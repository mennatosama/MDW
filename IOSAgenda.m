//
//  IOSAgenda.m
//  DBProject
//
//  Created by Mahmoud El nagar on 4/9/16.
//  Copyright (c) 2016 JETS. All rights reserved.
//

#import "IOSAgenda.h"
#import "Sessions.h"
#import "Speaker.h"
#import "MobilesOfSpeakers.h"
#import "PhonesOfSpeakers.h"
#import "CoreDataManager.h"
#import "IOSSessionDetailsView.h"
#import "Agenda.h"
#import "NetworkClass.h"
#import "NetworkManger.h"
#import "Reachability.h"

@interface IOSAgenda ()

@end

@implementation IOSAgenda{
    int i ;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dataRecived:(NSMutableArray *) data{
    if (data != nil) {
        _result = [NSMutableArray new];
    }
    for (int b = 0; b <[data count]; b++) {
//        printf("object from  %d count %d\n",b,[[[data[b] agendaSessions] allObjects] count]);
        [_result addObjectsFromArray:[[data[b] agendaSessions] allObjects]];
    }
    
    if (_result != nil) {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        printf("\nNotReachable\n");
        CoreDataManager *core = [CoreDataManager new];
        NSMutableArray *agendas = [core fetchEntitiesWithClassName:@"Agenda" sortDescriptors:nil predicate:nil];
        _result = [NSMutableArray new];
        
        for (int b = 0; b <[agendas count]; b++) {
            [_result addObjectsFromArray:[[agendas[b] agendaSessions] allObjects]];
        }
    } else {
        printf("\nConnected\n");
        NetworkManger *manager = [NetworkManger new];
        NetworkClass *c = [manager getNetworkInstance];
        [c setMyDelegate:self];
        [c getSessions];
    }
    
    i = 0;
    _icons = [NSMutableArray new];
    
    [_icons addObject:[UIImage imageNamed:@"first.png"]];
    [_icons addObject:[UIImage imageNamed:@"second.png"]];
    [_icons addObject:[UIImage imageNamed:@"third.png"]];
    
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidAppear:(BOOL)animated{
    
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]]];
    [self.tabBarController.tabBar setBackgroundColor:[UIColor redColor]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"agendaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Sessions *s = (Sessions*)[_result objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Cairo"]];
    
    NSDate *d1 = s.startDate;
    NSString *str1 = [formatter stringFromDate:d1];
    
    
    NSDate *d2 = s.endDate;
    NSString *str2 = [formatter stringFromDate:d2];
    
    NSMutableString *date = [[NSMutableString alloc]initWithFormat:@"%@ - %@",str1,str2];
    

    
    [(UILabel*)[cell viewWithTag:1] setText:s.name];
    UILabel * l = (UILabel*)[cell viewWithTag:2];
    l.font = [UIFont fontWithName:@"Arial" size:14.0f];
    [l setText:s.location];
    [(UILabel*)[cell viewWithTag:3] setText:date];
    
    cell.imageView.image = _icons[i];
    if (i==2) {
        i=0;
    }else{
        i++;
    }
    return cell;
}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSegueWithIdentifier:@"move" sender:indexPath];
//}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(50, 0, tableView.frame.size.width, 100.0)];
    head.backgroundColor = [UIColor orangeColor];
    head.bounds  =CGRectMake(50, 50, 50, 50);
    
    
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, tableView.frame.size.width, 25.0)];
//    lab.backgroundColor = [UIColor clearColor];
//    lab.font = [UIFont fontWithName:@"Verdana" size:20.0];
//    lab.textAlignment = NSTextAlignmentCenter;
//    lab.text = @"MDW Agenda";
//    [head addSubview:lab];
    
    return head;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"move"]) {
        IOSSessionDetailsView *details =  [segue destinationViewController];
        NSIndexPath *index = [self.tableView indexPathForCell:sender];
        details.session = [_result objectAtIndex:index.row];
    }
    
}



@end
