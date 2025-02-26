## threejs or doker

### docker

1. 打包本地项目 `npm run build`
2. 项目根目录新建 `Dockerfile` 文件

```dockerfile
# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx:alpine

# 将本地的 dist 目录复制到容器中的 /usr/share/nginx/html 目录
COPY dist/ /usr/share/nginx/html

# (可选) 在项目根目录下创建 nginx.conf 文件：dockerfile增加如下
# 复制本地的 nginx.conf 文件到容器中的 /etc/nginx/conf.d/default.conf 目录
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 80 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
```

3. 构建镜像并运行容器

- -t my-app：指定镜像的名称，. 表示当前目录 Dockerfile 文件

```bash
docker build -t my-app .
```

4. 运行容器

- -p 8080:80：将容器的 8080 端口映射到主机的 80 端口
- -d 后台运行容器
- --name my-container：指定容器的名称
- my-app：指定要运行的镜像名称

```bash
docker run -d -p 8080:80 --name my-container my-app
```

5. 访问容器 [http://localhost:8080]

### docker 常用命令

```bash
# 拉取nginx最新镜像
docker pull nginx:latest

# 查看本地所有的镜像
docker images

# 删除本地nginx镜像
docker rmi nginx:latest

# 构建my-app镜像
docker build -t my-app .

# 运行一个my-app容器，取名叫做my-container，-d后台运行
# 将容器的 8080 端口映射到主机的 80 端口
docker run -d -p 8080:80 --name my-container my-app

# 查看所有容器（-a 包括停止的）
docker ps -a

# 启动my-container容器
docker start my-container

# 停止my-container容器
docker stop my-container

# 删除my-container容器
docker rm my-container

# 查看资源使用情况
docker stats
```
