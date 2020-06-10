---
title: Hexo with HexoClient
tags: []
categories:
  - Hexo
toc: false
date: 2020-01-08 16:44:35
---

### Hexo

##### 1.1 Apply Github Account

[Git](https://github.com)

* Create a repositories named your_username.github.io
* set your github like page
* download a theme which you like or you can custome by yourself 


##### 1.2 Install Nodejs & Npm

[Nodejs](http://nodejs.cn/)

##### 1.3 Install Hexo
``` nodejs
npm install -g hexo
hexo init 
npm install hexo-deployer-git --save
```

#### 1.4 Apply Domain with CNAME

* [Tencent Cloud](https://cloud.tencent.com/)

* [Ali Cloud](https://www.aliyun.com/)

### Hexo Client

[Hexo Client Github](https://github.com/gaoyoubo/hexo-client)

```
git clone https://github.com/gaoyoubo/hexo-client/releases
# install dependencies
npm install
# dev
npm run electron:serve
# build electron application for production
npm run electron:build
```



