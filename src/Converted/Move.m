//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: Move.java
//
//  Created by amahfouz on 6/4/14.
//

#include "Knob.h"
#include "java/lang/IllegalArgumentException.h"

#import "Move.h"

@interface MMCMove : NSObject
@end

@implementation MMCMove

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "getPos", NULL, "I", 0x401, NULL },
    { "getKnobLoc", NULL, "Lcom.mahfouz.multic.core.Knob$Location;", 0x401, NULL },
  };
  static J2ObjcClassInfo _MMCMove = { "Move", "com.mahfouz.multic.core", NULL, 0x201, 2, methods, 0, NULL, 0, NULL};
  return &_MMCMove;
}

@end

@implementation MMCMove_Immutable

- (id)initWithInt:(int)pos
withMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)knobLocation {
  if (self = [super init]) {
    if (knobLocation == nil) @throw [[JavaLangIllegalArgumentException alloc] init];
    if (![MMCKnob isValidPosWithInt:pos]) @throw [[JavaLangIllegalArgumentException alloc] init];
    self->knobPos_ = pos;
    self->knobLocation_ = knobLocation;
  }
  return self;
}

- (int)getPos {
  return self->knobPos_;
}

- (MMCKnob_LocationEnum *)getKnobLoc {
  return self->knobLocation_;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ knob to %d", [((MMCKnob_LocationEnum *) nil_chk(knobLocation_)) getLabel], knobPos_];
}

- (void)copyAllFieldsTo:(MMCMove_Immutable *)other {
  [super copyAllFieldsTo:other];
  other->knobLocation_ = knobLocation_;
  other->knobPos_ = knobPos_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithInt:withMMCKnob_LocationEnum:", "Immutable", NULL, 0x1, NULL },
    { "getPos", NULL, "I", 0x1, NULL },
    { "getKnobLoc", NULL, "Lcom.mahfouz.multic.core.Knob$Location;", 0x1, NULL },
    { "description", "toString", "Ljava.lang.String;", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "knobPos_", NULL, 0x12, "I", NULL,  },
    { "knobLocation_", NULL, 0x12, "Lcom.mahfouz.multic.core.Knob$Location;", NULL,  },
  };
  static J2ObjcClassInfo _MMCMove_Immutable = { "Immutable", "com.mahfouz.multic.core", "Move", 0x19, 4, methods, 2, fields, 0, NULL};
  return &_MMCMove_Immutable;
}

@end

@implementation MMCMove_Mutable

- (int)getPos {
  return self->pos_;
}

- (MMCKnob_LocationEnum *)getKnobLoc {
  return self->knobLocation_;
}

- (void)setWithMMCKnob_LocationEnum:(MMCKnob_LocationEnum *)loc
                            withInt:(int)newPos {
  self->knobLocation_ = loc;
  self->pos_ = newPos;
}

- (MMCMove_Immutable *)toImmutable {
  return [[MMCMove_Immutable alloc] initWithInt:pos_ withMMCKnob_LocationEnum:knobLocation_];
}

- (void)copyIntoWithMMCMove_Mutable:(MMCMove_Mutable *)other {
  [((MMCMove_Mutable *) nil_chk(other)) setWithMMCKnob_LocationEnum:knobLocation_ withInt:pos_];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ knob to %d", [((MMCKnob_LocationEnum *) nil_chk(knobLocation_)) getLabel], pos_];
}

- (id)init {
  if (self = [super init]) {
    pos_ = -1;
  }
  return self;
}

- (void)copyAllFieldsTo:(MMCMove_Mutable *)other {
  [super copyAllFieldsTo:other];
  other->knobLocation_ = knobLocation_;
  other->pos_ = pos_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "getPos", NULL, "I", 0x1, NULL },
    { "getKnobLoc", NULL, "Lcom.mahfouz.multic.core.Knob$Location;", 0x1, NULL },
    { "setWithMMCKnob_LocationEnum:withInt:", "set", "V", 0x1, NULL },
    { "toImmutable", NULL, "Lcom.mahfouz.multic.core.Move$Immutable;", 0x1, NULL },
    { "copyIntoWithMMCMove_Mutable:", "copyInto", "V", 0x1, NULL },
    { "description", "toString", "Ljava.lang.String;", 0x1, NULL },
    { "init", NULL, NULL, 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "pos_", NULL, 0x2, "I", NULL,  },
    { "knobLocation_", NULL, 0x2, "Lcom.mahfouz.multic.core.Knob$Location;", NULL,  },
  };
  static J2ObjcClassInfo _MMCMove_Mutable = { "Mutable", "com.mahfouz.multic.core", "Move", 0x19, 7, methods, 2, fields, 0, NULL};
  return &_MMCMove_Mutable;
}

@end