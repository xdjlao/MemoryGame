//
//  ViewController.m
//  MemoryGame
//
//  Created by Jerry on 1/25/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import "ViewController.h"
#import "Card.h"

@interface ViewController () <CardDelegate>

@property NSMutableArray *cardArray;
@property NSMutableArray *randCardArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"firstLaunch"]) {
        [userDefaults setBool:YES forKey:@"firstLaunch"];
        [self.view subviews][0].hidden = NO;
    }
    
    self.cardArray = [NSMutableArray new];
    
    // 0 Suit = Hearts
    // 1 Suit = Spades
    // 2 Suit = Diamonds
    // 3 Suit = Clubs
    for (int i = 0; i < 4; i++) {
        for (int count = 0; count < 13; count++) {
            Card *newCard = [[Card alloc] initWithSuit:[NSString stringWithFormat:@"%i",i] withValue:[NSString stringWithFormat:@"%i", count]];
            newCard.delegate = self;
            [self.cardArray addObject:newCard];
        }
    }

    [self generateBoardWithSize:self.numberOfRows];
    
    
}

- (void)generateBoardWithSize:(int)scale {
    if (scale > 10) {
        scale = 10;
    } else if (scale < 2) {
        scale = 2;
    } else if (scale % 2 != 0) {
        scale += 1;
    }
    
    self.randCardArray = [NSMutableArray new];
    
    int count = (scale * scale) / 2;
    for (int i = 0; i < count; i++) {
        
        int random = arc4random_uniform(52);
        
        while ([self.randCardArray containsObject:[self.cardArray objectAtIndex:random]]) {
            random = arc4random_uniform(52);
        }
        
        [self.randCardArray addObject:[self.cardArray objectAtIndex:random]];
        
    }

    [self.randCardArray addObjectsFromArray:self.randCardArray];
    
    NSUInteger randCount = self.randCardArray.count;
    if (randCount < 1) return;
    for (NSUInteger i = 0; i < randCount - 1; ++i) {
        NSInteger remainingCount = randCount - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.randCardArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    int heightY = 0;
    int widthX = 0;
    
    for (int i = 0; i < self.randCardArray.count; i++) {
        Card *card = [self.randCardArray objectAtIndex:i];
        UIImageView *cardView = [[UIImageView alloc] initWithImage:card.cardImage];
        
        UIImage *cardBackImage = [UIImage imageNamed:@"cardBack"];
        UIImageView *cardBackView = [[UIImageView alloc] initWithImage: cardBackImage];
        
        
        
        int width = (self.view.frame.size.width/scale);
        int height = width * 1.452;
        
        int posX = width * widthX;
        int posY = height * heightY;
        cardView.frame = CGRectMake(posX, posY, width, height);
        cardBackView.frame = CGRectMake(0, 0, width, height);
        
//        [cardView addSubview:cardBackView];
        [self.view addSubview:cardView];
        
        widthX++;
        
        if ((i+1) % scale == 0) {
            heightY++;
            widthX = 0;
        }
    }
}

- (IBAction)onButtonDismissedTapped:(UIButton *)sender {
    [self.view subviews][0].hidden = YES;
}


- (void)hideSubView:(Card *)card {
    NSLog(@"htapped");
}

    @end
