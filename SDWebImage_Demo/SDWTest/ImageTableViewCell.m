//
//  ImageTableViewCell.m
//  SDWTest
//
//  Created by lanou on 15/8/24.
//  Copyright (c) 2015年 LYJ. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell

- (void)awakeFromNib {
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0, [[UIScreen mainScreen] bounds].size.width, 2)];
        [self.contentView addSubview:self.progressView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
