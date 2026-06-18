package com.zp.haoke.controller.house;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.ProfilePageQueryDTO;
import com.zp.haoke.house.domain.vo.HouseContractVO;
import com.zp.haoke.house.service.IProfileFeatureService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/house/contract")
public class HouseContractController {
    private final IProfileFeatureService profileFeatureService;
    private final SecurityUtils securityUtils;

    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
    public R<HouseContractVO> getById(@PathVariable String id, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.getContract(userId, id));
    }

    @RequestMapping(value = "/by-order/{orderId}", method = RequestMethod.GET)
    public R<HouseContractVO> getByOrderId(@PathVariable String orderId, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.getContractByOrderId(userId, orderId));
    }

    @RequestMapping(value = "/{id}/sign", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<HouseContractVO> sign(@PathVariable String id, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.signContract(userId, id));
    }

    @RequestMapping(value = "/page", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<PageVO<HouseContractVO>> getPageList(@RequestBody(required = false) ProfilePageQueryDTO queryDTO,
                                                  HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.queryContracts(userId, defaultQuery(queryDTO)));
    }

    private ProfilePageQueryDTO defaultQuery(ProfilePageQueryDTO queryDTO) {
        return queryDTO == null ? new ProfilePageQueryDTO() : queryDTO;
    }
}
