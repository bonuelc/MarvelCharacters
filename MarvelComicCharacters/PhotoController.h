//
//  PhotoController.h
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/23/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+ (void)imageForPhotoData:(NSDictionary*)photoData completion:(void(^)(UIImage *image))completion;

@end
