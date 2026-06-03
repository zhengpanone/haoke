package com.zp.haoke.controller.house;


import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceQueryDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseResourceDetailVO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import com.zp.haoke.house.service.IHouseResourceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

/**
 * @author : zhengpanone
 * Date : 2025/11/18 23:33
 * Version : v1.0.0
 * Description:
 */

@RestController
@Tag(name = "房源管理")
@RequestMapping("/api/house/resource")
public class HouseResourceController {
    @Resource
    private IHouseResourceService houseResourceService;

    @Resource
    private SecurityUtils securityUtils;

    @Operation(summary = "创建房源", description = "创建新的房源信息")
    @PostMapping("create")
    public R<HouseResourceVO> create(
            @Parameter(description = "房源创建请求参数", required = true)
            @Valid @RequestBody HouseResourceCreateDTO createDTO,
            HttpServletRequest request) {
        String landlordId = securityUtils.getCurrentUserId(request);
        houseResourceService.saveHouseResource(createDTO, landlordId);
        return R.ok();
    }

    @Operation(summary = "获取房源详情", description = "根据ID获取房源详细信息")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "成功",
                    content = @Content(schema = @Schema(implementation = HouseResourceDetailVO.class))),
            @ApiResponse(responseCode = "404", description = "房源不存在")
    })
    @GetMapping("/{id}")
    public R<HouseResourceDetailVO> getById(
            @Parameter(description = "房源ID", required = true, example = "1")
            @PathVariable String id) {
        return R.ok(houseResourceService.queryById(id));
    }

    @Operation(summary = "分页查询房源列表", description = "分页查询房源列表，支持标题、楼盘、租赁方式、状态等条件筛选")
    @PostMapping("/page")
    public R<PageVO<HouseResourceVO>> queryHouseResourcePageList(@RequestBody HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryPageList(queryDTO)));
    }

    @Operation(summary = "更新房源", description = "更新房源信息")
    @PutMapping("/update")
    public R<Void> updateHouseResource(@RequestBody HouseResourceUpdateDTO updateDTO) {
        boolean res = houseResourceService.updateById(updateDTO);
        return R.ok();
    }

    @Operation(summary = "获取热门房源", description = "获取热门房源信息")
    @PutMapping("/hot")
    public R<Void> hot(@RequestBody HouseResourceUpdateDTO updateDTO) {
        boolean res = houseResourceService.updateById(updateDTO);
        return R.ok();
    }

    @Operation(summary = "获取附近房源", description = "获取附近房源信息")
    @PutMapping("/nearby")
    public R<Void> nearby(@RequestBody HouseResourceUpdateDTO updateDTO) {
        boolean res = houseResourceService.updateById(updateDTO);
        return R.ok();
    }

    @Operation(summary = "获取推荐房源", description = "获取推荐房源信息")
    @PutMapping("/recommend")
    public R<Void> recommend(@RequestBody HouseResourceUpdateDTO updateDTO) {
        boolean res = houseResourceService.updateById(updateDTO);
        return R.ok();
    }

}