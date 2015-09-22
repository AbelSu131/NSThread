//
//  ViewController.m
//  NSThread
//
//  Created by abel on 15/9/22.
//  Copyright © 2015年 abel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString  *url = @"http://img5.duitang.com/uploads/item/201503/26/20150326161657_aL8FW.jpeg";
    //创建一个线程，用来执行downloadImage方法
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:url];
    
}

//downloadImage方法
- (void)downloadImage:(NSString *)url{
    //初始化加载状态和NSMutableData对象
    _isLoaded = NO;
    _bufferData = [NSMutableData data];
    //清除response的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //建立网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //建立网络请求的连接
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (connection != nil) {
        while (!_isLoaded) {
            NSLog(@"Downloading...");
            //直到BOOL变量为false时，才跳转到下面的代码，以此实现线程的阻塞
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    //将请求返回的数据，转换为UIImage对象
    UIImage *img = [UIImage imageWithData:_bufferData];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    [imgView setCenter:CGPointMake(10, 20)];
    [self.view addSubview:imgView];
    
    //清除网络请求对象和网络连接对象
    request = nil;
    connection = nil;
}

//添加一个方法，处理网络连接结束事件
- (void)httpConnectEnd
{
    NSLog(@"httpConnectEnd");
}

//添加一个方法,处理网络连接故障事件
- (void)httpConnectEndWithError
{
    NSLog(@"httpConnectEndWithError");
}

//添加一个代理方法，处理网络连接缓存事件，这里选择不缓存
- (NSCachedURLResponse *)connecttion:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}
//添加一个代理方法，处理网络连接故障事件
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(httpConnectEndWithError) withObject:self waitUntilDone:NO];
    [_bufferData setLength:0];
    
}

//添加一个代理方法，处理接收网络数据事件。将返回的数据存入NSMutableData对象
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_bufferData appendData:data];
}

//添加一个代理方法，处理网络连接结束事件
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    self.isLoaded = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
