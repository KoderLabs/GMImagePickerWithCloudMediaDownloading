//
//  ViewController.m
//  GMImagePickerWithCloudMediaDownloading
//
//  Created by Mubeen Raza Qazi on 14/06/2019.
//  Copyright © 2019 Mubeen Raza Qazi. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "GMImagePickerController.h"

@interface ViewController ()<GMImagePickerControllerDelegate>{
    UIButton *showGalleryBtn;
    GMImagePickerController *picker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupButton];
}


- (void)setupButton{
    showGalleryBtn = [[UIButton alloc]init];
    [showGalleryBtn setTitle:@"Show Gallery" forState:UIControlStateNormal];
    [showGalleryBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    showGalleryBtn.translatesAutoresizingMaskIntoConstraints = false;
    [showGalleryBtn addTarget:self action:@selector(openGMPicker) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showGalleryBtn];
    
    [showGalleryBtn.heightAnchor constraintEqualToConstant:40].active = YES;
    [showGalleryBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [showGalleryBtn.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
}

- (void)openGMPicker{
    picker = [[GMImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - GMImagePicker Delegate
-(void)assetsPickerController:(GMImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
