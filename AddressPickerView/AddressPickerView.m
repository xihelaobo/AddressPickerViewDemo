//
//  AddressPickerView.m
//  AddressPickerView
//
//  Created by zpf on 2017/3/13.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

//核心类

#import "AddressPickerView.h"
#import "AddressDataSource.h"

#define iPhoneW [UIScreen mainScreen].bounds.size.width
#define iPhoneH [UIScreen mainScreen].bounds.size.height
#define kPickerViewH 216
#define AddressPickerViewHeight 256

@interface AddressPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>
//取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//确定按钮
@property (nonatomic, strong) UIButton *sureBtn;
//pickerView
@property (nonatomic, strong) UIPickerView *pickerView;
//数据源
@property (nonatomic, strong) AddressDataSource *addressDataSource;
//省数据源
@property (nonatomic, strong) NSMutableArray *provinceMutableArray;
//市数据源
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
//区数据源
@property (nonatomic, strong) NSMutableArray *districtMutableArray;
//背景图
@property (nonatomic, strong) UIView *backView;
//省级字符串名称
@property (nonatomic, strong) NSString *provinceString;
//市级字符串名称
@property (nonatomic, strong) NSString *cityString;
//区级字符串名称
@property (nonatomic, strong) NSString *districtString;
//选中的地区的code
@property (nonatomic, strong) NSString *addressCodeString;
@end

@implementation AddressPickerView

- (instancetype)initWithkAddressPickerViewModel:(kAddressPickerViewModel)addressPickerViewModel {
    if (self = [super init]) {
        _addressPickerViewModel = addressPickerViewModel;
        self.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:246.0/255.0 alpha:1.0];
        self.frame = CGRectMake(0, iPhoneH, iPhoneW, AddressPickerViewHeight);
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    //初始化数据源类
    _addressDataSource = [[AddressDataSource alloc] initWithAllDataSource];
    if (_addressPickerViewModel == kAddressPickerViewModelAll) {
        //获取省份数据源
        _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
        _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
        //获取市数据源
        _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray.firstObject valueForKey:@"Code"] integerValue]];
        _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
        //获取区数据源
        _districtMutableArray = [_addressDataSource getdistrictMutableArray:[[_cityMutableArray.firstObject valueForKey:@"Code"] integerValue]];
        _districtString = [_districtMutableArray.firstObject valueForKey:@"RegName"];
        _addressCodeString = [_districtMutableArray.firstObject valueForKey:@"Code"];
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
        //获取省份数据源
        _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
        _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
        //获取市数据源
        _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray.firstObject valueForKey:@"Code"] integerValue]];
        _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
        _addressCodeString = [_cityMutableArray.firstObject valueForKey:@"Code"];
    }else{
        //获取省份数据源
        _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
        _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
        _addressCodeString = [_provinceMutableArray.firstObject valueForKey:@"Code"];
    }
    
    
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(10, 0, 50, 40);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    //确定按钮
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(iPhoneW - 60, 0, 50, 40);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:38.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
    
    //PickerView
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, iPhoneW, kPickerViewH)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    _pickerView.showsSelectionIndicator = YES;
    [self addSubview:_pickerView];
    
    _showLastSelect = NO;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_addressPickerViewModel == kAddressPickerViewModelAll) {
        return 3;
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
        return 2;
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvince) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_addressPickerViewModel == kAddressPickerViewModelAll) {
        if (component == 0) {
            return _provinceMutableArray.count;
        }else if (component == 1) {
            return _cityMutableArray.count;
        }else{
            return _districtMutableArray.count;
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
        if (component == 0) {
            return _provinceMutableArray.count;
        }else{
            return _cityMutableArray.count;
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvince) {
        if (component == 0) {
            return _provinceMutableArray.count;
        }
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_addressPickerViewModel == kAddressPickerViewModelAll) {
        if (component == 0) {
            return [_provinceMutableArray[row] valueForKey:@"RegName"];
        }else if (component == 1) {
            return [_cityMutableArray[row] valueForKey:@"RegName"];
        }else{
            return [_districtMutableArray[row] valueForKey:@"RegName"];
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
        if (component == 0) {
            return [_provinceMutableArray[row] valueForKey:@"RegName"];
        }else{
            return [_cityMutableArray[row] valueForKey:@"RegName"];
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvince) {
        if (component == 0) {
            return [_provinceMutableArray[row] valueForKey:@"RegName"];
        }
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_addressPickerViewModel == kAddressPickerViewModelAll) {
        if (component == 0) {
            _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray[row] valueForKey:@"Code"] integerValue]];
            _districtMutableArray = [_addressDataSource getdistrictMutableArray:[[_cityMutableArray.firstObject valueForKey:@"Code"] integerValue]];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadAllComponents];
            
            _provinceString = [_provinceMutableArray[row] valueForKey:@"RegName"];
            _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
            _districtString = [_districtMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_districtMutableArray.firstObject valueForKey:@"Code"];
            
        }else if (component == 1) {
            _districtMutableArray = [_addressDataSource getdistrictMutableArray:[[_cityMutableArray[row] valueForKey:@"Code"] integerValue]];
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            [_pickerView reloadAllComponents];
            
            _cityString = [_cityMutableArray[row] valueForKey:@"RegName"];
            _districtString = [_districtMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_districtMutableArray.firstObject valueForKey:@"Code"];
            
        }else{
            [_pickerView reloadAllComponents];
            _districtString = [_districtMutableArray[row] valueForKey:@"RegName"];
            _addressCodeString = [_districtMutableArray[row] valueForKey:@"Code"];
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
        if (component == 0) {
            _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray[row] valueForKey:@"Code"] integerValue]];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView reloadAllComponents];
            
            _provinceString = [_provinceMutableArray[row] valueForKey:@"RegName"];
            _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_cityMutableArray.firstObject valueForKey:@"Code"];
            
        }else{
            [_pickerView reloadAllComponents];
            _cityString = [_cityMutableArray[row] valueForKey:@"RegName"];
            _addressCodeString = [_cityMutableArray[row] valueForKey:@"Code"];
        }
    }else if (_addressPickerViewModel == kAddressPickerViewModelProvince) {
        [_pickerView reloadAllComponents];
        _provinceString = [_provinceMutableArray[row] valueForKey:@"RegName"];
        _addressCodeString = [_provinceMutableArray[row] valueForKey:@"Code"];
    }
}

//设置字体
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//展示
- (void)showInView:(UIView *)showView {
    if (!_showLastSelect) {
        [_provinceMutableArray removeAllObjects];
        [_cityMutableArray removeAllObjects];
        [_districtMutableArray removeAllObjects];
        
        if (_addressPickerViewModel == kAddressPickerViewModelAll) {
            //获取省份数据源
            _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
            _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
            //获取市数据源
            _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray.firstObject valueForKey:@"Code"] integerValue]];
            _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
            //获取区数据源
            _districtMutableArray = [_addressDataSource getdistrictMutableArray:[[_cityMutableArray.firstObject valueForKey:@"Code"] integerValue]];
            _districtString = [_districtMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_districtMutableArray.firstObject valueForKey:@"Code"];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            [_pickerView selectRow:0 inComponent:2 animated:NO];
            
            [_pickerView reloadAllComponents];
        }else if (_addressPickerViewModel == kAddressPickerViewModelProvinceCity) {
            //获取省份数据源
            _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
            _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
            //获取市数据源
            _cityMutableArray = [_addressDataSource getcityMutableArray:[[_provinceMutableArray.firstObject valueForKey:@"Code"] integerValue]];
            _cityString = [_cityMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_cityMutableArray.firstObject valueForKey:@"Code"];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            [_pickerView selectRow:0 inComponent:1 animated:NO];
            
            [_pickerView reloadAllComponents];
        }else{
            //获取省份数据源
            _provinceMutableArray = [_addressDataSource getProvinceMutableArray];
            _provinceString = [_provinceMutableArray.firstObject valueForKey:@"RegName"];
            _addressCodeString = [_provinceMutableArray.firstObject valueForKey:@"Code"];
            
            [_pickerView selectRow:0 inComponent:0 animated:NO];
            
            [_pickerView reloadAllComponents];
        }
    }
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneW, showView.bounds.size.height)];
    }
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [showView addSubview:_backView];
    [showView addSubview:self];
    [UIView animateWithDuration:0.1f animations:^{
        _backView.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            self.frame = CGRectMake(0, showView.bounds.size.height - AddressPickerViewHeight, iPhoneW, AddressPickerViewHeight);
        }];
    }];
}

//隐藏
- (void)hiddenInView {
    [UIView animateWithDuration:0.1f animations:^{
        self.frame = CGRectMake(0, iPhoneH, iPhoneW, AddressPickerViewHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f animations:^{
            _backView.alpha = 0.0;
        }];
        [_backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)cancelBtnClick:(UIButton *)button {
    if (_cancelBtnBlock) {
        _cancelBtnBlock();
    }
}

- (void)sureBtnClick:(UIButton *)button {
    if (_sureBtnBlock) {
        _sureBtnBlock(_provinceString, _cityString, _districtString, _addressCodeString);
    }
}


@end
