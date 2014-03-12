#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

typedef enum
{
    libraryType_set,
    
    libraryType_media,
    
    libraryType_profile
    
}LibraryType;

@interface COAssetsController : UITableViewController
{
    @private
    
    NSInteger lastIndex;

    NSMutableArray * _photoAssetsArray;

    NSMutableArray * _videoAssetsArray;

    BOOL isVideo;
    
    CGPoint videoOffset;
    
    CGPoint photoOffset;
}

@property (nonatomic) LibraryType type;

@property (nonatomic, retain) ALAssetsGroup * assetGroup;

@end
