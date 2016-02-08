#import "BMStream.h"
#import "BMResult.h"
#import "BMMaybe.h"
#import "BMBox.h"
#import "BMPromiseResolver.h"
#import "BMWeakifying.h"
#import <PromiseKit/PromiseKit.h>


@implementation BMStream {
	NSHashTable<BMSink> *_sinks;
	NSHashTable<BMSink> *_onceSinks;
}

+ (instancetype)create:(void (^)(BMSink))block {
	return [(BMStream *)self.alloc initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(BMSink))block {
	self = super.init;
	if (!self) return nil;

	_sinks = [NSHashTable hashTableWithOptions:NSPointerFunctionsCopyIn];
	_onceSinks = [NSHashTable hashTableWithOptions:NSPointerFunctionsCopyIn];

	block(self.sendNext);

	return self;
}

- (BMSink)sendNext {
	return ^(id value) {
		for (BMSink f in _sinks) f(value);

		for (BMSink f in _onceSinks) f(value);
		[_onceSinks removeAllObjects];
	};
}

- (BMStream *(^)(id (^)(id)))map {
	return ^(id (^f)(id)) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:^(id value) {
				sink(f(value));
			}];
		}];
	};
}

- (BMStream *(^)(id))mapReplace {
	return ^(id value) {
		return self.map(^(id _) {
			return value;
		});
	};
}

- (BMStream *(^)(id (^)(id)))flatMap {
	return ^(id (^f)(id)) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:^(id value) {
				id mapped = f(value);
				if ([mapped isKindOfClass:BMStream.class]) {
					((BMStream *)mapped).next(sink);
				} else if ([mapped isKindOfClass:PMKPromise.class]) {
					((PMKPromise *)mapped).then(sink).catch(sink);
				} else if ([mapped isKindOfClass:BMResult.class]) {
					((BMResult *)mapped).ifSuccess(sink).ifFailure(sink);
				} else {
					sink(mapped);
				}
			}];
		}];
	};
}

- (BMStream *)flatten {
	return self.flatMap(^(id value) {
		return value;
	});
}

- (BMStream *(^)(BOOL (^)(id)))filter {
	return ^(BOOL (^f)(id)) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:^(id value) {
				if (f(value)) sink(value);
			}];
		}];
	};
}

- (BMStream *(^)(BMStream *))mergeWith {
	return ^(BMStream *stream) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:sink];
			[stream->_sinks addObject:sink];
		}];
	};
}

- (BMStream2 *(^)(BMStream *))combineLatestWith {
	return ^(BMStream *other) {
		return [BMStream2 create:^(BMSink2 sink) {
			BMBox<BMMaybe<id> *> *lastSelf = BMBox.empty;
			BMBox<BMMaybe<id> *> *lastOther = BMBox.empty;

			BMSink (^sendNext)(BMBox<BMMaybe<id> *> *) = ^(BMBox<BMMaybe<id> *> *storage) {
				return ^(id value) {
					storage.value = BMMaybe.some(value);
					if (lastSelf.value && lastOther.value) {
						sink(lastSelf.value.value, lastOther.value.value);
					}
				};
			};

			[_sinks addObject:sendNext(lastSelf)];
			[other->_sinks addObject:sendNext(lastOther)];
		}];
	};
}

- (BMStream2 *(^)(BMStream *))zipWith {
	return ^(BMStream *other) {
		return [BMStream2 create:^(BMSink2 sink) {
			NSPointerArray *selfValues = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];
			NSPointerArray *otherValues = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];

			BMSink (^sendNext)(NSPointerArray *) = ^(NSPointerArray *array) {
				return ^(id value) {
					[array addPointer:(__bridge void *)value];

					if (!selfValues.count || !otherValues.count) return;

					sink([selfValues pointerAtIndex:0], [otherValues pointerAtIndex:0]);
					[selfValues removePointerAtIndex:0];
					[otherValues removePointerAtIndex:0];
				};
			};

			[_sinks addObject:sendNext(selfValues)];
			[other->_sinks addObject:sendNext(otherValues)];
		}];
	};
}

- (BMStream *(^)(BMSink))next {
	return ^(BMSink f) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:^(id value) {
				f(value);
				sink(value);
			}];
		}];
	};
}

- (BMStream *)distinctUntilChanged {
	return [BMStream create:^(BMSink sink) {
		BMBox<BMMaybe<id> *> *lastValue = BMBox.empty;

		[_sinks addObject:^(id value) {
			if (!lastValue.value || (lastValue.value.value != value && ![lastValue.value.value isEqual:value])) {
				lastValue.value = BMMaybe.some(value);
				sink(value);
			}
		}];
	}];
}

- (BMStream *)ignoreNils {
	return self.filter(^BOOL(id value) {
		return value != nil;
	});
}

- (BMStream *)ignoreErrors {
	return self.filter(^BOOL(id value) {
		return ![value isKindOfClass:NSError.class];
	});
}

- (BMStream *)not {
	return self.map(^(NSNumber *value) {
		NSCAssert([value isKindOfClass:NSNumber.class],
				  @"-not must only be used on a stream of NSNumbers. Instead, got: %@",
				  NSStringFromClass([value class]));

		return @(!value.boolValue);
	});
}

- (PMKPromise *)takeOne {
	BMPromiseResolver *resolver = BMPromiseResolver.new;
	[_onceSinks addObject:^(id value) {
		[resolver resolve:value];
	}];
	return resolver.promise;
}

@end


@implementation BMStream2 {
	NSHashTable<BMSink2> *_sinks;
}

+ (instancetype)create:(void (^)(BMSink2 sink))block {
	return [(BMStream2 *)self.alloc initWithBlock:block];
}

- (instancetype)initWithBlock:(void (^)(BMSink2))block {
	self = super.init;
	if (!self) return nil;

	_sinks = [NSHashTable hashTableWithOptions:NSPointerFunctionsCopyIn];

	block(^(id value1, id value2) {
		for (BMSink2 sink in _sinks) sink(value1, value2);
	});

	return self;
}

- (BMStream *(^)(id (^)(id, id)))reduce {
	return ^(id (^f)(id, id)) {
		return [BMStream create:^(BMSink sink) {
			[_sinks addObject:^(id value1, id value2) {
				sink(f(value1, value2));
			}];
		}];
	};
}

- (BMStream *)and {
	return self.reduce(^(NSNumber *value1, NSNumber *value2) {
		NSCAssert([value1 isKindOfClass:NSNumber.class] && [value2 isKindOfClass:NSNumber.class],
				  @"-and must only be used on a stream of NSNumbers. Instead, got: %@ and %@",
				  NSStringFromClass([value1 class]), NSStringFromClass([value2 class]));

		return @(value1.boolValue && value2.boolValue);
	});
}

- (BMStream *)or {
	return self.reduce(^(NSNumber *value1, NSNumber *value2) {
		NSCAssert([value1 isKindOfClass:NSNumber.class] && [value2 isKindOfClass:NSNumber.class],
				  @"-or must only be used on a stream of NSNumbers. Instead, got: %@ and %@",
				  NSStringFromClass([value1 class]), NSStringFromClass([value2 class]));

		return @(value1.boolValue || value2.boolValue);
	});
}

@end


@implementation BMPipe {
	BMSink _sendNext;
}

- (instancetype)init {
	self = super.init;
	if (!self) return nil;

	weakify(self)
	_stream = [BMStream create:^(BMSink sink) {
		strongify(self)
		self->_sendNext = [sink copy];
	}];

	return self;
}

- (void)put:(id)value {
	_sendNext(value);
}

@end
