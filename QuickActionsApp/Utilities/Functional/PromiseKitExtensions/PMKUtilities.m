#import "PMKUtilities.h"
#import <PromiseKit/PromiseKit.h>


PMKPromise *BMPromisify(id value) {
	if (![value isKindOfClass:PMKPromise.class]) {
		value = [PMKPromise promiseWithValue:value];
	}
	return value;
}

PMKPromise *BMFirstly(id frock) {
	return BMPromisify(BMSaflyCallBlock(frock, nil));
}

PMKPromise *promise_after(NSTimeInterval timeInterval, id block) {
	return promise_after_on(timeInterval, dispatch_get_main_queue(), block);
}

PMKPromise *promise_after_on(NSTimeInterval timeInterval, dispatch_queue_t queue, id block) {
	return [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), queue, ^{
			resolve(BMSaflyCallBlock(block, nil));
		});
	}];
}
