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
@property (nonatomic, assign) BOOL clearScreen;
@property (nonatomic, assign) NSString *operator;
@property (nonatomic, assign) float firstOperand;
@property (nonatomic, assign) float secondOperand;

- (IBAction)operandBtn:(id)sender;
- (IBAction)binaryOperator:(id)sender;
- (IBAction)evaluateExpression:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setDecimalPoint:NO];
    [self setOperator:@""];
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
        // Clear field for next operand
        if ([self clearScreen])
        {
            currentText = @"";
            [self setClearScreen:NO];
        }
        
        // Avoid more than one decimal point
        if (![self decimalPoint] && ![currentText isEqualToString:@""])
        {
            _txtDisplay.text = [currentText stringByAppendingString:btnText];
            
            // Set flag if decimal point has been added
            if ([btnText isEqualToString:@"."])
                [self setDecimalPoint:YES];
        }
        else
        {
            // If current button is not a decimal point then append its text to display
            if (![btnText isEqualToString:@"."])
                _txtDisplay.text = [currentText stringByAppendingString:btnText];
        }
    }
}

- (IBAction)binaryOperator:(id)sender
{
    // Set current text in display to be the first operand
    NSString *currentText = _txtDisplay.text;
    [self setFirstOperand:[currentText floatValue]];
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Set the current operator
    [self setOperator:btnText];
    
    // Set flags
    [self setDecimalPoint:NO];
    [self setClearScreen:YES];
}

- (IBAction)evaluateExpression:(id)sender
{
    // Set current text in display to be the second operand
    NSString *currentText = _txtDisplay.text;
    [self setSecondOperand:[currentText floatValue]];
    
    // Evaluate expression based on operands and operator
    if ([[self operator] isEqualToString:@"+"])
    {
        float sum = [self firstOperand] + [self secondOperand];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", sum];
        // Set result to be first operand
        [self setFirstOperand:sum];
    }
    else if ([[self operator] isEqualToString:@"-"])
    {
        float difference = [self firstOperand] - [self secondOperand];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", difference];
        [self setFirstOperand:difference];
    }
    else if ([[self operator] isEqualToString:@"÷"])
    {
        float quotient = [self firstOperand] / [self secondOperand];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", quotient];
        [self setFirstOperand:quotient];
    }
    else
    {
        float product = [self firstOperand] * [self secondOperand];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", product];
        [self setFirstOperand:product];
    }
    
    // Reset second operand to '0'
    [self setSecondOperand:0];
    // Set flag
    [self setDecimalPoint:YES];
    
}


@end
