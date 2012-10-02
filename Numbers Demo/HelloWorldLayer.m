//
//  HelloWorldLayer.m
//  Numbers Demo
//
//  Created by Cullen O'Neill on 8/16/12.
//  Copyright Lot18 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SceneManager.h" 
// used SceneManager for ease of use and method simplicity in transitioning between CCScenes



// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


+ (id)nodeWithColumns:(int)columns {
    HelloWorldLayer *layer = [[[HelloWorldLayer alloc] initWithColumns:columns] autorelease];
    return layer;
}


// on "init" you need to initialize your instance
- (id)initWithColumns:(int)columns {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        CGSize winsize = [CCDirector sharedDirector].winSize;
        _columns = columns;
        int fontsize = 32;
        // set square length and font size based on the number of columns
        switch (columns) {
            case 3:
                _width = 105;
                fontsize = 64;
                _startPoint = ccp(winsize.width*0.5 - _width*1.5 - 2, winsize.height - _width);
                break;
            case 4:
                _width = 79;
                fontsize = 48;
                _startPoint = ccp(winsize.width*0.5 - _width*2 - 3, winsize.height - _width);
                break;
            case 5:
                _width = 63;
                fontsize = 32;
                _startPoint = ccp(winsize.width*0.5 - _width*2.5 - 4, winsize.height - _width);
                break;
        }
        
        _tilesArray = [NSMutableArray new];
		
        int tileNumber = 0;
        
        // add the tiles and attach the numbers to them
		for (int i = 0; i < _columns; i++) {
            for (int j = 0; j < _columns; j++) {
                // create a gray cclayer square
                CCLayerColor *bgSquare = [CCLayerColor layerWithColor:ccc4(100, 100, 100, 255) 
                                                                width:_width height:_width];
                //position tiles with 2px border
                bgSquare.position = ccp(_startPoint.x + j*(_width+2), _startPoint.y - i*(_width+2));
                if (tileNumber > 0) {
                    // add the number layer to the tile
                    CCLabelTTF *number = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",tileNumber] fontName:@"uni_text" fontSize:fontsize];
                    [bgSquare addChild:number];
                    number.position = ccp(bgSquare.contentSize.width/2,bgSquare.contentSize.height/2);
                } else {
                    // blank tile, don't add a number
                    _blankTile = bgSquare;
                }
                bgSquare.tag = tileNumber;
                [self addChild:bgSquare];
                [_tilesArray addObject:bgSquare];
                tileNumber++;
            }
        }
        
        self.isTouchEnabled = YES;
        
        
        // add the various labels and buttons, placed on top layer for simplicity
        
        CCLabelTTF *helpLbl = [CCLabelTTF labelWithString:@"help!" fontName:@"uni_text" fontSize:16];
        CCMenuItemLabel *help = [CCMenuItemLabel itemWithLabel:helpLbl target:self selector:@selector(puzzleAssist)];
        CCMenu *helpMenu = [CCMenu menuWithItems:help, nil];
        helpMenu.position = ccp(winsize.width*0.9, winsize.height*0.5);
        [self addChild:helpMenu];
        
        CCLabelTTF *shuffleLbl = [CCLabelTTF labelWithString:@"shuffle" fontName:@"uni_text" fontSize:16];
        CCMenuItemLabel *shuffle = [CCMenuItemLabel itemWithLabel:shuffleLbl target:self selector:@selector(shuffleTiles)];
        CCMenu *shuffleMenu = [CCMenu menuWithItems:shuffle, nil];
        shuffleMenu.position = ccp(winsize.width*0.08, winsize.height*0.5);
        [self addChild:shuffleMenu];
        
        CCLabelTTF *backLbl = [CCLabelTTF labelWithString:@"back" fontName:@"uni_text" fontSize:16];
        CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:backLbl target:self selector:@selector(onBack)];
        CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = ccp(winsize.width*0.1, winsize.height*0.9);
        [self addChild:backMenu];
        
        _lblMoves = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"moves: %d",_moveCounter] dimensions:CGSizeMake(winsize.width*0.2, winsize.height*0.4) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"uni_text" fontSize:16];
        _lblMoves.position = ccp(winsize.width*0.9, winsize.height*0.8);
        [self addChild:_lblMoves];
        
        CCLabelTTF *onLabel = [CCLabelTTF labelWithString:@"accel ON" fontName:@"uni_text" fontSize:16];
        CCMenuItemLabel *onItem = [CCMenuItemLabel itemWithLabel:onLabel];
        onItem.color = ccWHITE;
        CCLabelTTF *offLabel = [CCLabelTTF labelWithString:@"accel OFF" fontName:@"uni_text" fontSize:16];
        CCMenuItemLabel *offItem = [CCMenuItemLabel itemWithLabel:offLabel];
        offItem.color = ccWHITE;
        CCMenuItemToggle *toggleItem = [CCMenuItemToggle itemWithTarget:self 
                                                               selector:@selector(didToggleAccelerometer) items:offItem,onItem, nil];
        CCMenu *toggleMenu = [CCMenu menuWithItems:toggleItem, nil];
        toggleMenu.position = ccp(winsize.width*0.9, winsize.height*0.2);
        [self addChild:toggleMenu z:50];
        
        
	}
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
		// Get the location of the touch in layer space
        CGPoint location = [self convertTouchToNodeSpace:touch];
        
        for (CCLayerColor *tile in _tilesArray) {
            if (CGRectContainsPoint(tile.boundingBox, location)) {
                NSLog(@"tile touched: %d",tile.tag);
                float diffX = tile.position.x - _blankTile.position.x;
                float diffY = tile.position.y - _blankTile.position.y;
                NSLog(@"diffx%f diffy%f",diffX,diffY);
                
                // swap the tile if it is exactly one unit distance away from the blank tile
                if ((abs(diffX)==_width+2 && abs(diffY)==0) || (abs(diffX)==0 && abs(diffY)==_width+2)) {
                    [self swapBlankTileWithTile:tile];
                } 
                // this could also be done by using the relative positioning of rows and columns,
                // but this method was chosen (absolute positioning) to avoid the case where tiles could 
                // move before reaching its final position after a swap
                
            }
        }
        
        
    }
    
}
     
// check if the tiles are in a winning configuration by sequential validation
- (void)checkIfWin {
    
    BOOL didWin = YES;
    
    int tileNumber = 1;
    for (int i = 0; i < _columns; i++) {
        for (int j = 0; j < _columns; j++) {
            CCLayerColor *tile = [_tilesArray objectAtIndex:tileNumber];
            CGPoint keyPos = ccp(_startPoint.x + j*(_width+2), _startPoint.y - i*(_width+2));
            if (keyPos.x != tile.position.x || keyPos.y != tile.position.y) {
                // tile position is out of place, game is not won (yet)
                // logic is based on absolute position
                didWin = NO;
                NSLog(@"did not win");
                break;
            }
            tileNumber++;
            if (tileNumber >= _tilesArray.count) {
                tileNumber = 0;
            }
        }
    }
    
    if (didWin) {
        NSLog(@"you won! did you cheat?");
        _gameover = YES;
        [self didWinGame];
    }
    
}

- (void)didWinGame {
    
    for (int i = 0; i < _tilesArray.count; i++) {
        CCLayerColor *layer = [_tilesArray objectAtIndex:i];
        [layer removeFromParentAndCleanup:YES];
    }
    CGSize winsize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *winLbl = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"uni_text" fontSize:64];
    winLbl.position = ccp(winsize.width/2,winsize.height*0.6);
    CCParticleSystemQuad *banner = [CCParticleSystemQuad particleWithFile:@"winbanner.plist"];
    [self addChild:banner];
    [self addChild:winLbl];
    
}

// alter puzzle to a configuration that is 1 move away from win
- (void)puzzleAssist {
    
    if (!_gameover) {
        int tileNumber = 1;
        for (int i = 0; i < _columns; i++) {
            for (int j = 0; j < _columns; j++) {
                CCLayerColor *tile = [_tilesArray objectAtIndex:tileNumber];
                CGPoint keyPos = ccp(_startPoint.x + j*(_width+2), _startPoint.y - i*(_width+2));
                tile.position = keyPos;
                
                if (tileNumber == (_tilesArray.count - 2)) {
                    // after we get to the 2nd-to-last tile, switch to the blank tile so the puzzle isn't solved automatically
                    tileNumber = 0;
                } else if (tileNumber == 0) {
                    // switch to the last tile after placing the blank tile
                    tileNumber = _tilesArray.count - 1;
                } else {
                    tileNumber++;
                }
                
            }
        }
    }
}

// move the tiles to a 'random' configuration
// used arc4random_uniform to avoid modulo bias
- (void)shuffleTiles {
    
    if (!_gameover) {
        // randomize array with modern fisher-yates shuffle
        NSMutableArray *shuffleArray = [NSMutableArray arrayWithArray:_tilesArray];
        for (int z = 0; z < shuffleArray.count; z++) {
            int tileIndex = arc4random_uniform(shuffleArray.count);
            int endIndex = shuffleArray.count - z;
            [shuffleArray exchangeObjectAtIndex:tileIndex withObjectAtIndex:(endIndex-1)];
        }
        NSLog(@"%@",shuffleArray);
        
        for (int i = 0; i < _columns; i++) {
            for (int j = 0; j < _columns; j++) {
                int tileIndex = _columns*i+j;
                CCLayerColor *tile = [shuffleArray objectAtIndex:tileIndex];
                CGPoint keyPos = ccp(_startPoint.x + j*(_width+2), _startPoint.y - i*(_width+2));
                tile.position = keyPos;
            }
        }
        
        _moveCounter = 0;
        [_lblMoves setString:[NSString stringWithFormat:@"moves: %d",_moveCounter]];
    }
    
}

- (void)onBack {
    [SceneManager goMenu];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    [_tilesArray release]; _tilesArray = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}





//toggle action
- (void)didToggleAccelerometer {
    
    if (_accelToggleOn) {
        
        self.isAccelerometerEnabled = NO;
        _accelToggleOn = NO;
    } else {
        
        self.isAccelerometerEnabled = YES;
        _accelToggleOn = YES;
    }
    
}

UIAccelerationValue unadjX = 0;
UIAccelerationValue unadjY = 0;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
#define kFilteringFactor 0.1
#define kRestAccelX -0.6
    
    // normalize the acceleration output
    float rollingX = (acceleration.x * kFilteringFactor) + (unadjX * (1.0 - kFilteringFactor));    
    float rollingY = (acceleration.y * kFilteringFactor) + (unadjY * (1.0 - kFilteringFactor));   
    
    float accelX = acceleration.x - rollingX; 
    float accelY = acceleration.y - rollingY;
    
    if (_isMoving) {
        //return if the number is already moving
        return;
    } else {
        CGPoint tempPos;
        BOOL deviceIsTilted = YES;
        NSLog(@"accelX:%f accelY:%f",accelX,accelY);
        
        if (accelX < -0.5 && abs(accelY) < 0.4) {
            NSLog(@"move blank tile south");
            //pick tile below open position
            tempPos = ccp(_blankTile.position.x, _blankTile.position.y-_width-2);
        } else if (accelX > 0 && abs(accelY) < 0.4) {
            NSLog(@"move blank tile north");
            //pick tile above open position
            tempPos = ccp(_blankTile.position.x, _blankTile.position.y+_width+2);
        } else if (accelY > 0.4 && abs(accelX) < 0.4) {
            NSLog(@"move blank tile west");
            //pick tile left of open position
            tempPos = ccp(_blankTile.position.x-_width-2, _blankTile.position.y);
        } else if (accelY < -0.4 && abs(accelX) < 0.4) {
            NSLog(@"move blank tile east");
            //pick tile right of open position
            tempPos = ccp(_blankTile.position.x+_width+2, _blankTile.position.y);
        } else {
            // do not pick a tile
            tempPos = ccp(-1,-1);
            deviceIsTilted = NO;
        }
        
        if (deviceIsTilted) {
            for (CCLayerColor *tile in _tilesArray) {
                if (tile.position.x == tempPos.x && tile.position.y == tempPos.y) {
                    _isMoving = YES;
                    self.isAccelerometerEnabled = NO;
                    [self swapBlankTileWithTile:tile];
                }
            }
        }
        
    }
    
}

// swap the given tile with the blank tile
- (void)swapBlankTileWithTile:(CCLayerColor *)tile {
    
    CGPoint swap1 = _blankTile.position;
    CGPoint swap2 = tile.position;
    id move1 = [CCMoveTo actionWithDuration:0.5 position:swap1];
    id move2 = [CCMoveTo actionWithDuration:0.5 position:swap2];
    id callback1 = [CCCallFunc actionWithTarget:self selector:@selector(stopMoving)];
    id callback2 = [CCCallFunc actionWithTarget:self selector:@selector(checkIfWin)];
    id sequence;
    if (_isMoving) {
        // alter CCSequence because move originated from accelerometer
        sequence = [CCSequence actions:move2, callback1, callback2, nil];
    } else {
        sequence = [CCSequence actions:move2, callback2, nil];
    }
    [tile runAction:move1];
    [_blankTile runAction:sequence];
    _moveCounter++;
    [_lblMoves setString:[NSString stringWithFormat:@"moves: %d",_moveCounter]];
    
}


// part of a sequence of callbacks specific to accelerometer function
- (void)stopMoving {
    _isMoving = NO;
    self.isAccelerometerEnabled = YES;
}




@end
