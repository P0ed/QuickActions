#import "BMQuickActionModel.h"
#import "BMCommand.h"


@implementation BMQuickActionModel

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title action:(BMCommand *)action {
	self = [super init];
	if (!self) return nil;

	_icon = icon.copy;
	_title = title.copy;
	_action = action;

	return self;
}

+ (instancetype)modelWithIcon:(NSString *)icon title:(NSString *)title action:(BMCommand *)action {
	return [(BMQuickActionModel *)self.alloc initWithIcon:icon title:title action:action];
}

@end
