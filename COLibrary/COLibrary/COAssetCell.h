#import <UIKit/UIKit.h>

#define GRID_X_SPACE        4.0

#define GRID_Y_SPACE        4.0

#define GRID_HEIGHT         75.0

#define GRID_WIDTH          75.0

#define GRIDS_IN_ROW        4

@interface COAssetCell : UITableViewCell

-(void)addAssetsOnCell:(NSArray *)assets atIndexPath:(NSIndexPath *)indexPath andTarget:(id)target;

@end
