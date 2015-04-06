//
//  GalleryController.m
//  ProcScheduler
//
//  Created by SumanKumar on 4/6/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "GalleryController.h"
#import "DataController.h"
#import "GalleryCollectionCell.h"
#import "UploadImageController.h"
@interface GalleryController ()
@property (nonatomic,strong) NSMutableArray *galleryFiles;
@property (nonatomic,assign) int selectedCell;
@end

@implementation GalleryController

static NSString * const reuseIdentifier = @"galleryIdentity";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    _galleryFiles = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[DataController sharedController] filePathWithName:@""] error:nil]];
    
//     [self.collectionView registerClass:[GalleryCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_galleryFiles count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    
    GalleryCollectionCell *cell = (GalleryCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
   
    [cell.titleLabel setText:[_galleryFiles objectAtIndex:indexPath.row]];
    UIImage *image =[UIImage imageWithContentsOfFile:[[DataController sharedController] filePathWithName:[_galleryFiles objectAtIndex:indexPath.row]]];
    [cell.galleryImageView setImage:image];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCell = (int)indexPath.row;
    [self performSegueWithIdentifier:@"showImage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showImage"]){
        
        UploadImageController *imageController = segue.destinationViewController;
        imageController.action = @"";
        [imageController setImageToBeUploaded:[UIImage imageWithContentsOfFile:[[DataController sharedController] filePathWithName:[_galleryFiles objectAtIndex:self.selectedCell]]]];
    }

}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
