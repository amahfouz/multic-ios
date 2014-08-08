//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: MutableGameState.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_MutableGameState_H_
#define _MMC_MutableGameState_H_

@class IOSIntArray;
@class MMCBoardState;
@class MMCDifficultyEnum;
@class MMCKnob_LocationEnum;
@class MMCKnobs;
@class MMCMulticGameCell;
@class MMCMutableGameState_Memento;
@class MMCPlayerEnum;
@protocol MMCMove;
@protocol MMCMulticMoveAlgo;
@protocol MMUMulticLog;
@protocol MMUXGameGridUiModel;

#import "JreEmulation.h"


/**
 @brief Aggregated mutable state of the game: - Board state (contents of cells) - Knob states - Who's turn is it
 */
@interface MMCMutableGameState : NSObject {
 @public
  MMCKnobs *knobs_;
  MMCBoardState *boardState_;
  MMCDifficultyEnum *difficulty_;
  id<MMCMulticMoveAlgo> algo_;
  BOOL isComputerTurn__;
}

- (id)initWithMMCKnobs:(MMCKnobs *)knobs
     withMMCBoardState:(MMCBoardState *)boardState
 withMMCDifficultyEnum:(MMCDifficultyEnum *)difficulty
           withBoolean:(BOOL)isComputerTurn
      withMMUMulticLog:(id<MMUMulticLog>)log;

+ (MMCMutableGameState *)createInitWithBoolean:(BOOL)randomFirstPos
                         withMMCDifficultyEnum:(MMCDifficultyEnum *)difficulty
                                   withBoolean:(BOOL)computerStarts
                              withMMUMulticLog:(id<MMUMulticLog>)log;

- (MMCKnobs *)getKnobs;

- (BOOL)isComputerTurn;

- (MMCPlayerEnum *)getWinnerIfAny;

- (IOSIntArray *)getWinningFourIfAny;

- (MMCMulticGameCell *)getCellStateWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)knobLoc
                                                    withInt:(int)pos;

- (BOOL)isValidMoveWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)knobLoc
                                    withInt:(int)pos;

- (int)evalBoardState;

- (id<MMUXGameGridUiModel>)getGridModel;

- (MMCDifficultyEnum *)getDifficulty;

- (id<MMCMove>)findNextComputerMove;

- (MMCMutableGameState_Memento *)makeMoveWithMMCMove:(id<MMCMove>)move;

- (void)applyUndoWithMMCMutableGameState_Memento:(MMCMutableGameState_Memento *)undoInfo;

- (id<MMCMulticMoveAlgo>)createAlgoWithMMUMulticLog:(id<MMUMulticLog>)log;

- (void)copyAllFieldsTo:(MMCMutableGameState *)other;

@end

__attribute__((always_inline)) inline void MMCMutableGameState_init() {}

J2OBJC_FIELD_SETTER(MMCMutableGameState, knobs_, MMCKnobs *)
J2OBJC_FIELD_SETTER(MMCMutableGameState, boardState_, MMCBoardState *)
J2OBJC_FIELD_SETTER(MMCMutableGameState, difficulty_, MMCDifficultyEnum *)
J2OBJC_FIELD_SETTER(MMCMutableGameState, algo_, id<MMCMulticMoveAlgo>)

typedef MMCMutableGameState ComMahfouzMulticCoreMutableGameState;

@interface MMCMutableGameState_Memento : NSObject {
 @public
  MMCMutableGameState *this$0_;
  int productCellToEmpty_;
  id<MMCMove> reverseMove_;
  BOOL isComputerTurn_;
}

- (id)initWithMMCMutableGameState:(MMCMutableGameState *)outer$
                          withInt:(int)productCellToEmpty
                      withMMCMove:(id<MMCMove>)reverseMove
                      withBoolean:(BOOL)isComputerTurn;

- (int)getCellIndex;

- (void)apply;

- (void)copyAllFieldsTo:(MMCMutableGameState_Memento *)other;

@end

__attribute__((always_inline)) inline void MMCMutableGameState_Memento_init() {}

J2OBJC_FIELD_SETTER(MMCMutableGameState_Memento, this$0_, MMCMutableGameState *)
J2OBJC_FIELD_SETTER(MMCMutableGameState_Memento, reverseMove_, id<MMCMove>)

#endif // _MMC_MutableGameState_H_