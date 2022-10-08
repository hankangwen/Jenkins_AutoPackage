# Jekins_AutoPackage
基于Jenkins的Unity自动化打包。

> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [blog.csdn.net](https://blog.csdn.net/linxinfa/article/details/118816132)

### 文章目录

*   *   *   [一、前言](#_2)
        *   [二、Jenkins 简介](#Jenkins_10)
        *   [三、Jenkins 的下载与安装](#Jenkins_24)
        *   *   [1、JDK 下载与安装](#1JDK_25)
            *   [2、Jenkins 下载](#2Jenkins_34)
            *   [3、Jenkins 安装](#3Jenkins_44)
            *   [4、Jenkins 初始化](#4Jenkins_62)
        *   [四、Jenkins 的基本操作](#Jenkins_81)
        *   *   [1、关闭 Jenkins](#1Jenkins_82)
            *   *   [1.1、方式一：暴力杀进程（不推荐）](#11_83)
                *   [1.2、方式二：以管理员身份执行 net stop jenkins](#12_net_stop_jenkins_87)
                *   [1.3、方式三：通过 jenkins.exe 来关闭，jenkins stop](#13jenkinsexejenkins_stop_105)
            *   [2、启动 Jenkins](#2Jenkins_110)
            *   *   [2.1、方式一：以管理员身份执行 net start jenkins](#21_net_start_jenkins_111)
                *   [2.2、方式二：通过 jenkins.exe 来启动，jenkins start](#22jenkinsexejenkins_start_114)
            *   [3、修改端口号](#3_121)
            *   [4、新建账号](#4_128)
            *   [5、修改密码](#5_144)
            *   [6、安装插件](#6_149)
            *   *   [6.1、方式一：通过 Manage Plugins 安装（需要科学上网）](#61Manage_Plugins_150)
                *   [6.2、方式二：CLI 命令行安装（需要科学上网）](#62CLI_155)
                *   [6.3、方式三：离线环境安装插件](#63_189)
            *   [7、创建并执行任务：Hello World](#7Hello_World_197)
            *   [8、执行带参数的任务](#8_223)
            *   [9、执行 python 任务](#9python_239)
            *   [10、周期性触发执行任务](#10_251)
        *   [五、实战：Unity + Jenkins](#Unity__Jenkins_319)
        *   *   [1、Unity Demo 工程](#1Unity_Demo_326)
            *   *   [1.1、创建 Demo 工程](#11Demo_327)
                *   [1.2、切换 Android 平台](#12Android_332)
                *   [1.3、设置 JDK、Android SDK、Gradle](#13JDKAndroid_SDKGradle_335)
                *   [1.4、设置包名](#14_338)
                *   [1.5、测试打包](#15_341)
            *   [2、编写 Editor 打包工具](#2Editor_346)
            *   *   [2.1、Editor 打包工具代码](#21Editor_347)
                *   [2.2、执行 Editor 打包工具菜单](#22Editor_374)
            *   [3、命令行调用 Unity 静态函数：打包函数](#3Unity_379)
            *   *   [3.1、Unity 命令行模式](#31Unity_380)
                *   [3.2、命令参数解释](#32_397)
                *   [3.3、批处理脚本](#33_442)
                *   [3.4、Unity 打包工具接收命令行参数](#34Unity_523)
            *   [4、Jenkins 调用 bat 脚本](#4Jenkinsbat_595)
            *   [5、拓展：python 加强版脚本](#5python_620)
        *   [六、完毕](#_704)

### 一、前言

 前几天我写了一篇文章，[【游戏开发进阶】教你自制离线 Maven 仓库，实现 Unity 离线环境使用 Gradle 打包（Unity | Android | 谷歌 | Gradle）](https://linxinfa.blog.csdn.net/article/details/118553713)，里面我提到了`Unity`使用`Jenkins`实现自动化打包，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_9_20210716185404460.png)  
不过那篇文章中我只是一笔带过，没有细说具体操作流程。今天，我就专门写一篇关于`Unity`通过`Jenkins`实现自动化打包的教程吧~

特别说明：  
我的电脑系统环境是`Windows 10`，所以下面的操作环境都是在`Windows 10`系统下的。

### 二、[Jenkins](https://so.csdn.net/so/search?q=Jenkins&spm=1001.2101.3001.7020) 简介

相信很多人都知道`Jenkins`，不过为了照顾萌新，我这里还是简单说下`Jenkins`是什么。

`Jenkins`官网：[https://www.jenkins.io/](https://www.jenkins.io/)

`Jenkins`是一个开源软件项目，是基于`Java`开发的一个持续集成工具（`CI`），具有友好的操作界面，主要用于持续、自动的构建 / 测试软件项目、监控外部任务的运行。它可以在`Tomcat`等流行的`servlet`容器中运行，也可独立运行。通常与版本管理工具（`SCM`）、构建工具结合使用。常用的版本控制工具有`SVN`、`GIT`，构建工具有`Maven`、`Ant`、`Gradle`。

> 注：  
> **什么是集成？**  
> 代码由编译、发布和测试、直到上线的一个过程。  
> **什么是持续集成？**  
> 高效的、持续性的不断迭代代码的集成工作。

这样讲好像也不是很直观，没关系，它就是一个工具，我们学会使用它就好，下面我来一步步教大家如何使用`Jenkins`。

### 三、Jenkins 的下载与安装

Port : 8080

Username : hankangwen

Passwoed : kerven

full name : 韩康文

<img src="https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_6_33_image-20221008100633113.png" alt="image-20221008100633113" style="zoom:150%;" />

#### 1、JDK 下载与安装

因为`Jenkins`是基于`Java`开发的，要运行`Jenkins`需要`Java`环境，即`JDK`，所以我们需要先安装下`JDK`。  
`JDK`下载：[https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)  
根据你的系统环境选择对应的`JDK`下载，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_1_3_20210717140404530.png)  
下载下来后双击即可执行安装，安装过程没什么，这里就不啰嗦了。  
安装完毕后，配置一下`JDK`的 **环境变量**。  
最后在[命令行](https://so.csdn.net/so/search?q=%E5%91%BD%E4%BB%A4%E8%A1%8C&spm=1001.2101.3001.7020)中输入`java -version`，如果能正常输出版本号，则说明`JDK`环境弄好了。  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_9_20210717140802689.png)

#### 2、Jenkins 下载

进入`Jenkins`官网：[https://www.jenkins.io/](https://www.jenkins.io/)  
点击`Download`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_9_20210716190759704.png)  
根据你的系统和环境选择对应的安装包，因为我是`Windows`系统，所以我下载`Windows`版的安装包，  
![](https://img-blog.csdnimg.cn/20210717154315652.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
下载下来是一个`msi`文件，  
![](https://img-blog.csdnimg.cn/2021071619083516.png)

#### 3、Jenkins 安装

双击`jenkins.msi`，执行安装，设置一下安装路径，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_10_20210716191015864.png)  
选择`Run service as LocalSystem`（即使用本地系统账号）  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_10_2021071619110790.png)  
设置端口号，比如我设置为`8075`，然后点击`Test Port`按钮测试一下端口有没有被占用，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_10_20210716191209720.png)  
确认端口没被占用后，点击`Next`，  
![](https://img-blog.csdnimg.cn/20210716191231265.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
设置`JDK`所在的路径，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210716191313486.png)  
继续`Next`，  
![](https://img-blog.csdnimg.cn/20210716191338152.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
点击`Install`开始安装，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210716191357144.png)  
注意，安装过程中可能会弹出`360`提醒，选择允许即可。  
完整完毕，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210716191425554.png)

#### 4、Jenkins 初始化

上面安装完毕后会自动启动`Jenkins`服务，我们可以在任务管理器中看到一个`Java`的进程，它就是`Jenkins`的服务进程。  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210717160100446.png)  
我们在浏览器中访问 `http://localhost:8075`，此时会显示需要解锁`Jenkins`，如下  
![](https://img-blog.csdnimg.cn/20210716192330235.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
我们找到这个`initialAdminPassword`文件，使用文本编辑器打开它，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210717155013813.png)  
可以看到里面是一串密码，我们复制它，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210716192217731.png)  
回到浏览器页面中，在管理员密码栏中粘贴刚刚的密码，然后点击继续，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_12_20210716192419194.png)  
接下来是插件安装界面，因为`Jenkins`插件的下载需要翻墙，所以如果你可以科学上网，则点击`安装推荐的插件`，当然也可以先不安装插件，后续有需要再安装对应的插件即可，  
![](https://img-blog.csdnimg.cn/20210716192524835.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
如果是离线环境（比如内网环境），则点击跳过插件安装（下文我会教如何在离线环境下安装插件），  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_13_20210717155437364.png)  
接着创建管理员账号，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_13_20210717155643358.png)  
完成，进入`Jenkins`主页，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_13_20210717155932260.png)

### 四、Jenkins 的基本操作

#### 1、关闭 Jenkins

##### 1.1、方式一：暴力杀进程（不推荐）

上面我们说到，在任务管理器中可以看到一个`Java`进程，它就是`Jenkins`的服务进程，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_11_20210717160100446.png)  
如果你直接暴力杀掉这个`Java`进程，那么`Jenkins`也就关闭了，不过不建议这么做。

##### 1.2、方式二：以管理员身份执行 net stop jenkins

以管理员身份运行命令`net stop jenkins`，如下（我是使用管理员身份运行`PowerShell`来执行命令的）  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_13_20210717161836443.png)

> 注意，如果你不是以管理员身份执行上面的命令，则会提示`发生系统错误 5`  
> 如下（普通账号权限下通过`cmd`执行命令）  
> ![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_13_20210717160950998.png)  
> **如何以管理员身份运行 cmd？**  
> 进入`cmd`所在目录：  
> `C:\Users\linxinfa\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools`  
> ![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_14_20210717161359421.png)  
> 右键`命令提示符`，点击`以管理员身份运行`即可，  
> ![](https://img-blog.csdnimg.cn/20210717161312139.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
> 如果觉得麻烦的话，也可以直接在系统的开始菜单那里直接以管理员身份运行`PowerShell`，  
> ![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_14_202107171617046.png)

##### 1.3、方式三：通过 jenkins.exe 来关闭，jenkins stop

进入`Jenkins`的安装目录，如下，  
![](https://img-blog.csdnimg.cn/20210717162138554.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
在地址栏输入`cmd`，然后执行`jenkins stop`，如下，与上面的效果是一样的，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_14_20210717162608912.gif)

#### 2、启动 Jenkins

##### 2.1、方式一：以管理员身份执行 net start jenkins

以管理员身份执行命令`net start jenkins`，如下  
![](https://img-blog.csdnimg.cn/20210717162751300.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)

##### 2.2、方式二：通过 jenkins.exe 来启动，jenkins start

进入`Jenkins`的安装目录，  
![](https://img-blog.csdnimg.cn/20210717162138554.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
执行命令`jenkins start`，如下  
![](https://img-blog.csdnimg.cn/2021071716331230.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
如果想重启`Jenkins`，则执行`jenkins restart`，如下  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_15_20210717163511335.png)

#### 3、修改端口号

先关闭`Jenkins`，进入`Jenkins`的安装目录，可以看到里面有一个`jenkins.xml`，使用文本编辑器打开它，  
![](https://img-blog.csdnimg.cn/20210717163854696.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
把`--httpPort`的端口改为别的，比如我改成`8076`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_15_20210717164202809.png)  
重新启动`Jenkins`服务，在浏览器中使用新的端口进行测试，能够正常访问则说明端口修改成功了。  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_16_2021071716431462.png)

#### 4、新建账号

`Jenkins`可能需要多人登录，我们可以新建一些账号供其他人登录。  
在`Jenkins`主页的左侧栏中点击`Manage Jenkins`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_16_20210717164617258.png)  
接着点击`Manager Users`，  
![](https://img-blog.csdnimg.cn/20210717164713255.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
然后点击`Create User`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_16_20210717164806126.png)  
输入要创建的新账号的账号密码，点击创建即可，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_16_20210717164843990.png)  
创建成功，可以看到多了一个账号了，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_17_20210717165009711.png)  
我们可以退出当前账号，使用这个新账号登录，  
![](https://img-blog.csdnimg.cn/20210717165053251.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
登录成功，  
![](https://img-blog.csdnimg.cn/20210717165117306.png)

#### 5、修改密码

点击账号的齿轮按钮，  
![](https://img-blog.csdnimg.cn/20210717165249653.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
修改`Password`，点击`Save`即可，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_17_20210717165359113.png)

#### 6、安装插件

##### 6.1、方式一：通过 Manage Plugins 安装（需要科学上网）

在`Manage Jenkins`页面中，点击`Manage Plugins`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_18_20210717170101550.png)  
搜索需要的插件名称进行安装即可（需要能科学上网才行）  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_17_20210717170312457.png)

##### 6.2、方式二：CLI 命令行安装（需要科学上网）

`Jenkins CLI`就是`Jenkins`的命令行工具，类似于`MacOS`的终端。  
我们可以在`Jenkins`的`Manage Jenkins`页面中看到`Jenkins CLI`，点击进入，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_18_20210717173039547.png)  
点击`jenkins-cli.jar`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_18_20210717173357618.png)  
把下载下来的`jenkins-cli.jar`放到`Jenkins`安装目录中，  
![](https://img-blog.csdnimg.cn/2021071717365344.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
接着我们就可以通过命令来操作`Jenkins`了，具体命令参数可以看`Jenkins CLI`页面，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_19_2021071717570376.png)  
我们可以看到安装插件的参数是`install-plugin`，  
![](https://img-blog.csdnimg.cn/20210717175753942.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
点击去可以看到具体的使用方法，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_19_2021071717585654.png)  
我们进入`jenkins-cli.jar`所在的目录，通过下面的命令即可安装插件，(注意端口根据你的`Jenkins`的实际端口号而定)

```
java -jar jenkins-cli.jar -s http://localhost:8075/ 插件名

```

如果不清楚插件名可以上`Jenkins`的插件官网查看：[https://plugins.jenkins.io/](https://plugins.jenkins.io/)  
![](https://img-blog.csdnimg.cn/20210717170407802.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
以`Maven Integration`插件为例，搜索`Maven Integration`，点击搜索到的插件，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_20_20210717172138811.png)  
点击`Releases`页面，即可看到，插件名就是`maven-plugin:3.12`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_20_20210717172235119.png)  
对应的插件安装命令就是：

```
java -jar jenkins-cli.jar -s http://localhost:8075/ maven-plugin:3.12

```

注意，你可能会提示

```
ERROR: anonymous is missing the Overall/Read permission

```

我们需要在`Configure Global Security`中勾选`项目矩阵授权策略`，给`Anonymous`添加`Administer`权限即可。  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_20_20210717181419219.png)

##### 6.3、方式三：离线环境安装插件

上面两种方式都需要联网，而我们有可能需要把`Jenkins`部署在离线环境的电脑上（比如内网），这个时候就只能通过离线安装的方式了。  
这个时候，我们需要先在有网络（能科学上网）的电脑上下载安装插件。  
安装好的插件可以在这个目录中找到：  
`C:\Windows\System32\config\systemprofile\AppData\Local\Jenkins\.jenkins\plugins`  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_22_20210717201201677.png)  
将其拷贝到内网机的相同路径中，然后重启`Jenkins`即可。

#### 7、创建并执行任务：Hello World

我以创建一个`HelloWorld`任务为例来演示一下。  
点击`New Item`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_21_20210717201604567.png)  
输入任务名，比如`HelloWorld`，点击`Freesytyle project`，点击`OK`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_21_20210717201708482.png)  
输入任务描述，  
![](https://img-blog.csdnimg.cn/20210717201931841.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
`Build`选项选择`Execute Windows batch command`（即批处理，也就是我们说的`bat`）  
![](https://img-blog.csdnimg.cn/20210717202014776.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
然后在`Command`中编写我们要执行的`bat`命令，比如

```
echo "Hello World"

```

如下  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_22_20210717202417123.png)  
最后点击保存，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_23_20210717202530146.png)  
这样我们的任务就创建成功了，我们可以点击`Build Now`来执行这个任务，  
![](https://img-blog.csdnimg.cn/20210717202602996.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
按`F5`刷新一下浏览器，可以看到任务执行的进度，  
![](https://img-blog.csdnimg.cn/20210717202857844.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
执行完后我们可以查看对应的日志，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_23_20210717202942458.png)  
从日志中我们可以看到我们输出的`Hello World`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_58_20210717203059514.png)

#### 8、执行带参数的任务

有时候我们需要创建带参数的任务。  
我们勾选`This project is parameterized`，然后点击`Add Parameter`，可以看到它提供了多种类型的参数，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_58_20210717204555259.png)  
我以`选择项`参数为例，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_58_20210717205015772.png)  
分别填写参数名、选项（每个选项一行）、描述，  
![](https://img-blog.csdnimg.cn/20210717205226643.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
编写`bat`命令，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_58_20210717205446521.png)  
点击`Build with Parameters`，然后设置好参数，  
![](https://img-blog.csdnimg.cn/20210717205600856.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
最后点击`Build`，  
![](https://img-blog.csdnimg.cn/20210717205655917.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
执行完毕可以看到输出日志，结果正确，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_59_2021071720573156.png)

#### 9、执行 python 任务

我们看到任务`Build`中并没有`Phython`的选项，  
![](https://img-blog.csdnimg.cn/20210717210023918.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
但我们又想要让`Jenkins`可以执行`Python`，怎么办呢？很简单，在`bat`中`call python`就好啦，  
![](https://img-blog.csdnimg.cn/2021071721034128.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
其中`python`代码如下：

```
print("Hello, I am python")

```

最后执行任务，输出日志如下，结果正确，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_9_59_59_2021071721050394.png)

#### 10、周期性触发执行任务

有时候我们需要周期性地执行任务，比如每天`8`点触发一次执行任务，或者每隔`30`分钟触发一次执行任务。  
在`Build Triggers`（触发器）中勾选`Build periodically`，  
![](https://img-blog.csdnimg.cn/20210717211307256.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
然后在`Schedule`中编写规则。  
**格式：**  
`MINUTE HOUR DOM MONTH DOW`

<table><thead><tr><th align="left">字段</th><th align="left">说明</th><th align="left">取值范围</th></tr></thead><tbody><tr><td align="left">MINUTE</td><td align="left">分钟</td><td align="left">0~59</td></tr><tr><td align="left">HOUR</td><td align="left">小时</td><td align="left">0~23</td></tr><tr><td align="left">DOM</td><td align="left">一个月中的第几天</td><td align="left">1~31</td></tr><tr><td align="left">MONTH</td><td align="left">月</td><td align="left">1~12</td></tr><tr><td align="left">DOW</td><td align="left">星期</td><td align="left">0~7（0 和 7 代表的都是周日）</td></tr></tbody></table>

**语法：**  
`*`：匹配范围内所有值，例：`* * * * *`  
`M-N`：匹配`M~N`范围内所有值，例：`10-30 * * * *`  
`M-N/X`：在指定`M~N`范围内每隔`X`构建一次，例：`10-30/5 * * * *`  
`*/X`：整个有效区间内每隔`X`构建一次，例：`*/30 * * * *`  
`A,B,...,Z`：匹配多个值，例：`10,20,30 * * * *`

**关于符号 H：**  
为了在系统中生成定时任务，符号`H`（代表`Hash`，后面用`散列`代替）应该用在可能用到的地方，例如：为十几个日常任务配置`0 0 * * *`将会在午夜产生较大峰值。相比之下，配置`H H * * *`仍将每天一次执行每个任务，不是都在同一时刻，可以更好的使用有限资源。

符号`H`可用于范围，例如，`H H(0-7) * * *`代表凌晨`0:00`到 上午`7:59`一段时间。

符号`H`在一定范围内可被认为是一个随机值，但实际上它是任务名称的一个散列而不是随机函数。

**案例：**  
每`30分钟`构建一次

```
H/30 * * * *

```

每`2小时`构建一次

```
H H/2 * * *

```

每天早上`8点`构建一次

```
0 8 * * *

```

每天的`8点`，`12点`，`22点`，一天构建`3`次

```
0 8,12,22 * * *

```

每前半小时中每隔`10分钟`构建一次

```
H(0-29)/10 * * * *

```

每个工作日从早上`9点45分`开始到下午`4点45分`结束这段时间内每间隔`2小时`的`45分钟`那一刻构建一次

```
45 9-16/2 * * 1-5

```

每月（除了`12月`）从`1号`到`15号`这段时间内某刻构建一次

```
H H 1,15 1-11 *

```

好了，案例就列举这么多了。

现在，为了演示，我设置为每隔`1`分钟执行一次，  
![](https://img-blog.csdnimg.cn/20210717221816784.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
命令如下，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_0_20210717221900296.png)  
可以看到它每分钟就触发执行一次任务，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_0_20210717222053676.png)

![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_0_2021071722202061.png)

### 五、实战：Unity + Jenkins

下面我演示一下通过`Jenkins`来调用`Unity`打包`Android`的`APK`。  
我先画个流程图，方便大家理解：  
![](https://img-blog.csdnimg.cn/20210718115141570.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)

现在，我们开始吧。

#### 1、Unity Demo 工程

##### 1.1、创建 Demo 工程

创建一个`Unity`工程，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_0_20210718082613815.png)  
简单弄点东西，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_1_20210718084444476.png)

##### 1.2、切换 Android 平台

点击 `File / Build Settings`菜单，切换成`Android`平台，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_1_20210718084057606.png)

##### 1.3、设置 JDK、Android SDK、Gradle

点击`Edit / Preferences`，在`External Tools`中设置好`JDK`、`Android SDK`、`Gradle`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_2_2021071808310263.png)

##### 1.4、设置包名

在`Player Settings`中设置一下包名，比如`com.linxinfa.test`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_2_20210718083440875.png)

##### 1.5、测试打包

添加要打包的场景，手动点击`Build`，测试一下是否能正常打出`APK`，  
![](https://img-blog.csdnimg.cn/20210718083600916.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
可以正常打出`APK`，说明打包环境设置都正确，  
![](https://img-blog.csdnimg.cn/20210718083818629.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)

#### 2、编写 Editor 打包工具

##### 2.1、Editor 打包工具代码

新建一个`Editor`文件夹，  
![](https://img-blog.csdnimg.cn/20210718085026312.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
在`Editor`文件夹中新建一个`BuildTools`脚本，  
![](https://img-blog.csdnimg.cn/20210718085146340.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
`BuildTools.cs`脚本代码如下：

```
using UnityEngine;
using UnityEditor;

public class BuildTools 
{
    [MenuItem("Build/Build APK")]
    public static void BuildApk()
    {
        BuildPlayerOptions opt = new BuildPlayerOptions();
        opt.scenes = new string[] { "Assets/Scenes/SampleScene.unity" };
        opt.locationPathName = Application.dataPath + "/../Bin/test.apk";
        opt.target = BuildTarget.Android;
        opt.options = BuildOptions.None;

        BuildPipeline.BuildPlayer(opt);

        Debug.Log("Build App Done!");
    }
}

```

##### 2.2、执行 Editor 打包工具菜单

点击菜单`Build / Build Apk`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_3_20210718090938645.png)  
可以正常打出`APK`，  
![](https://img-blog.csdnimg.cn/20210718083818629.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)

#### 3、命令行调用 Unity 静态函数：打包函数

##### 3.1、Unity 命令行模式

`Unity`提供了命令行模式给开发者，我们可以写`bat`脚本来调用`Unity`中的静态函数，比如我们的打包函数。  
格式：  
`Unity程序 -参数 -projectPath 工程地址 -executeMethod 静态函数`  
例：

```
"D:\software\Unity\2021.1.7f1c1\Editor\Unity.exe" ^
-quit ^
-batchmode ^
-projectPath "E:\UnityProject\UnityDemo" ^
-executeMethod BuildTools.BuildApk  ^
-logFile "E:\UnityProject\UnityDemo\output.log"

```

> 注：为了阅读方便，命令我写成多行，在`bat`中连接多行的符号是`^`

我们可以在`Unity`官方手册看到具体的命令参数说明：[https://docs.unity3d.com/Manual/CommandLineArguments.html](https://docs.unity3d.com/Manual/CommandLineArguments.html)  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_4_20210718091835602.png)

##### 3.2、命令参数解释

**-batchmode**  
在 批处理模式下运行`Unity`，它不会弹出窗口。当脚本代码在执行过程中发生异常或其他操作失败时`Unity`将立即退出，并返回代码为`1`。

**-quit**  
命令执行完毕后将退出`Unity`编辑器。请注意，这可能会导致错误消息被隐藏（但他们将显示在`Editor.log`文件）

**-buildWindowsPlayer <pathname>**  
构建一个`32位`的`Windows`平台的`exe`（例如：`-buildWindowsPlayer path/to/your/build.exe`）

**-buildWindows64Player <pathname>**  
构建一个`64位`的`Windows`平台的`exe`（例如：`-buildWindows64Player path/to/your/build.exe`）

**-importPackage <pathname>**  
导入一个的`package`，不会显示导入对话框

**-createProject <pathname>**  
根据提供的路径建立一个空项目

**-projectPath <pathname>**  
打开指定路径的项目

**-logFile <pathname>**  
指定输出的日志文件

**-nographics**  
当运行在批处理模式，不会初始化显卡设备，不需要`GPU`参与；但如果你需要执行光照烘焙等操作，则不能使用这个参数，因为它需要`GPU`运算。

**-executeMethod <ClassName.MethodName>**  
在`Unity`启动的同时会执行静态方法。也就是说，使用`executeMethod`我们需要在编辑文件夹有一个脚本并且类里有一个静态函数。

**-single-instance**  
在同一时间只允许一个游戏实例运行。如果另一个实例已在运行，然后再次通过`-single-instance`启动它的话会调节到现有的这个实例。

**-nolog**  
不产生输出日志。 通常`output_log.txt`被写在游戏输出目录下的`*_Data`文件夹中。

##### 3.3、批处理脚本

我们知道，一个`Unity`工程只能打开一个实例，所以如果我们已经手动用`Unity`打开了工程，此时执行下面这个命令是会报错的，

```
"D:\software\Unity\2021.1.7f1c1\Editor\Unity.exe" ^
-quit ^
-batchmode ^
-projectPath "E:\UnityProject\UnityDemo" ^
-executeMethod BuildTools.BuildApk ^

```

报错如下：

> Aborting batchmode due to fatal error:  
> It looks like another Unity instance is running with this project open.  
> Multiple Unity instances cannot open the same project.

我们需要先判断`Unity`是否在运行中，如果是，则先将旧的`Unity`实例进程杀掉，对应的`bat`代码如下：

```
::判断Unity是否运行中
TASKLIST /V /S localhost /U %username%>tmp_process_list.txt
TYPE tmp_process_list.txt |FIND "Unity.exe"
 
IF ERRORLEVEL 0 (GOTO UNITY_IS_RUNNING)
ELSE (GOTO START_UNITY)
 
:UNITY_IS_RUNNING
::杀掉Unity
TASKKILL /F /IM Unity.exe
::停1秒
PING 127.0.0.1 -n 1 >NUL
GOTO START_UNITY

:START_UNITY
:: 此处执行Unity打包

```

另外，我们想要在执行打包时传入一些参数，比如`APP名字`、`版本号`等，可以在命令中加上，格式可以自定义，我们只需在后面的`C#`代码中进行相应的解析即可，例：

```
--productName:%1 --version:%2

```

其中`%1`表示`参数1`，`%2`表示`参数2`，  
完整命令如下：

```
"D:\software\Unity\2021.1.7f1c1\Editor\Unity.exe" ^
-quit ^
-batchmode ^
-projectPath "E:\UnityProject\UnityDemo" ^
-executeMethod BuildTools.BuildApk ^
--productName:%1 ^
--version:%2

```

整合上面的`Unity`进程判断，最终完整的`bat`代码如下：

```
::判断Unity是否运行中
TASKLIST /V /S localhost /U %username%>tmp_process_list.txt
TYPE tmp_process_list.txt |FIND "Unity.exe"
 
IF ERRORLEVEL 0 (GOTO UNITY_IS_RUNNING)
ELSE (GOTO START_UNITY)
 
:UNITY_IS_RUNNING
::杀掉Unity
TASKKILL /F /IM Unity.exe
::停1秒
PING 127.0.0.1 -n 1 >NUL
GOTO START_UNITY

:START_UNITY
:: 此处执行Unity打包
"D:\software\Unity\2021.1.7f1c1\Editor\Unity.exe" ^
-quit ^
-batchmode ^
-projectPath "E:\UnityProject\UnityDemo" ^
-executeMethod BuildTools.BuildApk ^
-logFile "E:\UnityProject\UnityDemo\output.log" ^
--productName:%1 ^
--version:%2

```

将上面的`bat`代码保存为`build_app.bat`，我们通过命令行去执行这个`build_app.bat`，如下：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_3_20210718103919687.png)  
可以看到此时能打出`APK`，  
![](https://img-blog.csdnimg.cn/20210718083818629.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
在输出的日志文件中我们也可以看到我们`Debug.Log`输出的日志，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_4_202107181029491.png)

##### 3.4、Unity 打包工具接收命令行参数

虽然我们上面的`bat`脚本传递了包名和版本号两个参数，但是我们在`Unity`的打包工具中并没有对这两个参数进行解析，现在，我们补上解析参数的逻辑吧。

```
// 解析命令行参数
string[] args = System.Environment.GetCommandLineArgs();
foreach (var s in args)
{
    if (s.Contains("--productName:"))
    {
        string productName= s.Split(':')[1];
        // 设置app名字
        PlayerSettings.productName = productName;
    }

    if (s.Contains("--version:"))
    {
        string version = s.Split(':')[1];
        // 设置版本号
        PlayerSettings.bundleVersion = version;
    }
}

```

打包工具完整代码如下：

```
// BuildTools.cs
using UnityEngine;
using UnityEditor;

public class BuildTools
{
    [MenuItem("Build/Build APK")]
    public static void BuildApk()
    {
        // 解析命令行参数
        string[] args = System.Environment.GetCommandLineArgs();
        foreach (var s in args)
        {
            if (s.Contains("--productName:"))
            {
                string productName= s.Split(':')[1];
                // 设置app名字
                PlayerSettings.productName = productName;
            }

            if (s.Contains("--version:"))
            {
                string version = s.Split(':')[1];
                // 设置版本号
                PlayerSettings.bundleVersion = version;
            }
        }
       
        // 执行打包
        BuildPlayerOptions opt = new BuildPlayerOptions();
        opt.scenes = new string[] { "Assets/Scenes/SampleScene.unity" };
        opt.locationPathName = Application.dataPath + "/../Bin/test.apk";
        opt.target = BuildTarget.Android;
        opt.options = BuildOptions.None;

        BuildPipeline.BuildPlayer(opt);

        Debug.Log("Build App Done!");
    }
}

```

重新执行命令：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_3_20210718103919687.png)  
然后我们安装一下`APK`，看看`APP`名字是不是`哈哈哈`，  
![](https://img-blog.csdnimg.cn/20210718104334515.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
在应用信息里可以看到版本号也是我们命令行中设置的`1.2.0.0`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_4_20210718104423152.png)

#### 4、Jenkins 调用 bat 脚本

我们回到`Jenkins`页面中，创建一个带参数的任务，  
`appName`参数：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_4_20210718104906323.png)

`version`参数：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_5_20210718104830668.png)  
命令行：  
`E:\UnityProject\UnityDemo\bat\build_app.bat %appName% %version%`，如下：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_5_20210718105025524.png)  
执行`Jenkins`任务，如下：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_6_20210718105131948.png)  
等等运行结果：  
![](https://img-blog.csdnimg.cn/20210718105212849.png)  
执行完毕，我们看下输出的日志，  
![](https://img-blog.csdnimg.cn/20210718105517547.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
可以看到我们的`bat`脚本被正确执行了，参数也传递正确，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_6_20210718105604856.png)  
`APK`也可以正常生成，  
![](https://img-blog.csdnimg.cn/20210718083818629.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
安装到模拟器上，可以看到名字正确，  
![](https://img-blog.csdnimg.cn/20210718105719305.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
版本号也正确，  
![](https://img-blog.csdnimg.cn/20210718105753757.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
流程走通了，剩下的就是根据自己的需求进行扩展啦，比如打包前先执行一下`svn`更新之类的，需要额外参数，就在`Jenkins`中添加，传递到`bat`脚本中，再传递到`Unity`中，最后根据参数进行打包。

#### 5、拓展：python 加强版脚本

我个人其实不是特别喜欢写`bat`脚本，我更喜欢写`python`，于是，我就写了个`python`版的脚本，脚本中我加了监控`Unity`日志输出的逻辑，方便进行一些判断，画个图：  
![](https://img-blog.csdnimg.cn/20210718115451523.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
`python`完整代码如下：

```
import os
import sys
import time
 
# 设置你本地的Unity安装目录
unity_exe = 'D:/software/Unity/2021.1.7f1c1/Editor/Unity.exe'
# unity工程目录，当前脚本放在unity工程根目录中
project_path = 'E:/UnityProject/UnityDemo'
# 日志
log_file = os.getcwd() + '/unity_log.log'
 
static_func = 'BuildTools.BuildApk'
 
# 杀掉unity进程
def kill_unity():
    os.system('taskkill /IM Unity.exe /F')
 
def clear_log():
    if os.path.exists(log_file):
        os.remove(log_file)
 
# 调用unity中我们封装的静态函数
def call_unity_static_func(func):
    kill_unity()
    time.sleep(1)
    clear_log()
    time.sleep(1)
    cmd = 'start %s -quit -batchmode -projectPath %s -logFile %s -executeMethod %s --productName:%s --version:%s'%(unity_exe,project_path,log_file,func, sys.argv[1], sys.argv[2])
    print('run cmd:  ' + cmd)
    os.system(cmd)
 
    
 
# 实时监测unity的log, 参数target_log是我们要监测的目标log, 如果检测到了, 则跳出while循环    
def monitor_unity_log(target_log):
    pos = 0
    while True:
        if os.path.exists(log_file):
            break
        else:
            time.sleep(0.1) 
    while True:
        fd = open(log_file, 'r', encoding='utf-8')
        if 0 != pos:
            fd.seek(pos, 0)
        while True:
            line = fd.readline()
            pos = pos + len(line)
            if target_log in line:
                print(u'监测到unity输出了目标log: ' + target_log)
                fd.close()
                return
            if line.strip():
                print(line)
            else:
                break
        fd.close()
 
if __name__ == '__main__':
    call_unity_static_func(static_func)
    monitor_unity_log('Build App Done!')
    print('done')

```

我们把脚本保存为`build_app.py`，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_7_20210718113936971.png)  
把`Jenkins`中的命令改为执行`python`脚本：  
`call python E:\UnityProject\UnityDemo\bat\build_app.py %appName% %version%`  
如下：  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_7_20210718114041887.png)  
执行一下任务，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_7_20210718114343461.png)  
耐心等待执行结果，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_8_20210718114516664.png)  
执行完毕可以看到监控到的日志，  
![](https://img-blog.csdnimg.cn/20210718114835407.png?x-oss-process=/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xpbnhpbmZh,size_16,color_FFFFFF,t_70)  
我们在`python`中输出的日志都可以在`Jenkins`的`Console Output`中看到，  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_9_20210718114654730.png)  
`APK`顺利生成，`Very Good`，完美~  
![](https://gitcode.net/hankangwen/blog-image/-/raw/master/pictures/2022/10/8_10_0_8_20210718114739501.png)

### 六、完毕

好了，就写这么多吧，我是新发，喜欢我的可以点赞、关注，有任何技术上的疑问欢迎评论或留言~
