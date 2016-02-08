#import "BMMaybe.h"


@implementation BMMaybe

- (instancetype)initWithValue:(id)value {
	self = [super init];
	if (!self) return nil;

	_value = value;

	return self;
}

+ (BMMaybe *(^)(id))some {
	return ^(id value) {
		return [(BMMaybe *)self.alloc initWithValue:value];
	};
}

+ (BMMaybe *)none {
	return [(BMMaybe *)self.alloc initWithValue:nil];
}

- (BMMaybe *(^)(id (^)(id)))map {
	return ^BMMaybe *(id (^f)(id)) {
		id value = self.value;
		if (value) {
			return BMMaybe.some(f(value));
		} else {
			return BMMaybe.none;
		}
	};
}

@end
