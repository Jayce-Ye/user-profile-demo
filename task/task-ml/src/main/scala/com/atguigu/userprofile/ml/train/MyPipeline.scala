package com.atguigu.userprofile.ml.train

import org.apache.spark.ml.{Pipeline, PipelineModel, Transformer, linalg}
import org.apache.spark.ml.classification.{DecisionTreeClassificationModel, DecisionTreeClassifier}
import org.apache.spark.ml.feature.{IndexToString, StringIndexer, StringIndexerModel, VectorAssembler, VectorIndexer}
import org.apache.spark.mllib.evaluation.MulticlassMetrics
import org.apache.spark.rdd.RDD
import org.apache.spark.sql.DataFrame

class MyPipeline {



  //流水线类
  var pipeline:Pipeline= null

  //流水线模型
  var pipelineModel:PipelineModel=null

  def init(): MyPipeline ={
    pipeline= new  Pipeline().setStages( Array(
      createLabelIndexer(),
      createFeatureAssembler(),
      createFeatureIndexer(),
      createClassfier()
    ))
    this
  }


  private var labelColname:String=null;
  private var featureColNames:Array[String]=null;

  //// 以下为参数 ////////////////////
  //最大分类树（用于识别连续值特征和分类特征）
  private var maxCategories=5
  // 最大分支数
  private var maxBins=32
  // 最大树深度
  private var maxDepth=5
  //最小分支包含数据条数
  private var minInstancesPerNode=1
  //最小分支信息增益
  private var minInfoGain=0.0

  def setMaxCategories(maxCategories:Int): MyPipeline ={
    this.maxCategories=maxCategories
    this
  }
  def setMaxBins(maxBins:Int): MyPipeline ={
    this.maxBins=maxBins
    this
  }
  def setMaxDepth(maxDepth:Int): MyPipeline ={
    this.maxDepth=maxDepth
    this
  }

  def setMinInstancesPerNode(minInstancesPerNode:Int): MyPipeline ={
    this.minInstancesPerNode=minInstancesPerNode
    this
  }

  def setMinInfoGain(minInfoGain:Double): MyPipeline ={
    this.minInfoGain=minInfoGain
    this
  }



  def setLabelColname(labelColname:String):MyPipeline={
      this.labelColname=labelColname
     this
  }

  def setFeatureColName(featureColNames:Array[String]):MyPipeline={
    this.featureColNames=featureColNames
    this
  }

  // 1声明数据的label列 ，作为参考答案 ,对label列进行矢量化处理 如 0,1,2
   def  createLabelIndexer():StringIndexer   ={
           val stringIndexer = new StringIndexer()
           stringIndexer.setInputCol(labelColname).setOutputCol("label_index")
          stringIndexer
   }

  // 2声明样本数据中的特征列,聚合为一个特征列
   def createFeatureAssembler(): VectorAssembler ={
          val vectorAssembler = new VectorAssembler()
          vectorAssembler.setInputCols(featureColNames).setOutputCol("feature_assemble")
         vectorAssembler
   }

  // 3把特征进行向量化处理 ，
  // 根据MaxCategorie来区分离散特征和连续值特征，
  // 特征值类型大于MaxCategories 视为连续值特征 ，不会进行向量处理
  def createFeatureIndexer(): VectorIndexer ={
      val vectorIndexer = new VectorIndexer()
     vectorIndexer.setInputCol("feature_assemble")
       .setOutputCol("feature_index").setMaxCategories(maxCategories)
       .setHandleInvalid("skip")
    vectorIndexer
  }

  // 4 定义分类器，把label和feature列作为输入，
  def createClassfier(): DecisionTreeClassifier ={
        val decisionTreeClassifier = new DecisionTreeClassifier()
    decisionTreeClassifier.setLabelCol("label_index")
        .setFeaturesCol("feature_index")
        .setPredictionCol("prediction_col")
        .setImpurity("gini")
        .setMaxDepth(maxDepth)
      .setMaxBins(maxBins)
      .setMinInstancesPerNode(minInstancesPerNode)
      .setMinInfoGain(minInfoGain)
    decisionTreeClassifier
  }

  //训练
  def train(dataFrame:DataFrame): Unit ={
      pipelineModel  = pipeline.fit(dataFrame)
  }
  //预测
  def predict(dataFrame:DataFrame): DataFrame ={
    val predictedFrame: DataFrame = pipelineModel.transform(dataFrame)
    predictedFrame
  }


  // 读取决策树
  def getDecisionTree(): String ={
      val transformer: Transformer = pipelineModel.stages(3)
      val decisionTreeClassificationModel: DecisionTreeClassificationModel = transformer.asInstanceOf[DecisionTreeClassificationModel]
      decisionTreeClassificationModel.toDebugString
  }

  // 获得各个特征的权重:   各个特征在构建决策树是起到的重要性
  def getFeatureWeight(): linalg.Vector  ={
    val transformer: Transformer = pipelineModel.stages(3)
    val decisionTreeClassificationModel: DecisionTreeClassificationModel = transformer.asInstanceOf[DecisionTreeClassificationModel]
     decisionTreeClassificationModel.featureImportances
  }

  // 获得评估报告
  def  printEvaluate(predcitedDataFrame: DataFrame): Unit ={
    val predictionLabelRDD: RDD[(Double, Double)] = predcitedDataFrame.rdd.map {
      row =>
      (row.getAs[Double]("prediction_col"),
        row.getAs[Double]("label_index"))
    }

    val metrics = new MulticlassMetrics(predictionLabelRDD)
    println(metrics.accuracy)
    metrics.labels.foreach { label =>
      println("label:" + label + "召回率：" + metrics.recall(label))
      println("label:" + label + "精确率：" + metrics.precision(label))
    }


  }


  // 把模型存储到指定的位置
  def  saveModel(path:String): Unit ={
      pipelineModel.write.overwrite().save(path)
  }

  // 加载模型
  def loadModel(path:String): MyPipeline ={
        pipelineModel  = PipelineModel.load(path)
        this
  }


  def convertLabelToOrigin(dataFrame: DataFrame): DataFrame ={
         //提取流水线中的label矢量处理模型  // 解铃还须系铃人
        val transformer: Transformer = pipelineModel.stages(0)
        val stringIndexerModel: StringIndexerModel = transformer.asInstanceOf[StringIndexerModel]
         //声明转换工具
         val indexToString = new IndexToString()
         val convertor: IndexToString = indexToString.setLabels(stringIndexerModel.labels).setInputCol("prediction_col")
           .setOutputCol("prediction_origin")
         val convertedDataFrame: DataFrame = convertor.transform(dataFrame)
          convertedDataFrame

  }




}
