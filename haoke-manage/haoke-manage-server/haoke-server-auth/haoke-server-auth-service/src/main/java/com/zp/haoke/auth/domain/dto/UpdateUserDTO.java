package com.zp.haoke.auth.domain.dto;

import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.framework.core.enums.Gender;
import com.zp.haoke.framework.core.enums.UserStatus;
import com.zp.haoke.framework.core.enums.UserType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UpdateUserDTO {

    private String id;

    @NotBlank(message = "用户名不能为空")
    @Size(min = 3, max = 20, message = "用户名长度必须在3-20之间")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "用户名只能包含字母、数字和下划线")
    private String username;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度必须在6-20之间")
    private String password;

    @Email(message = "邮箱格式不正确")
    private String email;

    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "手机号格式不正确")
    private String phone;

    private String avatar;

    private String nickname;

    private Gender gender = Gender.UNKNOWN;

    private UserStatus status = UserStatus.ACTIVE;

    private UserType type = UserType.NORMAL;

    private LocalDateTime createTime;
}