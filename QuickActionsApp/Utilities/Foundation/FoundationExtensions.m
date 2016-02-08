#import "FoundationExtensions.h"


@implementation NSDictionary (BMExtensions)

- (NSArray *)bm_objectsForKeys:(NSArray *)keys {
	NSMutableArray *array = [NSMutableArray.alloc initWithCapacity:keys.count];
	for (id<NSCopying> key in keys) {
		id object = self[key];
		if (object) [array addObject:object];
	}
	return array;
}

@end


@implementation NSMutableDictionary (BMExtensions)

- (id)bm_removeObjectForKey:(id)key {
	id object = self[key];
	self[key] = nil;
	return object;
}

@end


@implementation NSArray (BMExtensions)

- (NSDictionary *(^)(id<NSCopying>(^)(id)))dictWithKeys {
	return ^NSDictionary *(id<NSCopying>(^makeKey)(id)) {
		NSMutableDictionary *dict = [NSMutableDictionary.alloc initWithCapacity:self.count];
		for (id object in self) {
			id key = makeKey(object);
			if (key) dict[key] = object;
		}
		return dict;
	};
}

- (NSArray *)bm_arrayByRemovingObjects:(NSArray *)objects {
	NSMutableArray *array = self.mutableCopy;

	for (id o in objects) {
		[array removeObject:o];
	}

	return array;
}

@end
