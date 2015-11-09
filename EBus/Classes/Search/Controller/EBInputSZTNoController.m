//
//  EBInputSZTNoController.m
//  EBus
//
//  Created by Kowloon on 15/11/9.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBInputSZTNoController.h"

@interface EBInputSZTNoController ()

@property (nonatomic, copy)void (^completion)(NSString *value);

@property (nonatomic, weak)UITextField *arguTextField;

@end

@implementation EBInputSZTNoController

- (void)dealloc {
    EBLog(@"%@ -> dealloc", NSStringFromClass([self class]));
}

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (instancetype)initWithCompletion:(void (^)(NSString *value))completion {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (self.arguTextField.text.length > 9 || self.arguTextField.text.length == 0) {
        [MBProgressHUD showError:@"请输入正确的格式"];
    } else {
        if(self.completion) self.completion(self.arguTextField.text);
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"settingArgumentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:cell.contentView.frame];
    textField.placeholder = @"请输入9位深圳通卡号";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [textField becomeFirstResponder];
    [cell.contentView addSubview:textField];
    self.arguTextField = textField;
    return cell;
}


@end
