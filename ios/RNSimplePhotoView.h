#import <React/RCTView.h>

@class RCTImageSource;
@interface RNSimplePhotoView : RCTView<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSArray<RCTImageSource *> *imageSources;
@property (nonatomic, copy) RCTBubblingEventBlock onDidExit;
@property (nonatomic, assign) CGFloat maxScaling;
@property (nonatomic, assign) CGFloat minScaling;
@property (nonatomic, assign) CGFloat minAlpha;
@property (nonatomic, assign) CGFloat maxExitDistance;
@property (nonatomic, assign) CGFloat minExitVelocity;

@end
