//
//  AddressPickerView.h
//  AddressPickerView
//
//  Created by zpf on 2017/3/13.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

//核心类

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kAddressPickerViewModel) {
    kAddressPickerViewModelAll = 1,    //只有省市区
    kAddressPickerViewModelProvinceCity = 2, //只有省市
    kAddressPickerViewModelProvince = 3, //只有省
};

@interface AddressPickerView : UIView

@property (nonatomic, assign) kAddressPickerViewModel addressPickerViewModel;

- (instancetype)initWithkAddressPickerViewModel:(kAddressPickerViewModel)addressPickerViewModel;

//取消按钮的block
@property (nonatomic, copy) void (^cancelBtnBlock)();

//确定按钮的block
@property (nonatomic, copy) void (^sureBtnBlock)(NSString *province, NSString *city, NSString *district, NSString *addressCode);

//二次打开之后是否显示上一次选择的地址
@property (nonatomic, assign) BOOL showLastSelect;

//展示
- (void)showInView:(UIView *)showView;

//隐藏
- (void)hiddenInView;

@end
