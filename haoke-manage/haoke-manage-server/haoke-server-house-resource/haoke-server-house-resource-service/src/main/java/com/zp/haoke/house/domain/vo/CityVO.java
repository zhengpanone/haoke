package com.zp.haoke.house.domain.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Schema(description = "City response")
public class CityVO {
    private String id;
    private String name;
    private String code;
    private String parentId;
    private Integer level;
    private Integer sort;
    private Boolean hot;
    private List<CityVO> children = new ArrayList<>();
}
