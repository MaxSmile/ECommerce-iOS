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
#import "AcmeConfiguration.h"
//#import "KIFUITestActor+EXAdditions.h"

@interface AddToCartTestCase : KIFTestCase

@end

@implementation AddToCartTestCase
static const NSString *kTitles[] = { @"The Tourist", @"The Lost City Of Z", @"The Goldfinch: A Novel", @"The Godfather", @"Shantaram", @"Sacred Hoops", @"Personal", @"Freakonomics", @"Farewell To Arms",@"Driven From Within",@"A Clockwork Orange"};
static const int kRandomCrash = 2;
static const int CRASH_INTERVAL = -1;
NSMutableDictionary *map = nil;

- (void)setUp {
    [super setUp];
    [KIFUITestActor setDefaultTimeout:10];
    map = [NSMutableDictionary dictionary];
    AcmeConfiguration *pmDemo =[[AcmeConfiguration alloc] init];
    
    pmDemo.eumKey = @"pm-cloud-AAB-AUN";
    pmDemo.acmeUrl = @"http://ec2-54-90-14-200.compute-1.amazonaws.com/appdynamicspilot/";
    pmDemo.collectorUrl = @"http://ec2-54-202-222-83.us-west-2.compute.amazonaws.com";
    pmDemo.username = @"test";
    pmDemo.password = @"appdynamics";
    [map setValue:pmDemo forKey:@"pm-demo"];
    
    AcmeConfiguration *pm2 =[[AcmeConfiguration alloc] init];
    pm2.eumKey = @"pm-cloud-AAB-AUM";
    pm2.acmeUrl = @"http://ec2-54-167-95-227.compute-1.amazonaws.com/appdynamicspilot/";
    pm2.collectorUrl = @"http://ec2-54-202-222-83.us-west-2.compute.amazonaws.com";
    pm2.username = @"test";
    pm2.password = @"appdynamics";
    [map setValue:pm2 forKey:@"pm2"];
}

- (void)tearDown {
    [super tearDown];
}


- (void)testExample {
//    [tester tapViewWithAccessibilityLabel:@"OK"];
    NSEnumerator *enumerator = [map keyEnumerator];
    
    id key;
    while((key = [enumerator nextObject])) {
    AcmeConfiguration *config  = [map objectForKey:key];
        [tester tapViewWithAccessibilityLabel:@"Settings"];

    [tester clearTextFromAndThenEnterText:config.acmeUrl intoViewWithAccessibilityLabel:@"BookstoreUrl"];
        [tester clearTextFromAndThenEnterText:config.collectorUrl intoViewWithAccessibilityLabel:@"CollectorUrl"];
    [tester clearTextFromAndThenEnterText:config.username intoViewWithAccessibilityLabel:@"Username"];
    [tester clearTextFromAndThenEnterText:config.password intoViewWithAccessibilityLabel:@"Password"];
    [tester clearTextFromAndThenEnterText:config.eumKey intoViewWithAccessibilityLabel:@"Appkey"];
    [tester tapViewWithAccessibilityLabel:@"return"];
    [tester tapViewWithAccessibilityLabel:@"Save"];
    [tester tapViewWithAccessibilityLabel:@"OK"];
        
    
    unsigned int i = 0;
    unsigned int count = 10 ;
    
    for (i=0; i < count; i++) {
        [tester tapViewWithAccessibilityLabel:@"Best Sellers"];

        [tester tapViewWithAccessibilityLabel:@"Refresh"];
        [NSThread sleepForTimeInterval:1.0f];
        int maxBooks =arc4random() % sizeof kTitles/sizeof (kTitles[0]);
        int randomCrash =arc4random() % CRASH_INTERVAL;
        
        if (randomCrash!=kRandomCrash) {
                for (int i=1; i<maxBooks;i++) {
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
    }
}

- (void) addToCart:(NSString *) title {
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    [tester tapViewWithAccessibilityLabel:@"Best Sellers"];
    NSLog(@"Title is %@", title);
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
