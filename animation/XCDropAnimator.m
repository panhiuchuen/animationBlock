//
//  XCDropAnimator.m
//  animation
//
//  Created by JohnnyPan on 15/12/25.
//  Copyright © 2015年 JohnnyPan. All rights reserved.
//

#import "XCDropAnimator.h"

@implementation XCDropAnimator


-(UIGravityBehavior*)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 1;
    }
    return _gravity;
}

-(UICollisionBehavior*)collisoner
{
    if (!_collisoner) {
        _collisoner = [[UICollisionBehavior alloc] init];
        _collisoner.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collisoner;
}

-(UIDynamicItemBehavior*)itemBehavior
{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc] init];
        _itemBehavior.allowsRotation = NO;
       
    }
    return _itemBehavior;
}

-(void) addItem:(id <UIDynamicItem>)UIItem
{
    [self.gravity addItem:UIItem];
    [self.collisoner addItem:UIItem];
    [self.itemBehavior addItem:UIItem];
}

-(void) removeItem:(id <UIDynamicItem>)UIItem
{
    [self.gravity removeItem:UIItem];
    [self.collisoner removeItem:UIItem];
    [self.itemBehavior removeItem:UIItem];
}

-(instancetype) init
{
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collisoner];
    [self addChildBehavior:self.itemBehavior];
    return self;
}

@end
