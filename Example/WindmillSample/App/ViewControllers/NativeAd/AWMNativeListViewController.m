//
//  AWMNativeListViewController.m
//  WindmillSample
//
//  Created by xiaoxiao2 on 2023/2/28.
//

#import "AWMNativeListViewController.h"

@interface AWMNativeListViewController ()
@end

@implementation AWMNativeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildSubViews];
}


- (void)buildSubViews {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.frame = CGRectMake(0, 0, 200, 100);
    stackView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:stackView];
    
    NSDictionary *dataDic = @{@"draw视频信息流广告":@"clickDrawBtn:", @"原生信息流广告":@"clickNativeBtn:"};
    NSMutableArray <UIButton *>*btnsArray = [NSMutableArray array];
    [dataDic enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:key forState:UIControlStateNormal];
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = UIColor.blackColor.CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString(obj) forControlEvents:UIControlEventTouchUpInside];
        [stackView addArrangedSubview:btn];
        [btnsArray addObject:btn];
    }];
        stackView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;

}

- (void)clickDrawBtn:(UIButton *)btn {
    [self pushToAdVC:@"AWMDrawAdConfigViewController"];
}

- (void)clickNativeBtn:(UIButton *)btn {
    [self pushToAdVC:@"WindmillNativeAdViewController"];
}

-(void)pushToAdVC:(NSString *)vcClassStr {
    Class cls = NSClassFromString(vcClassStr);
    if(!cls){
        return;
    }
    [self.navigationController pushViewController:[[cls alloc]init] animated:YES];
}

@end
