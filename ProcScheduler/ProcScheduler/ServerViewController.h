//
//  ServerViewController.h
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *serverTableView;
@property (nonatomic,strong) NSMutableArray *availableServersArr;
@property (nonatomic,strong) NSString *selectedServer;
@end
