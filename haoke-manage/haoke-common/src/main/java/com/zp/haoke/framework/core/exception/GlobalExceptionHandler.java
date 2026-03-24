package com.zp.haoke.framework.core.exception;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.framework.core.enums.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    @ExceptionHandler(BizException.class)
    public R<?> handleBizException(BizException e) {
        return R.fail(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public R<?> handleException(Exception e) {
        log.info("系统异常: {}", e.getMessage());
        return R.fail(ErrorCode.SYSTEM_ERROR);
    }
}
