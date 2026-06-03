package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseEstateCreateDTO;
import com.zp.haoke.house.domain.dto.HouseEstateQueryDTO;
import com.zp.haoke.house.domain.dto.HouseEstateUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;
import com.zp.haoke.house.service.IHouseEstateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 楼盘管理
 */
@RestController
@Tag(name = "Estate Management")
@RequestMapping({ "/api/house/estate"})
public class EstateController {

    @Resource
    private IHouseEstateService houseEstateService;

    @Operation(summary = "Create estate", description = "Create estate information")
    @PostMapping("create")
    public R<HouseEstateVO> create(
            @Parameter(description = "Estate create request", required = true)
            @Valid @RequestBody HouseEstateCreateDTO createDTO) {
        return R.ok(houseEstateService.createHouseEstate(createDTO));
    }

    @Operation(summary = "Query estate list", description = "Query estate list")
    @GetMapping("/page")
    public R<List<HouseEstateVO>> page(
            @Parameter(description = "Page number", example = "1")
            @RequestParam(defaultValue = "1") Integer pageNum,
            @Parameter(description = "Page size", example = "10")
            @RequestParam(defaultValue = "10") Integer pageSize,
            @Parameter(description = "Search keyword")
            @RequestParam(required = false) String keyword) {
        HouseEstateQueryDTO queryDTO = new HouseEstateQueryDTO();
        queryDTO.setPageNum(pageNum);
        queryDTO.setPageSize(pageSize);
        queryDTO.setKeyword(keyword);
        return R.ok(houseEstateService.queryPageList(queryDTO));
    }

    @Operation(summary = "Delete estate", description = "Delete estate by id")
    @DeleteMapping("/{id}")
    public R<Boolean> delete(
            @Parameter(description = "Estate id", required = true, example = "1")
            @PathVariable String id) {
        return R.ok(houseEstateService.deleteHouseEstate(id));
    }

    @Operation(summary = "Update estate", description = "Update estate by id")
    @PutMapping("/{id}")
    public R<HouseEstateVO> update(
            @Parameter(description = "Estate id", required = true, example = "1")
            @PathVariable String id,
            @Parameter(description = "Estate update request", required = true)
            @Valid @RequestBody HouseEstateUpdateDTO updateDTO) {
        updateDTO.setId(id);
        return R.ok(houseEstateService.updateById(updateDTO));
    }
}
