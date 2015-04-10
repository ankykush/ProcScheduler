//
//  DataController.m
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "DataController.h"

@implementation DataController
@synthesize scheduledDate;
static DataController *sharedInst = nil;

+(DataController *)sharedController{

    @synchronized( self )
    {
        if ( sharedInst == nil )
        {
            sharedInst = [[self alloc] init];
        }
    }
    return sharedInst;
}

- (BOOL)fileExistAtDocumentPath:(NSString *)fileName {
    
   
    NSString *writeToPath = [self filePathWithName:fileName];
  
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:writeToPath]? YES: NO;
    
    return isExists;
}

-(NSString *)filePathWithName:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writeToPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    return writeToPath;
}

@end
