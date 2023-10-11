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

可以在XIB中配置一个菜单按钮，用于检查更新。

这里使用代码方式作为示例，如下

```swift
import Sparkle

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    lazy var updaterController: SPUStandardUpdaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.setupCheckForUpdates()
	      ...
    }
  
    // MARK:
    func setupCheckForUpdates() -> Void {
        self.checkForUpdatesItem.target = self.updaterController
        self.checkForUpdatesItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
    }
}
```

这里懒加载初始化SPUStandardUpdaterController对象，将让AppDelegate对象持有它，这个对象用于响应菜单checkForUpdatesItem的点击事件。





### (3) 配置Info.plist

Sparkle提供一些自定义Key可以配置在Info.plist中，官方文档见：https://sparkle-project.org/documentation/customization/。这里介绍一些必要和常用的key。



#### a. 配置SUPublicEDKey (必填)

EdDSA的公钥，使用generate_keys工具可以生成。

在Pods中找到Sparkle文件夹，如下

```shell
$ cd path/to/HelloSparkle/Pods/Sparkle
$ ./bin/generate_keys 
Generating a new signing key. This may take a moment, depending on your machine.
A key has been generated and saved in your keychain. Add the `SUPublicEDKey` key to
the Info.plist of each app for which you intend to use Sparkle for distributing
updates. It should appear like this:

    <key>SUPublicEDKey</key>
    <string>gV2YaGTVamTS2dlFbt0dzuNFNHwHwWEhPnSzX2fzj3A=</string>
```



#### b. 配置SUEnableAutomaticChecks (可选)

不配置SUEnableAutomaticChecks，默认会自动出现一个提示框，让用户选择是否自动检查更新，如下

<img src="images/01_enable_auto_update.png" style="zoom:50%; float:left;" />

可以设置SUEnableAutomaticChecks=YES，让应用程序默认自动检查更新，则不会有这个提示框。





## 2、常见问题

### (1) Xcode Console提示Serving updates without an EdDSA key and only using Apple Code Signing is deprecated and may be unsupported in a future release.

Xcode Console提示，如下

```shell
2023-10-11 11:49:49.849844+0800 HelloSparkle[30734:244100] [Sparkle] Error: Serving updates without an EdDSA key and only using Apple Code Signing is deprecated and may be unsupported in a future release. Visit Sparkle's documentation for more information: https://sparkle-project.org/documentation/#3-segue-for-security-concerns
```

解决方法：Info.plist缺少SUPublicEDKey，添加这个key





## References

[^1]:https://github.com/sparkle-project/Sparkle
[^2]:https://sparkle-project.org/documentation/









