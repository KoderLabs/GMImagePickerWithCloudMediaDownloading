//
//  GMCloudImageDownloadManager.h
//  Pods
//
//  Created by Dinesh Kumar on 1/18/18.
//
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

extern NSString * _Nonnull const GMCloudImageDownloadCompleteNotification;

@interface GMCloudImageDownloadManager : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary * _Nonnull mapAssetIDWithPHRequestID;

+ (instancetype _Nonnull )shared;

- (PHImageRequestID)startFullImageDownalodForAsset:(PHAsset * __nonnull)asset;

- (BOOL)isFullSizedImageAvailableForAsset:(PHAsset *_Nonnull)asset;

@end
