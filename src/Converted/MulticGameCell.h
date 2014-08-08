//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: MulticGameCell.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_MulticGameCell_H_
#define _MMC_MulticGameCell_H_

@class MMCPlayerEnum;

#import "JreEmulation.h"


/**
 @brief State of a game cell.
 */
@interface MMCMulticGameCell : NSObject {
 @public

  /**
   @brief Index of cell in board (represented as an array) 
   */
  int cellIndex_;

  /**
   @brief Occupant, or null if the cell is empty 
   */
  MMCPlayerEnum *occupantIfAny_;
}

- (id)initWithInt:(int)cellIndex
withMMCPlayerEnum:(MMCPlayerEnum *)occupantIfAny;

- (int)getCellIndex;

- (MMCPlayerEnum *)getOccupantIfAny;

- (BOOL)isEmpty;

- (void)copyAllFieldsTo:(MMCMulticGameCell *)other;

@end

__attribute__((always_inline)) inline void MMCMulticGameCell_init() {}

J2OBJC_FIELD_SETTER(MMCMulticGameCell, occupantIfAny_, MMCPlayerEnum *)

typedef MMCMulticGameCell ComMahfouzMulticCoreMulticGameCell;

#endif // _MMC_MulticGameCell_H_