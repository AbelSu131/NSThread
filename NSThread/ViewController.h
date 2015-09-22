//
//  ViewController.h
//  NSThread
//
//  Created by abel on 15/9/22.
//  Copyright © 2015年 abel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLConnectionDelegate>
@property (nonatomic) BOOL isLoaded;//标识加载状态
@property (nonatomic) NSMutableData *bufferData;//用来接收网络数据





@end

