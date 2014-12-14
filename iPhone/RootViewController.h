#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface RootViewController : UIViewController
{
	NSFetchedResultsController *fetchedResultsController;
}

- (IBAction)settings:(id)sender;



@end
