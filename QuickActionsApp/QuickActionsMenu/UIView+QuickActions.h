#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BMQuickActionModel;
@class BMStream<A>;


@interface UIView (QuickActions)

- (BMStream *)bm_setQuickActions:(NSArray<BMQuickActionModel *> *)actions;

@end

NS_ASSUME_NONNULL_END
