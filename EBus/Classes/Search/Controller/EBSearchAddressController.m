//
//  EBSearchAddressController.m
//  EBus
//
//  Created by Kowloon on 15/11/14.
//  Copyright © 2015年 Goome. All rights reserved.
//

#import "EBSearchAddressController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "EBUserInfo.h"

@interface EBSearchAddressController () <UITextFieldDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputStringTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) AMapSearchAPI *searchAPI;

@property (nonatomic, copy) void (^option) (AMapPOI *poi);

@end

@implementation EBSearchAddressController
- (AMapSearchAPI *)searchAPI {
    if (_searchAPI == nil) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithOption:(void (^)(AMapPOI *))option {
    self = [super init];
    if (self) {
        self.option = option;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请输入位置";
    [self.inputStringTF becomeFirstResponder];
    self.inputStringTF.keyboardType = UIKeyboardTypeDefault;
    self.inputStringTF.layer.cornerRadius = self.inputStringTF.height / 2;
    self.inputStringTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputStringTF.layer.borderWidth = 0.5f;
    self.inputStringTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.inputStringTF.height)];
    self.inputStringTF.leftViewMode = UITextFieldViewModeAlways;
    self.inputStringTF.clearButtonMode = UITextFieldViewModeAlways;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldNotification) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    AMapPOI *poi = self.dataSource[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapPOI *poi = self.dataSource[indexPath.row];
    if (self.option) {
        self.option(poi);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    EBLog(@"%@",string);
    return YES;
}

- (void)textFieldNotification {
    EBLog(@"textFieldNotification->%@",self.inputStringTF.text);
    NSString *string = self.inputStringTF.text;
    if (string.length == 0) return;
    AMapPOIKeywordsSearchRequest *keyRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
    keyRequest.keywords = string;
    keyRequest.city = @"深圳";
    [self.searchAPI AMapPOIKeywordsSearch:keyRequest];
}


#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    self.dataSource = response.pois;
    [self.tableView reloadData];
}


@end
