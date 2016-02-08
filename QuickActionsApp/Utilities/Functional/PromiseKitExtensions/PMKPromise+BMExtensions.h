#import <PromiseKit/PromiseKit.h>


@interface PMKPromise (BMExtensions)

/**
 * Использовать вместо -catch, когда нужно перевыбросить ошибку.
 * Перевыбрасывает ошибку если блок вернет Void или nil,
 * иначе резолвит возвращеным из блока значением
 */
- (PMKPromise *(^)(id))catchRethrow;

- (PMKPromise *(^)(id))catchRethrowInBackground;

- (PMKPromise *(^)(dispatch_queue_t, id))catchRethrowOn;

+ (PMKPromise *)any:(NSArray<PMKPromise *> *)promises;

@end
