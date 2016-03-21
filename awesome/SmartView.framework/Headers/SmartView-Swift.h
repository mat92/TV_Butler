// Generated by Apple Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class Service;
@class ChannelClient;
@class NSError;
@class NSData;
@class NSNotification;
@protocol ChannelDelegate;


/// A Channel is a discreet connection where multiple clients can communicate
///
/// :since: 2.0
SWIFT_CLASS("_TtC9SmartView7Channel")
@interface Channel : NSObject

/// The connection status of the channel
@property (nonatomic, readonly) BOOL isConnected;

/// The uri of the channel ('chat')
@property (nonatomic, readonly, copy) NSString * __null_unspecified uri;

/// the service that is suplaying the channel connection
@property (nonatomic, readonly, strong) Service * __null_unspecified service;

/// The client that owns this channel instance
@property (nonatomic, strong) ChannelClient * __null_unspecified me;

/// The delegate for handling channel events
@property (nonatomic, weak) id <ChannelDelegate> __nullable delegate;

/// The timeout for channel transport connection. The connection will be closed if no ping is received within the defined timeout
@property (nonatomic) NSTimeInterval connectionTimeout;

/// Connects to the channel. This method will asynchronously call the delegate's onConnect method and post a ChannelEvent.Connect notification upon completion. When a TV application connects to this channel, the onReady method/notification is also fired
- (void)connect;

/// Connects to the channel. This method will asynchronously call the delegate's onConnect method and post a ChannelEvent.Connect notification upon completion. When a TV application connects to this channel, the onReady method/notification is also fired
///
/// \param attributes Any attributes you want to associate with the client (ie. ["name":"FooBar"])
- (void)connect:(NSDictionary<NSString *, NSString *> * __nullable)attributes;

/// Connects to the channel. This method will asynchronously call the delegate's onConnect method and post a ChannelEvent.Connect notification upon completion. When a TV application connects to this channel, the onReady method/notification is also fired
///
/// \param attributes Any attributes you want to associate with the client (ie. ["name":"FooBar"])
///
/// \param completionHandler The callback handler
- (void)connect:(NSDictionary<NSString *, NSString *> * __nullable)attributes completionHandler:(void (^ __nullable)(ChannelClient * __nullable, NSError * __nullable))completionHandler;

/// Disconnects from the channel. This method will asynchronously call the delegate's onDisconnect and post a ChannelEvent.Disconnect notification upon completion.
///
/// <ul><li>client: The client that is disconnecting which is yourself</li><li>error: An error info if disconnect fails</li></ul>
/// \param completionHandler The callback handler
- (void)disconnect:(void (^ __nullable)(ChannelClient * __nullable, NSError * __nullable))completionHandler;

/// Disconnects from the channel. This method will asynchronously call the delegate's onDisconnect and post a ChannelEvent.Disconnect notification upon completion.
- (void)disconnect;

/// Publish an event containing a text message payload
///
/// \param event The event name
///
/// \param message A JSON serializable message object
- (void)publishWithEvent:(NSString * __nonnull)event message:(id __nullable)message;

/// Publish an event containing a text message and binary payload
///
/// \param event The event name
///
/// \param message A JSON serializable message object
///
/// \param data Any binary data to send with the message
- (void)publishWithEvent:(NSString * __nonnull)event message:(id __nullable)message data:(NSData * __nonnull)data;

/// Publish an event with text message payload to one or more targets
///
/// \param event The event name
///
/// \param message A JSON serializable message object
///
/// \param target The target recipient(s) of the message.Can be a string client id, a collection of ids or a string MessageTarget (like MessageTarget.All.rawValue)
- (void)publishWithEvent:(NSString * __nonnull)event message:(id __nullable)message target:(id __nonnull)target;

/// Publish an event containing a text message and binary payload to one or more targets
///
/// \param event The event name
///
/// \param message A JSON serializable message object
///
/// \param data Any binary data to send with the message
///
/// \param target The target recipient(s) of the message.Can be a string client id, a collection of ids or a string MessageTarget (like MessageTarget.All.rawValue)
- (void)publishWithEvent:(NSString * __nonnull)event message:(id __nullable)message data:(NSData * __nonnull)data target:(id __nonnull)target;

/// A snapshot of the list of clients currently connected to the channel
- (NSArray<ChannelClient *> * __nonnull)getClients;

/// A convenience method to subscribe for notifications using blocks.
///
/// \param notificationName The name of the notification.
///
/// \param performClosure The notification closure, which will be executed in the main thread.
/// Make sure to control the ownership of a variables captured by the closure you provide in this parameter
/// (e.g. use [unowned self] or [weak self] to make sure that self is released even if you did not unsubscribe from notification)
///
/// \returns  An observer handler for removing/unsubscribing the block from notifications
- (id __nullable)on:(NSString * __nonnull)notificationName performClosure:(void (^ __nonnull)(NSNotification * __null_unspecified))performClosure;

/// A convenience method to unsubscribe from notifications
///
/// \param observer The observer object to unregister observations
- (void)off:(id __nonnull)observer;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@end



/// An Application represents an application on the TV device. Use this class to control various aspects of the application such as launching the app or getting information
SWIFT_CLASS("_TtC9SmartView11Application")
@interface Application : Channel

/// The id of the channel
@property (nonatomic, readonly, copy) NSString * __null_unspecified id;
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * __nullable args;

/// Retrieves information about the Application on the TV
///
/// \param completionHandler The callback handler with the status dictionary and an error if any
- (void)getInfo:(void (^ __nonnull)(NSDictionary<NSString *, id> * __nullable, NSError * __nullable))completionHandler;

/// Launches the application on the remote device, if the application is already running it returns success = true. If the startOnConnect is set to false this method needs to be called in order to start the application
///
/// \param completionHandler The callback handler
- (void)start:(void (^ __nullable)(BOOL, NSError * __nullable))completionHandler;

/// Stops the application on the TV
///
/// \param completionHandler The callback handler
- (void)stop:(void (^ __nullable)(BOOL, NSError * __nullable))completionHandler;

/// Starts the application install on the TV, this method will fail for cloud applications
///
/// \param completionHandler The callback handler
- (void)install:(void (^ __nullable)(BOOL, NSError * __nullable))completionHandler;

/// MARK: override channel connect
- (void)connect:(NSDictionary<NSString *, NSString *> * __nullable)attributes completionHandler:(void (^ __nullable)(ChannelClient * __nullable, NSError * __nullable))completionHandler;

/// Disconnects your client with the host TV app
///
/// \param leaveHostRunning True leaves the TV app running False stops the TV app if yours is the last client
///
/// \param completionHandler The callback handler
- (void)disconnectWithLeaveHostRunning:(BOOL)leaveHostRunning completionHandler:(void (^ __nullable)(ChannelClient * __nullable, NSError * __nullable))completionHandler;

/// Disconnect from the channel and leave the host application running if leaveHostRunning is set to true and you are the last client
///
/// \param leaveHostRunning True leaves the TV app running False stops the TV app if yours is the last client
- (void)disconnectWithLeaveHostRunning:(BOOL)leaveHostRunning;

/// Disconnect from the channel and terminate the host application if you are the last client
- (void)disconnect:(void (^ __nullable)(ChannelClient * __nullable, NSError * __nullable))completionHandler;
@end


@interface Application (SWIFT_EXTENSION(SmartView))
@end



@interface Channel (SWIFT_EXTENSION(SmartView))
@end


@interface Channel (SWIFT_EXTENSION(SmartView))
@end


@interface Channel (SWIFT_EXTENSION(SmartView))
@end

@class NSDate;


/// A client currently connected to the channel
SWIFT_CLASS("_TtC9SmartView13ChannelClient")
@interface ChannelClient : NSObject

/// The id of the client
@property (nonatomic, readonly, copy) NSString * __nonnull id;

/// The time which the client connected in epoch milliseconds
@property (nonatomic, readonly, strong) NSDate * __nullable connectTime;

/// A dictionary of attributes passed by the client when connecting
@property (nonatomic, readonly, strong) id __nullable attributes;

/// Flag for determining if the client is the host
@property (nonatomic, readonly) BOOL isHost;

/// The description of the client
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@end

@class Message;


/// The channel delegate protocol defines the event methods available for a channel
SWIFT_PROTOCOL("_TtP9SmartView15ChannelDelegate_")
@protocol ChannelDelegate
@optional

/// Called when the Channel is connected
///
/// \param client The Client that just connected to the Channel
///
/// \param error An error info if any
- (void)onConnect:(ChannelClient * __nullable)client error:(NSError * __nullable)error;

/// Called when the host app is ready to send or receive messages
- (void)onReady;

/// Called when the Channel is disconnected
///
/// \param client The Client that just disconnected from the Channel
///
/// \param error An error info if any
- (void)onDisconnect:(ChannelClient * __nullable)client error:(NSError * __nullable)error;

/// Called when the Channel receives a text message
///
/// \param message Text message received
- (void)onMessage:(Message * __nonnull)message;

/// Called when the Channel receives a binary data message
///
/// \param message Text message received
///
/// \param payload Binary payload data
- (void)onData:(Message * __nonnull)message payload:(NSData * __nonnull)payload;

/// Called when a client connects to the Channel
///
/// \param client The Client that just connected to the Channel
- (void)onClientConnect:(ChannelClient * __nonnull)client;

/// Called when a client disconnects from the Channel
///
/// \param client The Client that just disconnected from the Channel
- (void)onClientDisconnect:(ChannelClient * __nonnull)client;

/// Called when a Channel Error is fired
///
/// \param error The error
- (void)onError:(NSError * __nonnull)error;
@end



/// This class encapsulates the message that
SWIFT_CLASS("_TtC9SmartView7Message")
@interface Message : NSObject

/// The event name
@property (nonatomic, readonly, copy) NSString * __null_unspecified event;

/// The publisher of the event
@property (nonatomic, readonly, copy) NSString * __null_unspecified from;

/// A dictionary containig the message
@property (nonatomic, readonly, strong) id __nullable data;
@end

enum ServiceSearchDiscoveryType : NSInteger;
@class ServiceSearch;


/// A Service instance represents the multiscreen service root on the remote device Use the class to control top level services of the device
SWIFT_CLASS("_TtC9SmartView7Service")
@interface Service : NSObject
@property (nonatomic, readonly) enum ServiceSearchDiscoveryType discoveryType;

/// The id of the service
@property (nonatomic, readonly, copy) NSString * __nonnull id;

/// The uri of the service (http://<ip>:<port>/api/v2/)
@property (nonatomic, readonly, copy) NSString * __nonnull uri;

/// The name of the service (Living Room TV)
@property (nonatomic, readonly, copy) NSString * __nonnull name;

/// The version of the service (x.x.x)
@property (nonatomic, readonly, copy) NSString * __nonnull version;

/// The type of the service (Samsung SmartTV)
@property (nonatomic, readonly, copy) NSString * __nonnull type;

/// The service description
@property (nonatomic, readonly, copy) NSString * __nonnull description;

/// This asynchronously method retrieves a dictionary of additional information about the device the service is running on
///
/// \param timeout timeout
///
/// \param completionHandler A block to handle the response dictionary<ul><li>deviceInfo: The device info dictionary</li><li>error: An error info if getDeviceInfo failed</li></ul>
- (void)getDeviceInfo:(NSInteger)timeout completionHandler:(void (^ __nonnull)(NSDictionary<NSString *, id> * __nullable, NSError * __nullable))completionHandler;

/// Creates an application instance belonging to that service
///
/// <ul><li>For an installed application this is the string id as provided by Samsung, If your TV app is still in development, you can use the folder name of your app as the id. Once the TV app has been released into Samsung Apps, you must use the supplied app id.`</li><li>For a cloud application this is the application's URL</li></ul>
/// \param id The id of the application
///
/// \param channelURI The uri of the Channel ("com.samsung.multiscreen.helloworld")
///
/// \param args A dictionary of command line aruguments to be passed to the Host TV App
///
/// \returns  An Application instance or nil if application id or channel id is empty
- (Application * __nullable)createApplication:(id __nonnull)id channelURI:(NSString * __nonnull)channelURI args:(NSDictionary<NSString *, id> * __nullable)args;

/// Creates a channel instance belonging to that service ("mychannel")
///
/// <ul><li>`: The uri of the Channel ("com.samsung.multiscreen.helloworld")</li></ul>
/// \returns  A Channel instance
- (Channel * __nonnull)createChannel:(NSString * __nonnull)channelURI;

/// Creates a service search object
///
/// \returns  An instance of ServiceSearch
+ (ServiceSearch * __nonnull)search;

/// This asynchronous method retrieves a service instance given a service URI
///
/// <ul><li>service: The service instance</li><li>timeout: The timeout for the request</li><li>error: An error info if getByURI fails</li></ul>
/// \param uri The uri of the service
///
/// \param completionHandler The completion handler with the service instance or an error
+ (void)getByURI:(NSString * __nonnull)uri timeout:(NSTimeInterval)timeout completionHandler:(void (^ __nonnull)(Service * __nullable, NSError * __nullable))completionHandler;

/// This asynchronous method retrieves a service instance given a service id
///
/// <ul><li>service: The service instance</li><li>error: An error info if getById fails</li></ul>
/// \param id The id of the service
///
/// \param completionHandler The completion handler with the service instance or an error
+ (void)getById:(NSString * __nonnull)id completionHandler:(void (^ __nonnull)(Service * __nullable, NSError * __nullable))completionHandler;
@end

@protocol ServiceSearchDelegate;


/// This class searches the local network for compatible multiscreen services
SWIFT_CLASS("_TtC9SmartView13ServiceSearch")
@interface ServiceSearch : NSObject

/// Set a delegate to receive search events.
@property (nonatomic, weak) id <ServiceSearchDelegate> __nullable delegate;

/// The search status
@property (nonatomic, readonly) BOOL isSearching;
- (NSArray<Service *> * __nonnull)getServices;

/// A convenience method to suscribe for notifications using blocks
///
/// \param notificationName The name of the notification
///
/// \param performClosure The notification block, this block will be executed in the main thread
///
/// \returns  An observer handler for removing/unsubscribing the block from notifications
- (id __nonnull)on:(NSString * __nonnull)notificationName performClosure:(void (^ __nonnull)(NSNotification * __null_unspecified))performClosure;

/// A convenience method to unsuscribe from notifications
///
/// \param observer The observer object to unregister observations
- (void)off:(id __nonnull)observer;

/// Start the search
- (void)start;
- (BOOL)isSearchingBLE;

/// Start BLE Search Process
- (BOOL)startUsingBLE;

/// Stop BLE Search Process
- (BOOL)stopUsingBLE;

/// Stops the search
- (void)stop;
@end


@interface ServiceSearch (SWIFT_EXTENSION(SmartView))
@end


@interface ServiceSearch (SWIFT_EXTENSION(SmartView))
@end



/// This protocol defines the methods for ServiceSearch discovery
SWIFT_PROTOCOL("_TtP9SmartView21ServiceSearchDelegate_")
@protocol ServiceSearchDelegate
@optional

/// The ServiceSearch will call this delegate method when a service is found
///
/// \param service The found service
- (void)onServiceFound:(Service * __nonnull)service;

/// The ServiceSearch will call this delegate method when a service is lost
///
/// \param service The lost service
- (void)onServiceLost:(Service * __nonnull)service;

/// The ServiceSearch will call this delegate method after stopping the search
- (void)onStop;

/// The ServiceSearch will call this delegate method after the search has started
- (void)onStart;

/// If BLE device is found
- (void)onFoundOnlyBLE:(NSString * __nonnull)NameOfTV;

/// Find other network (other than BLE)
- (void)onFoundOtherNetwork:(NSString * __nonnull)NameOfTV;
@end

typedef SWIFT_ENUM(NSInteger, ServiceSearchDiscoveryType) {
  ServiceSearchDiscoveryTypeLAN = 0,
  ServiceSearchDiscoveryTypeCLOUD = 1,
};

#pragma clang diagnostic pop
