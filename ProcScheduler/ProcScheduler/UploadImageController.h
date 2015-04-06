//
//  UploadImageController.h
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImageController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong) UIImage *imageToBeUploaded;
@property (nonatomic,strong) NSString *action,*fileName;
@end
