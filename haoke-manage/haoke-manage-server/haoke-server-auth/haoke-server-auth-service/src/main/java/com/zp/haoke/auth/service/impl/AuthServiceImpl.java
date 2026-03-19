package com.zp.haoke.auth.service.impl;

import com.zp.haoke.auth.domain.dto.LoginDTO;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.domain.vo.LoginVO;
import com.zp.haoke.auth.service.IAuthService;
import com.zp.haoke.auth.service.ISysUserService;
import com.zp.haoke.auth.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@RequiredArgsConstructor
@Service
public class AuthServiceImpl implements IAuthService {

    private final AuthenticationManager authenticationManager;
    private final ISysUserService userService;
    private final JwtUtil jwtUtil;

    public LoginVO login(LoginDTO request) {
        // 1. 认证
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        // 2. 获取用户信息
        SysUserPO user = userService.findByUsername(request.getUsername());

        // 3. 生成token
        String token = jwtUtil.generateToken(user.getUsername(), user.getId());

        // 4. 返回响应
        return LoginVO.builder()
                .token(token)
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .avatar(user.getAvatar())
                .phone(user.getPhone())
                .build();
    }

    public void logout(String token) {
        if (StringUtils.hasText(token) && token.startsWith("Bearer ")) {
            token = token.substring(7);
            // 可以在这里将token加入黑名单
        }
    }

    public LoginVO refreshToken(String token) {
        if (StringUtils.hasText(token) && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        String userId = jwtUtil.getUserIdFromToken(token);
        String username = jwtUtil.getUsernameFromToken(token);

        SysUserPO user = userService.findById(userId);
        String newToken = jwtUtil.generateToken(username, userId);

        return LoginVO.builder()
                .token(newToken)
                .userId(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .avatar(user.getAvatar())
                .phone(user.getPhone())
                .build();
    }
}
