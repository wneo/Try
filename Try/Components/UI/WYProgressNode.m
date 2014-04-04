//
//  WYProgressNode.m
//  Try
//
//  Created by neo on 14-4-4.
//
//

#import "WYProgressNode.h"
@interface WYProgressNode ()
@property (nonatomic, strong) SKSpriteNode *maskNode;
@end

@implementation WYProgressNode
- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size
{
	self = [super initWithTexture:texture color:color size:size];
	if (self) {
		self.maskNode = [SKSpriteNode spriteNodeWithColor:color size:size];
		self.progress = 0;
		[self addChild:self.maskNode];
	}
	return self;
}
- (instancetype)initWithDoneColor:(UIColor *)doneColor andUndoneColor:(UIColor *)undoneColor size:(CGSize)size
{
	self = [super initWithColor:doneColor size:size];
	if (self) {
		self.maskNode = [SKSpriteNode spriteNodeWithColor:undoneColor size:size];
		[self addChild:self.maskNode];
	}
	return self;
}

- (void)setProgress:(float)progress
{
	_progress = progress;
	if (_progress < 0) {
		_progress = 0;
	}else if (_progress > 1.0) {
		_progress = 1.0;
	}
	CGRect newFrame = CGRectMake(self.size.width * ( 0.5 - self.anchorPoint.x) + self.size.width * _progress/2,//0.5 是中心点
								 self.size.height * ( 0.5 - self.anchorPoint.y),
								 self.size.width * (1 - _progress),
								 self.size.height);
	self.maskNode.position = newFrame.origin;
	self.maskNode.size = newFrame.size;
}
@end
