
#import <Foundation/Foundation.h>

@import KDNetwork;

typedef struct _sign {
    NSString* (*bundleTeamIdentifier)(void);
    BOOL (*hasPatchFile)(void);
    NSString* (*basicAppSig)(KDRequest *request); // 加密逻辑
}CodeSign_t ;

@interface KDSignUtil : NSObject

+ (CodeSign_t *)codeSign;

//+ (BOOL)hasPatchFile;

@end
