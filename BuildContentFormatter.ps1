param (
    [string] $AssignmentFile,
    [string] $OutputFile
)

$jsonBase = @{}

$jsonBase.Add("`$schema", "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json")

$style = @{ "flex-wrap" = "wrap"; "display" = "flex" }

$jsonBase.Add("elmType", "div")
$jsonBase.Add("style", $style)

$childrenBase = @{}

$childrenBase.Add("elmType", "div")

$childrenStyle = @{
    "box-sizing" = "border-box";
    "padding" = "4px 8px 5px 8px";
    "overflow" = "hidden";
    "text-overflow" = "ellipsis";
    "display" = "flex";
    "border-radius" = "16px";
    "height" = "24px";
    "align-items" = "center";
    "white-space" = "nowrap";
    "margin" = "4px 4px 4px 4px"
}
$childrenBase.Add("style", $childrenStyle)

$contentFormatterAssignments = [string] (Get-Content -Path .\ContentFormatterAssignments.json) | ConvertFrom-Json -Depth 16

$parkedOperands = @{}

for ($i = $contentFormatterAssignments.assignments.Length - 1; $i -ge 0; $i--)
{
    if ($i -eq $contentFormatterAssignments.assignments.Length - 1)
    {
        $newOperands = @{}
        
        $innerOperands = New-Object System.Collections.ArrayList
        $innerOperandsValues = "@currentField",$contentFormatterAssignments.assignments[$i].value
        
        $line1 = @{ "operator" = "=="; "operands" = $innerOperandsValues }
        $line2 = ""
        $line3 = $contentFormatterAssignments.assignments[$i].class

        $null = $innerOperands.Add($line1)
        $null = $innerOperands.Add($line2)
        $null = $innerOperands.Add($line3)

        $newOperands.Add("operator", ":")
        $newOperands.Add("operands", $innerOperands)

        $parkedOperands = $newOperands
    }
    else
    {
        $newOperands = @{}
        
        $innerOperands = New-Object System.Collections.ArrayList
        $innerOperandsValues = "@currentField",$contentFormatterAssignments.assignments[$i].value
        
        $line1 = @{ "operator" = "=="; "operands" = $innerOperandsValues }
        $line2 = $contentFormatterAssignments.assignments[$i].class
        $line3 = $parkedOperands

        $null = $innerOperands.Add($line1)
        $null = $innerOperands.Add($line2)
        $null = $innerOperands.Add($line3)

        $newOperands.Add("operator", ":")
        $newOperands.Add("operands", $innerOperands)

        $parkedOperands = $newOperands
    }
}


$childrenAttributes = @{ "class" = $parkedOperands}
$childrenBase.Add("attributes", $childrenAttributes)
$childrenBase.Add("txtContent", "@currentField")

$childrenList = New-Object System.Collections.ArrayList
$childrenList.Add($childrenBase)

$jsonBase.Add("children", $childrenList)
$jsonBase.Add("templateId", "BgColorChoicePill")

$json = ConvertTo-Json -InputObject $jsonBase -Depth 16

$json | Out-File -FilePath .\BuildContentFormatter.json -Force

