@import Foundation;


#define BMAssign(TARGET, SELECTOR) \
	[BMSubscriptingAssignmentTrampoline.alloc initWithTarget:TARGET][NSStringFromSelector(@selector(SELECTOR))]


@interface BMSubscriptingAssignmentTrampoline : NSObject

- (instancetype)initWithTarget:(id)target;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

@end
