//
//  PhotoController.m
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/23/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import "PhotoController.h"

@implementation PhotoController

+ (void)imageForPhotoData:(NSDictionary*)photoData completion:(void(^)(UIImage *image))completion {
    
    if (photoData == nil || completion == nil) {
        NSLog(@"missing argument for imageForPhotoData");
        return;
    }
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@.%@", [photoData valueForKeyPath:@"path"], [photoData valueForKeyPath:@"extension"]];
    
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc]initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    
    [task resume];
}

@end
