package com.atguigu.userprofile.ml.app

import java.util.Properties

import com.atguigu.userprofile.ml.train.MyPipeline
import com.atguigu.userprofile.util.MyPropertiesUtil
import org.apache.spark.SparkConf
import org.apache.spark.sql.{DataFrame, SparkSession}

object BusiGenderApp {

//    1  准备数据
//          与训练数据特征采集方式一致
//          但是没有label
//    2   加载模型 从hdfs中读取
//    3   预测结果
//    4   预测结果的转换 （矢量转文本值）
//    5   形成用户画像中的标签
//    6  保存到标签表中
  def main(args: Array[String]): Unit = {
  //    1  准备数据
  //          与训练数据特征采集方式一致
  //          但是没有label

  val sparkConf: SparkConf = new SparkConf().setAppName("task_ml_busi_gender_app")//.setMaster("local[*]")
  val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()

  val taskDate: String = args(1)
   //只取未填写性别的用户
  val genderQuerySql=
    s"""
       |with uid_visit as (
       |   select   user_id  as uid, category1_id ,during_time  from dwd_page_log pl
       |   join dim_sku_info si on  si.id=page_item
       |   where  page_id='good_detail' and page_item_type='sku_id'
       |    and pl.dt='$taskDate' and  si.dt='$taskDate'
       |),
       | uid_label as (
       |  select  id ,gender  from dim_user_info  where dt='9999-99-99' and  gender is null
       |)
       |select
       |uid_feature.uid,
       |male_dur,
       |female_dur,
       |c1_1,
       |c1_2,
       |c1_3
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

  //    2   加载模型 从hdfs中读取
  println("加载模型 从hdfs中读取")
  val properties: Properties = MyPropertiesUtil.load("config.properties")
  val path: String = properties.getProperty("model.path")
  val myPipeline: MyPipeline = new MyPipeline().loadModel(path )
  //    3   预测结果
  println("预测结果")
  val predictedDataFrame: DataFrame = myPipeline.predict(dataFrame)
  predictedDataFrame.show(100,false)
    //   4 把预测的矢量转换为原值
    val predictedWithOriDF: DataFrame = myPipeline.convertLabelToOrigin(predictedDataFrame)
    predictedWithOriDF.show(100,false)

  //5  写入标签表
  saveTag(  sparkSession ,predictedWithOriDF ,taskDate  )

  }


  def  saveTag(  sparkSession: SparkSession,predictedWithOriDF:DataFrame,taskDate :String): Unit ={
  //  1  定义标签表 （一个标签一个表）
    println(" 定义标签表 ")
    val properties: Properties = MyPropertiesUtil.load("config.properties")
    val hdfsPath: String = properties.getProperty("hdfs-store.path")
    val dwDbName: String = properties.getProperty("data-warehouse.dbname")
    val upDbName: String = properties.getProperty("user-profile.dbname")

    val tableName="tg_busi_predict_busigender"

    val createSQL=
      s"""
         |create table   if not exists ${tableName} ( uid string , tag_value String )
         |     comment '预测性别' PARTITIONED BY (`dt` STRING)
         |      ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\t'
         |       LOCATION    '$hdfsPath/$upDbName/$tableName'
       """.stripMargin

    println(createSQL)
    sparkSession.sql("use "+upDbName)
    sparkSession.sql(createSQL)


  //  2  把结果插入该表
    println("把结果插入该表")
    predictedWithOriDF.createTempView("predicted_table")
    //如果没有预测结果，用维度表中的性别补充
    val insertSQL=
      s"""
         |insert overwrite table $tableName   partition (dt='$taskDate')
         |   select uid ,
         |  case prediction_origin  when 'M' then  '男性'
         |                          when 'F' then '女性' end tag_value
         |      from predicted_table
         | union all
         |      select id, if(gender='M','男性','女性' )
         |         from $dwDbName.dim_user_info  ui
         |         where dt='9999-99-99'
         |         and (select count(1) as num from predicted_table  pr where  pr.uid=ui.id)=0
       """.stripMargin
    println(insertSQL)

    sparkSession.sql(insertSQL)






  }

}
