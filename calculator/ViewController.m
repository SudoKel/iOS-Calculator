//
//  ViewController.m
//  calculator
//
//  Created by Kelwin Joanes on 2017-01-28.
//  Copyright © 2017 com.kelel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtDisplay;
@property (nonatomic, assign) BOOL decimalPoint;
@property (nonatomic, assign) NSString *operator;
@property (nonatomic, assign) float firstOperand;
@property (nonatomic, assign) float secondOperand;

- (IBAction)operandBtn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setDecimalPoint:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)operandBtn:(id)sender
{
    // Grab current text from display
    NSString *currentText = _txtDisplay.text;
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Do not allow leading '0's
    if ([currentText isEqualToString:@"0"] && [btnText isEqualToString:@"0"])
    {
        _txtDisplay.text = @"0";
    }
    // Remove any leading '0's if any numeric button other than '0' is pressed
    else if ([currentText isEqualToString:@"0"] && ![btnText isEqualToString:@"0"])
    {
        // Add decimal point if button is pressed
        if ([btnText isEqualToString:@"."] && ![self decimalPoint])
        {
            _txtDisplay.text = [currentText stringByAppendingString:@"."];
            [self setDecimalPoint:YES];
        }
        else
        {
            // Avoid more than one decimal point
            if (![btnText isEqualToString:@"."] || [self decimalPoint])
            {
                currentText = @"";
                _txtDisplay.text = [currentText stringByAppendingString:btnText];
            }
        }
    }
    // Otherwise append the label text to display
    else
    {
        // Avoid more than one decimal point
        if (![self decimalPoint] && ![currentText isEqualToString:@""])
        {
            _txtDisplay.text = [currentText stringByAppendingString:btnText];
            
            if ([btnText isEqualToString:@"."])
                [self setDecimalPoint:YES];
        }
        else
        {
            if (![btnText isEqualToString:@"."])
                _txtDisplay.text = [currentText stringByAppendingString:btnText];
        }
    }
}
@end
