package com.zp.haoke.controller;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
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

    @Operation(summary = "创建房源", description = "创建新的房源信息")
    @PostMapping("create")
    public R<HouseResourceVO> create(
            @Parameter(description = "房源创建请求参数", required = true)
            @Valid @RequestBody HouseResourceCreateDTO createDTO) {
        houseResourceService.saveHouseResource(createDTO);
        return R.ok(null);
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
            @PathVariable Long id) {
        // 业务逻辑
        return R.ok(null);
    }
}