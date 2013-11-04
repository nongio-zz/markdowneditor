//
//  NIODocument.h
//  MarkdownEditor
//
//  Created by Riccardo Canalicchio on 02/11/13.
//  Copyright (c) 2013 nong.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
@interface NIODocument : NSDocument
{

    IBOutlet NSTextView * mdTextView;
    IBOutlet NSTextView * htmlTextView;
    IBOutlet NSTextView * cssTextView;
    IBOutlet WebView * webView;
    NSString * md_string;
    NSString * css_string;
}


@end
