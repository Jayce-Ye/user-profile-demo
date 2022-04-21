package com.atguigu.gmall.realtime.utils;

import org.apache.flink.api.common.serialization.SimpleStringSchema;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;

import java.util.Properties;

/**
 * Author: Felix
 * Date: 2021/7/30
 * Desc: 操作kafka的工具类
 */
public class MyKafkaUtil {
    private static final String KAFKA_SERVER = "hadoop202:9092,hadoop203:9092,hadoop204:9092";

    //获取kafka的消费者
    public static FlinkKafkaConsumer<String> getKafkaSource(String topic,String groupId){
        Properties props = new Properties();
        props.setProperty(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG,KAFKA_SERVER);
        props.setProperty(ConsumerConfig.GROUP_ID_CONFIG,groupId);
        return new FlinkKafkaConsumer<String>(topic,new SimpleStringSchema(),props);
    }
}
