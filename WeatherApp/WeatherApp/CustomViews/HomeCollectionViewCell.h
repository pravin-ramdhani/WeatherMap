//
//  HomeCollectionViewCell.h
//  WeatherApp
//
//  Created by Pravin on 08/07/17.
//  Copyright © 2017 WeatherMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityList+CoreDataClass.h"

@protocol deleteCellProtocol <NSObject>

-(void)deleteCell:(id)cellToDelete;

@end

@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthBtnDelete;
@property (strong, nonatomic) CityList *city;
@property (weak, nonatomic) id <deleteCellProtocol> delegate;

-(void)setDataOnCell:(BOOL)isDelete;

- (IBAction)btnDeleteCityPressed:(id)sender;

@end
