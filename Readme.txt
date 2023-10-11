
The script "BuildContentFormatter.ps1" can be used, to create a json structure to configure
the color coding in a choice field in SharePoint Online.

Parameters, when calling the script:

  AssignmentFile: Path and filename of a json structure, where the choice values are
                  matched against a class definition used in the json structure do 
                  define the color coding. An example is stored in the file
                  ContentFormatterAssignments.json
  OutputFile:     Path and filename, where the created json structure should be stored

Example call:

.\BuildContentFormatter.ps1 -AssignmentFile .\Assignments.json -OutputFile .\ChoiceCustomFormatter.json

The content of the output file created when running the script can then be assigne to the
CustomFormatter property of the field with the following execution of a PnP PowerShell cmdlet:

$customFormatter = [string] (Get-Content -Path .\ChoiceContentFormatter.json)

Set-PnPField -List "{listname}" -Identity "{fieldname}" -Values @{ CustomFormatter = $customFormatter }

The script and the procedure can be helpful, when same list/field configurations are needed
in separate SharePoint sites.


Reference for the possible classes in the assignments file:
https://gist.github.com/thechriskent/0e759edc51140c22ed8f386f9abbf5dc

