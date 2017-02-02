//
//  ViewController.m
//  A simple calculator.
//
//  Created by Kelwin Joanes on 2017-01-28.
//  Copyright © 2017 com.kelel. All rights reserved.
//

#import "ViewController.h"
#import "math.h"

@interface ViewController ()

// Properties
@property (weak, nonatomic) IBOutlet UITextField *txtDisplay;
@property (nonatomic, assign) BOOL decimalPoint;
@property (nonatomic, assign) BOOL clearScreen;
@property (nonatomic, assign) NSString *operator;
@property (nonatomic, assign) float firstOperand;
@property (nonatomic, assign) float secondOperand;

// Methods
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
    // Set flag to limit decimal points to 1
    [self setDecimalPoint:NO];
    
    // Initialize first operand to be 0
    [self setFirstOperand:0];
    
    // Initialize second operand to be 0
    [self setSecondOperand:0];
    
    // Initialize default operator to be addition
    [self setOperator:@"+"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 This method is used to display the text of the numeric
 buttons (0-9) and '.', which basically form the operands 
 of the expression
 */
- (IBAction)displayOperand:(id)sender
{
    // Grab current text from display or textfield
    NSString *currentText = _txtDisplay.text;
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Handle case when '0' is pressed and '0' is already first digit in display
    if ([currentText isEqualToString:@"0"] && [btnText isEqualToString:@"0"])
    {
        // Avoid leading '0's
        _txtDisplay.text = @"0";
    }
    // Handle case when '0' is in display and any other numeric button (1-9) or '.' is pressed
    else if ([currentText isEqualToString:@"0"] && ![btnText isEqualToString:@"0"])
    {
        // Add a decimal point to operand if none is already present
        if ([btnText isEqualToString:@"."] && ![self decimalPoint])
        {
            _txtDisplay.text = [currentText stringByAppendingString:@"."];
            // Set flag to avoid more than one decimal point
            [self setDecimalPoint:YES];
        }
        // Handle case if any other numeric button (1-9) or '.' is pressed
        else
        {
            // Only handle case for numeric buttons 1-9
            if (![btnText isEqualToString:@"."])
            {
                // Remove leading '0' from operand to be displayed
                currentText = @"";
                _txtDisplay.text = [currentText stringByAppendingString:btnText];
            }
        }
    }
    // Otherwise append the button text to display
    else
    {
        // Clear textfield for next operand
        if ([self clearScreen])
        {
            currentText = @"";
            [self setClearScreen:NO];
        }
        
        // Add numeric digit (0-9) to display
        if (![btnText isEqualToString:@"."])
        {
            _txtDisplay.text = [currentText stringByAppendingString:btnText];
        }
        // Add decimal point if not present and operand already has at least one digit
        else
        {
            if (![self decimalPoint] && ![currentText isEqualToString:@""])
            {
                _txtDisplay.text = [currentText stringByAppendingString:btnText];
                // Set flag to avoid more than one decimal point
                [self setDecimalPoint:YES];
            }
        }
    }
}

/**
 This method handles all binary operations (+,-,✕,÷,x^y)
 by saving the current display text as the first operand, 
 and saving the current operator to be evaluated by the 
 evaluateExpression: method later
 */
- (IBAction)selectBinaryOperator:(id)sender
{
    // Set current text in display to be the first operand
    NSString *currentText = _txtDisplay.text;
    [self setFirstOperand:[currentText floatValue]];
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Set the current operator
    [self setOperator:btnText];
    
    // Reset flag for decimal point to prepare for next operand
    [self setDecimalPoint:NO];
    // Set flag for clearing display for next operand
    [self setClearScreen:YES];
}


/**
 This method evaluates the expressions with binary
 operators (invoked by the '=' button), by saving the 
 current display text as the second operand, evaluating 
 the expression and finally displaying the result
 */
- (IBAction)evaluateExpression:(id)sender
{
    // Set current text in display to be the second operand
    NSString *currentText = _txtDisplay.text;
    [self setSecondOperand:[currentText floatValue]];
    
    // Evaluate expression based on operands and operator and display result
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
    
    // Set flag to avoid more than one decimal point
    [self setDecimalPoint:YES];
    // Set flag for clearing display for next operand
    [self setClearScreen:YES];
}

/**
 This method handles all unary operations (±,1/x,√,x^2,x^3)
 by saving the current display text as the first operand
 and then evaluating the expression based on the specified
 unary operator, and finally displaying the result
 */
- (IBAction)selectUnaryOperator:(id)sender
{
    // Get operand
    NSString *currentText = _txtDisplay.text;
    
    // Get label text of button
    NSString *btnText = [(UIButton *)sender currentTitle];
    
    // Evaluate expression based on operand and operator and display result
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
    
    // Set flag to avoid more than one decimal point
    [self setDecimalPoint:YES];
    // Set flag for clearing display for next operand
    [self setClearScreen:YES];
}


/**
 This method handles the 'C' and 'Del' buttons, by
 either clearing the display or removing a single 
 character from the display, respectively
 */
- (IBAction)clearOrDeleteDisplayText:(id)sender
{
    // Get label text of button
    NSString *command = [(UIButton *)sender currentTitle];
    
    // Handle case if 'C' is pressed
    if ([command isEqualToString:@"C"])
    {
        // Clear display and reset operands and operator
        _txtDisplay.text = @"";
        [self setFirstOperand:0];
        [self setSecondOperand:0];
        [self setOperator:@"+"];
        [self setDecimalPoint:NO];
    }
    // Otherwise handle case if 'Del' is pressed
    else
    {
        // Delete last digit of current operand
        NSString *currentText = _txtDisplay.text;
        if (![currentText isEqualToString:@""])
            _txtDisplay.text = [currentText substringToIndex:([currentText length]-1)];
    }
}

@end
