//
//  MulticPrefs.m
//  Multic
//
//  Created by Ayman Mahfouz on 6/4/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "MulticPrefs.h"
#import "Difficulty.h"

static NSString*  OPTION__LEVEL = @"level";
static MMCDifficulty  DEFAULT_DIFFICULTY = MMCDifficulty_MEDIUM;
static NSString* OPTION__RANDOM_POS =  @"random_pos";
static NSString* KEY_IS_FIRST_LAUNCH = @"is_first_launch";

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

+(BOOL)getAndSetIsFirstTime
{
    NSUserDefaults* options = [NSUserDefaults standardUserDefaults];
    NSNumber* isFirstLaunchAsNum = [options objectForKey:KEY_IS_FIRST_LAUNCH];
    
    BOOL isFirstLaunch
        = isFirstLaunchAsNum
        ? [isFirstLaunchAsNum boolValue]
        : YES;
    
    [options setObject:[NSNumber numberWithBool:NO]
                forKey:KEY_IS_FIRST_LAUNCH];
    [options synchronize];
    
    return isFirstLaunch;
}

@end
