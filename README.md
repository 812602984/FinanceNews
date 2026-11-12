# FinanceNews

一款**财经新闻资讯客户端**，Objective-C。内容取自和讯网的新闻接口，按频道组织，用户可以在不同财经领域之间横滑切换，看到感兴趣的就收藏起来慢慢读。

## 频道

顶部是自定义的频道切换栏（`Topbar`），六个频道横向排列，左右滑动切换：

| 频道 | 内容 |
| --- | --- |
| **头条**（Headline） | 财经要闻、当日重点 |
| **金融**（Financial） | 金融行业动态 |
| **个股**（Eachgold） | 个股相关资讯 |
| **银行**（Bank） | 银行板块 |
| **保险**（Insure） | 保险板块 |
| **海外**（Abroad） | 国际市场 |

另有**视频**、**图集**两个独立内容形态的频道。

## 主要功能

- **多频道横滑**：`ContainerViewController` 管子控制器，`Topbar` 管标题栏的下划线和选中态
- **左右抽屉**：主界面可以左右滑出两个侧边栏，左侧是频道/功能入口，右侧是个人中心
- **新闻详情**：正文用 UIWebView 渲染，图片自适应宽度
- **收藏**：收藏的新闻存在本地数据库，离线也能翻
- **评论 / 讨论**：详情页下方的评论列表，另有独立的讨论区
- **图集浏览**：多图横向滚动查看
- **搜索**：关键词搜索结果页
- **登录**：和讯账号 H5 登录
- **推送**：集成极光推送（JPush），收财经快讯

## 技术要点

**1. 自定义 Topbar 做频道切换**
把 `topbar.titles` 直接赋成所有子控制器的 `title`（`[_viewControllers valueForKey:@"title"]`），下拉线跟着滚动位置移动，不用一个个手写标题。

**2. 抽屉用手势驱动，不用第三方**
`SideViewController` 自己做左右抽屉：`UIPanGestureRecognizer` 挂在根视图上，拖动时实时改根视图的 frame，松手按位移比例决定展开还是回弹。支持配 `leftViewShowWidth` / `rightViewShowWidth` / `animationDuration`，还有 `rootViewMoveBlock` 让你在移动过程中插入自己的动画。

这种写法的好处是没有耦合第三方抽屉库，整个交互逻辑（手势识别、边界判断、动画曲线）都在自己手里。

**3. 本地数据库用 FMDB**
`DBManager` 是对 FMDB 的薄封装，管建表、增删改查。收藏列表、已读记录这类需要持久化的数据都走它，不依赖网络。

**4. GData 解析 XML**
和讯这个接口返回的是 **XML** 不是 JSON，所以工程里带了 Google 的 `GDataXML` 来解析，`NewGData` 是改造过的版本。这是这套代码里比较特别的一处 —— 现在绝大多数接口都是 JSON 了。

**5. 新闻 Cell 复用**
`NewsCell` / `PicCell` / `VideoCell` 分开，按内容类型决定用哪个，对应 `NewsModel` / `PicModel` / `VideoModel` 三套模型。

## 依赖

工程里同时存在**两种引入方式**，这是历史遗留：

**CocoaPods 管理**（`Pods/` 已提交）：

| 库 | 用途 |
| --- | --- |
| `Masonry` | 布局 |
| `MJRefresh` | 下拉刷新 |
| `JPush` / `JCore` | 极光推送 |

**源码直接放进根目录**：

| 库 | 用途 |
| --- | --- |
| `AFNetworking` | 网络请求 |
| `SDWebImage` | 图片加载 |
| `fmdb` | SQLite 封装 |
| `GData` / `NewGData` | XML 解析 |
| `JHRefresh` | 下拉刷新（和 MJRefresh 并存） |
| `MMProgressHUD` | 加载提示 |
| `LZXHelper` | 工具方法 |
| `nsstring-hashing` | 字符串哈希（缓存 key 用） |

## 怎么跑起来

1. 用 Xcode 打开 `FinanceNews.xcworkspace`
2. 部署目标 iOS 8.1，选 iPhone 模拟器 Run
3. 首次运行如果提示签名问题，把 Team 换成你自己的开发者账号

> 接口是 `https://wapi.hexun.com/Api_newsXml_v1.cc`，`pid` 参数区分频道。和讯这个老接口**很可能已经改版或下线**，列表拉不到数据时先看控制台的返回。

## 目录结构

```
FinanceNews/
├── AppDelegate
├── ContainerViewController     频道容器
├── Topbar                      顶部频道切换栏
├── SideViewController          左右抽屉
├── LeftViewController          左侧栏内容
├── RightViewController         右侧栏内容
├── Headline/Financial/Eachgold/Bank/Insure/Abroad   六个频道
├── VideoViewController         视频频道
├── PicsRootViewController      图集列表
├── PicDetailViewController     图集详情
├── DetailViewController        新闻详情
├── CommentViewController       评论
├── DiscussViewController       讨论区
├── CollectionViewController    收藏
├── SearchViewController        搜索
├── SearchResultViewController  搜索结果
├── LoginViewController         登录
├── DBManager                   本地数据库（FMDB 封装）
├── NewsCell / PicCell / VideoCell / CommentCell
├── NewsModel / PicModel / VideoModel / CommentModel
└── AFNetworking/ fmdb/ GData/ ...   第三方源码
```

## 已知限制

- 这个仓库最初是用 SVN 做版本控制的，早期提交里带有 27 个 `.svn` 元数据目录（已清理）。如果你 checkout 到旧提交看到这些目录，可以忽略或直接删除。
- 同时用了 `JHRefresh` 和 `MJRefresh` 两套下拉刷新，属于历史遗留，新写页面建议统一用一套。
- 接口返回 XML，解析链路比 JSON 长，字段改动时 `NewGData` 和模型要一起改。
- 登录走的是和讯 H5 页面，账号体系不在本地。
- 极光推送需要自己的 AppKey，仓库里的是旧配置，换账号后要重新配。

## License

未声明。代码可自由参考。
