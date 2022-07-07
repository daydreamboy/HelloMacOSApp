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



### (2) 常用UI组件



| 类                  | UI组件      | 作用                    |      |
| ------------------- | ----------- | ----------------------- | ---- |
| NSImageView         | 显示图片    |                         |      |
| NSProgressIndicator | loading组件 | 有2个样式：转圈和进度条 |      |
| NSSearchField       | 搜索框      |                         |      |
| NSTextView          | 显示文本框  |                         |      |







## 2、常见问题

### (1) MacOS app无法访问网络

新建的MacOS app工程，没有Info.plist文件可以设置，在App Sandbox设置[^1]，如下

<img src="images/01_turn_on_network.png" style="zoom:50%; float: left" />



Console报错提示，如下

```
networkd_settings_read_from_file Sandbox is preventing this process from reading networkd settings file at "/Library/Preferences/com.apple.networkd.plist", please add an exception.
```



https://www.jianshu.com/p/d7e96597bd1f



### (2)  NSProgressIndicator显示没有动画

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



解决方法

在entitlements文件中设置`com.apple.security.files.user-selected.read-only`为YES



## References

[^1]:https://stackoverflow.com/a/57292829
[^2]:https://stackoverflow.com/questions/14861373/indeterminate-nsprogressindicator-will-not-animate

