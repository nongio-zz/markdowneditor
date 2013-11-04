//
//  NIODocument.m
//  MarkdownEditor
//
//  Created by Riccardo Canalicchio on 02/11/13.
//  Copyright (c) 2013 nong.io. All rights reserved.
//

#import "NIODocument.h"
#import <OCDiscount/OCDiscount.h>
#import <Foundation/Foundation.h>

@implementation NIODocument

- (id)init
{
    self = [super init];
    if (self) {
        md_string = @"";
        css_string = @"";
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"NIODocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [mdTextView setString:md_string];
    [cssTextView setString:css_string];
    [self updateFields];
}


+ (BOOL)autosavesInPlace
{
    return YES;
}
- (void)textDidChange:(NSNotification *)aNotification
{
    [self updateFields];
}
- (void) updateFields
{
    md_string = [mdTextView string];
    if(![md_string isEqual: @""]){
        
        NSString *html = [md_string htmlFromMarkdown];
        [htmlTextView setString:html];
        css_string = [cssTextView string];
        
        NSString * html_page = [NSString stringWithFormat:@"<html>\n<head>\n<style>\n%@\n</style>\n</head>\n<body>\n%@\n</body>\n</html>", css_string, html];
        

        [[webView mainFrame] loadHTMLString:html_page baseURL:[[NSBundle mainBundle] bundleURL]];
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName
               error:(NSError **)outError {
    BOOL readSuccess = YES;

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *dict = [unarchiver decodeObjectForKey:@"mde"];
    [unarchiver finishDecoding];
    
    md_string = [dict objectForKey:@"md"];
    css_string = [dict objectForKey:@"css"];
    
    if(mdTextView && cssTextView){
        [mdTextView setString:md_string];
        [cssTextView setString:css_string];
        [self updateFields];
    }

    return readSuccess;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSArray * values = [NSArray arrayWithObjects:md_string, css_string, nil];
    NSArray * keys = [NSArray arrayWithObjects:@"md", @"css", nil];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:@"mde"];
    [archiver finishEncoding];

    return data;
}

@end
