package com.zp.haoke.controller.house;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.WalletTradeDTO;
import com.zp.haoke.house.domain.vo.WalletOverviewVO;
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
@RequestMapping("/api/wallet")
public class WalletController {
    private final IProfileFeatureService profileFeatureService;
    private final SecurityUtils securityUtils;

    @GetMapping("/me")
    public R<WalletOverviewVO> getWallet(HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.getWallet(userId));
    }

    @PostMapping("/recharge")
    public R<WalletOverviewVO> recharge(@RequestBody WalletTradeDTO tradeDTO, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.recharge(userId, tradeDTO));
    }

    @PostMapping("/withdraw")
    public R<WalletOverviewVO> withdraw(@RequestBody WalletTradeDTO tradeDTO, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.withdraw(userId, tradeDTO));
    }
}
