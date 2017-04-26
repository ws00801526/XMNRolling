//
//  XMNTestTableController.m
//  XMNRollingViewExample
//
//  Created by XMFraker on 16/12/1.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNTestTableController.h"

#import "XMNRollingView.h"

#import "XMNTestRollingItem.h"

#import "UIImageView+YYWebImage.h"

@interface XMNTestTableController ()

@end

@implementation XMNTestTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    XMNRollingView *view = [cell.contentView viewWithTag:100];
    if (indexPath.section == 0) {
        view.placeholder = [UIImage imageNamed:@"1.jpg"];
        view.items = [XMNTestRollingItem testLocalItems];
    }else if (indexPath.section == 1){
        view.rollingMode = XMNRollingModeInfiniteLoop | XMNRollingModeAuto;
        view.items = [XMNTestRollingItem testRemoteItems];
        view.placeholder = [UIImage imageNamed:@"2.jpeg"];
        [view setLoadRemoteBlock:^(UIImageView *imageView, id<XMNRollingItem> item, UIImage *placeholder) {
            [imageView yy_setImageWithURL:[NSURL URLWithString:[item imagePath]] placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        }];
    }else if (indexPath.section == 2) {
        view.rollingMode = XMNRollingModeAuto | XMNRollingModeReverse;
        view.placeholder = [UIImage imageNamed:@"placeholder.jpg"];
        view.items = [XMNTestRollingItem testMixedItems];
        [view setLoadRemoteBlock:^(UIImageView *imageView, id<XMNRollingItem> item, UIImage *placeholder) {
            [imageView yy_setImageWithURL:[NSURL URLWithString:[item imagePath]] placeholder:placeholder options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section ==  0) {
        return 120.f;
    }
    if (indexPath.section == 1) {
        return 240.f;
    }
    
    if (indexPath.section == 2) {
        return 360.f;
    }
    return CGFLOAT_MIN;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return @"测试本地图片";
    }
    if (section == 1) {
        return @"测试网络图片";
    }
    if (section == 2) {
        return @"测试混合图片";
    }
    return nil;
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
