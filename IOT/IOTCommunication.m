//
//  IOTCommunication.m
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import "IOTCommunication.h"

@implementation IOTCommunication


+(NSArray*)getTVRemoteInstructions:(NSString*)myID
{
    NSError*error;
    NSArray*ans;
    NSString*instruction=[NSString stringWithFormat:@"https://meci.euc.ac.cy/IOT/getIRCommands.php?ID=%@",myID];
    NSURL*url=[NSURL URLWithString:instruction];
    NSData*instructions=[NSData dataWithContentsOfURL:url];

    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:instructions options:kNilOptions error :&error];
    ans=[[NSArray alloc]initWithArray:[json objectForKey:@"parameters"]];
         
    NSLog(json.description);
    
    return ans;
    
}

+(void)sendIRInstruction:(NSString*)command forID:(NSString*)myID
{
    NSString*instruction=[NSString stringWithFormat:@"https://meci.euc.ac.cy/IOT/remote.php?ID=%@&command=%@",myID,command];
    
    NSURL*url=[NSURL URLWithString:instruction];

    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData *data, NSURLResponse *response,
                                                                 NSError *error) {
                                                 
                                                 NSLog(@"works");
                                                 
                                             }];

    [dataTask resume];
    
}

+(NSData*)getCameraFrameForID:(NSString*)myID
{
    NSError*error;
    NSArray*ans;
    NSString*instruction=[NSString stringWithFormat:@"https://meci.euc.ac.cy/IOT/camera.php?ID=%@",myID];
    NSURL*url=[NSURL URLWithString:instruction];
    NSData*frame=[NSData dataWithContentsOfURL:url];
 
    return frame;
    
    
}

@end
