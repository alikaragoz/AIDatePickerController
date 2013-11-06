//
//  AIDatePickerController.h
//  AIDatePickerController
//
//  Created by Ali Karagoz on 27/10/2013.
//  Copyright (c) 2013 Ali Karagoz All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  The Block which is executed when the select button is touched.
 *
 *  @param date The date that is picked.
 *
 *  @return void
 */
typedef void (^AIDatePickerDateBlock)(NSDate *date);

/**
 *  The Block which is executed when the cancel button is touched.
 *
 *  @param void
 *
 *  @return void
 */
typedef void (^AIDatePickerVoidBlock)(void);

@interface AIDatePickerController : UIViewController

/**
 *  The `UIDatePicker` object used in the component.
 */
@property (nonatomic) UIDatePicker *datePicker;

/**
 * The Block which is executed when the select button is touched.
 */
@property (nonatomic, copy) AIDatePickerDateBlock dateBlock;

/**
 *  The Block which is executed when the cancel button is touched.
 */
@property (nonatomic, copy) AIDatePickerVoidBlock voidBlock;

/**
 *  Creates and returns a new date picker.
 *
 *  @param date          The initial date. A `nil` value will set the current date.
 *  @param selectedBlock The Block which is executed when the select button is touched.
 *  @param cancelBlock   The Block which is executed when the cancel button is touched.
 *
 *  @return A newly created date picker.
 */
+ (id)pickerWithDate:(NSDate *)date selectedBlock:(AIDatePickerDateBlock)selectedBlock cancelBlock:(AIDatePickerVoidBlock)cancelBlock;

@end
