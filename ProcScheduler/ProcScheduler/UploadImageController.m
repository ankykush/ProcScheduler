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
    
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(UploadClicked:)];
    [uploadButton setTitle:@"Upload"];
    self.navigationItem.rightBarButtonItem = uploadButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)UploadClicked:(id)sender {
    _alertController = [UIAlertController alertControllerWithTitle:nil message:@"Enter File Name" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UploadImageController *controller = self;
    [_alertController addTextFieldWithConfigurationHandler:^(UITextField *fileTitle){
       
        fileTitle.placeholder = @"File Name";
        [fileTitle setDelegate:controller];
    }];
    
    _okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSString *name = ((UITextField *)_alertController.textFields[0]).text;
        [self uploadFileWithName:name];
    }];
    [_okAction setEnabled:NO];
    [_alertController addAction:_okAction];
    
    [self presentViewController:_alertController animated:YES completion:nil];
}

-(void)uploadFileWithName:(NSString *)fileName{
    dispatch_queue_t bgQueue = dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_HIGH, 0);

    dispatch_async(bgQueue, ^{
        
        [_activityIndicator startAnimating];
        [NSThread sleepForTimeInterval:0.1];
        
        PFFile *imageFile = [Model createPFFileFromData:UIImageJPEGRepresentation(self.imageToBeUploaded, 0.8) withName:[NSString stringWithFormat:@"%@.jpg",fileName]];
        [imageFile save];
        
        PFObject *imageObj = [PFObject objectWithClassName:@"Server1"];
        [imageObj setObject:imageFile forKey:@"File"];
        [imageObj save];
        [_activityIndicator stopAnimating];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"File Upload" message:[NSString stringWithFormat:@"%@ uploaded successfully",fileName] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
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

@end