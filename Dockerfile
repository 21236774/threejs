# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx:latest

# 将本地的 dist 目录复制到容器中的 /usr/share/nginx/html 目录
COPY dist/ /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 80 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]