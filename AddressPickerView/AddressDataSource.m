//
//  AddressDataSource.m
//  AddressPickerView
//
//  Created by zpf on 2017/3/13.
//  Copyright © 2017年 XiHeLaoBo. All rights reserved.
//

//数据源类

#import "AddressDataSource.h"

@interface AddressDataSource ()

@property (nonatomic, strong) NSMutableArray *allMutableArray;
//省数据源
@property (nonatomic, strong) NSMutableArray *provinceMutableArray;
//市数据源
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
//区数据源
@property (nonatomic, strong) NSMutableArray *districtMutableArray;

@end

@implementation AddressDataSource

- (instancetype)initWithAllDataSource {
    if (self = [super init]) {
        if (!_allMutableArray) {
            _allMutableArray = [[NSMutableArray alloc] init];
        }
        [self getSource];
    }
    return self;
}

- (void)getSource {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data=[NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingAllowFragments
                                                    error:&error];
    _allMutableArray = [(NSDictionary *)jsonObject valueForKey:@"City"];
}

//获取省份数组
- (NSMutableArray *)getProvinceMutableArray {
    if (!_provinceMutableArray) {
        _provinceMutableArray = [[NSMutableArray alloc] init];
    }else{
        [_provinceMutableArray removeAllObjects];
    }
    [_allMutableArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:@"ParentCode"] isEqual:@(0)]) {
            [_provinceMutableArray addObject:obj];
        }
    }];
    return _provinceMutableArray;
}

//获取市数组
- (NSMutableArray *)getcityMutableArray:(NSInteger)code {
    if (!_cityMutableArray) {
        _cityMutableArray = [[NSMutableArray alloc] init];
    }else{
        [_cityMutableArray removeAllObjects];
    }
    [_allMutableArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:@"ParentCode"] isEqual:@(code)]) {
            [_cityMutableArray addObject:obj];
        }
    }];
    return _cityMutableArray;
}

//获取区数组
- (NSMutableArray *)getdistrictMutableArray:(NSInteger)code {
    if (!_districtMutableArray) {
        _districtMutableArray = [[NSMutableArray alloc] init];
    }else{
        [_districtMutableArray removeAllObjects];
    }
    [_allMutableArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj valueForKey:@"ParentCode"] isEqual:@(code)]) {
            [_districtMutableArray addObject:obj];
        }
    }];
    return _districtMutableArray;
}

@end
