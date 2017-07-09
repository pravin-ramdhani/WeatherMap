//
//  CityViewController.m
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import "DataBaseManager.h"

@interface LocationViewController ()<MKMapViewDelegate>{
    
    NSString *strCityName;
    NSString *strCountry;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic)MKPointAnnotation *pointAnnotation;

@end

@implementation LocationViewController

#pragma mark - ViewDelegateMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Add city";
    /* Create right button item. */
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(funcAddAddress)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - MapViewMethods

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    gestureRecognizer.enabled = NO;
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self addAnnotationToMapViewWithCoordinate:touchMapCoordinate];
}

- (IBAction)setMapType:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
        pav.animatesDrop = YES;
    }
    else
    {
        pav.annotation = annotation;
    }
    
    return pav;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        [self updateTitleForAnnotation:annotationView.annotation];
    }
}


-(void)addAnnotationToMapViewWithCoordinate:(CLLocationCoordinate2D)coordinate{
    
    // Add an annotation
    _pointAnnotation = [[MKPointAnnotation alloc] init];
    _pointAnnotation.coordinate = coordinate;
    _pointAnnotation.title = @"city not found";
    [self.mapView addAnnotation:_pointAnnotation];
    [self updateTitleForAnnotation:_pointAnnotation];
}

-(void)updateTitleForAnnotation:(MKPointAnnotation *)pointAnnotation{
    
    //this will work is there is internet connection available
    CLLocation *location = [[CLLocation alloc] initWithLatitude:pointAnnotation.coordinate.latitude longitude:pointAnnotation.coordinate.longitude];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            if ([placemark locality].length>0) {
                strCityName = [placemark locality];
            } else if ([placemark subLocality].length>0) {
                strCityName = [placemark subLocality];
            }else if ([placemark administrativeArea].length>0) {
                strCityName = [placemark administrativeArea];
            }else if ([placemark subAdministrativeArea].length>0) {
                strCityName = [placemark subAdministrativeArea];
            }else if ([placemark name].length>0) {
                strCityName = [placemark name];
            }
            strCountry = [placemark country];
            pointAnnotation.title = strCityName;
        }
    }];
}

-(void)funcAddAddress{
    
    if (_pointAnnotation && strCityName.length>0) {
        
        //check if city already exist
        
        DataBaseManager *databaseManager = [DataBaseManager sharedManager];
        
        if (![databaseManager checkIfCityAlreadyAdded:strCityName]) {
            [databaseManager addEntitytoDB:strCountry andcity:strCityName withCordinate:_pointAnnotation.coordinate withCompletionBlock:^(NSError *error, BOOL success) {
                if (error) {
                    [self showAlertMessage:@"City not found for selected region, please try again." withTitle:@"City not found." andSuccess:NO];
                }
                else{
                    [self showAlertMessage:@"" withTitle:@"City added successfully." andSuccess:YES];
                }
            }];
        }
        else{
            [self showAlertMessage:@"Please drak the annonatation to select another city." withTitle:@"City already bookmarked." andSuccess:NO];
        }
        
    } else {
        [self showAlertMessage:@"City not found for selected region, please try again." withTitle:@"City not found" andSuccess:NO];
    }
}

-(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title andSuccess:(BOOL)success{
    UIAlertController *alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction *okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    if (success)
                                        [self.navigationController popViewControllerAnimated:YES];
                                }];

    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
