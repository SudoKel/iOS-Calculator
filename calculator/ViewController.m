//
//  ViewController.m
//  calculator
//
//  Created by Kelwin Joanes on 2017-01-28.
//  Copyright © 2017 com.kelel. All rights reserved.
//

#import "ViewController.h"
#import "math.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtDisplay;
@property (nonatomic, assign) BOOL decimalPoint;
@property (nonatomic, assign) BOOL clearScreen;
@property (nonatomic, assign) NSString *operator;
@property (nonatomic, assign) float firstOperand;
@property (nonatomic, assign) float secondOperand;

- (IBAction)displayOperand:(id)sender;
- (IBAction)selectBinaryOperator:(id)sender;
- (IBAction)selectUnaryOperator:(id)sender;
- (IBAction)evaluateExpression:(id)sender;
- (IBAction)clearOrDeleteDisplayText:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [self setDecimalPoint:NO];
    [self setOperator:@""];
    [self setFirstOperand:0];
    [self setSecondOperand:0];
    [self setOperator:@"+"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)displayOperand:(id)sender
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

- (IBAction)selectBinaryOperator:(id)sender
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
    else if ([[self operator] isEqualToString:@"✕"])
    {
        float product = [self firstOperand] * [self secondOperand];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", product];
        [self setFirstOperand:product];
    }
    else
    {
        float power = powf([self firstOperand], [self secondOperand]);
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", power];
        [self setFirstOperand:power];
    }
    
    // Reset second operand to '0'
    [self setSecondOperand:0];
    
    // Set flags
    [self setDecimalPoint:YES];
    [self setClearScreen:YES];
}

- (IBAction)selectUnaryOperator:(id)sender
{
    // Get operand
    NSString *currentText = _txtDisplay.text;
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Evaluate expression based on operand and operator
    if ([btnText isEqualToString:@"±"])
    {
        float result = [currentText floatValue] * (-1.0);
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", result];
    }
    else if ([btnText isEqualToString:@"1/x"])
    {
        float inverse = 1.0 / [currentText floatValue];
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", inverse];
    }
    else if ([btnText isEqualToString:@"√"])
    {
        float root = sqrtf([currentText floatValue]);
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", root];
    }
    else if ([btnText isEqualToString:@"x^2"])
    {
        float square = powf([currentText floatValue], 2.0);
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", square];
    }
    else
    {
        float cube = powf([currentText floatValue], 3.0);
        _txtDisplay.text = [NSString stringWithFormat:@"%.3f", cube];
    }
    
    // Set flags
    [self setDecimalPoint:YES];
    [self setClearScreen:YES];
}

- (IBAction)clearOrDeleteDisplayText:(id)sender
{
    // Get label text of button
    NSString *command = [(UIButton *)sender currentTitle];
    
    if ([command isEqualToString:@"C"])
    {
        // Clear display and reset operands and operator
        _txtDisplay.text = @"";
        [self setFirstOperand:0];
        [self setSecondOperand:0];
        [self setOperator:@"+"];
        [self setDecimalPoint:NO];
    }
    else
    {
        // Delete last digit of current operand
        NSString *currentText = _txtDisplay.text;
        if (![currentText isEqualToString:@""])
            _txtDisplay.text = [currentText substringToIndex:([currentText length]-1)];
    }
}

@end
