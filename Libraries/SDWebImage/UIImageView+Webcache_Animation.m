//
//  UIImageView+Webcache_Animation.m
//  Tubesmix
//
//  Created by Cherif YAYA on 17/03/13.
//  Copyright (c) 2013 Cherif YAYA. All rights reserved.
//

#import "UIImageView+Webcache_Animation.h"

@implementation UIImageView (Webcache_Animation)

-(void) setImageWithURL:(NSURL *)url usingActivityIndicatorStyle : (UIActivityIndicatorViewStyle) activityStyle animated:(BOOL)animated {
    
    [self setImageWithURL:url placeholderImage:nil usingActivityIndicatorStyle:activityStyle animated:animated];
}

-(void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage animated:(BOOL)animated duration:(NSTimeInterval)duration{
    __block UIImageView *weakSelf = self;
    [self setImageWithURL:url placeholderImage:placeholderImage
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                         if (image && cacheType == SDImageCacheTypeNone && animated)
                         {
                             weakSelf.alpha = 0.0;
                             [UIView transitionWithView:weakSelf duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [weakSelf setAlpha:1]; } completion:nil];
                         }
                     }];
}

-(void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage usingActivityIndicatorStyle : (UIActivityIndicatorViewStyle) activityStyle animated:(BOOL)animated {
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityStyle];
    activityIndicator.hidesWhenStopped = YES;
    [self addSubview:activityIndicator];
    activityIndicator.frame = self.bounds;
    [activityIndicator startAnimating];
    
    __block UIImageView *weakSelf = self;
    [self setImageWithURL:url placeholderImage:placeholderImage
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [activityIndicator removeFromSuperview];
                    if (image && cacheType == SDImageCacheTypeNone && animated)
                    {
                        [weakSelf setAlpha:0.0];
                        [UIView transitionWithView:weakSelf duration:2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ [weakSelf setAlpha:1]; } completion:nil];
                    }
                }];
}

@end
