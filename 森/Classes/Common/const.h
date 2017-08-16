#import <UIKit/UIKit.h>
#import "User.h"
#import "UIColor+Extension.h"
#import "HostTool.h"

// 颜色
#define RGB(r,g,b) [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f)blue:((float) b / 255.0f) alpha:1.0f]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define HEX(hex) [UIColor colorWithHexString:hex alpha:1]
#define HEXA(hex, a) [UIColor colorWithHexString:hex alpha:a]

/** image*/
#define IMAGE(name) [UIImage imageNamed:name]

/** 黄色按钮的字体大小*/
#define FONT(f) [UIFont systemFontOfSize:f]
#define FONT2(f) [UIFont systemFontOfSize:(f / 2.0)]
#define FONTB(f) [UIFont boldSystemFontOfSize:f]

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NETWORK_ERROR @"网络连接失败"

#define USER [User sharedUser]

#define TOKEN USER.access_token

#define ACCOUNT USER.account
#define NIKE_NAME USER.nike_name
#define ALIPAY_ACCOUNT USER.alipay_account
#define BANK_ACCOUNT USER.bank_account
#define IS_ONLINE [User online]

#ifdef DEBUG
    #define Log(FORMAT, ...) fprintf(stderr,"%s: %d\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
//    #define Log(...);
#define Log(FORMAT, ...) fprintf(stderr,"%s: %d\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

//#ifdef DEBUG
//    #define HOST @"http://dev.51isen.com/index.php"
//#else
//    #define HOST @"http://app.51isen.com/index.php"
//#endif

#define HOST [HostTool host]

#define DEBUG_HOST @"http://dev.51isen.com/index.php"
#define RELEASE_HOST @"http://app.51isen.com/index.php"

#define strongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define weakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;

UIKIT_EXTERN NSString *const kRootViewControllerKey;
UIKIT_EXTERN NSString *const kRootViewControllerTigong;
UIKIT_EXTERN NSString *const kRootViewControllerZhuizong;

//阿里云
UIKIT_EXTERN NSString *const kAliyunEndpoint;
UIKIT_EXTERN NSString *const kAliyunBucketName;
UIKIT_EXTERN NSString *const kAliyunAccessKey;
UIKIT_EXTERN NSString *const kAliyunSecretKey;
UIKIT_EXTERN NSString *const kSpecialAccount;
UIKIT_EXTERN NSNotificationName const kUserDidLogoutNotification;
UIKIT_EXTERN NSNotificationName const kUserDidLoginNotification;

UIKIT_EXTERN NSString *const kURLKey;


