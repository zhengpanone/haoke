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
@Tag(name = "浏览历史")
@RequestMapping("/history")
public class HistoryController {

    @Operation(summary = "添加浏览记录", description = "添加浏览记录信息")
    @PutMapping("/create")
    public R<Void> create(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }


    @Operation(summary = "我的浏览历史", description = "我的浏览历史信息")
    @PutMapping("/page")
    public R<Void> getPageList(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
