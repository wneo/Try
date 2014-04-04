//
//  WYObject.m
//  Try
//
//  Created by neo on 14-4-4.
//
//

#import "WYObject.h"

@implementation WYObject
/*
 0. name
 1. size : CGPoint
 2. SKTexture : {name:(images+times)}
 3.	color
 4. scaleMode
 5. physicsWorld:@{speed+direct+density+dynamic+restitution+linearDamping+angularDamping+affectedByGravity+usesPreciseCollisionDetection}
 6. position
 */
- (instancetype)initWithConfigDict:(NSDictionary *)configDict
{
	self = [super init];
	if (self) {
		NSDictionary *actions = @{@"action": [SKAction fadeOutWithDuration:0.2]};
	}
	return self;
}
@end
