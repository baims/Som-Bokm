//
//  StoryTelling-Swift2.h
//  StoryTelling
//
//  Created by Bader Alrshaid on 7/28/15.
//  Copyright (c) 2015 Bader Alrshaid. All rights reserved.
//

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
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
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
#if __has_feature(nullability)
#  define SWIFT_NULLABILITY(X) X
#else
# if !defined(__nonnull)
#  define __nonnull
# endif
# if !defined(__nullable)
#  define __nullable
# endif
# if !defined(__null_unspecified)
#  define __null_unspecified
# endif
#  define SWIFT_NULLABILITY(X)
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import RealmSwift;
@import CoreGraphics;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;
@class NSObject;

SWIFT_CLASS("_TtC12StoryTelling11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic) UIWindow * __nullable window;
- (BOOL)application:(UIApplication * __nonnull)application didFinishLaunchingWithOptions:(NSDictionary * __nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * __nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * __nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * __nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * __nonnull)application;
- (void)applicationWillTerminate:(UIApplication * __nonnull)application;
- (SWIFT_NULLABILITY(nonnull) instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class RLMRealm;
@class RLMObjectSchema;
@class RLMSchema;

SWIFT_CLASS("_TtC12StoryTelling7Element")
@interface Element : Object
@property (nonatomic) float positionX;
@property (nonatomic) float positionY;
@property (nonatomic, copy) NSString * __nonnull imageName;
- (SWIFT_NULLABILITY(nonnull) instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithValue:(id __nonnull)value OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithRealm:(RLMRealm * __nonnull)realm schema:(RLMObjectSchema * __nonnull)schema OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithValue:(id __nonnull)value schema:(RLMSchema * __nonnull)schema OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;
@class UIImage;
@class UIPanGestureRecognizer;
@class UIEvent;

SWIFT_CLASS("_TtC12StoryTelling16ElementImageView")
@interface ElementImageView : UIImageView
@property (nonatomic) CGPoint lastLocation;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithImage:(UIImage * __null_unspecified)image OBJC_DESIGNATED_INITIALIZER;
- (void)detectPan:(UIPanGestureRecognizer * __nonnull)recognizer;
- (void)touchesBegan:(NSSet * __nonnull)touches withEvent:(UIEvent * __nonnull)event;
@end

@class UIButton;

SWIFT_CLASS("_TtC12StoryTelling18ElementsScrollView")
@interface ElementsScrollView : UIScrollView
@property (nonatomic, readonly) NSInteger numberOfElements;
@property (nonatomic, readonly) NSInteger heightOfElement;
@property (nonatomic, readonly) NSInteger widthOfElement;
@property (nonatomic, copy) NSArray * __nonnull elementsOnscreen;
@property (nonatomic, copy) NSArray * __nonnull elementsImageName;
- (void)addElements;
- (void)elementTapped:(UIButton * __nonnull)sender;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIStoryboardSegue;
@class NSBundle;

SWIFT_CLASS("_TtC12StoryTelling18HomeViewController")
@interface HomeViewController : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)prepareForSegue:(UIStoryboardSegue * __nonnull)segue sender:(id __nullable)sender;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@class UITextView;

SWIFT_CLASS("_TtC12StoryTelling23TypeStoryViewController")
@interface TypeStoryViewController : UIViewController
@property (nonatomic, copy) NSString * __null_unspecified story;
@property (nonatomic, weak) IBOutlet UITextView * __null_unspecified textView;
- (void)viewDidLoad;
- (IBAction)submitStory:(UIButton * __nonnull)sender;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class LLSimpleCamera;
@class AVPlayer;
@class AVPlayerLayer;
@class NSURL;

SWIFT_CLASS("_TtC12StoryTelling28VideoRecordingViewController")
@interface VideoRecordingViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified snapButton;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified switchCamerasButton;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified cancelRecordingButton;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified useRecordingButton;
@property (nonatomic, weak) IBOutlet UIButton * __null_unspecified retakeVideoButton;
@property (nonatomic) LLSimpleCamera * __null_unspecified camera;
@property (nonatomic) AVPlayer * __nullable avPlayer;
@property (nonatomic) AVPlayerLayer * __nullable avPlayerLayer;
@property (nonatomic, copy) NSString * __null_unspecified nameOfFile;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLayoutSubviews;
- (NSURL * __null_unspecified)applicationDocumentsDirectory;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNotification;

@interface VideoRecordingViewController (SWIFT_EXTENSION(StoryTelling))
- (IBAction)switchCamerasButtonTapped:(UIButton * __nonnull)sender;
- (IBAction)snapButtonTapped:(UIButton * __nonnull)sender;
- (void)endRecording;
- (void)playerItemDidReachEnd:(NSNotification * __nonnull)notification;
- (IBAction)hide:(UIButton * __nonnull)sender;
- (IBAction)retakeVideoButtonTapped:(UIButton * __nonnull)sender;
@end

@class UILabel;
@class UIView;

SWIFT_CLASS("_TtC12StoryTelling14ViewController")
@interface ViewController : UIViewController
@property (nonatomic) NSDate * __null_unspecified dateOfStory;
@property (nonatomic) NSURL * __nullable videoUrl;
@property (nonatomic, weak) IBOutlet UILabel * __null_unspecified storyLabel;
@property (nonatomic, weak) IBOutlet UIView * __null_unspecified typeStoryContainerView;
@property (nonatomic, weak) IBOutlet UIView * __null_unspecified videoRecordingContainerView;
@property (nonatomic, weak) IBOutlet ElementsScrollView * __null_unspecified elementsScrollView;
@property (nonatomic) TypeStoryViewController * __null_unspecified typeStoryViewController;
@property (nonatomic) VideoRecordingViewController * __null_unspecified videoRecordingViewController;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)prepareForSegue:(UIStoryboardSegue * __nonnull)segue sender:(id __nullable)sender;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString * __nullable)identifier sender:(id __nullable)sender;
- (void)enableUserInteractionsForAllElements:(BOOL)enable;
- (IBAction)typeButtonTapped:(UIButton * __nonnull)sender;
- (IBAction)videoButtonTapped:(UIButton * __nonnull)sender;
- (void)viewDidAppear:(BOOL)animated;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithNibName:(NSString * __nullable)nibNameOrNil bundle:(NSBundle * __nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (SWIFT_NULLABILITY(nonnull) instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


@interface ViewController (SWIFT_EXTENSION(StoryTelling))
- (void)showTypeStoryContainerView;
- (void)hideTypeStoryContainerView;
@end


@interface ViewController (SWIFT_EXTENSION(StoryTelling))
- (void)showVideoRecordingContainerView;
- (void)hideVideoRecordingContainerView;
- (void)videoHasBeenRecorded:(NSURL * __nonnull)url;
@end

#pragma clang diagnostic pop
