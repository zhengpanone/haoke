package com.zp.haoke.framework.core.domain.response;

import com.zp.haoke.framework.core.enums.ErrorCode;
import lombok.Data;

import java.io.Serializable;
import java.util.Map;

/**
 * @author : zhengpanone
 * Date : 2025/11/18 21:46
 * Version : v1.0.0
 * Description:
 */
@Data
public class R<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 成功
     */
    public static final int SUCCESS = 200;

    /**
     * 失败
     */
    public static final int FAIL = 500;

    /**
     * 消息状态码
     */
    private int code;

    /**
     * 消息内容
     */
    private String msg;

    private boolean success;

    /**
     * 数据对象
     */
    private T data;

    /**
     * 时间戳
     */
    private long timestamp = System.currentTimeMillis();

    public static <T> R<T> ok() {
        return restResult(null, SUCCESS, "操作成功", true);
    }

    public static <T> R<T> ok(T data) {
        return restResult(data, SUCCESS, "操作成功", true);
    }

    public static <T> R<T> ok(String msg) {
        return restResult(null, SUCCESS, msg, true);
    }

    public static <T> R<T> ok(String msg, T data) {
        return restResult(data, SUCCESS, msg, true);
    }

    public static <T> R<T> fail() {
        return restResult(null, FAIL, "操作失败", false);
    }

    public static <T> R<T> fail(String msg) {
        return restResult(null, FAIL, msg, false);
    }


    public static <T> R<T> fail(T data) {
        return restResult(data, FAIL, "操作失败", false);
    }

    public static <T> R<T> fail(String msg, T data) {
        return restResult(data, FAIL, msg, false);
    }

    public static <T> R<T> fail(int code, String msg) {
        return restResult(null, code, msg, false);
    }

    public static <T> R<T> fail(ErrorCode errorCode) {
        return restResult(null, errorCode.code(), errorCode.message(), false);
    }

    private static <T> R<T> restResult(T data, int code, String msg, boolean success) {
        R<T> r = new R<>();
        r.setCode(code);
        r.setData(data);
        r.setMsg(msg);
        r.setSuccess(success);
        return r;
    }

    public static <T> Boolean isError(R<T> ret) {
        return !isSuccess(ret);
    }

    public static <T> Boolean isSuccess(R<T> ret) {
        return R.SUCCESS == ret.getCode();
    }
}
