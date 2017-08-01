//
//  MultiCell.m
//  森
//
//  Created by Lee on 17/4/6.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "MultiCell.h"
#import "ArrowItem.h"
#import "TextFieldItem.h"
#import "TextViewItem.h"
#import "KeyboardView.h"
#import "TextView.h"
#import "SwitchItem.h"
#import "ButtonItem.h"

#import <Masonry.h>

#define kTextColor HEX(@"#000000")
#define kPlaceholderColor [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22]

@interface MultiCell () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *requiredLabel;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) TextView *textView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIButton *buttonView;
@property (nonatomic, assign) NSInteger maxLength;

@end

@implementation MultiCell

static CGFloat const margin = 105;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MultiCell";
    MultiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MultiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)becomeFirstResponder {
    if (self.textField.hidden == NO) {
        [self.textField becomeFirstResponder];
    }
}

- (void)buttonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(multiCell:valueDidChange:)]) {
        [self.delegate multiCell:self valueDidChange:nil];
    }
}

- (void)switchViewDidChange:(UISwitch *)switchView {
    if ([self.delegate respondsToSelector:@selector(multiCell:valueDidChange:)]) {
        [self.delegate multiCell:self valueDidChange:@(switchView.isOn)];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    TextFieldItem *textFieldItem = (TextFieldItem *)self.item;
    textFieldItem.value = self.textField.text;

    if ([self.delegate respondsToSelector:@selector(multiCell:valueDidChange:)]) {
        [self.delegate multiCell:self valueDidChange:textField.text];
    }
}

- (void)textFieldBecomeFirstResponder:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(multiCellTextFieldBecomeFirstResponder:)]) {
        [self.delegate multiCellTextFieldBecomeFirstResponder:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(multiCellTextFieldBecomeFirstResponder:)]) {
        [self.delegate multiCellTextFieldBecomeFirstResponder:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    TextViewItem *textViewItem = (TextViewItem *)self.item;
    textViewItem.value = textView.text;
    
    if ([self.delegate respondsToSelector:@selector(multiCell:valueDidChange:)]) {
        [self.delegate multiCell:self valueDidChange:textView.text];
    }
}

- (BOOL)obj:(id)obj shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    if (self.maxLength == 0) return YES;
    
    //不支持系统表情的输入
    if ([[obj textInputMode] primaryLanguage]==nil||[[[obj textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    UITextRange *selectedRange = [obj markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [obj positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [obj offsetFromPosition:[obj beginningOfDocument] toPosition:selectedRange.start];
        NSInteger endOffset = [obj offsetFromPosition:[obj beginningOfDocument] toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < self.maxLength) {
            return YES;
        }else{
            return NO;
        }
    }
    NSString *comcatstr = [[obj text] stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = self.maxLength - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }else{
                __block NSInteger idx =0;
                __block NSString  *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop =YES;//取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [obj setText:[[obj text] stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text {
    BOOL value = [self obj:textField shouldChangeCharactersInRange:range replacementString:text];
    if (value == NO) {
        if ([self.delegate respondsToSelector:@selector(multiCell:didBeyondLength:title:)]) {
            [self.delegate multiCell:self didBeyondLength:self.maxLength title:self.item.title];
        }
    }
    return value;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    BOOL value =  [self obj:textView shouldChangeCharactersInRange:range replacementString:text];
    if (value == NO) {
        if ([self.delegate respondsToSelector:@selector(multiCell:didBeyondLength:title:)]) {
            [self.delegate multiCell:self didBeyondLength:self.maxLength title:self.item.title];
        }
    }
    return value;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.requiredLabel];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.arrow];
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.switchView];
    [self.contentView addSubview:self.buttonView];
    
//    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        //            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_greaterThanOrEqualTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        make.height.mas_lessThanOrEqualTo(44 - 16);
    }];

    [self.requiredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin - 4);
        make.top.mas_equalTo(self.contentView.mas_top).offset(8);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(8);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (void)setItem:(BaseItem *)item {
    _item = item;

    [self updateSubviews];
}

- (void)setReadOnly:(BOOL)readOnly {
    _readOnly = readOnly;
    
    [self updateSubviews];
}

- (void)updateSubviews {
    self.titleLabel.text = self.item.title;
    self.label.textAlignment = self.item.textAlignment;
    self.requiredLabel.hidden = !self.item.isRequired;
    
    if ([self.item isMemberOfClass:[BaseItem class]]) {
        self.label.text = self.item.value;
        self.arrow.hidden = YES;
        self.label.hidden = NO;
        self.textField.hidden = YES;
        self.textView.hidden = YES;
        self.switchView.hidden = YES;
        self.buttonView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if (self.readOnly) {
            self.label.textColor = HEX(@"#939399");
//        } else {
//            self.label.textColor = kTextColor;
//        }
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
            make.height.mas_greaterThanOrEqualTo(44 - 16);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
        
        // 重新设定约束，避免循环应用
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
//            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.right.mas_lessThanOrEqualTo(self.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
//            make.height.mas_greaterThanOrEqualTo(44 - 16);
        }];
    } else if([self.item isMemberOfClass:[ArrowItem class]]) {
        ArrowItem *arrowItem = (ArrowItem *)self.item;
        
        self.label.textColor = [UIColor colorWithRed:147/255.0 green:147/255.0 blue:153/255.0 alpha:1/1.0];
        self.arrow.hidden = NO;
        self.label.hidden = NO;
        self.textField.hidden = YES;
        self.textView.hidden = YES;
        self.switchView.hidden = YES;
        self.buttonView.hidden = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        if (arrowItem.disable) {
            self.arrow.hidden = YES;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            self.arrow.hidden = NO;
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
        if (arrowItem.subTitle) {
            self.label.textColor = kTextColor;
            self.label.text = arrowItem.subTitle;
        } else {
            self.label.textColor = kPlaceholderColor;
            self.label.text = arrowItem.placeholder;
        }
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.right.mas_equalTo(self.arrow.mas_left).offset(-15);
        }];
        // 重新设定约束，避免循环应用
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    } else if([self.item isMemberOfClass:[TextFieldItem class]]) {
        TextFieldItem *textFieldItem = (TextFieldItem *)self.item;
        self.textField.placeholder = textFieldItem.placeholder;
        self.textField.text = textFieldItem.value;
        self.textField.keyboardType = textFieldItem.keyboardType;
        self.textField.secureTextEntry = textFieldItem.isSecureTextEntry;
        self.textField.textAlignment = textFieldItem.textAlignment;
        self.switchView.hidden = YES;
        self.maxLength = textFieldItem.maxLength;
        self.label.textColor = kTextColor;
        
        self.arrow.hidden = YES;
        self.label.hidden = YES;
        self.textField.hidden = NO;
        self.textView.hidden = YES;
        self.buttonView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 重新设定约束，避免循环应用
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    } else if([self.item isMemberOfClass:[TextViewItem class]]) {
        TextViewItem *textViewItem = (TextViewItem *)self.item;
        self.textView.placeholder = textViewItem.placeholder;
        self.textView.text = textViewItem.value;
        self.arrow.hidden = YES;
        self.label.hidden = NO;
        self.textField.hidden = YES;
        self.textView.hidden = NO;
        self.switchView.hidden = YES;
        self.buttonView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label.textColor = kTextColor;
        
        self.maxLength = textViewItem.maxLength;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            // 因为textView里placeholder的y是7
            make.top.mas_equalTo(self.textView.mas_top).offset(7);
        }];
        
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(margin - 4);
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.height.mas_equalTo(textViewItem.height);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];
    } else if([self.item isMemberOfClass:[SwitchItem class]]) {
        SwitchItem *switchItem = (SwitchItem *)self.item;
        self.arrow.hidden = YES;
        self.label.hidden = YES;
        self.textField.hidden = YES;
        self.textView.hidden = YES;
        self.switchView.hidden = NO;
        self.buttonView.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label.textColor = kTextColor;
        
        self.switchView.on = [switchItem.value boolValue];
        
        // 重新设定约束，避免循环应用
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if([self.item isMemberOfClass:[ButtonItem class]]) {
        ButtonItem *buttonItem = (ButtonItem *)self.item;
        self.label.text = buttonItem.value;
        self.arrow.hidden = YES;
        self.textField.hidden = YES;
        self.textView.hidden = YES;
        self.switchView.hidden = YES;
        self.label.hidden = NO;
        self.buttonView.hidden = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label.textColor = kTextColor;
        if (buttonItem.text) {
            [self.buttonView setTitle:buttonItem.text forState:UIControlStateNormal];
        } else {
            [self.buttonView setTitle:@"" forState:UIControlStateNormal];
        }
        
        if (buttonItem.image) {
            [self.buttonView setBackgroundImage:IMAGE(buttonItem.image) forState:UIControlStateNormal];
        } else {
            [self.buttonView setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.right.mas_lessThanOrEqualTo(self.buttonView.mas_left).offset(-15);
        }];
        
        // 重新设定约束，避免循环应用
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.0 green:49/255.0 blue:51/255.0 alpha:1/1.0];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)requiredLabel {
    if (_requiredLabel == nil) {
        _requiredLabel = [[UILabel alloc] init];
        _requiredLabel.text = @"*";
        _requiredLabel.font = [UIFont fontWithName:@"SFUIText-Regular" size:14];
        _requiredLabel.textColor = [UIColor colorWithRed:250/255.0 green:75/255.0 blue:75/255.0 alpha:1/1.0];
    }
    return _requiredLabel;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _label.textColor = HEX(@"#939399");
        _label.numberOfLines = 0;
    }
    return _label;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_textField addTarget:self action:@selector(textFieldBecomeFirstResponder:) forControlEvents:UIControlEventEditingDidBegin];
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _textField;
}

- (UIImageView *)arrow {
    if (_arrow == nil) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = IMAGE(@"icon-select");
    }
    return _arrow;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEX(@"#EBEBF0");
    }
    return _line;
}

- (TextView *)textView{
    if (_textView == nil) {
        _textView = [[TextView alloc] init];
        _textView.delegate = self;
    }
    return _textView;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchViewDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIButton *)buttonView {
    if (_buttonView == nil) {
        _buttonView = [[UIButton alloc] init];
        _buttonView.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_buttonView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView setTitleColor:RGB(23, 143, 230) forState:UIControlStateNormal];
    }
    return _buttonView;
}

@end
