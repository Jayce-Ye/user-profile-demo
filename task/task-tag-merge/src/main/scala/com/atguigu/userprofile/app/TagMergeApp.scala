package com.atguigu.userprofile.app

import java.util.Properties

import com.atguigu.userprofile.bean.TagInfo
import com.atguigu.userprofile.dao.TagInfoDAO
import com.atguigu.userprofile.util.MyPropertiesUtil
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession

object TagMergeApp {


  //      1  要组合哪些标签表？  show tables (不准确)
  //         最好 查询 tag_info  join  task_info
  //          获得启用状态的标签列表
  //      2  建立宽表
  //           表名     user_tag_merge_20210609  ......
  //           字段     uid ,  <tag_code1> ,<tag_code2>
  //         考虑到每天的标签数是不一样的，那么宽表的字段也不一样，所以不使用一张固定的表，而是每天建一张新表，每天的字段可以不同。
  //
  //      3  合并数据进宽表
  //            利用  pivot 进行行转列操作。
  def main(args: Array[String]): Unit = {


    val sparkConf: SparkConf = new SparkConf().setAppName("task_tag_merge_app")//.setMaster("local[*]")
    val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()


    val taskId: String = args(0)
    val taskDate: String = args(1)

    val properties: Properties = MyPropertiesUtil.load("config.properties")
    val hdfsPath: String = properties.getProperty("hdfs-store.path")
    val dwDbName: String = properties.getProperty("data-warehouse.dbname")
    val upDbName: String = properties.getProperty("user-profile.dbname")

    //1 ////////////     查询 tag_info  join  task_info//////////////
    //          获得启用状态的标签列表
    val tagInfoList: List[TagInfo] = TagInfoDAO.getTagInfoListOnTask()

    // 2 /////////////// 建立宽表///////////////////////////
    //表名     user_tag_merge_$taskDate  ......
    val tableName=s"user_tag_merge_${taskDate.replace("-","")}"
    //  create table tablename  ( uid String , tg_person_base_gender string, tg_person_base_agegroup string  .....  )
    val  tagColNames =   tagInfoList.map(_.tagCode.toLowerCase+" string ").mkString(",")


    val dropTableSql=s" drop table if exists $tableName"

    val createTableSql=
      s"""  create table  $tableName ( uid string ,$tagColNames )
         |     comment '标签宽表'
         |      ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\t'
         |       LOCATION    '$hdfsPath/$upDbName/$tableName'
       """.stripMargin

    println(createTableSql)

    // /////////////     3  合并数据进宽表/////////////////////////////////
    //            利用  pivot 进行行转列操作。
    //
    //   select * from   (
    //        select uid ,tag_code,tag_value from tg_person_base_gender
   //         union all
    //        select uid ,tag_code,tag_value from tg_person_base_agegroup
       //     union all
      //      ....
    //    )
    //pivot ( concat_ws(',' ,collect_set(tag_value)) as tv
    //for  tag_code in( 'tg_person_base_gender','tg_person_base_agegroup','tg_person_base_last30ct',......))

    val unionSql= tagInfoList.map(tagInfo=>{
      s"select uid ,'${tagInfo.tagCode.toLowerCase}' as  tag_code,tag_value from ${tagInfo.tagCode.toLowerCase} "
    })  .mkString(" union all ")
    val inSql: String = tagInfoList.map("'"+_.tagCode.toLowerCase+"'").mkString(",")

    val selectSql=
      s""" select * from   (  $unionSql )
         |    pivot ( concat_ws(',' ,collect_set(tag_value)) as tv
         |     for  tag_code in( $inSql))
         |
       """.stripMargin

    val insertSql=s"insert overwrite table $tableName  $selectSql"
    println(insertSql)

    sparkSession.sql(s"use $upDbName")
    sparkSession.sql(dropTableSql)
    sparkSession.sql(createTableSql)
    sparkSession.sql(insertSql)




  }

}
