//
//  MYNStickyFlowLayout.m
//  Myntra
//
//  Created by Param Aggarwal on 19/08/14.
//  Copyright (c) 2014 Myntra Designs. All rights reserved.
//

#import "MYNStickyFlowLayout.h"

@implementation MYNStickyFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allItems = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lastCells = [[NSMutableDictionary alloc] init];

    NSMutableDictionary *firstCells = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *footers = [[NSMutableDictionary alloc] init];

    [allItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        NSIndexPath *indexPath = attributes.indexPath;
        
        if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader]) {
            [headers setObject:obj forKey:@(indexPath.section)];
            
        } else if ([[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter]) {
            [footers setObject:obj forKey:@(indexPath.section)];
            
        } else {

            // Get the bottom most cell of that section
            UICollectionViewLayoutAttributes *currentLastAttribute = [lastCells objectForKey:@(indexPath.section)];
            if ( !currentLastAttribute || indexPath.row > currentLastAttribute.indexPath.row) {
                [lastCells setObject:obj forKey:@(indexPath.section)];
            }

            // Get the top most cell of that section
            UICollectionViewLayoutAttributes *currentFirstAttribute = [firstCells objectForKey:@(indexPath.section)];
            if ( !currentFirstAttribute || indexPath.row < currentFirstAttribute.indexPath.row) {
                [firstCells setObject:obj forKey:@(indexPath.section)];
            }
        }

        // For iOS 7.0, the cell zIndex should be above sticky section header
        attributes.zIndex = 1;
    }];

    [lastCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        NSIndexPath *indexPath = attributes.indexPath;
        NSNumber *indexPathKey = @(indexPath.section);

        UICollectionViewLayoutAttributes *header = headers[indexPathKey];
        // CollectionView automatically removes headers not in bounds
        if (self.headerReferenceSize.height && !header) {
            header = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];

            if (header) {
                [allItems addObject:header];
            }
        }
        [self updateHeaderAttributes:header lastCellAttributes:lastCells[indexPathKey]];
    }];

    [firstCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        NSIndexPath *indexPath = attributes.indexPath;
        NSNumber *indexPathKey = @(indexPath.section);
        
        UICollectionViewLayoutAttributes *footer = footers[indexPathKey];
        // CollectionView automatically removes footers not in bounds
        if (self.footerReferenceSize.height && !footer) {
            footer = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
            
            if (footer) {
                [allItems addObject:footer];
            }
        }
        [self updateFooterAttributes:footer firstCellAttributes:firstCells[indexPathKey]];
        
    }];
    
    return allItems;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

#pragma mark Helper

- (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes lastCellAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes
{
    attributes.zIndex = 1024;
    attributes.hidden = NO;

    // last point of section minus height of header
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height;

    // top of the view
    CGFloat viewMinY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;

    // larger of sticky position or actual position
    CGFloat largerYPosition = MAX(viewMinY, attributes.frame.origin.y);
    
    // smaller of calculated position or end of section
    CGFloat finalPosition = MIN(largerYPosition, sectionMaxY);

//    NSLog(@"%.2f, %.2f, %.2f, %.2f", sectionMaxY, viewMinY, largerYPosition, finalPosition);

    // update y position
    CGPoint origin = attributes.frame.origin;
    origin.y = finalPosition;

    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

- (void)updateFooterAttributes:(UICollectionViewLayoutAttributes *)attributes firstCellAttributes:(UICollectionViewLayoutAttributes *)firstCellAttributes
{
    attributes.zIndex = 1024;
    attributes.hidden = NO;
    
    // starting point of section
    CGFloat sectionMinY = CGRectGetMinY(firstCellAttributes.frame);
    
    // bottom of the view
    CGFloat viewMaxY = CGRectGetMaxY(self.collectionView.bounds) - self.collectionView.contentInset.bottom - attributes.frame.size.height;
    
    // smaller of sticky position or actual position
    CGFloat smallerYPosition = MIN(viewMaxY, attributes.frame.origin.y);
    
    // larger of calculated position or end of section
    CGFloat finalPosition = MAX(smallerYPosition, sectionMinY);
    
//    NSLog(@"%.2f, %.2f, %.2f, %.2f", sectionMinY, viewMaxY, smallerYPosition, finalPosition);
    
    // update y position
    CGPoint origin = attributes.frame.origin;
    origin.y = finalPosition;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };

}

@end
