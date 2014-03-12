#import "COAssetsController.h"

#import "COAssetCell.h"

#import "COAssetButton.h"

@interface COAssetsController ()

@end

@implementation COAssetsController

@synthesize assetGroup = _assetGroup;

@synthesize type = _type;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (_type == libraryType_media)
        {
            UISegmentedControl * segmentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Photos",@"Videos", nil]];
            
            segmentControl.tintColor = [UIColor colorWithRed:88.0/255.0 green:196.0/255.0 blue:217.0/255.0 alpha:1.0];
            
            segmentControl.selectedSegmentIndex = lastIndex =  (isVideo)?1:0;
            
            [segmentControl addTarget:self action:@selector(toogleFilter:) forControlEvents:UIControlEventValueChanged];
            
            NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                         [UIColor whiteColor], UITextAttributeTextColor,
                                         nil];
            
            [segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
            
            NSDictionary * highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            
            [segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
            
            segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
            
            self.navigationItem.titleView = segmentControl;
            
            segmentControl = nil;
            
            UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(doneSelection)];
            
            self.navigationItem.rightBarButtonItem = right;
            
            right = nil;
        }
        else
        {
            self.title = @"Pick a photo";
        }
    }
    
    return self;
}

-(void)doneSelection
{
    NSLog(@"numberOfSelectedAssets :%d", [self numberOfSelectedAssets]);
}

-(void)toogleFilter:(id)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    
    if (lastIndex != index)
    {
        isVideo = (index == 0)?NO:YES;
        
        [self.tableView reloadData];
        
        [self.tableView setContentOffset:(isVideo)?videoOffset:photoOffset animated:NO];
    }
    
    lastIndex = index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = [_assetGroup valueForProperty:ALAssetsGroupPropertyName];
    
    if (!_photoAssetsArray)
    {
        _photoAssetsArray = [[NSMutableArray alloc] init];
        
        if (_type == libraryType_media)
            _videoAssetsArray = [[NSMutableArray alloc] init];
        
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset * result, NSUInteger index, BOOL *stop) {
            
            if (result)
            {
                COAssetButton * button = [COAssetButton buttonWithType:UIButtonTypeCustom];
                
                button.tag = 0;
                
                [button addAsset:result];
                
                if ([result valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto)
                    [_photoAssetsArray addObject:button];
                else if ([result valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo)
                    [_videoAssetsArray addObject:button];
                
                button = nil;
            }
            else
            {
                [self.tableView reloadData];
                
                if ([self.tableView numberOfRowsInSection:[self.tableView numberOfSections]-1])
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:[self.tableView numberOfSections]-1]-1 inSection:[self.tableView numberOfSections]-1] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        };
                
        [_assetGroup setAssetsFilter:(_type == libraryType_media)?[ALAssetsFilter allAssets]:[ALAssetsFilter allPhotos]];
        
        [_assetGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isVideo)
        videoOffset = scrollView.contentOffset;
    else
        photoOffset = scrollView.contentOffset;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GRID_HEIGHT + GRID_Y_SPACE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    NSArray * _assetsArray = (isVideo)?_videoAssetsArray:_photoAssetsArray;
    
    if ([_assetsArray count] % GRIDS_IN_ROW == 0)
    {
        rows = [_assetsArray count] / GRIDS_IN_ROW;
    }
    else
    {
        rows = ([_assetsArray count] / GRIDS_IN_ROW) + 1;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * _assetsArray = (isVideo)?_videoAssetsArray:_photoAssetsArray;

    if (![_assetsArray count])
    {
        static NSString * emptyCell = @"emptyCell";
        
        UITableViewCell * cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:emptyCell];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:emptyCell];
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            cell.textLabel.textColor = [UIColor whiteColor];
            
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
            
            cell.textLabel.text = @"No images.";
        }
        
        return cell;
    }
    
    NSString * CellIdentifier = [@"" stringByAppendingFormat:@"Cell"];
    
    COAssetCell * cell = (COAssetCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[COAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSRange range = NSMakeRange(indexPath.row * GRIDS_IN_ROW, GRIDS_IN_ROW);
    
    if (range.location + range.length > _assetsArray.count)
        range.length = _assetsArray.count % GRIDS_IN_ROW;
    
    NSArray * assets = [_assetsArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    [cell addAssetsOnCell:assets atIndexPath:indexPath andTarget:self];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return;
}

-(int)numberOfSelectedAssets
{
    int count = 0;
    
    for (COAssetButton * asset in _photoAssetsArray)
    {
        if (asset.isSelectedAsset)
            count += 1;
    }
    
    for (COAssetButton * asset in _videoAssetsArray)
    {
        if (asset.isSelectedAsset)
            count += 1;
    }
    
    return count;
}

@end
