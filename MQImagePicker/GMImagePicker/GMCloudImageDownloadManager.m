//
//  GMCloudImageDownloadManager.m
//  Pods
//
//  Created by Dinesh Kumar on 1/18/18.
//
//

#import "GMCloudImageDownloadManager.h"



NSString *const GMCloudImageDownloadCompleteNotification = @"GMCloudImageDownloadCompleteNotification";
static GMCloudImageDownloadManager *shared = nil;

@interface GMCloudImageDownloadManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary *mapAssetIDWithPHRequestID;

@end

@implementation GMCloudImageDownloadManager

+(instancetype)shared {
  if (shared == nil) {
    shared = [[self alloc] init];
  }
  return shared;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _mapAssetIDWithPHRequestID = [NSMutableDictionary new];
  }
  return self;
}

- (PHImageRequestID)startFullImageDownalodForAsset:(PHAsset *)asset {
   __block PHAsset *phAsset = asset;
  if (asset.mediaType == PHAssetMediaTypeImage) {
  //TDTLogInfo("GMImagePicker : Start iCould fetch for asset - %@", asset.localIdentifier);
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        [options setNetworkAccessAllowed:YES];
        [options setSynchronous:NO];

        __weak typeof(self) weakSelf = self;
        PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        //TDTLogInfo("GMImagePicker : Finished iCould fetch for asset - %@", asset.localIdentifier);
        weakSelf.mapAssetIDWithPHRequestID[phAsset.localIdentifier] = nil;
            if(imageData)
                [[NSNotificationCenter defaultCenter] postNotificationName:GMCloudImageDownloadCompleteNotification
                                                                object:weakSelf
                                                              userInfo:@{@"asset":phAsset}];
            else
                [[NSNotificationCenter defaultCenter] postNotificationName:GMCloudImageDownloadCompleteNotification
                                                                object:weakSelf
                                                              userInfo:info];
        }];
        self.mapAssetIDWithPHRequestID[asset.localIdentifier] = @(requestID);
        return requestID;
  }
  else if (asset.mediaType == PHAssetMediaTypeVideo){
      __weak typeof(self) weakSelf = self;
      PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
      options.version = PHVideoRequestOptionsVersionOriginal;
      //options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
      options.networkAccessAllowed = YES;
      PHImageRequestID requestID = [PHImageManager.defaultManager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
          weakSelf.mapAssetIDWithPHRequestID[phAsset.localIdentifier] = nil;
          
          if ([asset isKindOfClass:AVURLAsset.class]){
            [[NSNotificationCenter defaultCenter] postNotificationName:GMCloudImageDownloadCompleteNotification object:weakSelf userInfo:@{@"asset":phAsset}];
          }
          else
            [[NSNotificationCenter defaultCenter] postNotificationName:GMCloudImageDownloadCompleteNotification object:weakSelf userInfo:info];
      }];
      self.mapAssetIDWithPHRequestID[asset.localIdentifier] = @(requestID);
      return requestID;
  }
  else{
      return 0;
  }
}

- (BOOL)isFullSizedImageAvailableForAsset:(PHAsset *)asset {
  //TDTLogInfo("GMImagePicker : Checking is full sized image available for asset - %@", asset.localIdentifier);
  __block BOOL fullSizedImageDataAvaiable = NO;
  // I suspect even setSynchronous = YES, might execute the resultHandler
  // AFTER 'requestImageDataForAsset' call completes, hence making this
  // function broken
  __block BOOL isSynchronusFlagWorking = NO;
    
    if(asset.mediaType == PHAssetMediaTypeImage){
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        [options setNetworkAccessAllowed:NO];
        [options setSynchronous:YES];

        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        isSynchronusFlagWorking = YES;
        fullSizedImageDataAvaiable = imageData != nil;
        }];
    }
    else if(asset.mediaType == PHAssetMediaTypeVideo){
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.networkAccessAllowed = NO;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [PHImageManager.defaultManager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            isSynchronusFlagWorking = YES;
            fullSizedImageDataAvaiable = asset != nil;
            dispatch_semaphore_signal(semaphore);
        }];
         dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
  //TDTLogInfo("GMImagePicker : Is 'setSynchronous:YES' working as expected : %@",[NSNumber numberWithBool:isSynchronusFlagWorking]);
  //TDTLogInfo("GMImagePicker : Full sized image exits locally - %@, for asset - %@", [NSNumber numberWithBool:fullSizedImageDataAvaiable], asset.localIdentifier);
  return fullSizedImageDataAvaiable;
}
@end
