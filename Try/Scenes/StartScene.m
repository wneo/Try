//
//  StartScene.m
//  Try
//
//  Created by neo on 14-3-15.
//
//

#import "StartScene.h"
#import "WYProgressNode.h"

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
		
		WYProgressNode *progress = [[WYProgressNode alloc] initWithDoneColor:[SKColor brownColor]
															  andUndoneColor:[SKColor grayColor]
																		size:CGSizeMake(100, 20)];
		[self addChild:progress];
		[progress runAction:[SKAction customActionWithDuration:4 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
			((WYProgressNode *)node).progress = elapsedTime/4;
		}]];
		
	}
	return self;
}
@end
