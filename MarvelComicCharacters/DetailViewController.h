//
//  DetailViewController.h
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/26/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

