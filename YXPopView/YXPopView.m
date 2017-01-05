//
//  YXPopView.m
//  YXPopView
//
//  Created by shiqin on 2017/1/4.
//  Copyright © 2017年 mifo. All rights reserved.
//

#import "YXPopView.h"

#define YXScreenWidth  [UIScreen mainScreen].bounds.size.width

#define YXScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface YXPopView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UILabel * titleLab;

@property (nonatomic, weak) UILabel * subTitleLab;


@property (nonatomic, weak) UITableView * tableView;


@property (strong, nonatomic) NSArray * dataArr;

@property (nonatomic, copy) void(^tableClickRow)(NSInteger row);

@end

@implementation YXPopView

static UIWindow * window_;

static UIView * boundView_;


+ (YXPopView*)sharedView {
    
    static dispatch_once_t once;
    
    static YXPopView *sharedView;
    
    dispatch_once(&once, ^ {
        
       sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
       sharedView.backgroundColor = [UIColor clearColor];
        
    });
    
    
    
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        UIWindow * window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        window.windowLevel = UIWindowLevelAlert;

        
        window.hidden = NO;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
        tap.delegate = self;
        
        [window addGestureRecognizer:tap];
        
        window_ = window;

        UIView * boundView = [[UIView alloc]initWithFrame:CGRectMake(50, 100, YXScreenWidth - 100, YXScreenHeight - 200)];
        
        boundView.layer.cornerRadius = 8;
        
        boundView.layer.masksToBounds = YES;
        
        boundView.backgroundColor = [UIColor whiteColor];
        
        boundView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        
        [window addSubview:boundView];
        
        boundView_ = boundView;
        
        UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, YXScreenWidth - 100, 30)];
        
        titleLab.font = _titleLabFont == nil ? [UIFont boldSystemFontOfSize:16] : _titleLabFont;
        

        
        titleLab.textAlignment = NSTextAlignmentCenter;
        
        titleLab.textColor  = _titleLabColor == nil ? [UIColor darkTextColor] : _titleLabColor;
        

        
        [boundView addSubview:titleLab];
        
        _titleLab = titleLab;
        
        UILabel * subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame)+10, titleLab.frame.size.width, 20)];
        
        subTitleLab.font = _subTitleLabFont == nil ? [UIFont systemFontOfSize:13] : _subTitleLabFont;
        
        subTitleLab.textAlignment = NSTextAlignmentCenter;
        
        subTitleLab.textColor = _subTitleLabColor == nil ? [UIColor lightGrayColor] : _subTitleLabColor;
        

        [boundView addSubview:subTitleLab];
        
        _subTitleLab = subTitleLab;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subTitleLab.frame)+10,subTitleLab.frame.size.width, 1)];
        
        lineView.backgroundColor = [UIColor darkGrayColor];
        
        [boundView addSubview:lineView];
        
        
        UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+10, titleLab.frame.size.width, YXScreenHeight - 200 - (CGRectGetMaxY(lineView.frame)+20)) style:UITableViewStylePlain];
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.dataSource = self;
        
        tableView.delegate = self;

        [boundView addSubview:tableView];
        
        _tableView = tableView;
    
    
    }
    
    return self;
}

+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle dataArray:(NSArray *)array clickRow:(void(^)(NSInteger row))click;
{

    YXPopView * popView = [YXPopView sharedView];
    
    popView.dataArr = array;
    
    [popView.tableView reloadData];
    
    popView.titleLab.text = title;
    
    popView.subTitleLab.text = subTitle;
    
    popView.tableClickRow = ^(NSInteger row) {
    
        if (click){
         
            click(row);
        }
        
        [self dismiss];
    
    };
    
    
    [UIView animateWithDuration:0.4 animations:^{
        
        window_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        boundView_.alpha = 1.0;
        
        boundView_.transform = CGAffineTransformIdentity;
        
        
    }completion:^(BOOL finished) {
        
        window_.userInteractionEnabled = YES;
    }];
    
    
    
}


+ (void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        
        boundView_.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
        //
        boundView_.alpha = 0.0;
        
       
        
    }completion:^(BOOL finished) {
        
         window_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
         window_.userInteractionEnabled = NO;
        
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else {
        return YES;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:boundView_];

    //判断某个点是否在某个view的图层上
    
    if (![boundView_.layer containsPoint:point]) {
    
         [YXPopView dismiss];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"contentCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (_cellLabAlignment) {
    
        cell.textLabel.textAlignment = _cellLabAlignment;
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableClickRow) {
    
        self.tableClickRow(indexPath.row);
    }
}




@end
