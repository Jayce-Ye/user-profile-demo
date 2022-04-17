package com.atguigu.userprofile.util

import java.sql.{Connection, DriverManager, Statement}
import java.util.Properties

object ClickhouseUtil {

  private val properties: Properties = MyPropertiesUtil.load("config.properties")
  val CLICKHOUSE_URL = properties.getProperty("clickhouse.url")


  def executeSql(sql: String ): Unit ={
    Class.forName("ru.yandex.clickhouse.ClickHouseDriver");
    val connection: Connection = DriverManager.getConnection(CLICKHOUSE_URL, null, null)
    val  statement: Statement = connection.createStatement()
    statement.execute(sql)
    connection.close()

  }



}
