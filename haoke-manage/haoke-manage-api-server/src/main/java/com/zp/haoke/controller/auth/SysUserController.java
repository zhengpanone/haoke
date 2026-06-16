package com.zp.haoke.controller.auth;

import com.zp.haoke.auth.domain.dto.ChangePasswordDTO;
import com.zp.haoke.auth.domain.convert.SysUserConvert;
import com.zp.haoke.auth.domain.dto.CreateUserDTO;
import com.zp.haoke.auth.domain.dto.PhoneBindDTO;
import com.zp.haoke.auth.domain.dto.PhoneCodeDTO;
import com.zp.haoke.auth.domain.dto.UpdateUserDTO;
import com.zp.haoke.auth.domain.po.SysUserPO;
import com.zp.haoke.auth.domain.vo.UserVO;
import com.zp.haoke.auth.service.ISysUserService;
import com.zp.haoke.auth.util.JwtUtil;
import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;


@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
@Validated
@Tag(name = "用户管理", description = "用户相关接口")
public class SysUserController {

    private final ISysUserService sysUserService;
    private final JwtUtil jwtUtil;
    private final SecurityUtils securityUtils;

    private final SysUserConvert sysUserConvert;


    @PostMapping("/create")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<R<UserVO>> login(
            @Valid @RequestBody CreateUserDTO request) {
        UserVO response = sysUserService.createUser(request);
        return ResponseEntity.ok(R.ok(response));
    }


    /**
     * 获取当前登录用户信息
     */
    @GetMapping("/me")
    @Operation(summary = "获取当前登录用户信息")
    public R<UserVO> getCurrentUser(HttpServletRequest request) {
        try {
            // 方式2: 从token中获取用户信息
            String token = extractToken(request);
            if (token != null) {
                String userId = jwtUtil.getUserIdFromToken(token);
                SysUserPO user = sysUserService.findById(userId);
                return R.ok("获取成功", sysUserConvert.toVO(user));
            }
            // 如果Token不存在，从SecurityContext获取
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() ||
                    "anonymousUser".equals(authentication.getPrincipal())) {
                return R.fail(401, "未登录");
            }
            Object principal = authentication.getPrincipal();
            String username;
            if (principal instanceof UserDetails) {
                // 如果是UserDetails形式的用户名
                username = ((UserDetails) principal).getUsername();
            } else if (principal instanceof String) {
                // 如果是字符串形式的用户名
                username = (String) principal;
            } else {
                return R.fail(401, "无法获取用户信息");
            }
            // 通过用户名查询用户
            SysUserPO user = sysUserService.findByUsername(username);
            return R.ok("获取成功", sysUserConvert.toVO(user));

        } catch (RuntimeException e) {
            return R.fail(404, e.getMessage());
        } catch (Exception e) {
            return R.fail(500, "获取用户信息失败: " + e.getMessage());
        }

    }

    /**
     * 从请求中提取Token
     */
    @PutMapping("/me")
    @Operation(summary = "Update current user profile")
    public R<UserVO> updateCurrentUser(
            HttpServletRequest request,
            @Valid @RequestBody UpdateUserDTO userDTO) {
        try {
            String token = extractToken(request);
            if (token == null) {
                return R.fail(401, "Not logged in");
            }

            String userId = jwtUtil.getUserIdFromToken(token);
            UserVO user = sysUserService.updateUser(userId, userDTO);
            return R.ok("User updated successfully", user);
        } catch (RuntimeException e) {
            return R.fail(400, e.getMessage());
        } catch (Exception e) {
            return R.fail(500, "Failed to update user profile: " + e.getMessage());
        }
    }

    @PostMapping("/password")
    @Operation(summary = "Change current user password")
    public R<Void> changePassword(
            HttpServletRequest request,
            @Valid @RequestBody ChangePasswordDTO passwordDTO) {
        String userId = securityUtils.getCurrentUserId(request);
        sysUserService.changePassword(userId, passwordDTO);
        return R.ok("密码修改成功", null);
    }

    @PostMapping("/phone/code")
    @Operation(summary = "Send phone verification code")
    public R<String> sendPhoneCode(@Valid @RequestBody PhoneCodeDTO phoneCodeDTO) {
        String code = sysUserService.sendPhoneCode(phoneCodeDTO);
        return R.ok("验证码已发送", code);
    }

    @PostMapping("/phone/bind")
    @Operation(summary = "Bind current user phone")
    public R<UserVO> bindPhone(
            HttpServletRequest request,
            @Valid @RequestBody PhoneBindDTO phoneBindDTO) {
        String userId = securityUtils.getCurrentUserId(request);
        UserVO user = sysUserService.bindPhone(userId, phoneBindDTO);
        return R.ok("手机号绑定成功", user);
    }

    @PostMapping({"/phone/unbind", "/unbindPhone"})
    @Operation(summary = "Unbind current user phone")
    public R<UserVO> unbindPhone(HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        UserVO user = sysUserService.unbindPhone(userId);
        return R.ok("手机号解绑成功", user);
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }

    /**
     * 更新用户信息
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    public R<UserVO> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserDTO userDTO) {
        UserVO user = sysUserService.updateUser(id, userDTO);
        return R.ok("用户更新成功", user);
    }

    /**
     * 获取用户详情
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or #id == authentication.principal.id")
    public R<UserVO> getUser(@PathVariable Long id) {
        return R.ok("获取成功", sysUserService.getUser(id));
    }

    /**
     * 获取用户列表（管理员）
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public R<PageVO<UserVO>> getUsers(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size) {
        return R.ok("获取成功", sysUserService.queryUsers(page, size));
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public R<Void> deleteUser(@PathVariable Long id) {
        sysUserService.deleteUser(id);
        return R.ok("用户删除成功", null);
    }

    /**
     * 启用/禁用用户
     */
    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public R<UserVO> updateUserStatus(
            @PathVariable Long id,
            @RequestParam String status) {
        return R.ok("状态更新成功", sysUserService.updateUserStatus(id, status));
    }
}
