# AddressPickerViewDemo
这是一个地址选择工具类,提供三种模式可供选择.
```核心类
#import "AddressPickerView.h"
```
```数据源类
#import "AddressDataSource.h"
```
```在控制器中的调用
//用一个按钮的点击事件来调起地址选择器
_button = [UIButton buttonWithType:UIButtonTypeCustom];
_button.frame = CGRectMake(50, 30, 100, 50);
_button.backgroundColor = [UIColor redColor];
[_button setTitle:@"Show" forState:UIControlStateNormal];
[_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:_button];

//调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
    _addressPickerView = [[AddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
    //默认为NO
    //_addressPickerView.showLastSelect = YES;
    _addressPickerView.cancelBtnBlock = ^() {
        //移除掉地址选择器
        [weakSelf.addressPickerView hiddenInView];
    };
    _addressPickerView.sureBtnBlock = ^(NSString *province, NSString *city, NSString *district, NSString *addressCode) {
        //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断
        
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

//按钮点击方法的实现
- (void)buttonClick:(id)sender {
    //展示地址选择器
    [_addressPickerView showInView:self.view];
}
```
