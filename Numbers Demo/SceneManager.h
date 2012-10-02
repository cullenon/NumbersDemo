//
//  SceneManager.h
//  SceneManager
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//
//  
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface SceneManager : NSObject {
    
}

+ (void)goPlay:(int)columns;
+ (void)goMenu;
+ (void)go:(CCLayer *)layer;
+ (CCScene *)wrap:(CCLayer *)layer;

@end
