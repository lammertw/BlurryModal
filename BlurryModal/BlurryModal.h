//
//  BlurryModal.h
//  Pods
//
//  Created by Lammert Westerhoff on 06/08/14.
//
//

#import <UIKit/UIKit.h>


@class BlurryModal;

typedef UIImage*(^ProcessBackgroundImage)(BlurryModal* blurryModal, UIImage* rawImage);

@interface BlurryModal : NSObject

@property (nonatomic, copy) ProcessBackgroundImage processBackgroundImage;

@property (nonatomic) NSNumber* backingImageBlurRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSNumber* backingImageSaturationDeltaFactor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor* backingImageTintColor UI_APPEARANCE_SELECTOR;

+ (id)appearance;

- (void)presentViewController:(UIViewController *)controller parentViewController:(UIViewController *)parentViewController;

@end
