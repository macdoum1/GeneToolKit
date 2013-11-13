//
//  SequenceCell.m
//  GeneToolKit
//
//  Created by Michael MacDougall on 11/12/13.
//  Copyright (c) 2013 Michael MacDougall. All rights reserved.
//

#import "SequenceCell.h"

@implementation SequenceCell

@synthesize title,subTitle,includeSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
