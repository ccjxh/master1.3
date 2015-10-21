//
//  NSObject+URL.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+URL.h"

@implementation NSObject (URL)
-(NSString*)interfaceFromString:(interface)string
{
    NSString*urlString;
    switch (string) {
            case interface_cityList:
            urlString=@"location/allCityList";
            break;
            case interface_provinceList:
            urlString=@"location/provinceList";
            break;
            case interface_detail:
            urlString=@"user/location/regionList";
            break;
            case interface_list:
            urlString=@"user/list";
            break;
            case interface_skill:
            urlString=@"user/servicerSkill/allSkill";
            break;
            case interface_resigionList:
            urlString=@"location/regionList";
            break;
            case interface_login:
            urlString=@"user/login";
            break;
            case interface_loginout:
            urlString=@"user/logout";
            break;
            case interface_register:
            urlString=@"user/register";
            break;
            case interface_myServicerDetail:
            urlString=@"servicer/myServicerDetail";
            break;
            case interface_updateGendar:
            urlString=@"information/updateGendar";
            break;
            case interface_resetPassword:
            urlString=@"user/resetPassword";
            break;
            case interface_updateweChat:
            urlString=@"information/updateWeChat";
            break;
            case interface_updateRealName:
            urlString=@"/information/updateRealName";
            break;
            case interface_updateIDNo:
            urlString=@"/information/updateIdNo";
            break;
            case interface_personalDetail:
            urlString=@"/information/detail";
            break;
            case interface_updateQQ:
            urlString=@"/information/updateQQ";
            break;
            case interface_masterDetail:
            urlString=@"user/detail";
            break;
            case interface_uploadHeadImage:
            urlString=@"information/uploadIcon";
            break;
            case interface_commitProblem:
            urlString=@"feedback/addFeedback";
            break;
            case interface_allCityList:
            urlString=@"location/cityList";
            break;
            case interface_uploadIdentity:
            urlString=@"certifyInfo/personCertify";
            break;
            case interface_IDCity:
            urlString=@"location/cityList";
            break;
            case interface_IDTown:
            urlString=@"location/regionList";
            break;
            case interface_commonAdress:
            urlString=@"address/list";
            break;
            case interface_projectCaseImage:
            urlString=@"masterProjectCase/datail";
            break;
            case interface_projectCase:
            urlString=@"masterProjectCase/list";
            break;
            case interface_certainUpload:
            urlString=@"common/attachment/uploadFile";
            break;
            case interface_updateStartWork:
            urlString=@"servicer/updateStartWork";
            break;
            case interface_updateServicerSkill:
            urlString=@"servicer/updateServicerSkill";
            break;
            case interface_updateServicerRegion:
            urlString=@"servicer/updateServicerRegion";
            break;
            case interface_updateServiceDescribe:
            urlString=@"servicer/updateServiceDescribe";
            break;
            case interface_updateStatus:
            urlString=@"servicer/updateStatus";
            break;
            case interface_findRecommend:
            urlString=@"servicer/referrerSelectList";
            break;
            case interface_sendRecommend:
            urlString=@"servicer/requestRecommend";
            break;
            case interface_myOrder:
            urlString=@"masterOrder/listByMaster";
            break;
            case interface_myNextOrder:
            urlString=@"masterOrder/listByBuyer";
            break;
            case interface_myOrderDetail:
            urlString=@"masterOrder/detail";
            break;
            case interface_myNextConfirm:
            urlString=@"masterOrder/unConfirmListByBuyer";
            break;
            case interface_myNextComment:
            urlString=@"masterOrder/unCommentListByBuyer";
            break;
            case interface_finish:
            urlString=@"masterOrder/finishWork";
            break;

            case interface_myorderConfirm:
            urlString=@"masterOrder/unAcceptListByMaster";
            break;
            case interface_myorderCommend:
            urlString=@"masterOrder/unReplyListByMaster";
            break;
            case interface_scoreType:
            urlString=@"servicer/scoreTypeList";
            break;
            case interface_comment:
            urlString=@"masterOrder/comment";
            break;

            case interface_commitOrder:
            urlString=@"masterOrder/generateOrder";
            break;
            case interface_updateRegion:
            urlString=@"information/updateLocation";
            break;
            case interface_addCommonAddress:
            urlString=@"address/add";
            break;
            case interface_collectMaster:
            urlString=@"favorite/add";
            break;
            case interface_updateWechatPay:
            urlString=@"masterOrder/updateOrderDeposit";
            break;
            case interface_refuse:
            urlString=@"masterOrder/rejectWork";
            break;
            case interface_accept:
            urlString=@"masterOrder/acceptWork";
            break;
            case interface_deleteCommonAdress:
            urlString=@"address/remove";
            break;
            case interface_collectMasterList:
            urlString=@"favorite/myList";
            break;
            case interface_cancelCollect:
            urlString=@"favorite/cancel";
            break;
            case interface_commentReply:
            urlString=@"masterOrder/commentReply";
            break;
            case interface_myrecommendList:
            urlString=@"servicer/myRecommendHistory";
            break;
            case interface_resignRecommend:
            urlString=@"servicer/recommendMaster";
            break;
            case interface_IDmasterProjectCase:
            urlString=@"masterProjectCase/datail";
            break;
            case interface_deleProjectCase:
            urlString=@"/masterProjectCase/delete";
            break;
            case interface_deleCommon:
            urlString=@"common/attachment/delete";
            break;
            case interface_projectUpload:
            urlString=@"masterProjectCase/save";
            break;
            case interface_onePicture:
            urlString=@"common/attachment/uploadFile";
            break;
            case interface_adminProjecrCase:
            urlString=@"masterProjectCase/update";
            break;
        case interface_IDAllProjectCase:
            urlString=@"masterProjectCase/listByUser";
            break;
            case interface_allRecomments:
            urlString=@"masterComment/list";
            break;
            case interface_attestation:
            urlString=@"certifyInfo/skillCertify";
            break;
            case interface_moneyType:
            urlString=@"servicer/payTypeList";
            break;
            case interface_updateExpectPay:
            urlString=@"servicer/updateExpectPay";
            break;
            case interface_reportInfo:
            urlString = @"feedback/addReport";
            break;
            case interface_stopWork:
            urlString=@"masterOrder/stopWork";
            break;
            case interface_refuseRecommend:
            urlString=@"servicer/rejectRecommendMaster";
            break;
            case interface_banners:
            urlString=@"advertising/list";
            break;
            case interface_delegateCollection:
            urlString=@"favorite/cancel";
            break;
            case interface_shareID:
            urlString=@"share/masterShare";
            break;
            case interface_updateAddress:
            urlString=@"address/update";
            break;
            case interface_token:
            urlString=@"common/token/generateFormToken";
            break;
        case interface_deleBill:
            urlString=@"masterOrder/removeOrder";
            break;
            case interface_updateBirthday:
            urlString=@"information/updateBirthday";
            break;
            case interface_feedBack:
            urlString=@"feedback/addFeedback";
            break;
            case interface_help:
            urlString=@"admin/help/queryAllHelpList";
            break;
            case interface_adminpassword:
            urlString=@"user/updatePassword";
            break;
            case interface_findRefershTime:
            urlString=@"location/queryOpenCityNewestTime";
            break;
            case interface_getOpenCityList:
            urlString=@"location/openCityList";
            break;
            case interface_phonerecommend:
            urlString=@"log/callLog/add";
            break;
            case interface_findWorkList:
            urlString=@"project/list";
            break;
            case interface_quer:
            urlString=@"location/queryProjectWorkArea";
            break;
            case interface_isureWork:
            urlString=@"project/nowPublish";
            break;
            case interface_findWorkDetail:
            urlString=@"project/detail";
            break;
            case interface_myPublicList:
            urlString=@"project/myList";
            break;
            case interface_delePublic:
            urlString=@"project/delete";
            break;
            case interface_projectSave:
            urlString=@"project/save";
            break;
            case interface_Notice:
            urlString=@"notice/list";
            break;
            case interface_signInformation:
            urlString=@"log/signLog/personSignInfo";
            break;
            case interface_signIn:
            urlString=@"log/signLog/sign";
            break;
            case interface_hotRang:
            urlString=@"user/hotRankList";
            break;
            case interface_shareApp:
            urlString=@"share/app/thirdParty";
            break;
            case interface_myIntegral:
            urlString=@"integral/list";
            break;
            case interface_getIntral:
            urlString=@"integral/firstShareIntegral";
            break;
            case interface_version:
            urlString=@"licence/latestVersion";
            break;
            case interface_shareToQzone:
            urlString=@"share/masterShare";
            break;
            case interface_shareWorkInfor:
            urlString=@"share/projectShare";
            break;
            case interface_myTotal:
            urlString=@"integral/total";
            break;
             default:
            break;
                }
    NSString*tempUrlString=[changeURL stringByAppendingPathComponent:@"openapi/"];
    NSString*url=[tempUrlString stringByAppendingPathComponent:urlString];
    urlString=[url stringByAppendingString:@".json"];
    return urlString;

}



@end
