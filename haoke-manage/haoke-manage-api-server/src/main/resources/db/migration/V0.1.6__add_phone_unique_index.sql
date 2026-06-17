-- 为 sys_user.phone 添加唯一索引，防止重复绑定
-- 注意：已有重复数据的表需要先清理
ALTER TABLE sys_user
    ADD UNIQUE INDEX uk_phone (phone);
