package com.atguigu.spark.submitter.bean;


import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TaskStatusInfo {

    Long taskProcessId;

    Long taskId;

    String yarnAppId;

    String taskExecStatus;
}
