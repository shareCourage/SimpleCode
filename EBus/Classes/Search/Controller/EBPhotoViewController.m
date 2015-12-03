//
//  EBPhotoViewController.m
//  EBus
//
//  Created by Kowloon on 15/12/3.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBPhotoViewController.h"
#import "UIImageView+WebCache.h"

@interface EBPhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backClick:(id)sender;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation EBPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"search_map_back"] forState:UIControlStateNormal];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.delegate = self;
    [self.view insertSubview:scrollView atIndex:0];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlOfImage] placeholderImage:[UIImage imageNamed:@"main_background"]];
    imageView.frame = scrollView.bounds;
    imageView.center = scrollView.center;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale = 1;
}

- (void)back {
    [self backClick:nil];
}
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
