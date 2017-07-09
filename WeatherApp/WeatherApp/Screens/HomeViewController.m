//
//  HomeViewController.m
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import "HomeViewController.h"
#import "DataBaseManager.h"
#import "HomeCollectionViewCell.h"
#import "CityList+CoreDataClass.h"
#import "CityViewController.h"

@interface HomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource,deleteCellProtocol>{
    
    NSArray *arrCity;
    CityList *cityObj;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collViewCity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDelete;
@property (weak, nonatomic) IBOutlet UILabel *lblNoLocation;

@end

@implementation HomeViewController

#pragma mark - ViewDelegateMethods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.btnDelete setTitle:@"Delete"];
    [self fetchCityFromDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];
    [self.collViewCity.collectionViewLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

#pragma mark - FetchFromDB

-(void)fetchCityFromDB{
    DataBaseManager *databaseManager = [DataBaseManager sharedManager];
    [databaseManager fetchDataFromDBForEntity:@"CityList" withCompletionBlock:^(NSError *error, NSArray *result) {
        if (error) {
            
        }
        else if (result){
            arrCity = [NSArray arrayWithArray:result];
            [self.collViewCity reloadData];
            if (arrCity.count > 0) {
                [self.btnDelete setEnabled:YES];
                [self.btnDelete setTintColor:nil];
                self.lblNoLocation.hidden = YES;
                self.collViewCity.hidden = NO;

            }
            else{
                [self.btnDelete setEnabled:NO];
                [self.btnDelete setTintColor: [UIColor clearColor]];
                self.lblNoLocation.hidden = NO;
                self.collViewCity.hidden = YES;

            }
        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"loadCityVC"])
    {
        // Get reference to the destination view controller
        CityViewController *cityVC = [segue destinationViewController];
        [cityVC setCityObj:cityObj];
    }
}

#pragma mark - DeleteMethods

- (IBAction)btnDeletePressed:(id)sender {
    
    if ([self.btnDelete.title isEqualToString:@"Delete"]) {
        [self.btnDelete setTitle:@"Done"];
    }
    else{
        [self.btnDelete setTitle:@"Delete"];
    }
    [self.collViewCity reloadData];
}

-(void)deleteCell:(id)cellToDelete{
    
    HomeCollectionViewCell *cellHome = (HomeCollectionViewCell *)cellToDelete;
    [self showAlertMessage:[NSString stringWithFormat:@"you want to delete %@ from list",cellHome.city.cityname] withTitle:@"Are you sure?" withCell:cellHome];
}

-(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title  withCell:(HomeCollectionViewCell *)cellHome{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    if (cellHome) {
        UIAlertAction *yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        DataBaseManager *databaseManager = [DataBaseManager sharedManager];
                                        [databaseManager deleteFromDB:cellHome.city withCompletionBlock:^(NSError *error, BOOL success) {
                                            if (success) {
                                                [self fetchCityFromDB];
                                                [self showAlertMessage:@"" withTitle:@"Delete success" withCell:nil];
                                            }
                                        }];
                                        
                                    }];
        
        UIAlertAction *noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
    }
    else{
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        
        [alert addAction:okButton];
        
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrCity.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"homeCollectionViewCell";
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    CityList *city = [arrCity objectAtIndex:indexPath.row];
    cell.city = city;
    [cell setDataOnCell:[self.btnDelete.title isEqualToString:@"Done"] ? YES : NO];
    // return the cell
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collViewCity.frame.size.width, 50);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    cityObj = [arrCity objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"loadCityVC" sender:self];
}

@end
