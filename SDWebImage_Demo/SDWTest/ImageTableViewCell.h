//
//  ImageTableViewCell.h
//  SDWTest
//
//  Created by lanou on 15/8/24.
//  Copyright (c) 2015年 LYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
//cell中的图片
@property (weak, nonatomic) IBOutlet UIImageView *listImageView;
//进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end
