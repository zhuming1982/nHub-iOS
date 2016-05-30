//
//  NakedCommentCell.h
//  NakedHub
//
//  Created by zhuming on 16/3/14.
//  Copyright © 2016年 朱明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NakedHubCommentsModel.h"
#import "SYFavoriteButton.h"

@interface NakedCommentCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView  *headPortraitView;

@property (weak, nonatomic) IBOutlet UILabel      *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UILabel      *nakedHubNameLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet SYFavoriteButton *favoriteBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong) NakedHubCommentsModel *commentsModel;
@property (nonatomic,strong)void (^likeClikeCallBack)();
@property (nonatomic,copy)void (^ActionClikeLinkBlock)(NSURL*url);
@property (nonatomic,copy)void (^clikeUserAvatarImageViewActionBlock)(UIImageView *imgView);
-(void)ClikeWithLink:(NSURL*)string
       andController:(UIViewController*)vc;

-(void)likeClikeWithFeedModel:(NakedHubCommentsModel*)model
                andController:(UIViewController*)vc
                          and:(void(^)(NakedHubCommentsModel*model))block;

-(void)likeCommentWithVC:(UIViewController*)vc andComments:(NakedHubCommentsModel*)commentsModel;
- (IBAction)likeAction:(UIButton *)sender;


-(void) gotoUserDetailsVC:(NakedUserModel*)user andVC:(UIViewController*)vc;


@end
