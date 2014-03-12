#import "COAssetButton.h"

@implementation COAssetButton

@synthesize asset = _asset;

-(void)addAsset:(ALAsset *)asset
{
    _asset = asset;
    
    [self addTarget:self action:@selector(assetTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setImage:[UIImage imageWithCGImage:[_asset thumbnail]] forState:UIControlStateNormal];
    
    _overlayView = [[UIImageView alloc] init];
    
    _overlayView.frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
    
    _overlayView.image = [UIImage imageNamed:@"Overlay.png"];
    
    _overlayView.hidden = YES;
    
    _overlayView.userInteractionEnabled = NO;
    
    [self addSubview:_overlayView];
}

-(void)assetTapped
{
    _overlayView.hidden = !_overlayView.hidden;
}

-(BOOL)isSelectedAsset
{
    return !_overlayView.hidden;
}

@end
