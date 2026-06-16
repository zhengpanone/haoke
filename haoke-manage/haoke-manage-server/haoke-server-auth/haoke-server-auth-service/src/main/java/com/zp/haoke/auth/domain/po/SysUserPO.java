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

    @TableField("nickname")
    private String nickname;

    @TableField("status")
    private String status = "ACTIVE";

    @TableField("create_time")
    private LocalDateTime createTime = LocalDateTime.now();

    @TableField("update_time")
    private LocalDateTime updateTime = LocalDateTime.now();
    
}
