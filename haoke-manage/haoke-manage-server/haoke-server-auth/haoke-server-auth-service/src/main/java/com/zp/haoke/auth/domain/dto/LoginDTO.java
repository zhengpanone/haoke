package com.zp.haoke.auth.domain.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class LoginDTO {
    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;

    // 登录类型：password, sms, wechat
    private String loginType = "password";

    // 验证码
    private String code;
}
