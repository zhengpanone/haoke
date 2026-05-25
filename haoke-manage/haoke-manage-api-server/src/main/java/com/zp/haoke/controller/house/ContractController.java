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
@Tag(name = "合同模块")
@RequestMapping("/contract")
public class ContractController {

    @Operation(summary = "创建合同", description = "创建合同信息")
    @PutMapping("/create")
    public R<Void> create(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "删除合同", description = "删除合同信息")
    @PutMapping("/delete")
    public R<Void> delete(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "终止合同", description = "终止合同信息")
    @PutMapping("/terminate")
    public R<Void> terminate(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "合同详情", description = "合同详情信息")
    @PutMapping("/getById")
    public R<Void> getById(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }

    @Operation(summary = "合同分页查询", description = "合同分页查询信息")
    @PutMapping("/page")
    public R<Void> getPageList(@RequestBody HouseResourceUpdateDTO updateDTO) {

        return R.ok();
    }
}
