@import Foundation;


@interface NSMethodSignature (BlockSignature)

+ (instancetype)signatureWithBlock:(id)block;

@end


extern NSMethodSignature *BMBlockSignature(id block);
