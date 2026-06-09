CREATE TABLE IF NOT EXISTS `house_viewing_record`
(
    id               varchar(32) PRIMARY KEY COMMENT '看房记录ID',
    user_id          varchar(32)  NOT NULL COMMENT '用户ID',
    house_id         varchar(32)  NULL COMMENT '房源ID',
    title            varchar(100) NOT NULL COMMENT '房源标题',
    address          varchar(255) NULL COMMENT '看房地址',
    appointment_time datetime     NULL COMMENT '预约时间',
    contact_name     varchar(32)  NULL COMMENT '联系人',
    contact_phone    varchar(32)  NULL COMMENT '联系电话',
    status           varchar(20)  NOT NULL DEFAULT 'PENDING' COMMENT '状态',
    note             varchar(255) NULL COMMENT '备注',
    create_time      datetime              DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)  NULL COMMENT '创建人ID',
    create_user_name varchar(32)  NULL COMMENT '创建人名称',
    update_time      datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)  NULL COMMENT '更新人ID',
    update_user_name varchar(32)  NULL COMMENT '更新人名称',
    INDEX idx_viewing_user (user_id),
    INDEX idx_viewing_house (house_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='看房记录';

CREATE TABLE IF NOT EXISTS `house_order`
(
    id               varchar(32) PRIMARY KEY COMMENT '订单ID',
    user_id          varchar(32)    NOT NULL COMMENT '用户ID',
    house_id         varchar(32)    NULL COMMENT '房源ID',
    order_no         varchar(64)    NOT NULL COMMENT '订单编号',
    title            varchar(100)   NOT NULL COMMENT '订单标题',
    address          varchar(255)   NULL COMMENT '房源地址',
    amount           decimal(12, 2) NOT NULL DEFAULT 0 COMMENT '订单金额',
    status           varchar(20)    NOT NULL DEFAULT 'PENDING_SIGN' COMMENT '订单状态',
    action_text      varchar(32)    NULL COMMENT '主操作文案',
    order_time       datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    create_time      datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)    NULL COMMENT '创建人ID',
    create_user_name varchar(32)    NULL COMMENT '创建人名称',
    update_time      datetime                DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)    NULL COMMENT '更新人ID',
    update_user_name varchar(32)    NULL COMMENT '更新人名称',
    UNIQUE KEY uk_house_order_no (order_no),
    INDEX idx_house_order_user (user_id),
    INDEX idx_house_order_house (house_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='租房订单';

CREATE TABLE IF NOT EXISTS `house_favorite`
(
    id               varchar(32) PRIMARY KEY COMMENT '收藏ID',
    user_id          varchar(32)    NOT NULL COMMENT '用户ID',
    house_id         varchar(32)    NOT NULL COMMENT '房源ID',
    title            varchar(100)   NOT NULL COMMENT '房源标题',
    address          varchar(255)   NULL COMMENT '房源地址',
    price            decimal(12, 2) NOT NULL DEFAULT 0 COMMENT '租金',
    tags             varchar(255)   NULL COMMENT '标签，逗号分隔',
    image_url        varchar(255)   NULL COMMENT '封面图',
    favorite_time    datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    create_time      datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)    NULL COMMENT '创建人ID',
    create_user_name varchar(32)    NULL COMMENT '创建人名称',
    update_time      datetime                DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)    NULL COMMENT '更新人ID',
    update_user_name varchar(32)    NULL COMMENT '更新人名称',
    UNIQUE KEY uk_house_favorite_user_house (user_id, house_id),
    INDEX idx_house_favorite_user (user_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='房源收藏';

CREATE TABLE IF NOT EXISTS `user_identity_verification`
(
    id               varchar(32) PRIMARY KEY COMMENT '认证ID',
    user_id          varchar(32)  NOT NULL COMMENT '用户ID',
    real_name        varchar(64)  NULL COMMENT '真实姓名',
    id_card_no       varchar(32)  NULL COMMENT '身份证号',
    id_card_front    varchar(255) NULL COMMENT '身份证正面',
    id_card_back     varchar(255) NULL COMMENT '身份证反面',
    status           varchar(20)  NOT NULL DEFAULT 'NOT_SUBMITTED' COMMENT '认证状态',
    reject_reason    varchar(255) NULL COMMENT '驳回原因',
    submitted_at     datetime     NULL COMMENT '提交时间',
    reviewed_at      datetime     NULL COMMENT '审核时间',
    create_time      datetime              DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)  NULL COMMENT '创建人ID',
    create_user_name varchar(32)  NULL COMMENT '创建人名称',
    update_time      datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)  NULL COMMENT '更新人ID',
    update_user_name varchar(32)  NULL COMMENT '更新人名称',
    UNIQUE KEY uk_identity_user (user_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='用户身份认证';

CREATE TABLE IF NOT EXISTS `house_contract`
(
    id               varchar(32) PRIMARY KEY COMMENT '合同ID',
    user_id          varchar(32)  NOT NULL COMMENT '用户ID',
    house_id         varchar(32)  NULL COMMENT '房源ID',
    order_id         varchar(32)  NULL COMMENT '订单ID',
    contract_no      varchar(64)  NOT NULL COMMENT '合同编号',
    title            varchar(100) NOT NULL COMMENT '合同标题',
    period_start     date         NULL COMMENT '租期开始',
    period_end       date         NULL COMMENT '租期结束',
    status           varchar(20)  NOT NULL DEFAULT 'PENDING_SIGN' COMMENT '合同状态',
    pdf_url          varchar(255) NULL COMMENT 'PDF地址',
    sign_url         varchar(255) NULL COMMENT '签署地址',
    create_time      datetime              DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)  NULL COMMENT '创建人ID',
    create_user_name varchar(32)  NULL COMMENT '创建人名称',
    update_time      datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)  NULL COMMENT '更新人ID',
    update_user_name varchar(32)  NULL COMMENT '更新人名称',
    UNIQUE KEY uk_contract_no (contract_no),
    INDEX idx_contract_user (user_id),
    INDEX idx_contract_order (order_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='电子合同';

CREATE TABLE IF NOT EXISTS `user_wallet`
(
    id               varchar(32) PRIMARY KEY COMMENT '钱包ID',
    user_id          varchar(32)    NOT NULL COMMENT '用户ID',
    balance          decimal(12, 2) NOT NULL DEFAULT 0 COMMENT '账户余额',
    frozen_amount    decimal(12, 2) NOT NULL DEFAULT 0 COMMENT '冻结金额',
    create_time      datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)    NULL COMMENT '创建人ID',
    create_user_name varchar(32)    NULL COMMENT '创建人名称',
    update_time      datetime                DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)    NULL COMMENT '更新人ID',
    update_user_name varchar(32)    NULL COMMENT '更新人名称',
    UNIQUE KEY uk_wallet_user (user_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='用户钱包';

CREATE TABLE IF NOT EXISTS `wallet_record`
(
    id               varchar(32) PRIMARY KEY COMMENT '钱包流水ID',
    user_id          varchar(32)    NOT NULL COMMENT '用户ID',
    record_type      varchar(20)    NOT NULL COMMENT '流水类型',
    title            varchar(100)   NOT NULL COMMENT '流水标题',
    amount           decimal(12, 2) NOT NULL COMMENT '金额',
    income           tinyint(1)     NOT NULL DEFAULT 1 COMMENT '是否收入',
    status           varchar(20)    NOT NULL DEFAULT 'SUCCESS' COMMENT '流水状态',
    record_time      datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '流水时间',
    create_time      datetime                DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    create_user_id   varchar(32)    NULL COMMENT '创建人ID',
    create_user_name varchar(32)    NULL COMMENT '创建人名称',
    update_time      datetime                DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    update_user_id   varchar(32)    NULL COMMENT '更新人ID',
    update_user_name varchar(32)    NULL COMMENT '更新人名称',
    INDEX idx_wallet_record_user (user_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='钱包流水';

INSERT IGNORE INTO house_viewing_record (id, user_id, house_id, title, address, appointment_time, contact_name, contact_phone, status, note)
VALUES ('30000000000000000000000000000001', '2034514861085626370', '1', '阳光花园 2 室 1 厅', '朝阳区望京西路 18 号', '2026-06-10 10:30:00', '李经理', '13800138821', 'PENDING', '请提前 10 分钟到达小区南门'),
       ('30000000000000000000000000000002', '2034514861085626370', '2', '滨江雅苑整租一居室', '浦东新区张杨路 889 号', '2026-06-03 15:00:00', '王经理', '13900138821', 'COMPLETED', '采光不错，已收藏房源');

INSERT IGNORE INTO house_order (id, user_id, house_id, order_no, title, address, amount, status, action_text, order_time)
VALUES ('31000000000000000000000000000001', '2034514861085626370', '1', 'HK202606080001', '阳光花园租房订单', '朝阳区望京西路 18 号', 5800.00, 'PENDING_SIGN', '去签约', '2026-06-08 14:20:00'),
       ('31000000000000000000000000000002', '2034514861085626370', '2', 'HK202606010001', '滨江雅苑看房服务', '浦东新区张杨路 889 号', 80.00, 'COMPLETED', '评价', '2026-06-01 10:12:00');

INSERT IGNORE INTO house_favorite (id, user_id, house_id, title, address, price, tags, image_url, favorite_time)
VALUES ('32000000000000000000000000000001', '2034514861085626370', '1', '阳光花园 2 室 1 厅', '近地铁 14 号线，南向采光', 5800.00, '整租,近地铁,精装', 'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg', '2026-06-08 09:10:00'),
       ('32000000000000000000000000000002', '2034514861085626370', '2', '星河湾南向三居', '海淀区中关村南大街 6 号', 8600.00, '三居,可短租,随时看房', 'https://images.pexels.com/photos/33564839/pexels-photo-33564839.jpeg', '2026-06-02 20:30:00');

INSERT IGNORE INTO user_identity_verification (id, user_id, real_name, id_card_no, status, submitted_at)
VALUES ('33000000000000000000000000000001', '2034514861085626370', '张先生', '110101199001011234', 'REVIEWING', '2026-06-08 16:00:00');

INSERT IGNORE INTO house_contract (id, user_id, house_id, order_id, contract_no, title, period_start, period_end, status, pdf_url)
VALUES ('34000000000000000000000000000001', '2034514861085626370', '1', '31000000000000000000000000000001', 'HT202606150001', '阳光花园租赁合同', '2026-06-15', '2027-06-14', 'PENDING_SIGN', ''),
       ('34000000000000000000000000000002', '2034514861085626370', '2', '31000000000000000000000000000002', 'HT202606010001', '滨江雅苑服务协议', '2026-06-01', '2026-06-30', 'ARCHIVED', '');

INSERT IGNORE INTO user_wallet (id, user_id, balance, frozen_amount)
VALUES ('35000000000000000000000000000001', '2034514861085626370', 2680.00, 0.00);

INSERT IGNORE INTO wallet_record (id, user_id, record_type, title, amount, income, status, record_time)
VALUES ('36000000000000000000000000000001', '2034514861085626370', 'REFUND', '押金退款', 1200.00, 1, 'SUCCESS', '2026-06-06 18:20:00'),
       ('36000000000000000000000000000002', '2034514861085626370', 'SERVICE_FEE', '看房服务费', 80.00, 0, 'SUCCESS', '2026-06-01 10:12:00');
