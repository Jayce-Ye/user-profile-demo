package com.atguigu.webapp.demo.controller;

import com.atguigu.webapp.demo.bean.OrderInfo;
import com.atguigu.webapp.demo.service.OrderService;
import com.atguigu.webapp.demo.service.impl.OrderServiceImpl;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import jdk.nashorn.internal.ir.annotations.Reference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;



@RestController   //标识controller入口类   //1 接收请求 包括参数   2 返回结果
public class DemoController {


    @Autowired    //装配业务类
    OrderService orderService;


    @RequestMapping("/hello")  //标识访问路径
    public  String getHelloWorld(@RequestParam("name") String name ,@RequestParam("age") Integer age){  //装载参数
            return "hello world:"+name+","+age+" 岁";    //返回值
    }

    @RequestMapping("/order/{id}")  //标识访问路径
    public  String getOrder(@PathVariable("id") String id){  //装载参数
        return "order:"+id;    //返回值
    }

    @PostMapping(value = "/order") // post请求  一般用于用户提交写操作
    public String saveOrder(@RequestBody OrderInfo orderInfo){ //封装到结构化对象中  map 或者 bean
       // orderService.saveOrder(orderInfo);  //可以保存数据库

        orderService.save(orderInfo);

        return  "success";
    }

    @GetMapping("/orders")
    public List<OrderInfo> orderList(@RequestParam("gt") BigDecimal gtAmount){
        List<OrderInfo> orderInfoList = orderService.list(new QueryWrapper<OrderInfo>().gt("amount", gtAmount));
        return orderInfoList;
    }


}
