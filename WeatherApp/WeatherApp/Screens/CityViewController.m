//
//  CityViewController.m
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "CityViewController.h"
#import "ServiceManager.h"
#import <MapKit/MapKit.h>
#import "WeatherCollectionViewCell.h"
#import "MoreWeatherViewController.h"

@interface CityViewController ()<UICollectionViewDataSource>{
    
    NSMutableArray *arrWeather;
}

@property (weak, nonatomic) IBOutlet UILabel *lblCityCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblWheather;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInd;
@property (weak, nonatomic) IBOutlet UICollectionView *collViewWeather;

@end

@implementation CityViewController

#pragma mark - ViewDelegateMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.cityObj.cityname];
    
    UIBarButtonItem* moreBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMoreWeatherReport)];
    self.navigationItem.rightBarButtonItem = moreBtn;

    [self fetchWeatherReport];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resour[ces that can be recreated.
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    [self.collViewWeather.collectionViewLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

-(void)showMoreWeatherReport{
    
    [self performSegueWithIdentifier:@"moreWeatherReport" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"moreWeatherReport"])
    {
        // Get reference to the destination view controller
        MoreWeatherViewController *moreVC = [segue destinationViewController];
        [moreVC setCityObj:self.cityObj];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrWeather.count-1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"weatherCollectionViewCell";
    WeatherCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setDataOnCell:[arrWeather objectAtIndex:indexPath.row+1]];
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collViewWeather.frame.size.width, 50);
}

-(void)setDataOnView{
    
    self.lblCityCountry.text = [NSString stringWithFormat:@"Weather in %@, %@",self.cityObj.cityname, self.cityObj.country];
    
    NSDictionary *dictTemp = [arrWeather objectAtIndex:1];
    self.lblTemp.text = [dictTemp valueForKey:@"Temperature"];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm MMM dd"];
    NSString *result = [df stringFromDate:[NSDate date]];
    
    NSDictionary *dictDesc = [arrWeather objectAtIndex:0];
    self.lblWheather.text = [NSString stringWithFormat:@"%@ %@",result,[dictDesc valueForKey:@"description"]];
}

-(void)fetchWeatherReport{
    
    [self.activityInd startAnimating];
    ServiceManager *serviceManager = [ServiceManager sharedManager];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_cityObj.latitude, _cityObj.longitude);
    [serviceManager getTodaysForcastForCityWithCoordinates:coordinate completionBlock:^(NSError *error, id responce) {
        
        if (error) {
            [self showAlertMessage:[error localizedDescription] withTitle:@"Error" andSuccess:YES];
        }
        else if (responce) {
            [self getRequiredDataFromJson:responce];
        }
    }];
}

-(void)getRequiredDataFromJson:(id)responce{
    
    arrWeather = [[NSMutableArray alloc] init];
    
    if ([[responce valueForKey:@"weather"] count] > 0) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[[[responce valueForKey:@"weather"] objectAtIndex:0] valueForKey:@"description"] forKey:@"description"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"main"] valueForKey:@"temp"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ \u00B0C",[[responce valueForKey:@"main"] valueForKey:@"temp"]] forKey:@"Temperature"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"main"] valueForKey:@"pressure"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ hpa",[[responce valueForKey:@"main"] valueForKey:@"pressure"]] forKey:@"Pressure"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"main"] valueForKey:@"humidity"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ %%",[[responce valueForKey:@"main"] valueForKey:@"humidity"]] forKey:@"Humidity"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"wind"] valueForKey:@"speed"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@ m/s",[[responce valueForKey:@"wind"] valueForKey:@"speed"]] forKey:@"Wind"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"sys"] valueForKey:@"sunrise"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[self getDateFromEpochTime:[[responce valueForKey:@"sys"] valueForKey:@"sunrise"]] forKey:@"Sunrise"];
        [arrWeather addObject:dictDescr];
    }
    if ([[responce valueForKey:@"sys"] valueForKey:@"sunset"]) {
        NSDictionary *dictDescr = [NSDictionary dictionaryWithObject:[self getDateFromEpochTime:[[responce valueForKey:@"sys"] valueForKey:@"sunset"]] forKey:@"Sunset"];
        [arrWeather addObject:dictDescr];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setDataOnView];
        [self.collViewWeather reloadData];
        [self.activityInd stopAnimating];
    });
    
}

-(NSString *)getDateFromEpochTime:(NSString *)epochTime{
    
    // Convert NSString to NSTimeInterval
    NSTimeInterval seconds = [epochTime doubleValue];
    NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter stringFromDate:epochNSDate];
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
