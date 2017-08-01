//
//  DropdownMenu.m
//  森
//
//  Created by Lee on 2017/7/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "DropdownMenu.h"
#import "DropdownButton.h"
#import "AreaCell.h"
#import "Option.h"

@interface DropdownMenu () <DropdownButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger numberOfComponentsInComponent;
@property (nonatomic, assign) NSInteger numberOfRowsInComponent;
@property (nonatomic, assign) NSInteger numberOfComponentsInDropdownMenu;

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIControl *drawerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) DropdownButton *lastSelectButton;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, assign) CGFloat width;

@end

@implementation DropdownMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.buttons = [NSMutableArray array];
        self.width = (SCREEN_WIDTH - 2 * 10 - 6 * 10) / 4 - 1;
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    if (self = [super init]) {
        self.items = items;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat height = 0.5;
    CGFloat y = self.frame.size.height - height;
    CGFloat width = self.frame.size.width - 2 * x;
    self.bottomLine.frame = CGRectMake(x, y, width, height);
    Log(@"%@",NSStringFromCGSize(self.collectionView.contentSize));
}

- (void)showDrawerView {
    CGFloat height = SCREEN_HEIGHT - self.frame.origin.y;
    self.drawerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, height);
    self.drawerView.backgroundColor = HEXA(@"#000000", 0.6);
    [self.superview addSubview:self.drawerView];
    CGFloat maxHeight = SCREEN_HEIGHT - CGRectGetMaxY(self.frame);
    
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    [UIView animateWithDuration:0.3 animations:^{
        if (self.selectedIndex == 0) {
            int count = ceilf(self.datas.count / 4 + 0.5);
            CGFloat height = 10 * 2 + (count - 1) * 5 + count * 32;
            CGRect rect = self.collectionView.frame;
            rect.size.height = MIN(height, maxHeight);
            self.collectionView.frame = rect;
        } else {
            CGFloat height = 10 * 2 + (self.datas.count - 1) * 5 + self.datas.count * 32;
            CGRect rect = self.collectionView.frame;
            rect.size.height = MIN(height, maxHeight);
            self.collectionView.frame = rect;
        }
    }];
}

- (void)manualHiddenDrawerView {
    DropdownButton *button = [self.buttons objectAtIndex:self.selectedIndex];
    // 更新button的title
    button.selected = NO;
    [self hiddenDrawerView];
}

- (void)hiddenDrawerView {
    [UIView animateWithDuration:0.3 animations:^{
        self.drawerView.backgroundColor = HEXA(@"#000000", 0.);
        self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.drawerView removeFromSuperview];
    }];
}

- (void)rapidHiddenDrawerView:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:0.1 animations:^{
        self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, 0);
    } completion:completion];
}

- (void)dropdownButton:(DropdownButton *)button didSelect:(BOOL)selected {
    self.selectedIndex = [self.buttons indexOfObject:button];
    for (DropdownButton *btn in self.buttons) {
        if (button != btn) {
            btn.selected = NO;
        }
    }
    
    if (self.lastSelectButton != button) {
        // 如果点的不是同一个，先把上一个快速的收缩起来
        [self rapidHiddenDrawerView:^(BOOL finished) {
            [self showDrawerView];
        }];
    } else {
        if (selected) {
            [self showDrawerView];
        } else {
            [self hiddenDrawerView];
        }
    }
    
    self.lastSelectButton = button;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AreaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAreaCellID forIndexPath:indexPath];
    Option *option = self.datas[indexPath.row];
    cell.option = option;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Option *option = self.datas[indexPath.row];
    option.selected = YES;
    
    self.selectedOption = option;
    
    for (Option *o in self.datas) {
        if (o != option) {
            o.selected = NO;
        }
    }
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelectOption:)]) {
        [self.delegate dropdownMenu:self didSelectOption:option];
    }
    
    // 更新button的title
    DropdownButton *button = [self.buttons objectAtIndex:self.selectedIndex];
//    button.layer.borderColor = HEX(@"#178FE6").CGColor;
//    button.titleLabel.textColor = HEX(@"#178FE6");
    button.titleLabel.text = option.title;

    // 收起抽屉
    [self manualHiddenDrawerView];
    
}

- (void)setDataSource:(id<DropdownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    self.numberOfComponentsInComponent = [dataSource respondsToSelector:@selector(numberOfComponentsInComponent)];
    if ([dataSource respondsToSelector:@selector(numberOfComponentsInComponent)]) {
        self.numberOfComponentsInDropdownMenu = [dataSource numberOfComponentsInDropdownMenu:self];
    } else {
        self.numberOfComponentsInDropdownMenu = 1;
    }
    
    for (int i=0; i<self.numberOfComponentsInDropdownMenu; i++) {
        self.numberOfComponentsInComponent = [dataSource dropdownMenu:self numberOfRowsInComponent:i];
        DropdownButton *button = [[DropdownButton alloc] init];
        button.titleLabel.text = [self.delegate dropdownMenu:self titleForComponent:i];
    }
}

- (void)setDelegate:(id<DropdownMenuDelegate>)delegate {
    _delegate = delegate;
    
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (selectedIndex == 0) {
        self.datas = self.areas;
        self.layout.itemSize = CGSizeMake(self.width, 32);
    } else {
        self.datas = self.types;
        CGFloat width = SCREEN_WIDTH - 40;
        self.layout.itemSize = CGSizeMake(width, 32);
    }
    
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    
    [self.collectionView reloadData];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [self.buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttons removeAllObjects];
    
    CGFloat itemW = SCREEN_WIDTH / (float)items.count;
    CGFloat itemY = 0;
    CGFloat itemH = 49;
    for (int i = 0; i < items.count; i++) {
        DropdownButton *button = [[DropdownButton alloc] init];
        button.delegate = self;
        button.titleLabel.text = items[i];
        CGFloat itemX = i * itemW;
        button.frame = CGRectMake(itemX, itemY, itemW, itemH);
        if (i > 0 && i < items.count) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HEX(@"#EFEFF4");
            CGFloat lineX = itemX;
            CGFloat lineY = 11;
            CGFloat lineW = 1;
            CGFloat lineH = itemH - 2 * lineY;
            line.frame = CGRectMake(lineX, lineY, lineW, lineH);
            [self addSubview:line];
        }
        [self.buttons addObject:button];
        [self addSubview:button];
    }
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = HEX(@"#E6E6EB");
    }
    return _bottomLine;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[AreaCell class] forCellWithReuseIdentifier:kAreaCellID];
    }
    return _collectionView;
}

- (UIControl *)drawerView {
    if (_drawerView == nil) {
        _drawerView = [[UIControl alloc] init];
        _drawerView.backgroundColor = HEXA(@"#000000", 0.6);
        [_drawerView addTarget:self action:@selector(manualHiddenDrawerView) forControlEvents:UIControlEventTouchUpInside];
        [_drawerView addSubview:self.collectionView];
    }
    return _drawerView;
}

- (UICollectionViewFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(self.width, 32);
        _layout.minimumLineSpacing = 5;
        _layout.minimumInteritemSpacing = 5;
        _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _layout;
}

@end
