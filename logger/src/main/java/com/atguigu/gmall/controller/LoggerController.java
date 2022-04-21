package com.atguigu.gmall.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Author: Felix
 * Date: 2021/7/28
 * Desc: 日志数据采集
 */
@RestController
@Slf4j
public class LoggerController {
    //private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(LoggerController.class);
    @Autowired
    private KafkaTemplate kafkaTemplate;

    @RequestMapping("/applog")
    public String log(@RequestParam("param") String logStr){
        //1.打印输出到控制台
        //System.out.println(logStr);
        //2.落盘---利用logback
        log.info(logStr);
        //3.发送到kafka主题
        kafkaTemplate.send("ods_base_log",logStr);
        return "success";
    }
}
