package com.zp.haoke.auth.domain.po;


import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDateTime;

@TableName("sys_user")
@Data
public class SysUserPO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @TableId("id")
    private String id;

    @TableField("username")
    private String username;

    @TableField("password")
    private String password;

    @TableField("email")
    private String email;

    @TableField("phone")
    private String phone;

    @TableField("avatar")
    private String avatar;

    @TableField("create_time")
    private LocalDateTime createTime = LocalDateTime.now();

    @TableField("update_time")
    private LocalDateTime updateTime = LocalDateTime.now();

    // 枚举类型
    public enum Gender {
        MALE, FEMALE, UNKNOWN
    }

    public enum UserStatus {
        ACTIVE,     // 激活
        INACTIVE,   // 未激活
        LOCKED,     // 锁定
        DELETED     // 删除
    }

    public enum UserType {
        SUPER_ADMIN,    // 超级管理员
        ADMIN,          // 管理员
        NORMAL,         // 普通用户
        VIP             // VIP用户
    }
}
