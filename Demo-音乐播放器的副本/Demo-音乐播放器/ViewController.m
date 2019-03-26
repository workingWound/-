//
//  ViewController.m
//  Demo-音乐播放器
//
//  Created by 移动云 on 2019/3/26.
//  Copyright © 2019 移动云. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+XMGTimeExtension.h"
#import "AudioTool.h"
#import "MusicTool.h"
#import "XibTableViewCell.h"
@interface ViewController ()<UITableViewDelegate,MPMediaPickerControllerDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray  <MPMediaItem *>*musicArray;

@property (nonatomic,strong) NSData *data;

@property(nonatomic,strong) CADisplayLink *timer;

//音乐的下标
@property (nonatomic, assign) NSInteger index;

/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

@property(nonatomic,strong) MPMediaItem *currentItem;
//当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
//歌曲总时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
//进度条
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//歌曲名字
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 进度条时间 */
@property(nonatomic, strong) NSTimer *progressTimer;

/** 播放暂停按钮 */

@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
//播放列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)  NSMutableArray *items;

#pragma mark - 进度条事件处理
- (IBAction)start;
- (IBAction)end;
- (IBAction)progressValueChange;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;
#pragma mark - 按钮点击事件
- (IBAction)playOrPause;
- (IBAction)next;
- (IBAction)previous;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 改变滑块的图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"椭圆4拷贝"] forState:UIControlStateNormal];
    
   
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XibTableViewCell" bundle:nil] forCellReuseIdentifier:@"XibTableViewCell"] ;
    
     [self getMusicListFromMusicLibrary];
    
    self.currentItem = self.musicArray[0];

    [self startPlayingMusic];
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    
    [self.currentPlayer pause];
    
    
}

#pragma mark - 获取媒体库文件
- (MPMediaItemCollection *)getMusicListFromMusicLibrary {
    //媒体队列
    MPMediaQuery *mediaQueue = [MPMediaQuery songsQuery];
    
    // 申明一个Collection便于下面给MusicPlayer赋值
    MPMediaItemCollection *mediaItemCollection;
    
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    
    if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized ){
        if (mediaQueue.items.count == 0) {
            return 0;
        } else {
            //获取本地音乐库文件
            self.musicArray = [NSMutableArray array];
            
            [mediaQueue.items enumerateObjectsUsingBlock:^(MPMediaItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj valueForProperty:MPMediaItemPropertyAssetURL]) {
                    [self.musicArray addObject:obj];
                }
            }];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用媒体库"
                                                        message:@"请在iPhone的设置中允许访问。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
        return 0;
    }
    
    mediaItemCollection = [[MPMediaItemCollection alloc] initWithItems:[self.musicArray copy]];
    
    
    return mediaItemCollection;
}


#pragma mark - 开始播放音乐
-(void)startPlayingMusic
{
    
    //获取当前正在播放的音乐
    //    Model *playingMusic = [MusicTool playingMusic];
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    
    if (authStatus == MPMediaLibraryAuthorizationStatusAuthorized && self.musicArray.count!=0){
        self.currentPlayer= [AudioTool playMusicWithurl:[self.musicArray[self.index] valueForProperty:MPMediaItemPropertyAssetURL]];
    }else{
        return;
    }
    self.currentPlayer.currentTime = 0;
    
    //设置歌曲名字
    self.songLabel.text =[self.musicArray[self.index] valueForProperty:MPMediaItemPropertyTitle];
    
    //设置界面信息
    self.totalTimeLabel.text = [self getMMSSFromSS:[self.musicArray[self.index] valueForProperty:MPMediaItemPropertyPlaybackDuration]];
    // 设置播放按钮
    self.playOrPauseBtn.selected = self.currentPlayer.isPlaying;
    
    
    // 开启定时器,现将之前的定时器移除
    [self removeProgressTimer];
    
    [self addProgressTimer];
}


-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    //NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}

#pragma mark - 对进度条时间的处理
- (void)addProgressTimer
{
    //提前更新数据
    [self updateProgressinfo];
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressinfo) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer  forMode:NSRunLoopCommonModes];
    
   
    
}

#pragma mark 移除定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    
}

#pragma mark - 更新进度条
-(void)updateProgressinfo{
    
    float a = self.currentPlayer.currentTime ;
    
    NSString *String = [NSString stringWithFormat:@"%f",a];
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%@",[self getMMSSFromSS:String]] ;
    
    // 2.更新滑动条
    
    NSString *duration = [self.musicArray[self.index] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    self.progressSlider.value =  a / [duration floatValue]  ;
}

#pragma mark - 歌曲列表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.musicArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XibTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XibTableViewCell" forIndexPath:indexPath];
    
    MPMediaItem *item = self.musicArray[indexPath.row];
    
    NSString *musicName = [item valueForKey:MPMediaItemPropertyTitle];
    
    
    
    NSString *musicSinger = [item valueForKey:MPMediaItemPropertyAlbumArtist];
    // 专辑图片
    MPMediaItemArtwork *artwork= [item valueForKey:MPMediaItemPropertyArtwork];
    
    UIImage *image=[artwork imageWithSize:CGSizeMake(120, 120)];
    
    cell.musicImageView.image = image;
    
    cell.songTitleLabel.text = musicName;
    
    cell.singerTitleLabel.text = musicSinger;
    
    //返回当前cell
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.currentPlayer stop];
    
    self.index = indexPath.row;
    NSLog(@"%ld",(long)self.index);
    
    
    [self startPlayingMusic];
    
    if (self.playOrPauseBtn.state == self.playOrPauseBtn.selected) {
        
        self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
        
    }
}

#pragma mark - slider 事件处理
- (IBAction)start {
    // 移除定时器
    [self removeProgressTimer];
}

- (IBAction)end {
    
    // 1.更新播放的时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    
    
    // 2.添加定时器
    [self addProgressTimer];
}

- (IBAction)progressValueChange {
    
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value * self.currentPlayer.duration];
    
}



- (IBAction)sliderClick:(UITapGestureRecognizer *)sender {
    
    // 1.获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    
    // 2.获取点击的比例
    CGFloat ratio = point.x / self.progressSlider.bounds.size.width;
    
    // 3.更新播放的时间
    self.currentPlayer.currentTime = self.currentPlayer.duration * ratio;
    
    // 4.更新时间和滑块的位置
    [self updateProgressinfo];
}

#pragma mark - 播放按钮的处理
- (IBAction)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    
    if (self.currentPlayer.playing) {
        self.currentPlayer.meteringEnabled = NO;
        
        // 1.暂停播放器
        [self.currentPlayer pause];
        
        
        // 2.移除定时器
        [self removeProgressTimer];
        
    } else {
        // 1.开始播放
        [self.currentPlayer play];
        
        
        // 2.添加定时器
        [self addProgressTimer];
        
        
    }
    
}



- (IBAction)next {
   
    [self.currentPlayer stop];

    if (self.playOrPauseBtn.state == self.playOrPauseBtn.selected) {
        
        self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
        
    }
    
    if(self.musicArray[self.index] == [self.musicArray lastObject]){
        
        self.index = 0;
        
        [self startPlayingMusic];
        
        [self.currentPlayer play];
        
    }else{
        
        self.index++;
        
        NSLog(@"%ld",(long)self.index);
        
        [self startPlayingMusic];
    }
    
}

- (IBAction)previous {
    
    [self.currentPlayer stop];
    
    
    if (self.playOrPauseBtn.state == self.playOrPauseBtn.selected) {
        
        self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
        
    }
    
    if(self.musicArray[self.index] == [self.musicArray firstObject]){
        
        self.index = self.musicArray.count-1;
        NSLog(@"%ld",(long)self.index);
        
        
        [self startPlayingMusic];
        //
        [self.currentPlayer play];
        
    }else{
        
        self.index--;
        NSLog(@"%ld",(long)self.index);
        
        [self startPlayingMusic];
        
    }
}

@end
