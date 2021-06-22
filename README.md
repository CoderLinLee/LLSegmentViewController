# LLSegmentViewController

## 要求

- iOS 8.0+
- Xcode 9
- Swift

## 使用CocoaPods安装
```
pod 'LLSegmentViewController'
```

## 特征
1、预加载控制器View
```Swift
pageView.preLoadRange = 1...3 //当前控制器的左边预加载1个，右边预加载3个
```
2、红点设置简单，跟当前控制器绑定，不再需要写额外控制代码
```Swift
self.tabBarItem.badgeValue = "\(indexPath.row)"//红点设置为LLSegmentRedBadgeValue
```
3、自定义性强：参考自定义样式

## 项目中的使用
```Swift
class SimpDemoViewController: LLSegmentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSegmentedConfig()
    }
}

extension SimpDemoViewController{
    func loadSegmentedConfig() {
        layoutContentView()
        loadCtls()
        setUpSegmentStyle()
    }

    func layoutContentView() {
        self.layoutInfo.segmentControlPositionType = .top(size: CGSize.init(width: UIScreen.main.bounds.width, height: 44),offset:0)
        self.relayoutSubViews()
    }

    func loadCtls() {
        let introCtl = UIViewController()
        introCtl.title = "简介"
        introCtl.view.backgroundColor = UIColor.yellow
        
        let catalogCtl = UIViewController()
        catalogCtl.title = "目录"
        catalogCtl.view.backgroundColor = UIColor.red
        
        let ctls =  [introCtl,catalogCtl]
        reloadViewControllers(ctls:ctls)
    }

    func setUpSegmentStyle() {
        let itemStyle = LLSegmentItemTitleViewStyle()
        itemStyle.selectedColor = UIColor.init(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1)
        itemStyle.unSelectedColor = UIColor.init(red: 136/255.0, green: 136/255.0, blue: 136/255.0, alpha: 1)
        itemStyle.selectedTitleScale = 1
        itemStyle.titleFontSize = 15
        itemStyle.itemWidth = UIScreen.main.bounds.width/CGFloat(ctls.count)//如果不指定是自动适配的
        //这里可以继续增加itemStyle的其他配置项... ...

        segmentCtlView.backgroundColor = UIColor.white
        segmentCtlView.separatorLineShowEnabled = true //间隔线显示，默认不显示
        //还有其他配置项：颜色、宽度、上下的间隔...

        segmentCtlView.bottomSeparatorStyle = (1,UIColor.red) //分割线:默认透明色
        segmentCtlView.indicatorView.widthChangeStyle = .stationary(baseWidth: 11)//横杆宽度:有默认值
        segmentCtlView.indicatorView.centerYGradientStyle = .bottom(margin: 0)//横杆位置:有默认值
        segmentCtlView.indicatorView.shapeStyle = .custom //形状样式:有默认值

        var segmentedCtlStyle = LLSegmentedControlStyle()
        segmentedCtlStyle.segmentItemViewClass = LLSegmentItemTitleView.self  //ItemView和ItemViewStyle要统一对应
        segmentedCtlStyle.itemViewStyle = itemStyle
        segmentCtlView.reloadData(ctlViewStyle: segmentedCtlStyle)
    }
```


## 自定义
只需两步就可完成自定义效果：(可参考项目内的自定义样式)
-  1、继承LLSegmentBaseItemView或子类；
-  2、实现LLSegmentBaseItemView以下方法（有些方法可实现可不实现）

```Swift
//1、设置标题
public func titleChange(title:String)
//2、滚动时会调用这个方法，percent的取值范围是0...1
public func percentChange(percent:CGFloat)
//3、返回当前ItemView的宽度
public func itemWidth() ->CGFloat
//4、设置Item的style样式
public func setSegmentItemViewStyle(itemViewStyle:LLSegmentItemViewStyle) 
```

## 效果预览

### 详情页效果预览

说明 | Gif |
----|-------|
个人中心头部放大  |  <img src="Screenshot/detail/personCenter.gif" width="385" height="630"> | 
个人中心列表刷新  |  <img src="Screenshot/detail/personCenterListRefresh.gif" width="385" height="630"> | 
商品详情  |  <img src="Screenshot/detail/goodsDetail.gif" width="385" height="630"> | 

### 指示器效果预览

说明 | Gif |
----|------|
LineView固定宽度  |  <img src="Screenshot/indicatorView/lineView.gif" width="355" height="133"> |
LineView京东风格  |  <img src="Screenshot/indicatorView/jdLineView.gif" width="355" height="133"> |
LineView爱奇艺风格  |  <img src="Screenshot/indicatorView/aiqyLineView.gif" width="355" height="133"> |
LineView回旋风格  |  <img src="Screenshot/indicatorView/huigunLineView.gif" width="355" height="133"> |
LineView与Item等宽  |  <img src="Screenshot/indicatorView/equlWidthLineView.gif" width="355" height="133"> |
LineView分割线  |  <img src="Screenshot/indicatorView/separatorLineView.gif" width="355" height="133"> |
LineView背景  |  <img src="Screenshot/indicatorView/backgroundLineView.gif" width="355" height="133"> |
LineView椭圆形  |  <img src="Screenshot/indicatorView/ellipseLineView.gif" width="355" height="133"> |
LineView椭圆形加阴影  |  <img src="Screenshot/indicatorView/ellipseShadowLineView.gif" width="355" height="133"> |
LineView文字遮罩  |  <img src="Screenshot/indicatorView/maskLineView.gif" width="355" height="133"> |
LineView文字遮罩加背景  |  <img src="Screenshot/indicatorView/maskBackgroundLineView.gif" width="355" height="133"> |
LineView文字遮罩加背景和阴影  |  <img src="Screenshot/indicatorView/maskBackgroundShadowLineView.gif" width="355" height="133"> |
LineView三角形  |  <img src="Screenshot/indicatorView/triangleLineView.gif" width="355" height="133"> |
LineView小红点加数字  |  <img src="Screenshot/indicatorView/numberLineView.gif" width="355" height="133"> |
LineView点线效果  |  <img src="Screenshot/indicatorView/pointLineLineView.gif" width="355" height="133"> |
LineViewQQ红点  |  <img src="Screenshot/indicatorView/qqPointLineView.gif" width="355" height="133"> |

### 特殊效果预览

说明 | Gif |
----|------|
LineView嵌套  |  <img src="Screenshot/special/nestlineView.gif" width="355" height="133"> |
LineView足球  |  <img src="Screenshot/special/footballlineView.gif" width="355" height="133"> |
LineView插入  |  <img src="Screenshot/special/insertlineView.gif" width="355" height="133"> |
LineView混合  |  <img src="Screenshot/special/mixlineView.gif" width="355" height="133"> |
LineView图片做背景  |  <img src="Screenshot/special/changeImagelineView.gif" width="355" height="133"> |
LineView图片文字  |  <img src="Screenshot/special/imageTextlineView.gif" width="355" height="133"> |

### 自定义Item效果预览

说明 | Gif |
----|------|
LineView背景色渐变  |  <img src="Screenshot/custom/changeColorcustomView.gif" width="355" height="133"> |
LineView富文本  |  <img src="Screenshot/custom/attributecustomView.gif" width="355" height="133"> |
LineView网易新闻 |  <img src="Screenshot/custom/wangyicustomView.gif" width="355" height="133"> |

### 自定义tabbar效果预览

说明 | Gif |
----|------|
LineView微信  |  <img src="Screenshot/tabbar/weixintabbarView.gif" width="355" height="133"> |
LineView微博  |  <img src="Screenshot/tabbar/sinatabbarView.gif" width="355" height="133"> |
LineView图片做背景  |  <img src="Screenshot/tabbar/backgroundtabbarView.gif" width="355" height="133"> |



邮箱：736764509@qq.com </br>
QQ群： 142649183

<img src="Screenshot/qqGroup.png" width="170" height="166"> 








