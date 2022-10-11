// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTPigeon.h"
#import <sys/utsname.h>

@implementation FLTPigeon
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTPigeon* instance = [[FLTPigeon alloc] init];
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"vn.educa.bridge/bridge_native"
            binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([call.method isEqualToString:@"check"]) {
      result(FlutterMethodNotImplemented);
    } else {
      result(FlutterMethodNotImplemented);
    }
  //do nothing yet
}

@end