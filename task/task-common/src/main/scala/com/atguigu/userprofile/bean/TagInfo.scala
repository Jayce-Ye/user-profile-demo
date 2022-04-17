package com.atguigu.userprofile.bean

import java.util.Date
import java.lang.Long
case class TagInfo(var id:Long,
                   var tagCode:String,
                   var tagName:String,
                   var tagLevel:Long,
                   var parentTagId:Long,
                   var tagType:String,
                   var tagValueType:String,
                   var  tagValueLimit:Long,
                   var  tagValueStep:Long,
                   var  tagTaskId:Long,
                   var  tagComment:String,
                   var  createTime:Date,
                   var  updateTime:Date
                  ) {
  def this()  ={
    this(null,null,null,null,null,null,null,null,null,null,null,null,null )
  }
}

