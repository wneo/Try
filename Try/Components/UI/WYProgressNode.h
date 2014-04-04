//
//  WYProgressNode.h
//  Try
//
//  Created by neo on 14-4-4.
//
//

#import <SpriteKit/SpriteKit.h>

@interface WYProgressNode : SKSpriteNode
@property (nonatomic) float progress;

- (instancetype)initWithDoneColor:(UIColor *)doneColor andUndoneColor:(UIColor *)undoneColor size:(CGSize)size;
@end
