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
#import "UploadImageController.h"
@interface DBOperationsViewController ()
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) UIImage *selectedImage;
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

    self.selectedImage = nil;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    [self.imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self.imagePicker setDelegate:self];
    
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];

    
//    NSArray *keys = [NSArray arrayWithObjects:@"ServerName", nil];
//    NSArray *objects = [NSArray arrayWithObjects:@"server 3", nil];
//    NSDictionary *Upload = [NSDictionary dictionaryWithObjects:objects
//                                                           forKeys:keys];
//    
//    [Model insertObjectWithTable:@"Servers" values:Upload completion:^(BOOL responseBool, NSError *responseError, NSString *object) {
//    
//        if (responseError == nil) {
//            
//    
//    
//            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"SUCCESS"
//                                                                           message:@"file added"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            [alert addAction:defaultAction];
//            [self presentViewController:alert animated:YES completion:nil];
//            
//        }
//        
//    }];
    

}

- (IBAction)FileDownload:(id)sender {
    
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.selectedImage = image;
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"uploadImage" sender:self];
        
    }];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"uploadImage"])
    {
        UploadImageController *uploadController = segue.destinationViewController;
        uploadController.imageToBeUploaded = self.selectedImage;
    }
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
