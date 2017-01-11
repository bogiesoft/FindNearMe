//
//  ViewController.m
//  Fill In
//
//  Created by Tony Shark on 1/10/17.
//  Copyright © 2017 Tony Shark. All rights reserved.
//
#import "InfoWindow.h"
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FSCalendar.h>
#import "SignInViewController.h"
#import "SignUpViewController.h"


@interface ViewController () <GMSMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    FSCalendar *calendar;
    InfoWindow *infoWindow;
    GMSCameraPosition *currentCameraPostion;
    BOOL shouldShowInfoWindow;
    GMSMarker *currentMarker;
    GMSMapView *mapview;
}
@end

@implementation ViewController {
    UILabel *_statusLabel;
}
- (void)viewWillAppear:(BOOL)animated{
   
    NSLog(@"Reload Content");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
    if(![defaults boolForKey:@"AUTH"]){
        SignInViewController* SignInController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
        if ([[UIDevice currentDevice].systemVersion integerValue] >= 8)
        {
            //For iOS 8
            SignInController.providesPresentationContextTransitionStyle = YES;
            SignInController.definesPresentationContext = YES;
            SignInController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else
        {
            //For iOS 7
            SignInController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        SignInController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        dispatch_after(0, dispatch_get_main_queue(), ^{
            
            [self presentViewController:SignInController animated:NO completion:nil];
        });
    }
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
  

    infoWindow = [[InfoWindow alloc] initWithFrame:CGRectMake(25, 210, 269, 90)];
    infoWindow.backgroundColor = [UIColor yellowColor];
    infoWindow.hidden = YES;
    [infoWindow.detail addTarget:self
                          action:@selector(didTapInfoWindowOfMarker)
                forControlEvents:UIControlEventTouchUpInside];
    [infoWindow.direction addTarget:self
                             action:@selector(openDirectionApp)
                   forControlEvents:UIControlEventTouchUpInside];

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:15];
    mapview = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapview.myLocationEnabled = YES;
    mapview.mapType = kGMSTypeNormal;
//    mapview.accessibilityElementsHidden = NO;
    mapview.settings.scrollGestures = YES;
    mapview.settings.zoomGestures = YES;
    //mapview.settings.compassButton = YES;
    mapview.settings.myLocationButton = YES;
    mapview.delegate = self;
    self.view = mapview;
    
   [mapview addSubview:infoWindow];
    
    calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,mapview.frame.size.height-250, mapview.frame.size.width, 150)];
    calendar.backgroundColor=[UIColor whiteColor];
    calendar.hidden=YES;
    [mapview addSubview:calendar];
    
    //Some dummies location
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000016,currentLocation.coordinate.longitude-0.000016);
    GMSMarker *marker1 = [GMSMarker markerWithPosition:position];
    marker1.title = @"Location title 1";
    marker1.snippet = @"Location address 1 here...";
    marker1.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker1.map = mapview;
    
    position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000326,currentLocation.coordinate.longitude-0.000326);
    GMSMarker *marker2 = [GMSMarker markerWithPosition:position];
    marker2.title = @"Location title 2";
    marker2.snippet = @"Location address 2 here...";
    marker2.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker2.map = mapview;
    
    
    position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000536,currentLocation.coordinate.longitude-0.000536);
    GMSMarker *marker3 = [GMSMarker markerWithPosition:position];
    marker3.title = @"Location title 3";
    marker3.snippet = @"Location address 3 here...";
    marker3.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker3.map = mapview;
    
    // Add status label, initially hidden.
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    _statusLabel.alpha = 0.0f;
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _statusLabel.backgroundColor = [UIColor blueColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    
    [mapview addSubview:_statusLabel];
//    currentCameraPostion = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
//                                                       longitude:currentLocation.coordinate.longitude
//                                                            zoom:15];
//   
//    GMSCameraPosition *camera1 = currentCameraPostion;
//    mapview.camera = camera1;
}

- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView {
    _statusLabel.alpha = 0.8f;
    _statusLabel.text = @"Rendering";
}

- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView {
    _statusLabel.alpha = 0.0f;
}
#pragma mark - GMSMapViewDelegate
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay {
    float opacity = (((float)arc4random()/0x100000000)*0.5f + 0.5f);
    ((GMSGroundOverlay *)overlay).opacity = opacity;

}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    //    NSLog(@"Did tap marker");
    
    currentMarker = marker;
    GMSCameraPosition *markerPosition = [GMSCameraPosition
                                         cameraWithLatitude:marker.position.latitude
                                         longitude:marker.position.longitude
                                         zoom:currentCameraPostion.zoom
                                         bearing:currentCameraPostion.bearing
                                         viewingAngle:currentCameraPostion.viewingAngle];
    [mapview animateToCameraPosition:markerPosition];
    if (fabs(currentCameraPostion.target.latitude - markerPosition.target.latitude) < 0.00001 &&
        fabs(currentCameraPostion.target.longitude == markerPosition.target.longitude) < 0.00001) {
        infoWindow.hidden = !infoWindow.hidden;
       //
    } else {
        infoWindow.hidden = YES;
        shouldShowInfoWindow = YES;
    }
    if(calendar){
        [calendar removeFromSuperview];
    }
    calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0,mapview.frame.size.height-250, mapview.frame.size.width, 150)];
    calendar.backgroundColor=[UIColor whiteColor];
    [mapview addSubview:calendar];
    
    //Update infoWindow
    infoWindow.title.text = marker.title;
    infoWindow.snippet.text = marker.snippet;
    // Animate to the marker
    [CATransaction begin];
    [CATransaction setAnimationDuration:3.f];  // 3 second animation
    
    GMSCameraPosition *camera =
    [[GMSCameraPosition alloc] initWithTarget:marker.position
                                         zoom:15
                                      bearing:50
                                 viewingAngle:60];
    [mapView animateToCameraPosition:camera];
    [CATransaction commit];
    return YES;
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    //Hide InfoWindow when tapped outside
    infoWindow.hidden = YES;
}

- (void)didTapInfoWindowOfMarker {
    NSLog(@"Tapped on info window");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"InfoWindow clicked." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)openDirectionApp {
    NSLog(@"Open direction app");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Button clicked." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    currentCameraPostion = position;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    if(gesture) {
        //Mapview is moved by gesture
        infoWindow.hidden = YES;
        [calendar removeFromSuperview];
    } else {
        //Mapview is moved by animation
        //Do nothing
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if (shouldShowInfoWindow) {
        infoWindow.hidden = NO;
       
    }
    shouldShowInfoWindow = NO;
}
#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude
                                                            longitude:currentLocation.coordinate.longitude
                                                                 zoom:15.0];
    [mapview animateToCameraPosition:camera];
    
    //Some dummies location
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000016,currentLocation.coordinate.longitude-0.000016);
    GMSMarker *marker1 = [GMSMarker markerWithPosition:position];
    marker1.title = @"Location title 1";
    marker1.snippet = @"Location address 1 here...";
    marker1.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker1.map = mapview;
    
    position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000326,currentLocation.coordinate.longitude-0.000326);
    GMSMarker *marker2 = [GMSMarker markerWithPosition:position];
    marker2.title = @"Location title 2";
    marker2.snippet = @"Location address 2 here...";
    marker2.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker2.map = mapview;
    
    
    position = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude-0.000536,currentLocation.coordinate.longitude-0.000536);
    GMSMarker *marker3 = [GMSMarker markerWithPosition:position];
    marker3.title = @"Location title 3";
    marker3.snippet = @"Location address 3 here...";
    marker3.icon = [UIImage imageNamed:@"Marker-Icon"];
    marker3.map = mapview;
    
    [locationManager stopUpdatingLocation];
    NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error){
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
                       
                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
