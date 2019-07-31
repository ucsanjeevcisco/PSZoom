<#

.SYNOPSIS
List user schedulers.
.DESCRIPTION
List user schedulers.
.PARAMETER UserId
The user ID or email address.
.PARAMETER ApiKey
The Api Key.
.PARAMETER ApiSecret
The Api Secret.
.OUTPUTS
A hastable with the Zoom API response.
.EXAMPLE
Get-ZoomUserSchedulers jmcevoy@lawfirm.com
.LINK
https://marketplace.zoom.us/docs/api-reference/zoom-api/users/userschedulers

#>

$Parent = Split-Path $PSScriptRoot -Parent
import-module "$Parent\ZoomModule.psm1"

function Get-ZoomUserSchedulers {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $True, 
            Position = 0, 
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True
        )]
        [Alias('Email', 'EmailAddress', 'Id', 'user_id')]
        [string]$UserId,

        [ValidateNotNullOrEmpty()]
        [string]$ApiKey,

        [ValidateNotNullOrEmpty()]
        [string]$ApiSecret
    )

    begin {
        #Get Zoom Api Credentials
        if (-not $ApiKey -or -not $ApiSecret) {
            $ApiCredentials = Get-ZoomApiCredentials
            $ApiKey = $ApiCredentials.ApiKey
            $ApiSecret = $ApiCredentials.ApiSecret
        }

        #Generate Header with JWT (JSON Web Token)
        $Headers = New-ZoomHeaders -ApiKey $ApiKey -ApiSecret $ApiSecret
    }

    process {
        $Request = [System.UriBuilder]"https://api.zoom.us/v2/users/$UserId/schedulers"

        try {
            $Response = Invoke-RestMethod -Uri $Request.Uri -Headers $headers -Method GET
        } catch {
            Write-Error -Message "$($_.exception.message)" -ErrorId $_.exception.code -Category InvalidOperation
        }

        Write-Output $Response
    }
}