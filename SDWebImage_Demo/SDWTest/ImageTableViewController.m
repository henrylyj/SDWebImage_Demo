//
//  ImageTableViewController.m
//  SDWTest
//
//  Created by lanou on 15/8/24.
//  Copyright (c) 2015年 LYJ. All rights reserved.
//

#import "ImageTableViewController.h"
#import "ImageTableViewCell.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
@interface ImageTableViewController ()
@property (nonatomic, strong) NSMutableArray *imageURLArr;
@end

@implementation ImageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageURLArr = [[NSMutableArray alloc] init];
    [self.imageURLArr addObject:@"http://a.hiphotos.baidu.com/image/pic/item/03087bf40ad162d93a0f0c1c13dfa9ec8b13cdc9.jpg"];
    [self.imageURLArr addObject:@"http://a.hiphotos.baidu.com/image/pic/item/d043ad4bd11373f0fae42e80a60f4bfbfaed04d1.jpg"];
    [self.imageURLArr addObject:@"http://c.hiphotos.baidu.com/image/pic/item/8b13632762d0f703d3ee49d10afa513d2697c55b.jpg"];

}
- (IBAction)clear:(UIBarButtonItem *)sender {
    //只清理memory时图片还是可以加载出来
    //[[SDImageCache sharedImageCache] clearMemory];
    
    //清理硬盘时图片就彻底被清理掉了
    //  [[SDImageCache sharedImageCache] clearDisk];
    
    //清理硬盘中指定的图片，YES连带清理缓存
    [[SDImageCache sharedImageCache] removeImageForKey:[self.imageURLArr firstObject] fromDisk:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.imageURLArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    // 不带占位图,有缓存
//    [cell.listImageView sd_setImageWithURL:[self.imageURLArr objectAtIndex:indexPath.row]];
    // 带占位图，可避免网速不好时空白页的出现，有缓存
//    [cell.listImageView sd_setImageWithURL:self.imageURLArr[indexPath.row] placeholderImage:[UIImage imageNamed:@"background640*1136"]];
    
    // 这个属于是下载图片的方法，中途可以中断下载，可以监听下载进度,本方法下载的图片是会自动缓存的，
    __block id sdWebImageOperation = [[SDWebImageManager sharedManager] downloadImageWithURL:self.imageURLArr[indexPath.row] options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //加载过程中会返回目前收到的和预期的字节，监听下载过程（应用于图片加载进度条），下载结束后执行结束的block
        NSLog(@"图片 == %ld   收到 == %ld,预期 == %ld",indexPath.row,(long)receivedSize,(long)expectedSize);
        //计算进度条进度，监听每张图片的加载进度
        float progress =(float)receivedSize/expectedSize;
        cell.progressView.progress = progress;
        
        //停止方法 根据downloadImageWithURL的返回值可以停止任务进行
//        if (progress > 0.5) {
//            [sdWebImageOperation cancel];
//        }
        // 下载完成
    } completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        UIImage *aImage = image;
        //  [cell.progressView removeFromSuperview];
        NSLog(@"成功了:%lu",(unsigned long)UIImageJPEGRepresentation(aImage, 1).length);
        cell.listImageView.image = aImage;
        //SDImageCacheType可以显示是从哪里获得的图片
        //SDImageCacheTypeNone      0
        //SDImageCacheTypeDisk      1
        //SDImageCacheTypeMemory    2
        switch (cacheType) {
            case 0:
                NSLog(@"图片%ld从网络加载获得",(long)indexPath.row);
                break;
            case 1:
                NSLog(@"图片%ld从设备硬盘获得",(long)indexPath.row);
                break;
            case 2:
                NSLog(@"图片%ld从缓存获得",(long)indexPath.row);
                break;
            default:
                break;
        }
    }];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
