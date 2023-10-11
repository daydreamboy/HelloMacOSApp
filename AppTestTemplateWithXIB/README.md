# AppTestTemplateWithXIB

[TOC]

## 1、介绍

MacOS app template project for multiple demos



## 2、使用方式

新建一个MacOS app工程，copy下面文件到新工程。如果新工程，已有文件，则覆盖文件

```shell
$ tree .
.
├── AppDelegate.swift
├── Base.lproj
│   └── MainMenu.xib
├── Classes
│   ├── Demo1WindowController.swift
│   └── Demo2WindowController.swift
└── UI
    ├── Demo1WindowController.xib
    └── Demo2WindowController.xib
```

几个修改步骤，如下

* 删除Main.storyboard文件，设置INFOPLIST_KEY_UIMainStoryboardFile为空
* 设置INFOPLIST_KEY_NSMainNibFile=MainMenu，即设置应用菜单为MainMenu.xib
* 设置INFOPLIST_KEY_NSMainStoryboardFile为空

