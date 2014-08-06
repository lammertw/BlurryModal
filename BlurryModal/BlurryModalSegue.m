//
//  BlurryModalSegue.m
//  BlurryModal
//
//  Created by Matthew Hupman on 11/21/13.
//  Copyright (c) 2013 Citrrus. All rights reserved.
//

#import "BlurryModalSegue.h"
#import "BlurryModal.h"

@interface BlurryModalSegue()

@property (strong, nonatomic) BlurryModal *blurryModal;

@end


@implementation BlurryModalSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self)
    {
        self.blurryModal = [[BlurryModal alloc] init];
    }
    
    return self;
}

- (void)perform
{
    [self.blurryModal presentViewController:self.destinationViewController parentViewController:self.sourceViewController];
}

@end
