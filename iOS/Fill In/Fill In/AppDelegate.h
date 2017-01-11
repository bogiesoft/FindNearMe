//
//  AppDelegate.h
//  Fill In
//
//  Created by Tony Shark on 1/10/17.
//  Copyright © 2017 Tony Shark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

