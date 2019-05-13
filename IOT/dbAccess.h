//
//  dbAccess.h
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"sqlite3.h"

@interface dbAccess : NSObject

@property(nonatomic)sqlite3* database;
@property(nonatomic,retain) NSString*dbPath;

-(void)deleteCommands;
-(id)init;
-(NSMutableArray*)getFavouriteCommands;
-(void)insertFavouriteCommand:(NSString*)command;
@end
