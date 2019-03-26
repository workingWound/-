//
//  MusicTool.m
//  灯控
//
//  Created by 移动云 on 2018/10/18.
//  Copyright © 2018 Jackson XIE. All rights reserved.
//

#import "MusicTool.h"
#import "Model.h"
#import "MJExtension.h"
@implementation MusicTool

static NSArray *_musics;
static Model *_playingMusic;

+(void)initialize
{
    
    if (_musics ==nil) {
        _musics = [Model objectArrayWithFilename:@"Musics.plist"];

    }
    if (_playingMusic == nil) {
        _playingMusic = _musics[0];
    }
}

+(NSArray *)musics
{
    return  _musics;
}

+(Model *)playingMusic
{
    return _playingMusic;
}

+(void)setupPlayingMusic:(Model *)playingMusic
{
    _playingMusic = playingMusic;
}


+ (Model *)priviousMusic{
    // 1.获取当前音乐的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取上一首音乐的下标值
    NSInteger previousIndex = --currentIndex;
    Model *previousMusic = nil;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    previousMusic = _musics[previousIndex];
    
    return previousMusic;
}

+ (Model *)nextMusic
{
    // 1.获取当前音乐的下标值
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    // 2.获取下一首音乐的下标值
    NSInteger nextIndex = ++currentIndex;
    Model *nextMusic = nil;
    if (nextIndex >= _musics.count) {
        nextIndex = 0;
    }
    nextMusic = _musics[nextIndex];
    
    return nextMusic;
}
@end
