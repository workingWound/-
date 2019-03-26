//
//  XibTableViewCell.h
//  xib自定义UITableViewCell
//
//  Created by 移动云 on 2018/11/22.
//  Copyright © 2018 移动云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XibTableViewCell : UITableViewCell

+(instancetype)xibTableViewCell;

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerTitleLabel;


@end

NS_ASSUME_NONNULL_END
