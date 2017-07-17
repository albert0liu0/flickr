//
//  FlickrViewCell.m
//  Flickr
//
//  Created by iOSIntern on 2017/7/14.
//  Copyright © 2017年 iOSIntern. All rights reserved.
//

#import "FlickrViewCell.h"
@implementation FlickrViewCell
-(void)setImageURL:(NSURL*) imageURL{
    _imageURL = imageURL;
    //    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; // blocks main queue!
    [self startDownloadingImage];
}
- (void)startDownloadingImage
{
    
    if (self.imageURL)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.spinner startAnimating];});
        if([self.imageCache objectForKey:self.imageURL]){
            UIImage* image=[self.imageCache objectForKey:self.imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                self.backgroundView = [[UIImageView alloc] initWithImage:image];});
        }
        else{
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];  
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
        completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:self.imageURL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                [self.imageCache setObject:image forKey:self.imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.spinner stopAnimating];   
                    self.backgroundView = [[UIImageView alloc] initWithImage:image];});
                }
            }
        }];
        [task resume]; // don't forget that all NSURLSession tasks start out suspended!
        }
    }
}
-(void)prepareForReuse{
    [super prepareForReuse];
    [self.backgroundView removeFromSuperview];
    self.backgroundView=nil;
}
@end
