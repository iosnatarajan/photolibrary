#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>

@interface COAlbumController : UITableViewController
{
    @private
    
    NSMutableArray * _albumsArray;
    
    ALAssetsLibrary * library;
}

@end
