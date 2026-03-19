package com.zp.haoke.auth.domain.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LoginVO {

    private String token;

    @Builder.Default
    private String tokenType = "Bearer";

    private String userId;

    private String username;

    private String avatar;

    private String email;

    private String phone;

    private LocalDateTime expiresAt;

    @Builder.Default
    private LocalDateTime loginTime = LocalDateTime.now();
}
