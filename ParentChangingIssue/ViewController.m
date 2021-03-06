//
//  ViewController.m
//  ParentChangingIssue
//
//  Created by DNosov on 09.02.17.
//  Copyright © 2017 Kuluum. All rights reserved.
//

#import "ViewController.h"

@interface MyNode: ASDisplayNode
@property (strong, nonatomic) ASTextNode *textNode;
@property (strong, nonatomic) ASImageNode *imageNode;
@property (strong, nonatomic) ASDisplayNode *proxyNode;
@end

@interface ViewController ()
@end

@implementation ViewController
- (instancetype)init {
    self = [super initWithNode:[[MyNode alloc] init]];
    return self;
}
@end



@implementation MyNode

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        
        _textNode = [[ASTextNode alloc] init];
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        _textNode.attributedText = [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus non nibh vitae nulla dictum convallis. Aliquam porttitor ante eu est efficitur consectetur. Nulla enim sem, facilisis at odio et, fringilla accumsan tellus. Nam scelerisque egestas leo, non bibendum lorem auctor id. Etiam porta, magna quis ullamcorper efficitur, elit ex auctor metus, non ultricies nisl tortor et massa. Pellentesque eget justo a nibh lacinia porta eget in nisi. Quisque nunc velit, congue id diam nec, semper blandit mauris. Pellentesque eget venenatis ante." attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];
        
        _textNode.style.flexShrink = YES;
        
        _imageNode = [[ASImageNode alloc] init];
        _imageNode.image = [UIImage imageNamed:@"logo"];
        _imageNode.contentMode = UIViewContentModeScaleAspectFit;
        _imageNode.style.preferredSize = self.imageNode.image.size;
        
        _proxyNode = [[ASDisplayNode alloc] init];
        _proxyNode.automaticallyManagesSubnodes = YES;
        
        __weak typeof(self) weakSelf = self;
        [_proxyNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            ASStackLayoutSpec *stack = [ASStackLayoutSpec verticalStackLayoutSpec];
            stack.spacing = 8.0;
            stack.horizontalAlignment = ASHorizontalAlignmentMiddle;
            stack.verticalAlignment = ASVerticalAlignmentCenter;
            
            if (self.asyncTraitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
                stack.children = @[weakSelf.textNode];
            }
            else {
                stack.children = @[weakSelf.imageNode, weakSelf.textNode];
                
                // Uncomment to check that image works in landscape.
//                stack.children = @[weakSelf.textNode];
            }
            return stack;
        }];
        
    }
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *proxySpec = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                                              sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                                      child:_proxyNode];
    proxySpec.style.width = ASDimensionMake(320);
    proxySpec.style.flexShrink = YES;
    ASWrapperLayoutSpec *imageWrapper = [ASWrapperLayoutSpec wrapperWithLayoutElement:_imageNode];
    
    if (self.asyncTraitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) {
        return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                       spacing:8
                                                justifyContent:ASStackLayoutJustifyContentStart
                                                    alignItems:ASStackLayoutAlignItemsStretch
                                                      children:@[imageWrapper, proxySpec]];
    }
    else {
        return proxySpec;
    }
}

@end


