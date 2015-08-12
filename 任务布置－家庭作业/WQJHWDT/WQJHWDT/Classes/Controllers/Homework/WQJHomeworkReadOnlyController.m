//
//  WQJHomeworkReadOnlyController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/2.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "WQJHomeworkReadOnlyController.h"
#import "UIImageView+WebCache.h"
#import "WQJHudUtil.h"
#import "WQJAlertUtil.h"

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH self.view.bounds.size.width
#define CELL_CONTENT_MARGIN 15.0f

@interface WQJHomeworkReadOnlyController ()

@end

@implementation WQJHomeworkReadOnlyController

-(NSArray *)libImageArray
{
    if (!_libImageArray) {
        _libImageArray = [NSArray array];
    }
    return _libImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"作业查看";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadImages];
    
    
    if (self.done) {
        // 未完成了，添加完成的按钮
        UIBarButtonItem * doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    
        self.navigationItem.rightBarButtonItem = doneBarButton;
    }
    
}

- (void)done:(id)sender
{
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    NSLog(@"done");
    
    BmobObject * obj = [BmobObject objectWithoutDatatWithClassName:@"wqjTaskUserRef" objectId:self.taskUserRefID];
    [obj setObject:@"done" forKey:@"state"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        [[WQJHudUtil shareUtil] hide];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (void)loadImages
{
    [[WQJHudUtil shareUtil] showSimpleOnView:self.view];
    BmobQuery * query = [BmobQuery queryWithClassName:@"wqjHomeworkImage"];
    [query whereKey:@"libId" equalTo:self.libID];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [[WQJHudUtil shareUtil] hide];
        if (array.count) {
            self.libImageArray = array;
            [self.tableView reloadData];

        }else{
            
        }
     
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titleReadOnlyCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleReadOnlyCell"];
        }
        cell.textLabel.text = self.libTitle;
//        cell.detailTextLabel.text = self.libTitle;
    }
    
    if (indexPath.section == 1) {
        UILabel * label;
        cell = [tableView dequeueReusableCellWithIdentifier:@"contentReadOnlyCell"];
        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"contentReadOnlyCell"];
        
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"contentReadOnlyCell"];
            
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setLineBreakMode:UILineBreakModeWordWrap];
            [label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            
//            [[label layer] setBorderWidth:2.0f];
            
            [[cell contentView] addSubview:label];
        }
        
        NSString * text = self.libContent;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        [label setText:text];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f))];
    }
    
    if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"viewReadOnlyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"viewReadOnlyCell"];
        }
        for (int i=0; i<self.libImageArray.count; i++) {
            int width = 85;
            int height = 85;
            
            int spacing = (self.view.bounds.size.width - 3*width- 2*CELL_CONTENT_MARGIN)/2;
            int x = CELL_CONTENT_MARGIN + (i%3)*spacing + ((i)%3)*width;
            int y = CELL_CONTENT_MARGIN+ (i/3)*(height+CELL_CONTENT_MARGIN);
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
            
            BmobObject * obj = self.libImageArray[i];
            
            NSString * url = [obj objectForKey:@"url"];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
//            UIImage * image = [UIImage imageNamed:@"placeholder"];
//            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
//            [imageView setFrame:CGRectMake(x, y, width, height)];
            
            
            
            [cell addSubview:imageView];
        }
    }

    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"作业标题";
    } else if (section == 1) {
        return @"作业内容";
    } else {
        return @"作业图片";
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45.0f;
    } else if (indexPath.section == 1) {
        NSString * text = self.libContent;
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat height = MAX(size.height, 44.0f);
        
        return height + (CELL_CONTENT_MARGIN * 2);
    } else {
        if (self.libImageArray.count <4) {
            return 110.0f;
        }
        if (self.libImageArray.count>3) {
            return 210.f;
        }
        
        return 100.0f;;
    }
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
