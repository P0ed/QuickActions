@import Foundation;


NS_ASSUME_NONNULL_BEGIN

@interface BMResult<A> : NSObject

@property (readonly, nullable, nonatomic) A value;
@property (readonly, nullable, nonatomic) NSError *error;

+ (BMResult *(^)(A))success;
+ (BMResult *(^)(NSError *))failure;

- (BMResult *(^)(id (^)(id)))map;

- (BMResult *(^)(void (^)(A)))ifSuccess;
- (BMResult *(^)(void (^)(NSError *)))ifFailure;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
