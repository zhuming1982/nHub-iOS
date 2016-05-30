//
//  CornerRadiusBorderView.h
//  SportSocial
//
//  Created by wings on 15/11/18.
//  Copyright © 2015年 cloudrui. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CornerRadiusBorderView : UIView

@property (nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic,assign) IBInspectable CGFloat borderWidth;
@property (nonatomic,assign) IBInspectable UIColor *borderColor;

@end
