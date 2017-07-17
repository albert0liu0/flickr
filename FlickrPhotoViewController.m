//
//  FlickrPhotoViewController.m
//  Flickr
//
//  Created by iOSIntern on 2017/7/13.
//  Copyright © 2017年 iOSIntern. All rights reserved.
//

#import "FlickrPhotoViewController.h"
#import "FlickrFetcher.h"
#import "FlickrViewCell.h"
#import "ImageViewController.h"
@interface FlickrPhotoViewController ()
@property (strong,nonatomic) NSOperationQueue* queue;
@property (strong,nonatomic) NSCache* imageCache;
@end

@implementation FlickrPhotoViewController

static NSString * const reuseIdentifier = @"prototypeCell";
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)fetchPhoto{
    NSURL* url=[FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSData* jsonResult=[NSData dataWithContentsOfURL:url];
    NSDictionary* propertyListResult=[NSJSONSerialization JSONObjectWithData:jsonResult options:0 error:NULL];
    self.photos=[propertyListResult valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self fetchPhoto];
    self.queue=[[NSOperationQueue alloc]init];
    self.imageCache=[[NSCache alloc] init];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (FlickrViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FlickrViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [self.queue addOperationWithBlock:^{
        cell.imageCache=self.imageCache;
        cell.imageURL=[FlickrFetcher URLforPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatSquare];}];
    // Configure the cell
    
    return cell;
}
-(void)prepareImageViewController:(ImageViewController*)ivc toDisplayPhoto:(NSDictionary*) photo{
    ivc.imageCache=self.imageCache;
    ivc.imageURL=[FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatOriginal];
    ivc.title=[photo valueForKeyPath:FLICKR_PHOTO_TITLE];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        if (indexPath){
            if ([segue.identifier isEqualToString:@"displayPhoto"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]){
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.photos[indexPath.row]];
                }
            }
        }
    }
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
