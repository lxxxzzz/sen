//
//  Util.m
//  森
//
//  Created by Lee on 2017/5/2.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Util.h"
#import "Photo.h"
#import <AliyunOSSiOS.h>

@implementation Util

+ (void)uploadImages:(NSArray *)images isAsync:(BOOL)isAsync success:(void(^)(NSArray *urls))success failure:(void(^)(NSError *error))failure {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *urls = [NSMutableArray array];
    for (int i=0; i<images.count; i++) {
        id obj = images[i];
        if ([obj isKindOfClass:[Photo class]]) {
            Photo *photo = (Photo *)obj;
            if (photo.hdImage) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    NSString *endpoint = kAliyunEndpoint;
                    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:kAliyunAccessKey secretKey:kAliyunSecretKey];
                    OSSClient *ossClient = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
                    //任务执行
                    NSString *uuid = [[NSUUID UUID] UUIDString];
                    OSSPutObjectRequest *put = [[OSSPutObjectRequest alloc] init];
                    put.bucketName = kAliyunBucketName;
                    NSDateFormatter *format = [[NSDateFormatter alloc] init];
                    format.dateFormat = @"yyyy-MM-dd-hh:mm:ss:SSS";
                    NSString *date = [format stringFromDate:[NSDate date]];
                    NSString *fileName = [NSString stringWithFormat:@"%@-%@.png", uuid, date];
                    put.objectKey = [NSString stringWithFormat:@"upload/user_app/%@", fileName];
//                    put.uploadingData = UIImagePNGRepresentation(photo.hdImage); // 直接上传NSData
                    put.uploadingData = UIImageJPEGRepresentation(photo.hdImage, 0.4);
                    Log(@"%ld", put.uploadingData.length);
                    OSSTask * putTask = [ossClient putObject:put];
                    [putTask waitUntilFinished]; // 阻塞直到上传完成
                    if (!putTask.error) {
                        Log(@"上传成功!!!!!!!!");
                        NSString *imageURL = [NSString stringWithFormat:@"http://%@.%@/%@", put.bucketName, kAliyunEndpoint, put.objectKey];
                        [urls addObject:imageURL];
                    } else {
                        Log(@"上传失败......, error: %@" , putTask.error);
                        if (failure) {
                            failure(putTask.error);
                        }
                        return;
                    }
                    if (isAsync) {
                        if (photo == images.lastObject) {
                            Log(@"上传完成....");
                            if (success) {
                                success(urls);
                            }
                        }
                    }
                }];
                if (queue.operations.count != 0) {
                    [operation addDependency:queue.operations.lastObject];
                }
                [queue addOperation:operation];
            }
        } else if ([obj isKindOfClass:[NSString class]]) {
            // 如果是url，直接放进去
            [urls addObject:obj];
        } else {
            Log(@"不明确数据类型%@", [obj class]);
        }
    }
    if (!isAsync) {
        [queue waitUntilAllOperationsAreFinished];
        if (success) {
            Log(@"上传完成....");
            success(urls);
        }
    }
}

@end
