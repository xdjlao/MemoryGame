//
//  Card.h
//  MemoryGame
//
//  Created by Jerry on 1/25/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CardDelegate <NSObject>

- (void) hideSubView:(id) card;

@end

@interface Card : UIImageView

@property UIImage *cardImage;
@property NSArray *suitValue;
@property NSString *suit;
@property NSString *value;

@property (nonatomic, assign) id <CardDelegate> delegate;

-(instancetype)initWithSuit:(NSString *)suit withValue:(NSString *)value;

@end
