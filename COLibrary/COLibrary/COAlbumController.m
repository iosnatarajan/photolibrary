#import "COAlbumController.h"

#import "COAssetsController.h"

@interface COAlbumController ()

@end

@implementation COAlbumController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self)
    {
        self.title = @"Select an Album";

        _albumsArray = [[NSMutableArray alloc] init];

    }
    
    return self;
}

-(void)reloadTableView
{
	[self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    library = [[ALAssetsLibrary alloc] init];

    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [_albumsArray addObject:group];
        } else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
        
        NSLog(@"errorMessage :%@", errorMessage);
    };
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:failureBlock];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _albumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_albumsArray count])
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
            
            cell.textLabel.text = @"No albums.";
        }
        
        return cell;
    }
    
    NSString * CellIdentifier = [@"" stringByAppendingFormat:@"Cell"];
    
    UITableViewCell * cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup * g = (ALAssetsGroup*)[_albumsArray objectAtIndex:indexPath.row];
    
    NSLog(@"ALAssetsGroup :%@", g);
    
    [g setAssetsFilter:[ALAssetsFilter allAssets]];
        
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], [g numberOfAssets]];
    
    [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    COAssetsController * assets = [[COAssetsController alloc] initWithStyle:UITableViewStylePlain];
    
    assets.type = libraryType_set;
    
    assets.assetGroup = [_albumsArray objectAtIndex:indexPath.row];
    
    assets.title = [assets.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    
    [self.navigationController pushViewController:assets animated:YES];
    
    assets = nil;
}

@end
