package com.zp.haoke.auth.domain.dto;

import com.zp.haoke.framework.core.enums.Gender;
import com.zp.haoke.framework.core.enums.UserStatus;
import com.zp.haoke.framework.core.enums.UserType;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UpdateUserDTO {

    private String id;

    @Size(min = 3, max = 20, message = "Username length must be 3-20")
    @Pattern(regexp = "^[a-zA-Z0-9_]+$", message = "Username can only contain letters, numbers and underscores")
    private String username;

    @Size(min = 6, max = 20, message = "Password length must be 6-20")
    private String password;

    @Email(message = "Invalid email format")
    private String email;

    @Pattern(regexp = "^1[3-9]\\d{9}$", message = "Invalid phone number")
    private String phone;

    @Size(max = 255, message = "Avatar URL length must be at most 255")
    private String avatar;

    @Size(max = 64, message = "Nickname length must be at most 64")
    private String nickname;

    private Gender gender = Gender.UNKNOWN;

    private UserStatus status = UserStatus.ACTIVE;

    private UserType type = UserType.NORMAL;

    private LocalDateTime createTime;
}
