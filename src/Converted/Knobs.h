//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: Knobs.java
//
//  Created by amahfouz on 6/4/14.
//

#ifndef _MMC_Knobs_H_
#define _MMC_Knobs_H_

@class MMCKnob_LocationEnum;
@class MMCKnob_Pos;

#import "JreEmulation.h"


/**
 @brief State of both knobs combined.
 */
@interface MMCKnobs : NSObject {
 @public
  MMCKnob_Pos *topKnobPos_;
  MMCKnob_Pos *botKnobPos_;
}

- (id)initWithMMCKnob_Pos:(MMCKnob_Pos *)topKnobPos
          withMMCKnob_Pos:(MMCKnob_Pos *)botKnobPos;

+ (MMCKnobs *)createInitWithBoolean:(BOOL)randomFirstPos;

- (int)getCurProduct;

- (int)getPosForWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)loc;

- (int)getOtherPosWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)loc;

- (BOOL)areAtSamePos;

- (int)getProdIfMovedWithInt:(int)pos
    withMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)knobLoc;

- (NSString *)description;

- (void)setWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)loc
                            withInt:(int)pos;

- (MMCKnob_Pos *)getObjForWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)loc;

- (void)copyAllFieldsTo:(MMCKnobs *)other;

@end

__attribute__((always_inline)) inline void MMCKnobs_init() {}

J2OBJC_FIELD_SETTER(MMCKnobs, topKnobPos_, MMCKnob_Pos *)
J2OBJC_FIELD_SETTER(MMCKnobs, botKnobPos_, MMCKnob_Pos *)

typedef MMCKnobs ComMahfouzMulticCoreKnobs;

#endif // _MMC_Knobs_H_