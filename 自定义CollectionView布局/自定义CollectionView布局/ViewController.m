//
//  ViewController.m
//  自定义CollectionView布局
//
//  Created by tarena on 15/8/11.
//  Copyright (c) 2015年 com.wanq. All rights reserved.
//

#import "ViewController.h"
#import "MyImageCell.h"
#import "MyLineLayout.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource >

@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ViewController

static NSString * const ID = @"image";

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
        for (int i = 1; i<=25; i++) {
            if (i<10) {
                [self.images addObject:[NSString stringWithFormat:@"00%d", i]];
            } else {
                [self.images addObject:[NSString stringWithFormat:@"0%d", i]];
            }
        }
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat w = self.view.bounds.size.width;
    
    CGRect rect = CGRectMake(0, 100, w, 200);
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[MyLineLayout alloc] init]];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"MyImageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:collectionView];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyImageCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.image = self.images[indexPath.row];
    
    return cell;
}


@end
