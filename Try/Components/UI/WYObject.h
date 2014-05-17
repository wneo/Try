//
//  WYObject.h
//  Try
//
//  Created by neo on 14-4-4.
//
//

#import "WYBaseSpriteNode.h"

@interface WYObject : WYBaseSpriteNode

//atomic
@property (nonatomic) BOOL isAtomic;

+ (void)loadAtomicObjectWithConfig:(NSDictionary *)configDict;

//instance
+ (instancetype)copyFromAtomicName:(NSString *)name;

@end
