//
//  CollectionViewController.m
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/21/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import "CollectionViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"characterCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshCharacters];
}

- (void)refreshCharacters {
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // compute url parameters
    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    double milliseconds = seconds*1000;
    NSString *timestamp = [[NSString alloc] initWithFormat:@"%.0f", milliseconds];
    NSString *privateKey = @"73388c4da7de1c82c718936ec003923a77d3d3bf";
    NSString *apiKey = @"623e50c12a8b0e6bbb058462369842d0";
    NSString *timestampAndAPIKey = [[NSString alloc] initWithFormat:@"%@%@%@", timestamp, privateKey, apiKey];
    NSString *hash = [self generateMD5:timestampAndAPIKey];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters?ts=%@&apikey=%@&hash=%@", timestamp, apiKey, hash];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    
    NSURLSessionDownloadTask *charactersTask = [session downloadTaskWithRequest:requst completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *charctersData = [[NSData alloc]initWithContentsOfURL:location];
        NSDictionary *charactersResponseDict = [NSJSONSerialization JSONObjectWithData:charctersData options:kNilOptions error:nil];
        self.charactersArray = [charactersResponseDict valueForKeyPath:@"data.results"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [charactersTask resume];
}

- (NSString *) generateMD5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
