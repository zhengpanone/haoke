package com.zp.haoke.controller.ad;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "Banner 广告")
@RequestMapping("/banner")
public class BannerController {

    @Operation(summary = "创建Banner", description = "创建Banner信息")
    @PutMapping("/create")
    public R<Void> create(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "删除Banner", description = "删除Banner信息")
    @PutMapping("/delete")
    public R<Void> delete(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "Banner详情", description = "Banner详情信息")
    @PutMapping("/getById")
    public R<Void> getById(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "Banner分页查询", description = "Banner分页查询信息")
    @PutMapping("/page")
    public R<Void> getPageList(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
