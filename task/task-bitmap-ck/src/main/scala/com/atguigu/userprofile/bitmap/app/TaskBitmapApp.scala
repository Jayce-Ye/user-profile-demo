package com.atguigu.userprofile.bitmap.app

import com.atguigu.userprofile.bean.TagInfo
import com.atguigu.userprofile.constant.ConstCode
import com.atguigu.userprofile.dao.TagInfoDAO
import com.atguigu.userprofile.util.ClickhouseUtil
import org.apache.spark.{SparkConf, SparkContext}

import scala.collection.mutable.ListBuffer

object TaskBitmapApp {

  def main(args: Array[String]): Unit = {

    val sparkConf: SparkConf = new SparkConf().setAppName("task_bitmap_app")
      .setMaster("local[*]")

    val sparkContext = new SparkContext(sparkConf)

    val taskDate: String = args(1)

    // 1  查询标签的定义，tag_info mysql
    val tagInfoList: List[TagInfo] = TagInfoDAO.getTagInfoListOnTask()


    // 2 根据 不同的标签值类型 存放在不同的列表中
    val tagInfoStringlist: ListBuffer[TagInfo]=new ListBuffer[TagInfo]();
    val tagInfoLonglist: ListBuffer[TagInfo]=new ListBuffer[TagInfo]();
    val tagInfoDecimallist: ListBuffer[TagInfo]=new ListBuffer[TagInfo]();
    val tagInfoDatelist: ListBuffer[TagInfo]=new ListBuffer[TagInfo]();

    for (tagInfo <- tagInfoList ) {

      tagInfo.tagValueType match {
        case ConstCode.TAG_VALUE_TYPE_STRING => tagInfoStringlist.append(tagInfo)
        case ConstCode.TAG_VALUE_TYPE_DECIMAL => tagInfoDecimallist.append(tagInfo)
        case ConstCode.TAG_VALUE_TYPE_LONG => tagInfoLonglist.append(tagInfo)
        case ConstCode.TAG_VALUE_TYPE_DATE => tagInfoDatelist.append(tagInfo)
      }
    }
    // 2.9  把四个表全部清理
    //    alter table $tableName delete  where dt='$taskDate'  ;
    //


    // 3  把四个标签列表对应的标签数据 存储到4张bitmap表中
    insertSQLbyTagType("user_tag_value_string",tagInfoStringlist,taskDate)
    insertSQLbyTagType("user_tag_value_long",tagInfoLonglist,taskDate)
    insertSQLbyTagType("user_tag_value_decimal",tagInfoDecimallist,taskDate)
    insertSQLbyTagType("user_tag_value_date",tagInfoDatelist,taskDate)



  }


  // INSERT INTO user_tag_value_string SELECT
  //    tag.1 AS tag_code,
  //    tag.2 AS tag_value,
  //    groupBitmapState(uid) AS us
  //FROM
  //(
  //    SELECT
  //        uid,
  //        arrayJoin([('agegroup', agegroup), ('gender', gender), ('favor', favor)]) AS tag
  //    FROM user_tag_merge
  //) AS ut
  //GROUP BY
  //    tag.1,
  //    tag.2
  def   insertSQLbyTagType( tableName:String, tagList: ListBuffer[TagInfo] ,taskDate:String): Unit ={
    //  把各个表全部清理
    //    alter table $tableName delete  where dt='$taskDate'  ;
    val dropTableSql=s" alter table $tableName delete  where dt='$taskDate'"
    println(dropTableSql)
    ClickhouseUtil.executeSql(dropTableSql)


    if(tagList.size>0){
    val  tagCodeSql=tagList.map(tagInfo=> s"('${tagInfo.tagCode.toLowerCase}',${tagInfo.tagCode.toLowerCase})"  ).mkString(",")
    val insertSQL=
      s"""
         |    INSERT INTO $tableName SELECT
         |      tag.1 AS tag_code,
         |      tag.2 AS tag_value,
         |      groupBitmapState(cast( uid as UInt64)) AS us,
         |      '$taskDate'
         |   FROM
         |   (
         |      SELECT
         |           uid,
         |          arrayJoin([ $tagCodeSql]) AS tag
         |      FROM user_tag_merge_${taskDate.replace("-","")}
         |   ) AS ut
         |   where tag.2 <>''
         |  GROUP BY  tag.1,  tag.2
       """.stripMargin

      println(insertSQL)

      ClickhouseUtil.executeSql(insertSQL)

    }


  }






}
