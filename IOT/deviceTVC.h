//
//  deviceTVC.h
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"dbAccess.h"
#define TV 1
#define CAMERA 2

@interface deviceTVC : UITableViewController
{
    NSMutableArray*data;
    NSMutableArray*selectedData;
    bool showFavourites;
    NSData*frame;
    
    
}
@property(atomic)bool refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtnOut;

@property(nonatomic) int type; //TV=1, Camera=2
@property(nonatomic)dbAccess*q;;
-(void)loadInstructions;
- (IBAction)saveBtn:(id)sender;
-(void)updateSelections;
- (IBAction)showAllInstructionsBtn:(id)sender;
-(void)updateInstructionSelection:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath;
-(void)invokeCommand:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath;
-(void)loadFrames;

@end
