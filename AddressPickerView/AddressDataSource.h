//
//  AddressDataSource.h
//  AddressPickerView
//
//  Created by zpf on 2017/3/13.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

//数据源类

#import <Foundation/Foundation.h>

@interface AddressDataSource : NSObject

- (instancetype)initWithAllDataSource;
//获取省份数组
- (NSMutableArray *)getProvinceMutableArray;
//获取市数组
- (NSMutableArray *)getcityMutableArray:(NSInteger)code;
//获取区数组
- (NSMutableArray *)getdistrictMutableArray:(NSInteger)code;


@end
