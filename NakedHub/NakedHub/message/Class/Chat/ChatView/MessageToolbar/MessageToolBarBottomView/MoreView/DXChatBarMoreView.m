/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 108
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    
    
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 3 * CHAT_BUTTON_SIZE) / 4;
    
    UIView  *photoView = [[UIView alloc] initWithFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE+20)];
    photoView.backgroundColor = [UIColor clearColor];
    
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(0,0,CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:_photoButton];
    
    UILabel   *photoBtnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_photoButton.frame.size.height+_photoButton.frame.origin.y+5, _photoButton.frame.size.width, 15)];
    [photoBtnTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [photoBtnTitleLabel setText:[GDLocalizableClass getStringForKey:@"Photos"]];
    [photoBtnTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [photoBtnTitleLabel setTextColor:[UIColor colorWithRed:136/255.0 green:139.0/255.0 blue:144.0/255.0 alpha:1.0]];
    [photoView addSubview:photoBtnTitleLabel];
    
    [self addSubview:photoView];
    
    UIView  *locationView = [[UIView alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE+20)];
    locationView.backgroundColor = [UIColor clearColor];
    
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(0, 0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [locationView addSubview:_locationButton];
    
    UILabel *localBtnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_locationButton.frame.size.height+_locationButton.frame.origin.y+5, _locationButton.frame.size.width, 15)];
    [localBtnTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [localBtnTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [localBtnTitleLabel setTextColor:[UIColor colorWithRed:136/255.0 green:139.0/255.0 blue:144.0/255.0 alpha:1.0]];
    [localBtnTitleLabel setText:[GDLocalizableClass getStringForKey:@"Location"]];
    [locationView addSubview:localBtnTitleLabel];
    
    [self addSubview:locationView];
    
    UIView  *tackPicView = [[UIView alloc] initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE+20)];
    tackPicView.backgroundColor = [UIColor clearColor];
    
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(0,0, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [tackPicView addSubview:_takePicButton];
    
    UILabel   *takePicBtnTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,_takePicButton.frame.size.height+_takePicButton.frame.origin.y+5, _takePicButton.frame.size.width, 15)];
    [takePicBtnTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [takePicBtnTitleLabel setText:[GDLocalizableClass getStringForKey:@"Camera"]];
    [takePicBtnTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [takePicBtnTitleLabel setTextColor:[UIColor colorWithRed:136/255.0 green:139.0/255.0 blue:144.0/255.0 alpha:1.0]];
    [tackPicView addSubview:takePicBtnTitleLabel];
    
    [self addSubview:tackPicView];

    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
//        frame.size.height = 150;
//        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
//        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
//        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_audioCallButton];
//        
//        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
//        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
//        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
//        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_videoCallButton];
    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = CHAT_BUTTON_SIZE +50;
    }
    self.frame = frame;
}

#pragma mark - action

- (void)takePicAction{
    [mixPanel track:@"Chat_takePic" properties:logInDic];
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    [mixPanel track:@"Chat_photo" properties:logInDic];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    [mixPanel track:@"Chat_location" properties:logInDic];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

@end
