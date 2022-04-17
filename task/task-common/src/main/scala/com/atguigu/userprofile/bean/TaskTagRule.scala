package com.atguigu.userprofile.bean

import java.lang.Long
case class TaskTagRule(var id:Long,
                       var tagId:Long,
                       var  taskId:Long,
                       var  queryValue:String,
                       var  subTagId:Long,
                       var   subTagValue:String
                      ) {
  def this()  ={
    this(null,null,null,null,null,null  )
  }

}
