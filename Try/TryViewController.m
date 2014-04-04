//
//  TryViewController.m
//  Try
//
//  Created by neo on 14-3-13.
//
//

#import "TryViewController.h"
#import "StartScene.h"

@interface TryViewController ()

@end

@implementation TryViewController

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	NSLog(@"viewDidLoad, view w:%f, h:%f", self.view.frame.size.width, self.view.frame.size.height);
	NSLog(@"viewDidLoad, view b w:%f, h:%f", self.view.bounds.size.width, self.view.bounds.size.height);
//	self.rootView = [[SKView alloc] initWithFrame:self.view.frame];
//	NSLog(@"viewDidLoad, rootView w:%f, h:%f", self.rootView.frame.size.width, self.rootView.frame.size.height);
//	self.rootView.showsFPS = YES;
//	self.rootView.showsNodeCount = YES;
//	[self.view addSubview:self.rootView];
}
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	static BOOL start = NO;
	if (! start) {
		SKView *view = (SKView *)self.view;
		view.showsFPS = YES;
		view.showsNodeCount = YES;
		start = YES;
		StartScene *scene = [[StartScene alloc] initWithSize:self.view.bounds.size];
		scene.scaleMode = SKSceneScaleModeAspectFill;
		[view presentScene:scene];
	}
	NSLog(@"WillLayoutSubviews, view w:%f, h:%f", self.view.frame.size.width, self.view.frame.size.height);
	NSLog(@"WillLayoutSubviews, view b w:%f, h:%f", self.view.bounds.size.width, self.view.bounds.size.height);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
