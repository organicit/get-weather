$Global:apiRoot = "http://api.openweathermap.org/data/2.5/"

function get-temperature {
	<#
		.SYNOPSIS
			A brief description of the function.

		.DESCRIPTION
			A detailed description of the function.

		.PARAMETER  ParameterA
			The description of the ParameterA parameter.

		.PARAMETER  ParameterB
			The description of the ParameterB parameter.

		.EXAMPLE
			PS C:\> Get-Something -ParameterA 'One value' -ParameterB 32

		.EXAMPLE
			PS C:\> Get-Something 'One value' 32

		.INPUTS
			System.String,System.Int32

		.OUTPUTS
			System.String

		.NOTES
			Additional information about the function go here.

		.LINK
			about_functions_advanced

		.LINK
			about_comment_based_help

	#>
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$CityCode
	)
	try {
		 $url = "http://api.openweathermap.org/data/2.5/forecast?id=$CityCode"
		 Invoke-RestMethod -Uri $url
	}
	catch {
		throw
	}
}

function Get-City {
	<#
		.SYNOPSIS
			Use the API to set the Proper City Code

		.DESCRIPTION
			The API uses City Weather codes so you will need to lookup your city and verify it's location and select the appropriate code.

		.PARAMETER  ParameterA
			City

		.PARAMETER  ParameterB
			CountryCode

		.EXAMPLE
			Find-City -City "San Francisco" -CountryCode "US"

		.EXAMPLE
			find-City "New York"

		.INPUTS
			System.String,System.String

		.OUTPUTS
			System.Int32
		
	#>
	[CmdletBinding()]
	[OutputType([System.Int32])]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$City,

		[Parameter(Position=1)]
		[ValidateNotNull()]
		[System.String]
		$CountryCode
	)
    $updName = $Name -replace " ","%20"
    $url = $Global:apiRoot + "find?q=" + $updName
    #Write-Host $url
	try {
		$LUVals = Invoke-RestMethod -Uri $url
            
        if($LUVals.count -eq 1)
        {
            
            return $LUVals.list.id

        } else {
            Write-Host "More than one City has been returned:"
            foreach($City in $LUVals)
            {
                Write-Host $City.List.Name
                write-host $City.List.sys
            }
        }

  	}
	catch {
		throw
	}
}

function Set-City {
	<#
		.SYNOPSIS
			Lookup city code

		.DESCRIPTION
			A detailed description of the function.

		.PARAMETER  ParameterA
			The description of the ParameterA parameter.

		.PARAMETER  ParameterB
			The description of the ParameterB parameter.

		.EXAMPLE
			PS C:\> Get-Something -ParameterA 'One value' -ParameterB 32

		.EXAMPLE
			PS C:\> Get-Something 'One value' 32

		.INPUTS
			System.String,System.Int32

		.OUTPUTS
			System.String

		.NOTES
			Additional information about the function go here.

		.LINK
			about_functions_advanced

		.LINK
			about_comment_based_help

	#>
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Name
	)
    
    $updName = $Name -replace " ","%20"
    $url = $Global:apiRoot + "find?q=" + $updName
    #Write-Host $url
	try {
		$LUVals = Invoke-RestMethod -Uri $url
            
        if($LUVals.count -eq 1)
        {
            
            return $LUVals.list.id

        } else {
            Write-Host "More than one City has been returned:"
            foreach($City in $LUVals)
            {
                Write-Host $City.List.Name + ": " + $City.List.sys
            }
        }

  	}
	catch {
		throw
	}
}