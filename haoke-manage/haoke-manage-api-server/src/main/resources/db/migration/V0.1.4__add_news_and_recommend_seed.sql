CREATE TABLE IF NOT EXISTS `news_article`
(
    id               varchar(32) PRIMARY KEY COMMENT 'news id',
    title            varchar(100) NOT NULL COMMENT 'title',
    summary          varchar(255) NULL COMMENT 'summary',
    content          text         NOT NULL COMMENT 'content',
    cover_url        varchar(255) NULL COMMENT 'cover url',
    source           varchar(50)  NULL COMMENT 'source',
    status           tinyint      NOT NULL DEFAULT 1 COMMENT '1 draft, 2 published, 3 offline',
    sort             int          NOT NULL DEFAULT 0 COMMENT 'sort order',
    publish_time     datetime     NULL COMMENT 'publish time',
    create_time      datetime              DEFAULT CURRENT_TIMESTAMP COMMENT 'create time',
    create_user_id   varchar(32)  NULL COMMENT 'create user id',
    create_user_name varchar(32)  NULL COMMENT 'create user name',
    update_time      datetime              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'update time',
    update_user_id   varchar(32)  NULL COMMENT 'update user id',
    update_user_name varchar(32)  NULL COMMENT 'update user name',
    INDEX idx_news_status_sort (status, sort, publish_time),
    INDEX idx_news_title (title)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='latest news';

INSERT IGNORE INTO house_community
(id, name, province, city, area, address, year, type, property_cost, property_company, developers)
VALUES
('21000000000000000000000000000001', '阳光花园', '北京', '北京', '朝阳区', '望京西路18号', '2016', '住宅', '4.8', '好客物业', '好客置业'),
('21000000000000000000000000000002', '滨江雅苑', '上海', '上海', '浦东新区', '张杨路889号', '2019', '住宅', '5.2', '滨江物业', '城市开发'),
('21000000000000000000000000000003', '星河湾', '广东', '广州', '天河区', '珠江新城海安路6号', '2021', '住宅', '6.0', '星河物业', '星河集团');

INSERT IGNORE INTO house_resource
(id, title, estate_id, building_num, building_unit, building_floor_num, rent, rent_method, payment_method, house_type, covered_area, use_area, floor, orientation, decoration, facilities, pic, house_desc, contact, mobile, landlord_id, status, time, property_cost)
VALUES
('22000000000000000000000000000001', '阳光花园整租两居', '21000000000000000000000000000001', '8', '1', '1202', 5800, 1, 2, '2室1厅1卫', 89.50, '76', '12/26', 2, 1, '1,2,3,5', 'https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg', '南向两居，近地铁，家具家电齐全，可拎包入住。', '李经理', '13800138821', '2034514861085626370', 2, 5, '4.8'),
('22000000000000000000000000000002', '滨江雅苑精装一居', '21000000000000000000000000000002', '3', '2', '802', 4600, 1, 1, '1室1厅1卫', 56.00, '48', '8/18', 2, 1, '1,2,4,5', 'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg', '浦东热门小区，通勤方便，适合单身或情侣入住。', '王经理', '13900138821', '2034514861085626370', 2, 5, '5.2'),
('22000000000000000000000000000003', '星河湾南向三居', '21000000000000000000000000000003', '12', '1', '1601', 8600, 1, 2, '3室2厅2卫', 128.00, '112', '16/32', 2, 1, '1,2,3,4,5', 'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg', '南向大三居，视野开阔，适合家庭长租。', '陈经理', '13700138821', '2034514861085626370', 2, 5, '6.0');

INSERT IGNORE INTO news_article
(id, title, summary, content, cover_url, source, status, sort, publish_time)
VALUES
('23000000000000000000000000000001', '毕业季租房避坑指南', '毕业季看房前，先确认预算、通勤、押付方式和合同关键条款。', '毕业季租房需求集中，建议先明确预算上限和通勤半径，再预约实地看房。看房时重点核对房屋权属、家具家电清单、押付方式、维修责任和退租规则，签约前保留费用明细和沟通记录。', 'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg', '好客指南', 2, 30, '2026-06-10 09:00:00'),
('23000000000000000000000000000002', '多城优化租赁服务', '多地持续推进租赁备案、线上签约和房源核验服务。', '近期多地优化住房租赁服务流程，鼓励房源真实核验、合同线上签署和租赁备案线上办理。平台将持续完善房源审核能力，帮助租客更快识别真实、可租、可签约房源。', 'https://images.pexels.com/photos/8293778/pexels-photo-8293778.jpeg', '租房资讯', 2, 20, '2026-06-09 16:30:00'),
('23000000000000000000000000000003', '通勤半径怎么选', '热门商圈周边不一定最合适，通勤稳定性和生活配套同样重要。', '选择通勤半径时，可以综合地铁换乘次数、早晚高峰拥堵情况、周边餐饮便利度和夜间安全性。预算有限时，可优先选择一站换乘、配套成熟、房源稳定的小区。', 'https://images.pexels.com/photos/439391/pexels-photo-439391.jpeg', '城市生活', 2, 10, '2026-06-08 18:00:00');
