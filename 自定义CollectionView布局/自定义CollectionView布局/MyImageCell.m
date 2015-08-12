//
//  MyImageCell.m
//  自定义CollectionView布局
//
//  Created by tarena on 15/8/11.
//  Copyright (c) 2015年 com.wanq. All rights reserved.
//

#import "MyImageCell.h"

@interface MyImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation MyImageCell

-(void)setImage:(NSString *)image
{
    _image = [image copy];
    self.imageView.image = [UIImage imageNamed:_image];
    
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
