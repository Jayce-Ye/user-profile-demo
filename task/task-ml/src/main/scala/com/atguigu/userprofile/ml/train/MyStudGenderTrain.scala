package com.atguigu.userprofile.ml.train

import org.apache.spark.SparkConf
import org.apache.spark.sql.{DataFrame, SparkSession}

object MyStudGenderTrain {


  def main(args: Array[String]): Unit = {
    val sparkConf: SparkConf = new SparkConf().setAppName("my_stud_gender_train_app").setMaster("local[*]")
    val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()

    //1 获得数据
    //从表中查询出数据
    println("从表中查询出数据")
    val genderSql=
      s"""
         |select uid,case hair when '长发' then 101
         |                     when '短发' then 102
         |                     when '板寸' then 103 end  as  hair,
         |           height,
         |          case skirt  when '是' then 21
         |                      when '否' then 22 end  as skirt,
         |           case age  when  '80后' then 80
         |                     when  '90后' then 90
         |                     when  '00后' then 100 end  age ,
         |                     gender
         |   from user_profile0111.student ;
         |""".stripMargin

    val dataFrame: DataFrame = sparkSession.sql(genderSql)

    //2 把数据分成2部分  1 训练集 2 测试集
    println("把数据分成2部分")
     val  Array(trainDF,testDF)= dataFrame.randomSplit(Array(0.8,0.2))

    //3 构造流水线
    println("构造流水线分")
      val myPipeline = new MyPipeline().setLabelColname("gender").setFeatureColName(Array("hair","height","skirt","age"))
        .setMaxDepth(4)
        .setMinInfoGain(0.05)
        .setMinInstancesPerNode(5)
        .setMaxBins(10)
        .init()

    //4 用流水线对数据进行训练
    println("用流水线对数据进行训练")
    myPipeline.train(trainDF)
   //4.1 打印决策树
    println("打印决策树")
    println(myPipeline.getDecisionTree())
    //4.2 打印特征权重
    println("打印特征权重")
    println(myPipeline.getFeatureWeight())

    //5 用模型对测试集进行预测
    println("用模型对测试集进行预测")
    val predictedDataFrame: DataFrame = myPipeline.predict(testDF)
    println("打印预测结果")
    predictedDataFrame.show(1000,false)

    //6 用评估器对结果进行分析
    println("打印评估结果")
    myPipeline.printEvaluate(predictedDataFrame)




  }

}
