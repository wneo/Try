//
//  StartScene.m
//  Try
//
//  Created by neo on 14-3-15.
//
//

#import "StartScene.h"

@interface StartScene ()
@property (nonatomic, strong) SKSpriteNode *background;
@end

@implementation StartScene
- (instancetype)initWithSize:(CGSize)size
{
	self = [super initWithSize:size];
	if (self) {
		self.anchorPoint = CGPointMake(0.5, 0.5);
		self.background = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"background"] size:self.frame.size];
		//self.background = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:self.frame.size];
		//self.background.blendMode = SKBlendModeReplace;
		self.background.position = CGPointMake(0.0, 0.0);
		[self addChild:self.background];
	}
	return self;
}
@end
