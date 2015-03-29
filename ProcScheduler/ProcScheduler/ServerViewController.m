//
//  ServerViewController.m
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "ServerViewController.h"
#import "Model.h"
#import "DBOperationsViewController.h"


@interface ServerViewController ()

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.availableServersArr = [[NSMutableArray alloc]init];
    [Model getDataFrom:@"Servers" orderBy:@"ServerName" completion:^(NSArray *responseArray, NSError *responseError, NSString *object) {
        if(responseError == nil)
        {
            for(PFObject *serverObj in responseArray )
            {
                [self.availableServersArr addObject:[serverObj objectForKey:@"ServerName"]];
            }
            [self.serverTableView reloadData];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.availableServersArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"serverCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.availableServersArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedServer = self.availableServersArr[indexPath.row];
    [self performSegueWithIdentifier:@"showDBOperations" sender:self];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
if([segue.identifier isEqualToString:@"showDBOperations"])
{
    DBOperationsViewController *dbOperationsVC = segue.destinationViewController;
    dbOperationsVC.selectedServer = self.selectedServer;
}
 }
 

@end
