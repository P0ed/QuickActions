#import "BMSubscriptingAssignmentTrampoline.h"
#import "BMStream.h"
#import <PromiseKit/PromiseKit.h>


@interface BMSubscriptingAssignmentTrampoline ()

@property (nonatomic, readonly) id target;

@end


@implementation BMSubscriptingAssignmentTrampoline

- (instancetype)initWithTarget:(id)target {
	self = super.init;
	if (!self) return nil;

	_target = target;

	return self;
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key {
	if ([object isKindOfClass:BMStream.class]) {
		((BMStream *)object).next(^(id value) {
			[self.target setValue:value forKey:key];
		});
	} else if ([object isKindOfClass:PMKPromise.class]) {
		((PMKPromise *)object).then(^(id value) {
			[self.target setValue:value forKey:key];
		});
	} else {
		@throw [NSException exceptionWithName:@"Invalid argument" reason:nil userInfo:nil];
	}
}

@end
