//
//  ScheduleViewController.m
//  ProcScheduler
//
//  Created by Ankush Jain on 29/03/15.
//  Copyright (c) 2015 SecureAppTech. All rights reserved.
//

#import "ScheduleViewController.h"
#import "DataController.h"


@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicke;
@property (weak, nonatomic) IBOutlet UILabel *scheduledDateValue;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicke.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectDateAction:(id)sender {
    self.datePicke.hidden = NO;
}
- (IBAction)dateChangedAction:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd MMM YYYY,hh:mm"];
    self.scheduledDateValue.text =[df stringFromDate:self.datePicke.date];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [DataController sharedController].scheduledDate = self.datePicke.date;
}


@end
