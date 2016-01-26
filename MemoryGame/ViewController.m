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
@property NSMutableArray *checkArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.checkArray = [NSMutableArray new];
    
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
    
    NSMutableArray *addCardArray = [NSMutableArray new];
    for (Card *card in self.randCardArray) {
        Card *newCard = [[Card alloc] initWithSuit:card.suit withValue:card.value];
        newCard.delegate = self;
        [addCardArray addObject:newCard];
    }
    [self.randCardArray addObjectsFromArray:addCardArray];
    
    [self shuffleCards];
    
    int heightY = 0;
    int widthX = 0;
    
    for (int i = 0; i < self.randCardArray.count; i++) {
        Card *card = [self.randCardArray objectAtIndex:i];
        
        card.image = card.cardImage;
        UIImage *cardBackImage = [UIImage imageNamed:@"cardBack"];
        UIImageView *cardBackView = [[UIImageView alloc] initWithImage: cardBackImage];
        
        int width = (self.view.frame.size.width/scale);
        int height = width * 1.452;
        
        int posX = width * widthX;
        int posY = height * heightY;
        card.frame = CGRectMake(posX, posY, width, height);
        cardBackView.frame = CGRectMake(0, 0, width, height);
        
        [card addSubview:cardBackView];
        [[self.view viewWithTag:1] addSubview:card];
        
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
- (IBAction)onRestartButtonPressed:(UIButton *)sender {
//    [self shuffleCards];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideSubView:(Card *)card {
    if (card.subviews[0] != nil) {
        if (self.checkArray.count < 2) {
            [self.checkArray addObject:card];
            // [card.subviews[0] removeFromSuperview];
            card.subviews[0].hidden = YES;
            
            if (self.checkArray.count == 2) {
                [self matchCards:self.checkArray];
            }
        }
    }
    
}

- (void)matchCards:(NSMutableArray *)matchedCards {
    Card *firstCard = matchedCards[0];
    Card *secondCard = matchedCards[1];
    if (![firstCard.suitValue isEqual:secondCard.suitValue]) {
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showCards) userInfo:nil repeats:NO];
    } else {
        [self.checkArray removeAllObjects];
    }
}

- (void)showCards {
    Card *firstCard = self.checkArray[0];
    Card *secondCard = self.checkArray[1];
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardBack"];
    UIImageView *firstCardBackView = [[UIImageView alloc] initWithImage: cardBackImage];
    UIImageView *secondCardBackView = [[UIImageView alloc] initWithImage: cardBackImage];
    
    firstCardBackView.frame = CGRectMake(0, 0, firstCard.frame.size.width, firstCard.frame.size.height);
    secondCardBackView.frame = CGRectMake(0, 0, secondCard.frame.size.width, secondCard.frame.size.height);
    
    firstCard.subviews[0].hidden = NO;
    
    secondCard.subviews[0].hidden = NO;
    [self.checkArray removeAllObjects];
}

- (void)shuffleCards {
    NSUInteger randCount = self.randCardArray.count;
    for (NSUInteger i = 0; i < randCount - 1; ++i) {
        NSInteger remainingCount = randCount - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self.randCardArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
