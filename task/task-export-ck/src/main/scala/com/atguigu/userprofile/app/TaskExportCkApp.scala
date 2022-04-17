package com.atguigu.userprofile.app

import java.util.Properties

import com.atguigu.userprofile.bean.TagInfo
import com.atguigu.userprofile.dao.TagInfoDAO
import com.atguigu.userprofile.util.{ClickhouseUtil, MyPropertiesUtil}
import org.apache.spark.SparkConf
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}

object TaskExportCkApp {


  //1   建表 每天建一个
  //
  //
  //插入数据  因为是异构的数据库  不能使用insert xxx select 完成
  //2   读取要插入的数据
  //
  //3   写入到clickhouse
  //      spark 通过jdbc写入到 某个数据中
  def main(args: Array[String]): Unit = {

    //1   在ck中 建表  每天建一个
    //    表名  字段名   标签定义列表   查hive宽表的定义
    //  create table  tableName  ( uid UInt64, 标签 String,xxxx ... )
    //  engine = MergeTree
    //  分区可以不用  因为表是每天的
    //   primary key  uid
    //   order by  uid

    val sparkConf: SparkConf = new SparkConf().setAppName("task_export_clickhouse_app")//.setMaster("local[*]")
    val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()


    //表名   user_tag_merge_日期
    val taskId: String = args(0)
    val taskDate: String = args(1)

    val tableName=s"user_tag_merge_${taskDate.replace("-","")}"

    //获得字段的列表
    val tagInfoList: List[TagInfo] = TagInfoDAO.getTagInfoListOnTask()
    val  tagColNames =   tagInfoList.map(_.tagCode.toLowerCase+" String ").mkString(",")

    val dropTableSql=s" drop table if exists $tableName";

    val createTableSQL=
      s"""
         |    create table  $tableName  ( uid UInt64, ${tagColNames} )
         |     engine = MergeTree
         |     primary key  uid
         |     order by  uid
       """.stripMargin

    println(createTableSQL)

    ClickhouseUtil.executeSql(dropTableSql)
    ClickhouseUtil.executeSql(createTableSQL)

    //2   读取要插入的数据
    //  hive  表 $tableName
    val properties: Properties = MyPropertiesUtil.load("config.properties")
    val  userprofileDbName = properties.getProperty("user-profile.dbname")
    val dataFrame: DataFrame = sparkSession.sql(s"select * from $userprofileDbName.$tableName")

    //3   把数据写入clickhouse  jdbc

    val CLICKHOUSE_URL = properties.getProperty("clickhouse.url")

    dataFrame.write.mode(SaveMode.Append)
      .option("batchsize", "100")
      .option("isolationLevel", "NONE") // 关闭事务
      .option("numPartitions", "4") // 设置并发
      .option("driver","ru.yandex.clickhouse.ClickHouseDriver")
      .jdbc(CLICKHOUSE_URL,tableName,new Properties())

  }

}
