package com.atguigu.userprofile.dao

import com.atguigu.userprofile.bean.TaskTagRule
import com.atguigu.userprofile.util.MySqlUtil


object TaskTagRuleDAO {

  def getTaskTagRuleListByTaskId(taskId:String): List[TaskTagRule] ={

    val taskRuleSql: String =
      s"""select tr.id,tr.tag_id,tr.task_id,tr.query_value,
         | sub_tag_id,ti.tag_name as sub_tag_value
         | from task_tag_rule tr,tag_info ti
         | where tr.sub_tag_id=ti.id and   tr.task_id=$taskId""".stripMargin
    val taskTagRuleList: List[TaskTagRule] =
      MySqlUtil.queryList(taskRuleSql, classOf[TaskTagRule], true)
    taskTagRuleList
  }
}
