//
//  NetWorkAPIUrl.h
//  NakedHub
//
//  Created by zhuming on 16/3/21.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#ifndef NetWorkAPIUrl_h
#define NetWorkAPIUrl_h

//#define APP_APIBASEURL @"http://139.196.26.60:8088/nakedhub/"

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

//标记是否测试环境,如果是正式环境,注释掉这句
//#define IS_TESTING



//#ifdef IS_TESTING
////环信应用标识(AppKey):测试 
#define HUAN_XIN_TEST_APPKEY @"naked-hub#nhubdev"
#define HUAN_XIN_APPKEY @"naked-hub#nhub"

//环信推送证书标识 测试
#define HUAN_XIN_APNS_TEST_CERT_NAME @"nakedHubtest"
#define HUAN_XIN_APNS_CERT_NAME @"disHub"

#define APP_Test_APIBASEURL @"http://139.196.26.60:8088/nakedhub/api/"
#define APP_APIBASEURL @"http://app.nakedhub.cn/nakedhub/api/"

//#else
////环信应用标识(AppKey):线上
//#define HUAN_XIN_APPKEY @"naked-hub#nhubdev"
////环信推送证书标识 线上
//#define HUAN_XIN_APNS_CERT_NAME @"nakedHubpro"
//
////服务器首地址
//#define APP_APIBASEURL @"http://139.196.26.60:8088/nakedhub/"
//#endif


//会员资格列表接口
#define memberShip_list @"membership/list"

//获取验证码
#define auth_reqSmsCode @"auth/reqSmsCode"

//验证手机验证码
#define auth_verify @"auth/verify"

//用户注册支付接口
#define pay_open_addRegOrder @"pay/open/addRegOrder"

//用户注册支付接口
#define pay_open_pay @"pay/open/pay"


//用户注册
#define auth_reg @"auth/reg"

//用户登录
#define auth_login @"auth/login"

//发布动态
#define feed_post @"feed/post"

//动态列表
#define feed_list @"feed/list"

//(动态)点赞/取消点赞
#define feed_like @"feed/like"

//动态详情
#define feed_(feedId) [NSString stringWithFormat:@"feed/%li",(long)feedId]

//动态评论列表
#define feed_feedComments @"feed/feedComments"

//评论
#define feed_comment @"feed/comment"

//(评论)点赞/取消点赞
#define feed_comment_like @"feed/comment/like"

//国家码
#define auth_area_phoneCode_list @"auth/area/phoneCode/list"

//举报
#define user_report @"user/report"

//hub列表
#define hub_list @"hub/list"

//用户详情
#define user_detail @"user/detail"

//绑定俱乐部
#define hub_bind @"hub/bind"

//编辑个人详情
#define user_profile_edit @"user/profile/edit"

//批量拉用户对象
#define chat_users @"chat/users"

//社区首页－> service列表
#define community_service_list @"community/service/list"
//群聊列表
#define chat_chatGroups @"chat/chatGroups"

//搜索用户
#define user_search @"user/search"
//社区首页 - > companies列表
#define community_service_companies @"community/service/companies"
//搜索用户
#define user_search @"user/search"
#define chat_group_add @"chat/group/add"

//群组成员列表
#define chat_members @"chat/members"
//社区首页
#define community_index @"community/index"
//社区首页 - > 公司详情
#define company_(company_id) [NSString stringWithFormat:@"company/%li",(long)company_id]
//公司编辑
#define company_edit @"company/edit"
//管理公司
#define company_manage @"company/manage"


//我的公司
#define company_myCompany @"company/myCompany"

//关注/取消关注
#define user_follow @"user/follow"
//聊天列表(既可以查询用户列表,也可以查询群聊列表)
#define chat_chatList @"chat/chatlist"
//公司列表
#define community_company_list @"community/company/list"
//创建群聊
#define chat_group_add @"chat/group/add"

//可预定MettingRoom列表
#define reservation_mettingRoom_list @"reservation/mettingRoom/list"

//预定首页信息
#define reservation_index @"reservation/index"

// 预定
#define reservation_book_mettingRoom @"reservation/book/meetingRoom"

//today 搜索条件
#define today_queryUnits @"today/queryUnits"
//today 首页信息
#define today_index @"today/index"
//预定记录列表
#define today_reservationRecords @"today/reservationRecords"
//推送消息列表
#define today_pushMessages @"today/pushMessages"
//预定详情
#define reservation_detail(reservation_id) [NSString stringWithFormat:@"reservation/record/%li",(long)reservation_id]
//取消预定 POST
#define reservation_book_cancel @"reservation/book/cancel"

//
#define feed(feed_id) [NSString stringWithFormat:@"feed/%li",(long)feed_id]

//
#define feed_like_new @"feed/like_new"

//检查团队激活码
#define auth_teamCode_check @"auth/teamCode/check"


//消息接口
#define chat_saveChatMessage   @"chat/saveChatMessage"

//消息接口
#define getPushMsg_count   @"message/pushmessage/count"
//标记消息已读
#define message_pushmessage_mark @"message/pushmessage/mark" 

//hub列表
#define hub_list @"hub/list"

/* Hub信息 */
#define hub_information(hub_id) [NSString stringWithFormat:@"hub/%li",(long)hub_id]

//hubs列表
#define reservation_hubs @"reservation/hubs"

//预定workspace
#define reservation_book_workspace @"reservation/book/workspace"

//修改密码
#define auth_password_modify @"auth/password/modify"

//用户配额
#define user_myQuota @"user/myQuota"

//用户动态
#define feed_userFeeds @"feed/userFeeds"

/* Events 活动 */
#define events_list @"event/list"

/* 参加活动 */
#define events_attend @"event/attend"

/* 活动详情 */
#define events(events_id) [NSString stringWithFormat:@"event/%li", (long)events_id]

/* 参与者列表 */
#define events_attendees(events_id) [NSString stringWithFormat:@"event/%li/attendees", (long)events_id]

/* 筛选活动标签页列表 */
#define events_category @"event/category"

/* Today 页面到 events (即将到来的活动)*/
#define today_events @"today/events"
/* Search */
#define searchByKeyWord @"search/searchByKeyWord"

/* Search 推荐 */
#define search_recommend @"search/recommend"

/* Search 推荐详情 */
#define search_recommend_detail @"search/recommend/detail"

/* Search VIEW ALL*/
#define searchByKeyWordAndType @"search/searchByKeyWordAndType"

#endif /* NetWorkAPIUrl_h */
