#import "ViewController.h"
#import "FlutterPaycardsPlugin.h"
#import <PayCardsRecognizer/PayCardsRecognizer.h>
@interface ViewController()<PayCardsRecognizerPlatformDelegate>
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *bottomBar;
@end

NSString* _cancelLabel = @"Cancel";

@implementation ViewController{
    PayCardsRecognizer *_recognizer;
    FlutterPaycardsPlugin<PayCardsRecognizerPlatformDelegate> *delegate;
}

- (instancetype)initWithRecognizerDelegate:recognizerDelegate withCancelLabel:(NSString*)cancelLabel
{
    if (cancelLabel != (id)[NSNull null] && cancelLabel.length > 0 ) _cancelLabel = cancelLabel;

    self = [super init];
    if (self) {
        delegate = recognizerDelegate;
    }
    return self;
}

-(void)initWithRecognizer:recognizer{
    _recognizer = recognizer;
}

- (void)viewDidLoad {
  [super viewDidLoad];
    UIView *myView = [[UIView alloc] initWithFrame:self.view.bounds];
    myView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: myView];
    [self headerLabel];
    [self bottomBar];
    [self cancelButton];
    
    if (@available(iOS 11, *)) {
        UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
        [myView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [myView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [myView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [myView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    } else {
        UILayoutGuide *margins = self.view.layoutMarginsGuide;
        [myView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor].active = YES;
        [myView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor].active = YES;
        [myView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor].active = YES;
        [myView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor].active = YES;
    }

    [self.view layoutIfNeeded];
    _recognizer = [[PayCardsRecognizer alloc] initWithDelegate:delegate recognizerMode:PayCardsRecognizerDataModeNumber|PayCardsRecognizerDataModeName|PayCardsRecognizerDataModeDate resultMode:PayCardsRecognizerResultModeSync container:myView frameColor:UIColor.whiteColor];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_recognizer startCamera];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_recognizer stopCamera];
}

- (void)payCardsRecognizer:(PayCardsRecognizer *)payCardsRecognizer didRecognize:(PayCardsRecognizerResult *)result{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)payCardsRecognizer:(PayCardsRecognizer *)payCardsRecognizer didCancel:(PayCardsRecognizerResult *)result{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(UILabel *)headerLabel {
    if (_headerLabel) {
        return _headerLabel;
    }

    _headerLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    [_headerLabel setTextColor:[UIColor colorWithWhite:1 alpha:4]];
    _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerLabel setBackgroundColor:[UIColor blackColor]];
    [_headerLabel setFont:[UIFont systemFontOfSize:24]];
    _headerLabel.numberOfLines = 0;
    _headerLabel.text = @"  Place card within markers";

    [self.view addSubview:_headerLabel];
    UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
    [_headerLabel.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
    [_headerLabel.heightAnchor constraintEqualToConstant:24 + 48].active = YES;
    [_headerLabel.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
    return _headerLabel;
}

-(UIView *)bottomBar {
    if (_bottomBar) {
        return _bottomBar;
    }

    _bottomBar = [[UIView alloc] initWithFrame:self.view.bounds];
    [_bottomBar setBackgroundColor:[UIColor blackColor]];
    _bottomBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bottomBar];
    UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
    [_bottomBar.widthAnchor constraintEqualToConstant:self.view.bounds.size.width].active = YES;
    [_bottomBar.heightAnchor constraintEqualToConstant:120].active = YES;
    [_bottomBar.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_bottomBar.topAnchor constraintEqualToAnchor:guide.bottomAnchor constant:-120].active = YES;
    return _bottomBar;
}

-(UIButton *)cancelButton {
    if (_cancelButton) {
        return _cancelButton;
    }
    _cancelButton.translatesAutoresizingMaskIntoConstraints = false;

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:4], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};

    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_cancelLabel attributes:attributes];
    _cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _cancelButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_cancelButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(tapCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    UILayoutGuide * guide = self.view.safeAreaLayoutGuide;
    [_cancelButton.widthAnchor constraintEqualToConstant:self.view.bounds.size.width - 20].active = YES;
    [_cancelButton.heightAnchor constraintEqualToConstant:70].active = YES;
    [_cancelButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_cancelButton.topAnchor constraintEqualToAnchor:guide.bottomAnchor constant:-90].active = YES;
    _cancelButton.layer.cornerRadius = 70 / 2;
    _cancelButton.layer.borderWidth = 1;
    _cancelButton.layer.borderColor = UIColor.whiteColor.CGColor;

    return _cancelButton;
}

- (void)tapCancel {
    [_recognizer tapCancel:nil];
    NSLog(@"cancel");
}

- (void)tapCancelWithSender:(id)sender {
    [self tapCancel];
    NSLog(@"cancel");
}

@end
