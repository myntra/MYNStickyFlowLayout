//
//  MYNStickyFlowLayout.h
//  Myntra
//
//  Created by Param Aggarwal on 19/08/14.
//  Copyright (c) 2014 Myntra Designs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PKResizableHeaderDelegate <NSObject>

- (void)sectionHeaderResizedToHeight:(CGFloat)height;

@end

@interface MYNStickyFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<PKResizableHeaderDelegate>resizableHeaderDelegate;

@end
