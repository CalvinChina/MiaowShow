//
//  XMGTopWindow.m
//  HealthyNews
//
//  Created by ALin on 16/1/22.
//  Copyright © 2016年 ALin. All rights reserved.
//
#import "SLTopWindow.h"

@implementation SLTopWindow

static UIButton *btn_;

+ (void)initialize
{
    if (@available(iOS 13.0, *)) {
        // 获取主窗口的 UIStatusBarManager
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UIStatusBarManager *statusBarManager = keyWindow.windowScene.statusBarManager;
        
        // 获取状态栏的 frame
        CGRect statusBarFrame = statusBarManager.statusBarFrame;
        
        // 创建按钮并添加到状态栏的 view 中
        UIButton *btn = [[UIButton alloc] initWithFrame:statusBarFrame];
        [btn addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
        [keyWindow addSubview:btn];
        btn.hidden = YES;
        btn_ = btn;
    } else {
        // 对于旧版本 iOS，可以保持原有实现，但建议尽量迁移到新 API
        UIButton *btn = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        [btn addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
        [[self statusBarView] addSubview:btn];
        btn.hidden = YES;
        btn_ = btn;
    }
}

+ (void)show
{
    btn_.hidden = NO;
}

+ (void)hide
{
    btn_.hidden = YES;
}

// 这个方法在 iOS 13 及更高版本中不再适用
+ (UIView *)statusBarView
{
    UIView *statusBar = nil;
    if (@available(iOS 13.0, *)) {
        // 在 iOS 13 及更高版本中，使用 keyWindow 的 windowScene 的 statusBarManager 来获取状态栏 frame
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow) {
            UIStatusBarManager *statusBarManager = keyWindow.windowScene.statusBarManager;
            if (statusBarManager) {
                statusBar = [[UIView alloc] initWithFrame:statusBarManager.statusBarFrame];
            }
        }
    } else {
        // 对于旧版本 iOS
        NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
        NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        id object = [UIApplication sharedApplication];
        if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
    }
    return statusBar;
}

/**
 * 监听窗口点击
 */
+ (void)windowClick
{
    NSLog(@"点击了最顶部...");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}

@end
