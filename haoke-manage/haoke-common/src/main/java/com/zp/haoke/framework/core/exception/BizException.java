package com.zp.haoke.framework.core.exception;

import com.zp.haoke.framework.core.enums.IErrorCode;
import lombok.Getter;

public class BizException extends RuntimeException {

    @Getter
    private final int code;
    private final String message;

    public BizException(String message) {
        super(message);
        this.code = 500;
        this.message = message;
    }

    public BizException(int code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }

    public BizException(int code, String message, Throwable cause) {
        super(message, cause);
        this.code = code;
        this.message = message;
    }

    public BizException(IErrorCode errorCode) {
        super(errorCode.message());
        this.code = errorCode.code();
        this.message = errorCode.message();
    }

    @Override
    public String getMessage() {
        return message;
    }
}