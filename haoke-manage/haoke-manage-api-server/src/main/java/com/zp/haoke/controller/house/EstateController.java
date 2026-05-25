package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseEstateCreateDTO;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.service.IHouseEstateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 楼盘数据表 前端控制器
 * </p>
 *
 * @author zhengpanone
 * @since 2025-11-14
 */
@RestController
@Tag(name = "楼盘管理")
@RequestMapping("/estate")
public class EstateController {

    @Resource
    private IHouseEstateService houseEstateService;

    @Operation(summary = "创建楼盘", description = "创建新的楼盘信息")
    @PostMapping("create")
    public R<HouseEstateVO> create(
            @Parameter(description = "楼盘创建请求参数", required = true)
            @Valid @RequestBody HouseEstateCreateDTO createDTO) {

        return R.ok();
    }

    @Operation(summary = "分页查看楼盘列表", description = "获取楼盘列表")
    @GetMapping("/page")
    public R<List<HouseEstateVO>> page(
            @Parameter(description = "页码", required = true, example = "1")
            @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "每页条数", required = true, example = "10")
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return R.ok(houseEstateService.queryPageList());
    }

    @Operation(summary = "删除楼盘", description = "根据ID删除楼盘")
    @DeleteMapping("/{id}")
    public R<Boolean> delete(
            @Parameter(description = "楼盘ID", required = true, example = "1")
            @PathVariable String id) {
        return R.ok(houseEstateService.removeById(id));
    }

    @Operation(summary = "修改楼盘", description = "根据ID修改楼盘")
    @PutMapping("/{id}")
    public R<Integer> update(
            @Parameter(description = "楼盘ID", required = true, example = "1")
            @PathVariable String id,
            @Parameter(description = "楼盘修改请求参数", required = true)
            @Valid @RequestBody HouseEstateUpdateDTO updateDTO) {
        return R.ok(houseEstateService.updateById(updateDTO));
    }

}
