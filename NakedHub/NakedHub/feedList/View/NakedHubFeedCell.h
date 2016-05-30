//
//  NakedHubFeedCell.h
//  NakedHub
//
//  Created by 朱明 on 16/3/11.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYFavoriteButton.h"
#import "NakedHubFeedModel.h"
#import "STTweetLabel.h"


@interface NakedHubFeedCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView               *headPortraitView;
@property (weak, nonatomic) IBOutlet UILabel                   *nameLabel;
@property (weak, nonatomic) IBOutlet SYFavoriteButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (nonatomic,copy) NSString *QRCodeResul;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidth;

@property (nonatomic,copy) void (^RecognizeQRCodeCallBack)();

@property (weak, nonatomic) IBOutlet UILabel *hubNameLabel;
@property (weak, nonatomic) IBOutlet UILabel                    *distanceLabel;
@property (weak, nonatomic) IBOutlet STTweetLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView                *feedImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *contentLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *feedImageViewTopConstraint;
@property (nonatomic,strong) NakedHubFeedModel *feedModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedImageHeightConstraint;

@property (nonatomic,copy)void (^buttonActionBlock)(UIButton *btn);
@property (nonatomic,copy)void (^clikeImageViewActionBlock)(UIImageView *imgView);
@property (nonatomic,copy)void (^clikeUserAvatarImageViewActionBlock)(UIImageView *imgView);

@property (nonatomic,copy)void (^ActionClikeLinkBlock)(NSURL*url);


-(void)commentClikeWithFeedModel:(NakedHubFeedModel*)model
                   andController:(UIViewController*)vc;

//-(void)likeClikeWithFeedModel:(NakedHubFeedModel*)model
//                andController:(UIViewController*)vc;


-(void)likeClikeWithFeedModel:(NakedHubFeedModel*)model
                andController:(UIViewController*)vc
                          and:(void(^)(NakedHubFeedModel*model))block;

-(void)ForWardClikeWithFeedModel:(NakedHubFeedModel*)model
                   andController:(UIViewController*)vc;

-(void)ClikeWithLink:(NSURL*)string
       andController:(UIViewController*)vc;

-(void)showHostImageView:(UIImageView*)imageV andVC:(UIViewController*)vc;
-(void) gotoUserDetailsVC:(NakedUserModel*)user andVC:(UIViewController*)vc;
- (IBAction)favorite:(SYFavoriteButton *)sender;
- (IBAction)comment:(UIButton *)sender;
- (IBAction)more:(UIButton *)sender;


@end
