package com.atguigu.webapp.demo.service.impl;

import com.atguigu.webapp.demo.bean.OrderInfo;
import com.atguigu.webapp.demo.mapper.OrderMapper;
import com.atguigu.webapp.demo.service.OrderService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class OrderServiceImpl extends ServiceImpl< OrderMapper ,OrderInfo> implements OrderService  {

    @Autowired
    OrderMapper orderMapper;

    @Override
    public void saveOrder(Map orderMap) {
        System.out.println("处理订单业务:" + orderMap);
        orderMapper.insertOrder(orderMap);
        OrderInfo orderInfo = orderMapper.selectOrder((Integer) orderMap.get("id"));
        System.out.println("查询订单:" +orderInfo  );
        OrderInfo orderInfo2 = orderMapper.selectById((Integer) orderMap.get("id"));
        System.out.println("查询订单 plus:" +orderInfo2  );
    }
}
