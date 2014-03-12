#import "ViewController.h"

#import "COLibraryController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton * but = [UIButton buttonWithType:UIButtonTypeCustom];
    
    but.backgroundColor = [UIColor whiteColor];
    
    [but setTitle:@"Open" forState:UIControlStateNormal];
    
    [but setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    but.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    
    but.clipsToBounds = YES;
    
    but.layer.cornerRadius = 5.0;
    
    [but addTarget:self action:@selector(showLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    but.center = self.view.center;
    
    [self.view addSubview:but];

    but = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLibrary
{
    COLibraryController * _coLib = [[COLibraryController alloc] initWithStyle:UITableViewStylePlain];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:_coLib];
    
    [self presentViewController:navController animated:YES completion:nil];
    
    navController = nil;
    
    _coLib = nil;
}

@end
