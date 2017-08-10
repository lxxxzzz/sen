//
//  OrderSignViewController.m
//  森
//
//  Created by Lee on 2017/5/26.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "OrderSignViewController.h"
#import "MultiCell.h"
#import "BaseItem.h"
#import "ItemGroup.h"
#import "PhotoSelectCell.h"
#import "PhotoManager.h"
#import "AlbumsViewController.h"
#import "Order.h"
#import "HTTPTool.h"
#import "TextFieldItem.h"
#import "NSString+Extension.h"
#import "TableView.h"
#import "GZOrderListViewController.h"

#import "Album.h"
#import "Photo.h"
#import "Util.h"

#import "UIBarButtonItem+Extension.h"

#import <Masonry.h>
#import <SVProgressHUD.h>
#import <SDWebImageManager.h>

@interface OrderSignViewController ()<UITableViewDelegate, UITableViewDataSource, PhotoSelectCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AlbumsViewControllerDelegate, MultiCellDelegate>

@property (nonatomic, strong) TableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, copy) NSString *money;

@property (nonatomic, strong) BaseItem *moneyItem;
@property (nonatomic, strong) BaseItem *dateItem;
@property (nonatomic, strong) ItemGroup *group2;
@property (nonatomic, assign) BOOL isFirstLoadView;
@property (nonatomic, strong) NSArray *imageURLs;

@end

@implementation OrderSignViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItem];
    
    [self setupSubviews];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isFirstLoadView = YES;
    
    ItemGroup *group1 = [[ItemGroup alloc] init];
    group1.header = @"合同明细";
    NSString *date = [NSString nowDateWithTimeFormat:@"yyyy-MM-dd"];
    self.money = @"0";
    self.dateItem = [BaseItem itemWithTitle:@"签单时间" value:date required:NO];

    if (!self.editable) {
        // 不可以编辑
        self.moneyItem = [BaseItem itemWithTitle:@"合同金额" value:@"" required:YES];
        
    } else {
        // 可以编辑
        TextFieldItem *moneyItem = [TextFieldItem itemWithTitle:@"合同金额" value:@"" required:YES];
        moneyItem.keyboardType = UIKeyboardTypeNumberPad;
        self.moneyItem = moneyItem;
    }
    
    [self loadData];
    
    group1.items = @[self.moneyItem,
                     self.dateItem
                     ];
    self.group2 = [[ItemGroup alloc] init];
    self.group2.header = @"合同凭证";
    self.group2.items = @[@"合同凭证"];
    
    self.dataSource = @[group1, self.group2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.editable && self.isFirstLoadView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        MultiCell *cell = (MultiCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.isFirstLoadView = NO;
    
    [self.view endEditing:YES];
}

- (void)dealloc {
    Log(@"%s",__func__);
}

#pragma mark - Override
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 私有方法
- (void)setupNavigationItem {
    self.navigationItem.title = @"确认签单";
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
}

#pragma mark Action
- (void)submit {
    if( ![self.money isPureInt] || ![self.money isPureFloat]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的金额"];
        return;
    }
    if (self.photos.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择凭证照片"];
        return;
    }
    [SVProgressHUD showWithStatus:@"处理中..."];
    __weak typeof(self) weakself = self;
    
    [Util uploadImages:self.photos isAsync:YES success:^(NSArray *urls) {
        Log(@"照片上传完成%@",urls);
        [weakself sign:urls];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}

#pragma mark 网络请求
- (void)downloadImages:(NSArray *)images comletion:(void(^)(NSArray *result))completion {
    dispatch_group_t group = dispatch_group_create();
    __block NSMutableArray *arrM = [NSMutableArray array];
    for (NSString *urlStr in images) {
        dispatch_group_enter(group);
        NSURL *url = [NSURL URLWithString:urlStr];
        [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            dispatch_group_leave(group);
            Photo *photo = [[Photo alloc] init];
            photo.hdImage = image;
            [arrM addObject:photo];
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completion) {
            Log(@"全部下载完了....");
            completion(arrM);
        }
    });
}

- (void)loadData {
    __weak typeof(self) weakself = self;
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=keziOrderSignDetail", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"user_kezi_order_id"] = self.order.customerId;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",[result.data class]);
        if (result.success) {
            if ([result.data isKindOfClass:[NSDictionary class]]) {
                self.moneyItem.value = result.data[@"order_money"];
                NSTimeInterval time = [result.data[@"sign_using_time"] integerValue];
                self.dateItem.value = [NSString stringWithTimeInterval:time format:@"yyyy-MM-dd"];
//                self.photos = [[result.data[@"sign_pic"] componentsSeparatedByString:@","] copy];
                self.imageURLs = [[result.data[@"sign_pic"] componentsSeparatedByString:@","] copy];
                [weakself.tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)sign:(NSArray *)urls {
    NSString *url = [NSString stringWithFormat:@"%@?m=app&c=order&f=keziOrderSign&debug=1", HOST];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = TOKEN;
    parameters[@"user_kezi_order_id"] = self.order.customerId;
    parameters[@"order_money"] = self.money;
    parameters[@"sign_using_time"] = @((int)[NSDate date].timeIntervalSince1970);
    parameters[@"sign_pic"] = [urls componentsJoinedByString:@","];
    __weak typeof(self) weakself = self;
    [HTTPTool POST:url parameters:parameters success:^(HTTPResult *result) {
        Log(@"%@",result);
        if (result.success) {
            [SVProgressHUD showSuccessWithStatus:@"签单成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSArray *controllers = self.navigationController.viewControllers;
                GZOrderListViewController *popVc;
                for (UIViewController *vc in controllers) {
                    if ([vc isKindOfClass:[GZOrderListViewController class]]) {
                        popVc = (GZOrderListViewController *)vc;
                        break;
                    }
                }
                if (popVc) {
                    popVc.segmentControl.selectedIndex = 1;
                    [weakself.navigationController popToViewController:popVc animated:YES];
                } else {
                    [weakself.navigationController popToRootViewControllerAnimated:YES];
                }
            });
        } else {
            [SVProgressHUD showErrorWithStatus:@"签单失败"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:NETWORK_ERROR];
    }];
}

#pragma mark - delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemGroup *group = self.dataSource[indexPath.section];
    if (indexPath.section == self.dataSource.count - 1) {
        // 最后一组
        PhotoSelectCell *cell = [PhotoSelectCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.photos = self.photos;
        cell.editable = self.editable;
        self.rowHeight = [cell cellHeight];
        return cell;
    }
    MultiCell *cell = [MultiCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.item = group.items[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    return group.header;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ItemGroup *group = self.dataSource[section];
    if (group.header) return 50;
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.dataSource.count - 1) {
        // 最后一行
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return self.rowHeight;
    } else {
        return 44;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)photoSelectCellHeightDidChange:(PhotoSelectCell *)cell height:(CGFloat)height {
//    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    MultiCell *multiCell = [self.tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = multiCell.frame;
    rect.size.height = height;
    self.rowHeight = height;
    [self.tableView beginUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    multiCell.frame = rect;
    [self.tableView endUpdates];
}

- (void)photoSelectCellAdd:(PhotoSelectCell *)cell {
    [self.view endEditing:YES];
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     }];
     UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     UIImagePickerController *pickerVc = [[UIImagePickerController alloc] init];
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
         pickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
         pickerVc.delegate = self;
         [self presentViewController:pickerVc animated:NO completion:nil];
         }
     }];
     UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         __weak typeof(self) weakself = self;
         [[PhotoManager manager] requestAuthorization:^(BOOL authorization) {
             if (authorization) {
                 [[PhotoManager manager] openAlbumWithPhotos:self.photos completion:^(NSArray *photos) {
                     weakself.photos = [photos mutableCopy];
                     [weakself.tableView reloadData];
                 }];
             } else {
                 [SVProgressHUD showErrorWithStatus:@"没有相册使用权限"];
             }
         }];
     }];
     [alertController addAction:actionCancel];
     [alertController addAction:actionCamera];
     [alertController addAction:actionAlbum];
     [self presentViewController:alertController animated:YES completion:nil];

}

- (void)multiCell:(UITableViewCell *)cell valueDidChange:(id)value {
    self.money = value;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];

    // 保存照片到本地相册，不会自动保存
    UIImageWriteToSavedPhotosAlbum(original, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
    Log(@"%@", original.accessibilityIdentifier);
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"ascending:NO]];
    PHFetchResult *resut = [PHAsset fetchAssetsWithOptions:options];
    
    PHAsset *asset = [resut firstObject];
    Photo *photo = [[Photo alloc] init];
    photo.asset = asset;
    
    [self.photos addObject:photo];
    [self.tableView reloadData];
}

#pragma mark - setter and getter
#pragma mark setter
- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    self.tableView.tableFooterView.hidden = !editable;
    
    [self.tableView reloadData];
}

- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs = imageURLs;
    
    __weak typeof(self) weakself = self;
    [self downloadImages:imageURLs comletion:^(NSArray *result) {
        
        weakself.photos = [result mutableCopy];
        [weakself.tableView reloadData];
    }];
}

#pragma mark getter
- (TableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[TableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:1/1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.estimatedRowHeight = 44;
        //        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 90, 50)];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        button.backgroundColor = HEX(@"#178FE6");
        [button setTitleColor:HEX(@"#FFFFFF") forState:UIControlStateNormal];
        [button setTitle:@"提交审核" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:button];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

@end
