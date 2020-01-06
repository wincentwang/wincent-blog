---
title: UNIX文件系统调用与文件库函数调用对比
date: 2018-02-28 15:07:11
tags: Unix
categories: Unix
description: UNIX文件系统调用与文件库函数调用对比。
---

## 概述:
>分别使用文件的系统调用read(fd, buf, nbytes), write(fd, buf, nbytes)和文件的库函数fread(buf, size, nitems, fp),fwrite(buf, size, nitems, fp)，编写一个文件的复制程序。

## 目的:
>文件的系统调用和文件的库函数在底层,前者每次读写都需要进入核心态操作,文件的库函数增加了Buffer减少了进入核心态的次数。

## Code:

``` c
#include <stdio.h>
#include <time.h>
#include <string.h>
#include <fcntl.h>
/*copy file , if way ==1, use read/write, else use fread/fwrite, at the same time, it counts time consumed*/
int mycopy(int way, int step)
{
    time_t start_tm, stop_tm;
    FILE *srcf,*destf;
    char buff[4096];
    int i, sfd,dfd;
    time(&start_tm);  //获得起始时间
    for (i=0; i<1024; i=i+step)
    {
        if(way==1)
        {
            sfd=open("in.txt",O_RDONLY,0644);  // 输入文件
            dfd=open("out.txt",O_WRONLY|O_CREAT|O_TRUNC,0644);
            // 输出文件
            read(sfd,buff,step);
            write(dfd,buff, step);
            close(sfd);
            close(dfd);
        }
        else
        {
            srcf=fopen("in.txt","r");
            destf=fopen("out.txt","w");
            fread(buff,step*sizeof(char),1,srcf);
            fwrite(buff,step*sizeof(char),1,destf);
            close(srcf);
            close(destf);
        }
    }
    time(&stop_tm);  // 获得结束时间
    printf("\ntime used for copy file by means of %s,%d byte per time: %ds", 
	way?"read,write":"fread,fwrite",step,(int)(stop_tm-start_tm));
    //print information for testing
    return 0;
}

int main (int argc, char **argv)
{
    /*当上述函数中nbytes, size和nitems都取值为1时（即一次读写一个字节），比较这两种程序的执行效率。*/
    if (mycopy (1,1))
        return 1;
    if (mycopy (0,1))
        return 1;
    /*当nbytes取1024字节，size取1024字节，且nitems取1时（即一次读写1024字节），再次比较这两种程序的执行效率。*/
    if (mycopy (1,1024))
        return 1;
    if (mycopy (0,1024))
        return 1;
    return 0;
}



```
