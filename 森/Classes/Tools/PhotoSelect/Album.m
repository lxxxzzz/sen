//
//  Album.m
//  森
//
//  Created by Lee on 2017/5/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Album.h"

@implementation Album

- (NSString *)description {
    return [NSString stringWithFormat:@"名字：%@\n数量：%ld\n结果集：%@\n", self.name, self.count, self.result];
}

//- (NSString *)chineseName {
//    if ([self.name isEqualToString:@"Bursts"]) {
//        return @"连拍快照";
//    } else if([self.name isEqualToString:@"Recently Added"]){
//        return @"最近添加";
//    } else if([self.name isEqualToString:@"Screenshots"]){
//        return @"屏幕快照";
//    } else if([self.name isEqualToString:@"Camera Roll"]){
//        return @"相机胶卷";
//    } else if([self.name isEqualToString:@"Selfies"]){
//        return @"自拍";
//    } else if([self.name isEqualToString:@"My Photo Stream"]){
//        return @"我的照片流";
//    } else if([self.name isEqualToString:@"Videos"]){
//        return @"视频";
//    } else if([self.name isEqualToString:@"All Photos"]){
//        return @"所有照片";
//    } else if([self.name isEqualToString:@"Slo-mo"]){
//        return @"慢动作";
//    } else if([self.name isEqualToString:@"Recently Deleted"]){
//        return @"最近删除";
//    } else if([self.name isEqualToString:@"Favorites"]){
//        return @"个人收藏";
//    } else if([self.name isEqualToString:@"Panoramas"]){
//        return @"全景照片";
//    } else if([self.name isEqualToString:@"Time-lapse"]){
//        return @"延时摄影";
//    } else {
//        return self.name;
//    }
//}

@end
