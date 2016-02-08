#import "BMCommand.h"
#import "PMKUtilities.h"
#import <PromiseKit/PromiseKit.h>


@interface BMCommand ()

@property (readonly, copy, nonatomic) id block;

@end


@implementation BMCommand

+ (instancetype)commandWithBlock:(id)block {
	return [(BMCommand *)self.alloc initWithBlock:block];
}

- (instancetype)initWithBlock:(id)block {
	self = super.init;
	if (!self) return nil;

	_block = [block copy];

	return self;
}

- (PMKPromise *)execute:(id)input {
	return BMPromisify(BMSaflyCallBlock(self.block, input));
}

@end
