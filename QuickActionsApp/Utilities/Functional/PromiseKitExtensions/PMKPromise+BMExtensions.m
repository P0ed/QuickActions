#import "PMKPromise+BMExtensions.h"
#import "PMKUtilities.h"


@implementation PMKPromise (BMExtensions)

/// Не используется
- (PMKPromise *(^)(NSTimeInterval))delay {
	return ^(NSTimeInterval duration) {
		return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
			self.then(^(id value){
				promise_after(duration, ^{
					resolve(value);
				});
			});
		}];
	};
}

- (PMKPromise *(^)(id))catchRethrow {
	return ^(id frock) {
		return self.catchRethrowOn(dispatch_get_main_queue(), frock);
	};
}

- (PMKPromise *(^)(id))catchRethrowInBackground {
	return ^(id frock) {
		return self.catchRethrowOn(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), frock);
	};
}

- (PMKPromise *(^)(dispatch_queue_t, id))catchRethrowOn {
	return ^(dispatch_queue_t queue, id frock) {
		return self.catchOn(queue, ^(NSError *error) {
			return BMSaflyCallBlock(frock, error) ?: error;
		});
	};
}

+ (PMKPromise *)any:(NSArray<PMKPromise *> *)promises {
	return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
		for (PMKPromise *promise in promises) {
			promise.finally(^{
				resolve(nil);
			});
		}
	}];
}

@end
