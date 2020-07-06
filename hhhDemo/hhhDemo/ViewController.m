//
//  ViewController.m
//  hhhDemo
//
//  Created by Tyler Cloud on 2020/7/2.
//  Copyright © 2020 Tyler Cloud. All rights reserved.
//

#import "ViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface ViewController () <SKPSMTPMessageDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (IBAction)sendMail:(id)sender {
    
    SKPSMTPMessage *myMessage = [[SKPSMTPMessage alloc] init];
    myMessage.fromEmail=@"794334810@qq.com";
    
    myMessage.toEmail=@"1973376397@qq.com";
//    myMessage.bccEmail=@"1374966541@qq.com";
    myMessage.relayHost=@"smtp.qq.com";
    
    myMessage.requiresAuth=YES;
    if (myMessage.requiresAuth) {
        myMessage.login=@"794334810@qq.com";
        
        myMessage.pass=@"fszhwazfsakvbegd";
        
    }
    
    myMessage.wantsSecure =YES; //为gmail邮箱设置 smtp.gmail.com
    
    myMessage.subject = @"博客园-FlyElephant";

    myMessage.delegate = self;
    
    //设置邮件内容
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain; charset=UTF-8",kSKPSMTPPartContentTypeKey,
                               @"发送一个附件试试喽！~xueyong",kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    NSString *fileName = @"临港云";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xls"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
    
    NSDictionary *xlsPart;
    // 2.2、附件 - txt
    xlsPart = @{kSKPSMTPPartContentTypeKey:@"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"text.txt\"",
                kSKPSMTPPartContentDispositionKey:@"attachment;\r\n\tfilename=\"text.txt\"",
                kSKPSMTPPartMessageKey:[fileData encodeBase64ForData],
                kSKPSMTPPartContentTransferEncodingKey:@"base64"};
    
    
    myMessage.parts = @[plainPart, xlsPart];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [myMessage send];
    });
}

- (void)messageSent:(SKPSMTPMessage *)message
{
  NSLog(@"恭喜,邮件发送成功");
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"不好意思,邮件发送失败");
    
}

@end
