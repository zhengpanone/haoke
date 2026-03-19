package com.zp.haoke.controller.auth;

import com.zp.haoke.auth.domain.dto.LoginDTO;
import com.zp.haoke.auth.domain.vo.LoginVO;
import com.zp.haoke.auth.service.IAuthService;
import com.zp.haoke.framework.core.domain.response.R;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/auth")
@Validated
public class AuthController {
    private final IAuthService authService;


    @PostMapping("/login")
    public ResponseEntity<R<LoginVO>> login(
            @Valid @RequestBody LoginDTO request) {
        LoginVO response = authService.login(request);
        return ResponseEntity.ok(R.ok(response));
    }

    @PostMapping("/logout")
    public ResponseEntity<R<Void>> logout(
            @RequestHeader("Authorization") String token) {
        authService.logout(token);
        return ResponseEntity.ok(R.ok(null));
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<R<LoginVO>> refreshToken(
            @RequestHeader("Authorization") String token) {
        LoginVO response = authService.refreshToken(token);
        return ResponseEntity.ok(R.ok(response));
    }
}
