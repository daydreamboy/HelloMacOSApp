# HelloSparkle

[TOC]

## 1、介绍Sparkle

Sparkle是macOS上一个更新软件的框架。官方文档描述[^1]，如下

> Secure and reliable software update framework for macOS.

github地址：https://github.com/sparkle-project/Sparkle

使用文档：https://sparkle-project.org/documentation/



### (1) 安装Sparkle

Sparkle支持下面几种集成方式，如下

* SPM (Swift Package Manager)
* CocoaPods
* Carthage
* 手动集成（Xcode工程内置framework）

这里以CocoaPods集成为例

在Podfile中，设置如下

```ruby
source 'https://cdn.cocoapods.org/'

platform :osx, '11.0'

target 'HelloSparkle' do
  pod 'Sparkle', '2.1.0'
end
```

使用静态库或动态库集成都可以。



### (2) 设置SPUStandardUpdaterController

参考官方文档[^2]的步骤，如下

> - Open up your MainMenu.xib.
> - Choose View › Show Library…
> - Type “Object” in the search field under the object library and drag an Object into the left sidebar of the document editor.
> - Select the Object that was just added.
> - Choose View › Inspectors › Identity.
> - Type `SPUStandardUpdaterController` in the Class box of the Custom Class section in the inspector.
> - If you’d like, make a “Check for Updates…” menu item in the application menu; set its target to the `SPUStandardUpdaterController` instance and its action to `checkForUpdates:`.





(3) 



## 2、常见问题

### (1) Xcode Console提示Serving updates without an EdDSA key and only using Apple Code Signing is deprecated and may be unsupported in a future release.



```shell
2023-10-11 11:49:49.849844+0800 HelloSparkle[30734:244100] [Sparkle] Error: Serving updates without an EdDSA key and only using Apple Code Signing is deprecated and may be unsupported in a future release. Visit Sparkle's documentation for more information: https://sparkle-project.org/documentation/#3-segue-for-security-concerns
```





## References

[^1]:https://github.com/sparkle-project/Sparkle
[^2]:https://sparkle-project.org/documentation/









