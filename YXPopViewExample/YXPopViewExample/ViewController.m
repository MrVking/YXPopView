//
//  ViewController.m
//  YXPopViewExample
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"

#import "YXPopView.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray * dataSourceArr;

@property (weak, nonatomic) IBOutlet UILabel *dataLab;

@end

@implementation ViewController

- (NSArray *)dataSourceArr
{
    if (!_dataSourceArr) {
        
        _dataSourceArr = @[@"Objective-C(GitHub)",@"Javascript(GitHub)",@"C(GitHub)",@"C++(GitHub)",@"C#(GitHub)",@"Python(GitHub)",@"Swift(GitHub)"];
        
    }
    
    return _dataSourceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [YXPopView dismiss];
}
- (IBAction)show {
    
    __weak typeof(self) weakSelf = self;
    
    [YXPopView showWithTitle:@"Program Language" subTitle:@"Objective-C(GitHub)" dataArray:self.dataSourceArr clickRow:^(NSInteger row) {
        
        weakSelf.dataLab.text = weakSelf.dataSourceArr[row];
        
    }];
    
    
}

@end
