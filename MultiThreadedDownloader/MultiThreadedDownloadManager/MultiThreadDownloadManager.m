//
//  MultiThreadDownloadManager.m
//  MultiThreadedDownloader
//
//  Created by Danny  on 11/22/19.
//  Copyright © 2019 Bokati Enterprises. All rights reserved.
//


#define DB_DIRECTORY @"Download.dmg"

#import <Foundation/Foundation.h>
#import "MultiThreadDownloadManager.h"


@interface MultiThreadDownloadManager ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic) NSUInteger fileSize;
@property (nonatomic) NSUInteger chunkSize;

//may or may not be required later
//@property (nonatomic) int downloadedSize;
@end

@implementation MultiThreadDownloadManager

-(void) downloadFileFromStringURL:(NSString *) URLString {
    
    //setting the total file size and chunk size
    
    self.fileSize = [self getSizeForFileFromUrl:URLString];
    self.chunkSize = [self getChunkSizeFromTotalFileSize:[self fileSize]];
    
    NSUInteger fileIndex = 0;
    NSUInteger fileHeadByte = 0;
    
    //queue for download tasks
    dispatch_queue_t serialQueue = dispatch_queue_create("com.javra.queue", DISPATCH_QUEUE_SERIAL);
    
    for (fileHeadByte = 0; (fileHeadByte < [self fileSize]); (fileHeadByte = fileHeadByte + [self chunkSize]) ) {
        
        NSUInteger startByte = fileHeadByte;
        NSUInteger endByte = fileHeadByte + [self chunkSize];
        
        if (endByte > [self fileSize]) {
            endByte = [self fileSize];
        }
        
        NSLog(@"Start Byte: %d and End Byte: %d", startByte, endByte);
        
        //perform asynchronous downloads
        
//        dispatch_async(serialQueue, ^{
//            //block1
//
        
            [self downloadFileWithURLString:URLString fileIndex:fileIndex startByte:startByte endByte:endByte];
//        });
    
        fileIndex ++;
    }

}


- (void) downloadFileWithURLString: (NSString *) URLString fileIndex: (NSUInteger) fileIndex startByte:(NSUInteger ) startByte endByte:(NSUInteger ) endByte {
    
    
    // request creation
    
    NSMutableURLRequest *req;
    req = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:URLString]
                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                              timeoutInterval:30.0];
    if (![NSURLConnection canHandleRequest:req]) {
        // Handle the error
    }
    
    
    // creating required filepath
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d-%@", fileIndex,DB_DIRECTORY]];
    
    
    //permanent code
    
    NSString *filePath=[NSString stringWithFormat:@"%@",databasePath];
    NSLog(@"%@", filePath);
    
    
    //creating file at that filepath
    [fm createFileAtPath:databasePath contents:nil attributes:nil];
    
    //setting range header
    NSString *requestRange = [NSString stringWithFormat:@"bytes=%d-%d", startByte, endByte];
    [req setValue:requestRange forHTTPHeaderField:@"Range"];
    
    NSLog(@"%@", requestRange);

    NSURLConnection *conn = nil;
    conn = [NSURLConnection connectionWithRequest:req delegate:self];
    
    //permanent code
    
    //  setting filehandle array
    
    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:databasePath];
    if (!self.fileHandles) self.fileHandles = [[NSMutableArray alloc] init];
    [self.fileHandles addObject:fh];
    
    // setting connection array
    
    if (!self.connections) self.connections = [[NSMutableArray alloc] init];
    [self.connections addObject:conn];
    [conn start];
    NSLog(@"The connections count is %d and the file handles count is %d.", self.connections.count, self.fileHandles.count);
}


-(NSUInteger) getSizeForFileFromUrl:(NSString *) URLString {
    
    // Perform operations or network call here which can calculate the size of required file to be downloaded
    return 5500000;
}

-(NSUInteger) getChunkSizeFromTotalFileSize:(NSUInteger ) fileSize {
    
    //perform calculations here if you wish to create a chunk size based upon file size
    return 1000000;
}



// Delegate Methods

//delegate methods

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    
//    NSLog(@"connection didFailWithError");
//
//    if(error.code==-1009){
//        NSLog(@"connection didFailWithError");
//       //do something
//    }
//    
//    for (NSURLConnection *connectionFromArray in [self connections]) {
//        if (connectionFromArray  == connection) {
//            [connectionFromArray cancel];
//        }
//    }
//    
//    //Old Logic
//    //self.downloadingConnection = nil;
//    //Show an alert for the error
//}


- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if (![httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        // I don't know what kind of request this is!
        return;
    }
    
    NSUInteger index = 0;
    NSFileHandle *fh;
    for (NSURLConnection *connectionFromArray in [self connections]) {
        if (connectionFromArray == connection) {
            fh = [self.fileHandles objectAtIndex:index];
        }
        index ++;
    }
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",DB_DIRECTORY]];
//
//
//    NSFileHandle *fh = [NSFileHandle fileHandleForWritingAtPath:databasePath];
//    self.fileHandle = fh;
//
//
//    NSDictionary *responseDictionary = [httpResponse allHeaderFields];
//    NSLog(@"%@",responseDictionary);
//
//    _fileSize = [response expectedContentLength];
//    NSLog(@"%d", self.fileSize);
//    _downloadedSize = 0;
    
    switch (httpResponse.statusCode) {
        case 206: {
            
            
//            // Check to see if the download is in progress
//            NSUInteger downloadedBytes = 0;
//            NSFileManager *fm = [NSFileManager defaultManager];
//
//            NSString *filePath=[NSString stringWithFormat:@"%@",databasePath];
//            NSLog(@"%@", filePath);
//
//
//            if ([fm fileExistsAtPath:databasePath]) {
//                NSError *error = nil;
//                NSDictionary *fileDictionary = [fm attributesOfItemAtPath:databasePath
//                                                                    error:&error];
//                if (!error && fileDictionary)
//                    downloadedBytes = [fileDictionary fileSize];
//            } else {
//                [fm createFileAtPath:databasePath contents:nil attributes:nil];
//            }
//            [fh seekToFileOffset:downloadedBytes];
//            break;
//        }
////        case 206: {
////            NSString *range = [httpResponse.allHeaderFields valueForKey:@"Content-Range"];
////            NSError *error = nil;
////            NSRegularExpression *regex = nil;
////
////            // Check to see if the server returned a valid byte-range
////            regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+)"
////                                                              options:NSRegularExpressionCaseInsensitive
////                                                                error:&error];
////            if (error) {
////                [fh truncateFileAtOffset:0];
////                break;
////            }
////
////            // If the regex didn't match the number of bytes, start the download from the beginning
////            NSTextCheckingResult *match = [regex firstMatchInString:range
////                                                            options:NSMatchingAnchored
////                                                              range:NSMakeRange(0, range.length)];
//////        MARK:- correctt the implementation below
//////            uncomment these lines later
////            NSLog(@"%@", match.components);
////            NSLog(@"%d", match.numberOfRanges);
////            if (match.numberOfRanges < 2) {
////                [fh truncateFileAtOffset:0];
////                break;
////            }
////
////            // Extract the byte offset the server reported to us, and truncate our
////            // file if it is starting us at "0".  Otherwise, seek our file to the
////            // appropriate offset.
////
////            //test code
////            NSInteger *i;
////            for (i=0; i<match.numberOfRanges; i++) {
////                NSString *byteStr = [range substringWithRange:[match rangeAtIndex:i]];
////                NSLog(@"%@", byteStr);
////            }
////            //
////
////
////            NSString *byteStr = [range substringWithRange:[match rangeAtIndex:1]];
////            NSInteger bytes = [byteStr integerValue];
////            if (bytes <= 0) {
////                [fh truncateFileAtOffset:0];
////                break;
////            } else {
////                [fh seekToFileOffset:bytes];
////            }
////            break;
////        }
            [fh truncateFileAtOffset:0];
        }
        default:
            [fh truncateFileAtOffset:0];
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
//    _downloadedSize = _downloadedSize + [data length];
//    _downloadProgressBar.progress = ((float) _downloadedSize / (float) _fileSize);
    NSUInteger index = 0;
    NSFileHandle *fh;
    for (NSURLConnection *connectionFromArray in [self connections]) {
        if (connectionFromArray == connection) {
            fh = [self.fileHandles objectAtIndex:index];
        }
        index ++;
    }

    [fh writeData:data];
    [fh synchronizeFile];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    DocsetFeedModel *docset = self.downloadingDocset;
  
    NSUInteger index = 0;
    NSFileHandle *fh;
    for (NSURLConnection *connectionFromArray in [self connections]) {
        if (connectionFromArray == connection) {
            fh = [self.fileHandles objectAtIndex:index];
            [fh closeFile];
//            [[self.connections objectAtIndex:index] close];
        }
        index ++;
    }
    
//    [fh closeFile];
////    self.fileHandle = nil;
//    self.downloadingConnection = nil;
////    self.downloadingDocset = nil;
//
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSError *error = nil;
////    if (![fm removeItemAtPath:docset.rootPath error:&error]) {
////        // Show an error to the user
////    }
////    if (![fm moveItemAtPath:docset.downloadPath toPath:docset.rootPath error:&error]) {
////        // Show an error to the user
////    }
}



@end
