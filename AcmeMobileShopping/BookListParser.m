//
//  BookListParser.m
//  AcmeBookStore
//
//  Created by Adam Leftik on 6/16/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "BookListParser.h"
#import <ADEUMInstrumentation/ADEUMInstrumentation.h>
#import <Foundation/Foundation.h>
#import "BookListParser.h"
#import "Product.h"
#import "ItemImageRequest.h"
#import "AppDelegate.h"


@implementation BookListParser
    NSMutableData *bookData;
    NSMutableString *currentNodeContent;
    NSMutableString *currentElement;
    NSMutableString *key;
    NSXMLParser     *parser;
    NSEntityDescription *entity;


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [ADEumInstrumentation startTimerWithName:@"BookListParsing"];
    self.bookList = [[NSMutableDictionary alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self saveContext];
    NSLog(@"Doc Parsed");
    NSLog(@"Count of books %d", [self.bookList count] );
    [ADEumInstrumentation stopTimerWithName:@"BookListParsing"];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    currentElement = (NSMutableString *) [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([elementName isEqualToString:@"product"]) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:self.managedContext];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
        if ([elementName isEqualToString:@"product"]) {
            [self.bookList setObject:entity forKey:key];
        } else if ([elementName isEqualToString:@"title"]) {
            [entity setValue:[currentNodeContent copy] forKey:elementName];

        } else if ([elementName isEqualToString:@"id"]) {
            key = [currentNodeContent copy];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterNoStyle];
            NSNumber *id = [f numberFromString:key];
            [entity setValue:[id copy] forKey:elementName];
        } else if ([elementName isEqualToString:@"imagePath"]) {
            [entity setValue:[currentNodeContent copy] forKey:elementName];
            [self getImage: currentNodeContent];
        } else if ([elementName isEqualToString:@"price"]) {
            NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:currentNodeContent];
            [entity setValue:[price copy] forKey:elementName];
        }
    
}

-(void) getImage: (NSString *) imagePath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *imageurl = [appDelegate.url stringByAppendingString:imagePath];
    ItemImageRequest *request = [[ItemImageRequest alloc] initWithURLString:imageurl];

    [entity setValue:request.imageData forKey:@"imageData"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [bookData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [bookData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[bookData length]);
    parser = [[NSXMLParser alloc] initWithData:bookData ];
    parser.delegate = self;
    [parser parse];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
@end
