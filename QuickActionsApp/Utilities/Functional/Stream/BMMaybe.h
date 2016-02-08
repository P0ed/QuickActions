@import Foundation;


NS_ASSUME_NONNULL_BEGIN

@interface BMMaybe<A> : NSObject

+ (BMMaybe *(^)(A __nullable))some;
+ (BMMaybe *)none;

@property (readonly, nullable, nonatomic) A value;

- (BMMaybe *(^)(id (^)(A)))map;

@end

NS_ASSUME_NONNULL_END
