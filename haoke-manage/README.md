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