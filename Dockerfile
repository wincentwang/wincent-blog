FROM node:14

# 创建一个工作目录
WORKDIR /app

# 将当前目录内容复制到工作目录中
COPY . /app

# 安装依赖
RUN npm install --production

# 暴露端口（通常是4000，如果你更改了端口，请相应修改）
EXPOSE 4000

# 启动服务
CMD ["npm", "start"]
