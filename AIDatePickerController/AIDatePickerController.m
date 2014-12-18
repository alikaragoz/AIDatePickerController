//
//  AIDatePickerController.m
//  AIDatePickerController
//
//  Created by Ali Karagoz on 27/10/2013.
//  Copyright (c) 2013 Ali Karagoz All rights reserved.
//

#import "AIDatePickerController.h"

static NSTimeInterval const AIAnimatedTransitionDuration = 0.4;

@interface AIDatePickerController () <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *selectButton;
@property (nonatomic) UIButton *dismissButton;
@property (nonatomic) UIView *buttonDivierView;
@property (nonatomic) UIView *buttonContainerView;
@property (nonatomic) UIView *datePickerContainerView;
@property (nonatomic) UIView *dimmedView;

// UIButton Actions
- (void)didTouchCancelButton:(id)sender;
- (void)didTouchSelectButton:(id)sender;

@end

@implementation AIDatePickerController

#pragma mark - Init

+ (id)pickerWithDate:(NSDate *)date selectedBlock:(AIDatePickerDateBlock)selectedBlock cancelBlock:(AIDatePickerVoidBlock)cancelBlock {
    
    if (![date isKindOfClass:NSDate.class]) {
        date = [NSDate date];
    }
    
    AIDatePickerController *datePickerController = [AIDatePickerController new];
    datePickerController.datePicker.date = date;
    datePickerController.dateBlock = [selectedBlock copy];
    datePickerController.voidBlock = [cancelBlock copy];
    return datePickerController;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Custom transition
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    // Date Picker
    _datePicker = [UIDatePicker new];
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    // Dismiss View
    _dismissButton = [UIButton new];
    _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dismissButton.userInteractionEnabled = YES;
    [_dismissButton addTarget:self action:@selector(didTouchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dismissButton];
    
    // Date Picker Container
    _datePickerContainerView = [UIView new];
    _datePickerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    _datePickerContainerView.backgroundColor = [UIColor whiteColor];
    _datePickerContainerView.clipsToBounds = YES;
    _datePickerContainerView.layer.cornerRadius = 5.0;
    [self.view addSubview:_datePickerContainerView];
    
    // Date Picker
    [_datePickerContainerView addSubview:_datePicker];
    
    // Button Container View
    _buttonContainerView = [UIView new];
    _buttonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonContainerView.backgroundColor =  [UIColor whiteColor];
    _buttonContainerView.layer.cornerRadius = 5.0;
    [self.view addSubview:_buttonContainerView];
    
    // Button Divider
    _buttonDivierView = [UIView new];
    _buttonDivierView.translatesAutoresizingMaskIntoConstraints = NO;
    _buttonDivierView.backgroundColor =  [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
    [_buttonContainerView addSubview:_buttonDivierView];
    
    // Cancel Button
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(didTouchCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonContainerView addSubview:_cancelButton];
    
    // Select Button
    _selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_selectButton addTarget:self action:@selector(didTouchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setTitle:NSLocalizedString(@"Select", nil) forState:UIControlStateNormal];
    
    CGFloat fontSize = _selectButton.titleLabel.font.pointSize;
    _selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    
    [_buttonContainerView addSubview:_selectButton];
    
    // Layout
    NSDictionary *views = NSDictionaryOfVariableBindings(_dismissButton,
                                                         _datePickerContainerView,
                                                         _datePicker,
                                                         _buttonContainerView,
                                                         _buttonDivierView,
                                                         _cancelButton,
                                                         _selectButton);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_cancelButton][_buttonDivierView(0.5)][_selectButton(_cancelButton)]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_cancelButton]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_buttonDivierView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_selectButton]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_datePicker]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_datePicker]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_dismissButton]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_datePickerContainerView]-5-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_buttonContainerView]-5-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_dismissButton][_datePickerContainerView]-10-[_buttonContainerView(40)]-5-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
}

#pragma mark - UIButton Actions

- (void)didTouchCancelButton:(id)sender {
    if (self.voidBlock != nil) {
        self.voidBlock();
        self.voidBlock = nil;
    }
}

- (void)didTouchSelectButton:(id)sender {
    if (self.dateBlock != nil) {
        self.dateBlock(self.datePicker.date);
        self.dateBlock = nil;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return AIAnimatedTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    // If we are presenting
    if (toViewController.view == self.view) {
        fromViewController.view.userInteractionEnabled = NO;
        
        // Adding the view in the right order
        [containerView addSubview:self.dimmedView];
        [containerView addSubview:toViewController.view];
        
        // Moving the view OUT
        CGRect frame = toViewController.view.frame;
        frame.origin.y = CGRectGetHeight(toViewController.view.bounds);
        toViewController.view.frame = frame;
        
        self.dimmedView.alpha = 0.0;
        
        [UIView animateWithDuration:AIAnimatedTransitionDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.dimmedView.alpha = 0.5;
            
            // Moving the view IN
            CGRect frame = toViewController.view.frame;
            frame.origin.y = 0.0;
            toViewController.view.frame = frame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
    
    // If we are dismissing
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:AIAnimatedTransitionDuration delay:0.1 usingSpringWithDamping:1.0 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.dimmedView.alpha = 0.0;
            
            // Moving the view OUT
            CGRect frame = fromViewController.view.frame;
            frame.origin.y = CGRectGetHeight(fromViewController.view.bounds);
            fromViewController.view.frame = frame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source {
    return self;
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - Factory Methods

- (UIView *)dimmedView {
    if (!_dimmedView) {
        UIView *dimmedView = [[UIView alloc] initWithFrame:self.view.bounds];
        dimmedView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        dimmedView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        dimmedView.backgroundColor = [UIColor blackColor];
        _dimmedView = dimmedView;
    }
    
    return _dimmedView;
}

@end
