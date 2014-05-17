//
//  WYObject.m
//  Try
//
//  Created by neo on 14-4-4.
//
//

#import "WYObject.h"


@interface WYObject () <NSCopying>

@end

@implementation WYObject

- (id)copyWithZone:(NSZone *)zone
{
	WYObject *newObject = [super copyWithZone:zone];
	newObject.isAtomic = NO;
	return newObject;
}

+ (instancetype)copyFromAtomicName:(NSString *)name
{
	if (! name) {
		return [[self alloc] init];
	}
	NSAssert([name isKindOfClass:[NSString class]], nil);
	
	NSMutableDictionary *atomics = [WYObject getAtomicObjs];
	NSAssert(atomics[name], nil);
	NSAssert([atomics[name][@"object"] isKindOfClass:[WYObject class]], nil);
	
	WYObject *newObject = [atomics[name][@"object"] copy];
	atomics[name][@"count"] = [NSNumber numberWithInteger:[atomics[name][@"count"] integerValue] + 1];
	return newObject;

}

#pragma mark - Atomic config

static NSMutableDictionary *g_atomicObjects = nil;
+ (NSMutableDictionary *)getAtomicObjs
{
	
	if (g_atomicObjects) {
		return g_atomicObjects;
	}
	g_atomicObjects = [NSMutableDictionary dictionary];
	return g_atomicObjects;
}

#define kNodeDefaultConfig	@"defaultConfig"	//NSMutableDictionary
#define kConfigTextures		@"textures"			//NSMutableDictionary
/**
 *	根据配置dict生成元对象
 *
 *	@param configDict configDict description
 */
/*
 0. name
 1. size : CGPoint
 2. SKTextures : {name:(images+times)}
 3.	color{RGBA}
 4. position
 5. physicsWorld:@{speed+direct+density+dynamic+restitution+linearDamping+angularDamping+affectedByGravity+usesPreciseCollisionDetection}

 */
+ (void)loadAtomicObjectWithConfig:(NSDictionary *)configDict
{
	NSMutableDictionary *atomicObjs = [self getAtomicObjs];
	NSAssert([configDict isKindOfClass:[NSDictionary class]], nil);
	NSAssert(configDict[@"name"], @"name should be set for Atomic config");
	NSAssert(atomicObjs[configDict[@"name"]] == nil, @"should not be set before");
	if (! configDict) {
		return ;
	}
	
	// 0. color & size
	SKColor *objColor = [SKColor whiteColor];//default color
	if (configDict[@"color"]) {
		objColor = [WYObject colorFormConfig:configDict[@"color"]];
	}
	CGSize objSize = CGSizeMake(20, 20);//default size
	if (configDict[@"size"][@"w"] && configDict[@"size"][@"h"]) {
		objSize = CGSizeMake([configDict[@"size"][@"w"] floatValue], [configDict[@"size"][@"h"] floatValue]);
	}
	
	WYObject *object = [[WYObject alloc] initWithColor:objColor size:objSize];


	object.userData[kNodeDefaultConfig] = [NSMutableDictionary dictionary];
	object.isAtomic = YES;
	
	// 1. register
	atomicObjs[configDict[@"name"]] = [NSMutableDictionary dictionaryWithDictionary:@{@"object":object,//元对象
																					  @"count":@0,//生成子类个数
																					  @"initTime":[NSDate date]}];//元对象初始化时间
	
	
	NSMutableDictionary *config = object.userData[kNodeDefaultConfig];
	config[@"color"] = objColor;
	config[@"size"] = [NSValue valueWithCGSize:objSize];
	
	// 2. name
	if (configDict[@"name"]) {
		object.name = configDict[@"name"];
		config[@"name"] = configDict[@"name"];
	}
	
	// 3. textures   SKTextures : {name:(baseName+count+defaultInterval+atlasName)}
	if (configDict[kConfigTextures]) {
		NSAssert([configDict[kConfigTextures] isKindOfClass:[NSDictionary class]], nil);
		config[kConfigTextures] = [NSMutableDictionary dictionaryWithCapacity:[configDict[kConfigTextures] count]];
		NSArray *allNames = [configDict[kConfigTextures] allKeys];
		for (NSString *name in allNames) {
			NSDictionary *detailConfig = configDict[kConfigTextures][name];
			NSAssert([name isKindOfClass:[NSString class]], nil);
			NSString *baseName = detailConfig[@"baseName"];
			NSNumber *count = detailConfig[@"count"];
			NSArray *exts = detailConfig[@"exts"];//无重复型才有 count， 可重复型需要指定后缀,即 exts集合
			NSNumber *defaultInterval = detailConfig[@"defaultInterval"];
			NSNumber *resize = detailConfig[@"resize"];
			NSNumber *restore = detailConfig[@"restore"];
			NSNumber *repeartTimes = detailConfig[@"repeartTimes"];
			NSString *atlasName = detailConfig[@"atlasName"];
			NSAssert([baseName isKindOfClass:[NSString class]] || [exts isKindOfClass:[NSArray class]], nil);
			NSAssert([count isKindOfClass:[NSNumber class]] ^ [exts isKindOfClass:[NSArray class]], @"must only set one of them");
			NSUInteger textureCount = count?count.unsignedIntegerValue:exts.count;
			NSAssert(defaultInterval == nil || [defaultInterval isKindOfClass:[NSNumber class]], nil);
			NSAssert([atlasName isKindOfClass:[NSString class]], nil);
			
			config[kConfigTextures][name] = @{@"defaultInterval":defaultInterval?defaultInterval:@0,
											  @"resize":resize?resize:@YES,
											  @"restore":restore?restore:@NO,
											  @"repeartTimes":repeartTimes?repeartTimes:@1,
											  @"textures":[NSMutableArray arrayWithCapacity:textureCount],
											  };
			
			// 加载images
			SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:atlasName];
			for (NSInteger i = 1; i <= textureCount; i++) {
				NSString *imageName = nil;
				if (count) {
					imageName = [NSString stringWithFormat:@"%@%04d.png", baseName, i];
				}else{
					if (baseName) {
						imageName = [NSString stringWithFormat:@"%@%04d.png", baseName, [exts[i-1] integerValue]];
					}else{
						imageName = [NSString stringWithFormat:@"%@.png", exts[i-1]];
					}
				}
				
				SKTexture *texture = [atlas textureNamed:imageName];
				[(NSMutableArray *)config[kConfigTextures][name][@"textures"] addObject:texture];
			}
			
			//设置默认texture
			if ([name isEqualToString:@"default"]) {
				[object fireAnimationWithName:name andKey:name];
			}
		}
	}
	
	// 4. position  {x: y: z: r:}
	if (configDict[@"position"]) {
		if (configDict[@"position"][@"x"] && configDict[@"position"][@"y"]) {
			CGPoint position = CGPointMake([configDict[@"position"][@"x"] floatValue], [configDict[@"position"][@"y"] floatValue]);
			object.position = position;
			config[@"position"] = [NSValue valueWithCGPoint:position];
		}
		if (configDict[@"position"][@"z"]) {
			object.zPosition = [configDict[@"position"][@"z"] floatValue];
			config[@"positionZ"] = configDict[@"position"][@"z"];
		}
		if (configDict[@"position"][@"r"]) {
			object.zRotation = [configDict[@"position"][@"r"] floatValue];
			config[@"positionR"] = configDict[@"position"][@"R"];
		}
	}
	
}
#pragma mark - helps
+ (SKColor *)colorFormConfig:(NSDictionary *)config
{
	return [SKColor colorWithRed:[config[@"R"] floatValue]
						   green:[config[@"G"] floatValue]
							blue:[config[@"B"] floatValue]
						   alpha:[config[@"A"] floatValue]];
}
- (BOOL)fireAnimationWithName:(NSString *)name andKey:(NSString *)key
{
	NSAssert(name, nil);
	if (key) {
		if ([self actionForKey:key]) {
			return YES; // we already have a running animation or there aren't any frames to animate
		}
	}
	NSMutableDictionary *textureConfig = self.userData[kNodeDefaultConfig][kConfigTextures][name];
	if (! textureConfig) {
		return NO;
	}
	if ([textureConfig[@"textures"] count] == 1) {
		[self setTexture:textureConfig[@"textures"][0]];
	}else{
		NSAssert([textureConfig[@"textures"] count] > 1, @"must greater than 1 to show frames");
		SKAction *animateAction = [SKAction animateWithTextures:textureConfig[@"textures"]
												   timePerFrame:[textureConfig[@"defaultInterval"] floatValue]
														 resize:[textureConfig[@"resize"] boolValue]
														restore:[textureConfig[@"restore"] boolValue]];
		SKAction *doAction = nil;
		NSInteger repeartTimes = [(NSNumber *)textureConfig[@"repeartTimes"] integerValue];
		if (repeartTimes == 0) {//永远重复
			doAction = [SKAction repeatActionForever:animateAction];
		}else {
			doAction = [SKAction repeatAction:animateAction count:repeartTimes];
		}
		if (key) {
			[self runAction:doAction withKey:key];
		}else{
			[self runAction:doAction];
		}
	}
	
	return YES;
}

@end
