package com.atguigu.spark.submitter.service;

import com.atguigu.spark.submitter.bean.SubmitEvent;

public interface SubmitterService {

    public void submitAppJar(SubmitEvent submitEvent)  throws  Exception;
}
