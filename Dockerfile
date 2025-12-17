# 基础镜像：指定 Node 版本（推荐 LTS 版，如 20-alpine 轻量化）
FROM node:16

# 设置工作目录
WORKDIR /app

# 安装 Hexo 核心及-cli（全局安装）
RUN npm install -g hexo-cli

# 复制本地配置和源码（先复制依赖文件，利用 Docker 缓存）
COPY package.json package-lock.json* /app/
RUN npm install --production

# 复制所有源码
COPY . /app

# 暴露 Hexo 预览端口
EXPOSE 4000

# 默认命令：启动 Hexo 服务
CMD ["hexo", "server", "-i", "0.0.0.0"]
~                                         