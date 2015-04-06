//
//  DataController.h
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataController : NSObject

@property (nonatomic,strong) NSString *selectedServer;

+(DataController *)sharedController;

-(BOOL)fileExistAtDocumentPath:(NSString *)fileName;

-(NSString *)filePathWithName:(NSString *)fileName;
@end
