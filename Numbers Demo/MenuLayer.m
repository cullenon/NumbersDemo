//
//  MenuLayer.m
//  Numbers Demo
//
//  Created by Cullen O'Neill on 8/16/12.
//  Copyright 2012 Lot18. All rights reserved.
//

#import "MenuLayer.h"
#import "SceneManager.h"

@implementation MenuLayer

- (id)init {
    
    if ((self = [super init])) {
        CGSize winsize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *lbl3x3 = [CCLabelTTF labelWithString:@"3x3" fontName:@"uni_text" fontSize:32];
        CCLabelTTF *lbl4x4 = [CCLabelTTF labelWithString:@"4x4!" fontName:@"uni_text" fontSize:32];
        CCLabelTTF *lbl5x5 = [CCLabelTTF labelWithString:@"5x5!" fontName:@"uni_text" fontSize:32];
        CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lbl3x3 target:self selector:@selector(doSelect3x3)];
        CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lbl4x4 target:self selector:@selector(doSelect4x4)];
        CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:lbl5x5 target:self selector:@selector(doSelect5x5)];
        CCMenu *menu = [CCMenu menuWithItems:item1,item2,item3, nil];
        menu.position = ccp(winsize.width/2,winsize.height/2);
        [menu alignItemsVerticallyWithPadding:20];
        [self addChild:menu];
    }
    
    return self;
    
}

- (void)doSelect3x3 {
    [SceneManager goPlay:3];
}

- (void)doSelect4x4 {
    [SceneManager goPlay:4];
}

- (void)doSelect5x5 {
    [SceneManager goPlay:5];
}

@end
