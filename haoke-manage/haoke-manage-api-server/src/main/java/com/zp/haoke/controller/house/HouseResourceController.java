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
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "House resource")
@RequestMapping("/api/house/resource")
public class HouseResourceController {
    @Resource
    private IHouseResourceService houseResourceService;

    @Resource
    private SecurityUtils securityUtils;

    @Operation(summary = "Create house resource")
    @PostMapping("create")
    public R<HouseResourceVO> create(
            @Parameter(description = "Create request", required = true)
            @Valid @RequestBody HouseResourceCreateDTO createDTO,
            HttpServletRequest request) {
        String landlordId = securityUtils.getCurrentUserId(request);
        houseResourceService.saveHouseResource(createDTO, landlordId);
        return R.ok();
    }

    @Operation(summary = "Get house resource detail")
    @GetMapping("/{id}")
    public R<HouseResourceDetailVO> getById(
            @Parameter(description = "House resource id", required = true, example = "1")
            @PathVariable String id) {
        return R.ok(houseResourceService.queryById(id));
    }

    @Operation(summary = "Query house resource page")
    @PostMapping("/page")
    public R<PageVO<HouseResourceVO>> queryHouseResourcePageList(
            @RequestBody(required = false) HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryPageList(queryDTO)));
    }

    @Operation(summary = "Query hot house resources")
    @PostMapping("/hot")
    public R<PageVO<HouseResourceVO>> hot(@RequestBody(required = false) HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryHotPageList(queryDTO)));
    }

    @Operation(summary = "Query nearby house resources")
    @PostMapping("/nearby")
    public R<PageVO<HouseResourceVO>> nearby(@RequestBody(required = false) HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryNearbyPageList(queryDTO)));
    }

    @Operation(summary = "Query recommended house resources")
    @PostMapping("/recommend")
    public R<PageVO<HouseResourceVO>> recommend(@RequestBody(required = false) HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryRecommendPageList(queryDTO)));
    }

    @Operation(summary = "Update house resource")
    @PutMapping("/update")
    public R<Void> updateHouseResource(@RequestBody HouseResourceUpdateDTO updateDTO) {
        houseResourceService.updateById(updateDTO);
        return R.ok();
    }
}
