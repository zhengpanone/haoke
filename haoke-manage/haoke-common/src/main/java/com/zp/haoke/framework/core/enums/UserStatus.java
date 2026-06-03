package com.zp.haoke.framework.core.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 用户状态
 *
 * @author ruoyi
 */
@Getter
@AllArgsConstructor
public enum UserStatus {
    /**
     * 正常
     */
    ACTIVE("0", "正常"),
    /**
     * 未激活
     */
    INACTIVE("1", "未激活"),
    /**
     * 锁定
     */
    LOCKED("2", "锁定"),
    /**
     * 停用
     */
    DISABLE("1", "停用"),
    /**
     * 删除
     */
    DELETED("2", "删除");

    private final String code;
    private final String info;
}
