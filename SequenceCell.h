//
//  SequenceCell.h
//  GeneToolKit
//
//  Created by Michael MacDougall on 11/12/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SequenceCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *subTitle;
@property (nonatomic, strong) IBOutlet UISwitch *includeSwitch;

@end
