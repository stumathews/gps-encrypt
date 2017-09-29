//
//  Message.h
//  IdeaExplorer
//
//  Created by Stuart Mathews on 02/07/2010.
//  Copyright 2010 Stuart Mathews Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Message : NSObject {

	NSString* from;
	NSString* message;
	NSString* other;
}
@property(nonatomic,copy) NSString* from;
@property(nonatomic,copy) NSString* message;
@property(nonatomic, copy) NSString* other;

- (id)initWithMessage:(NSString*) theMessage from:(NSString*) fromSomeone;

@end


//Test
