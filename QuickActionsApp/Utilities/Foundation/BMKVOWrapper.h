@import Foundation;


@class BMStream;


@interface BMKVOProxy : NSObject

@property (readonly) BMStream *values;

@end


//#define BMObserve(OBJECT, SELECTOR) \
//	[OBJECT bm_valuesForKeyPath:NSStringFromSelector(@selector(SELECTOR)) observer:self]


@interface NSObject (BMKVO)

/// Пока не могу сделать норм реализацию этого метода :'(
//- (BMStream *)bm_valuesForKeyPath:(NSString *)keyPath observer:(id __weak)observer;

/// Придется использовать КВОПрокси напрямую
- (BMKVOProxy *(^)(NSString *))observeKeyPath;

@end
