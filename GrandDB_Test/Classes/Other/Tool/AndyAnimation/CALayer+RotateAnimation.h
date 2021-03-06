//
//  CALayer+RotateAnimation.h
//  AndyAnimation_Test
//
//  Created by 李扬 on 16/8/1.
//  Copyright © 2016年 andyli. All rights reserved.
//

@interface CALayer (RotateAnimation)

- (void)andy_addRotateAnimationToAngle:(NSValue *)angel;

- (void)andy_addRotateAnimationToAngle:(NSValue *)angel completion:(void (^)(BOOL finished))completion;

- (void)andy_addRotateAnimationToAngle:(NSValue *)angel duration:(CGFloat)duration;

- (void)andy_addRotateAnimationToAngle:(NSValue *)angel duration:(CGFloat)duration completion:(void (^)(BOOL finished))completion;

- (void)andy_addRotateAnimationToAngle:(NSValue *)angel duration:(CGFloat)duration forKey:(NSString *)key completion:(void (^)(BOOL finished))completion;

@end
