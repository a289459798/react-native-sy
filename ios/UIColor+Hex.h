//
//  UIColor+Hex.h
//  Base64
//
//  Created by zhangzy on 2020/3/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *) colorWithHexString: (NSString *)color;

@end

NS_ASSUME_NONNULL_END
