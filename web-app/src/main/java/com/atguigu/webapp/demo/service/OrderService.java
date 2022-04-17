package com.atguigu.webapp.demo.service;

import com.atguigu.webapp.demo.bean.OrderInfo;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.Map;

public interface OrderService extends IService<OrderInfo> {

    public void   saveOrder(Map orderMap);
}
