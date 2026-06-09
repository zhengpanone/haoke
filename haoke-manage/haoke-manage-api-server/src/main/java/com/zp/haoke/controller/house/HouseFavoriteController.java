package com.zp.haoke.controller.house;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.FavoriteCreateDTO;
import com.zp.haoke.house.domain.dto.ProfilePageQueryDTO;
import com.zp.haoke.house.domain.vo.HouseFavoriteVO;
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
@RequestMapping({"/api/house/favorite", "/favirite"})
public class HouseFavoriteController {
    private final IProfileFeatureService profileFeatureService;
    private final SecurityUtils securityUtils;

    @RequestMapping(value = "/create", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<HouseFavoriteVO> create(@RequestBody FavoriteCreateDTO createDTO, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.createFavorite(userId, createDTO));
    }

    @RequestMapping(value = "/delete", method = {RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE})
    public R<Boolean> delete(@RequestBody FavoriteCreateDTO createDTO, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.deleteFavorite(userId, createDTO.getHouseId()));
    }

    @RequestMapping(value = "/{houseId}", method = RequestMethod.DELETE)
    public R<Boolean> deleteByHouseId(@PathVariable String houseId, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.deleteFavorite(userId, houseId));
    }

    @RequestMapping(value = "/check/{houseId}", method = RequestMethod.GET)
    public R<Boolean> check(@PathVariable String houseId, HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.isFavorite(userId, houseId));
    }

    @RequestMapping(value = "/page", method = {RequestMethod.POST, RequestMethod.PUT})
    public R<PageVO<HouseFavoriteVO>> getPageList(@RequestBody(required = false) ProfilePageQueryDTO queryDTO,
                                                  HttpServletRequest request) {
        String userId = securityUtils.getCurrentUserId(request);
        return R.ok(profileFeatureService.queryFavorites(userId, defaultQuery(queryDTO)));
    }

    private ProfilePageQueryDTO defaultQuery(ProfilePageQueryDTO queryDTO) {
        return queryDTO == null ? new ProfilePageQueryDTO() : queryDTO;
    }
}
