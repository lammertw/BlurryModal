//
//  BlurryModal.m
//  Pods
//
//  Created by Lammert Westerhoff on 06/08/14.
//
//

#import "BlurryModal.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImage+BlurredFrame/UIImage+ImageEffects.h>
#import <MZAppearance/MZAppearance.h>

static CGRect NormalizedWindowBoundsInView(UIView *sourceView)
{
    CGRect windowBounds = sourceView.window.bounds;
    
    // Normalize based on the orientation
    CGRect nomalizedWindowBounds = [sourceView convertRect:windowBounds fromView:nil];
    
    return nomalizedWindowBounds;
}

@interface BlurryImageView : UIImageView

@property (strong, nonatomic) id observer;

@end

@implementation BlurryImageView

-(id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        __weak typeof(self) weakSelf = self;
        self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
            CGRect frame = weakSelf.frame;
            frame.size = CGSizeMake(CGRectGetHeight(frame), CGRectGetWidth(frame));
            weakSelf.frame = NormalizedWindowBoundsInView(weakSelf.superview);
        }];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}

@end

@implementation BlurryModal

static UIImageOrientation ImageOrientationFromInterfaceOrientation(UIInterfaceOrientation orientation) {
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIImageOrientationDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIImageOrientationRight;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIImageOrientationLeft;
            break;
        default:
            return UIImageOrientationUp;
    }
}

+ (id)appearance
{
    return [MZAppearance appearanceForClass:[self class]];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        // Some sane defaults
        self.backingImageBlurRadius = @(20);
        self.backingImageSaturationDeltaFactor = @(.45f);
        
        [[[self class] appearance] applyInvocationTo:self];
    }
    
    return self;
}

- (void)presentViewController:(UIViewController *)controller parentViewController:(UIViewController *)parentViewController
{
    UIViewController* source = parentViewController;
    UIViewController* destination = controller;
    UIViewController* presented = destination;
    UIModalTransitionStyle transitionStyle = destination.modalTransitionStyle;
    
    if ([destination isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)destination;
        destination = navigationController.viewControllers.firstObject;
    }
    
    CGRect windowBounds = source.view.window.bounds;
    
    CGRect nomalizedWindowBounds = NormalizedWindowBoundsInView(source.view);
    
    UIGraphicsBeginImageContextWithOptions(windowBounds.size, YES, 0.0);
    
    [source.view.window drawViewHierarchyInRect:windowBounds afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.processBackgroundImage)
    {
        snapshot = self.processBackgroundImage(self, snapshot);
    }
    else
    {
        snapshot = [snapshot applyBlurWithRadius:self.backingImageBlurRadius.doubleValue tintColor:self.backingImageTintColor saturationDeltaFactor:self.backingImageSaturationDeltaFactor.doubleValue maskImage:nil];
    }
    
    snapshot = [UIImage imageWithCGImage:snapshot.CGImage scale:1.0 orientation:ImageOrientationFromInterfaceOrientation([UIApplication sharedApplication].statusBarOrientation)];
    
    destination.view.clipsToBounds = YES;
    
    UIImageView* backgroundImageView = [[BlurryImageView alloc] initWithImage:snapshot];
    
    CGRect frame;
    switch (transitionStyle) {
        case UIModalTransitionStyleCoverVertical:
            // Only the CoverVertical transition make sense to have an
            // animation on the background to make it look still while
            // destination view controllers animates from the bottom to top
            frame = CGRectMake(0, CGRectGetMinY(nomalizedWindowBounds) - nomalizedWindowBounds.size.height, nomalizedWindowBounds.size.width, nomalizedWindowBounds.size.height);
            break;
        default:
            frame = nomalizedWindowBounds;
            break;
    }
    backgroundImageView.frame = frame;
    
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
    
    [source presentViewController:presented animated:YES completion:nil];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = NormalizedWindowBoundsInView(source.view);
        }];
    } completion:nil];
}

@end
