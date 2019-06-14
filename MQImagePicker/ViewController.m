//
//  ViewController.m
//  MQImagePicker
//
//  Created by Mubeen Raza Qazi on 14/06/2019.
//  Copyright © 2019 Mubeen Raza Qazi. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController (){
    UIButton *showGalleryBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButton];
}


- (void)setupButton{
    showGalleryBtn = [[UIButton alloc]init];
    [showGalleryBtn setTitle:@"Show Gallery" forState:UIControlStateNormal];
    [showGalleryBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    showGalleryBtn.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:showGalleryBtn];
    
    [showGalleryBtn.heightAnchor constraintEqualToConstant:40].active = YES;
    //[showGalleryBtn.widthAnchor constraintEqualToConstant:160].active = YES;
    //[showGalleryBtn.topAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [showGalleryBtn.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [showGalleryBtn.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    
}


@end
