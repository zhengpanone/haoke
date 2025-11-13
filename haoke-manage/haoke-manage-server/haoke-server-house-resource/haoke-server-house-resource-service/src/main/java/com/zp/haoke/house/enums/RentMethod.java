package com.zp.haoke.house.enums;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "租赁方式枚举")
public enum RentMethod {

    @Schema(description = "整租")
    WHOLE(1, "整租"),

    @Schema(description = "合租")
    SHARE(2, "合租");

    private final Integer code;
    private final String description;

    RentMethod(Integer code, String description) {
        this.code = code;
        this.description = description;
    }

    public Integer getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }
}