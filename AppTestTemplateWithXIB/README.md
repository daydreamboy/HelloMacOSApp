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



## 3、是否使用Info.plist自动生成

方式一：使用Info.plist文件

AppTestTemplateWithXIB默认关闭Info.plist自动生成，即设置GENERATE_INFOPLIST_FILE=NO。同时，在工程下面有一个Info.plist文件，并设置INFOPLIST_FILE=AppTestTemplateWithXIB/Info.plist。

方式二：使用Info.plist自动生成

如果使用Xcode默认模板，会使用Info.plist自动生成的方式。

使用哪种方式，决定具体需求。例如是否自动化修改Info.plist的内容等。











