//
//  dbAccess.m
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import "dbAccess.h"

@implementation dbAccess
@synthesize dbPath,database;

-(id)init
{
    if(self=[super init])
    {
        
        NSArray*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString*documentsDirectory = [paths objectAtIndex:0];
        dbPath=[documentsDirectory stringByAppendingPathComponent:@"iot.sqlite"];
        
        sqlite3_open ([dbPath cStringUsingEncoding:NSUTF8StringEncoding],&database);
    }
    
    return  self;
}


-(void)deleteCommands
{
    int returnCode;
    
    
    
    
    char *st,*errorMsg;
    
    
    st = sqlite3_mprintf ("delete from tvFavouriteCommands");
    
    returnCode = sqlite3_exec (database,st,NULL,NULL,&errorMsg);
    
    
    sqlite3_free (st); // free the string
    
    
    
}

-(void)insertFavouriteCommand:(NSString*)command
{
    int returnCode;
    char *st,*errorMsg;
    
    
    st = sqlite3_mprintf ("insert into tvFavouriteCommands (command) values ('%s')",[command cStringUsingEncoding:NSUTF8StringEncoding]);
    
    returnCode = sqlite3_exec (database,st,NULL,NULL,&errorMsg);
    
    
    sqlite3_free (st); // free the string
    
    
    
}


-(NSMutableArray*)getFavouriteCommands
{
    NSMutableArray*ans=[[NSMutableArray alloc]init];
    int returnCode;
    
    
    
    sqlite3_stmt * statement;
    char *st;
    
    st = sqlite3_mprintf("select command from tvFavouriteCommands order by command asc");
    //    st = sqlite3_mprintf("select latitude,longitude,timestamp from location order by locationID");
    
    
    sqlite3_prepare_v2(database,st,strlen(st),&statement,NULL);
    returnCode = sqlite3_step(statement); // this statement returns a record
    
    while ( returnCode == SQLITE_ROW ) // while there are rows
    {
        
        NSString*comm=[NSString stringWithCString:(char*)sqlite3_column_text(statement,0) encoding:NSUTF8StringEncoding];
        
        [ans addObject:comm];
        returnCode = sqlite3_step(statement); // this statement returns a record
    }
    
    sqlite3_finalize ( statement ); // finish statement
    sqlite3_free (st); // free the string
    
    
    
    return ans;
    
    
    
}

@end
