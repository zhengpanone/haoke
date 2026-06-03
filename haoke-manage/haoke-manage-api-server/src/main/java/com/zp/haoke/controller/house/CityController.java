package com.zp.haoke.controller.house;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.CityCreateDTO;
import com.zp.haoke.house.domain.dto.CityQueryDTO;
import com.zp.haoke.house.domain.dto.CityUpdateDTO;
import com.zp.haoke.house.domain.vo.CityVO;
import com.zp.haoke.house.service.ICityService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Tag(name = "City Management")
@RequestMapping({ "/api/house/city"})
public class CityController {

    @Resource
    private ICityService cityService;

    @Operation(summary = "Get city tree", description = "Get province/city/area tree")
    @RequestMapping(value = "/tree", method = {RequestMethod.GET, RequestMethod.PUT})
    public R<List<CityVO>> tree() {
        return R.ok(cityService.queryTree());
    }

    @Operation(summary = "Get hot cities", description = "Get hot city list")
    @RequestMapping(value = "/hot", method = {RequestMethod.GET, RequestMethod.PUT})
    public R<List<CityVO>> hot() {
        return R.ok(cityService.queryHot());
    }

    @Operation(summary = "Query cities", description = "Query city list by condition")
    @PutMapping("/list")
    public R<List<CityVO>> list(@RequestBody(required = false) CityQueryDTO queryDTO) {
        return R.ok(cityService.queryList(queryDTO));
    }

    @Operation(summary = "Get city detail", description = "Get city detail by id")
    @GetMapping("/{id}")
    public R<CityVO> getById(@PathVariable String id) {
        return R.ok(cityService.queryById(id));
    }

    @Operation(summary = "Create city", description = "Create province, city or area")
    @PutMapping("/create")
    public R<CityVO> create(@Valid @RequestBody CityCreateDTO createDTO) {
        return R.ok(cityService.createCity(createDTO));
    }

    @Operation(summary = "Update city", description = "Update province, city or area")
    @PutMapping("/update")
    public R<CityVO> update(@Valid @RequestBody CityUpdateDTO updateDTO) {
        return R.ok(cityService.updateCity(updateDTO));
    }

    @Operation(summary = "Delete city", description = "Delete city and descendants")
    @DeleteMapping("/{id}")
    public R<Boolean> delete(@PathVariable String id) {
        return R.ok(cityService.deleteCity(id));
    }
}
