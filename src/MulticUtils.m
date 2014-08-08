//
//  MulticUtils.m
//  Multic
//
//  Created by Ayman Mahfouz on 6/8/14.
//  Copyright (c) 2014 Ayman Mahfouz. All rights reserved.
//

#import "MulticUtils.h"
#import "MulticUtils.h"

@implementation UIColor (ColorManipulation)

-(UIColor*)halve
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    return [UIColor colorWithRed:r/2.0 green:g/2.0 blue:b/2.0 alpha:a];
}

+(UIColor*)colorWithR:(CGFloat)r withG:(CGFloat)g withB:(CGFloat)b
{
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
}


@end

