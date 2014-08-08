//
//  MulticPrefs.h
//  Multic
//
//  Created by Ayman Mahfouz on 6/4/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Difficulty.h"

@interface MulticPrefs : NSObject

+(MMCDifficultyEnum*)getDifficulty;
+(MMCDifficulty)getDifficultyAsInt;
+(BOOL)getIsRandomFirstPos;
+(BOOL)getHumanStarts;

+(void)setDifficulty:(MMCDifficulty)difficulty;
+(void)setIsRandomFirstPos:(BOOL)isRandom;
@end
