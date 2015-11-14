//
//  EBSearchAddressController.m
//  EBus
//
//  Created by Kowloon on 15/11/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchAddressController.h"

@interface EBSearchAddressController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputStringTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EBSearchAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputStringTF becomeFirstResponder];
    self.inputStringTF.keyboardType = UIKeyboardTypeDefault;
    self.inputStringTF.layer.cornerRadius = self.inputStringTF.height / 2;
    self.inputStringTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputStringTF.layer.borderWidth = 0.5f;
    self.inputStringTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.inputStringTF.height)];
    self.inputStringTF.leftViewMode = UITextFieldViewModeAlways;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    EBLog(@"%@",string);
    return YES;
}



@end
