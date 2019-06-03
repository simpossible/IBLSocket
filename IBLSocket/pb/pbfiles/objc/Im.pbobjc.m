// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: im.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 1
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProstocolBuffers_RuntimeSupport.h"
#endif

#import "Im.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - ImRoot

@implementation ImRoot

// No extensions in the file and none of the imports (direct or indirect)
// defined extensions, so no need to generate +extensionRegistry.

@end

#pragma mark - ImRoot_FileDescriptor

static GPBFileDescriptor *ImRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"tutorial"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - IBLBaseReq

@implementation IBLBaseReq

@dynamic appId;
@dynamic marketId;
@dynamic sendName;

typedef struct IBLBaseReq__storage_ {
  uint32_t _has_storage_[1];
  uint32_t appId;
  uint32_t marketId;
  NSString *sendName;
} IBLBaseReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "appId",
        .dataTypeSpecific.className = NULL,
        .number = IBLBaseReq_FieldNumber_AppId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(IBLBaseReq__storage_, appId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "marketId",
        .dataTypeSpecific.className = NULL,
        .number = IBLBaseReq_FieldNumber_MarketId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(IBLBaseReq__storage_, marketId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "sendName",
        .dataTypeSpecific.className = NULL,
        .number = IBLBaseReq_FieldNumber_SendName,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(IBLBaseReq__storage_, sendName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[IBLBaseReq class]
                                     rootClass:[ImRoot class]
                                          file:ImRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(IBLBaseReq__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\010\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    #if defined(DEBUG) && DEBUG
      NSAssert(descriptor == nil, @"Startup recursed!");
    #endif  // DEBUG
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)