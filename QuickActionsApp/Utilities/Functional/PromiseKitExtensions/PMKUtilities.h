#import "BMSaflyCallBlock.h"


@class PMKPromise;

/// Wraps AnyObject into Promise if needed
extern PMKPromise *BMPromisify(id value);

/// Firstly can make chains more readable
extern PMKPromise *BMFirstly(BMBlock block);


/// Dispatches on main queue
extern PMKPromise *promise_after(NSTimeInterval timeInterval, id block);

extern PMKPromise *promise_after_on(NSTimeInterval timeInterval, dispatch_queue_t queue, id block);
