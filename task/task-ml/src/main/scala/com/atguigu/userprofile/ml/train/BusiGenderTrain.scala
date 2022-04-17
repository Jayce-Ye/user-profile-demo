package com.atguigu.userprofile.ml.train

import java.util.Properties

import com.atguigu.userprofile.util.MyPropertiesUtil
import org.apache.spark.SparkConf
import org.apache.spark.sql.{DataFrame, SparkSession}

object BusiGenderTrain {


  //1 训练阶段
  //
  //     1） 数据（特征+label ）
  //    特征哪来？
  //        选取
  //        抽取数据（数仓）
  //
  //    label哪来？
  //         咱们认为的部分用户真实性别
  //                  用户填写（营销手段）
  //                   买来的（）
  //          从用户基本信息表中提取
  //     2）构造pipeline  MyPipeline
  //     3)  进行训练
  //      4)  评估 优化（特征、算法、参数）
  //      5） 把模型存储  存储在hdfs
  def main(args: Array[String]): Unit = {
    //     1） 数据（特征+label ）
    //        抽取数据（数仓）
    val sparkConf: SparkConf = new SparkConf().setAppName("task_ml_busi_gender_train").setMaster("local[*]")
    val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()

    val taskDate: String = args(1)

    val genderQuerySql=
      s"""
         |with uid_visit as (
         |   select   user_id  as uid, category1_id ,during_time  from dwd_page_log pl
         |   join dim_sku_info si on  si.id=page_item
         |   where  page_id='good_detail' and page_item_type='sku_id'
         |    and pl.dt='$taskDate' and  si.dt='$taskDate'
         |),
         | uid_label as (
         |  select  id ,gender  from dim_user_info  where dt='9999-99-99' and  gender  is not null
         |)
         |select
         |uid_feature.uid,
         |male_dur,
         |female_dur,
         |c1_1,
         |c1_2,
         |c1_3,
         |uid_label.gender
         | from
         |(
         |  select
         |  uid  ,
         |  sum(if(category1_id in (3,4,6,16) ,dur_time,0)) male_dur,
         |  sum(if(category1_id in (8,12,15) ,dur_time,0)) female_dur,
         |  sum(if(rk=1,category1_id,0)) c1_1,
         |  sum(if(rk=2,category1_id,0)) c1_2,
         |  sum(if(rk=3,category1_id,0)) c1_3
         |from
         |(
         |select uid,category1_id,sum(during_time) dur_time,  count(*) ct ,
         |row_number()over(partition by uid order by count(*) desc ) rk
         |from uid_visit  uv
         |group by uid,category1_id
         |) uv_rk
         |where  rk<=3
         |group by uid
         |) uid_feature  join uid_label on uid_feature.uid=uid_label.id
       """.stripMargin
    println(genderQuerySql)
    println("提取特征和label数据...")
    sparkSession.sql("use gmall2021")
    val dataFrame: DataFrame = sparkSession.sql(genderQuerySql)
    println("切分数据 ...")
    val  Array(trainDf,testDf)= dataFrame.randomSplit(Array(0.8,0.2))
    //2）构造pipeline  MyPipeline

    println("构造pipeline  MyPipeline")
    val pipeline: MyPipeline = new MyPipeline().setLabelColname("gender")
      .setFeatureColName(Array("male_dur", "female_dur", "c1_1", "c1_2", "c1_3"))
      .setMaxCategories(20) //区分连续值特征和离散特征
      .setMaxDepth(7)
      .setMaxBins(32)
      .setMinInfoGain(0.03)
      .setMinInstancesPerNode(3)
      .init()

    //3）训练
    println("开始训练")
    pipeline.train(trainDf)


    // 4) 观察  决策树 、 特征的权重
    println("观察  决策树 、 特征的权重")
    println(pipeline.getDecisionTree())
    println(pipeline.getFeatureWeight())

    //5)预测测试集
    println("预测测试集 ")
    val predictedDataFrame: DataFrame = pipeline.predict(testDf)
    predictedDataFrame.show(100,false)
    //6 评估优化
    println("评估优化 ")
    pipeline.printEvaluate(predictedDataFrame)

    //7 存储模型
    val properties: Properties = MyPropertiesUtil.load("config.properties")
    val path: String = properties.getProperty("model.path")
    pipeline.saveModel(path)




  }

}
