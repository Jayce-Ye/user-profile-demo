package com.atguigu.spark.submitter.controller;


import com.atguigu.spark.submitter.bean.SubmitEvent;
import com.atguigu.spark.submitter.service.SubmitterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SubmitterController {


    @Autowired
   SubmitterService submitterService;

    @PostMapping("/spark-submit")
    public String submit(@RequestBody SubmitEvent submitEvent) throws  Exception{
        submitterService.submitAppJar(submitEvent);
        return "submit success";
    }


}
