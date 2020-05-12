//
//  HBWKWebViewNaviBarView.m
//  testWebView_Example
//
//  Created by 王海波 on 2020/4/26.
//  Copyright © 2020 wanghaibo1991. All rights reserved.
//

#import "HBWKWebViewNaviBarView.h"
#import <Masonry/Masonry.h>
@implementation HBWKWebViewNaviBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLbl];
    [self addSubview:self.rightBtn];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(5);
        make.bottom.equalTo(self);
        make.height.equalTo(@44);
        make.width.equalTo(@50);
    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.backBtn);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:0];
        [_backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0,10);
    }return _backBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:18];
    }return _titleLbl;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn =
        _rightBtn = [UIButton buttonWithType:0];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightBtn;
}




@end
