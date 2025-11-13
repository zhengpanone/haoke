-- 楼盘数据表
CREATE TABLE `estate`
(
    id               varchar(32) PRIMARY KEY COMMENT '楼盘id',
    name             VARCHAR(10) COMMENT '楼盘名称',
    province         VARCHAR(10) COMMENT '所在省',
    city             VARCHAR(10) COMMENT '所在市',
    area             VARCHAR(10) COMMENT '所在区',
    address          VARCHAR(255) COMMENT '具体地址',
    year             VARCHAR(10) COMMENT '建筑年代',
    type             VARCHAR(10) COMMENT '建筑类型',
    property_cost    VARCHAR(10) COMMENT '物业费',
    property_company VARCHAR(20) COMMENT '物业公司',
    developers       VARCHAR(20) COMMENT '开发商',
    created          DATETIME COMMENT '创建时间',
    updated          DATETIME COMMENT '更新时间'
) COMMENT ='楼盘数据表';

-- 房源数据表
CREATE TABLE `house_resources`
(
    id                 varchar(32) PRIMARY KEY COMMENT '房源id',
    title              VARCHAR(20) COMMENT '房源标题，如：南北通透，两室朝南，主卧带阳台',
    estate_id          BIGINT COMMENT '楼盘id',
    building_num       VARCHAR(5) COMMENT '楼号（栋）',
    building_unit      VARCHAR(5) COMMENT '单元号',
    building_floor_num VARCHAR(5) COMMENT '门牌号',
    rent               INT COMMENT '租金',
    rent_method        tinyint(1) COMMENT '租赁方式，1-整租，2-合租',
    payment_method     tinyint(1) COMMENT '支付方式，1-付一押一，2-付三押一，3-付六押一，4-年付押一，5-其它',
    house_type         VARCHAR(50) COMMENT '户型，如：2室1厅1卫',
    covered_area       VARCHAR(10) COMMENT '建筑面积',
    use_area           VARCHAR(10) COMMENT '使用面积',
    floor              VARCHAR(50) COMMENT '楼层，如：8/26',
    orientation        INT COMMENT '朝向：东、南、西、北',
    decoration         tinyint(1) COMMENT '装修，1-精装，2-简装，3-毛坯',
    facilities         VARCHAR(500) COMMENT '配套设施，如：1,2,3',
    pic                VARCHAR(200) COMMENT '图片，最多5张',
    house_desc         TEXT COMMENT '房源描述',
    contact            varchar(10) COMMENT '联系人',
    mobile             varchar(11) comment '手机号',
    time               tinyint(1) comment '看房时间，1-上午、2-中午、3-下午、4-晚上、5-全天',
    property_cost varchar(10) comment '物业费',
    created          DATETIME COMMENT '创建时间',
    updated          DATETIME COMMENT '更新时间'

) COMMENT '房源数据表';
