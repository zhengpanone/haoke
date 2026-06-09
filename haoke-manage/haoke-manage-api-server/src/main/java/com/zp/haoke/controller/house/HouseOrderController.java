package com.zp.haoke.controller.house;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseOrderCreateDTO;
import com.zp.haoke.house.domain.dto.ProfilePageQueryDTO;
import com.zp.haoke.house.domain.vo.HouseOrderVO;
import com.zp.haoke.house.service.IProfileFeatureService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/house/order")
public class HouseOrderController {
    private final IProfileFeatureService profileFeatureService;
    private final SecurityUtils securityUtils;

    @RequestMapping(value = "/create", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<HouseOrderVO> create(@RequestBody HouseOrderCreateDTO createDTO, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.createOrder(userId, createDTO));
    }

    @RequestMapping(value = "/page", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<PageVO<HouseOrderVO>> getPageList(@RequestBody(required = false) ProfilePageQueryDTO queryDTO,
                                               HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.queryOrders(userId, defaultQuery(queryDTO)));
    }

    private ProfilePageQueryDTO defaultQuery(ProfilePageQueryDTO queryDTO) {
        return queryDTO == null ? new ProfilePageQueryDTO() : queryDTO;
    }
}
