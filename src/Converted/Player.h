//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: Player.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_Player_H_
#define _MMC_Player_H_

#import "JreEmulation.h"
#include "java/lang/Enum.h"

typedef enum {
  MMCPlayer_COMPUTER = 0,
  MMCPlayer_HUMAN = 1,
} MMCPlayer;

@interface MMCPlayerEnum : JavaLangEnum < NSCopying > {
 @public
  int valueOfFourInRow_;
}
+ (IOSObjectArray *)values;
+ (MMCPlayerEnum *)valueOfWithNSString:(NSString *)name;
- (id)copyWithZone:(NSZone *)zone;

- (id)initWithInt:(int)valueOfFourInRow
     withNSString:(NSString *)__name
          withInt:(int)__ordinal;

- (int)valueOfFour;
@end

FOUNDATION_EXPORT BOOL MMCPlayerEnum_initialized;
J2OBJC_STATIC_INIT(MMCPlayerEnum)

FOUNDATION_EXPORT MMCPlayerEnum *MMCPlayerEnum_values[];

#define MMCPlayerEnum_COMPUTER MMCPlayerEnum_values[MMCPlayer_COMPUTER]
J2OBJC_STATIC_FIELD_GETTER(MMCPlayerEnum, COMPUTER, MMCPlayerEnum *)

#define MMCPlayerEnum_HUMAN MMCPlayerEnum_values[MMCPlayer_HUMAN]
J2OBJC_STATIC_FIELD_GETTER(MMCPlayerEnum, HUMAN, MMCPlayerEnum *)

#endif // _MMC_Player_H_
