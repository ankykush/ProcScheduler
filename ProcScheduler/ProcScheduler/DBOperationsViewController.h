//
//  DBOperationsViewController.h
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBOperationsViewController : UIViewController<UIImagePickerControllerDelegate>
@property(nonatomic,strong) NSString *selectedServer;
@property (weak, nonatomic) IBOutlet UILabel *selectedServerLbl;
- (IBAction)FileUpload:(id)sender;
- (IBAction)FileDownload:(id)sender;

@end
