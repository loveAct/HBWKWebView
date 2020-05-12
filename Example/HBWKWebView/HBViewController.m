//
//  HBViewController.m
//  HBWKWebView
//
//  Created by wanghaibo1991 on 04/26/2020.
//  Copyright (c) 2020 wanghaibo1991. All rights reserved.
//

#import "HBViewController.h"
#import <HBWKWebViewHeader.h>
@interface HBViewController ()

@end

@implementation HBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    HBWKWebViewController *webVC = [[HBWKWebViewController alloc]init];
    
    [webVC loadRequestWithUrl:@"https://www.baidu.com"];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
