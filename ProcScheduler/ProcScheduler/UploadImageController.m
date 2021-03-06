//
//  UploadImageController.m
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "UploadImageController.h"
#import "Model.h"
@interface UploadImageController ()
@property (weak, nonatomic) IBOutlet UIImageView *uploadView;
@property (nonatomic,strong) UIAlertAction *okAction;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UIAlertController *alertController;
@end

@implementation UploadImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.navigationController setNavigationBarHidden:YES];
    [self.uploadView setContentMode:UIViewContentModeScaleAspectFit];
    [self.uploadView setImage:self.imageToBeUploaded];
    
    if([self.action length] > 0){
        
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:self.action
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(UploadClicked:)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)UploadClicked:(id)sender {
    UIBarButtonItem *btn = (UIBarButtonItem *)sender;
    
    if([btn.title isEqualToString:@"Upload"]){
        _alertController = [UIAlertController alertControllerWithTitle:nil message:@"Enter File Name" preferredStyle:UIAlertControllerStyleAlert];
        
        __weak UploadImageController *controller = self;
        [_alertController addTextFieldWithConfigurationHandler:^(UITextField *fileTitle){
            
            fileTitle.placeholder = @"File Name";
            [fileTitle setDelegate:controller];
        }];
        
        _okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSString *name = ((UITextField *)_alertController.textFields[0]).text;
            
            [self storeFileAtTempDirectoryWithName:name];
            
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"FileName",[[DataController sharedController] selectedServer],@"Server", nil];
            
            [self fireLocalNotificationWithTime:[DataController sharedController].scheduledDate  andMessage:@"FILE_UPLOAD" andUserInfo:userInfoDict];
            //            [self uploadFileWithName:name toServer:[[DataController sharedController] selectedServer]];
        }];
        [_okAction setEnabled:NO];
        [_alertController addAction:_okAction];
        
        [self presentViewController:_alertController animated:YES completion:nil];
    }
    else if([btn.title isEqualToString:@"Download"]){
        
        
        [self storeFileAtTempDirectoryWithName:_fileName];
        
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:_fileName,@"FileName",[[DataController sharedController] selectedServer],@"Server", nil];
        
        [self fireLocalNotificationWithTime:[DataController sharedController].scheduledDate  andMessage:@"FILE_DOWNLOAD" andUserInfo:userInfoDict];
        
    }
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Server" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [Model getDataFrom:@"Servers" orderBy:@"ServerName" completion:^(NSArray *responseArray, NSError *responseError, NSString *object) {
            
            
            if(responseError == nil)
            {
                for(PFObject *serverObj in responseArray )
                {
                    if(![[serverObj objectForKey:@"ServerName"] isEqualToString:[[DataController sharedController] selectedServer]]){
                        UIAlertAction *action = [UIAlertAction actionWithTitle:[serverObj objectForKey:@"ServerName"]  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            [self transferFileToServer:action.title];
                        }];
                        [alertController addAction:action];
                    }
                }
            }
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            }];
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }];
    }
}



-(void)transferFileToServer:(NSString *)toServer{
    
    [self uploadFileWithName:_fileName toServer:toServer];
    
}
-(void)uploadFileWithName:(NSString *)fileName toServer:(NSString *)serverName{
    dispatch_queue_t bgQueue = dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    dispatch_async(bgQueue, ^{
        
        [_activityIndicator startAnimating];
        [NSThread sleepForTimeInterval:0.1];
        
        PFFile *imageFile = [Model createPFFileFromData:UIImageJPEGRepresentation([self getFileAtTempDirectoryWithName:fileName], 0.8) withName:[NSString stringWithFormat:@"%@.jpg",fileName]];
        [imageFile save];
        
        PFObject *imageObj = [PFObject objectWithClassName:serverName];
        [imageObj setObject:imageFile forKey:@"File"];
        [imageObj setObject:fileName forKey:@"FileName"];
        [imageObj save];
        [_activityIndicator stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"File Upload" message:[NSString stringWithFormat:@"%@ uploaded successfully",fileName] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            [self deleteFileAtTempDirectoryWithName:fileName];
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *name = [[textField.text stringByAppendingString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([name length] > 0){
        [_okAction setEnabled:YES];
    }
    else{
        [_okAction setEnabled:NO];
    }
    
    
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)fileDownload:(NSDictionary *)userInfo
{
    
    if([[DataController sharedController] fileExistAtDocumentPath:[userInfo objectForKey:@"FileName"]]){
        
        [[[UIAlertView alloc] initWithTitle:@"Download File" message:@"File already downloaded" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else{
        //[UIImageJPEGRepresentation(_imageToBeUploaded, 0.8) writeToFile:[[DataController sharedController] filePathWithName:_fileName] atomically:YES];
        
        [self moveFileFromTempToDirectoryWithName:[userInfo objectForKey:@"FileName"]];
        
        [[[UIAlertView alloc] initWithTitle:@"Download File" message:@"File downloaded successfully" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

-(void)fileUpload:(NSDictionary *)userInfo
{
    [self uploadFileWithName:[userInfo objectForKey:@"FileName"] toServer:[userInfo objectForKey:@"Server"]];
}

-(void)fireLocalNotificationWithTime:(NSDate *)fireDate andMessage:(NSString *)alertBody andUserInfo:(NSDictionary *)userInfo
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = alertBody;
    localNotification.alertTitle = alertBody;
    localNotification.userInfo = userInfo;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)moveFileFromTempToDirectoryWithName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *tempPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@",fileName]];
    
    [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:docDir error:nil];
    
}


-(void)storeFileAtTempDirectoryWithName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@",fileName]];
    
    [[NSFileManager defaultManager]createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    
    [UIImageJPEGRepresentation(_imageToBeUploaded, 0.8) writeToFile:storePath atomically:YES];
}

-(UIImage *)getFileAtTempDirectoryWithName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@",fileName]];
    
    return [UIImage imageWithContentsOfFile:storePath];
    
}

-(void )deleteFileAtTempDirectoryWithName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@",fileName]];
    
    [[NSFileManager defaultManager]removeItemAtPath:storePath error:nil];
    
    
}
@end
