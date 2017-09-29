//
//  IdeaExplorerViewController.m
//  IdeaExplorer
//
//  Created by Stuart Mathews on 11/06/2010.
//  Copyright Stuart Mathews Inc. 2010. All rights reserved.
//

#import "IdeaExplorerViewController.h"
#import "Message.h"

@implementation IdeaExplorerViewController
@synthesize coords;
@synthesize mapView;
@synthesize segControl;
@synthesize btnCrypt;
@synthesize message;
@synthesize locationManager;
@synthesize currentStatus;
@synthesize encryptedLocation;
@synthesize activity;
@synthesize encryptedMessage;
@synthesize decryptedMessage;
@synthesize ourMessage;
@synthesize getPictureButton;
@synthesize imagePicker;
@synthesize imageView;
@synthesize inboxView;
@synthesize inboxBtn;
@synthesize messages;


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

	NSLog(@"cellForRowAtIndex");
	static NSString* myItentifyer = @"MyIdentifiyer";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:myItentifyer];
	if(cell == nil){
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:myItentifyer] autorelease];
	}
	
	//Message* msg = [[self messages] objectAtIndex:indexPath.row];
	cell.text = @"test";
	return cell;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (IBAction)hideInbox:(id) sender
{
	NSLog(@"hideInbox:sender called!");

	if ([[inboxBtn title] isEqualToString:@"Hide Inbox"]) {
		// Is this memory efficient? 
		[inboxView setHidden:YES];
		[inboxBtn setTitle:@"Show Inbox"];
	}else{
		[inboxBtn setTitle:@"Hide Inbox"];
		[inboxView setHidden:NO];
	}
	
	
	/*
	if ([[inboxBtn text] isEqual:@"Hide Inbox"]) {
		[inboxBtn setText:@"Show Inbox"];
		[inboxView setHidden:YES];
	}else{
		[inboxBtn setText:@"Hide Inbox"];
		[inboxView setHidden:NO];
	}
	*/
	
	
	
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo
{

	
	[[imagePicker parentViewController] dismissModalViewControllerAnimated:YES];
	[imagePicker release];

}

-(IBAction) getPhoto:(id) sender
{
	NSLog(@"getPhoto");
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:imagePicker animated:YES];
	
}
/* Gets the users currently typed in message from the UITextField */

- (IBAction)textFieldDidEndEditing:(UITextView*) textField
{
	ourMessage = [[NSString alloc] initWithString:message.text];
	
}

/* Performs the encryption on the inputed string and returns an encrypted NSData* object*/

- (NSData*) encryptMessage:(NSString*) theMessage coordinates:(CLLocation*) coord
{
	/* The key should resemble the usres current location coordianates.*/
	NSString* key = [[NSString alloc] initWithString:@"key"];
	NSData* encryptedData = [theMessage dataUsingEncoding:NSUTF8StringEncoding];	
	encryptedData = [encryptedData AES256EncryptWithKey:key];
	[key release];

	return encryptedData; // Does this needs to be released? When?

	
	
}

/* Decrypts the NSData block passed in and returns an unencrypted NSData block */
- (NSData*) decryptMessage:(NSData*) theMessage coordinates:(CLLocation*) coord
{

	NSString* key = [[NSString alloc] initWithString:@"key"];	
	NSData* encryptedData = [[NSData alloc] initWithData:theMessage];
	NSData* decryptedData  =  [[NSData alloc] initWithData:[encryptedData AES256DecryptWithKey:key]];
	[key release];
	[encryptedData release];
	return decryptedData;
	
}

/* Event thatr is called when the location manager detects a change in the user's current location*/
- (void) locationManager:(CLLocationManager*) manager didUpdateToLocation:(CLLocation*) newLocation fromLocation:(CLLocation*) old{
	NSLog(@"Location Changed");
	//currentStatus.text = @"Current position determined.";
	currentStatus.text = @"Ready.";
	coords.text = [NSString stringWithFormat:@"lat: %f long: %f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
	[activity stopAnimating];
	[activity setHidden:TRUE];//this is not how it should be done.
	
	

}

/* The encrypt/decrypt button is pressed and then handled by this function*/

- (IBAction)performCryptFunction:(id) sender
{
	
	// Perform the en/de-cryption on the message based on the coords.
	
	// Make sure that the user has entered a message
	if ([ourMessage length ] == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Need Message" message:@"You have not entered a message to encrypt" delegate:nil cancelButtonTitle:@"Ok, I'll add one" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	// Determine which state the button is in - this is dependant on the UISegmentedControl that sets the buttons text.
	
	if ([btnCrypt.titleLabel.text isEqual:@"Encrypt"]) {
		NSLog(@"Performing encryption:");
		encryptedLocation.text = @"Encrypted at: ";
		encryptedLocation.text = [encryptedLocation.text stringByAppendingFormat:coords.text]; 

		[message setText:@""];
		[activity setHidden:FALSE];
		[activity startAnimating];
		currentStatus.text = @"Encrypting message...";
		// Encrypt Message here
			encryptedMessage = [[NSData alloc] initWithData:[self encryptMessage:ourMessage coordinates:locationManager.location]];
		currentStatus.text = @"Press to decrypt.";
		//currentStatus.text = [[NSString alloc] initWithFormat:@"Encrypted message:%s",encryptedMessage];
		[activity stopAnimating];
		[activity setHidden:TRUE];
		readyToDecrypt = TRUE;
		[btnCrypt setTitle:@"Decrypt" forState:UIControlStateNormal];
	}else {
		NSLog(@"Performing decryption:");
		// Ensure that something has been encrypted in order to decrypt:
		if (readyToDecrypt == FALSE) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Problem" message:@"You havent encrypted anything" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		[activity setHidden:FALSE];
		[activity startAnimating];
		currentStatus.text = @"Decrypting message...";
		[message setText:@"Decrypted Message goes here"];
		[activity stopAnimating];
		[activity setHidden:TRUE];
		// decrypt Message here
			decryptedMessage = [self decryptMessage:encryptedMessage coordinates:locationManager.location];
		currentStatus.text = [[NSString alloc] initWithData:decryptedMessage encoding:NSASCIIStringEncoding];
		
		[message setText:currentStatus.text];

		readyToDecrypt = FALSE;
		[btnCrypt setTitle:@"Encrypt" forState:UIControlStateNormal];
		[decryptedMessage release];
		[encryptedMessage release];
		
	}

	
}

/* Ensures that the keyboard is dismissed when the user presses the done button on the keyboard*/
-(BOOL) textFieldShouldReturn:(UITextView*)textfield
{
	ourMessage = textfield.text;
	[textfield resignFirstResponder];
	return YES;
}

/* Segmented control determines the text of the crypt button and thus what the crypt button will do when pressed indirectly.*/
-(IBAction) switchModes:(id) sender
{
	/*
	NSLog([segControl titleForSegmentAtIndex:[segControl selectedSegmentIndex]]);
	NSString* controlText = [[NSString alloc] initWithString:[segControl titleForSegmentAtIndex:[segControl selectedSegmentIndex]]];
	NSLog(controlText);
	[btnCrypt setTitle:controlText forState:UIControlStateNormal];
	 */
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Create the Location manager to track the and use the GPS.
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = 1;
	[locationManager startUpdatingLocation];
	
	// Set some initialization when the form loads
	
	encryptedLocation.text = @"";
	currentStatus.text = @"Locking onto your position...";
	coords.text = @"location unavailable.";
	[activity startAnimating];
	[activity hidesWhenStopped];
	
	// Set the keyboard delegte to this class, this is also done in IB
	
	[message setDelegate:self];
	
	
	// Configure the mapview:
	mapView.scrollEnabled = YES;
	mapView.showsUserLocation = YES;
	
	// Configure data:
	
	
	
	Message* msg1 = [[Message alloc] initWithMessage:@"Bruce" from:@"Message1OverAndOut" ];	
	Message* msg2 = [[Message alloc] initWithMessage:@"Jenny" from:@"Message2OverAndOut" ];	
	Message* msg3 = [[Message alloc] initWithMessage:@"Jessy" from:@"Message3OverAndOut" ];	
	
	messages = [[NSMutableArray alloc] initWithObjects:msg1,msg2,msg3,nil];
	
	

}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[locationManager release];
	[coords release];
	[mapView release];
	[segControl release];
	[btnCrypt release];
	[message release];
	[locationManager release];
	[currentStatus release];
	[encryptedLocation release];
	[activity release];
	[encryptedMessage release];
	[decryptedMessage release];
	[ourMessage release];
	
}



@end

// Encryption and decryption functions - 256bit AES Symetrical key encryption

@implementation NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or 
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesEncrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES256,
										  NULL /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
	// 'key' should be 32 bytes for AES256, will be null-padded otherwise
	char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
	
	// fetch key data
	[key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
	
	NSUInteger dataLength = [self length];
	
	//See the doc: For block ciphers, the output size will always be less than or 
	//equal to the input size plus the size of one block.
	//That's why we need to add the size of one block here
	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
	
	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES256,
										  NULL /* initialization vector (optional) */,
										  [self bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);
	
	if (cryptStatus == kCCSuccess) {
		//the returned NSData takes ownership of the buffer and will free it on deallocation
		return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
	}
	
	free(buffer); //free the buffer;
	return nil;
}

@end
