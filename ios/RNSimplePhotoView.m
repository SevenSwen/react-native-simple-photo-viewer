#import <React/RCTComponent.h>
#import <React/RCTImageSource.h>
#import <UIKit/UIKit.h>

#import "RNSimplePhotoView.h"

#define screenHeight [[UIScreen mainScreen] bounds].size.height

@interface RNSimplePhotoView (){
    CGFloat alpha;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIPanGestureRecognizer *verticalPanGesture;

@end


@implementation RNSimplePhotoView

/////////////////////////////////////////////////////////////////
#pragma mark LifeCircle
/////////////////////////////////////////////////////////////////
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaultSettings];
        [self assemblySubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultSettings];
        [self assemblySubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self centering];
    [self updateZoomScaleForSize: self.frame.size];
}

- (void)dealloc{
    [self clearAll];
}

/////////////////////////////////////////////////////////////////
#pragma mark Constructor
/////////////////////////////////////////////////////////////////
- (void)setDefaultSettings{
    _maxScaling = 2.0;
    _minScaling = 0.5;
    _maxExitDistance = screenHeight / 4.;
    _minExitVelocity = 2000;
    _minAlpha = 0.5;
    
    self.verticalPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    self.verticalPanGesture.delegate = self;
    [self.verticalPanGesture setMinimumNumberOfTouches:1];
    [self.verticalPanGesture setMaximumNumberOfTouches:2];
    [self addGestureRecognizer:self.verticalPanGesture];
}

- (void)assemblySubviews{
    // create scrollView
    self.scrollView = [UIScrollView new];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    self.scrollView.delegate = self;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview: self.scrollView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[myView]|"
                                                                 options: 0
                                                                 metrics:nil
                                                                   views:@{@"myView" : self.scrollView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[myView]|"
                                                                 options: 0
                                                                 metrics:nil
                                                                   views:@{@"myView" : self.scrollView}]];
    
    //create ImageView
    self.imageView = [UIImageView new];
    [self.scrollView addSubview:self.imageView];
    self.imageView.clipsToBounds = YES;
}

/////////////////////////////////////////////////////////////////
#pragma mark RCT PROPERTIES
/////////////////////////////////////////////////////////////////
- (void)setImageSources:(NSArray<RCTImageSource *> *)imageSources{
    if ([imageSources isEqual:_imageSources])
        return;
    
    _imageSources = [imageSources copy];
    RCTImageSource *imageSource = imageSources.firstObject; // it's very stupid, but normal approach is very difficult.
    // See RCTImageView and RCTImageViewManager for more information
    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageSource.request.URL]];
    CGSize imageSize = self.image.size;
    
    CGRect frame = { {0,0}, imageSize };
    [self.imageView setFrame:frame];
    [self.imageView setImage:self.image];
    [self.scrollView setContentSize:imageSize];
}

- (void)setMaxScaling:(CGFloat)maxScaling{
    if (maxScaling == _maxScaling)
        return;
    
    _maxScaling = maxScaling;
}

- (void)setMinScaling:(CGFloat)minScaling{
    if (_minScaling == minScaling)
        return;
    
    _minScaling = minScaling;
}

- (void)setMinAlpha:(CGFloat)minAlpha{
    if (_minAlpha == minAlpha) {
        return;
    }
    
    _minAlpha = minAlpha;
}

- (void)setMaxExitDistance:(CGFloat)maxExitDistance{
    if (_maxExitDistance == maxExitDistance) {
        return;
    }
    
    _maxExitDistance = maxExitDistance;
}

- (void)setMinExitVelocity:(CGFloat)minExitVelocity{
    if (_minExitVelocity == minExitVelocity) {
        return;
    }
    
    _minExitVelocity = minExitVelocity;
}

/////////////////////////////////////////////////////////////////
#pragma mark Private Functions
/////////////////////////////////////////////////////////////////
- (void)updateZoomScaleForSize:(CGSize) size{
    CGSize imageSize = self.image.size;
    if (size.height > size.width) {
        self.scrollView.minimumZoomScale = size.width / imageSize.width * self.minScaling;
        self.scrollView.maximumZoomScale = size.height / imageSize.height * self.maxScaling;
    }else{
        self.scrollView.minimumZoomScale = size.height / imageSize.height * self.minScaling;
        self.scrollView.maximumZoomScale = size.width / imageSize.width * self.maxScaling;
    }
}

- (void)centering{
    CGSize size = self.frame.size;
    CGSize imageViewSize = self.imageView.frame.size;
    
    CGFloat newX = 0, newY = 0;
    if (imageViewSize.height < size.height) {
        newY = (size.height - imageViewSize.height) / 2.;
    }
    
    if (imageViewSize.width < size.width) {
        newX = (size.width - imageViewSize.width) / 2.;
    }
    
    [self.imageView setFrame: CGRectMake(newX, newY, imageViewSize.width, imageViewSize.height)];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect imageViewFrame = self.imageView.frame;
    if ((CGRectContainsPoint(imageViewFrame, point))) {
        return self.imageView;
    }
    
    return nil;
}

- (void) clearAll{
    [self removeConstraints: self.constraints];
    
    [self removeGestureRecognizer:self.verticalPanGesture];
    
    [self.imageView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self removeFromSuperview];
}

/////////////////////////////////////////////////////////////////
#pragma mark PanGestures
/////////////////////////////////////////////////////////////////
-(void)move:(UIPanGestureRecognizer*)panGestureRecognizer{
    CGFloat heightImageView = self.imageView.frame.size.height;
    CGFloat heightSelf = self.frame.size.height;
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    
    if (heightSelf >= heightImageView){
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            alpha = self.alpha;
        }
        
        CGPoint translation = [panGestureRecognizer translationInView:self];
        
        CGAffineTransform transform = CGAffineTransformTranslate(self.transform, 0, translation.y);
        self.transform = transform;
        
        [panGestureRecognizer setTranslation:CGPointZero inView:self];
        
        if (ABS(transform.ty) < self.maxExitDistance &&
            sqrtf(velocity.x * velocity.x + velocity.y * velocity.y) < self.minExitVelocity) {
            self.alpha = MAX(self.minAlpha, alpha - ABS(self.transform.ty / self.maxExitDistance));
        }else{
            self.verticalPanGesture.enabled = false;
            [UIView animateWithDuration:0.25
                             animations:^{
                                 if (transform.ty > 0) {
                                     self.transform = CGAffineTransformTranslate(self.transform, 0, screenHeight);
                                 }else{
                                     self.transform = CGAffineTransformTranslate(self.transform, 0, -screenHeight);
                                 }
                             } completion:^(BOOL finished) {
                                 [self clearAll];
                                 self.onDidExit(nil);
                             }];
        }
        
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.25
                                  delay:0
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:0
                                options:0
                             animations:^{
                                 self.transform = CGAffineTransformIdentity;
                                 self.alpha = alpha;
                             }
                             completion:^(BOOL finished) {
                             }];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    return fabs(velocity.y) > fabs(velocity.x);
}

/////////////////////////////////////////////////////////////////
#pragma mark UIScrollViewDelegate
/////////////////////////////////////////////////////////////////
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centering];
}

@end
