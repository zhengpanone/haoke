package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "小区管理")
@RequestMapping("/community")
public class CommunityController {

    @Operation(summary = "小区分页查询", description = "小区分页查询信息")
    @PutMapping("/page")
    public R<Void> getPageList(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "获取小区详情", description = "获取小区详情")
    @PutMapping("/getById")
    public R<Void> getById(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "新增小区", description = "新增小区信息")
    @PutMapping("/create")
    public R<Void> create(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "修改小区", description = "修改小区信息")
    @PutMapping("/update")
    public R<Void> updateById(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "删除小区", description = "删除小区信息")
    @PutMapping("/delete")
    public R<Void> deleteByIds(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
