
#import "RNSy.h"

@implementation RNSy

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(init:(NSString *)appId debug:(BOOL)debug callback:(RCTResponseSenderBlock)callback)
{
    [CLShanYanSDKManager printConsoleEnable:debug];
    [CLShanYanSDKManager initWithAppId:appId complete:^(CLCompleteResult * _Nonnull completeResult) {
        if(completeResult.error) {
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.error.userInfo]);
        } else {
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.data]);
        }
    }];
}

RCT_EXPORT_METHOD(preGetPhonenumber:(RCTResponseSenderBlock)callback)
{
    [CLShanYanSDKManager preGetPhonenumber:^(CLCompleteResult * _Nonnull completeResult) {
        if(completeResult.error) {
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.error.userInfo]);
        } else {
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.data]);
        }

    }];
}

RCT_EXPORT_METHOD(login:(RCTResponseSenderBlock)callback)
{
    __weak typeof(self) weakself = self;

    CLUIConfigure * baseUIConfigure = [self configureStyle:[CLUIConfigure new]];

    //闪验一键登录接口（将拉起授权页）
    [CLShanYanSDKManager quickAuthLoginWithConfigure:baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {

        if (completeResult.error) {
            //拉起授权页失败
            NSLog(@"openLoginAuthListener:%@",completeResult.error.userInfo);
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.data]);
        }else{
            //拉起授权页成功
            NSLog(@"openLoginAuthListener:%@",completeResult.data);
        }
    } oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
        __strong typeof(self) strongSelf = weakself;

        if (completeResult.error) {
            //一键登录失败
            NSLog(@"oneKeyLoginListener:%@",completeResult.error.description);

            //提示：错误无需提示给用户，可以在用户无感知的状态下直接切换登录方式
            if (completeResult.code == 1011){
                //用户取消登录（点返回）
                //处理建议：如无特殊需求可不做处理，仅作为交互状态回调，此时已经回到当前用户自己的页面
                //点击sdk自带的返回，无论是否设置手动销毁，授权页面都会强制关闭
            }  else{
                //处理建议：其他错误代码表示闪验通道无法继续，可以统一走开发者自己的其他登录方式，也可以对不同的错误单独处理
                //1003    一键登录获取token失败
                //1008    未开启移动网络
                //1009    未检测到sim卡
                //其他     其他错误//

                //关闭授权页，如果授权页还未拉起，此调用不会关闭当前用户vc，即不执行任何代码
                [CLShanYanSDKManager finishAuthControllerCompletion:nil];
                callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.error.userInfo]);
            }
        }else{
            //一键登录获取Token成功
            NSLog(@"oneKeyLoginListener:%@",completeResult.data);

            //SDK成功获取到Token
            /** token置换手机号
             code
             */
            callback(@[[NSString stringWithFormat:@"%ld", (long)completeResult.code], completeResult.data]);
        }

    }];
}

- (CLUIConfigure *)configureStyle:(CLUIConfigure *)inputConfigure{
    CGFloat screenWidth_Portrait;
    CGFloat screenHeight_Portrait;
    screenWidth_Portrait = UIScreen.mainScreen.bounds.size.width;
    screenHeight_Portrait = UIScreen.mainScreen.bounds.size.height;

    CGFloat screenScale = [UIScreen mainScreen].bounds.size.width/375.0;
    if (screenScale > 1) {
        screenScale = 1;
    }

    UIColor * style2Color = [UIColor colorWithRed:63/255.0 green:165/255.0 blue:240/255.0 alpha:1];;

    CLUIConfigure * baseUIConfigure = inputConfigure;

    //  UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //  mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    //  [app.nav.view addSubview:mask];
    baseUIConfigure.viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;

    //横竖屏设置
    baseUIConfigure.shouldAutorotate = @(NO);

    baseUIConfigure.clAuthTypeUseWindow = @(YES);
    baseUIConfigure.clAuthWindowCornerRadius = @(10);
    //    baseUIConfigure.clAuthWindowModalTransitionStyle = @(UIModalTransitionStyleCoverVertical);

    baseUIConfigure.clNavigationBackgroundClear = @(NO);
    //    baseUIConfigure.clNavigationBackBtnHidden = @(YES);
    baseUIConfigure.clNavigationBottomLineHidden = @(YES);
    baseUIConfigure.clNavBackBtnAlimentRight = @(YES);
    //LOGO
    baseUIConfigure.clLogoImage = [UIImage imageNamed:@"icon"];

    //PhoneNumber
    baseUIConfigure.clPhoneNumberColor = style2Color;
    baseUIConfigure.clPhoneNumberFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18.0*screenScale];

    //LoginBtn
    //    baseUIConfigure.clLoginBtnText = [NSString stringWithFormat:@"一键登录%f",CFAbsoluteTimeGetCurrent()];
    baseUIConfigure.clLoginBtnText = @"一键登录";

    baseUIConfigure.clLoginBtnTextFont = [UIFont systemFontOfSize:15*screenScale];
    baseUIConfigure.clLoginBtnBgColor = style2Color;
    baseUIConfigure.clLoginBtnCornerRadius = @(10*screenScale);
    baseUIConfigure.clLoginBtnTextColor = UIColor.whiteColor;

    //Privacy
    //  baseUIConfigure.clAppPrivacyFirst = @[@"测试连接A",@"https://www.baidu.com"];
    //  baseUIConfigure.clAppPrivacySecond = @[@"18055352658",@"https://www.sina.com"];

    baseUIConfigure.clAppPrivacyColor = @[[UIColor lightGrayColor],style2Color];
    baseUIConfigure.clAppPrivacyTextAlignment = @(NSTextAlignmentCenter);
    baseUIConfigure.clAppPrivacyTextFont = [UIFont systemFontOfSize:13];
    //        baseUIConfigure.clAppPrivacyLineSpacing = @(2);
    //        baseUIConfigure.clAppPrivacyNeedSizeToFit = @(YES);

    //CheckBox
    //    baseUIConfigure.clCheckBoxHidden = @(YES);
    //  baseUIConfigure.clCheckBoxValue = @(NO);
    baseUIConfigure.clCheckBoxCheckedImage = [UIImage imageNamed:@"sdk_oauth.bundle/checkBox_selected"];
    baseUIConfigure.clCheckBoxUncheckedImage = [UIImage imageNamed:@"sdk_oauth.bundle/checkBox_unSelected"];
    baseUIConfigure.clCheckBoxImageEdgeInsets = [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(8, 8, 0, 0)];

    //Slogan
    baseUIConfigure.clSloganTextColor = UIColor.lightGrayColor;
    baseUIConfigure.clSloganTextFont = [UIFont systemFontOfSize:11.0];
    baseUIConfigure.clSlogaTextAlignment = @(NSTextAlignmentCenter);

    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setImage:[UIImage imageNamed:@"close-black"] forState:(UIControlStateNormal)];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [rightButton addTarget:self action:@selector(dismissCurrentVC) forControlEvents:UIControlEventTouchUpInside];

    // 自定义优先级更高
    //    baseUIConfigure.clNavigationRightControl = right;

    //  baseUIConfigure.clNavigationBackBtnImage = [UIImage imageNamed:@"close-black"];
    baseUIConfigure.clAppPrivacyWebBackBtnImage = [UIImage imageNamed:@"close-black"];

    __weak typeof(self) weakSelf = self;

    //layout 布局
    //布局-竖屏
    CLOrientationLayOut * clOrientationLayOutPortrait = [CLOrientationLayOut new];

    //窗口
    clOrientationLayOutPortrait.clAuthWindowOrientationWidth = @(screenWidth_Portrait * 0.8);
    clOrientationLayOutPortrait.clAuthWindowOrientationHeight = @(screenHeight_Portrait * 0.5);
    clOrientationLayOutPortrait.clAuthWindowOrientationCenter = [NSValue valueWithCGPoint:CGPointMake(screenWidth_Portrait*0.5, screenHeight_Portrait*0.5)];
    //    clOrientationLayOutPortrait.clAuthWindowOrientationOrigin = [NSValue valueWithCGPoint:CGPointMake(0, screenHeight_Portrait*0.5)];

    //控件
    clOrientationLayOutPortrait.clLayoutLogoWidth = @(108*screenScale);
    clOrientationLayOutPortrait.clLayoutLogoHeight = @(44*screenScale);
    clOrientationLayOutPortrait.clLayoutLogoCenterX = @(0);
    clOrientationLayOutPortrait.clLayoutLogoTop = @(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.15);

    clOrientationLayOutPortrait.clLayoutPhoneTop = @(clOrientationLayOutPortrait.clLayoutLogoTop.floatValue + clOrientationLayOutPortrait.clLayoutLogoHeight.floatValue);
    clOrientationLayOutPortrait.clLayoutPhoneCenterX = @(0);
    clOrientationLayOutPortrait.clLayoutPhoneHeight = @(25*screenScale);
    clOrientationLayOutPortrait.clLayoutPhoneWidth = @(screenWidth_Portrait*0.8);

    clOrientationLayOutPortrait.clLayoutLoginBtnTop= @(clOrientationLayOutPortrait.clAuthWindowOrientationHeight.floatValue*0.4 + 15*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnHeight = @(40*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnLeft = @(20*screenScale);
    clOrientationLayOutPortrait.clLayoutLoginBtnRight = @(-20*screenScale);

    clOrientationLayOutPortrait.clLayoutAppPrivacyLeft = @(40*screenScale);
    clOrientationLayOutPortrait.clLayoutAppPrivacyRight = @(-40*screenScale);
    clOrientationLayOutPortrait.clLayoutAppPrivacyBottom = @(0);
    clOrientationLayOutPortrait.clLayoutAppPrivacyHeight = @(65*screenScale);

    clOrientationLayOutPortrait.clLayoutSloganLeft = @(0);
    clOrientationLayOutPortrait.clLayoutSloganRight = @(0);
    clOrientationLayOutPortrait.clLayoutSloganHeight = @(15);
    clOrientationLayOutPortrait.clLayoutSloganBottom = @(clOrientationLayOutPortrait.clLayoutAppPrivacyBottom.floatValue - clOrientationLayOutPortrait.clLayoutAppPrivacyHeight.floatValue);

    baseUIConfigure.clOrientationLayOutPortrait = clOrientationLayOutPortrait;

    return baseUIConfigure;
}

- (void)dismissCurrentVC{
    dispatch_async(dispatch_get_main_queue(), ^{
        //    [app.nav.view.subviews[app.nav.view.subviews.count - 1] removeFromSuperview];
        [ [[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:nil];
    });
}


@end

