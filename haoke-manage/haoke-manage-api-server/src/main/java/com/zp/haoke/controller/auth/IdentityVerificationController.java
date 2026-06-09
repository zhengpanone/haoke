package com.zp.haoke.controller.auth;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.IdentityVerificationSubmitDTO;
import com.zp.haoke.house.domain.vo.IdentityVerificationVO;
import com.zp.haoke.house.service.IProfileFeatureService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user/identity")
public class IdentityVerificationController {
    private final IProfileFeatureService profileFeatureService;
    private final SecurityUtils securityUtils;

    @GetMapping("/me")
    public R<IdentityVerificationVO> getCurrent(HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.getIdentityVerification(userId));
    }

    @PostMapping("/submit")
    public R<IdentityVerificationVO> submit(@RequestBody IdentityVerificationSubmitDTO submitDTO,
                                            HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.submitIdentityVerification(userId, submitDTO));
    }
}
