function New-UserPrompt {
    <#
    .SYNOPSIS
    Creates an interactive user prompt with numbered options for selection.
    
    .DESCRIPTION
    The New-UserPrompt function displays a numbered list of options to the user and prompts 
    them to select one by entering the corresponding number. It validates the user's input 
    and returns the selected option. This is useful for creating interactive menus and 
    user choice scenarios in PowerShell scripts.
    
    .PARAMETER Options
    An array of strings representing the choices available to the user. Each option will 
    be displayed with a number starting from 1.
    
    .PARAMETER Prompt
    The text to display when prompting the user for their selection. 
    Default value is 'Select option'.
    
    .EXAMPLE
    New-UserPrompt -Options 'Larry','Curly','Moe'
    
    Output:
    1. Larry
    2. Curly
    3. Moe
    Select option (1-3): 2
    
    Returns: Curly
    
    .EXAMPLE
    $environments = @('Development', 'Testing', 'Production')
    $selected = New-UserPrompt -Options $environments -Prompt 'Choose deployment environment'
    
    Output:
    1. Development
    2. Testing
    3. Production
    Choose deployment environment (1-3): 1
    
    Returns: Development
    
    .EXAMPLE
    New-UserPrompt -Options @('Yes', 'No') -Prompt 'Continue with operation?'
    
    Output:
    1. Yes
    2. No
    Continue with operation? (1-2): 1
    
    Returns: Yes
    
    .OUTPUTS
    System.String
    Returns the selected option as a string.
    
    .NOTES
    - The function throws an error if the user enters an invalid option number
    - Input validation ensures only numbers within the valid range are accepted
    - This function is useful for creating interactive scripts that require user input
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String[]]
        $Options,

        [Parameter()]
        [String]
        $Prompt = 'Select option'
    )

    end {

        $x = 1 
        foreach($o in $Options){
            '{0}. {1}' -f $x,$o
            $x++
        }

        [int]$choiceCount = $x -1
        $choice = Read-Host -Prompt "$Prompt (1-$choiceCount)"

        if([int]$choice -gt $choiceCount){
            throw "Invalid option. Please choose between 1 and $choiceCount!"
        } else {
           $Options[($choice - 1)]
        }
    }
}