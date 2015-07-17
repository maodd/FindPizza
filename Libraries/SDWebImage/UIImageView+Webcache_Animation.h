#import "UIImageView+Webcache.h"

@interface UIImageView (Webcache_Animation)

/**
  * Set the imageView `image` with an `url`.
  * and put an activity indicator while downloading the.
  *
  * The downloand is asynchronous and cached. And the image display can be animated.
  *
  * @param url The url for the image.
  * @param activityStyle THe UIActivityIndicatorViewStyle to use
  * @param animated Whether the image display is animated or not
  */
-(void) setImageWithURL:(NSURL *)url usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle animated:(BOOL)animated;


/**
 * Set the imageView `image` with an `url`.
 * and put an activity indicator while downloading the.
 *
 * The download is asynchronous and cached. And the image display can be animated.
 *
 * @param url The url for the image.
 * @param placeholderImage An optional image placeholder
 * @param activityStyle THe UIActivityIndicatorViewStyle to use
 * @param animated Whether the image display is animated or not
 */
-(void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage usingActivityIndicatorStyle:(UIActivityIndicatorViewStyle)activityStyle animated:(BOOL)animated;

-(void) setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage animated:(BOOL)animated duration:(NSTimeInterval)duration;
@end
