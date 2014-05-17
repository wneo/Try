//
//  WYObject+Test.m
//  Try
//
//  Created by neo on 14-5-13.
//
//

#import "WYObject+Test.h"

@implementation WYObject (Test)
- (void)testInstance
{

}
+ (void)testClass
{
	[self testInitAtom];
	WYObject *obj = [self copyFromAtomicName:@"testInitAtom"];
	NSLog(@"test obj: %@", obj);
}
+ (void)testInitAtom
{
	NSDictionary *config = @{@"name":@"testInitAtom",
							 @"color":@{@"R":@0.5, @"G":@0.5, @"B":@0.5, @"A":@0.5},
							 @"size":@{@"w":@10, @"h":@10},
							 @"position":@{@"x":@10, @"y":@10, @"z":@1, @"r":@0},
							 };
	
	
	[self loadAtomicObjectWithConfig:config];
}
@end
