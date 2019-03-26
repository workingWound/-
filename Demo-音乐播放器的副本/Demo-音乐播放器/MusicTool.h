//
//  MusicTool.h
//  灯控
//
//  Created by 移动云 on 2018/10/18.
//  Copyright © 2018 Jackson XIE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicTool.h"
#import "Model.h"
#import "MJExtension.h"
NS_ASSUME_NONNULL_BEGIN
@class Model;
@interface MusicTool : NSObject

//所有的音乐
+(NSArray *)musics;

//当前播放的音乐
+(Model *)playingMusic;

//设置默认的音乐
+(void)setupPlayingMusic:(Model *)playingMusic;

//返回上一首音乐
+(Model *)priviousMusic;

//返回下一首音乐
+(Model *)nextMusic;

@end

NS_ASSUME_NONNULL_END
