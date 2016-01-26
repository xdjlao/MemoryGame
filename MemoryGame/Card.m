//
//  Card.m
//  MemoryGame
//
//  Created by Jerry on 1/25/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "Card.h"
#import "ViewController.h"

@interface Card () <UIGestureRecognizerDelegate>

@property UITapGestureRecognizer *tgr;

@end

@implementation Card

-(instancetype)initWithSuit:(NSString *)suit withValue:(NSString *)value {
    self = [super init];
    
    if (self) {
        NSString *imageName = [NSString stringWithFormat:@"%@%@",value,suit];
        self.tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.userInteractionEnabled = YES;

        [self addGestureRecognizer:self.tgr];
        
        self.cardImage = [UIImage imageNamed:imageName];
        self.value = value;
        self.suit = suit;
        self.suitValue = [NSArray arrayWithObjects:value, suit, nil];
    }
    
    return self;
}

-(void)handleTap:(UITapGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate hideSubView:self];
        
    }
}

@end
