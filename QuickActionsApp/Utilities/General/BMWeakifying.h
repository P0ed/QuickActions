#define weakify(var) __weak typeof(var) BMWeak_##var = var;

#define strongify(var) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong typeof(var) var = BMWeak_##var; \
_Pragma("clang diagnostic pop")
