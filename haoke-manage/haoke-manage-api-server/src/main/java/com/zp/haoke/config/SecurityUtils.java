package com.zp.haoke.config;

import com.zp.haoke.auth.util.JwtUtil;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * 安全工具类，提供获取当前登录用户信息的方法
 *
 * @author zhengpanone
 */
@Component
@RequiredArgsConstructor
public class SecurityUtils {

    private final JwtUtil jwtUtil;

    /**
     * 从请求中提取当前用户ID
     *
     * @param request HTTP请求
     * @return 用户ID
     * @throws RuntimeException 未登录或Token无效时抛出
     */
    public String getCurrentUserId(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            String token = bearerToken.substring(7);
            return jwtUtil.getUserIdFromToken(token);
        }
        throw new RuntimeException("未登录或Token无效");
    }
}
