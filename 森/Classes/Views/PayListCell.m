//
//  PayListCell.m
//  森
//
//  Created by Lee on 2017/6/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "PayListCell.h"
#import "ImageCell.h"
#import "PayList.h"
#import "PhotoBrowserViewController.h"
#import "NSString+Extension.h"
#import <Masonry.h>

@interface PayListCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *titleLabel3;
@property (nonatomic, strong) UILabel *titleLabel4;
@property (nonatomic, strong) UILabel *valueLabel1;
@property (nonatomic, strong) UILabel *valueLabel2;
@property (nonatomic, strong) UILabel *valueLabel3;
@property (nonatomic, strong) UILabel *valueLabel4;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;
@property (nonatomic, strong) UITableView *tableView;

@end

static const CGFloat spacing = 1.0f;  /**< 图片间距 */
static const CGFloat itemSize = 85.0f;  /**< 图片间距 */
static const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */
static NSString *const kPayListCellID = @"PayListCell";
static NSString *const kImageCellID = @"kImageCellID";

@implementation PayListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"PayListCell";
    PayListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.collectionView.frame = self.contentView.bounds;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.paylist.order_sign_pic.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCellID forIndexPath:indexPath];
    cell.url = self.paylist.order_sign_pic[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 点击了照片
    PhotoBrowserViewController *vc = [[PhotoBrowserViewController alloc] initWithImages:self.paylist.order_sign_pic selectedIndex:indexPath.row];
    vc.sourceCollectionView = collectionView;
    [vc show];
    
}

- (void)setPaylist:(PayList *)paylist {
    _paylist = paylist;
    
    // 首付款
    NSTimeInterval first_order_using_time = [paylist.first_order_using_time doubleValue];
    NSTimeInterval order_time = [paylist.order_time doubleValue];
    
    self.titleLabel1.text = @"合同金额";
    self.titleLabel2.text = @"尾款时间";
    self.titleLabel3.text = @"首付金额";
    self.titleLabel4.text = @"支付时间";
    self.valueLabel1.text = paylist.order_money;
    self.valueLabel2.text = [NSString stringWithTimeInterval:order_time format:@"yyyy-MM-dd"];
    self.valueLabel3.text = paylist.first_order_money;
    self.valueLabel4.text = [NSString stringWithTimeInterval:first_order_using_time format:@"yyyy-MM-dd"];
    
    
    if (paylist.order_sign_pic.count) {
        // 有图片
        NSInteger num = paylist.order_sign_pic.count / 4 + 1;
        CGFloat height = num * itemSize + (num - 1) * spacing;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.line4.mas_bottom).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
            make.height.mas_equalTo(height);
        }];
    } else {
        // 没有图片
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.line4.mas_left);
            make.top.mas_equalTo(self.line4.mas_bottom);
            make.right.mas_equalTo(self.line4.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        [_collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:kImageCellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(itemSize, itemSize);
        _layout.minimumLineSpacing      = spacing;
        _layout.minimumInteritemSpacing = spacing;
    }
    return _layout;
}

- (UILabel *)titleLabel1 {
    if (_titleLabel1 == nil) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel1.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (_titleLabel2 == nil) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel2.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel2;
}

- (UILabel *)titleLabel3 {
    if (_titleLabel3 == nil) {
        _titleLabel3 = [[UILabel alloc] init];
        _titleLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel3.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel3;
}

- (UILabel *)titleLabel4 {
    if (_titleLabel4 == nil) {
        _titleLabel4 = [[UILabel alloc] init];
        _titleLabel4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLabel4.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
    }
    return _titleLabel4;
}

- (UILabel *)valueLabel1 {
    if (_valueLabel1 == nil) {
        _valueLabel1 = [[UILabel alloc] init];
        _valueLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _valueLabel1.textColor =  [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _valueLabel1;
}

- (UILabel *)valueLabel2 {
    if (_valueLabel2 == nil) {
        _valueLabel2 = [[UILabel alloc] init];
        _valueLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _valueLabel2.textColor =  [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _valueLabel2;
}

- (UILabel *)valueLabel3 {
    if (_valueLabel3 == nil) {
        _valueLabel3 = [[UILabel alloc] init];
        _valueLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _valueLabel3.textColor =  [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _valueLabel3;
}

- (UILabel *)valueLabel4 {
    if (_valueLabel4 == nil) {
        _valueLabel4 = [[UILabel alloc] init];
        _valueLabel4.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _valueLabel4.textColor =  [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
    }
    return _valueLabel4;
}

- (UIView *)line1 {
    if (_line1 == nil) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = HEX(@"#efeff4");
    }
    return _line1;
}

- (UIView *)line2 {
    if (_line2 == nil) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = HEX(@"#efeff4");
    }
    return _line2;
}

- (UIView *)line3 {
    if (_line3 == nil) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = HEX(@"#efeff4");
    }
    return _line3;
}
- (UIView *)line4 {
    if (_line4 == nil) {
        _line4 = [[UIView alloc] init];
        _line4.backgroundColor = HEX(@"#efeff4");
    }
    return _line4;
}

//- (UITableView *)tableView {
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] init];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.scrollEnabled = NO;
//    }
//    return _tableView;
//}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel1];
    [self.contentView addSubview:self.titleLabel2];
    [self.contentView addSubview:self.titleLabel3];
    [self.contentView addSubview:self.titleLabel4];
    [self.contentView addSubview:self.valueLabel1];
    [self.contentView addSubview:self.valueLabel2];
    [self.contentView addSubview:self.valueLabel3];
    [self.contentView addSubview:self.valueLabel4];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    [self.contentView addSubview:self.line3];
    [self.contentView addSubview:self.line4];
    [self.contentView addSubview:self.collectionView];
    
    // 拉伸
    [self.titleLabel1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel1 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 拉伸
    [self.titleLabel2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 拉伸
    [self.titleLabel3 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel3 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 拉伸
    [self.titleLabel4 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel4 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(44);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self.valueLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_right).offset(31);
        make.top.mas_equalTo(self.titleLabel1.mas_top);
        make.height.mas_equalTo(self.titleLabel1.mas_height);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.titleLabel1.mas_bottom);
    }];
    
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel1.mas_left);
        make.top.mas_equalTo(self.line1.mas_bottom);
        make.height.mas_equalTo(self.titleLabel1.mas_height);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self.valueLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel1.mas_left);
        make.top.mas_equalTo(self.titleLabel2.mas_top);
        make.height.mas_equalTo(self.titleLabel2.mas_height);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_left);
        make.height.mas_equalTo(self.line1.mas_height);
        make.right.mas_equalTo(self.line1.mas_right);
        make.top.mas_equalTo(self.titleLabel2.mas_bottom);
    }];
    
    [self.titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel2.mas_left);
        make.top.mas_equalTo(self.line2.mas_bottom);
        make.height.mas_equalTo(self.titleLabel2.mas_height);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self.valueLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel2.mas_left);
        make.top.mas_equalTo(self.titleLabel3.mas_top);
        make.height.mas_equalTo(self.titleLabel3.mas_height);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_left);
        make.height.mas_equalTo(self.line2.mas_height);
        make.right.mas_equalTo(self.line1.mas_right);
        make.top.mas_equalTo(self.titleLabel3.mas_bottom);
    }];
    
    [self.titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel3.mas_left);
        make.top.mas_equalTo(self.line3.mas_bottom);
        make.height.mas_equalTo(self.titleLabel3.mas_height);
        make.width.mas_greaterThanOrEqualTo(60);
    }];
    
    [self.valueLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.valueLabel3.mas_left);
        make.top.mas_equalTo(self.titleLabel4.mas_top);
        make.height.mas_equalTo(self.titleLabel4.mas_height);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line1.mas_left);
        make.height.mas_equalTo(self.line3.mas_height);
        make.right.mas_equalTo(self.line1.mas_right);
        make.top.mas_equalTo(self.titleLabel4.mas_bottom);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.line4.mas_bottom).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
    }];
}

@end
