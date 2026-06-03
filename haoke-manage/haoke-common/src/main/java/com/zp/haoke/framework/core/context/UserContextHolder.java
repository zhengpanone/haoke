package com.zp.haoke.framework.core.context;

/**
 * 用户上下文持有者，基于 ThreadLocal 存储当前请求的用户信息
 *
 * @author zhengpanone
 */
public class UserContextHolder {

    private static final ThreadLocal<Context> CONTEXT = new ThreadLocal<>();

    private UserContextHolder() {
    }

    /**
     * 设置当前用户信息
     */
    public static void set(String userId, String userName) {
        CONTEXT.set(new Context(userId, userName));
    }

    /**
     * 获取当前用户ID
     */
    public static String getUserId() {
        Context ctx = CONTEXT.get();
        return ctx != null ? ctx.userId : null;
    }

    /**
     * 获取当前用户名
     */
    public static String getUserName() {
        Context ctx = CONTEXT.get();
        return ctx != null ? ctx.userName : null;
    }

    /**
     * 清理上下文（请求结束后必须调用）
     */
    public static void clear() {
        CONTEXT.remove();
    }

    private record Context(String userId, String userName) {
    }
}
