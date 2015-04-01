//
//  DBOperationsViewController.m
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "DBOperationsViewController.h"
#import "Model.h"
#import "ServerViewController.h"

@interface DBOperationsViewController ()

@end

@implementation DBOperationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedServerLbl.text = self.selectedServer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FileUpload:(id)sender{


    
    

    
    NSArray *keys = [NSArray arrayWithObjects:@"ServerName", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"server 3", nil];
    NSDictionary *Upload = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    [Model insertObjectWithTable:@"Servers" values:Upload completion:^(BOOL responseBool, NSError *responseError, NSString *object) {
    
        if (responseError == nil) {
            
    
    
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SUCCESS"
                                                                           message:@"file added"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];
    
    
   
    


}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
