//
//  HelloWorldLayer.h
//  Numbers Demo
//
//  Created by Cullen O'Neill on 8/16/12.
//  Copyright Lot18 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    NSMutableArray *_tilesArray;
    CCLayerColor *_blankTile;
    CGPoint _startPoint;
    int _width;
    int _columns;
    BOOL _gameover;
    CCLabelTTF *_lblMoves;
    int _moveCounter;
    BOOL _isMoving;
    BOOL _accelToggleOn;
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;
+ (id)nodeWithColumns:(int)columns;
- (id)initWithColumns:(int)columns;
- (void)checkIfWin;
- (void)didWinGame;
- (void)puzzleAssist;
- (void)shuffleTiles;
- (void)onBack;
- (void)didToggleAccelerometer;
- (void)swapBlankTileWithTile:(CCLayerColor *)tile;
- (void)stopMoving;


@end
