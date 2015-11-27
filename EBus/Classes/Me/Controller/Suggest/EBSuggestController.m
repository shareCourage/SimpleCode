//
//  EBSuggestController.m
//  EBus
//
//  Created by Kowloon on 15/10/27.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSuggestController.h"
#import "EBUserInfo.h"

@interface EBSuggestController ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *suggestBtns;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitBottomLayout;
@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
- (IBAction)commitClick:(id)sender;
@property (nonatomic, strong) NSArray *btnTitles;
@property (nonatomic, strong) NSMutableArray *types;

@property (nonatomic, weak) UIButton *selectedBtn;
@end

@implementation EBSuggestController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSMutableArray *)types {
    if (!_types) {
        _types = [NSMutableArray array];
    }
    return _types;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (EB_HeightOfScreen <= 480) {
        self.commitBottomLayout.constant = 10;
    }
    self.navigationItem.title = @"建议";
    self.btnTitles = @[@"线路优化",@"功能操作",@"司乘服务",@"车辆配置",@"费用/订单",@"其他"];
    self.commitBtn.layer.cornerRadius = self.commitBtn.frame.size.height / 2;
    [self.commitBtn setBackgroundColor:EB_DefaultColor];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    int i = 1000;
    for (UIButton *btn in self.suggestBtns) {
        btn.tag = i;
        btn.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f].CGColor;
        btn.layer.borderWidth = 0.5f;
        [btn setTitle:self.btnTitles[i - 1000] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1000) {
            self.selectedBtn = btn;
            btn.selected = YES;
            [self.selectedBtn setBackgroundColor:EB_DefaultColor];
        }
        i ++;
    }
    self.suggestTextView.layer.cornerRadius = 5;
    self.suggestTextView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6f].CGColor;
    self.suggestTextView.layer.borderWidth = 1.f;
    self.suggestTextView.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyBoardWillShow:(NSNotification *)sender
{
    CGFloat heightFromBottom = EB_HeightOfScreen - CGRectGetMaxY(self.inputBackView.frame);
    NSDictionary *userInfo = sender.userInfo;
    NSValue *frameValue = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGSize keyboardSize = [frameValue CGRectValue].size;
    CGFloat value = keyboardSize.height - heightFromBottom;
    CGFloat height = 0;
    if (value > 0) height = value;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = CGRectMake(0, height, self.view.width, self.view.height);
    }];
}
- (void)keyBoardWillHide:(NSNotification *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.view.bounds = CGRectMake(0, 0, self.view.width, self.view.height);
    }];
}

- (void)btnClick:(UIButton *)sender {
    if (sender != self.selectedBtn) {
        sender.selected = !sender.isSelected;
        if (sender.isSelected) {
            [sender setBackgroundColor:EB_DefaultColor];
        } else {
            [sender setBackgroundColor:[UIColor whiteColor]];
        }
        self.selectedBtn.selected = NO;
        [self.selectedBtn setBackgroundColor:[UIColor whiteColor]];
        self.selectedBtn = sender;
    }
}
- (void)tapClick {
    [self.view endEditing:YES];
}
- (IBAction)commitClick:(id)sender {
    [self.types removeAllObjects];
    NSString *textString = nil;
    if (self.suggestTextView.text.length == 0) {
        [MBProgressHUD showError:@"请输入您的宝贵意见" toView:self.view];
        return;
    } else if (self.suggestTextView.text.length > 100) {
        [MBProgressHUD showError:@"超过100个字符！" toView:self.view];
        return;
    } else {
        textString = self.suggestTextView.text;
    }
//    textString = @" 请 输入您的宝贵意见见请输入您的宝贵意见见请输入您的宝贵意见见请输入您的宝贵意见见请输入您的宝贵意见见请输入您的宝贵意见见请输入您的宝贵意";
    NSString *stringWithOutSpace = [textString stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSUInteger length = stringWithOutSpace.length;
    NSString *unicodeStr = [stringWithOutSpace stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    for (UIButton *btn in self.suggestBtns) {
        if (btn.isSelected) {
            switch (btn.tag) {
                case 1000:
                    [self.types addObject:@"1"];
                    break;
                case 1001:
                    [self.types addObject:@"2"];
                    break;
                case 1002:
                    [self.types addObject:@"3"];
                    break;
                case 1003:
                    [self.types addObject:@"4"];
                    break;
                case 1004:
                    [self.types addObject:@"5"];
                    break;
                case 1005:
                    [self.types addObject:@"9"];
                    break;
                default:
                    break;
            }
        }
    }
    if (self.types.count == 0) {
        [MBProgressHUD showError:@"请选择一个投诉" toView:self.view];
        return;
    }
    NSString *string = [self.types firstObject];
    for (NSString *obj in self.types) {
        if (![string isEqualToString:obj]) {
            string = [string stringByAppendingString:@","];
        }
    }
    
    NSDictionary *parameters = @{static_Argument_customerId : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_customerName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_content : unicodeStr,
                                 static_Argument_type : string};
    [EBNetworkRequest POST:static_Url_Suggest parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSString *string = [NSString stringWithFormat:@"%@",dict[@"returnCode"]];
        if ([string integerValue] == 500) {
            [MBProgressHUD showSuccess:@"谢谢您的建议" toView:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [MBProgressHUD showError:@"提交失败" toView:self.view];
        }
    } errorBlock:^(NSError *error) {
        [MBProgressHUD showError:@"提交失败" toView:self.view];
    }];
}
@end



