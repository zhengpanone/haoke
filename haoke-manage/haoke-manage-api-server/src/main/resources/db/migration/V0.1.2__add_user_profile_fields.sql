ALTER TABLE sys_user
    ADD COLUMN nickname varchar(64) null comment 'nickname' AFTER avatar;
