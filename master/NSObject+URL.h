//
//  NSObject+URL.h
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  enum
{
    interface_login,  //登陆
    interface_cityList,//城市列表
    interface_resigionList,//地区列表
    interface_skill,//技能接口
    interface_list, //列表接口
    interface_detail,//详情
    interface_resogn,//注册
    interface_adminpassword,//修改密码
    interface_loginout,//登出
    interface_phoneCheck,//手机验证
    interface_updateSex,//更新性别
    interface_updateLocation,//更新籍贯
    interface_updateQQ,//更新QQ
    interface_updateBirthday,//更新生日
    interface_updateAddress,//更新地址
    interface_updateRealName,//更新姓名
    interface_updateIDNo,//更新省份证
    interface_uploadHeadImage,//上传头像
    interface_uploadIdentity,//上传身份证照片
    interface_updateStartWork,//更新从业时间
    interface_updateServiceDescribe,//更新服务说明
    interface_payTypeList,//薪资支付类型集合
    interface_updateExpectPay,//更新期望薪资
    interface_updateStatus,//更新工作状态
    interface_updateServicerSkill,//更新专业技能
    interface_updateServicerRegion,//更新服务区域
    interface_requestRecommend,//请求推荐
    interface_scoreTypeList,//评分维度，如服务质量等
    interface_recommendMaster,//推荐师傅
    interface_register,////注册
    interface_myServicerDetail,//我的服务详情
    interface_resetPassword,//重置密码
    interface_provinceList, //全部省列表
    interface_updateGendar, //更新性别
    interface_updateweChat, //更新微信
    interface_personalDetail,//个人详情
    interface_masterDetail, //师傅详情
    interface_commitProblem, //提交问题
    interface_IDCity,
    interface_IDTown,
    integface_myServicerDetail,
    interface_allCityList,  //根据省份请求城市
    interface_commonAdress, //显示常用地址
    interface_deleteCommonAdress, //删除常用地址
    interface_projectCase, //我的工程案例查询
    interface_projectCaseImage,  //工程案例图片显示
    interface_certainUpload,//证书上传    
    interface_findRecommend,//寻求推荐人
    interface_sendRecommend,//请求推荐
    interface_myOrder,//我的接单
    interface_myNextOrder,//我的下单
    interface_myOrderDetail,//订单详情
    interface_myNextConfirm,//我的下单待确认
    interface_myNextComment,//我的下单带评价
    interface_finish,//完工确认

    interface_myorderConfirm,//我的接单确认
    interface_myorderCommend,//我的接单待评价
    interface_scoreType,//评分维度
    interface_comment,//提交评论

    interface_commitOrder, //提交预约
    interface_updateRegion, //更新国籍
    interface_refuse,//拒绝预约
    interface_accept,//接受预约

    
    interface_addCommonAddress, //添加常用地址
    interface_collectMaster, //添加收藏
    interface_collectMasterList, //显示收藏师傅列表
    interface_updateWechatPay, // 更新微信支付
    interface_cancelCollect, //取消收藏
    interface_commentReply,//回复评论

    
    interface_myrecommendList,//我推荐的人列表
    interface_resignRecommend,//推荐
    
    interface_IDmasterProjectCase,//单个工程案例详情查询
    interface_deleProjectCase,//工程案例删除
    interface_deleCommon,//删除附件
    interface_projectUpload,//工程案例上传
    interface_onePicture,//单个工程案例上传
    interface_adminProjecrCase,//修改工程案例说明
    interface_IDAllProjectCase,//指定用户工程案例
    interface_allRecomments,//师傅的全部评价
    
    
    interface_attestation,//身份认证
    interface_moneyType,//薪资支付集合
    interface_reportInfo,  //举报信息
    interface_stopWork,//终止雇佣
    interface_refuseRecommend,//拒绝推荐
    
    interface_banners,//广告栏
    interface_delegateCollection,//删除收藏
    interface_shareID,//分享接口请求
    interface_updateNormalAdress,//常用地址修改接口
    interface_token,//请求订单令牌
    interface_deleBill,//单据删除
    interface_feedBack,
    interface_help,//帮助
    interface_getOpenCityList,//获取已开通的城市
    interface_findRefershTime,//查询开头那个城市更新时间
    interface_phonerecommend,//拨打记录上传
    
    interface_findWorkList,//查询招工信息
    interface_quer,//招工地区
    interface_isureWork,//发布招工信息
    interface_findWorkDetail,//招工信息详情
    
    interface_myPublicList,//我的招工信息
    interface_delePublic,//删除发布
    interface_projectSave,//我的发布保存
    interface_Notice,//通知公告
    interface_signInformation,//签到信息
    interface_signIn,//签到
    interface_hotRang,//热度排行榜
    interface_shareApp,//分享app
    interface_myIntegral,//我的积分
    interface_getIntral,//获取积分
    interface_version,//版本查询
    interface_shareToQzone,//分享到QQ空间
    interface_shareWorkInfor,//分享招工信息
    interface_myTotal,//我的总积分
    
}interface;
@interface NSObject (URL)
-(NSString*)interfaceFromString:(interface)string;
@end
