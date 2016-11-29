//
//  CollectionViewController.m
//  MarvelComicCharacters
//
//  Created by Christopher Bonuel on 11/21/16.
//  Copyright © 2016 Christopher Bonuel. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "CharacterCollectionViewCell.h"
#import <CommonCrypto/CommonDigest.h>

@interface CollectionViewController ()

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"characterCell";
static NSInteger const apiResultsLimit = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGestures];
    
    [self refreshCharacters];
}

- (void)setupGestures {
    UIScreenEdgePanGestureRecognizer *swipeRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    [swipeRight setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    UIScreenEdgePanGestureRecognizer *swipeLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    [swipeLeft setEdges:UIRectEdgeRight];
    [self.view addGestureRecognizer:swipeLeft];
}

- (void)handleRightSwipe:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded && self.apiPageNumber != 0) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)handleLeftSwipe:(UIGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self performSegueWithIdentifier:@"nextSegue" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"nextSegue"]) {
        UINavigationController * navController = [segue destinationViewController];
        CollectionViewController * collectionVC = [navController topViewController];
        collectionVC.apiPageNumber = self.apiPageNumber + 1;
    } else if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailViewController * detailVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.collectionView indexPathsForSelectedItems][0];
        detailVC.characterData = self.charactersArray[indexPath.row];
    }
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
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://gateway.marvel.com:443/v1/public/characters?offset=%ld&limit=%ld&ts=%@&apikey=%@&hash=%@", (long)[self offset], (long)apiResultsLimit, timestamp, apiKey, hash];
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

- (NSInteger)offset {
    return _apiPageNumber * apiResultsLimit;
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
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.charactersArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CharacterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.photoData = [self.charactersArray[indexPath.row] valueForKey:@"thumbnail"];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
