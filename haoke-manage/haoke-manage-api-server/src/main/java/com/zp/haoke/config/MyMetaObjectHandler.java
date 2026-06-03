package com.zp.haoke.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.zp.haoke.framework.core.context.UserContextHolder;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * MyBatis-Plus 自动填充处理器
 * 对继承 BasePojo 的实体，在新增/修改时自动填充创建人、更新人、时间等字段
 *
 * @author zhengpanone
 */
@Slf4j
@Component
public class MyMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        String userId = UserContextHolder.getUserId();
        String userName = UserContextHolder.getUserName();
        LocalDateTime now = LocalDateTime.now();

        this.strictInsertFill(metaObject, "createTime", LocalDateTime.class, now);
        this.strictInsertFill(metaObject, "createUserId", String.class, userId);
        this.strictInsertFill(metaObject, "createUserName", String.class, userName);
        this.strictInsertFill(metaObject, "updateTime", LocalDateTime.class, now);
        this.strictInsertFill(metaObject, "updateUserId", String.class, userId);
        this.strictInsertFill(metaObject, "updateUserName", String.class, userName);
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        String userId = UserContextHolder.getUserId();
        String userName = UserContextHolder.getUserName();

        this.strictUpdateFill(metaObject, "updateTime", LocalDateTime.class, LocalDateTime.now());
        this.strictUpdateFill(metaObject, "updateUserId", String.class, userId);
        this.strictUpdateFill(metaObject, "updateUserName", String.class, userName);
    }
}
