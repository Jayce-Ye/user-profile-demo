package com.atguigu.userprofile.util

import java.lang.reflect.Field
import java.sql.{Connection, DriverManager, PreparedStatement, ResultSet, ResultSetMetaData, Statement}
import java.util.Properties

import com.alibaba.fastjson.JSONObject
import com.google.common.base.CaseFormat

import scala.collection.mutable.ListBuffer

object MySqlUtil {

  def main(args: Array[String]): Unit = {
    val list: java.util.List[JSONObject] = queryList("select * from base_province")
    println(list)
  }

  private val properties: Properties = MyPropertiesUtil.load("config.properties")


  val MYSQL_URL = properties.getProperty("mysql.url")
  val MYSQL_USERNAME = properties.getProperty("mysql.username")
  val MYSQL_PASSWORD = properties.getProperty("mysql.password")

  //查询列表
  def queryList(sql: String): java.util.List[JSONObject] = {
    Class.forName("com.mysql.jdbc.Driver")
    //创建结果列表
    val resultList: java.util.List[JSONObject] = new java.util.ArrayList[JSONObject]()
    //创建连接
    val conn: Connection = DriverManager.getConnection(MYSQL_URL, MYSQL_USERNAME, MYSQL_PASSWORD)
    //创建会话
    val stat: Statement = conn.createStatement
    println(sql)
    //提交sql 返回结果
    val rs: ResultSet = stat.executeQuery(sql)
    //为了获得列名 要取得元数据
    val md: ResultSetMetaData = rs.getMetaData
    while (rs.next) {
      val rowData = new JSONObject();
      for (i <- 1 to md.getColumnCount) {
        // 根据下标得到对应元数据中的字段名，以及结果中值
        rowData.put(md.getColumnName(i), rs.getObject(i))
      }
      resultList.add(rowData)
    }

    stat.close()
    conn.close()
    resultList
  }

 // 查询列表
  def queryList[T<:AnyRef](sql: String, clazz: Class[T], underScoreToCamel: Boolean):List[T]={

    Class.forName("com.mysql.jdbc.Driver");
    val resultList: ListBuffer[T] = new ListBuffer[T]();
    val connection: Connection = DriverManager.getConnection(MYSQL_URL, MYSQL_USERNAME, MYSQL_PASSWORD)
    val stat: Statement = connection.createStatement();
    val rs: ResultSet = stat.executeQuery(sql);
    val md: ResultSetMetaData = rs.getMetaData();
    while (rs.next()) {
      val obj: T = clazz.newInstance()
      for (i <- 1 to md.getColumnCount) {
        var propertyName: String = md.getColumnLabel(i)

        if (underScoreToCamel) {
          propertyName = CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, md.getColumnLabel(i))
        }
        MyBeanUtils.setV(obj,propertyName,rs.getObject(i))

      }
      resultList.append(obj);
    }
    stat.close()
    connection.close()
    resultList.toList

  }

  def queryOne[T<:AnyRef](sql: String, clazz: Class[T] ,
                          underScoreToCamel: Boolean): Option[T ] ={
    println(sql)
    Class.forName("com.mysql.jdbc.Driver");
    val resultList: ListBuffer[T] = new ListBuffer[T]();
    val connection: Connection =
      DriverManager.getConnection(MYSQL_URL, MYSQL_USERNAME, MYSQL_PASSWORD)
    val stat: Statement = connection.createStatement();
    val rs: ResultSet = stat.executeQuery(sql);
    val md: ResultSetMetaData = rs.getMetaData();
    while (rs.next()) {
      val obj: T = clazz.newInstance()


      for (i <- 1 to md.getColumnCount) {
        var propertyName: String = md.getColumnName(i)
        if (underScoreToCamel) {
          propertyName =
            CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, md.getColumnName(i))
        }
        MyBeanUtils.setV(obj,propertyName,rs.getObject(i))
      }
      resultList.append(obj);
    }
    stat.close()
    connection.close()
    if(resultList!=null){
      Some(resultList(0))
    }else{
      None
    }

  }

  def insertOne[T](sql: String, obj:T ): Unit ={
    Class.forName("com.mysql.jdbc.Driver");
    val resultList: ListBuffer[T] = new ListBuffer[T]();
    val connection: Connection =
      DriverManager.getConnection(MYSQL_URL, MYSQL_USERNAME, MYSQL_PASSWORD)
    val pstat: PreparedStatement = connection.prepareStatement(sql)
    val fields: Array[Field] = obj.getClass.getDeclaredFields

    for(i<- 1 to fields.size){
      val field:Field = fields(i-1);
      field.setAccessible(true)
      val value: AnyRef = field.get(obj)
      pstat.setObject(i,value)
    }
    val resInsert = pstat.execute()
    println("插入数据，返回值=>" + resInsert)

  }

}

