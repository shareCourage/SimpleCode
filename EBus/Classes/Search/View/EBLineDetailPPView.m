//
//  EBLineDetailPPView.m
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineDetailPPView.h"

@interface EBLineDetailPPView ()
@property (weak, nonatomic) IBOutlet UILabel *stationL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation EBLineDetailPPView

+ (instancetype)lineDetailPPView {
    EBLineDetailPPView *lineView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    lineView.backgroundColor = [UIColor clearColor];
    return lineView;
}

- (void)setLineDetail:(EBLineDetail *)lineDetail {
    _lineDetail = lineDetail;
    self.stationL.text = lineDetail.station;
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",lineDetail.time];
    [mString insertString:@":" atIndex:2];
    self.timeL.text = [[mString copy] stringByAppendingString:@"出发"];
}


- (IBAction)checkPhoto:(id)sender {
    EBLog(@"checkPhoto");
    if ([self.delegate respondsToSelector:@selector(lineDetailPPViewDidClickRightBtn:)]) {
        [self.delegate lineDetailPPViewDidClickRightBtn:self];
    }
}


@end
