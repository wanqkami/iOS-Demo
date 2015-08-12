//
//  MyLineLayout.m
//  自定义CollectionView布局
//
//  Created by tarena on 15/8/11.
//  Copyright (c) 2015年 com.wanq. All rights reserved.
//

#import "MyLineLayout.h"

static const CGFloat ItemWH = 100;

@implementation MyLineLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(ItemWH, ItemWH);
    
    CGFloat inset = (self.collectionView.frame.size.width-ItemWH)*0.5;
    
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
            self.minimumLineSpacing = 100;
    
    //        UICollectionViewLayoutAttributes;
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    NSArray * arr = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes * attrs in arr) {
        
        
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        CGFloat itemCenterX = attrs.center.x;
        
        if (ABS(itemCenterX - centerX) <= 150) {
            CGFloat scale = 1+0.8*(1- (ABS(itemCenterX - centerX)/150));
            attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
        } else {
            attrs.transform = CGAffineTransformMakeScale(1, 1);
        }
        
        
    }
    
    return arr;
}

@end
