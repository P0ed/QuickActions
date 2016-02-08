#import "BMResult.h"


@implementation BMResult

- (instancetype)initWithValue:(id)value {
	self = [super init];
	if (!self) return nil;

	_value = value;

	return self;
}

- (instancetype)initWithError:(NSError *)error {
	self = [super init];
	if (!self) return nil;

	_error = error.copy;

	return self;
}

+ (BMResult *(^)(id))success {
	return ^(id value) {
		return [(BMResult *)self.alloc initWithValue:value];
	};
}

+ (BMResult *(^)(NSError *))failure {
	return ^(NSError *error) {
		return [(BMResult *)self.alloc initWithError:error];
	};
}

- (BMResult *(^)(id (^)(id)))map {
	return ^(id (^f)(id)) {
		if (!self.error) {
			return BMResult.success(f(self.value));
		} else {
			return BMResult.failure(self.error);
		}
	};
}

- (BMResult *(^)(void (^)(id)))ifSuccess {
	return ^(void (^f)(id)) {
		if (!self.error) f(self.value);
		return self;
	};
}

- (BMResult *(^)(void (^)(NSError *)))ifFailure {
	return ^(void (^f)(NSError *)) {
		if (self.error) f(self.error);
		return self;
	};
}

@end
