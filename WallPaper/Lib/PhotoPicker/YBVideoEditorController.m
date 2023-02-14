//
//  YBVideoEditorController.m
//  EnglishVideoStudio
//
//  Created by liQi on 2019/8/6.
//  Copyright © 2019 优贝科技. All rights reserved.
//

#import "YBVideoEditorController.h"
#import "ICGVideoTrimmerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
//#import <SXVideoEnging/SXVideoEnging.h>
#import "TZImageManager.h"

@interface YBVideoEditorController ()<ICGVideoTrimmerDelegate>

@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;

@property (weak, nonatomic) IBOutlet ICGVideoTrimmerView *trimmerView;
@property (weak, nonatomic) IBOutlet UIView *videoPlayer;
@property (weak, nonatomic) IBOutlet UIView *videoLayer;
@property (weak, nonatomic) IBOutlet UIButton *heightBtn;
@property (weak, nonatomic) IBOutlet UIButton *widthBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (strong, nonatomic) NSString *tempVideoPath;
@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) AVAsset *asset;

@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;

@property (assign, nonatomic) BOOL restartOnPlay;

@property (nonatomic, assign) CGFloat needVideoTime;
@property (nonatomic, assign) CGFloat needVideoHeight;
@property (nonatomic, assign) CGFloat needVideoWeight;

@property (nonatomic) float lastVolume;

@end

@implementation YBVideoEditorController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    YBVideoEditModel *videoEditModel = [TZImageManager manager].yb_videoEditModel;
//    self.needVideoHeight = videoEditModel.needVideoHeight?:300;
//    self.needVideoWeight = videoEditModel.needVideoWeight?:SCREEN_WIDTH;
//    self.needVideoTime = videoEditModel.needVideoTime;
//    
//    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];
//    [self setupNav];
//    [self setupBtns];
//    [self setupPlay];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    [self stopPlaybackTimeChecker];
//}
//
//- (void)dealloc
//{
//    
//}
//
//#pragma mark - Event
//
//- (IBAction)onClickHeightBtn:(UIButton *)sender
//{
//    if (self.heightBtn.selected) {
//        return;
//    }
//    [self setupBtn:self.heightBtn selected:YES];
//    [self setupBtn:self.widthBtn selected:NO];
//    [self changePlayerLayerFrame];
//}
//
//- (IBAction)onClickWidthBtn:(UIButton *)sender
//{
//    if (self.widthBtn.selected) {
//        return;
//    }
//    [self setupBtn:self.widthBtn selected:YES];
//    [self setupBtn:self.heightBtn selected:NO];
//    [self changePlayerLayerFrame];
//}
//
//- (IBAction)onClickTimeLbl:(UIButton *)sender
//{
//    self.audioBtn.selected = !self.audioBtn.selected;
//    [self setupBtn:self.audioBtn selected:self.audioBtn.selected];
//    if (self.audioBtn.selected) {
//        self.lastVolume = self.player.volume;
//        self.player.volume = 0;
//    }
//    else {
//        self.player.volume = self.lastVolume;
//    }
//}
//
//- (void)onClickDone
//{
//    AVURLAsset *urlAsset = (AVURLAsset*)self.asset;
//    NSURL *inPutUrl = urlAsset.URL;
//    NSString *outPutpath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%dMov.mp4",arc4random() % 1000]];
//    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutpath];
//    
//    AVAssetTrack *clipVideoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize videoSize = clipVideoTrack.naturalSize;
//    SXVideoCompositor *dvVideoCompositor = [[SXVideoCompositor alloc] init:inPutUrl output:outPutUrl];
//    [dvVideoCompositor setOutputSize:CGSizeMake(self.needVideoWeight, self.needVideoHeight)];
//    
//    if (self.audioBtn.selected) {
//        // 静音
//        [dvVideoCompositor setOutputVolume:0];
//    }
//    else {
//        [dvVideoCompositor setOutputVolume:clipVideoTrack.preferredVolume];
//    }
//    CGFloat videoWidth = self.needVideoHeight == 0 ? videoSize.width:self.needVideoWeight;
//    CGFloat videoHeight = self.needVideoHeight == 0? videoSize.height:self.needVideoHeight;
//    
//    CMTime start = CMTimeMakeWithSeconds(self.startTime, self.player.currentTime.timescale);
//    CMTime duration = CMTimeMakeWithSeconds(self.stopTime - self.startTime, self.player.currentTime.timescale);
//    CMTimeRange range = CMTimeRangeMake(start, duration);
//    
//    [dvVideoCompositor setOutputRange:range];
//    
//    CGPoint moveCenter = CGPointMake(videoWidth / 2, videoHeight / 2);
//    CGPoint videoCenter = CGPointMake(videoSize.width / 2, videoSize.height / 2);
//    CGAffineTransform t = clipVideoTrack.preferredTransform;
//    
//    if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
//       (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)) {
//        CGFloat width = videoSize.height;
//        videoSize.height = videoSize.width;
//        videoSize.width = width;
//    }
//    
//    CGFloat viewScale = 0.0;
//    if (self.heightBtn.selected) {
//        viewScale = videoHeight / videoSize.height;
//        
//    } else {
//        viewScale = videoWidth / videoSize.width;
//    }
//    
//    t = CGAffineTransformScale(t, viewScale, viewScale);
//    t.tx = moveCenter.x;
//    t.ty = moveCenter.y;
//    t = CGAffineTransformTranslate(t,  -videoCenter.x, -videoCenter.y);
//    [dvVideoCompositor setOutputTransform:t];
//    
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
//    [SVProgressHUD showWithStatus:@"正在处理"];
//    
//    [dvVideoCompositor finish:VIDEO_EXPORT_PRESET_HIGH finishHandle:^(BOOL success) {
//        NSLog(@"成功了么？");
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (success) {
//                NSLog(@"这个成功了么？%@",outPutUrl.path);
//                [SVProgressHUD dismiss];
//                
//                AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:outPutUrl options:nil];
//                AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//                
//                assetGen.appliesPreferredTrackTransform = YES;
//                CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//                NSError *error = nil;
//                CMTime actualTime;
//                CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//                UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
//                CGImageRelease(image);
//                
//                YBVideoEditModel *videoEditModel = [TZImageManager manager].yb_videoEditModel;
//                if (videoEditModel.didSelectVideo) {
//                    videoEditModel.didSelectVideo(videoImage, outPutUrl.path);
//                }
//                [TZImageManager manager].yb_videoEditModel = nil;
//                
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            }
//            else {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"导出失败！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//        });
//    }];
//}
//
//#pragma mark - ICGVideoTrimmerDelegate
//
//- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime
//{
//    _restartOnPlay = YES;
//    [self.player pause];
//    self.isPlaying = NO;
//    [self stopPlaybackTimeChecker];
//    
//    [self.trimmerView hideTracker:true];
//    
//    if (startTime != self.startTime) {
//        //then it moved the left position, we should rearrange the bar
//        [self seekVideoToPos:startTime];
//    }
//    else{ // right has changed
//        [self seekVideoToPos:endTime];
//    }
//    self.startTime = startTime;
//    self.stopTime = endTime;
//    
//}
//
//#pragma mark - Nav
//
//- (void)setupNav
//{
//    UIButton *btn = [[UIButton alloc] init];
//    
//    btn.frame = CGRectMake(0, 0, 73, 32);
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn.titleLabel setFont:PF_SC_Bold(14)];
//    [btn setBackgroundColor:[UIColor colorWithHexString:@"#FF5252"]];
//    btn.layer.cornerRadius = 3;
//    btn.layer.masksToBounds = YES;
//    [btn addTarget:self action:@selector(onClickDone) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//}
//
//#pragma mark - Btns
//
//- (void)setupBtns
//{
//    [self setupBtn:self.heightBtn selected:YES];
//    [self setupBtn:self.widthBtn selected:NO];
//    [self setupBtn:self.audioBtn selected:NO];
//}
//
//- (void)setupBtn:(UIButton *)btn selected:(BOOL)selectd
//{
//    if (!selectd) {
//        btn.backgroundColor = [UIColor clearColor];
//        btn.layer.cornerRadius = 15;
//        btn.layer.borderColor = [UIColor whiteColor].CGColor;
//        btn.layer.borderWidth = 0.5;
//        btn.selected = selectd;
//    }
//    else {
//        btn.backgroundColor = [UIColor colorWithHexString:@"#FB344C"];
//        btn.layer.cornerRadius = 15;
//        btn.layer.borderColor = [UIColor clearColor].CGColor;
//        btn.layer.borderWidth = 0;
//        btn.selected = selectd;
//    }
//}
//
//#pragma mark - Set up
//
//- (void)setupPlay
//{
//    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
//    options.version = PHVideoRequestOptionsVersionOriginal;
//    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
//    options.networkAccessAllowed = YES;
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [[PHImageManager defaultManager] requestAVAssetForVideo:self.model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            self.asset = asset;
//            
//            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
//            
//            self.player = [AVPlayer playerWithPlayerItem:item];
//            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//            self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
//            self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
//            
//            CGSize playerSize = [self getCurrentPlayerSize];
//            self.playerLayer.bounds = CGRectMake(0, 0, playerSize.width, playerSize.height);
//            self.playerLayer.position = CGPointMake(self.videoLayer.frame.size.width/2, self.videoLayer.frame.size.height/2);
//            
//            [self.videoLayer.layer addSublayer:self.playerLayer];
//            
//            self.videoPlayer.clipsToBounds = YES;
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
//            [self.videoLayer addGestureRecognizer:tap];
//            
//            self.videoPlaybackPosition = 0;
//            
//            [self tapOnVideoLayer:tap];
//            
//            // set properties for trimmer view
//            [self.trimmerView setThemeColor:[UIColor colorWithHexString:@"#FB344C"]];
//            [self.trimmerView setAsset:self.asset];
//            [self.trimmerView setShowsRulerView:YES];
//            [self.trimmerView setRulerLabelInterval:10];
//            [self.trimmerView setTrackerColor:[UIColor colorWithHexString:@"#FB344C"]];
//            [self.trimmerView setDelegate:self];
//            [self.trimmerView setMinLength:MIN(self.needVideoTime, 1)];
//            [self.trimmerView setMaxLength:MAX(self.needVideoTime, 10)];
//            
//            // important: reset subviews
//            [self.trimmerView resetSubviews];
//            
//            self.timeLbl.text = [NSString stringWithFormat:@"%0.fs", self.model.asset.duration];
//            
//            [self tapOnVideoLayer:nil];
//            
//        });
//
//    }];
//}
//
//#pragma mark - 比例调整
//
//- (CGSize)getCurrentPlayerSize
//{
//    CGSize bgViewSize = self.videoLayer.bounds.size;
//    CGSize newSize ;
//    CGFloat scale;
//    AVAssetTrack *clipVideoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
//    CGSize videoSize = clipVideoTrack.naturalSize;
//    CGAffineTransform t = clipVideoTrack.preferredTransform;
//    
//    if((t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) ||
//       (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)) {
//        CGFloat width = videoSize.height;
//        videoSize.height = videoSize.width;
//        videoSize.width = width;
//    }
//    
//    CGFloat widthScale = self.needVideoWeight / bgViewSize.width;
//    CGFloat heightScale = self.needVideoHeight / bgViewSize.height;
//    CGFloat playerScale = MAX(widthScale, heightScale);
//    
//    scale = videoSize.width / videoSize.height;
//    
//    if (self.heightBtn.selected) {
//        // 按高度适配
//        newSize = CGSizeMake(self.needVideoHeight / playerScale * scale, self.needVideoHeight / playerScale);
//    }
//    else {
//        // 按宽度适配
//        newSize = CGSizeMake(self.needVideoWeight / playerScale, self.needVideoWeight / playerScale / scale);
//    }
//
//    if (isnan(newSize.width)) {
//        newSize.width = 0;
//    }
//    if (isnan(newSize.height)) {
//        newSize.height = 0;
//    }
//    
//    return newSize;
//}
//
//- (void)changePlayerLayerFrame
//{
//    CGSize playerSize = [self getCurrentPlayerSize];
//    [UIView animateWithDuration:0.5f animations:^{
//        self.playerLayer.bounds = CGRectMake(0, 0, playerSize.width, playerSize.height);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//#pragma mark - Actions
//
//- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap
//{
//    if (self.isPlaying) {
//        [self.player pause];
//        [self stopPlaybackTimeChecker];
//    }
//    else {
//        if (_restartOnPlay){
//            [self seekVideoToPos: self.startTime];
//            [self.trimmerView seekToTime:self.startTime];
//            _restartOnPlay = NO;
//        }
//        [self.player play];
//        [self startPlaybackTimeChecker];
//    }
//    self.isPlaying = !self.isPlaying;
//    [self.trimmerView hideTracker:!self.isPlaying];
//}
//
//- (void)startPlaybackTimeChecker
//{
//    [self stopPlaybackTimeChecker];
//    
//    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
//}
//
//- (void)stopPlaybackTimeChecker
//{
//    if (self.playbackTimeCheckerTimer) {
//        [self.playbackTimeCheckerTimer invalidate];
//        self.playbackTimeCheckerTimer = nil;
//    }
//}
//
//#pragma mark - PlaybackTimeCheckerTimer
//
//- (void)onPlaybackTimeCheckerTimer
//{
//    CMTime curTime = [self.player currentTime];
//    Float64 seconds = CMTimeGetSeconds(curTime);
//    if (seconds < 0){
//        seconds = 0; // this happens! dont know why.
//    }
//    self.videoPlaybackPosition = seconds;
//    
//    [self.trimmerView seekToTime:seconds];
//    
//    if (self.videoPlaybackPosition >= self.stopTime) {
//        self.videoPlaybackPosition = self.startTime;
//        [self seekVideoToPos: self.startTime];
//        [self.trimmerView seekToTime:self.startTime];
//    }
//}
//
//- (void)seekVideoToPos:(CGFloat)pos
//{
//    self.videoPlaybackPosition = pos;
//    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
//    //NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
//    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//}

@end
