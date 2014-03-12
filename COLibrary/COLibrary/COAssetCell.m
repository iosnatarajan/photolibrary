#import "COAssetCell.h"

#import "COAssetButton.h"

@implementation COAssetCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
    }
    
    return self;
}

-(void)addAssetsOnCell:(NSArray *)assets atIndexPath:(NSIndexPath *)indexPath andTarget:(id)target
{
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int i = 0;
        
    int prevTag = indexPath.row * GRIDS_IN_ROW;
        
    for(COAssetButton * button in assets)
    {
        @autoreleasepool
        {
            button.frame = CGRectMake(GRID_X_SPACE + (GRID_WIDTH + GRID_X_SPACE) * i, GRID_Y_SPACE, GRID_WIDTH, GRID_HEIGHT);
            
            button.tag = i + 1 + prevTag;
            
            [self.contentView addSubview:button];
        }
        
        i++;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
