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
    
    [self setupGestures];
}

- (void)setupGestures {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [longPressGestureRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSArray *urls = [self.characterData valueForKey:@"urls"];
        NSString *urlString = [urls[0] valueForKey:@"url"];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
        svc.delegate = self;
        [self presentViewController:svc animated:true completion:nil];
    }
}

@end
