# HelloMacOSApp
[TOC]

## 1、使用AppKit

### (1) Class Hierarchy 

NSWindowController

NSViewController

NSSplitViewController

NSTabViewController

TODO



NSTableView

https://medium.com/@kicsipixel/very-simple-view-based-nstableview-in-swift-5-using-model-134c5f4c12ee



add constraints

https://stackoverflow.com/a/66386655

https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithConstraintsinInterfaceBuidler.html



AppKit

https://developer.apple.com/documentation/appkit



file/direcotry picker

https://ourcodeworld.com/articles/read/1117/how-to-implement-a-file-and-directory-picker-in-macos-using-swift-5



TODO

https://developer.apple.com/library/archive/samplecode/SearchField/Introduction/Intro.html#//apple_ref/doc/uid/DTS10004112



nstokenfield

https://developer.apple.com/documentation/appkit/nstokenfield



NSTextField

https://medium.com/bpxl-craft/styling-nstextfield-a-guide-for-designers-8280da794263



Interface Builder 

cocoa coordinate

https://stackoverflow.com/questions/9474943/what-does-the-origin-control-do-in-interface-builder



// Alternative Rows

https://stackoverflow.com/a/17245860



## 2、常用UI组件

| 类                  | UI组件      | 作用                    |      |
| ------------------- | ----------- | ----------------------- | ---- |
| NSImageView         | 显示图片    |                         |      |
| NSProgressIndicator | loading组件 | 有2个样式：转圈和进度条 |      |
| NSSearchField       | 搜索框      |                         |      |
| NSTextField         | 文本框      |                         |      |
| NSTextView          | 文本框      |                         |      |
| WKWebView           | Web容器     |                         |      |



### (1) NSTextField

NSTextField限制某些字符不能输入。

举个例子[^6]，如下

```swift
class IntegerFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool{
        
        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }

        // Actual check
        if Int(partialString) != nil {
            return true
        }
        else {
            // @see https://stackoverflow.com/questions/41668688/no-beeping-with-nsbeep
            NSSound.beep()
            return false
        }
    }
}

someTextField.formatter = IntegerFormatter()
```





## 3、常用非UI组件





## 4、常见问题

### (1) MacOS app无法访问网络

Console报错提示，如下

```
networkd_settings_read_from_file Sandbox is preventing this process from reading networkd settings file at "/Library/Preferences/com.apple.networkd.plist", please add an exception.
```



新建的MacOS app工程，没有Info.plist文件可以设置，在App Sandbox设置[^1]，如下

<img src="images/01_turn_on_network.png" style="zoom:50%; float: left" />

* 勾选Incoming Connections或Outgoing Connections[^8]
* 设置Allow Arbitrary Loads为YES



### (2) NSProgressIndicator显示没有动画

解决方法：将Drawing勾选Hidden[^2]，如下

<img src="images/02_solve_NSProgressIndicator_not_animate.png" style="zoom:50%; float: left" />



如果是使用代码实现，则设置如下

```objective-c
- (IBAction)startAction:(id)sender {
    [progressBar setHidden:NO];
    [progressBar setIndeterminate:YES];
    [progressBar setUsesThreadedAnimation:YES];
    [progressBar startAnimation:nil];
}
```



### (3) 使用NSOpenPanel出现crash

使用NSOpenPanel出现crash，如下

```
[OpenSavePanels] ERROR: Unable to display open panel: your app is missing the User Selected File Read app sandbox entitlement. Please ensure that your app's target capabilities include the proper entitlements.
```



解决方法:

在entitlements文件中设置`com.apple.security.files.user-selected.read-only`为YES



### (4) 给toolbar添加item时出现warning

给toolbar添加item时出现warning，如下

```
[NSToolbarItem] NSToolbarItem.minSize and NSToolbarItem.maxSize methods are deprecated. Usage may result in clipping of items. It is recommended to let the system measure the item automatically using constraints.
```



解决方法:

选中toolbar item，在size Inspector中设置Size为Automatic[^3]



### (5) 如何给NSViewController设置背景颜色[^4]

示例代码，如下

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    self.view.wantsLayer = true

    if self.view.layer != nil {
        let color : CGColor = CGColor(red: 1.0, green: 0, blue: 0, alpha: 1.0)
        self.view.layer?.backgroundColor = color
    }
}
```

说明

> Xcode13 + Swift 5



### (6) 设置WKWebView背景透明

示例代码[^5]，如下

```swift
self.webView.setValue(false, forKey: "drawsBackground")
```



### (7) 执行`-[NSObject performSelector:withObject:afterDelay:]`可能没有生效

参考这篇[SO](https://stackoverflow.com/questions/21687774/mac-os-console-application-performselectorwithobjectafterdelay-doesnt-work)，可以换成dispatch_after的方式





## 5、Xcode编译问题

### (1) ld: file not found: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_macosx.a

在Xcode14上最低支持macOS 10.13，通过macOS Deployment Target的列表找到该最小版本

解决方法：设置target的版本为macOS 10.13以及以上



## 6、配置Capability

### (1) 访问Downloads文件夹

在Xcode的Signing & Capabilities > Downloads Folder，选择Read/Write[^7]。在第一次运行app，系统会提示访问。



## References

[^1]:https://stackoverflow.com/a/57292829
[^2]:https://stackoverflow.com/questions/14861373/indeterminate-nsprogressindicator-will-not-animate

[^3]:https://developer.apple.com/forums/thread/667695
[^4]:https://stackoverflow.com/questions/26553444/swift-nsviewcontroller-background-color-mac-app

[^5]:https://stackoverflow.com/questions/27211561/transparent-background-wkwebview-nsview

[^6]:https://stackoverflow.com/questions/12161654/restrict-nstextfield-to-only-allow-numbers

[^7]:https://stackoverflow.com/questions/50200377/how-to-create-a-directory-in-downloads-folder-with-swift-on-macos-permission-ex

[^8]:https://www.jianshu.com/p/d7e96597bd1f

