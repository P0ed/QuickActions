@import Foundation;


@interface NSDictionary (BMExtensions)

/// Excluding not found
- (NSArray *)bm_objectsForKeys:(NSArray *)keys;

@end


@interface NSMutableDictionary<KeyType, ObjectType> (BMExtensions)

/// @return Removed object
- (ObjectType)bm_removeObjectForKey:(KeyType)aKey;

@end


@interface NSArray (BMExtensions)

/**
 Принимает функцию, которая производит ключи из объектов массива
 */
- (NSDictionary *(^)(id<NSCopying>(^)(id)))dictWithKeys;


- (NSArray *)bm_arrayByRemovingObjects:(NSArray *)objects;

@end
