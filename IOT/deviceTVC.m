//
//  deviceTVC.m
//  IOT
//
//  Created by Georgios Stylianou on 31/07/2017.
//  Copyright © 2017 Georgios Stylianou. All rights reserved.
//

#import "deviceTVC.h"
#import"IOTCommunication.h"
#import"AppDelegate.h"
#import"cameraCell.h"

@interface deviceTVC ()

@end

@implementation deviceTVC
@synthesize type,q,saveBtnOut,refresh;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    type=CAMERA;
    
    
    AppDelegate*appD=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.q=appD.q;
    
    

}


-(void)viewWillDisappear:(BOOL)animated {
    
    if(type==CAMERA)
       refresh=false;
}

-(void)viewWillAppear:(BOOL)animated {
    
    if(type==CAMERA)
    {
        [self loadFrames];
        refresh=true;
    }
   if(type==TV)
    {
        showFavourites=true;
        AppDelegate*appD=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        data=(NSMutableArray*)[appD.q getFavouriteCommands];
        selectedData=[data copy];
        
        
        
    }
    
    switch(type)
    {
        case TV: [self.navigationController setToolbarHidden:FALSE animated:YES];
        break;
        case CAMERA: [self.navigationController setToolbarHidden:YES animated:YES];
        break;
        
    }
    
}

-(void)loadFrames
{
    
    
    __weak typeof(self) weakSelf=self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        __strong typeof(self) strongSelf=weakSelf;
        
        frame=[IOTCommunication getCameraFrameForID:@"JNqX4Rz6PW7n"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            [strongSelf.tableView reloadData];
            
            
            dispatch_time_t t=dispatch_time(DISPATCH_TIME_NOW,1000*NSEC_PER_MSEC);
            
            dispatch_queue_t myqueue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_after(t,myqueue,^(void){
               if(refresh)
                  [strongSelf loadFrames];
                
            
             });

            
        });
        
        
    });
    
}

-(void)loadInstructions
{
    __weak typeof(self) weakSelf=self;
    
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
      
      __strong typeof(self) strongSelf=weakSelf;
     
     if(data!=nil)
      [data removeAllObjects];
      
      data=(NSMutableArray*)[IOTCommunication getTVRemoteInstructions:@"JNqX4Rz6PW7n"];

    //load favourites from sqlite
     if(data.count>0)
      selectedData=[strongSelf.q getFavouriteCommands];
      
      dispatch_async(dispatch_get_main_queue(), ^(void){
          
          [strongSelf.tableView reloadData];
       
          //need to update the accessoryType
         // [strongSelf updateSelections];
          
          
      });
    
      
  });
    
}

-(void)updateSelections {
    
if(selectedData.count==0)
    return;
    
for(NSString*obj in selectedData)
    {
        
    NSUInteger index=[data indexOfObjectIdenticalTo:obj];
        
     if(index!=NSNotFound)
        {  NSIndexPath*indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
      }
    }
    
    
}

- (IBAction)showAllInstructionsBtn:(id)sender {
    
    UIBarButtonItem*btn=(UIBarButtonItem*)sender;
    
   if(showFavourites)
    {  showFavourites=false;
       btn.title=@"Favourite Instructions";
       [self loadInstructions];
    }
   else
    {
        showFavourites=true;
        
        AppDelegate*appD=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        data=(NSMutableArray*)[appD.q getFavouriteCommands];
        [self.tableView reloadData];
        
        btn.title=@"All Instructions";
        
    }
    
    
}

- (IBAction)saveBtn:(id)sender {
    
    
  if(type==TV)
    {
    
    NSEnumerator*enu=[selectedData objectEnumerator];
    
    id value;
    
    [self.q deleteCommands]; //need to empty favourites in sqlite
    
    //and save the new favourites
    while(value=[enu nextObject])
    {
        
        NSLog((NSString*)value);
        [self.q insertFavouriteCommand:(NSString*)value];
        
    }
    
    }
    
  
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch(type){
    case TV:
                return data.count;
    case CAMERA: return 1;
    };
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    UITableViewCell *cell;
    cameraCell*camCell;
    
    switch(type){
        case TV:cell= [tableView dequeueReusableCellWithIdentifier:@"tvCell" forIndexPath:indexPath];
                      cell.textLabel.text=data[indexPath.row];
                      cell.accessoryType=UITableViewCellAccessoryNone;
        
                       if(!showFavourites)
                       {
                           
                           
                           if([selectedData containsObject:data[indexPath.row]])
                               cell.accessoryType=UITableViewCellAccessoryCheckmark;
                           
                        }
                break;
        
        case CAMERA: camCell= [tableView dequeueReusableCellWithIdentifier:@"cameraCell" forIndexPath:indexPath];
                     camCell.cameraFrame.image=[UIImage imageWithData:frame];
                     return camCell;
        break;
    };
    
    
    
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch(showFavourites) {
        case true:  [self invokeCommand:tableView forIndexPath:indexPath];
                    break;
        case false: [self updateInstructionSelection:tableView forIndexPath:indexPath];
                    if(!saveBtnOut.enabled)
                          saveBtnOut.enabled=true;
                    break;
        
    }
    
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(type==CAMERA)
        return 280;
    
    
    return 44;
    
    
}

-(void)invokeCommand:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath {
    
  NSString*command=data[indexPath.row];
    
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
     [IOTCommunication sendIRInstruction:command forID:@"JNqX4Rz6PW7n"];
     
     
 });
}



-(void)updateInstructionSelection:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath{
    
    UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType==UITableViewCellAccessoryCheckmark)
    {  [selectedData removeObject:data[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    else
    { [selectedData addObject:data[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
   
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
  if(type==TV)
    switch (showFavourites)
    {
        case true:
        sectionName = @"Favourite Commands. Tap to Execute";
        break;
        case false:
        sectionName = @"All Commands. Tap to add to Favourites";
        break;
        
    }
   
    if(type==CAMERA)
       sectionName = @"Camera Feed";
    
    return sectionName;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    UILabel *myLabel = [[UILabel alloc] init];
//    myLabel.frame = CGRectMake(20, 8, 320, 20);
//    myLabel.font = [UIFont boldSystemFontOfSize:14];
//    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    UIView *headerView = [[UIView alloc] init];
//    [headerView addSubview:myLabel];
//
    
 UITableViewCell*cell= [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
 cell.textLabel.text=[self tableView:tableView titleForHeaderInSection:section];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
