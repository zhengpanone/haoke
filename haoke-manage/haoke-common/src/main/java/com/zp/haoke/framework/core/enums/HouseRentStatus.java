package com.zp.haoke.framework.core.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 房屋出租状态
 */
@Getter
@AllArgsConstructor
public enum HouseRentStatus {
    /**
     * 待审核
     */
    PENDING("1", "待审核"),
    /**
     * 审核通过
     */
    APPROVED("2", "审核通过"),
    /**
     * 审核不通过
     */
    REJECTED("3", "审核不通过"),
    /**
     * 已出租
     */
    RENTED("4", "已出租"),
    /**
     * 已下架
     */
    OFF_SHELF("5", "已下架");

    @EnumValue
    @JsonValue
    private final String code;
    private final String info;

    @JsonCreator
    public static HouseRentStatus fromCode(String code) {
        for (HouseRentStatus status : values()) {
            if (status.code.equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid HouseRentStatus code: " + code);
    }
}
