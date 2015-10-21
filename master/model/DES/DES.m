//
//  DES.m
//  master
//
//  Created by jin on 15/6/10.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "DES.h"
#import <CommonCrypto/CommonCryptor.h>
@implementation DES

+(NSData*)decryptWithText:(NSString *)sText Key:(NSString *)key{

    NSString*result;
    NSData* data;
    NSData *base64 = [GTMBase64 webSafeDecodeString:sText];
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [base64 length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [base64 bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        data=  [[NSData alloc]initWithBytes:buffer length:numBytesEncrypted];
    }
    return  data;

}

@end
