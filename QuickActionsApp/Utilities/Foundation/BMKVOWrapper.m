#import "BMKVOWrapper.h"
#import "BMStream.h"
@import ObjectiveC.runtime;


@interface BMKVOProxy ()

@property BMPipe *pipe;
@property (copy) NSString *keyPath;
@property (weak) id target;

@end


@implementation BMKVOProxy

- (instancetype)initWithTarget:(id __weak)target keyPath:(NSString *)keyPath {
	self = [super init];
	if (!self) return nil;

	_pipe = BMPipe.new;
	_values = _pipe.stream;

	_target = target;
	_keyPath = keyPath.copy;

	[target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];

	return self;
}

- (void)dealloc {
	[self.target removeObserver:self forKeyPath:self.keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	[self.pipe put:change[NSKeyValueChangeNewKey]];
}

@end


@implementation NSObject (BMKVO)

- (BMKVOProxy *(^)(NSString *))observeKeyPath {
	return ^(NSString *keyPath) {
		return [BMKVOProxy.alloc initWithTarget:self keyPath:keyPath];
	};
}

//- (BMStream *)bm_valuesForKeyPath:(NSString *)keyPath observer:(id __weak)observer {
//	BMKVOProxy *proxy = BMKVOProxy.new;
//	objc_setAssociatedObject(observer, @selector(observeKeyPath), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//	[self addObserver:proxy forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
//	return proxy.values;
//}

@end
