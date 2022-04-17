package com.atguigu.userprofile.mapper;

import com.atguigu.userprofile.bean.UserGroup;
import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.*;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author zhangchen
 * @since 2021-05-04
 */
@DS("mysql")
public interface UserGroupMapper extends BaseMapper<UserGroup> {

    @Insert("${sql}")
    @DS("clickhouse")
    public void insertUidsSQL(@Param("sql") String sql);

    @DS("clickhouse")
    @Select("select  arrayJoin(bitmapToArray(us)) us   from user_group where user_group_id=#{id} ")
    public List<String> getUserIdListByUserGruopId(@Param("id") String id);

    @DS(("clickhouse"))
    @Select("select bitmapCardinality(us) us_ct  from user_group where user_group_id =#{id}")
    public Long getUserCountByUserGruopId(@Param("id") String id);


    @DS(("clickhouse"))
    @Select("${sql}")
    public Long getUserCountBySQL(@Param("sql") String sql);


    @DS("clickhouse")
    @Delete("alter table  user_group  delete where user_group_id =#{id}")
    public Long deleteUserCountById(@Param("id") String id);

}
