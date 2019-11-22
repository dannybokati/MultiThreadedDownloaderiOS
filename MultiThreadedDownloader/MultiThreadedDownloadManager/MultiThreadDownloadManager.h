//
//  MultiThreadDownloadManager.h
//  MultiThreadedDownloader
//
//  Created by Danny  on 11/22/19.
//  Copyright © 2019 Bokati Enterprises. All rights reserved.
//

@interface MultiThreadDownloadManager : NSObject


@property (nonatomic, strong) NSMutableArray *connections;
@property (nonatomic, strong) NSMutableArray *fileHandles;

//remove these two variables later
//@property (nonatomic, strong) NSURLConnection *tempConnection;
//@property (nonatomic, strong) NSFileHandle * tempFileHandle;

-(void) downloadFileFromStringURL:(NSString *) URLString;
@end
