//
//  DataController.m
//  ProcScheduler
//
//  Created by SumanKumar on 4/5/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "DataController.h"

@implementation DataController

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




@end
