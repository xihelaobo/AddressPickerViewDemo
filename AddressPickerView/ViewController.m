//
//  ViewController.m
//  AddressPickerView
//
//  Created by zpf on 2017/3/13.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

//调用类

#import "ViewController.h"
#import "AddressPickerView.h"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height
#define AddressPickerViewHeight 256

@interface ViewController ()

@property (nonatomic, strong) AddressPickerView *addressPickerView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *addressNameLab;

@property (nonatomic, strong) UILabel *addressCodeLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地址选择器";
    
    __weak ViewController *weakSelf = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //用一个按钮的点击事件来调起地址选择器
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(50, 30, 100, 50);
    _button.backgroundColor = [UIColor redColor];
    [_button setTitle:@"Show" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    //展示出来选中的地区名称
    _addressNameLab = [[UILabel alloc] init];
    _addressNameLab.frame = CGRectMake(50, 120, iPhoneW - 100, 40);
    _addressNameLab.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_addressNameLab];
    
    //展示出来地区编码(2017年最新规则地区编码)
    _addressCodeLab = [[UILabel alloc] init];
    _addressCodeLab.frame = CGRectMake(50, 200, iPhoneW - 100, 40);
    _addressCodeLab.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_addressCodeLab];
    
    //调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
    _addressPickerView = [[AddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
    //默认为NO
    //_addressPickerView.showLastSelect = YES;
    _addressPickerView.cancelBtnBlock = ^() {
        //移除掉地址选择器
        [weakSelf.addressPickerView hiddenInView];
    };
    _addressPickerView.sureBtnBlock = ^(NSString *province, NSString *city, NSString *district, NSString *addressCode) {
        //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断,(province和addressCode为必返回参数,可以不做非空判断)
        
        NSString *showString;
        
        if (city != nil) {
            showString = [NSString stringWithFormat:@"%@-%@", province, city];
        }else{
            showString = province;
        }
        if (district != nil) {
            showString = [NSString stringWithFormat:@"%@-%@", showString, district];
        }
        
        weakSelf.addressNameLab.text = [NSString stringWithFormat:@"地址:%@", showString];
        weakSelf.addressCodeLab.text = [NSString stringWithFormat:@"地区编码:%@", addressCode];
        //移除掉地址选择器
        [weakSelf.addressPickerView hiddenInView];
    };
}

//按钮点击方法的实现
- (void)buttonClick:(id)sender {
    //展示地址选择器
    [_addressPickerView showInView:self.view];
}

#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
