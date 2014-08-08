//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: MulticRandomAlgo.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_MulticRandomAlgo_H_
#define _MMC_MulticRandomAlgo_H_

@class MMCMutableGameState;
@protocol MMCMove;

#import "JreEmulation.h"
#include "MulticMoveAlgo.h"


/**
 @brief Picks a move at random for the computer.
 */
@interface MMCMulticRandomAlgo : NSObject < MMCMulticMoveAlgo > {
}

- (id<MMCMove>)findNextMoveWithMMCMutableGameState:(MMCMutableGameState *)gameState;

- (id)init;

@end

__attribute__((always_inline)) inline void MMCMulticRandomAlgo_init() {}

typedef MMCMulticRandomAlgo ComMahfouzMulticCoreMulticRandomAlgo;

#endif // _MMC_MulticRandomAlgo_H_