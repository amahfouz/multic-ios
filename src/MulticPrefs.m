//
//  MulticPrefs.m
//  Multic
//
//  Created by Ayman Mahfouz on 6/4/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "MulticPrefs.h"
#import "Difficulty.h"

#define OPTION__LEVEL @"level"
#define DEFAULT_DIFFICULTY MMCDifficulty_MEDIUM
#define OPTION__RANDOM_POS @"random_pos"

@implementation MulticPrefs

+(MMCDifficulty)getDifficultyAsInt
{
    NSUserDefaults* options = [NSUserDefaults standardUserDefaults];
    NSNumber* levelAsNum = [options objectForKey:OPTION__LEVEL];

    NSInteger level = (! levelAsNum)
        ? 0
        : [levelAsNum intValue];
    
    // check for valid range
    if (level < MMCDifficulty_SILLY || level > MMCDifficulty_EXPERT)
        return DEFAULT_DIFFICULTY;
    
    return level;
}

+(void)setDifficulty:(MMCDifficulty)difficulty
{
    NSUserDefaults* options = [NSUserDefaults standardUserDefaults];
    [options setObject:[NSNumber numberWithInt:difficulty]
                forKey:OPTION__LEVEL];
    [options synchronize];
}

+(MMCDifficultyEnum*)getDifficulty
{
    return MMCDifficultyEnum_values[[MulticPrefs getDifficultyAsInt]];
}

+(BOOL)getIsRandomFirstPos
{
    NSUserDefaults* options = [NSUserDefaults standardUserDefaults];
    NSNumber* isRandomFirstPos = [options objectForKey:OPTION__RANDOM_POS];
    
    return isRandomFirstPos
        ? [isRandomFirstPos boolValue]
        : NO;
}

+(void)setIsRandomFirstPos:(BOOL)isRandom
{
    NSUserDefaults* options = [NSUserDefaults standardUserDefaults];
    [options setObject:[NSNumber numberWithBool:isRandom]
                forKey:OPTION__RANDOM_POS];
    [options synchronize];

}

+(BOOL)getHumanStarts
{
    return YES;
}

@end
