//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: Four.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_Four_H_
#define _MMC_Four_H_

@class IOSIntArray;
@class IOSObjectArray;
@class MMCPlayerEnum;

#import "JreEmulation.h"

#define MMCFour_VALUE_FORBIDDEN_FACTOR 2
#define MMCFour_VALUE_MIXED_OR_EMPTY_ROW 0
#define MMCFour_VALUE_ONE_IN_A_ROW 1
#define MMCFour_VALUE_THREE_IN_A_ROW 16
#define MMCFour_VALUE_TWO_IN_A_ROW 4
#define MMCFour_VALUE_WIN 100000000


/**
 @brief Combination of four cells that, if filled by a player, constitute a win.
 */
@interface MMCFour : NSObject {
 @public
  IOSIntArray *indices_;
}

- (id)initWithIntArray:(IOSIntArray *)indices;

- (IOSIntArray *)getIndices;

/**
 @brief Evaluates the favorability of the state of the 'Four' in the following way: - All four cell values are PC --> VALUE_PC_WIN - All four cell values are Player --> VALUE_PLAYER_WIN - Three cells
 @param cellValues  values of cells (parallels BoardDef.LABELS)
 @return a positive value to indicate the row state is favorable to computer, negative value to indicate position is favorable to player. The larger the value, the more favorable.
 */

- (int)evaluateWithMMCPlayerEnumArray:(IOSObjectArray *)cellValues;

- (MMCPlayerEnum *)getValueIfAllSameWithMMCPlayerEnumArray:(IOSObjectArray *)cellValues;

- (int)getFirstEmptyIndexWithMMCPlayerEnumArray:(IOSObjectArray *)cellValues;

/**
 @brief Evaluates a four (from the point of view of player 1) given number of cells occupied by player 1 and player 2
 */

- (int)evalWithInt:(int)numP1
           withInt:(int)numP2;

- (BOOL)isTerminalPositionWithMMCPlayerEnumArray:(IOSObjectArray *)cellValues;

+ (BOOL)isTerminalPositionWithInt:(int)valueForFour;

- (void)copyAllFieldsTo:(MMCFour *)other;

@end

__attribute__((always_inline)) inline void MMCFour_init() {}

J2OBJC_FIELD_SETTER(MMCFour, indices_, IOSIntArray *)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_WIN, int)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_FORBIDDEN_FACTOR, int)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_THREE_IN_A_ROW, int)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_MIXED_OR_EMPTY_ROW, int)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_ONE_IN_A_ROW, int)

J2OBJC_STATIC_FIELD_GETTER(MMCFour, VALUE_TWO_IN_A_ROW, int)

typedef MMCFour ComMahfouzMulticCoreFour;

#endif // _MMC_Four_H_