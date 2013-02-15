//
//  CPLMasterViewController.m
//  MyMapView
//
//  Created by Chris Lamb on 8/6/12.
//  Copyright (c) 2012 CPL Consulting. All rights reserved.
//

#import "CPLMasterViewController.h"

#import "CPLDetailViewController.h"
#import "CPLCountry.h"
#import "CPLAnnotationView.h"

@interface CPLMasterViewController () {
    NSMutableArray *_objects;
    NSArray *theIndexArray;
}
@end

@implementation CPLMasterViewController
@synthesize detailViewController = _detailViewController;
@synthesize countriesArrayDictionary = _countriesArrayDictionary;
@synthesize countriesArray = _countriesArray;
@synthesize indexArray = _indexArray;

@synthesize mySearchBar = _mySearchBar;
@synthesize searchString = _searchString;
@synthesize searchArray = _searchArray;
@synthesize filteredArray = _filteredArray;

#pragma mark - View lifecycle methods

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);

// Loads the ARRAY of DICTIONARIES plist from the main bundle 
    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSURL *countriesArrayURL = [mainBundle URLForResource:@"CountryPopulationGeoData" withExtension:@"plist"];
    NSURL *countriesArrayURL = [mainBundle URLForResource:@"ThinkLocalFirstDemo" withExtension:@"plist"];
    self.countriesArrayDictionary = [NSArray arrayWithContentsOfURL:countriesArrayURL];
    self.countriesArray = [NSArray arrayWithContentsOfURL:countriesArrayURL];
//    NSLog(@"The initial PLIST array is %@", self.countriesArrayDictionary);
    
// Create an arra of just country names
    NSMutableArray *countryNameMutableArray = [NSMutableArray arrayWithCapacity:300];
    for (int i=0; i<=([self.countriesArrayDictionary count]-1); i++) {
//        [countryNameMutableArray addObject:[[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Country"]];
        [countryNameMutableArray addObject:[[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Name"]];
        [self makeIndexedArray:self.countriesArrayDictionary];
    }
    self.countriesArray = [NSArray arrayWithArray:countryNameMutableArray];
//    NSLog(@"The array is %@", countryNamesArray);

    [self makeSectionsIndex:self.countriesArrayDictionary];
    [self makeIndexedArray:self.countriesArray withIndex:self.indexArray];
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (CPLDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
// Initializes properties with values
    self.searchString = [NSString stringWithFormat:@"CPL"];
    self.filteredArray = [NSMutableArray arrayWithCapacity:20];
    
// builds an array for the searchBar
    [self buildSearchArray];
}

- (void)viewDidUnload
{
    [self setMySearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - custom methods

- (NSArray *)makeIndexedArray:(NSArray *)arrayOfDictionaries {
//    NSLog(@"This will be an array with index, name & data");
    
    return arrayOfDictionaries;
}

- (NSArray *)makeSectionsIndex:(NSArray *)arrayOfDictionaries {
// Takes the array in question and creates an index for use in the tableview
    
// Creates a mutable set to read each letter only once    
    NSMutableSet *sectionsMutableSet = [NSMutableSet setWithCapacity:26];
    
// Reads each item's country & loads it's first letter into sections set
    for (int i=0; i<=[arrayOfDictionaries count]-1; i++) {
        NSDictionary *aDictionary = [arrayOfDictionaries objectAtIndex:i];
//        NSString *aCountry = [aDictionary objectForKey:@"Country"];
        NSString *aCountry = [aDictionary objectForKey:@"Name"];
        NSString *aLetter = [aCountry substringToIndex:1U];         //uses first letter of string
        [sectionsMutableSet addObject:aLetter];
    }
    
// Copies the mutable set into a set & then make a mutable array of the set
    NSSet *sectionsSet = [NSSet setWithSet:sectionsMutableSet];
    NSMutableArray *sectionsMutableArray = [[sectionsSet allObjects] mutableCopy];
    
//Now let's sort the array and make it inmutable
    NSArray *sortedArray = [[NSArray alloc] init];
    sortedArray = [sectionsMutableArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.indexArray = [NSArray arrayWithArray:sortedArray];

//    NSLog(@"The self.indexArray = %@", self.indexArray);
    return self.indexArray;                                                   
}

- (NSArray *)makeIndexedArray:(NSArray *)wordsArray withIndex:(NSArray *)indexArray {
    // Makes an array of index letters (sections) and letter word arrays (rows) for display in indexed tableview
//    NSLog(@"Making the indexed countries array");

    
    NSMutableArray *indexedCountriesArray = [NSMutableArray arrayWithCapacity:300];
    // Create a indexed array start with the first index letter
    for (int i=0; i <= ([indexArray count]-1); i++) {
        NSString *theIndexLetter = [indexArray objectAtIndex:i];
//                NSLog(@"the index letter = %@", theIndexLetter);
        NSMutableArray *aListOfStates = [NSMutableArray arrayWithCapacity:50];
        // Now page thru all of the states
        for (int j=0; j<=([wordsArray count]-1); j++) {
            NSString *firstLetterOfWord = [[wordsArray objectAtIndex:j] substringToIndex:1U];
            //            NSLog(@"first letter = %@", firstLetterOfWord);
            if ([theIndexLetter isEqualToString:firstLetterOfWord])
                [aListOfStates addObject:[wordsArray objectAtIndex:j]];
        }
        [indexedCountriesArray addObject:aListOfStates];
    }
    self.countriesArray = [NSArray arrayWithArray:indexedCountriesArray];
//    NSLog(@"The self.countriesArray = %@", self.countriesArray);
    
    return self.countriesArray;
}

- (void)buildSearchArray {
    
    int arrayCount = [self.countriesArrayDictionary count];
    self.searchArray = [NSMutableArray arrayWithCapacity:arrayCount];
    
// Builds an array of description fields for searching
    for (int i=0; i<=arrayCount-1;i++) {
        NSString *aDescription = [[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Description"];
        [self.searchArray addObject:aDescription];
    }
    
    NSLog(@"Just built this array for searching %@", self.searchArray);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
// Update the filtered array based on the search text and scope.	
	[self.filteredArray removeAllObjects]; // First clear the filtered array.
    
// Loop thru each decription field and look for a match    
	for (int i=0; i<=[self.searchArray count]-1; i++) {
        NSString *searchDescription = [self.searchArray objectAtIndex:i];
        NSString *searchName = [[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Name"];
        NSString *searchCategories = [[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Categories"];

        // Checks for empty search string
        if (self.searchString.length > 0) 
        {
// Searches in both description & name fileds for string match
            BOOL foundInDescription = [searchDescription rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            BOOL foundInName = [searchName rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            BOOL foundInCategories = [searchCategories rangeOfString:self.searchString options:NSCaseInsensitiveSearch].location == NSNotFound;
            if (!foundInDescription || !foundInName || !foundInCategories)
            {
                NSLog(@"The Business is #%d %@    %@", i, searchName, searchDescription);
                [self.filteredArray addObject:[self.searchArray objectAtIndex:i]];
                [self creatAnnotationPin:i];
            }            
        }
    }
}

- (void)creatAnnotationPin:(int)i {
// Create a single country dictionary and get it from the index countriesArrayDictionary  
    NSDictionary *theCountryDictionary = [[NSDictionary alloc] init];
    theCountryDictionary = [self.countriesArrayDictionary objectAtIndex:i]; 
    self.detailViewController.detailItem = theCountryDictionary;
    
// Annotations for each location picked
    // Sets latitude & longitude
    NSString *newLatitudeString = [theCountryDictionary objectForKey:@"Latitude"];
    NSString *newLongitudeString = [theCountryDictionary objectForKey:@"Longitude"];
    double newLatitude = [newLatitudeString doubleValue];
    double newLongitude = [newLongitudeString doubleValue];
    CLLocationCoordinate2D newCoordinates = CLLocationCoordinate2DMake(newLatitude, newLongitude);
    
    NSString *newName = [theCountryDictionary objectForKey:@"Name"];         
    NSString *newDescription = [theCountryDictionary objectForKey:@"Description"];
    
// Calls for a new Country object & adds it to the view & annotations array
    CPLCountry *aNewCountryPin = [[CPLCountry alloc] initWithCoordinates:newCoordinates placeName:newName description:newDescription];

    [self.detailViewController.myMapView addAnnotation:aNewCountryPin];  
    [self.detailViewController.mapAnnotations addObject:aNewCountryPin];
    
    NSLog(@"The new pin data is %@", aNewCountryPin); 
}

- (IBAction)searchButton:(UIBarButtonItem *)sender {
// Temporary way to load the searchString into this ViewController
    self.searchString = self.mySearchBar.text;
    NSLog(@"TRYing to search Now for ---> %@", self.searchString);
    [self filterContentForSearchText:self.searchString scope:@"All"];

    NSLog(@"Now we're searching BABY!");
}


#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *searchString = self.mySearchBar.text;
    NSLog(@"TRYing to search Now for this %@", searchString);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"Sections count = %d", [self.indexArray count]);
    return [self.indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"number of records = %d", self.countriesArray.count);

//    NSLog(@"Sections count = %d", [[self.countriesArray objectAtIndex:section] count]);
    return [[self.countriesArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

// Configures the cell text fields    
    NSString *cellTitle = [[self.countriesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//    NSString *cellTitle = [[self.countriesArray objectAtIndex:indexPath.row] objectForKey:@"Country"];    
    cell.textLabel.text = cellTitle;
    
//    NSString *website = [[self.countriesArray objectAtIndex:indexPath.row] objectForKey:@"Website"];
// Gather detail info from the original array countriesArrayDictionary
    NSString *countryInfo = [[self.countriesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    for (int i=0; i<=([self.countriesArrayDictionary count]-1); i++)
        if ([[[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Name"] isEqualToString:countryInfo]) {
            NSDictionary *theCountryDictionary = [[NSDictionary alloc] init];
            theCountryDictionary = [self.countriesArrayDictionary objectAtIndex:i]; 
            self.detailViewController.detailItem = theCountryDictionary;
//            NSLog(@"The country data is %@", theCountryDictionary);
            NSString *phone = [[NSString alloc] init];
            phone = [theCountryDictionary objectForKey:@"Phone"];
            cell.detailTextLabel.text = phone;   
        }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *countryInfo = [[NSString alloc] init];
    countryInfo = [[self.countriesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSLog(@"Info displayed is %@", countryInfo);
    //    self.detailViewController.detailItem = countryInfo;
    
// Gather detail info from the original array countriesArrayDictionary
    for (int i=0; i<=([self.countriesArrayDictionary count]-1); i++)
        //        if ([[[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Country"] isEqualToString:countryInfo]) {
        if ([[[self.countriesArrayDictionary objectAtIndex:i] objectForKey:@"Name"] isEqualToString:countryInfo]) {
            
// Drops a pin
            [self creatAnnotationPin:i];
        }    
}

/*
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    
    CPLAnnotationView *annotationView =
    (CPLAnnotationView *)[self.detailViewController.myMapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[CPLAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.indexArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
}


@end
