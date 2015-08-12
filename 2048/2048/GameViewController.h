//
//  GameViewController.h
//  2048
//
//  Created by tarena on 15/7/9.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *boxSites;

@end
