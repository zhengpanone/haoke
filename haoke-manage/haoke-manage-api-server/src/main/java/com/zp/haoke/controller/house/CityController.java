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
@Tag(name = "城市管理")
@RequestMapping("/city")
public class CityController {
    @Operation(summary = "获取城市树", description = "获取城市树信息")
    @PutMapping("/tree")
    public R<Void> tree(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "获取热门城市", description = "获取热门城市信息")
    @PutMapping("/hot")
    public R<Void> hot(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
