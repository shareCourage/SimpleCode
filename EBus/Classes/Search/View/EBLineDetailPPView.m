//
//  EBLineDetailPPView.m
//  EBus
//
//  Created by Kowloon on 15/10/21.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBLineDetailPPView.h"
#import "EBLineStation.h"

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

- (void)setLineDetail:(EBLineStation *)lineDetail {
    _lineDetail = lineDetail;
    NSArray *arrayOn = [lineDetail.station componentsSeparatedByString:@"（"];
    self.stationL.text = [arrayOn firstObject];
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@",lineDetail.time];
    [mString insertString:@":" atIndex:2];
    if (lineDetail.isOn) {
        self.timeL.text = [[mString copy] stringByAppendingString:@"出发"];
    } else {
        self.timeL.text = [[mString copy] stringByAppendingString:@"抵达"];
    }
}


- (IBAction)checkPhoto:(id)sender {
    EBLog(@"checkPhoto");
    if ([self.delegate respondsToSelector:@selector(lineDetailPPViewCheckPhoto:lineDetail:)]) {
        [self.delegate lineDetailPPViewCheckPhoto:self lineDetail:self.lineDetail];
    }
}


@end
