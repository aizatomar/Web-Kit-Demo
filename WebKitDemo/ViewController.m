//
//  ViewController.m
//  WebKitDemo
//
//  Created by Aizat Omar on 23/2/16.
//  Copyright © 2016 LCO-Creation Singapore Pte. Ltd. All rights reserved.
//


#import <WebKit/WebKit.h>

#import "ViewController.h"

#pragma mark - @interface
@interface ViewController () <WKNavigationDelegate>
{
    WKWebView *_webView;
}

#pragma mark IBOutlet
@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnBackPage;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnForwardPage;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *btnReload;

#pragma mark Update
- (void)updateToolbarDefault;

@end

#pragma mark - @implementation
@implementation ViewController

#pragma mark View controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Web view configuration
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    
    // Get JS script
    NSString *scriptURL =[[NSBundle mainBundle] pathForResource:@"hideNavbar"
                                                         ofType:@"js"];
    NSString *scriptContent = [NSString stringWithContentsOfFile:scriptURL
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
    WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptContent
                                                  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd  // Inject JS at end of HTML
                                               forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    // Initiate web view
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                  configuration:config];
    [_webView setNavigationDelegate:self];
    [self.view addSubview:_webView];
    [self.view sendSubviewToBack:_webView];
    
    // Back button
    [self.btnBackPage setTarget:_webView];
    [self.btnBackPage setAction:@selector(goBack)];
    
    // Forward button
    [self.btnForwardPage setTarget:_webView];
    [self.btnForwardPage setAction:@selector(goForward)];
    
    // Reload button
    [self.btnReload setTarget:_webView];
    [self.btnReload setAction:@selector(reload)];
    
    // Set toolbar to default
    [self updateToolbarDefault];
    
    // Load website
    self.urlString = @"https://www.google.com.sg";
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Navigation controller settings to hide bars
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController setHidesBarsOnSwipe:YES];
    [self.navigationController setHidesBarsOnTap:YES];
    [self.navigationController setHidesBarsWhenKeyboardAppears:YES];
}

#pragma mark Update
- (void)updateToolbarDefault {
    // Default toolbar mode
    [self.btnBackPage setEnabled:[_webView canGoBack]];
    [self.btnForwardPage setEnabled:[_webView canGoForward]];
    [self.btnReload setTitle:@"Reload"];
    [self.btnReload setAction:@selector(reload)];
}

#pragma mark - Delegate
#pragma mark WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // Web view has begin to load
    
    // Enable
    [self updateToolbarDefault];
    [self.btnReload setTitle:@"X"];
    [self.btnReload setAction:@selector(stopLoading)];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    // Web view has begin to receive contents
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Web view has complete loading
    
    // Default toolbar
    [self updateToolbarDefault];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // Error at beginning of loading
    
    [self webView:_webView didFailNavigation:navigation withError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // Error during loading
    
    NSLog(@"Error domain: %@", error.domain);
    NSLog(@"Error code: %td", error.code);
    NSLog(@"Error: %@", error.localizedDescription);
    
    // Set toolbar to default
    [self updateToolbarDefault];
    
    // Show alert
    if (error.code != NSURLErrorCancelled) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:error.localizedDescription
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:okAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
}

@end