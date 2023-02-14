//
//  YBVideoEditModel.h
//  EnglishVideoStudio
//
//  Created by liQi on 2019/8/6.
//  Copyright © 2019 优贝科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YBVideoEditModel : NSObject

@property (nonatomic, assign) CGFloat needVideoTime;
@property (nonatomic, assign) CGFloat needVideoHeight;
@property (nonatomic, assign) CGFloat needVideoWeight;
@property (nonatomic, copy, nullable) void(^didSelectVideo)(UIImage *img, NSString *videoPath);

@end

NS_ASSUME_NONNULL_END
