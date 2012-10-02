//
//  SceneManager.m
//  SceneManager
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "SceneManager.h"

#import "HelloWorldLayer.h"
#import "MenuLayer.h"

@implementation SceneManager


+ (void)goMenu 
{
	CCLayer *layer = [MenuLayer node];
	[SceneManager go:layer];
}

+ (void)goPlay:(int)columns
{
    CCLayer *layer = [HelloWorldLayer nodeWithColumns:columns];
    [SceneManager go:layer];
}


+ (void)go:(CCLayer *)layer 
{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	
	if ([director runningScene]) {
		[director replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:newScene]];
	}
	else {
		[director runWithScene:newScene];		
	}
}

+ (CCScene *)wrap:(CCLayer *)layer 
{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}



@end
