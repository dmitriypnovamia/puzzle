#import <Foundation/NSMethodSignature.h>
extern NSMethodSignature *YOLOMS(id);
extern int YOLOArgCount(id);

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#define YOLOIsClass(arg) class_isMetaClass(object_getClass(arg))
