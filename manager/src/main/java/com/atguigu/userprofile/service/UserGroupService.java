package com.atguigu.userprofile.service;

import com.atguigu.userprofile.bean.UserGroup;
import com.baomidou.dynamic.datasource.annotation.DS;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.scheduling.annotation.Async;

public interface UserGroupService  extends IService<UserGroup> {

        public void genUserGroup(UserGroup userGroup);

        public Long evaluateUserGroup(UserGroup userGroup);

        public void   refreshUserGroup(String userGroupId,String busiDate);
}
