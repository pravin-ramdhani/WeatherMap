//
//  MoreWeatherViewController.m
//  WeatherApp
//
//  Created by Swapnali on 09/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "MoreWeatherViewController.h"
#import "ServiceManager.h"
#import <MapKit/MapKit.h>
#import "MoreCollectionViewCell.h"

@interface MoreWeatherViewController (){

    NSMutableArray *arrWeather;
    NSMutableDictionary *dictWeather;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collViewWeather;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;

@end

@implementation MoreWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Forcast";
    
    [self fetchWeatherReport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    [self.collViewWeather.collectionViewLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

-(void)fetchWeatherReport{
    
    [self.activityInd startAnimating];
    ServiceManager *serviceManager = [ServiceManager sharedManager];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_cityObj.latitude, _cityObj.longitude);
    [serviceManager getForcastForCityForFiveDaysWithCoordinates:coordinate completionBlock:^(NSError *error, id responce) {
        
        if (error) {
            [self showAlertMessage:[error localizedDescription] withTitle:@"Error" andSuccess:YES];
        }
        else if (responce) {
            [self getRequiredDataFromJson:responce];
        }
    }];
}

-(void)getRequiredDataFromJson:(id)dictResponce{
    
    arrWeather = [[NSMutableArray alloc] init];
    
    for (NSDictionary *responce in [dictResponce valueForKey:@"list"]) {
        
        dictWeather = nil;
        dictWeather = [[NSMutableDictionary alloc] init];
        
        if ([[responce valueForKey:@"weather"] count] > 0) {
            [dictWeather setObject:[[[responce valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"] forKey:@"Description"];
        }
        if ([responce valueForKey:@"dt"]) {
            [dictWeather setObject:[self getDateFromEpochTime:[responce valueForKey:@"dt"]] forKey:@"Date"];
        }
        if ([[responce valueForKey:@"main"] valueForKey:@"temp"]) {
            [dictWeather setObject:[NSString stringWithFormat:@"%@ \u00B0C",[[responce valueForKey:@"main"] valueForKey:@"temp"]] forKey:@"Temperature"];
        }
        if ([[responce valueForKey:@"main"] valueForKey:@"pressure"]) {
            [dictWeather setObject:[NSString stringWithFormat:@"%@ hpa",[[responce valueForKey:@"main"] valueForKey:@"pressure"]] forKey:@"Pressure"];
        }
        if ([[responce valueForKey:@"main"] valueForKey:@"humidity"]) {
            [dictWeather setObject:[NSString stringWithFormat:@"%@ %%",[[responce valueForKey:@"main"] valueForKey:@"humidity"]] forKey:@"Humidity"];
        }
        if ([[responce valueForKey:@"wind"] valueForKey:@"speed"]) {
            [dictWeather setObject:[NSString stringWithFormat:@"%@ m/s",[[responce valueForKey:@"wind"] valueForKey:@"speed"]] forKey:@"Wind"];
        }
        if ([[responce valueForKey:@"clouds"] valueForKey:@"all"]) {
            [dictWeather setObject:[NSString stringWithFormat:@"%@",[[responce valueForKey:@"clouds"] valueForKey:@"all"]] forKey:@"Clouds"];
        }
        [arrWeather addObject:dictWeather];
    }    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collViewWeather reloadData];
        [self.activityInd stopAnimating];
    });
    
}

-(NSString *)getDateFromEpochTime:(NSString *)epochTime{
    
    // Convert NSString to NSTimeInterval
    NSTimeInterval seconds = [epochTime doubleValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm"];
    
    return [dateFormatter stringFromDate:epochNSDate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrWeather.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"moreCollectionViewCell";
    MoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDataOnCell:[arrWeather objectAtIndex:indexPath.row]];
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collViewWeather.frame.size.width, 120);
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
