@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class BMStream<A>;
@class BMTransitionProgress;


@interface BMQuickActionsPressHandler : NSObject

@property (readonly, nonatomic) BMStream<BMTransitionProgress *> *transitions;

- (instancetype)initWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
