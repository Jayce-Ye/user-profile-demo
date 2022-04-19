package com.atguigu.spark.submitter.service.impl;

import com.alibaba.fastjson.JSON;
import com.atguigu.spark.submitter.bean.SubmitEvent;
import com.atguigu.spark.submitter.bean.TaskStatusInfo;
import com.atguigu.spark.submitter.service.SubmitterService;

import com.atguigu.spark.submitter.util.HttpUtil;

import lombok.extern.slf4j.Slf4j;
import org.apache.spark.launcher.SparkAppHandle;
import org.apache.spark.launcher.SparkLauncher;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Map;

import static com.atguigu.spark.submitter.bean.TaskProcess.*;

@Slf4j
@Service
public class SubmitterServiceImpl implements SubmitterService {




    @Value("${callback.type}")
    String callBackType;

    @Value("${callback.http.url}")
    String callBackHttpUrl;



    public static final String CALLBACK_TYPE_HTTP="http";





    public void submitAppJar(SubmitEvent submitEvent) throws  Exception{
        log.info("spark任务传入参数：{}", submitEvent.toString());
       // CountDownLatch countDownLatch = new CountDownLatch(1);

        SparkLauncher launcher = new SparkLauncher()
                .setAppName(submitEvent.getAppName())
                .setAppResource(submitEvent.getJarFilePath())
                .setMainClass(submitEvent.getMainClass())
                .setMaster(submitEvent.getMaster())
                .setDeployMode(submitEvent.getDeployMode());
        if(submitEvent.getSparkArgs()!=null&&submitEvent.getSparkArgs().size()>0){
            for (Map.Entry<String,String> entry : submitEvent.getSparkArgs().entrySet() ) {



                launcher.addSparkArg(entry.getKey(),entry.getValue()) ;
            }
        }
        if(submitEvent.getSparkConf()!=null&&submitEvent.getSparkConf().size()>0){
            for (Map.Entry<String,String> entry : submitEvent.getSparkConf().entrySet() ) {
                launcher.setConf(entry.getKey(),entry.getValue()) ;
            }
        }
        launcher.addAppArgs( submitEvent.getAppArgs().toArray( new String[]{}) );


        log.info("参数设置完成，开始提交spark任务");
        SparkAppHandle handle = launcher.setVerbose(true).startApplication(new SparkAppHandle.Listener() {
            @Override
            public void stateChanged(SparkAppHandle sparkAppHandle) {
               if(callBackType.equals(CALLBACK_TYPE_HTTP)){
                    log.info("stateChanged2:{}", sparkAppHandle.getState().toString());
                    callbackStatus(  submitEvent,  sparkAppHandle);
                }
            }

            @Override
            public void infoChanged(SparkAppHandle sparkAppHandle) {
                log.info("infoChanged:{}", sparkAppHandle.getState().toString());
            }
        });


        log.info("The task is finished!");


        return ;
    }


    public void callbackStatus(SubmitEvent submitEvent,SparkAppHandle sparkAppHandle){
        TaskStatusInfo taskStatusInfo=new TaskStatusInfo(submitEvent.getTaskProcessId(), submitEvent.getTaskId(),sparkAppHandle.getAppId(),null);
        if (sparkAppHandle.getState().equals( SparkAppHandle.State.SUBMITTED )) {
            taskStatusInfo.setTaskExecStatus(STATUS_SUBMITTED);
        }else if(sparkAppHandle.getState().equals( SparkAppHandle.State.RUNNING )){
            taskStatusInfo.setTaskExecStatus(STATUS_RUNNING);
        }else if(sparkAppHandle.getState().equals( SparkAppHandle.State.FINISHED )){
            taskStatusInfo.setTaskExecStatus(STATUS_FINISHED);
        }else if(sparkAppHandle.getState().isFinal()){
            taskStatusInfo.setTaskExecStatus(STATUS_FAILED);
        }
        if(taskStatusInfo.getTaskExecStatus()!=null){
            String jsonString = JSON.toJSONString(taskStatusInfo);
            HttpUtil.post(callBackHttpUrl,jsonString);
        }

    }

//--driver-memory=1G
//--num-executors=3
//--executor-memory=2G
//--executor-cores=2
//--conf spark.default.parallelism=12

    private String convertKey(String  key){
            if(key.indexOf("driver-memory")>=0){
                return SparkLauncher.DRIVER_MEMORY;
            }else if(key.indexOf("executor-cores")>=0){
                return SparkLauncher.EXECUTOR_CORES;
            }else if(key.indexOf("executor-memory")>=0) {
                return SparkLauncher.EXECUTOR_MEMORY;
            }else if(key.indexOf("num-executors")>=0) {
                return "spark.num.executors";
            }
            return  null ;
    }
}
