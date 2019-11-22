//
//  ViewController.m
//  MultiThreadedDownloader
//
//  Created by Danny  on 11/22/19.
//  Copyright © 2019 Bokati Enterprises. All rights reserved.
//

#import "ViewController.h"
#import "MultiThreadDownloadManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startDownload];
    // Do any additional setup after loading the view.
}

- (void) startDownload {
    MultiThreadDownloadManager *downloader = [[MultiThreadDownloadManager alloc] init];
    [downloader downloadFileFromStringURL: @"https://dl.google.com/chrome/mac/stable/CHFA/googlechrome.dmg"];
}

@end
