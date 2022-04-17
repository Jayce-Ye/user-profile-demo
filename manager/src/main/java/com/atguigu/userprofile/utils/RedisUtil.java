package com.atguigu.userprofile.utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

@Configuration
public class RedisUtil {


    public static   String  host;
    public static   Integer  port;

    @Value("${spring.redis.host}")
    public void setHost(String host){
        RedisUtil.host=host;
    }
    @Value("${spring.redis.port}")
    public void setPort(Integer port){
        RedisUtil.port=port;
    }

    public static void main(String[] args) {
        Jedis jedis =  RedisUtil.getJedis();


        jedis.set("k10000","v10000");

        String value = jedis.get("k10000");
        System.out.println(value);
        System.out.println(jedis.keys("*"));

        jedis.close();

    }


    static JedisPool jedisPool=null;


    public static Jedis  getJedis(){
        if(jedisPool==null){
            JedisPoolConfig jedisPoolConfig = new JedisPoolConfig();
            jedisPoolConfig.setMaxTotal(100);
            jedisPoolConfig.setMinIdle(20);
            jedisPoolConfig.setMaxIdle(40);
            jedisPoolConfig.setBlockWhenExhausted(true);
            jedisPoolConfig.setMaxWaitMillis(1000);
            jedisPoolConfig.setTestOnBorrow(true);

            jedisPool=new JedisPool(jedisPoolConfig,host,port);
            return jedisPool.getResource();
        }else{
            return jedisPool.getResource();
        }

    }


}
