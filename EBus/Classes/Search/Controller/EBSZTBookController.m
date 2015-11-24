//
//  EBSZTBookController.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSZTBookController.h"
#import "EBInputSZTNoController.h"
#import "PHNavigationController.h"
#import "EBSearchResultModel.h"
#import "PHCalenderDay.h"
#import "EBUserInfo.h"

@interface EBSZTBookController ()

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
- (IBAction)modifyClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
- (IBAction)bookClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sztNoL;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myActivityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@end

@implementation EBSZTBookController
- (void)dealloc {
    EBLog(@"%@ -> dealloc", NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.myTitle.length != 0) {
        self.navigationItem.title = @"更改绑定深圳通卡";
    } else {
        self.navigationItem.title = @"深圳通卡预订";
    }
    self.modifyBtn.layer.cornerRadius = self.modifyBtn.height / 2;
    self.bookBtn.layer.cornerRadius = self.bookBtn.height / 2;
    self.sztNoL.layer.cornerRadius = self.sztNoL.height / 2;
    self.sztNoL.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7f].CGColor;
    self.sztNoL.layer.borderWidth = 1.f;
    self.modifyBtn.backgroundColor = EB_DefaultColor;
    self.bookBtn.backgroundColor = EB_DefaultColor;

    if (self.hidenBookBtn) {
        self.bookBtn.hidden = YES;
        self.bottomLayout.constant = 0;
    }
    if ([EBUserInfo sharedEBUserInfo].sztNo.length != 0) {
        [self.modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        self.sztNoL.text = [NSString stringWithFormat:@"  卡号:%@",[EBUserInfo sharedEBUserInfo].sztNo];
    } else {
        self.sztNoL.text = @"请绑定深圳通卡号";
        [self.modifyBtn setTitle:@"绑定" forState:UIControlStateNormal];
    }
    [self webViewLoading];
}
- (void)webViewLoading {
    self.myActivityIndicator.hidden = NO;
    [self.myActivityIndicator startAnimating];
    [EBNetworkRequest GET:static_Url_SZTNotice parameters:nil dictBlock:^(NSDictionary *dict) {
        NSString *string = dict[static_Argument_returnData];
        [self.myWebView loadHTMLString:string baseURL:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.myActivityIndicator.hidden = YES;
            [self.myActivityIndicator stopAnimating];
        });
    } errorBlock:^(NSError *error) {
        self.myActivityIndicator.hidden = YES;
        [self.myActivityIndicator stopAnimating];
    }];
}
- (IBAction)modifyClick:(id)sender {
    if (EB_iOS(8.0)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入深圳通卡号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"请输入9位深圳通卡号";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alertController addAction:[self actionWithTitle:@"取消" actionStyle:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[self actionWithTitle:@"确定" actionStyle:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *textF =  [alertController.textFields firstObject];
            if (textF.text.length < 9) {
                [MBProgressHUD showError:@"卡号不为9位数,请重新输入" toView:self.view];
            } else if (textF.text.length > 9) {
                [MBProgressHUD showError:@"文本框限制了输入数字长度,最多只可输入9位数字" toView:self.view];
            } else {
                [self bindSZT:textF.text];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        EB_WS(ws);
        EBInputSZTNoController *settingArgu = [[EBInputSZTNoController alloc] initWithCompletion:^(NSString *value) {
            if (value.length < 9) {
                [MBProgressHUD showError:@"卡号不为9位数，请重新输入" toView:self.view];
            } else if (value.length > 9) {
                [MBProgressHUD showError:@"文本框限制了输入数字长度，最多只可输入9位数字" toView:self.view];
            } else {
                [ws bindSZT:value];
            }
        }];
        PHNavigationController *navi = [[PHNavigationController alloc] initWithRootViewController:settingArgu];
        [self.navigationController presentViewController:navi animated:YES completion:nil];
    }
}

- (UIAlertAction *)actionWithTitle:(NSString *)title actionStyle:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction *action))handler
{
    if (style == UIAlertActionStyleCancel) {
        return [UIAlertAction actionWithTitle:title style:style handler:handler];
    }
    return [UIAlertAction actionWithTitle:title style:style handler:handler];
}

- (IBAction)bookClick:(id)sender {
    
    NSArray *sortArray = [self.dates sortedArrayUsingSelector:@selector(compare:)];//升序排序
    NSMutableArray *newDates = [NSMutableArray array];
    PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
    for (NSString *obj in sortArray) {
        NSString *string = [NSString stringWithFormat:@"%ld-%02ld-%02ld",(unsigned long)currentDay.year, (unsigned long)currentDay.month, (long)[obj integerValue]];
        [newDates addObject:string];
    }
    NSString *newString = [EBTool stringConnected:newDates connectString:@","];
    EBLog(@"%@",newString);
    if (newString.length != 0 && self.resultModel.lineId && self.resultModel.vehTime && self.resultModel.startTime && self.resultModel.onStationId && self.resultModel.offStationId && [EBUserInfo sharedEBUserInfo].loginId.length != 0 && [EBUserInfo sharedEBUserInfo].loginName.length != 0) {
        NSDictionary *parameters = @{static_Argument_saleDates      : newString,
                                     static_Argument_lineId         : self.resultModel.lineId,
                                     static_Argument_vehTime        : self.resultModel.vehTime,
                                     static_Argument_startTime      : self.resultModel.startTime,
                                     static_Argument_onStationId    : self.resultModel.onStationId,
                                     static_Argument_offStationId   : self.resultModel.offStationId,
                                     static_Argument_tradePrice     : @(self.totalPrice),
                                     static_Argument_payType        : @(3),//szt支付
                                     static_Argument_userId         : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_userName       : [EBUserInfo sharedEBUserInfo].loginName};
        [EBNetworkRequest GET:static_Url_Order parameters:parameters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString *string = dict[static_Argument_returnInfo];
            NSString *returCode = dict[static_Argument_returnCode];
            if ([returCode integerValue] != 500) {
                if ([string isEqualToString:@"深圳通卡号不可为空"]) {
                    [MBProgressHUD showError:@"深圳通卡号不能为空" toView:self.view];
                } else {
                    [MBProgressHUD showError:string toView:self.view];
                }
            } else if ([returCode integerValue] == 500){
                [MBProgressHUD showSuccess:@"预订成功，请按时乘坐" toView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [EBTool popToAttentionControllWithIndex:0 controller:self];
                });
                
            }
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:@"预订失败" toView:self.view];
        }];
    }
}

#pragma mark - Method
- (void)bindSZT:(NSString *)szt {
    if (szt.length == 0) return;
    NSDictionary *parameters = @{static_Argument_loginName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_sztNo : szt,
                                 static_Argument_id : [EBUserInfo sharedEBUserInfo].loginId};
    [EBNetworkRequest POST:static_Url_SetSZTNo parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSString *code = dict[static_Argument_returnCode];
        NSString *info = dict[static_Argument_returnInfo];
        if ([code integerValue] == 500) {
            [MBProgressHUD showSuccess:@"绑定成功" toView:self.view];
            [EBUserInfo sharedEBUserInfo].sztNo = szt;
            self.sztNoL.text = [NSString stringWithFormat:@"  卡号:%@",[EBUserInfo sharedEBUserInfo].sztNo];
        } else {
            [MBProgressHUD showError:info toView:self.view];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD showSuccess:@"绑定失败" toView:self.view];
    }];
}

@end


