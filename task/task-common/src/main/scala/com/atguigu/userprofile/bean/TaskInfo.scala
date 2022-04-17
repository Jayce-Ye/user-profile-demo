package com.atguigu.userprofile.bean

import java.util.Date
import java.lang.Long
case class TaskInfo  (var id: Long = null ,
                      var taskName:String=null,
                      var taskStatus:String=null,
                      var taskComment:String=null,
                      var taskTime:String=null,
                      var taskType:String=null,
                      var execType:String=null,
                      var mainClass:String=null,
                      var fileId:Long= null,
                      var taskArgs:String=null,
                      var taskSql:String=null,
                      var taskExecLevel:Long =null,
                      var createTime:Date=null)  {

  //补充无参构造函数
  def this()  ={
    this(0L,null,null,null,null,null,null,null,-1L,null,null,null,null)
  }
}

