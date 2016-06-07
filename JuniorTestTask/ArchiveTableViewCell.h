//
//  ArchiveTableViewCell.h
//  JuniorTestTask
//
//  Created by Stas Malinovsky on 28.05.16.
//  Copyright © 2016 StasMalinovsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateArchiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinatesArchiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityArchiveLabel;

@end
