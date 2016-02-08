@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface BMBox<A> : NSObject

@property (nullable, nonatomic) A value;

+ (BMBox *(^)(id __nullable))wrap;
+ (BMBox *)empty;

@end

NS_ASSUME_NONNULL_END
