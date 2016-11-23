//
//  CharacterCollectionViewCell.m
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/23/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import "CharacterCollectionViewCell.h"
#import "PhotoController.h"

@implementation CharacterCollectionViewCell

- (void)setPhotoData:(NSDictionary *)photoData{
    _photoData = photoData;
    
    [PhotoController imageForPhotoData:photoData completion:^(UIImage *image) {
        self.photoView.image = image;
    }];
}

@end
