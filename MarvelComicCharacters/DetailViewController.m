//
//  DetailViewController.m
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/26/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [PhotoController imageForPhotoData:[_characterData valueForKey:@"thumbnail"] completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    self.nameLabel.text = [self.characterData valueForKey:@"name"];
    self.descriptionLabel.text = [self.characterData valueForKey:@"description"];
}

@end
