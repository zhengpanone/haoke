package com.zp.haoke.framework.core.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Gender {

    MALE("1", "男"), FEMALE("2", "女"), UNKNOWN("0", "未知");

    private final String code;
    private final String info;
}