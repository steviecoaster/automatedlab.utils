function New-OptionSet {
    <#
    .SYNOPSIS
    Creates a numbered list of options for display or selection purposes.
    
    .DESCRIPTION
    The New-OptionSet function takes an array of options and formats them as a numbered list, 
    starting from 1. This is useful for creating menus, displaying choices, or formatting 
    options for user selection.
    
    .PARAMETER Options
    An array of strings representing the options to be numbered and displayed.
    
    .EXAMPLE
    New-OptionSet -Options @('Red', 'Blue', 'Green')
    
    Output:
    1. Red
    2. Blue
    3. Green
    
    .EXAMPLE
    $colors = @('Red', 'Blue', 'Green', 'Yellow')
    New-OptionSet -Options $colors
    
    Output:
    1. Red
    2. Blue
    3. Green
    4. Yellow
    
    .EXAMPLE
    New-OptionSet -Options 'Option A', 'Option B', 'Option C'
    
    Output:
    1. Option A
    2. Option B
    3. Option C
    
    .OUTPUTS
    System.String
    Returns formatted strings with numbered options.
    
    .NOTES
    This function is useful for creating interactive menus or displaying choices 
    in a consistent numbered format.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String[]]
        $Options
    )
        end {
            $x = 1 
            foreach ($o in $Options) {
                '{0}. {1}' -f $x, $o
                $x++
            }
        }
    }