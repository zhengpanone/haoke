# haoke-manage
好客租房后端

```shell
# 构建镜像
docker build -t haoke-manage-api-server:v1.0.0 .

# 运行镜像
docker run -d \
  -p 28080:8080 \
  --name haoke-manager-api-server \
  haoke-manager-api-server:1.0.0
  
# tag镜像
docker tag haoke-manage-api-server:v1.0.0 localhost:32000/haoke-manage-api-server:v1.0.0

# 推送镜像
docker push localhost:32000/haoke-manage-api-server:v1.0.0

```

测试接口

```text
# 注册用户
curl -X POST "http://localhost:8080/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "123456",
    "confirmPassword": "123456",
    "email": "test@example.com",
    "phone": "13800138000",
    "captcha": "123456"
  }'

# 登录
curl -X POST "http://localhost:8080/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "123456"
  }'
```


```text
auth-service	认证中心
user-service	用户中心
house-service	房源中心
search-service	搜索中心
pay-service	支付中心
contract-service	合同中心
file-service	文件中心
message-service	消息中心
gateway-service	网关服务
```

### 角色
超级管理员
平台运营
房东
租客
客服

### 数据权限
全部数据
本机构数据
本人数据

### 推荐扩展功能
AI 智能推荐房源
地图找房
VR 看房
IM 在线聊天
智能客服
电子合同
人脸认证
实名认证
微信小程序
APP 端


### 好客租房系统 API 接口设计文档》，

包含：

用户认证
房源管理
小区管理
收藏/浏览历史
合同管理
支付模块
消息通知
权限系统
后台统计
Elasticsearch 搜索
Redis 缓存
Banner 广告
日志管理
数据字典
微服务拆分
数据库表设计建议
安全方案
Kubernetes/K3s 部署建议