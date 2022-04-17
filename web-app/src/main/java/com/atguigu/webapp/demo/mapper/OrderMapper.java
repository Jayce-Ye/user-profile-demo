package com.atguigu.webapp.demo.mapper;


import com.atguigu.webapp.demo.bean.OrderInfo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.Map;

@Mapper
public interface OrderMapper  extends BaseMapper<OrderInfo> {

    @Insert("insert into order_info values(#{order.id},#{order.amount} )")
    public  void insertOrder(@Param("order") Map orderMap);

    @Select("select id, amount from order_info  where id=#{id}")
    public OrderInfo selectOrder(@Param("id") Integer id );
}
