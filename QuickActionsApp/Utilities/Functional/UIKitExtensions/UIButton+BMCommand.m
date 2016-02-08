#import "UIButton+BMCommand.h"
#import "BMUtilities.h"
@import ObjectiveC.runtime;


@implementation UIButton (BMCommand)

- (BMCommand *)bm_command {
	return objc_getAssociatedObject(self, @selector(bm_command));
}

- (void)bm_setCommand:(BMCommand *)command {
	objc_setAssociatedObject(self, @selector(bm_command), command, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

	if (command == nil) return;

	SEL executeSelector = @selector(bm_executeCommand:);
	NSSet *touchUpInsideActions = [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside].set;
	if (![touchUpInsideActions containsObject:NSStringFromSelector(executeSelector)]) {
		[self addTarget:self action:executeSelector forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)bm_executeCommand:(id)sender {
	[self.bm_command execute:sender];
}

@end
