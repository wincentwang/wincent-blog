---
title: UNIX进程通信之有名管道与无名管道
date: 2018-02-28 15:07:11
tags: Unix
categories: Unix
description: UNIX进程通信之有名管道与无名管道。
---


## 无名管道:
``` c
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
int main(int argc, char **argv)
{
    int sfd,dfd,n,chan[2];
    char buff[1024];
    sfd=open("in.txt",O_RDONLY,0644);	// 输入文件
    dfd=open("out.txt",O_WRONLY|O_CREAT|O_TRUNC,0644);	// 输出文件
    pipe(chan);	    //open a pipe
    if(fork())  	//start a child process to send file
    {
        while((n=read(sfd,buff,1024))>0)
        {
            close(chan[0]);
            write(chan[1],buff,n);
            close(chan[1]);
        }
    }
    else  		//in father process, receive file
    {
        close(chan[1]);
        read(chan[0],buff,1024);
        write(dfd,buff,strlen(buff));
        close(chan[0]);
    }

    close(sfd);
    close(dfd);
    return 0;
}

```

## 有名管道:
``` c
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
int main(int argc, char **argv)
{
    int sfd,dfd,sp,dp,iofile;
    char buff[1024];
    sfd=open("in.txt",O_RDONLY,0644);
    dfd=open("out.txt",O_WRONLY|O_CREAT|O_TRUNC,0644);
    mknod("iofile",S_IFIFO|0666,0);	//name a pipe
    if(fork())
    {
        sp=open("iofile",O_WRONLY);
        while((n=read(sfd,buff,1024))>0)
            write(pp,buff,n);
        close(sp);
        close(sfd);
    }
    else
    {
        dp=open("iofile",O_RDONLY|O_NDELAY);
        while((n= read(dp,buff,1024))!=1)
            if(n==0) sleep(5);
            else write(df,buff,strlen(buff));
        close(dp);
        close(dfd);
    }
    return 0;
}
```

