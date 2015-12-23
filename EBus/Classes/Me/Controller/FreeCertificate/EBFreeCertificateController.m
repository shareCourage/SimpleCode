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
#import <Masonry/Masonry.h>

#import "EBUploadZJView.h"
#import "EBUploadSFZView.h"
#import "EBValidatingView.h"
#import "EBValidatResultView.h"
#import "EBZJTypePickerView.h"
@interface EBFreeCertificateController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, EBUploadZJViewDelegate, EBUploadSFZViewDelegate, EBValidatResultViewDelegate, EBZJTypePickerViewDelegate>
{
    BOOL pikerViewUpOrDown;//用来控制pickerView的up down
}
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
@property (weak, nonatomic) EBZJTypePickerView *pickerView;

@property (strong, nonatomic) UIImage *zjImage;
@property (strong, nonatomic) UIImage *sfzImage;
@property (assign, nonatomic) NSUInteger zjType;
@property (weak, nonatomic) UIView *presentImageControllerView;
@end

@implementation EBFreeCertificateController
#pragma mark - 懒加载
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

#pragma mark - Super Method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"免费证件审核";
    self.zjType = 1;
    [self topViewImplementation];
    [self bottomScrollViewImplementation];
    [self bottomScrollViewContentImplementation];
    [self pickerViewImplementation];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(freeTapClick)]];
    [self settingTopAndBottomView:0];
    [self checkCertificateStatus];
}

#pragma mark Target Method
- (void)freeTapClick {
    if (pikerViewUpOrDown) {
        [self pikerViewDown];
        pikerViewUpOrDown = NO;
    }
    [self.view endEditing:YES];
}
- (void)tapClick {
    [self.view endEditing:YES];
}

#pragma mark - Private Method
- (void)presentImagePickerController:(UIView *)view {
    self.presentImageControllerView = view;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePicker.delegate =self;
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
#if TARGET_IPHONE_SIMULATOR
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#elif TARGET_OS_IPHONE
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)setViewImage:(UIImage *)image {
    if ([self.presentImageControllerView isKindOfClass:[EBUploadZJView class]]) {
        [self.zjView setZJImage:image];
        self.zjImage = image;
    } else if ([self.presentImageControllerView isKindOfClass:[EBUploadSFZView class]]) {
        [self.sfzView setSFZImage:image];
        self.sfzImage = image;
    }
}

- (void)pikerViewDown {
    [UIView animateWithDuration:0.4f animations:^{
        self.pickerView.y = EB_HeightOfScreen;
    }];
}
- (void)pickerViewUp {
    [UIView animateWithDuration:0.4f animations:^{
        self.pickerView.y = EB_HeightOfScreen - self.pickerView.height;
    }];
}


- (void)settingTopAndBottomView:(NSUInteger)index {
    [self settingTopAndBottomView:index animation:YES];
}

- (void)settingTopAndBottomView:(NSUInteger)index animation:(BOOL)animation{
    [self setFirAndSecBackColor:index];
    [self setScrollViewContentOffset:index animation:animation];
}

- (void)setFirAndSecBackColor:(NSUInteger)index {
    if (index >= self.firLabels.count) return;
    for (UILabel *label in self.firLabels) {
        label.backgroundColor = EB_RGBColor(212, 212, 212);
    }
    for (UILabel *label in self.secLabels) {
        label.textColor = EB_RGBColor(212, 212, 212);
    }
    UILabel *fir = self.firLabels[index];
    UILabel *sec = self.secLabels[index];
    fir.backgroundColor = EB_RGBColor(104, 142, 237);
    sec.textColor = EB_RGBColor(104, 142, 237);
}
- (void)setScrollViewContentOffset:(NSUInteger)index animation:(BOOL)animation{
    [self.bottomScrollView setContentOffset:CGPointMake(EB_WidthOfScreen * index, 0) animated:animation];
}

#pragma mark - Delegate
#pragma mark - EBValidatResultViewDelegate
- (void)validatResultViewDidClickBack:(EBValidatResultView *)resultView {
    [self settingTopAndBottomView:0];
}

#pragma mark - EBUploadSFZViewDelegate
- (void)uploadSFZViewDidClick:(EBUploadSFZView *)sfzView type:(EBUploadSFZViewClickType)type {
    switch (type) {
        case EBUploadSFZViewClickTypeOfSFZPhoto:
            [self presentImagePickerController:sfzView];
            break;
        case EBUploadSFZViewClickTypeOfForward:
            [self settingTopAndBottomView:0];
            break;
        case EBUploadSFZViewClickTypeOfDelete:
            self.sfzImage = nil;
            break;
        case EBUploadSFZViewClickTypeOfCommit:
            [self uploadUserInformation];
            break;
        default:
            break;
    }
}

#pragma mark - EBUploadZJViewDelegate
- (void)uploadZJViewDidClick:(EBUploadZJView *)zjView type:(EBUploadZJViewClickType)type {
    switch (type) {
        case EBUploadZJViewClickTypeOfZJType:
            EBLog(@"EBUploadZJViewClickTypeOfZJType");
        {
            pikerViewUpOrDown = !pikerViewUpOrDown;
            pikerViewUpOrDown ? [self pickerViewUp] : [self pikerViewDown];
        }
            break;
        case EBUploadZJViewClickTypeOfZJPhoto:
            EBLog(@"EBUploadZJViewClickTypeOfZJPhoto");
            [self presentImagePickerController:zjView];
            break;
        case EBUploadZJViewClickTypeOfNext:
            EBLog(@"EBUploadZJViewClickTypeOfNext");
            [self settingTopAndBottomView:1];
            break;
        case EBUploadZJViewClickTypeOfDeletePhoto:
            EBLog(@"EBUploadZJViewClickTypeOfDeletePhoto");
            self.zjImage = nil;
            break;
        case EBUploadZJViewClicTypeOfkNone:
            break;
        default:
            break;
    }
}
#pragma mark - EBZJTypePickerViewDelegate
- (void)zj_typePickerView:(EBZJTypePickerView *)pickerView didSelected:(EBZJTypePickerViewClickType)type row:(NSUInteger)row string:(NSString *)string {
    self.zjType = row + 1;//把选择到的证件类型，赋值全局变量
    if (type == EBZJTypePickerViewClickTypeOfCancel) {
        [self pikerViewDown];
        pikerViewUpOrDown = NO;
    } else if (type == EBZJTypePickerViewClickTypeOfSure) {
        [self.zjView setZJTypeTitle:string];
        [self pikerViewDown];
        pikerViewUpOrDown = NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self setViewImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request 
- (void)checkCertificateStatus {
    [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    PHCalenderDay *currentDay = [EBUserInfo sharedEBUserInfo].currentCalendarDay;
    NSString *today = [NSString stringWithFormat:@"%ld%02ld%02ld",(unsigned long)currentDay.year, (unsigned long)currentDay.month, (unsigned long)currentDay.day];
    NSDictionary *parameters = @{static_Argument_id : [EBUserInfo sharedEBUserInfo].loginId,
                                 static_Argument_loginName : [EBUserInfo sharedEBUserInfo].loginName,
                                 static_Argument_loginCode : [today MD5]};
    [EBNetworkRequest GET:static_Url_CustomerCertificate parameters:parameters dictBlock:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *returnData = dict[static_Argument_returnData];
        NSNumber *status = returnData[static_Argument_certificateStatus];
        NSInteger statusIn = [status integerValue];
#if DEBUG
//        statusIn = 0;
#endif
        if (statusIn == 0) {//未认证
            [self settingTopAndBottomView:statusIn animation:NO];
        } else if (statusIn == 1) {//认证中
            [self settingTopAndBottomView:2 animation:NO];
        } else if (statusIn == 2 || statusIn == 3) {//2认证不通过， 3认证成功
            [self settingTopAndBottomView:3 animation:NO];
            if (statusIn == 2) {
                self.resultView.authenticationPass = NO;
            } else if (statusIn == 3) {
                self.resultView.authenticationPass = YES;
            }
        }
        NSNumber *certType = returnData[static_Argument_certificateType];
        NSInteger certTypeIn = [certType integerValue];
        if (!certType || certTypeIn == 0) return;
        [self.zjView setZJTypeTitle:[EBTool stringFromZJType:certTypeIn]];
    } errorBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (void)uploadUserInformation {
    if ([self canCommit]) {
        [MBProgressHUD showMessage:@"上传中..." toView:self.view];
        NSData *zjData = UIImageJPEGRepresentation(self.zjImage, 1.f);
        NSData *sfzData = UIImageJPEGRepresentation(self.sfzImage, 1.f);
        NSString *nameTFStr = self.sfzView.nameTF.text;
//        NSString *nameUTF8 = [nameTFStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *parameters = @{static_Argument_customerId   : [EBUserInfo sharedEBUserInfo].loginId,
                                     static_Argument_customerName : [EBUserInfo sharedEBUserInfo].loginName,
                                     static_Argument_perName      : nameTFStr,
                                     static_Argument_identityNo   : self.sfzView.sfzTF.text,
                                     static_Argument_certType     : @(self.zjType)};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:static_Url_UploadCertificate parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSString *mime = @"image/jpeg";
            [formData appendPartWithFileData:zjData name:@"certificateFile" fileName:@"file1.jpg" mimeType:mime];
            [formData appendPartWithFileData:sfzData name:@"identityFile" fileName:@"file2.jpg" mimeType:mime];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            EBLog(@"%@",dict);
            NSNumber *code = dict[static_Argument_returnCode];//
            if ([code integerValue] == 500) {
                [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
                NSNumber *data = dict[static_Argument_returnData];
                if ([data integerValue] == 1) {//status：认证状态, 0未认证、1认证中、2认证不通过、3认证完成
                    [self settingTopAndBottomView:2];
                }
            } else {
                [MBProgressHUD showError:@"上传失败" toView:self.view];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:@"上传失败" toView:self.view];
            EBLog(@"%@",error);
        }];
        
    }
}
- (BOOL)canCommit {
    if (!self.zjImage) {
        [MBProgressHUD showError:@"请拍一张免费证件的正面照"];
        return NO;
    }
    if (self.sfzView.nameTF.text.length == 0) {
        [MBProgressHUD showError:@"姓名不可为空"];
        return NO;
    }
    if (self.sfzView.sfzTF.text.length == 0) {
        [MBProgressHUD showError:@"身份证不可为空"];
        return NO;
    }
    if (self.sfzView.sfzTF.text.length != 18) {
        [MBProgressHUD showError:@"身份证号长度不正确！"];
        return NO;
    }
    if (!self.sfzImage) {
        [MBProgressHUD showError:@"请拍一张身份证的正面照"];
        return NO;
    }
    return YES;
}
#pragma mark - Implementation
#pragma mark - PickerView
- (void)pickerViewImplementation {
    EBZJTypePickerView *picker = [[EBZJTypePickerView alloc] initWithFrame:CGRectMake(0, EB_HeightOfScreen, EB_WidthOfScreen, 200)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    [self.view addSubview:picker];
    self.pickerView = picker;
}

#pragma mark - bottomScrollViewImplementation 
- (void)bottomScrollViewImplementation {
    CGFloat topViewH = 70;
    CGFloat scX = 0;
    CGFloat scY = 0;
    CGFloat scW = EB_WidthOfScreen;
    CGFloat scH = EB_HeightOfScreen - EB_HeightOfNavigationBar - topViewH - 20;
    CGRect scF = CGRectMake(scX, scY, scW, scH);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scF];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = NO;
    [self.bottomView addSubview:scrollView];
    self.bottomScrollView = scrollView;
    CGSize size = CGSizeMake(scW * 4, scH);
    self.bottomScrollView.contentSize = size;
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
    sfzView.delegate = self;
    [sfzView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    sfzView.frame = CGRectMake(EB_WidthOfScreen, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:sfzView];
    self.sfzView = sfzView;
}

- (void)three {
    EBValidatingView *validatingView = [EBValidatingView EBValidatingViewFromXib];
    validatingView.frame = CGRectMake(EB_WidthOfScreen * 2, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:validatingView];
    self.validatingView = validatingView;
}
- (void)four {
    EBValidatResultView *resultView = [EBValidatResultView EBValidatResultViewFromXib];
    resultView.delegate = self;
    resultView.frame = CGRectMake(EB_WidthOfScreen * 3, 0, EB_WidthOfScreen, self.bottomScrollView.height);
    [self.bottomScrollView addSubview:resultView];
    self.resultView = resultView;
}

#pragma mark - topView Implementation
- (void)topViewImplementation {
    self.lineView.backgroundColor = EB_RGBColor(213, 213, 213);
    self.secView.backgroundColor = [UIColor whiteColor];
    [self firLabel];
    [self secLabel];
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
        label.text = [NSString stringWithFormat:@"%ld",(long)(i + 1)];
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

@end












