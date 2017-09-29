//
//  IdeaExplorerViewController.h
//  IdeaExplorer
//
//  Created by Stuart Mathews on 11/06/2010.
//  Copyright Stuart Mathews Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@interface IdeaExplorerViewController : UIViewController <UITableViewDelegate, 
										UINavigationControllerDelegate,
										CLLocationManagerDelegate,
										UITextViewDelegate,
										UIImagePickerControllerDelegate,
										UITextViewDelegate>
{
	
	MKMapView* mapView;
	UILabel* coords;
	UISegmentedControl* segControl;
	UIButton* btnCrypt;
	UITextField* message;
	CLLocationManager* locationManager;
	UILabel* currentStatus;
	UILabel* encryptedLocation;
	UIActivityIndicatorView* activity;
	Boolean readyToDecrypt;
	NSData* encryptedMessage;
	NSData* decryptedMessage;
	NSString* ourMessage;
	UIImagePickerController* imagePicker;
	UIImageView* imageView;
	UIBarButtonItem* getPictureButton;
	UITextView* textView;
	NSMutableArray* messages;
	
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;
@property( nonatomic, retain) IBOutlet UILabel* coords;
@property( nonatomic, retain) IBOutlet UISegmentedControl* segControl;
@property( nonatomic, retain) IBOutlet UIButton* btnCrypt;
@property( nonatomic, retain) IBOutlet UITextField* message;

@property( nonatomic, retain) CLLocationManager* locationManager;
@property( nonatomic, retain) IBOutlet UILabel* currentStatus;
@property( nonatomic, retain) IBOutlet UILabel* encryptedLocation;
@property( nonatomic) Boolean readyToDecrypt;
@property( nonatomic, retain) IBOutlet UIActivityIndicatorView* activity;
@property( nonatomic, retain) IBOutlet UIBarButtonItem* getPictureButton;
@property( nonatomic, retain) NSData* encryptedMessage;
@property( nonatomic, retain) NSData* decryptedMessage;
@property( nonatomic, retain) NSString* ourMessage;
@property( nonatomic, retain) IBOutlet UIImagePickerController* imagePicker;
@property( nonatomic, retain) IBOutlet UITextView* textView;
@property( nonatomic, retain) IBOutlet UIImageView* imageView;
@property( nonatomic, retain) IBOutlet UITableView* inboxView;
@property( nonatomic, retain) IBOutlet UIBarButtonItem* inboxBtn;
@property(nonatomic, retain) NSMutableArray* messages;


- (IBAction)hideInbox:(id) sender;
- (IBAction)switchModes:(id) sender;
- (IBAction)performCryptFunction:(id) sender;
-(IBAction) getPhoto:(id) sender;
- (void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation*) newLocation fromLocation:(CLLocation*) old;
- (NSData*) encryptMessage:(NSString*) message coordinates:(CLLocation*) coord;
- (NSData*) decryptMessage:(NSData*) message coordinates:(CLLocation*) coord;
- (NSData *)AES128EncryptWithKey:(NSString *)key toEncryptString:(NSString*) encryptMe;
- (NSData *)AES128DecryptWithKey:(NSString *)key toDecryptString:(NSString*) decryptMe;

@end

