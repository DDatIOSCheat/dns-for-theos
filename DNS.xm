#import <Foundation/Foundation.h>
#include <substrate.h>

BOOL matchesDomainWithWildcard(NSString *urlString, NSString *domainPattern) {
    // Convert wildcard domain pattern to a regular expression
    NSString *regexPattern = [domainPattern stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    NSError *error = nil;
    
    // Create the regex object
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:0 error:&error];
    
    if (error) {
        NSLog(@"Error creating regex: %@", error);
        return NO;
    }
    
    // Check if the URL matches the regex pattern
    NSRange range = NSMakeRange(0, [urlString length]);
    NSUInteger matches = [regex numberOfMatchesInString:urlString options:0 range:range];
    
    return matches > 0;
}

%hook NSURLRequest

- (instancetype)initWithURL:(NSURL *)URL {
    NSString *urlString = [URL absoluteString];
    
    // Define your blocklist with the new domains
    NSArray *blockedDomains = @[
        @"*.cloudfront.net",
        @"dl.dir.freefiremobile.com",
        @"dl.cdn.freefiremobile.com",
        @"vnevent.ggblueshark.com",
        @"*.apple.com",
        @"mask-api.fe2.apple-dns.net",
        @"mask-api.icloud.com",
        @"app-measurement.com",
        @"ca.iadsdk.apple.com",
        @"gin.freefiremobile.com",
        @"a1756.dscd.akamai.net",
        @"100067.msdk.garena.com",
        @"amp-api-edge.apps.apple.com",
        @"100067.ff.connect.garena.com",
        @"dd.garena.com",
        @"safebrowsing.g.aaplimg.com",
        @"token.safebrowsing.apple",
        @"dl.dir.freefiremobile.com",
        @"100067.connect.garena.com",
        @"100067.ff.connect.garena.com",
        @"*.appsflyersdk.com",
        @"inappcheck.itunes.apple.com",
        @"firebase-settings.crashlytics.com",
        @"*.garenanow.com",
        @"bdversion.ggbluefox.com"
    ];
    
    // Block requests if the URL matches any domain in the blocklist
    for (NSString *domain in blockedDomains) {
        if (matchesDomainWithWildcard(urlString, domain)) {
            NSLog(@"Blocked domain: %@", urlString);
            
            // We return nil here, which will effectively cancel the request
            return nil;  // Block the request
            
        }
    }
    
    return %orig(URL); // Return original URL request if not blocked
}

%end
