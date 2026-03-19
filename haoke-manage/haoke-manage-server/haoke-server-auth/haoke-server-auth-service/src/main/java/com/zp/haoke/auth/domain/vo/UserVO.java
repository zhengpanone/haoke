package com.zp.haoke.auth.domain.vo;

import com.zp.haoke.auth.domain.po.SysUserPO;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class UserVO {
    
    private Long id;
    private String username;
    private String email;
    private String phone;
    private String avatar;
    private String nickname;
    private SysUserPO.Gender gender;
    private SysUserPO.UserStatus status;
    private SysUserPO.UserType type;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private LocalDateTime lastLoginTime;
    private List<RoleVO> roles;
    
    @Data
    public static class RoleVO {
        private Long id;
        private String name;
        private String description;
    }
}