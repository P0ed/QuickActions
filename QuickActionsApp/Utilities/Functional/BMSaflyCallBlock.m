#import "BMSaflyCallBlock.h"
#import "NSMethodSignature+BlockSignature.h"


id BMSaflyCallBlock(BMBlock block, id arg) {
	#define invalid_block_exception() [NSException \
		exceptionWithName:NSInvalidArgumentException \
		reason:@"The provided block’s signature is unsupported." \
		userInfo:nil]

	#define call_block_with_rtype(type) ({^type{ \
		switch (nargs) { \
			case 1: \
				return ((type(^)(void))block)(); \
			case 2: { \
				return ((type(^)(id))block)(arg); \
			} \
			default: \
				@throw invalid_block_exception(); \
		}}();})

	if (!block) return nil;

	NSMethodSignature *blockMS = BMBlockSignature(block);
	const char rtype = blockMS.methodReturnType[0];
	const NSInteger nargs = blockMS.numberOfArguments;

	switch (rtype) {
		case 'v':
			return call_block_with_rtype(void), nil;
		case '@':
			return call_block_with_rtype(id);
		default:
			@throw invalid_block_exception();
	}
}
