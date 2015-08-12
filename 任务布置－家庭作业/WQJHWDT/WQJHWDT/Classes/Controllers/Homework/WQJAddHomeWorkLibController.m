//
//  WQJAddHomeWorkLibController.m
//  WQJHWDT
//
//  Created by 万齐鹣 on 15/8/1.
//  Copyright (c) 2015年 com.tarena.wanq. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "WQJAddHomeWorkLibController.h"
#import "WQJDateUtil.h"
#import "NSObject+WQJExpand.h"
#import "WQJAlertUtil.h"
#import "WQJHudUtil.h"
#import <BmobSDK/BmobProFile.h>


@interface WQJAddHomeWorkLibController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic, strong) NSMutableArray * saveImageNameArray;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageViewCell;
@property (weak, nonatomic) IBOutlet UITextField *homeworkTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *homeworkContentTextField;

@end

@implementation WQJAddHomeWorkLibController
{

}

-(NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        [_imageArray addObject:self.addImageButton];
    }
    return _imageArray;
}

-(NSMutableArray *)saveImageNameArray
{
    if(!_saveImageNameArray) {
        _saveImageNameArray = [NSMutableArray array];
    }
    return _saveImageNameArray;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)addFinish:(id)sender {
    // 检查数据
    NSString * title = self.homeworkTitleTextField.text;
    NSString * content = self.homeworkContentTextField.text;
    NSString * userID = [BmobUser getCurrentUser].objectId;
    
    if ([title isEmpty]) {
        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"标题不能为空" rightBtnText:@"知道了"];
        return ;
    } else {
        [[WQJHudUtil shareUtil] showOnWindowOnView:self.view];
        // 上传数据
        // 保存内容
        BmobObject * obj = [[BmobObject alloc] initWithClassName:@"wqjHomeworkLib"];
        [obj setObject:title forKey:@"title"];
        [obj setObject:content forKey:@"content"];
        [obj setObject:userID forKey:@"userId"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                // 上传照片
                [BmobProFile uploadFilesWithPaths:self.saveImageNameArray resultBlock:^(NSArray *pathArray, NSArray *urlArray,NSArray *bmobFileArray,NSError *error) {
                    //路径数组和url数组（url数组里面的元素为NSString）
                    if (error) {
                        [[WQJHudUtil shareUtil] hide];
                        [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"提交失败" rightBtnText:@"好的"];
                        NSLog(@"%@",error);
                    } else {
                        //路径数组和url数组（url数组里面的元素为NSString）
                        NSLog(@"pathArray %@ urlArray %@",pathArray,urlArray);
                        
                        BmobObjectsBatch *batch = [[BmobObjectsBatch alloc] init] ;
                        
                        for (BmobFile* bmobFile in bmobFileArray ) {
//                            NSLog(@"%@",bmobFile);
                            
                            [batch saveBmobObjectWithClassName:@"wqjHomeworkImage" parameters:@{@"name": bmobFile.name ,@"url": bmobFile.url, @"libId": obj.objectId}];
                        }
                        [batch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                // 保存成功
                                [[WQJHudUtil shareUtil] hide];
                                // 返回我的作业库
                                [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"提交完成，返回上一界面" rightBtnText:@"好的" block:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                                
                            }else{
                                [[WQJHudUtil shareUtil] hide];
                                [WQJAlertUtil showOneBtnAlertWithTitle:@"提示" content:@"提交失败" rightBtnText:@"好的"];
                                NSLog(@"batch error %@",[error description]);
                            }
                        }];
                    }
                } progress:^(NSUInteger index, CGFloat progress) {
                    //index表示正在上传的文件其路径在数组当中的索引，progress表示该文件的上传进度
                    NSLog(@"index %lu progress %f",(unsigned long)index,progress);
                }];
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    
}


- (IBAction)clickAddImageButton:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    [sheet showInView:self.view];

    NSLog(@"Move Button");
//    CGRect frame = self.addImageButton.frame;
//    frame.origin.x = frame.origin.x + 90;
//    
//    self.addImageButton.frame = frame;
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = NO;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSString * saveImageName = [NSString stringWithFormat:@"img_%@", [WQJDateUtil getDateString]];
    [self saveImage:image withName:saveImageName];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:saveImageName];
    [self.saveImageNameArray addObject:fullPath];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    UIButton * button = [[UIButton alloc] initWithFrame:self.addImageButton.frame];
    [button setBackgroundImage:savedImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageViewCell addSubview:button];
    [self.imageArray addObject:button];
    
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:savedImage];
//    imageView.frame = self.addImageButton.frame;
//    [self.imageArray addObject:imageView];
//    
//    [self.imageViewCell addSubview:imageView];
    
    CGRect frame = self.addImageButton.frame;
    
    if (self.imageArray.count == 4) {
        
        UIButton * tempBtn = self.imageArray[1];
        frame.origin.x = tempBtn.frame.origin.x;
        frame.origin.y = frame.origin.y + frame.size.height + 10;
        self.addImageButton.frame = frame;
    } else if (self.imageArray.count == 7){
//        [self.addImageButton removeFromSuperview];
        [self.addImageButton setHidden:YES];
        
    } else {
        frame.origin.x = frame.origin.x + frame.size.width + 10;
        self.addImageButton.frame = frame;
    }
}

- (void)removeImage:(UIButton *)sender
{
    NSInteger index = [self.imageArray indexOfObject:sender];
    
    [sender removeFromSuperview];
    if (self.imageArray.count == 7) {
        [self.addImageButton setHidden:NO];
    }
    self.addImageButton.frame = ((UIButton *)self.imageArray.lastObject).frame;
    for (NSInteger i=self.imageArray.count; i>index; i--) {
        UIButton * button = self.imageArray[i-1];
        UIButton * preButton = self.imageArray[i-2];
        button.frame = preButton.frame;
    }
    NSLog(@"%@", self.saveImageNameArray);
    
    [self.imageArray removeObjectAtIndex:index];
    
    NSFileManager * fileMgr = [NSFileManager defaultManager];
    
    [fileMgr removeItemAtPath:self.saveImageNameArray[index-1] error:nil];
    
    [self.saveImageNameArray removeObjectAtIndex:index-1];
    
//    BmobFile;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}




@end
