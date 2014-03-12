#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface COAssetButton : UIButton
{
    @private
    
    UIImageView * _overlayView;
}

@property (nonatomic, retain) ALAsset * asset;

-(void)addAsset:(ALAsset *)asset;

-(BOOL)isSelectedAsset;

@end
