#import "BMNotificationsWrapper.h"
#import "BMUtilities.h"
#import "Bookmate-swift.h"


@implementation BMNotificationProxy {
	id _observer;
}

- (instancetype)initWithName:(NSString *)name {
	self = [super init];
	if (!self) return nil;

	_notifications = [BMStream create:^(BMSink sink) {
		_observer = [NotificationObserver.alloc initWithName:name closure:sink];
	}];

	return self;
}

@end
