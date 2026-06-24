package com.zp.haoke.exception;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.framework.core.enums.ErrorCode;
import com.zp.haoke.framework.core.exception.BizException;
import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * 处理参数验证异常
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<R<Map<String, String>>> handleValidationExceptions(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        log.warn("参数验证失败: {}", errors);
        return ResponseEntity.badRequest()
                .body(R.fail(400, "参数验证失败: "+errors));
    }

    /**
     * 处理约束违反异常
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<R<Void>> handleConstraintViolationException(
            ConstraintViolationException ex) {
        log.warn("约束违反: {}", ex.getMessage());
        return ResponseEntity.badRequest()
                .body(R.fail(400, ex.getMessage()));
    }


    /**
     * 处理业务异常
     */
    @ExceptionHandler(BizException.class)
    public R<?> handleBizException(BizException e) {
        log.warn("业务异常: code={}, message={}", e.getCode(), e.getMessage());
        return R.fail(e.getCode(), e.getMessage());
    }

    /**
     * 处理非法参数异常（业务校验类，消息可安全返回客户端）
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<R<Void>> handleIllegalArgumentException(IllegalArgumentException ex) {
        log.warn("非法参数: {}", ex.getMessage());
        return ResponseEntity.badRequest()
                .body(R.fail(400, ex.getMessage()));
    }

    /**
     * 处理其他异常（含未预期的运行时异常，视为服务端错误，不向客户端泄漏内部信息）
     */
    @ExceptionHandler(Exception.class)
    public R<?> handleException(Exception e) {
        log.error("系统异常: {}", e.getMessage(), e);
        return R.fail(ErrorCode.SYSTEM_ERROR);
    }
}
