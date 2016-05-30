//
//  NakedBookRoomSelectTimeCell.m
//  NakedHub
//
//  Created by zhuming on 16/4/5.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "NakedBookRoomSelectTimeCell.h"
#import "NakedBookTimeCCell.h"
#import "NakedBookRoomSelectTimeView.h"
#import "Constant.h"
#import "NakedBookTimeRectModel.h"


@implementation NakedBookRoomSelectTimeCell

-(void)setBookRoomModel:(NakedBookRoomModel *)bookRoomModel
{
    _bookRoomModel = bookRoomModel;
    
    [self.CollectionView reloadData];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [Utility configSubView:_ReductionBtn CornerWithRadius:_ReductionBtn.frame.size.width/2];
    [Utility configSubView:_addBtn CornerWithRadius:_addBtn.frame.size.width/2];
}
- (void)applicationWillResignActive:(NSNotification *)notification

{
    if(_isZoom)
    {
        self.selectTV.userInteractionEnabled = YES;
        self.CollectionView.scrollEnabled = YES;
        CGRect rt =  [self.CollectionView convertRect:self.selectTV.frame fromView:self];
        CGFloat minX = 40;
        for (int i = 1; i<self.bookRoomModel.reservationTimeUnites.count+1; i++) {
            if(fabs((rt.origin.x+rt.size.width) - i*40)<fabs((rt.origin.x+rt.size.width) - minX))
            {  minX = i*40;}
        }
        if (rt.size.width<=40) {
            rt.size.width = 40;
        }
        else
        {
            rt.size.width = minX-rt.origin.x;
        }
        CGRect rect = [self convertRect:rt fromView:self.CollectionView];
        self.selectTV.frame = rect;
        self.pullView.frame = CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, 0, 50, self.selectTV.frame.size.height);
        if (self.ScalingEndCallBack) {
            self.ScalingEndCallBack();
        }
        self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
    }
    else
    {
        self.isMoved = NO;
        self.addBtn.enabled = YES;
        self.ReductionBtn.enabled = YES;
        self.pullView.userInteractionEnabled = YES;
        CGRect rc = [self.CollectionView convertRect:self.selectTV.frame fromView:self];
        self.CollectionView.scrollEnabled = YES;
        //拉到最左边的时候
        if (rc.origin.x<=0) {
            
            rc.origin.x = 0;
            CGRect rect = [self convertRect:rc fromView:self.CollectionView];
            self.selectTV.frame = rect;
        }
        //拉到最右边的时候
        else if (rc.origin.x >= (self.CollectionView.contentSize.width - rc.size.width))
        {
            rc.origin.x = self.CollectionView.contentSize.width - rc.size.width;
            CGRect rect = [self convertRect:rc fromView:self.CollectionView];
            self.selectTV.frame = rect;
        }
        else
        {
            CGFloat minX = 0;
            for (int i = 0; i<self.bookRoomModel.reservationTimeUnites.count+1; i++) {
                if(fabs(rc.origin.x - i*40)<fabs(rc.origin.x - minX))
                {  minX = i*40;}
            }
            rc.origin.x = minX;
            CGRect rects = [self convertRect:rc fromView:self.CollectionView];
            self.selectTV.frame = rects;
        }
        
        self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
        if (self.endCallBack) {
            self.endCallBack();
        }
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //监听是否触发home键挂起程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    self.cellRects = [NSMutableArray array];
    self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
    self.multipleTouchEnabled = NO;
    self.exclusiveTouch = YES;
    self.CollectionView.multipleTouchEnabled = NO;
    self.CollectionView.exclusiveTouch = YES;
    @weakify(self)
    [RACObserve(self, selectTVRectStr)subscribeNext:^(NSString *rectStr) {
        @strongify(self)
        if (self.pullView) {
            self.pullView.frame = CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, self.selectTV.frame.origin.y, 50, self.selectTV.frame.size.height);
        }
        else
        {
            self.pullView = [[NakedPullImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, self.selectTV.frame.origin.y, 50, self.selectTV.frame.size.height)];
            self.pullView.multipleTouchEnabled = NO;
            self.pullView.exclusiveTouch = YES;
            self.pullView.contentMode = UIViewContentModeScaleAspectFit;
            self.pullView.image = [UIImage imageNamed:@"pointLine"];
            [self addSubview:self.pullView];
        }
        if (self.selectTV) {
            [self bringSubviewToFront:self.pullView];
        }
        
        @weakify(self)
        [self.pullView setTouchBegin:^(UITouch *touch) {
            @strongify(self)
            self.isZoom = YES;
            self.selectTV.userInteractionEnabled = NO;
            self.CollectionView.scrollEnabled = NO;
            self.selectTV.oldRect = self.selectTV.frame;
            self.pullView.offset = [touch locationInView:self.superview];
            self.pullView.oldPoint = self.pullView.center;
            self.selectTV.maxWidth = 40;
        }];
        [self.pullView setTouchMove:^(UITouch *touch) {
            @strongify(self)
            if (self.ScalingBeginCallBack) {
                self.ScalingBeginCallBack();
            }
            CGPoint location = [touch locationInView:self];
            CGPoint temp = CGPointMake(location.x , location.y);
            float temp_x = temp.x - self.pullView.offset.x;
            CGPoint center = CGPointMake(self.pullView.oldPoint.x+temp_x, self.pullView.oldPoint.y);
            self.pullView.center = center;
            [self.pullView.layer addAnimation:[CABasicAnimation animationWithKeyPath:@"transform"] forKey:@"shake"];
            CGRect rect = self.selectTV.frame;
            
//            if (rect.size.width<40) {
//                rect.size.width = 40;
//            }
//            else
//            {
                rect.size.width = self.selectTV.oldRect.size.width+temp_x<40?40:self.selectTV.oldRect.size.width+temp_x;
//            }
            
            self.selectTV.frame = rect;
            self.selectTV.maxWidth = MAX(rect.size.width, 40);
        }];
        [self.pullView setTouchEnd:^(UITouch *touch) {
            @strongify(self)
            self.selectTV.userInteractionEnabled = YES;
            self.CollectionView.scrollEnabled = YES;
            CGRect rt =  [self.CollectionView convertRect:self.selectTV.frame fromView:self];
            CGFloat minX = 40;
            for (int i = 1; i<self.bookRoomModel.reservationTimeUnites.count+1; i++) {
                if(fabs((rt.origin.x+rt.size.width) - i*40)<fabs((rt.origin.x+rt.size.width) - minX))
                {  minX = i*40;}
            }
            if (rt.size.width<=40) {
                rt.size.width = 40;
            }
            else
            {
                rt.size.width = minX-rt.origin.x;
            }
            CGRect rect = [self convertRect:rt fromView:self.CollectionView];
            self.selectTV.frame = rect;
            self.pullView.frame = CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, 0, 50, self.selectTV.frame.size.height);
            if (self.ScalingEndCallBack) {
                self.ScalingEndCallBack();
            }
            self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
        }];

        self.addBtn.enabled = YES;
        [self.addBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:231.0/255.0 alpha:1.0]];
        self.ReductionBtn.enabled = YES;
        [self.ReductionBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:231.0/255.0 alpha:1.0]];
        CGRect rt = CGRectFromString(rectStr);
        CGRect rect = [self.CollectionView convertRect:rt fromView:self];
        self.oldContentOffSet = rect.origin.x;
        if (rect.size.width<=40) {
            self.ReductionBtn.enabled = NO;
            [self.ReductionBtn setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:212/255.0 alpha:1.0]];
        }
        if (rect.size.width+rect.origin.x>=self.CollectionView.contentSize.width) {
            self.addBtn.enabled = NO;
            [self.addBtn setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:212/255.0 alpha:1.0]];
        }
        
        NSString  *minStr = [GDLocalizableClass getStringForKey:@"Minutes"];
        self.timeLabel.text = [NSString stringWithFormat:@"%li %@",(long)(30*(rect.size.width/40)),minStr];
        NSInteger indexStart = rect.origin.x/40;
        NSInteger indexEnd = (rect.origin.x+rect.size.width)/40;
        BOOL isAllowBook = YES;
        
        for (NSInteger i = indexStart; i<indexEnd; i++) {
            if (!_bookRoomModel.reservationTimeUnites[i].allowBook) {
                isAllowBook = NO;
                break;
            }
        }
        self.selectTV.backgroundColor = isAllowBook?[UIColor orangeColor]:[UIColor colorWithRed:255.0/255.0 green:0.0 blue:0.0 alpha:0.3];
        if (self.changeTVFrame) {
            self.changeTVFrame(isAllowBook);
        }
    }];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bookRoomModel.reservationTimeUnites.count/2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NakedBookTimeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NakedBookTimeCCell" forIndexPath:indexPath];
    [cell setModel:_bookRoomModel.reservationTimeUnites[indexPath.row*2] andHalfModel:_bookRoomModel.reservationTimeUnites[indexPath.row*2+1]];
    return cell;
}
  
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NakedBookTimeCCell *cell = (NakedBookTimeCCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (!_selectTV) {

            CGRect rect = [self convertRect:cell.frame fromView:collectionView];

            _selectTV = [[NakedBookRoomSelectTimeView alloc]initWithFrame:CGRectMake(rect.origin.x, 26, 80, 54)];
            self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
            @weakify(self)
            [_selectTV setTouchBegin:^(UITouch *touch) {
                @strongify(self)
                self.isZoom = NO;
                self.pullView.userInteractionEnabled = NO;
                self.addBtn.enabled = NO;
                self.ReductionBtn.enabled = NO;
                self.isMoved = YES;
                if (self.beginCallBack) {
                    self.beginCallBack();
                }
                self.CollectionView.scrollEnabled = NO;
                self.selectTV.offset = [touch locationInView:self];
                self.selectTV.oldPoint = self.selectTV.center;
            }];
            [_selectTV setTouchMove:^(UITouch *touch) {
                @strongify(self)
                CGPoint location = [touch locationInView:self];
                CGPoint temp = CGPointMake(location.x , location.y);
                float temp_x = temp.x - self.selectTV.offset.x;
                CGPoint center = CGPointMake(self.selectTV.oldPoint.x+temp_x, self.selectTV.oldPoint.y);
                self.selectTV.center = center;
                CGRect rc = self.selectTV.frame;
                self.pullView.frame = CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, self.selectTV.frame.origin.y, 50, self.selectTV.frame.size.height);
                if (rc.origin.x<=0&&temp_x<0) {
                    if (self.CollectionView.contentOffset.x+temp_x>0) {
                        [self.CollectionView setContentOffset:CGPointMake(self.CollectionView.contentOffset.x+temp_x, 0) animated:YES];
                    }
                    else
                    {
                        [self.CollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
                    }
                }
                if (rc.origin.x+rc.size.width>=kScreenWidth&&temp_x>0) {
                    if (self.CollectionView.contentOffset.x + temp_x + kScreenWidth >= self.CollectionView.contentSize.width) {
                        [self.CollectionView setContentOffset:CGPointMake(self.CollectionView.contentSize.width-kScreenWidth, 0) animated:YES];
                    }
                    else
                    {
                        [self.CollectionView setContentOffset:CGPointMake(self.CollectionView.contentOffset.x+temp_x, 0) animated:YES];
                    }
                }
                [self.selectTV.layer addAnimation:[CABasicAnimation animationWithKeyPath:@"transform"] forKey:@"shake"];
            }];
            [_selectTV setTouchEnd:^(UITouch *touch) {
                @strongify(self)
                self.isMoved = NO;
                self.addBtn.enabled = YES;
                self.ReductionBtn.enabled = YES;
                self.pullView.userInteractionEnabled = YES;
                CGRect rc = [collectionView convertRect:self.selectTV.frame fromView:self];
                self.CollectionView.scrollEnabled = YES;
                //拉到最左边的时候
                if (rc.origin.x<=0) {
                    
                    rc.origin.x = 0;
                    CGRect rect = [self convertRect:rc fromView:collectionView];
                    self.selectTV.frame = rect;
                }
                //拉到最右边的时候
                else if (rc.origin.x >= (self.CollectionView.contentSize.width - rc.size.width))
                {
                    rc.origin.x = self.CollectionView.contentSize.width - rc.size.width;
                    CGRect rect = [self convertRect:rc fromView:collectionView];
                    self.selectTV.frame = rect;
                }
                else
                {
                    CGFloat minX = 0;
                    for (int i = 0; i<self.bookRoomModel.reservationTimeUnites.count+1; i++) {
                        if(fabs(rc.origin.x - i*40)<fabs(rc.origin.x - minX))
                        {  minX = i*40;}
                    }
                    rc.origin.x = minX;
                    CGRect rects = [self convertRect:rc fromView:collectionView];
                    self.selectTV.frame = rects;
                }
                
                self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
                if (self.endCallBack) {
                    self.endCallBack();
                }
            }];
            [_selectTV setScalingMove:^{
                @strongify(self)
                if (self.ScalingBeginCallBack) {
                    self.ScalingBeginCallBack();
                }
            }];
            [_selectTV setScalingEnd:^{
                @strongify(self)
            // 将rect从view中转换到当前视图中，返回在当前视图中的rect
                CGRect rt =  [collectionView convertRect:self.selectTV.frame fromView:self];
                CGFloat minX = 40;
                for (int i = 1; i<self.bookRoomModel.reservationTimeUnites.count+1; i++) {
                    if(fabs((rt.origin.x+rt.size.width) - i*40)<fabs((rt.origin.x+rt.size.width) - minX))
                    {  minX = i*40;}
                }
                
                CGRect rect = self.selectTV.frame;
                
                if (rect.size.width<=40) {
                    rect.size.width = 40;
                }
                else
                {
                    rect.size.width = minX-rt.origin.x;
                }
                self.selectTV.frame = rect;
                self.selectTV.pullView.frame = CGRectMake(rect.size.width-30, 0, 60, rect.size.height);
                if (self.ScalingEndCallBack) {
                    self.ScalingEndCallBack();
                }
                self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
            }];
            [self addSubview:_selectTV];
            [self bringSubviewToFront:self.pullView];
        }
        else
        {
            CGRect rect = [_CollectionView convertRect:_selectTV.frame fromView:self];
            if (cell.frame.origin.x+rect.size.width>self.CollectionView.contentSize.width) {
                rect.origin.x= self.CollectionView.contentSize.width-rect.size.width;
            }
            else
            {
                rect.origin.x = cell.frame.origin.x;
            }
            _selectTV.frame = [self convertRect:rect fromView:_CollectionView];
            self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
        }
 }


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_selectTV&&!_isMoved) {
        CGRect rt = [_CollectionView convertRect:CGRectFromString(self.selectTVRectStr) fromView:self];
        CGFloat tempx = self.oldContentOffSet - rt.origin.x;
        CGRect rect = CGRectFromString(self.selectTVRectStr);
        rect.origin.x+=tempx;
        
        _selectTV.frame = rect;
        
        self.pullView.frame = CGRectMake(CGRectGetMaxX(self.selectTV.frame)-25, self.selectTV.frame.origin.y, 50, self.selectTV.frame.size.height);
    }
    

}

- (void)loadRectCell
{
    [self.cellRects removeAllObjects];
    for (NakedBookTimeCCell*cell in self.CollectionView.visibleCells) {
        if ([cell isKindOfClass:[NakedBookTimeCCell class]]) {
            NakedBookTimeRectModel *cellRM = [[NakedBookTimeRectModel alloc]initWith:cell.frame andIndex:[self.CollectionView indexPathForCell:cell]];
            [self.cellRects addObject:cellRM];
        }
    }
}

- (IBAction)changeTime:(UIButton *)sender {
    if (sender.tag == 100) {
        [mixPanel track:@"Book_room_minus" properties:logInDic];
        CGRect rect = _selectTV.frame;
        rect.size.width-=40;
        _selectTV.frame = rect;
    }
    else
    {
        [mixPanel track:@"Book_room_plus" properties:logInDic];
        CGRect rect = _selectTV.frame;
        rect.size.width+=40;
        _selectTV.frame = rect;
    }
    self.selectTVRectStr = NSStringFromCGRect(self.selectTV.frame);
}
@end
