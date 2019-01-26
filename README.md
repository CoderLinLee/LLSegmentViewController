# LLSegmentViewController

##效果参考

[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView)


## 要求

- iOS 8.0+
- Xcode 9
- Swift

## 使用CocoaPods安装
```
pod 'LLSegmentViewController'
```

## 自定义
只需两步就可完成自定义效果：(可参考项目内的自定义样式)
-  1、继承LLSegmentBaseItemView；
-  2、实现LLSegmentBaseItemView以下方法（有些方法可实现可不实现）

```
//1、设置标题
public func titleChange(title:String)
//2、滚动时会调用这个方法，percent的取值范围是0...1
public func percentChange(percent:CGFloat)
//3、返回当前ItemView的宽度
public func itemWidth() ->CGFloat
//设置Item的style样式
public func setSegmentItemViewStyle(itemViewStyle:LLSegmentItemViewStyle) 
```

## 效果预览

### 详情页效果预览

说明 | Gif | Code |
----|------|------|
个人中心头部放大  |  <img src="Screenshot/detail/personCenter.gif" width="355" height="630"> | `    override func scrollView(scrollView: LLContainerScrollView, dragToMinimumHeight progress: CGFloat) {
self.progress = progress
customNavBar.alpha = progress
}
` |
个人中心列表刷新  |  <img src="Screenshot/detail/personCenterListRefresh.gif" width="355" height="630"> | `  `  |
商品详情  |  <img src="Screenshot/detail/goodsDetail.gif" width="355" height="630"> | `  `  |

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








