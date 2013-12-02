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
		$CityCode,
        [Parameter(Position=1)]
        $Units
	)
	try {
		 $url = $apiRoot + "weather?id=" + $CityCode
		 $reqRetVal = Invoke-RestMethod -Uri $url
         if($Units){
            if($Units.toUpper()-eq "C"){
                $val = convertto-centigrade $reqRetVal.main.temp
                return $val
            }elseif($Units.toUpper() -eq "F"){
                $val = convertto-Farenheit $reqRetVal.main.temp
                return $val
            }else{
                Write-Host "Invalid Parameter for Unit. Please enter C or F for valid conversion"
            }
         }
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
	param($CityName)
    
    $CQuery = Invoke-RestMethod -uri $apiRoot"find?q="$CityName

    #$a = @{}

    $a = $CQuery.list|select id, coord

    #$googs = Invoke-RestMethod -Uri "http://maps.googleapis.com/maps/api/geocode/json?latlng=38.661145,-121.182588&sensor=true"


    #$returns = foreach($b in $a.coord) { $c = $b.lat; $d = $b.lon; $e = "http://maps.googleapis.com/maps/api/geocode/json?latlng=$c,$d&sensor=true"; Write-Host $e}
    $array =@()
    foreach($b in $a) { 
            $c = $b.coord.lat
            $d = $b.coord.lon
            $f = $b.id
            $e = (Invoke-RestMethod -uri "http://maps.googleapis.com/maps/api/geocode/json?latlng=$c,$d&sensor=true")
            $state = $e.results.where({$_.types -eq "postal_code"}).address_components|where-object {$_.types -like "*1*"}|select long_name, short_name -First 1
            $country = $e.results.where({$_.types -like "country*"}).address_components

            $obj = New-Object System.Object 
            $obj | Add-Member -membertype NoteProperty -Name State -value $state.long_name
            $obj | Add-Member -MemberType NoteProperty -Name Country -Value $country.long_name
            $obj | Add-Member -MemberType NoteProperty -Name CityCode -Value $f

            $array += $obj
        
            #$e.results.where({$_.types -eq "postal_code"}).address_components.types


            #$e.results.where({$_.types -eq "postal_code"}).address_components.where({$_.types.contains("country")}).long_name
        
            #$state = $e.results.where({$_.types -eq "postal_code"}).address_components.where({$_.types -like "administrative_area_level_1"}).long_name
            #$country = $foo.results.where({$_.types -eq "postal_code"}).address_components.where({$_.types -like "country"}).long_name
        
            #write-host " select city id `{0} for state:{1} in country:{2}" -f $b.id,$state,$country
            #Write-Host $b.id $state $country
        
            } 
            Write-Output $array

}

function get-forcast ($param1, $param2)
{
    
}

function convertto-Farenheit ($param1)
{
    [int]$farenheit = (($param1 - 273) * 1.8) + 32
    return $farenheit
}

function convertto-Centigrade ($param1)
{
    [int]$Centigrade = $param1 - 273
    return $Centigrade
}