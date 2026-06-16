ALTER TABLE sys_user
    ADD COLUMN status varchar(20) not null default 'ACTIVE' comment '用户状态：ACTIVE/INACTIVE/LOCKED/DISABLE/DELETED' AFTER nickname;
