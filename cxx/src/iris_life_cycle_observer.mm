#include "iris_life_cycle_observer.h"

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
// #import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
// #import "sdk/objc/Framework/Classes/Audio/RTEAudioSession+Private.h"
// #import "sdk/objc/Framework/Headers/WebRTC/RTEAudioSessionConfiguration.h"
// #import "sdk/objc/Framework/Headers/WebRTC/RTELogging.h"
#endif

#if TARGET_OS_MAC && !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif

namespace agora {
namespace iris {

ILifeCycleObserver::ILifeCycleObserver(std::function<void()> cb){
  callback_ = cb;
}

void ILifeCycleObserver::addApplicationObserver() {


    NSLog(@"ILifeCycleObserver addApplicationObserver");
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

  applicationWillTerminateObserver = (__bridge_retained void *)
#if TARGET_OS_IPHONE
      [center addObserverForName:UIApplicationWillTerminateNotification 
#elif TARGET_OS_MAC
      [center addObserverForName:NSApplicationWillTerminateNotification
#endif
                          object:nil
                           queue:[NSOperationQueue mainQueue]
                      usingBlock:^(NSNotification *notification){
                          callback_();
                      }];
}

void ILifeCycleObserver::removeApplicationObserver() {
  if (applicationWillTerminateObserver != nullptr) {
    id observer = (__bridge_transfer id) applicationWillTerminateObserver;
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    applicationWillTerminateObserver = nullptr;
  }
}

}
}