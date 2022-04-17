package com.atguigu.userprofile.controller;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.atguigu.userprofile.bean.TagCondition;
import com.atguigu.userprofile.bean.TaskInfo;
import com.atguigu.userprofile.bean.UserGroup;
import com.atguigu.userprofile.service.UserGroupService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import io.swagger.annotations.ApiOperation;
import org.apache.catalina.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author zhangchen
 * @since 2021-05-04
 */
@RestController
public class UserGroupController {

    @Autowired
    UserGroupService userGroupService;

    @RequestMapping("/user-group-list")
    @CrossOrigin
    public String  getUserGroupList(@RequestParam("pageNo")int pageNo , @RequestParam("pageSize") int pageSize){
        int startNo=(  pageNo-1)* pageSize;
        int endNo=startNo+pageSize;

        QueryWrapper<UserGroup> queryWrapper = new QueryWrapper<>();
        int count = userGroupService.count(queryWrapper);

        queryWrapper.orderByDesc("id").last(" limit " + startNo + "," + endNo);
        List<UserGroup> userGroupList = userGroupService.list(queryWrapper);

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("detail",userGroupList);
        jsonObject.put("total",count);

        return  jsonObject.toJSONString();
    }

    @PostMapping("/user-group")   //接收分群的保存  包括人群包的生成
    public String  genUserGroup( @RequestBody  UserGroup userGroup){
        System.out.println(userGroup);
        userGroupService.genUserGroup(userGroup);
        return "success";
    }

    @PostMapping("/user-group-evaluate")
    public Long userGroupEvaluate(@RequestBody  UserGroup userGroup){
        Long userCount=  userGroupService.evaluateUserGroup(userGroup);
        return userCount;
    }

    @PostMapping("/user-group-refresh/{id}")
    public String refreshUserGroup(@PathVariable("id")String userGroupId,@RequestParam("busiDate") String busiDate){
          userGroupService.refreshUserGroup(userGroupId,busiDate);
          return  "success";
    }


}

