# UIViewControllerTransitioningAnimation iOS自定义转场动画

# 前言

由于本人喜欢有趣的动效，在刚开始学习iOS开发时就自己捣腾iOS动画。当时什么也不懂，而且虽然现在看来iOS动画的实现方式就那么几种，但是刚开始弄的时候还是挺费劲的。嘿嘿，虽然现在也不算很牛，但也算入门。我来抛砖引玉了，说的不好不要打我😊。

# 1.什么是动画？

动画，电影，电视，漫画，以前傻傻的分不清，其实也好区分，很明显漫画是不会动的，比如我喜欢看的死神，火影，海贼，动画和电影神马的都是能动的，但是也有点不一样，动画是画出来的，电影则是拍出来的，呵呵哒。
其实，我觉得一切动画都可以分解成一幅幅画面，所谓的帧动画，只要够强大，什么都挡不住一只笔的风骚。😍

# 2.为何是60FPS（60帧／秒）？

说这个问题之前，我们先说一下电影的24FPS和游戏的60FPS，一部流畅的电影只需24FPS即可，但是游戏24FPS可能会很卡。why?
有两个原因：

### （1）电影成像和游戏成像的原理不一样

电影每一帧都包含了一段时间的信息，而游戏则只包含那一瞬间的信息。举个例子，拍照片。如果设置曝光时间过长，则会出现模糊，因为这段时间相机里面的场景变化的痕迹都记录在照片中了，所以会出现模糊不清的照片，如下图：

![twocat.png](http://upload-images.jianshu.io/upload_images/968977-e07aab2267758586.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

一只模糊的猫头😄，其实这也可以看作一段时间内多帧糅合在一起了。电影虽然帧数低，但是上一针储存了到下一针所需要的变化，所以看起来可以连贯，就像阳光照射在人的视网膜上，会有停留时间。想象一下，站在你对面的人向你招手，速度从慢到快，你是否也不会感觉到卡顿呢？（如果能感觉到卡顿，这个世界就精彩了，想象一下奥运会的短跑项目😄）。而游戏则不一样，游戏显示在屏幕的每一帧都是先经过CPU的处理，然后再经过GPU的处理，最后才会显示在电子屏幕上面（电子屏幕显示相关的细节可以看一下ibireme大神的[iOS保持界面流畅的技巧](http://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/)）。简单来说就是上一帧没有保留下一帧过度所需要的变化，所以，一旦前后画面变化过大，则会感觉到卡顿，因为是突然变化，措手不及。

### （2）电影的FPS是稳定的，而游戏则是不稳定的

这个可以这样理解，电影一秒24帧，每帧之间的时间间隔是一样的，稳定的，而游戏比如前面30帧时间间隔比较短，后面30帧的时间间隔比较长，也会感觉卡顿，这也是为什么有同样的帧数，有的应用感觉卡顿，有的不卡的原因。

总的来说，帧数越多也不一定不卡顿，但是应用显示的帧数在30～60之间一般不会感觉到明显的卡顿。貌似是因为人眼的视觉停留时间为1/24秒，具体是什么鬼，大家自行Google。

# 3.iOS动画的层级结构

![层级关系.png](http://upload-images.jianshu.io/upload_images/968977-33c61736af4698c3.png)

### 解析一下上图的层级关系：<br>
1.UIKit应用于iOS，AppKit应用于Mac OS，可想iOS和Mac OS开发有很多相似之处。<br>
2.QuartzCore包含Core Animation。<br>
3.OpenGL ES是跨平台的图形API，属于OpenGL的一个简化版本，是应用程序编程接口，也就是说它只定义了一套规范，具体的实现由设备制造商根据规范去做。QuartZ 2D是苹果公司开发的一套API，它是Core Graphics Framework的一部分，是一套基于C的API框架，使用了Quartz作为绘图引擎。<br>
4.OpenGL ES可以绘制2D和3D图形，Core Graphics只能绘制2D图形。<br>
5.CATransform3D包含于Core Animation里面；CGAffineTransform包含于Core Graphics里面。<br>
6.一般从绘制性能来说：OpenGL ES > Core Graphics > Core Animation，从使用简易来说：Core Animation > Core Graphics > OpenGL ES<br>

# 4.iOS动画实现

首先要清楚CALayer的概念，在MVC框架里面，View是负责用户界面显示的，显而易见，Apple刚开始就让iOS遵循MVC框架，UIView负责显示界面。然而，CALayer才是绘制页面的功臣，UIView只是负责管理CALayer的行为。CALayer里包含了三种树呈现树（presentationLayer tree）,模型树（modelLayer tree）以及渲染树（render tree），其中呈现树主要记录了图层从动画开始到结束的所有变化，模型树只记录了最终结果，而渲染树顾名思义是渲染到屏幕上显示的。

##### （1）CoreAnimation（基本动画）

![CoreAnimation.png](http://upload-images.jianshu.io/upload_images/968977-aab85a824844ee31.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

由上图可见CA动画分组动画（CAAnimationGroup），属性动画（CAPropertyAnimation）和转场动画（CATransition），其中属性动画又分为基本动画（CABasicAnimation）和帧动画（CAKeyframAnimation），CA动画还实现了CAMediaTiming接口，提供一些和动画时间有关的功能。
*  CABasicAnimation

```Objective-C
fromValue: 初始值
toValue: 结束值

代码：
//使用CABasicAnimation创建基础动画
CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-75)];
anima.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-75)];
anima.duration = 1.0f;
//anima.fillMode = kCAFillModeForwards;
//anima.removedOnCompletion = NO;
[_demoView.layer addAnimation:anima forKey:@"positionAnimation"];
注意⚠：
如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
```
*  CAKeyframeAnimation

```Objective-C
values ： NSArray对象，里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧 
path ： 可以设置一个CGPathRef\CGMutablePathRef，让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略。 
keyTimes ： 可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0，keyTimes中的每一个时间值都对应values中的每一帧。当keyTimes没有设置的时候，各个关键帧的时间是平分的。

代码：
CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"position"];
UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-100, 200, 200)];
anima.path = path.CGPath;
anima.duration = 2.0f;
[_demoView.layer addAnimation:anima forKey:@"pathAnimation"];
```
*  CAAnimationGroup

```Objective-C
animations : 用来保存一组动画对象的NSArray 

代码：
CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
NSValue *value0 = [NSValue valueWithCGPoint:CGPointMake(0, SCREEN_HEIGHT/2-50)];
NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2-50)];
NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH/3, SCREEN_HEIGHT/2+50)];
NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2+50)];
NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH*2/3, SCREEN_HEIGHT/2-50)];
NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50)];
anima1.values = [NSArray arrayWithObjects:value0,value1,value2,value3,value4,value5, nil];

//缩放动画
CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
anima2.fromValue = [NSNumber numberWithFloat:0.8f];
anima2.toValue = [NSNumber numberWithFloat:2.0f];

//旋转动画
CABasicAnimation *anima3 = [CABasicAnimationanimationWithKeyPath:@"transform.rotation"];
anima3.toValue = [NSNumber numberWithFloat:M_PI*4];

//组动画
CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2,anima3, nil];
groupAnimation.duration = 4.0f;

[_demoView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
```
*  CATransition

```Objective-C
CAAnimation的子类，用于做过渡动画或者转场动画，能够为层提供移出屏幕和移入屏幕的动画效果。 

type：动画过渡类型
- kCATransitionFade 渐变效果 
- kCATransitionMoveIn 进入覆盖效果 
- kCATransitionPush 推出效果 
- kCATransitionReveal 揭露离开效果 
私有API提供了其他很多非常炫的过渡动画，比如@”cube”、@”suckEffect”、@”oglFlip”、 @”rippleEffect”、@”pageCurl”、@”pageUnCurl”、@”cameraIrisHollowOpen”、@”cameraIrisHollowClose”等。 
注意点 
私有api，不建议开发者们使用。因为苹果公司不提供维护，并且有可能造成你的app审核不通过。

subtype：动画过渡方向
* kCATransitionFromRight 从右侧进入
* kCATransitionFromLeft 从左侧进入
* kCATransitionFromTop 从顶部进入
* kCATransitionFromBottom 从底部进入

startProgress：动画起点(在整体动画的百分比) 
endProgress：动画终点(在整体动画的百分比)

代码：
CATransition *transition = [CATransition animation];
transition.type = kCATransitionFade;
transition.subtype = kCATransitionFromLeft;
transition.startProgress = 0;
transition.endProgress = 1;
transition.duration = 0.4;

SecondViewController *svc = [[SecondViewController alloc] init];
[self.navigationController.view.layer addAnimation: transition forKey: @"kCATransitionFade"];
[self.navigationController pushViewController: svc animated: NO];
```
关于部分keyPath的值：

| keyPath               |  描述 |
| ---------------- |:------:| 
|  transform.scale | 比例变化 |
|  transform.scale.x | 宽的比例变化 |
|  transform.scale.y | 高的比例变化 |
|  transform.rotation.z | 以z轴为中心轴旋转 |
| opacity | 透明度变化 |
| frame | 形状变化 |
| path | 路径变化 |

# 5.其他调用动画的方式

```Objective-C
(1)UIView块动画
_demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
[UIView animateWithDuration:1.0f animations:^{
_demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
} completion:^(BOOL finished) {
_demoView.frame = CGRectMake(SCREEN_WIDTH/2-25, SCREEN_HEIGHT/2-50, 50, 50);
}];
(2)UIView commit动画 //现已不使用
_demoView.frame = CGRectMake(0, SCREEN_HEIGHT/2-50, 50, 50);
[UIView beginAnimations:nil context:nil];
[UIView setAnimationDuration:1.0f];
_demoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT/2-50, 50, 50);
[UIView commitAnimations];
```
# 6.总结

有的时候，app加上动画可以提高可玩性，趣味性。动画本身也挺好玩的，有兴趣的同学可以看一下我的Demo，[Objective-C版](https://github.com/jashion/UIViewControllerTransitioningAnimation)，[Swift版](https://github.com/jashion/SwiftTransitionAnimation)。

![AnimationDemo.gif](http://upload-images.jianshu.io/upload_images/968977-e7d604398501c59a.gif?imageMogr2/auto-orient/strip)


