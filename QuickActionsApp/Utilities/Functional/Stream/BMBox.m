#import "BMBox.h"


@implementation BMBox

- (instancetype)initWithValue:(id)value {
	self = [super init];
	if (!self) return nil;

	_value = value;

	return self;
}

+ (BMBox *(^)(id))wrap {
	return ^(id value) {
		return [(BMBox *)self.alloc initWithValue:value];
	};
}

+ (BMBox *)empty {
	return [(BMBox *)self.alloc initWithValue:nil];
}

@end
