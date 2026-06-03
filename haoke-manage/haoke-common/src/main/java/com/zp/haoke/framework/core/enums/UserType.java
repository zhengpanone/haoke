package com.zp.haoke.framework.core.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UserType {
    SUPER_ADMIN("1", "超级管理员"),    // 超级管理员
    ADMIN("2", "管理员"),          // 管理员
    NORMAL("3", "普通用户"),         // 普通用户
    VIP("4", "VIP用户");             // VIP用户

    private final String code;
    private final String info;
}