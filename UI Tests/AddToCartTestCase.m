//
//  AddToCartTestCase.m
//  Ecommerce Mobile Application
//
//  Created by Adam Leftik on 10/2/14.
//  Copyright (c) 2014 Adam Leftik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIFTestCase.h>
#import <KIF/KIF.h>
//#import "KIFUITestActor+EXAdditions.h"

@interface AddToCartTestCase : KIFTestCase

@end

@implementation AddToCartTestCase
static const NSString *kTitles[] = { @"The Tourist", @"The Lost City Of Z", @"The Goldfinch: A Novel", @"The Godfather", @"Shantaram", @"Sacred Hoops", @"Personal", @"Freakonomics", @"Farewell To Arms",@"Driven From Within",@"A Clockwork Orange"};
static const int kRandomCrash = 45;
static const int CRASH_INTERVAL = 100;

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    [tester tapViewWithAccessibilityLabel:@"Refresh"];
    int maxBooks =arc4random() % sizeof kTitles/sizeof (kTitles[0]);
    int randomCrash =arc4random() % CRASH_INTERVAL;
    if (randomCrash!=kRandomCrash) {
    for (int i=0; i<maxBooks;i++) {
        [self addToCart:kTitles[arc4random()%maxBooks]];
    }
    } else {
        [self crashTheApp];
    }

    [tester waitForViewWithAccessibilityLabel:@"CheckoutButton"];
    [tester tapViewWithAccessibilityLabel:@"CheckoutButton"];
    [tester waitForViewWithAccessibilityLabel:@"OK"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester tapViewWithAccessibilityLabel:@"Refresh"];
}

- (void) addToCart:(NSString *) title {
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester waitForViewWithAccessibilityLabel:title];
    [tester tapViewWithAccessibilityLabel:title];
    [tester waitForViewWithAccessibilityLabel:@"Add To Cart"];
    [tester tapViewWithAccessibilityLabel:@"Add To Cart"];

}
-(void) crashTheApp {
    [tester tapViewWithAccessibilityLabel:@"Settings"];
    [tester tapViewWithAccessibilityLabel:@"CrashMe"];
}



@end
