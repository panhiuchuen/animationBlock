//
//  ViewController.m
//  animation
//
//  Created by JohnnyPan on 15/12/24.
//  Copyright © 2015年 JohnnyPan. All rights reserved.
//

#import "ViewController.h"
#import "XCDropAnimator.h"

#import "XCBezierPathView.h"

@interface ViewController ()<UIDynamicAnimatorDelegate>

@property (strong ,nonatomic) XCBezierPathView * animationView;

@property (strong ,nonatomic ) UIDynamicAnimator * animationDrop;

@property (strong ,nonatomic) XCDropAnimator * dropBehavior;


@property (strong ,nonatomic) UIAttachmentBehavior * attach;

@property (strong ,nonatomic) UIView * dropView;


@end

@implementation ViewController

static const CGSize DropSize = {41.4,41.4};

#pragma -mark seter geter


-(XCDropAnimator*)dropBehavior
{
    if (!_dropBehavior) {
        _dropBehavior = [[XCDropAnimator alloc] init];
    
    }
    return _dropBehavior;
}

-(UIDynamicAnimator*)animationDrop
{
    if (!_animationDrop) {
        _animationDrop = [[UIDynamicAnimator alloc] initWithReferenceView:self.animationView];
        [_animationDrop addBehavior:self.dropBehavior];
    }
    return _animationDrop;
}

-(UIView * ) animationView
{
    if (!_animationView) {
        _animationView = [[XCBezierPathView alloc] initWithFrame:self.view.frame];
       // _animationView = [[XCBezierPathView alloc] init];
        _animationView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_animationView];
        
    }
    return _animationView;
}
#pragma -mark gestureEvent
-(void) tapEvent:(UITapGestureRecognizer *) tapGesture
{
    [self drop];
}

-(void)pan:(UIPanGestureRecognizer *) panGesture
{
    CGPoint gesturePoint = [panGesture locationInView:self.animationView];
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        [self attachDrop:gesturePoint];
    }else if(panGesture.state == UIGestureRecognizerStateChanged)
    {
        self.attach.anchorPoint = gesturePoint;
    }else if(panGesture.state == UIGestureRecognizerStateEnded)
    {
        [self.animationDrop removeBehavior:self.attach];
        self.animationView.path = nil;
    }
}

#pragma -mark func

-(void) attachDrop:(CGPoint) gesturePoint
{
    if (self.dropView) {
        self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.dropView attachedToAnchor:gesturePoint];
        
      
        UIView * dropView = self.dropView;
        __weak ViewController * weakController = self;
        self.attach.action = ^{
            UIBezierPath * dropPath = [[UIBezierPath alloc] init];
            [dropPath moveToPoint:weakController.attach.anchorPoint];
            [dropPath addLineToPoint:dropView.center];
            weakController.animationView.path = dropPath;
        };
        
        
        self.dropView = nil;
        [self.animationDrop addBehavior:self.attach];
    }
}


-(void) drop
{
    CGRect dropFrame ;
    dropFrame.size = DropSize;
    dropFrame.origin = CGPointZero;
    
    int x = (arc4random()%(int) self.animationView.bounds.size.width )/DropSize.width;
    
    dropFrame.origin.x = x * DropSize.width;
    UIView * dropView = [[UIView alloc] initWithFrame:dropFrame];
    dropView.backgroundColor = [self randomColor];
   
    [self.animationView addSubview: dropView];
     self.dropView = dropView;

    [self.dropBehavior addItem:dropView];
}

-(UIColor *) randomColor
{
    switch (arc4random() % 5) {
        case  1 : return [UIColor redColor];
        case  2 : return [UIColor grayColor];
        case  3 : return [UIColor greenColor];
        case  4 : return [UIColor blueColor];
        case  5 : return [UIColor orangeColor];
        }
    return [UIColor blackColor];
}
-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self dropToRemove];
}
-(void)dropToRemove
{
    NSMutableArray * dropsToRemove = [[NSMutableArray alloc] init];
    for (CGFloat y = self.animationView.bounds.size.height - DropSize.height/2; y>0; y -= DropSize.height) {
        NSMutableArray * drops = [[NSMutableArray alloc] init];
        BOOL compelet = YES;
        for (CGFloat x = DropSize.width / 2; x <= self.animationView.bounds.size.width - DropSize.width/2; x += DropSize.width) {
            UIView * hitView = [self.animationView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.animationView) {
                [drops addObject:hitView];
            }else
            {
                compelet = NO;
                break;
            }
            
        }
        if (!drops.count) {
            break;
        }
        if (compelet) {
            [dropsToRemove addObjectsFromArray:drops];
        }
    }
    if (dropsToRemove.count) {
        for (UIView * drop in dropsToRemove) {
            [self.dropBehavior removeItem:drop];
        }
        [self animationRemoveDrops:dropsToRemove];
    }
    
    
    
}
-(void) animationRemoveDrops:(NSArray*) drops
{
    [UIView animateWithDuration:1.0 animations:^{
        for (UIView * drop in drops) {
            int x = (arc4random() % (int )self.animationView.bounds.size.width * 5) - (int)self.animationView.bounds.size.width *2;
            int y = self.animationView.bounds.size.height ;
            drop.center = CGPointMake(x, -y);
        }
    } completion:^(BOOL finished) {
        [drops makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}
#pragma  -mark  setup
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self.animationView  addGestureRecognizer:tapGesture];
    UIPanGestureRecognizer   * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.animationView addGestureRecognizer:panGesture];
    
    self.animationDrop.delegate  = self;
}

@end
