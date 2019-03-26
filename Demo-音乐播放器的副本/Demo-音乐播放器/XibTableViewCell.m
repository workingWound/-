//
//  XibTableViewCell.m
//  xib自定义UITableViewCell
//
//  Created by 移动云 on 2018/11/22.
//  Copyright © 2018 移动云. All rights reserved.
//

#import "XibTableViewCell.h"

@implementation XibTableViewCell

+(instancetype)xibTableViewCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"XibTableViewCell" owner:nil options:nil] lastObject];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
