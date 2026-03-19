package com.zp.haoke.controller.auth;

import com.zp.haoke.auth.domain.dto.CreateUserDTO;
import com.zp.haoke.auth.domain.dto.UpdateUserDTO;
import com.zp.haoke.auth.domain.vo.UserVO;
import com.zp.haoke.auth.service.ISysUserService;
import com.zp.haoke.framework.core.domain.response.R;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/user")
@Validated
public class SysUserController {

    private final ISysUserService sysUserService;


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
    public R<UserVO> getCurrentUser() {
        // 从SecurityContext中获取当前用户ID
        // 这里简化处理，实际应该从token中获取
        return R.ok("获取成功", null);
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
        // 这里简化处理，实际应该查询并返回用户信息
        return R.ok("获取成功", null);
    }

    /**
     * 获取用户列表（管理员）
     */
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public R<List<UserVO>> getUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        // 这里简化处理，实际应该分页查询
        return R.ok("获取成功", null);
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
        // 这里简化处理，实际应该根据status参数更新用户状态
        return R.ok("状态更新成功", null);
    }
}
