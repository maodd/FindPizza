//
//  VeneneCell.h
//  FindPizza
//
//  Created by Frank Mao on 2015-07-17.
//  Copyright (c) 2015 mazoic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VeneneCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel * name;
@property (nonatomic, weak) IBOutlet UILabel * address;
@property (nonatomic, weak) IBOutlet UILabel * distance;

@end
