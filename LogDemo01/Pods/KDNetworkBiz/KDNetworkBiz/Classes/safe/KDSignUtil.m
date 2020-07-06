#import "KDSignUtil.h"

@import KDFoundation;

static NSString *bundleTeamIdentifier(void) {
    return ({
        static NSString *teamIdentifier = nil;
        
        if (teamIdentifier.length <= 0) {
            NSString *mobileProvisionPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"embedded.mobileprovision"];
            FILE *fp = fopen([mobileProvisionPath UTF8String],"r");
            
            if(fp != NULL) {
                char ch;
                NSMutableString *str = [NSMutableString string];
                while((ch = fgetc(fp)) != EOF) {
                    [str appendFormat:@"%c",ch];
                }
                fclose(fp);
                
                NSRange teamIdentifierRange = [str rangeOfString:@"<key>com.apple.developer.team-identifier</key>"];
                if (teamIdentifierRange.location != NSNotFound) {
                    NSInteger location = teamIdentifierRange.location + teamIdentifier.length;
                    NSInteger length = [str length] - location;
                    if (length > 0 && location >= 0) {
                        NSString *newStr = [str substringWithRange:NSMakeRange(location, length)];
                        NSArray *val = [newStr componentsSeparatedByString:@"</string>"];
                        NSString *v = [val firstObject];
                        NSRange startRange = [v rangeOfString:@"<string>"];
                        
                        NSInteger newLocation = startRange.location + startRange.length;
                        NSInteger newLength = [v length] - newLocation;
                        if (newLength > 0 && location >= 0) {
                            teamIdentifier = [v substringWithRange:NSMakeRange(newLocation, newLength)];
                        }
                    }
                }
            }
            
            // 从appstore下载的app 现在无法获取到，设置默认值
            if (teamIdentifier.length <= 0) {
                NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:@"OE04WTc5NzNEMw==" options:0]; // decode base64
                teamIdentifier = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            }
        }
        
        teamIdentifier;
    });
}

static NSString* basicAppSig(KDRequest *request) {
    return ({
        NSString *result = @"";
        
        NSString *teamIdentifier = bundleTeamIdentifier();
        
        result = [NSString stringWithFormat:@"%@%@%@", [teamIdentifier kd_md5Sting], request.oauthTimestamp, request.oauthNonce];
        result = [result kd_md5Sting];
        
        result;
    });
}


static CodeSign_t * util = NULL;

@implementation KDSignUtil

+ (CodeSign_t *)codeSign
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = malloc(sizeof(CodeSign_t));
        util->bundleTeamIdentifier = bundleTeamIdentifier;
        util->basicAppSig = basicAppSig;
    });
    return util;
}

+ (void)destroy
{
    util ? free(util): 0;
    util = NULL;
}

@end
