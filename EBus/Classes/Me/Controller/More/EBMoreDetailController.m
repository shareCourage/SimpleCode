//
//  EBMoreDetailController.m
//  EBus
//
//  Created by Kowloon on 15/11/13.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBMoreDetailController.h"
#import "EBMoreModel.h"
@interface EBMoreDetailController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *myIndicator;

@end

@implementation EBMoreDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.moreModel) {
        self.navigationItem.title = self.moreModel.title;
        [self webViewLoading];
    } else {
        self.navigationItem.title = @"用户须知";
        [self userShouldKnow];
    }
}
- (void)webViewLoading {
    self.myIndicator.hidden = NO;
    [self.myIndicator startAnimating];
    NSDictionary *parameters = @{static_Argument_id : self.moreModel.ID};
    [EBNetworkRequest GET:static_Url_MoreDetail parameters:parameters dictBlock:^(NSDictionary *dict) {
        NSString *string = dict[static_Argument_returnData];
        [self.myWebView loadHTMLString:string baseURL:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.myIndicator.hidden = YES;
            [self.myIndicator stopAnimating];
        });
    } errorBlock:^(NSError *error) {
        self.myIndicator.hidden = YES;
        [self.myIndicator stopAnimating];
    }];
}
- (void)userShouldKnow {
    self.myIndicator.hidden = NO;
    [self.myIndicator startAnimating];
    [EBNetworkRequest GET:static_Url_UserShouldKnow parameters:nil dictBlock:^(NSDictionary *dict) {
        NSString *string = dict[static_Argument_returnData];
        [self.myWebView loadHTMLString:string baseURL:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.myIndicator.hidden = YES;
            [self.myIndicator stopAnimating];
        });
    } errorBlock:^(NSError *error) {
        self.myIndicator.hidden = YES;
        [self.myIndicator stopAnimating];
    }];
}
@end
