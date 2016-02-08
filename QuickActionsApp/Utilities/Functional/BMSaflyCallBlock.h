@import Foundation;

/**
 * Can be one of these:
 * <p>Void → Void</p>
 * <p>Void → AnyObject</p>
 * <p>AnyObject → Void</p>
 * <p>AnyObject → AnyObject</p>
 */
typedef id BMBlock;

/**
 * Supports following signatures:
 * <p>Void → Void</p>
 * <p>Void → AnyObject</p>
 * <p>AnyObject → Void</p>
 * <p>AnyObject → AnyObject</p>
 */
extern id __nullable BMSaflyCallBlock(BMBlock __nullable block, id __nullable arg);


#define bm_safeBlockCall(block, ...) block ? block(__VA_ARGS__) : nil
