package com.zp.haoke.auth.enums;

import com.zp.haoke.framework.core.enums.IErrorCode;

public enum UserErrorCode implements IErrorCode {
    USER_NOT_FOUND(404, "用户不存在"),
    USER_ALREADY_EXISTS(400, "用户已存在"),
    USER_PASSWORD_INCORRECT(400, "用户密码不正确"),
    USER_PASSWORD_RESET_FAILED(500, "用户密码重置失败"),
    USER_PASSWORD_RESET_SUCCESS(200, "用户密码重置成功"),
    USER_PASSWORD_RESET_FAILED_RETRY_LIMIT_EXCEEDED(400, "用户密码重置失败，重试次数超出限制"),
    ;

    private final int code;
    private final String message;

    UserErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    @Override
    public int code() {
        return this.code;
    }

    @Override
    public String message() {
        return this.message;
    }
}
