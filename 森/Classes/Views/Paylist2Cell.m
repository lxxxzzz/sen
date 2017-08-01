//
//  Paylist2Cell.m
//  森
//
//  Created by Lee on 2017/7/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "Paylist2Cell.h"
#import "ImageCell.h"
#import "PayList.h"
#import "PhotoBrowserViewController.h"
#import "NSString+Extension.h"
#import <Masonry.h>

@interface Paylist2Cell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UILabel *titleLabel1;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UILabel *valueLabel1;
@property (nonatomic, strong) UILabel *valueLabel2;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;

@end

static const CGFloat spacing = 1.0f;  /**< 图片间距 */
static const CGFloat itemSize = 85.0f;  /**< 图片间距 */
static const NSInteger maxCountInLine = 4; /**< 每行显示图片张数 */
static NSString *const kPayListCellID = @"Paylist2Cell";
static NSString *const kImageCellID = @"kImageCellID";

@implementation Paylist2Cell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    Paylist2Cell *cell = [tableView dequeueReusableCellWithIdentifier:kPayListCellID];
    if (cell == nil) {
        cell = [[Paylist2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPayListCellID];
    }
    return cell;
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
    Log(@"类型%ld  数量%ld  %@",self.paylist.sign_type,self.paylist.order_sign_pic.count,[[self.paylist.order_sign_pic firstObject] class]);
    // 1 中款 2尾款 3附加款 4尾款时间 5首款
    NSTimeInterval order_time = [paylist.order_time doubleValue];
    NSString *strDate = [NSString stringWithTimeInterval:order_time format:@"yyyy-MM-dd"];
    
    if (paylist.sign_type == 1) {
        // 中款
        self.titleLabel1.text = @"中款金额";
        self.titleLabel2.text = @"支付时间";
        self.valueLabel1.text = paylist.order_money;
        self.valueLabel2.text = strDate;
        
        
    } else if (paylist.sign_type == 2) {
        // 尾款
        self.titleLabel1.text = @"尾款金额";
        self.titleLabel2.text = @"支付时间";
        
        self.valueLabel1.text = paylist.order_money;
        self.valueLabel2.text = strDate;
    } else if (paylist.sign_type == 3) {
        // 附加款
        self.titleLabel1.text = @"附加款金额";
        self.titleLabel2.text = @"支付时间";
        
        self.valueLabel1.text = paylist.order_money;
        self.valueLabel2.text = strDate;
        
    } else if (paylist.sign_type == 4) {
        // 尾款时间
        self.titleLabel1.text = @"原时间";
        self.titleLabel2.text = @"申请时间";
        NSTimeInterval other_item_weikuan_old_time = [paylist.other_item_weikuan_old_time doubleValue];
        NSString *old_time = [NSString stringWithTimeInterval:other_item_weikuan_old_time format:@"yyyy-MM-dd"];
        
        NSTimeInterval other_item_weikuan_new_time = [paylist.other_item_weikuan_new_time doubleValue];
        NSString *new_time = [NSString stringWithTimeInterval:other_item_weikuan_new_time format:@"yyyy-MM-dd"];
        
        self.valueLabel1.text = old_time;
        self.valueLabel2.text = new_time;
        
    }
    
    
    if (paylist.order_sign_pic.count) {
        // 有图片
        NSInteger num = paylist.order_sign_pic.count / 4 + 1;
        CGFloat height = num * itemSize + (num - 1) * spacing;
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.top.mas_equalTo(self.line2.mas_bottom).offset(12);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
            make.height.mas_equalTo(height);
        }];
    } else {
        // 没有图片
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.line2.mas_left);
            make.top.mas_equalTo(self.line2.mas_bottom);
            make.right.mas_equalTo(self.line2.mas_right);
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

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel1];
    [self.contentView addSubview:self.titleLabel2];
    [self.contentView addSubview:self.valueLabel1];
    [self.contentView addSubview:self.valueLabel2];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    [self.contentView addSubview:self.collectionView];
    
    // 拉伸
    [self.titleLabel1 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel1 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 拉伸
    [self.titleLabel2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    // 压缩
    [self.titleLabel2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.line2.mas_bottom).offset(12);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
    }];
}

@end
