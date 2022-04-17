package com.atguigu.userprofile.app

import java.util.Properties

import com.atguigu.userprofile.bean.{TagInfo, TaskInfo, TaskTagRule}
import com.atguigu.userprofile.constant.ConstCode
import com.atguigu.userprofile.dao.{TagInfoDAO, TaskInfoDAO, TaskTagRuleDAO}
import com.atguigu.userprofile.util.{MyPropertiesUtil, MySqlUtil}
import org.apache.spark.SparkConf
import org.apache.spark.sql.SparkSession

object TaskTagSqlApp {


  //1、 根据TaskID 读取 任务的定义、规则、SQL    读取标签  名称
  //2、 每个标签都保存在对应的标志  一个标签对应一张表   根据定义 建立标签表（如果新标签）
  //3、 通过sql查询数据仓库中的数据 ，写入到标签表中
  //      insert overwrite  table xxx  select xxx
  //     根据定义规则进行拼接完成
  def main(args: Array[String]): Unit = {


     val sparkConf: SparkConf = new SparkConf().setAppName("task_tag_sql_app")
       //.setMaster("local[*]")
     val sparkSession: SparkSession = SparkSession.builder().config(sparkConf).enableHiveSupport().getOrCreate()


    //1、 根据TaskID 读取 任务的定义、规则、SQL    读取标签  名称
    // 1.1  taskId   //spark-submit结尾处 会带俩个参数  第一个参数是taskId  第二个参数是业务日期 ，一般是前一天的日期
    // spark-submit   --master ..xxxx.xx.     xxxxx.jar  1 2021-06-08
    val taskId: String = args(0)
    val taskDate: String = args(1)

   //  1.2  根据TaskID 读取tag_info
       val tagInfo: TagInfo = TagInfoDAO.getTagInfoByTaskId(taskId)
    // 1.3   根据TaskID    读取task_info
       val taskInfo: TaskInfo = TaskInfoDAO.getTaskInfo(taskId)
    //1.4  根据TaskID 读取task_tag_info
      val taskTagRuleList: List[TaskTagRule] = TaskTagRuleDAO.getTaskTagRuleListByTaskId(taskId)

    println(tagInfo)
    println(taskInfo)
    println(taskTagRuleList)


    //2、 每个标签都保存在对应的标志  一个标签对应一张表   根据定义 建立标签表（如果新标签,没有表）
    // hive :  create table   if not exists $tagCode ( uid string , tag_value $tag_value_type )
    // comment '${tagInfo.tagName}' PARTITIONED BY (`dt` STRING)
    //  ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\t'
    //  LOCATION    $hdfsPath/$userprofielDbName/$tagCode

    val tableName=tagInfo.tagCode.toLowerCase
    val tagValueType: String = tagInfo.tagValueType match {
      case ConstCode.TAG_VALUE_TYPE_STRING => "STRING"
      case ConstCode.TAG_VALUE_TYPE_LONG => "BIGINT"
      case ConstCode.TAG_VALUE_TYPE_DECIMAL => "DECIMAL(16,2)"
      case ConstCode.TAG_VALUE_TYPE_DATE => "STRING"
    }

    val properties: Properties = MyPropertiesUtil.load("config.properties")
    val hdfsPath: String = properties.getProperty("hdfs-store.path")
    val dwDbName: String = properties.getProperty("data-warehouse.dbname")
    val upDbName: String = properties.getProperty("user-profile.dbname")

    val createSQL=
      s"""
         |create table   if not exists ${tableName} ( uid string , tag_value $tagValueType )
         |     comment '${tagInfo.tagName}' PARTITIONED BY (`dt` STRING)
         |      ROW FORMAT DELIMITED FIELDS TERMINATED BY '\\t'
         |       LOCATION    '$hdfsPath/$upDbName/$tableName'
       """.stripMargin

    println(createSQL)

    //3、 通过sql查询数据仓库中的数据 ，写入到标签表中
    // insert  overwrite table $tagCode partition (dt='$taskDate')
    // select   uid,
    //  case  query_value
    //         when  'F' then '女'
    //         when 'M' then '男'
    //         when  'U' then '未知' end  as  tag_value
    //  from   ($sql)

     // 3.1  动态根据 tagRule 生成case when 语句
    // 3.2 针对sql 中的$dt要换成 业务日期
    val taskSql: String = taskInfo.taskSql.replace("$dt",taskDate)
    var caseWhenSql=""
    if(taskTagRuleList.size>0){
      val whenList: List[String] = taskTagRuleList.map(taskTagRule=>s"when  '${taskTagRule.queryValue}' then '${taskTagRule.subTagValue}'")
       caseWhenSql="case  query_value " +whenList.mkString(" ")+" end  as  tag_value"
    }else{
      //如果没有子标签匹配的话 把query_value 直接作为tag_value
      caseWhenSql="   query_value  as  tag_value"
    }

     val selectSql= s"select uid , $caseWhenSql  from (${taskSql} ) tv"

     val insertSelectSql=s"insert overwrite table   $upDbName.$tableName partition (dt='$taskDate')  $selectSql"

    println(insertSelectSql)


    sparkSession.sql("use "+upDbName)
    sparkSession.sql(createSQL)
    sparkSession.sql("use "+dwDbName)
    sparkSession.sql(insertSelectSql)



  }

}
