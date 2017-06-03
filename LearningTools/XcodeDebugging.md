
# Xcode Debugging

> 你的代码，或者任何人的代码中总会有bug存在，**你可以把调试看做是更好地理解代码的一种方式** —— By Advanced_Apple_Debugging_&_Reverse_Engineering_v0.9.5
    
## The Debugging Process

1. Reproduce the problem
> if you cannot reproduce the problem, then you (probably) do not understand it.


2. Gather Debug Information
> Logs, program, state,...
> What is the value of a variable?
> What kind of error?(ex.EXC_BAD_ACCESS)
> What line of code caused the error?
> Which functions or methods led to the error?

3. Form a Hypothesis


4. Try a fix
> Maximize the information gained per fix!


![](http://oc98nass3.bkt.clouddn.com/2017-05-21-14953337356733.jpg)


### Print Debugging

![](http://oc98nass3.bkt.clouddn.com/2017-05-21-14953347612931.jpg)


#### LLDB


##### Print variable frame
` frame variable`
` fr v`

##### Expression命令
expression命令的作用是执行一个表达式，并将表达式返回的结果输出。expression的完整语法是这样的：

Objective-C

expression <cmd-options> -- <expr>
1
expression <cmd-options> -- <expr>

说expression是LLDB里面最重要的命令都不为过。因为他能实现2个功能。

执行某个表达式。 我们在代码运行过程中，可以通过执行某个表达式来动态改变程序运行的轨迹。 假如我们在运行过程中，突然想把self.view颜色改成红色，看看效果。我们不必写下代码，重新run，只需暂停程序，用expression改变颜色，再刷新一下界面，就能看到效果
Objective-C

  // 改变颜色
`  (lldb) expression -- self.view.backgroundColor = [UIColor redColor]`
  // 刷新界面
`  (lldb) expression -- (void)[CATransaction flush]`
将返回值输出。 也就是说我们可以通过expression来打印东西。 假如我们想打印self.view：
Objective-C

    (lldb) expression -- self.view
    (UIView *) $1 = 0x00007fe322c18a10
    
    (lldb) expression -- self.view
    (UIView *) $1 = 0x00007fe322c18a10



##### BreakPoint

![](http://oc98nass3.bkt.clouddn.com/2017-05-23-14955445977510.jpg)


###  Xcode Debugging Hotkeys
>Here is a listing of Xcode hotkeys (related to debugging) we mentioned in this course. Let us know if we missed any!

```
Show Navigator (⌘+0)
Show Debug Navigator (⌘+6)
Show Breakpoint Navigator (⌘+7)
Show Debug Area (⌘+Shift+Y)
Open Documentation (⌘+Shift+0)
Step Over (F6)
Step Into (F7)
Step Out (F8)
Continue (⌘+Ctrl+Y)
Build (⌘+B)
Run (⌘+R)
Activate/Deactivate Breakpoint (⌘+Y)
Quick Search (⌘+Shift+O)
```

[Xcode Debugging Hotkeys](https://classroom.udacity.com/courses/ud774/lessons/4388088536/concepts/44197787450923)


## TOOL

### Icon Injection Plugin for Xcode

[Icon Injection Plugin for Xcode](https://github.com/johnno1962/injectionforxcode#user-content-use-with-appcode)

![Icon Injection Plugin for Xcode ](http://oc98nass3.bkt.clouddn.com/2017-06-03-Icon Injection Plugin for Xcode .gif)

> 一个Xcode的插件，让你在改完代码后无需重新运行Xcode就可以看到效果。

将需要调试的代码写到`injected`这个方法中，然后在和这个方法中设置一个断言，使用`Ctr + =`,即会停在这个断言里，每次修改，使用一下`Ctr + =`就会重新注入，释放断言就可以看到效果。

```
- (void)injected
{
    NSLog(@"I've been injected: %@", self);
}
```
**注意**

```
- (void)injected as an instance method, which gives you the chance to re-update an object with new contexts.
+ (void)injected as a class method, making it possible to update globals with new information
Listening for INJECTION_BUNDLE_NOTIFICATION, allowing other classes to listen out for injection calls, this is useful for providing app level changes.

```
**原理**

它通过解析应用程序的生成日志来确定源文件是如何最后编译的。用这个包将重新编译成一个`bundle`，该`bundle`使用动态加载程序注入应用程序。现在在`bundle`中就有两个版本，原版本和新的修改版本。修改后的版本是“调和”在原版本发生变化。

## LLDB

>A cheatsheet for commands and ideas on how to use LLDB.

List all commands and aliases.


`(lldb) help po`


`(lldb) help break set`


`(lldb) apropos step-in`








`   (lldb) image lookup -rn 'UIViewController\ set\w+:\]'`


`(lldb) image lookup -rn . Security`
Look up all code located within the Security module. 


`(lldb) image lookup -a 0x10518a720`


`(lldb) image lookup -s mmap`


















`(lldb) rbreak viewDid -s SwiftRadio`














`(lldb) expression -lswift -O -- UIApplication.shared`
Print the shared UIApplication instance in a Swift context.


 Advanced Apple Debugging & Reverse Engineering Appendix A: LLDB Cheatsheet (lldb) expression -u0 -O -- [UIApplication test]
 Advanced Apple Debugging & Reverse Engineering
Advanced Apple Debugging & Reverse Engineering Appendix A: LLDB Cheatsheet


## 参考

[The Debugging Process](https://classroom.udacity.com/courses/ud774/lessons/4377638660/concepts/43903186280923)

[Advanced Apple Debugging & Reverse Engineering](https://videos.raywenderlich.com/courses/82-rwdevcon-2017-vault-workshops/lessons/1)

[Debugging in Xcode2012](https://developer.apple.com/videos/play/wwdc2012/412/)

[What's New in LLDB 2015](https://developer.apple.com/videos/play/wwdc2015/402/)

#### LLDB

[小笨狼与LLDB的故事](http://www.jianshu.com/p/e89af3e9a8d7)
