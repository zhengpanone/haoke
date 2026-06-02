package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseEstateCreateDTO;
import com.zp.haoke.house.domain.dto.HouseEstateQueryDTO;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.service.IHouseEstateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 楼盘
 */
@RestController
@Tag(name = "Community Management")
@RequestMapping({"/community", "/api/house/community"})
public class CommunityController {

    @Resource
    private IHouseEstateService houseEstateService;

    @Operation(summary = "Query community list", description = "Query communities by keyword")
    @PutMapping("/page")
    public R<List<HouseEstateVO>> getPageList(@RequestBody(required = false) HouseEstateQueryDTO queryDTO) {
        return R.ok(houseEstateService.queryPageList(queryDTO));
    }

    @Operation(summary = "Get community detail", description = "Get community detail by id")
    @GetMapping("/{id}")
    public R<HouseEstateVO> getById(@PathVariable String id) {
        return R.ok(houseEstateService.queryById(id));
    }

    @Operation(summary = "Create community", description = "Create a community")
    @PutMapping("/create")
    public R<HouseEstateVO> create(@Valid @RequestBody HouseEstateCreateDTO createDTO) {
        return R.ok(houseEstateService.createHouseEstate(createDTO));
    }

    @Operation(summary = "Update community", description = "Update community information")
    @PutMapping("/update")
    public R<HouseEstateVO> updateById(@Valid @RequestBody HouseEstateUpdateDTO updateDTO) {
        return R.ok(houseEstateService.updateById(updateDTO));
    }

    @Operation(summary = "Delete community", description = "Delete community by id")
    @DeleteMapping("/{id}")
    public R<Boolean> deleteByIds(@PathVariable String id) {
        return R.ok(houseEstateService.deleteHouseEstate(id));
    }
}
