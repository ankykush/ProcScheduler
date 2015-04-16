//
//  FileNamesController.m
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "FileNamesController.h"
#import "Model.h"
#import "UploadImageController.h"

@interface FileNamesController ()
@property (nonatomic,strong) NSMutableArray *fileNames;
@property (nonatomic,strong) NSString *selectedFileName;
@property (nonatomic,strong) UIImage *imageToBeDownloaded;
@end

@implementation FileNamesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileNames = [NSMutableArray array];
    // Do any additional setup after loading the view.
     [Model getDataFrom:[[DataController sharedController] selectedServer] withColumns:@[@"FileName"] where:nil clause:-1 value:nil completion:^(NSArray *responseArray, NSError *responseError, NSString *object) {
         
         if(responseError == nil){
             
             for(PFObject *obj in responseArray){
                 [self.fileNames addObject:[obj objectForKey:@"FileName"]];
             }
             
         }
         [self.tableView reloadData];
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.fileNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"fileNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.fileNames[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedFileName = self.fileNames[indexPath.row];
    [Model getDataFrom:[[DataController sharedController] selectedServer] withColumns:@[@"File"] where:@"FileName" clause:kEqualTo value:self.selectedFileName completion:^(NSArray *responseArray, NSError *responseError, NSString *object){
        if(responseError == nil){
            
            PFObject *fileObj = [responseArray lastObject];
            PFFile *imageFile = [fileObj objectForKey:@"File"];
            NSData *imageData = [imageFile getData];
            _imageToBeDownloaded = [UIImage imageWithData:imageData];
            [self performSegueWithIdentifier:@"downloadImage" sender:self];
        }
        
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UploadImageController *downloadController = segue.destinationViewController;
    [downloadController setAction:_identifier];
    [downloadController setImageToBeUploaded:_imageToBeDownloaded];
    [downloadController setFileName:self.selectedFileName];
    if([segue.identifier isEqualToString:@"downloadImage"])
    {
        [self storeFileAtTempDirectoryWithName:self.selectedFileName];
    }
}

-(void)storeFileAtTempDirectoryWithName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *storePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"temp/%@",fileName]];
    
    [[NSFileManager defaultManager]createDirectoryAtPath:[storePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    
    [UIImageJPEGRepresentation(_imageToBeDownloaded, 0.8) writeToFile:storePath atomically:YES];
}


@end
