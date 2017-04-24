#import "RNSimplePhotoView.h"

#import "RNSimplePhotoViewManager.h"

@implementation RNSimplePhotoViewManager

RCT_EXPORT_MODULE()

RCT_REMAP_VIEW_PROPERTY(source, imageSources, NSArray<RCTImageSource *>);
RCT_EXPORT_VIEW_PROPERTY(maxScaling, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(minScaling, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(minAlpha, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(maxExitDistance, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(minExitVelocity, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(onDidExit, RCTBubblingEventBlock)

- (UIView *)view{
    return [RNSimplePhotoView new];
}

@end

