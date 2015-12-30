//
//  XCDropAnimator.h
//  animation
//
//  Created by JohnnyPan on 15/12/25.
//  Copyright © 2015年 JohnnyPan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCDropAnimator : UIDynamicBehavior
@property (strong , nonatomic) UIGravityBehavior * gravity;
@property (strong , nonatomic) UICollisionBehavior * collisoner;
@property (strong , nonatomic) UIDynamicItemBehavior * itemBehavior;

-(void) addItem:(id <UIDynamicItem>) UIItem;
-(void) removeItem:(id <UIDynamicItem>) UIItem;

@end
