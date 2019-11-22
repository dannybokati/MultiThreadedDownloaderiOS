//
//  AppDelegate.h
//  MultiThreadedDownloader
//
//  Created by Danny  on 11/22/19.
//  Copyright © 2019 Bokati Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

