package com.atguigu.userprofile.util

import java.lang.reflect.{Field, Modifier}
import java.text.SimpleDateFormat
import java.util.Locale
import scala.util.control.Breaks._

object MyBeanUtils {


  /**
    * 对象相同属性copy
    *
    * @param obj
    * @param toResult
    * @return
    * @throws Exception
    * 转换报错
    */
  def copyProperties(obj: Object, toResult: Object): Unit = {
    if (obj == null) {
      return
    }
    try {
      val fields = toResult.getClass.getDeclaredFields
      for (field <- fields) {
        breakable {
          field.setAccessible(true) //修改访问权限
          if (Modifier.isFinal(field.getModifiers()))
            break
          if (isWrapType(field)) {
            val getMethodName = field.getName()
            val setMethodName = field.getName()+"_$eq"
            val getMethod = {
              try {
                obj.getClass().getMethod(getMethodName)
              } catch {
                case ex: Exception =>
                  //  println(ex)
                  break
              }
            }

            //从源对象获取get方法
            val setMethod =
              toResult.getClass.getMethod(setMethodName, field.getType)
            //从目标对象获取set方法
            val value = {
              val objValue = getMethod.invoke(obj) // get 获取的是源对象的值
              if (objValue != null && objValue.isInstanceOf[java.util.Date]) {
                // GMT时间转时间戳
                val format =
                  new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH)
                val formatValue = format.format(objValue)
                java.lang.Long.valueOf(format.parse(formatValue).getTime)
              } else
                objValue
            }
            setMethod.invoke(toResult, value)
          }
        }
      }
    } catch {
      case ex: Exception => throw ex
    }
  }

  /**
    * 是否是基本类型、包装类型、String类型
    */
  def isWrapType(field: Field): Boolean = {
    val typeList = List[String]("java.lang.Integer"
      , "java.lang.Double", "java.lang.Float", "java.lang.Long", "java.util.Optional"
      , "java.lang.Short", "java.lang.Byte", "java.lang.Boolean", "java.lang.Char"
      , "java.lang.String", "int", "double", "long"
      , "short", "byte", "boolean", "char", "float")
    if (typeList.contains(field.getType().getName())) true else false
  }


  def getV(ref:AnyRef, name: String): Any = ref.getClass.getMethods.find(_.getName == name).get.invoke(ref)

  def setV(ref:AnyRef,name: String, value: Any): Unit = {
    ref.getClass.getMethods.find(_.getName == name + "_$eq").get.invoke(ref, value.asInstanceOf[AnyRef])
  }

}


