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
            UICollectionViewLayoutAttributes *currentLastAttribute = [lastCells objectForKey:@(indexPath.section)];

            // Get the bottom most cell of that section
            if ( !currentLastAttribute || indexPath.row > currentLastAttribute.indexPath.row) {
                [lastCells setObject:obj forKey:@(indexPath.section)];
            }

            UICollectionViewLayoutAttributes *currentFirstAttribute = [firstCells objectForKey:@(indexPath.section)];
            
            // Get the top most cell of that section
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
        if (!header) {
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
        if (!footer) {
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

    CGRect currentBounds = self.collectionView.bounds;
    CGFloat sectionMaxY = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height;
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;

    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);

//    NSLog(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);

    CGPoint origin = attributes.frame.origin;
    origin.y = maxY;

    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

- (void)updateFooterAttributes:(UICollectionViewLayoutAttributes *)attributes firstCellAttributes:(UICollectionViewLayoutAttributes *)firstCellAttributes
{
    attributes.zIndex = 1024;
    attributes.hidden = NO;
        
    CGRect currentBounds = self.collectionView.bounds;
    CGFloat sectionMaxY = CGRectGetMaxY(firstCellAttributes.frame) - attributes.frame.size.height;
    CGFloat y = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top;
    
    CGFloat maxY = MIN(MAX(y, attributes.frame.origin.y), sectionMaxY);
    
//    NSLog(@"%.2f, %.2f, %.2f", y, maxY, sectionMaxY);
    
    CGPoint origin = attributes.frame.origin;
    origin.y = maxY;
    
    attributes.frame = (CGRect){
        origin,
        attributes.frame.size
    };
}

@end
