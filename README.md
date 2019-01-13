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
只需要两步就可完成自定义效果：(可参考项目内的自定义样式)
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

### 指示器效果预览

说明 | Gif |
----|------|
LineView固定宽度  |  <img src="https://github.com/CoderLinLee/Screenshot/blob/master/LLSegmentViewController/lineView.gif" width="355" height="133"> |
LineView京东风格  |  <img src="https://github.com/CoderLinLee/Screenshot/blob/master/LLSegmentViewController/jdlineView.gif" width="355" height="133"> |
LineView爱奇艺风格  |  <img src="https://github.com/CoderLinLee/Screenshot/blob/master/LLSegmentViewController/aiqyLineView.gif" width="355" height="133"> |
LineView回旋风格  |  <img src="https://github.com/CoderLinLee/Screenshot/blob/master/LLSegmentViewController/huigunLineView.gif" width="355" height="133"> |
LineView与Item等宽  |  <img src="https://github.com/CoderLinLee/Screenshot/blob/master/LLSegmentViewController/equlWidthLineView.gif" width="355" height="133"> |




