//
//  AudioTool.m
//  02-播放音效
//
//  Created by xiaomage on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool

static NSMutableDictionary *_players;

+ (void)initialize
{
    _players = [NSMutableDictionary dictionary];
    //
}

+ (AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName
{
    // 1.创建空的播放器
    AVAudioPlayer *player = nil;
    
    // 2.从字典中取出播放器
    player = _players[fileName];
    
    // 3.判断播放器是否为空
    if (player == nil) {
        // 4.生成对应音乐资源
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (fileUrl == nil) return nil;
        
        // 5.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        
        // 6.保存到字典中
        [_players setObject:player forKey:fileName];
        
        // 7.准备播放
        [player prepareToPlay];
    }
    
    //8.开始播放
  [player play];
    
    return player;
    
}
+ (AVAudioPlayer *)playMusicWithurl:(NSURL *)fileurl
{
    // 1.创建空的播放器
    AVAudioPlayer *player = nil;
    
    // 2.从字典中取出播放器
    player = _players[fileurl];
    
    // 3.判断播放器是否为空
    if (player == nil) {
        // 4.生成对应音乐资源
       // NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
//        if (fileUrl == nil) return nil;
        
        // 5.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileurl error:nil];
        
        // 6.保存到字典中
        [_players setObject:player forKey:fileurl];
        
        // 7.准备播放
        [player prepareToPlay];
    }
    [player prepareToPlay];

    //8.开始播放
    [player play];
    
    return player;
    
}
+ (void)pauseMusicWithFileName:(NSString *)fileName
{
    // 1.从字典中取出播放器
    AVAudioPlayer *player = _players[fileName];
    
    // 2.暂停音乐
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithFileName:(NSString *)fileName
{
    // 1.从字典中取出播放器
    AVAudioPlayer *player = _players[fileName];
    
    // 2.停止音乐
    if (player) {
        [player stop];
        [_players removeObjectForKey:fileName];
        player = nil;
    }
}


@end
