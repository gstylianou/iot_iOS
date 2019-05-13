//
//  IOTCommunication.h
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOTCommunication : NSObject


+(NSArray*)getTVRemoteInstructions:(NSString*)myID;
+(void)sendIRInstruction:(NSString*)command forID:(NSString*)myID;
+(NSData*)getCameraFrameForID:(NSString*)myID;
@end
