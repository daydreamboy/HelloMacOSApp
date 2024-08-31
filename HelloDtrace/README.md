# HelloDTrace

[TOC]

## 1、介绍DTrace

在MacOS上使用`man dtrace`命令，查看man文档描述，如下

> DTrace is a comprehensive dynamic tracing framework ported from Solaris. DTrace provides a powerful infrastructure that permits administrators, developers, and service personnel to concisely answer arbitrary questions about the behavior of the operating system and user programs.

简单来说，DTrace是从Solaris操作系统引入到MacO系统上的一个动态跟踪framework。它提供跟踪操作系统和用户程序的能力。



### (1) DTrace相关概念

#### a. probe



#### b. D语言



#### c. D脚本





## 2、dtrace命令常见用法

### (1) 查看系统调用个数

```shell
$ sudo dtrace -ln 'syscall:::entry' | wc -l
```







## References

