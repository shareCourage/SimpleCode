//
//  EBFreeCertificateController.m
//  EBus
//
//  Created by Kowloon on 15/11/11.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBFreeCertificateController.h"
#import "PHCalenderDay.h"
#import "EBUserInfo.h"

#import "EBUploadZJView.h"
#import "EBUploadSFZView.h"
#import "EBValidatingView.h"
#import "EBValidatResultView.h"

@interface EBFreeCertificateController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, EBUploadZJViewDelegate >
@property (weak, nonatomic) IBOutlet UIView *firView;
@property (weak, nonatomic) IBOutlet UIView *secView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) NSMutableArray *firLabels;
@property (nonatomic, strong) NSMutableArray *secLabels;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) UIScrollView *bottomScrollView;

@property (weak, nonatomic) EBUploadZJView *zjView;
@property (weak, nonatomic) EBUploadSFZView *sfzView;
@property (weak, nonatomic) EBValidatingView *validatingView;
@property (weak, nonatomic) EBValidatResultView *resultView;
@end

@implementation EBFreeCertificateController
- (NSMutableArray *)firLabels {
    if (!_firLabels) {
        _firLabels = [NSMutableArray array];
    }
    return _firLabels;
}

- (NSMutableArray *)secLabels {
    if (!_secLabels) {
        _secLabels = [NSMutableArray array];
    }
    return _secLabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"免费证件审核";
    self.lineView.backgroundColor = EB_RGBColor(213, 213, 213);
    self.secView.backgroundColor = [UIColor whiteColor];
    [self firLabel];
    [self secLabel];
    [self bottomScrollViewImplementation];
    [self checkCertificateStatus];
}
- (void)bottomScrollViewImplementation {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bottomView.bounds];
    [self.bottomView addSubview:scrollView];
    self.bottomScrollView = scrollView;
//    CGFloat height = self.bottomScrollView.height;
    CGFloat height = 300;
    self.bottomScrollView.contentSize = CGSizeMake(EB_WidthOfScreen * 4, height);
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.pagingEnabled = YES;
    //    self.bottomScrollView.scrollEnabled = NO;
    self.bottomScrollView.backgroundColor = [UIColor lightGrayColor];
    [self bottomScrollViewContentImplementation];
}
- (void)firLabel {
    CGFloat lW = 40;
    CGFloat lH = 40;
    CGFloat padding = 50;
    CGFloat lineW = EB_WidthOfScreen - padding * 2;
    CGFloat distance = lineW / 3;
    for (NSInteger i = 0; i < 4; i ++) {
        CGFloat lx = padding + distance * i;
        CGFloat ly = lH / 2;
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(lx, ly);
        label.bounds = CGRectMake(0, 0, lW, lH);
        label.layer.cornerRadius = lH / 2;
        label.layer.masksToBounds = YES;
        label.backgroundColor = EB_RGBColor(213, 213, 213);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld",i + 1];
        [self.firView addSubview:label];
        [self.firLabels addObject:label];
    }
}

- (void)secLabel {
    CGFloat lW = EB_WidthOfScreen / 4;
    CGFloat lH = 30;
    CGFloat padding = 50;
    CGFloat lineW = EB_WidthOfScreen - padding * 2;
    CGFloat distance = lineW / 3;
    NSArray *titles = @[@"上传证件",@"上传身份证",@"审核中",@"审核结果"];
    for (NSInteger i = 0; i < 4; i ++) {
        CGFloat lx = padding + distance * i;
        CGFloat ly = lH / 2;
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(lx, ly);
        label.bounds = CGRectMake(0, 0, lW, lH);
        [label setSystemFontOf14];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = EB_RGBColor(213, 213, 213);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = titles[i];
        [self.secView addSubview:label];
        [self.secLabels addObject:label];
    }
}

- (void)settingTopAndBottomView:(NSUInteger)index {
    [self setFirAndSecBackColor:index];
    [self setScrollViewContentOffset:index];
}

- (void)setFirAndSecBackColor:(NSUInteger)index {
    if (index >= self.firLabels.count) return;
    UILabel *fir = self.firLabels[index];
    UILabel *sec = self.secLabels[index];
    fir.backgroundColor = EB_RGBColor(104, 142, 237);
    sec.textColor = EB_RGBColor(104, 142, 237);
}
- (void)setScrollViewContentOffset:(NSUInteger)index {
    self.bottomScrollView.contentOffset = CGPointMake(EB_WidthOfScreen * index, 0);
}
- (void)bottomScrollViewContentImplementation {
    [self one];
    [self two];
    [self three];
    [self four];
}

- (void)one {
    EBUploadZJView *zjView = [EBUploadZJView EBUploadZJViewFromXib];
    zjView.delegate = self;
    zjView.frame = CGRectMake(0, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:zjView];
    self.zjView = zjView;
}
- (void)two {
    EBUploadSFZView *sfzView = [EBUploadSFZView EBUploadSFZViewFromXib];
    [sfzView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    sfzView.frame = CGRectMake(EB_WidthOfScreen, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:sfzView];
    self.sfzView = sfzView;
}
- (void)tapClick {
    [self.view endEditing:YES];
}
- (void)three {
    EBValidatingView *validatingView = [EBValidatingView EBValidatingViewFromXib];
    validatingView.frame = CGRectMake(EB_WidthOfScreen * 2, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:validatingView];
    self.validatingView = validatingView;
}
- (void)four {
    EBValidatResultView *resultView = [EBValidatResultView EBValidatResultViewFromXib];
    resultView.frame = CGRectMake(EB_WidthOfScreen * 3, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:resultView];
    self.resultView = resultView;
}
#pragma mark - EBUploadZJViewDelegate
- (void)uploadZJViewDidClickZJTypeBtn:(EBUploadZJView *)zjView {
}
- (void)uploadZJViewDidClickZJPhotoBtn:(EBUploadZJView *)zjView {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePicker.delegate =self;
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)uploadZJViewDidClickNextBtn:(EBUploadZJView *)zjView {
    self.bottomScrollView.contentOffset = CGPointMake(EB_WidthOfScreen, 0);
}
- (void)uploadZJViewDidClickDeletePhotoBtn:(EBUploadZJView *)zjView {
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData *data = UIImagePNGRepresentation(image);
    [self.zjView setZJImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request 
- (void)checkCertificateStatus {
    PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
    NSString *today = [NSString stringWithFormat:@"%ld%02ld%02ld",(unsigned long)currentDay.year, (unsigned long)currentDay.month, (unsigned long)currentDay.day];
    NSDictionary *parameters = @{static_Argument_id : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_loginName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_loginCode : [today MD5]};
    [EBNetworkRequest GET:static_Url_CustomerCertificate parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSDictionary *returnData = dict[static_Argument_returnData];
        NSNumber *status = returnData[static_Argument_status];
        NSNumber *certType = returnData[@"certType"];
        NSInteger statusIn = [status integerValue];
        NSInteger certTypeIn = [certType integerValue];
        [self settingTopAndBottomView:statusIn];
        if (statusIn == 0) {

        } else if (statusIn == 1) {
        
        } else if (statusIn == 2) {
            
        }else if (statusIn == 3) {
            
        }
    } errorBlock:^(NSError *error) {
    }];
    
}

@end












