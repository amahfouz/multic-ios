//
//  Generated by the J2ObjC translator.  DO NOT EDIT!
//  source: Difficulty.java
//
//  Created by amahfouz on 6/4/14.
//

#include "IOSClass.h"
#include "java/lang/IllegalArgumentException.h"

#import "Difficulty.h"

BOOL MMCDifficultyEnum_initialized = NO;

MMCDifficultyEnum *MMCDifficultyEnum_values[5];

@implementation MMCDifficultyEnum

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)initWithNSString:(NSString *)__name withInt:(int)__ordinal {
  return [super initWithNSString:__name withInt:__ordinal];
}

+ (void)initialize {
  if (self == [MMCDifficultyEnum class]) {
    MMCDifficultyEnum_SILLY = [[MMCDifficultyEnum alloc] initWithNSString:@"SILLY" withInt:0];
    MMCDifficultyEnum_EASY = [[MMCDifficultyEnum alloc] initWithNSString:@"EASY" withInt:1];
    MMCDifficultyEnum_MEDIUM = [[MMCDifficultyEnum alloc] initWithNSString:@"MEDIUM" withInt:2];
    MMCDifficultyEnum_HARD = [[MMCDifficultyEnum alloc] initWithNSString:@"HARD" withInt:3];
    MMCDifficultyEnum_EXPERT = [[MMCDifficultyEnum alloc] initWithNSString:@"EXPERT" withInt:4];
    MMCDifficultyEnum_initialized = YES;
  }
}

+ (IOSObjectArray *)values {
  return [IOSObjectArray arrayWithObjects:MMCDifficultyEnum_values count:5 type:[IOSClass classWithClass:[MMCDifficultyEnum class]]];
}

+ (MMCDifficultyEnum *)valueOfWithNSString:(NSString *)name {
  for (int i = 0; i < 5; i++) {
    MMCDifficultyEnum *e = MMCDifficultyEnum_values[i];
    if ([name isEqual:[e name]]) {
      return e;
    }
  }
  @throw [[JavaLangIllegalArgumentException alloc] initWithNSString:name];
  return nil;
}

+ (J2ObjcClassInfo *)__metadata {
  static J2ObjcMethodInfo methods[] = {
    { "init", NULL, NULL, 0x1, NULL },
  };
  static const char *superclass_type_args[] = {"Lcom.mahfouz.multic.core.Difficulty;"};
  static J2ObjcClassInfo _MMCDifficultyEnum = { "Difficulty", "com.mahfouz.multic.core", NULL, 0x4011, 1, methods, 0, NULL, 1, superclass_type_args};
  return &_MMCDifficultyEnum;
}

@end
