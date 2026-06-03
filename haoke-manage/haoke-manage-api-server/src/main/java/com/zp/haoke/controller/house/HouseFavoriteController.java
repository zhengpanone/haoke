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
@Tag(name = "收藏模块")
@RequestMapping("/favirite")
public class HouseFavoriteController {

    @Operation(summary = "收藏房源", description = "收藏房源信息")
    @PutMapping("/create")
    public R<Void> create(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "取消收藏", description = "取消收藏信息")
    @PutMapping("/delete")
    public R<Void> delete(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "我的收藏", description = "我的收藏信息")
    @PutMapping("/page")
    public R<Void> getPageList(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
