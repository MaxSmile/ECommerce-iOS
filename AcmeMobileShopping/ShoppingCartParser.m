//
//  ShoppingCartParser.m
//  AcmeMobileShopping
//
//  Created by Adam Leftik on 7/9/13.
//  Copyright (c) 2013 Adam Leftik. All rights reserved.
//

#import "ShoppingCartParser.h"
#import "ItemImageRequest.h"

@implementation ShoppingCartParser
    NSMutableData *cartData;
    NSMutableString *currentNodeContent;
    NSMutableString *currentElement;
    NSMutableString *key;
    NSXMLParser     *parser;
    NSEntityDescription *entity;


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.cartItems = [[NSMutableDictionary alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Doc Parsed");
    NSLog(@"Count of items %d", [self.cartItems count] );
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    currentElement = (NSMutableString *) [elementName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([elementName isEqualToString:@"cart-item"]) {

        entity = [NSEntityDescription insertNewObjectForEntityForName:@"CartItem" inManagedObjectContext:self.managedContext];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"cart-item"]) {
        [self.cartItems setObject:entity forKey:key];
    } else if ([elementName isEqualToString:@"title"]) {
        [entity setValue:[currentNodeContent copy] forKey:elementName];
    } else if ([elementName isEqualToString:@"itemId"]) {
        key = [currentNodeContent copy];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *itemId = [f numberFromString:key];
        [entity setValue:[itemId copy] forKey:elementName];
    } else if ([elementName isEqualToString:@"id"]) {
        key = [currentNodeContent copy];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        NSNumber *id = [f numberFromString:key];
        [entity setValue:[id copy] forKey:elementName];
    } else if ([elementName isEqualToString:@"imagePath"]) {
        [entity setValue:[currentNodeContent copy] forKey:elementName];
        [self getImage: currentNodeContent];
    }
    
}

-(void) getImage: (NSString *) imagePath {
    ItemImageRequest *request = [[ItemImageRequest alloc] initWithURLString:imagePath];
    //    request.imageData.
    [entity setValue:request.imageData forKey:@"imageData"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [cartData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [cartData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[cartData length]);
    parser = [[NSXMLParser alloc] initWithData:cartData ];
    parser.delegate = self;
    [parser parse];
}
@end
