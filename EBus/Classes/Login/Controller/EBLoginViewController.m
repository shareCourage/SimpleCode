//
//  EBLoginViewController.m
//  EBus
//
//  Created by Kowloon on 15/10/26.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLoginViewController.h"
#import "EBUserInfo.h"
#import "EBMoreDetailController.h"
@interface EBLoginViewController ()
{
    NSUInteger timer;
}
@property (weak, nonatomic) IBOutlet UITextField *telephoneTF;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIButton *getVerificationBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)getVerificationClick:(id)sender;
- (IBAction)loginClick:(id)sender;
@property (nonatomic, strong) NSTimer *myTimer;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
- (IBAction)seletedBtnClick:(UIButton *)sender;
- (IBAction)serviceProtocolClick:(id)sender;
@end

@implementation EBLoginViewController
- (NSTimer *)myTimer
{
    if (_myTimer == nil) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(myTimerBegin) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    return _myTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timer = 60;
    self.navigationItem.title = @"登录";
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
    [self.selectedBtn setBackgroundImage:[UIImage imageNamed:@"login_selectHL"] forState:UIControlStateSelected];
    self.selectedBtn.selected = YES;

    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    self.navigationItem.leftBarButtonItem = left;
    
    CGFloat imageW = 15;
    CGFloat imageH = 20;
    self.telephoneTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftTele = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    leftTele.contentMode = UIViewContentModeScaleAspectFit;
    leftTele.image = [UIImage imageNamed:@"login_telephone"];
    self.telephoneTF.leftView = leftTele;
    
    self.verificationTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftVeri = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    leftVeri.contentMode = UIViewContentModeScaleAspectFit;
    leftVeri.image = [UIImage imageNamed:@"login_verificationCode"];
    self.verificationTF.leftView = leftVeri;
    
    self.telephoneTF.clearButtonMode = UITextFieldViewModeAlways;
    self.telephoneTF.layer.cornerRadius = self.telephoneTF.frame.size.height / 2;
    self.telephoneTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.telephoneTF.layer.borderWidth = 1;
    self.telephoneTF.keyboardType = UIKeyboardTypeNumberPad;
    self.telephoneTF.returnKeyType = UIReturnKeyDone;
    
    self.verificationTF.clearButtonMode = UITextFieldViewModeAlways;
    self.verificationTF.layer.cornerRadius = self.telephoneTF.frame.size.height / 2;
    self.verificationTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.verificationTF.layer.borderWidth = 1;
    self.verificationTF.keyboardType = UIKeyboardTypeNumberPad;
    self.verificationTF.returnKeyType = UIReturnKeyDone;

    self.getVerificationBtn.backgroundColor = EB_RGBColor(156, 195, 234);
    self.getVerificationBtn.layer.cornerRadius = self.getVerificationBtn.frame.size.height / 2;
    [self.getVerificationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.getVerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    if (EB_WidthOfScreen <= 320) {
        self.getVerificationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    } else {
        self.getVerificationBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    self.loginBtn.backgroundColor = EB_RGBColor(156, 195, 234);
    self.loginBtn.layer.cornerRadius = self.loginBtn.frame.size.height / 2;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tipClick)]];
}

- (void)tipClick {
    [self.view endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.telephoneTF becomeFirstResponder];
}
- (void)leftItemClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)myTimerBegin {
    timer --;
    NSString *title = [NSString stringWithFormat:@"%@秒后再次获取",@(timer)];
    [self.getVerificationBtn setTitle:title forState:UIControlStateNormal];
    if (timer == 0) {
        timer = 60;
        self.getVerificationBtn.enabled = YES;
        self.getVerificationBtn.backgroundColor = EB_RGBColor(156, 195, 234);
        [self.getVerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}
- (IBAction)getVerificationClick:(id)sender {
    if (![EBTool isPureTelephoneNumber:self.telephoneTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号码格式" toView:self.view];
    } else {
        UIButton *btn = sender;
        btn.enabled = NO;
        btn.backgroundColor = [UIColor lightGrayColor];
        [self.myTimer fire];
        NSDictionary *parameters = @{static_Argument_phone : self.telephoneTF.text};
        [EBNetworkRequest GET:static_Url_GetCode parameters:parameters dictBlock:nil errorBlock:nil];
        [self.verificationTF becomeFirstResponder];
    }
}

- (IBAction)loginClick:(id)sender {
    if (!self.selectedBtn.selected) {
        [MBProgressHUD showError:@"请阅读服务协议" toView:self.view];
    }
    NSString *code = self.verificationTF.text;
    if (code.length == 0) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
    }
    NSString *tele = self.telephoneTF.text;
    if (code.length != 0 && [EBTool isPureTelephoneNumber:tele]) {
        NSDictionary *paramenters = @{static_Argument_loginCode : code,
                                      static_Argument_loginName : tele};
        [MBProgressHUD showMessage:@"登录中..." toView:self.view];
        [EBNetworkRequest POST:static_Url_Login parameters:paramenters dictBlock:^(NSDictionary *dict) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString *code = dict[static_Argument_returnCode];
            NSInteger codeIn = [code integerValue];
            if (codeIn == 500) {
                NSString *type = [NSString stringWithFormat:@"%@",dict[static_Argument_returnData]];
                if (type.length != 0) {
                    [EBUserInfo sharedEBUserInfo].loginName = tele;
                    [EBUserInfo sharedEBUserInfo].loginId = type;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self leftItemClick];
                        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                        [notificationCenter postNotificationName:EBLoginSuccessNotification object:self];
                    });
                }
            } else {
                [MBProgressHUD showError:@"登录失败" toView:self.view];
            }
            
        } errorBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
        }];
    }
}


- (IBAction)seletedBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)serviceProtocolClick:(id)sender {
    EBMoreDetailController *detail = [[EBMoreDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}
@end



