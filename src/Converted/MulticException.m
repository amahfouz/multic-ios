//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: MulticException.java
//
//  Created by amahfouz on 6/4/14.
//

#include "MulticGameCell.h"

#import "MulticException.h"

@implementation MMCMulticException

- (id)initWithNSString:(NSString *)detailMessage
 withMMCMulticGameCell:(MMCMulticGameCell *)gameCell {
  if (self = [super initWithNSString:detailMessage]) {
    self->cellIfAny_ = gameCell;
  }
  return self;
}

- (MMCMulticGameCell *)getCellIfAny {
  return self->cellIfAny_;
}

- (void)copyAllFieldsTo:(MMCMulticException *)other {
  [super copyAllFieldsTo:other];
  other->cellIfAny_ = cellIfAny_;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "initWithNSString:withMMCMulticGameCell:", "MulticException", NULL, 0x1, NULL },
    { "getCellIfAny", NULL, "Lcom.mahfouz.multic.core.MulticGameCell;", 0x1, NULL },
  };
  static J2ObjcFieldInfo fields[] = {
    { "cellIfAny_", NULL, 0x12, "Lcom.mahfouz.multic.core.MulticGameCell;", NULL,  },
  };
  static J2ObjcClassInfo _MMCMulticException = { "MulticException", "com.mahfouz.multic.core", NULL, 0x11, 2, methods, 1, fields, 0, NULL};
  return &_MMCMulticException;
}

@end
