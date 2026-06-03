package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseCommunityCreateDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityQueryDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.service.IHouseCommunityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 小区管理
 */
@RestController
@Tag(name = "小区管理")
@RequestMapping({"/api/house/community"})
public class HouseCommunityController {

    @Resource
    private IHouseCommunityService houseCommunityService;

    @Operation(summary = "创建小区", description = "创建新的小区信息")
    @PostMapping("create")
    public R<HouseEstateVO> create(
            @Parameter(description = "创建小区请求参数", required = true)
            @Valid @RequestBody HouseCommunityCreateDTO createDTO) {
        return R.ok(houseCommunityService.create(createDTO));
    }

    @Operation(summary = "Query Community list", description = "Query Community list")
    @PostMapping("/page")
    public R<List<HouseEstateVO>> page(HouseCommunityQueryDTO queryDTO
          ) {
        return R.ok(houseCommunityService.queryPageList(queryDTO));
    }

    @Operation(summary = "Delete Community", description = "Delete Community by id")
    @DeleteMapping("/delete")
    public R<Boolean> delete(
            @Parameter(description = "Community id", required = true, example = "1")
            @PathVariable("id") String id) {
        return R.ok(houseCommunityService.delete(id));
    }

    @Operation(summary = "Update Community", description = "Update Community by id")
    @PutMapping("/update")
    public R<HouseEstateVO> update(
            @Parameter(description = "Community update request", required = true)
            @Valid @RequestBody HouseCommunityUpdateDTO updateDTO) {
        return R.ok(houseCommunityService.updateById(updateDTO));
    }
}
