<#

.SYNOPSIS
List users on a Zoom account.
.DESCRIPTION
List users on a Zoom account.
.PARAMETER Status
User statuses:
Active - Users with an active status. This is the default status.
Inactive - Users with an inactive status.
Pending - Users with a pending status.
.PARAMETER PageSize
The number of records returned within a single API call. Default value is 30. Maximum value is 300.
.PARAMETER PageNumber
The current page number of returned records. Default value is 1.
.PARAMETER ApiKey
The Api Key.
.PARAMETER ApiSecret
The Api Secret.
.LINK
https://marketplace.zoom.us/docs/api-reference/zoom-api/users/users
.EXAMPLE
Get-ZoomUsers
.EXAMPLE
Get-ZoomUsers -Status active -PageSize 50
.EXAMPLE
(Get-ZoomUsers -PageSize 100 -pagenumber 3 -status active).Users.Email

#>

function Get-ZoomUsers {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidateSet('active', 'inactive', 'pending')]
        [string]$Status = 'active',

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [ValidateRange(1, 300)]
        [Alias('page_size')]
        [int]$PageSize = 30,

        [Parameter(ValueFromPipelineByPropertyName = $True)]
        [Alias('page_number')]
        [int]$PageNumber = 1,

        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [ValidateNotNullOrEmpty()]
        [string]$ApiSecret
    )

    begin {
        $Uri = "https://api.zoom.us/v2/users/"

       #Get Zoom Api Credentials
        $Credentials = Get-ZoomApiCredentials -ZoomApiKey $ApiKey -ZoomApiSecret $ApiSecret
        $ApiKey = $Credentials.ApiKey
        $ApiSecret = $Credentials.ApiSecret

        $Headers = New-ZoomHeaders -ApiKey $ApiKey -ApiSecret $ApiSecret
    }

    process {
        $RequestBody = @{
            'status'      = $Status
            'page_size'   = $PageSize
            'page_number' = $PageNumber
        }    
        try {
            $Response = Invoke-RestMethod -Uri $Uri -Headers $headers -Body $RequestBody -Method GET
        } catch {
            Write-Error -Message "$($_.exception.message)" -ErrorId $_.exception.code -Category InvalidOperation
        }

        Write-Output $Response
    }
}