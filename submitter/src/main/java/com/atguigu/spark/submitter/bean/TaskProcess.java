package com.atguigu.spark.submitter.bean;



import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 *
 * </p>
 *
 * @author zhangchen
 * @since 2021-04-28
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class TaskProcess implements Serializable {

   public static final String STATUS_TODO="TODO";
   public static final String STATUS_START="START";
   public static final String STATUS_SUBMITTED ="SUBMITTED";
   public static final String STATUS_RUNNING="RUNNING";
   public static final String STATUS_FINISHED="FINISHED";
   public static final String STATUS_FAILED="FAILED";

    private static final long serialVersionUID = 1L;


    private Long id;

    private Long taskId;


    private String taskName;


    private String taskExecTime;


    private String taskBusiDate;


    private String taskExecStatus;


    private Long taskExecLevel;


    private String yarnAppId;

    private Date createTime;


    private Date startTime;


    private Date endTime;


}
