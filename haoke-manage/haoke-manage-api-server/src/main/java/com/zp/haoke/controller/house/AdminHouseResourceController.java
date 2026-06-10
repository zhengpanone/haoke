package com.zp.haoke.controller.house;

import com.zp.haoke.config.SecurityUtils;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.dto.HouseResourceQueryDTO;
import com.zp.haoke.house.domain.dto.HouseResourceStatusDTO;
import com.zp.haoke.house.domain.dto.HouseResourceUpdateDTO;
import com.zp.haoke.house.domain.vo.HouseResourceVO;
import com.zp.haoke.house.service.IHouseResourceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "Admin house resource")
@RequestMapping("/api/admin/house/resource")
public class AdminHouseResourceController {

    private final IHouseResourceService houseResourceService;
    private final SecurityUtils securityUtils;

    @Operation(summary = "Query all house resources for admin")
    @PostMapping("/page")
    public R<PageVO<HouseResourceVO>> page(@RequestBody(required = false) HouseResourceQueryDTO queryDTO) {
        return R.ok(PageVO.of(houseResourceService.queryPageList(queryDTO)));
    }

    @Operation(summary = "Create house resource for admin")
    @PostMapping("/create")
    public R<HouseResourceVO> create(
            @Valid @RequestBody HouseResourceCreateDTO createDTO,
            HttpServletRequest request) {
        return R.ok(houseResourceService.createByAdmin(createDTO, resolveOperatorId(request)));
    }

    @Operation(summary = "Update house resource for admin")
    @PutMapping("/update")
    public R<Void> update(@Valid @RequestBody HouseResourceUpdateDTO updateDTO) {
        houseResourceService.updateById(updateDTO);
        return R.ok();
    }

    @Operation(summary = "Update house resource status")
    @PutMapping("/{id}/status")
    public R<Void> updateStatus(
            @PathVariable String id,
            @Valid @RequestBody HouseResourceStatusDTO statusDTO) {
        houseResourceService.updateStatus(id, statusDTO.getStatus());
        return R.ok();
    }

    @Operation(summary = "Delete house resource")
    @DeleteMapping("/{id}")
    public R<Void> delete(@PathVariable String id) {
        houseResourceService.deleteByIds(id);
        return R.ok();
    }

    private String resolveOperatorId(HttpServletRequest request) {
        try {
            return securityUtils.getCurrentUserId(request);
        } catch (RuntimeException ignored) {
            return "admin";
        }
    }
}
