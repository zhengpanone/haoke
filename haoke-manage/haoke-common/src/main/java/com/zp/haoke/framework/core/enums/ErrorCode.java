package com.zp.haoke.framework.core.enums;

public enum ErrorCode implements IErrorCode {

    PARAM_ERROR(400, "参数错误"),
    SYSTEM_ERROR(500, "系统异常");

    private final int code;
    private final String message;

    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public int code() {
        return code;
    }

    public String message() {
        return message;
    }
}