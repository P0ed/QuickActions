#import "BMPromiseResolver.h"
#import "NSError+BMExtensions.h"
#import <PromiseKit/PromiseKit.h>


@interface BMPromiseResolver ()

@property (copy) PMKResolver resolverBlock;

@end


@implementation BMPromiseResolver

- (instancetype)init {
	self = super.init;
	if (!self) return nil;

	_promise = [PMKPromise promiseWithResolver:^(PMKResolver resolve) {
		self.resolverBlock = resolve;
	}];

	return self;
}

- (void)dealloc {
	if (self.promise.pending) {
		[self resolve:[NSError errorWithDescription:@"BMPromiseResolver is deallocated"]];
	}
}

- (void)resolve:(id)value {
	self.resolverBlock(value);
}

@end
