//
//  FlickrViewCell.h
//  Flickr
//
//  Created by iOSIntern on 2017/7/14.
//  Copyright © 2017年 iOSIntern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong,nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSCache* imageCache;
@end
