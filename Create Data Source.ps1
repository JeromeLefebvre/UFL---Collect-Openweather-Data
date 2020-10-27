
<#
Curently this scripts makes no attempt to updating an existing instance. Only create a new one

#>

$filePath = "C:\Users\jlefebvre.OSI\Documents\GitHub\UFL---Collect-Openweather-Data\OpenWeather.ini"
$OpenWeatherAPPID = "33ed95774fd9f0308a9135bb8dd8a2c9"


function ConfigFile($iniFilePath) {
    # Copies the ini file to UFL internal folders and creates the ConfigFile for the data source
    $internalFileName =  -join ((97..122) | Get-Random -Count 8 | % {[char]$_})
    $internalFileName += "."
    # Currently fixing an extension to make these files easy to find
    $internalFileName += "aut" #-join ((97..122) | Get-Random -Count 3 | % {[char]$_})

    $ConfigFile = [ordered]@{
        FileName = Split-Path $iniFilePath -leaf
        InternalFileName = $internalFileName
        Base64EncodedFile = ""
    }
    return $ConfigFile
}

$cities = @("Tokyo,JP", "Montreal,CA", "Barcelona,ES", "Vancouver,CA", "New Orleans,US")

function ChannelAddress($cities, $APPID) {
    $rootUrl = "https://api.openweathermap.org/data/2.5/weather?q=UFL_Placeholder&units=metric&APPID=" + $APPID 
    $citiesParamter = "|" + ($cities -join "|")
    return ($rootUrl + $citiesParamter)
}

$dataRequest = [ordered]@{
    ConfigFile = ConfigFile -iniFilePath $filePath
    DataSourceType = "REST Client"
	ChannelAddress = ChannelAddress($cities, $OpenWeatherAPPID)
	UserName = $null
    Password = @{
		Value = $null
	}
	ScanTime= "3600"
	NewLine= ""
	WordWrap= 0
	StoreMode= "Insert"
	Locale= "English - United States"
	IncomingTimestamps= "Local"
	Encoding= "Extended ASCII"
	HttpHeaders= ""
	Name= "OpenWeather"
	Description= "Collects weather data using OpenWeather's API"
}
#$dataRequest |  ConvertTo-Json -Depth 10


function CopyINIFile($filePath, $InternalFileName) {

    $programData = [System.Environment]::GetEnvironmentVariable("ProgramData")
    $internalPath = $programData + "\OSIsoft\Tau\UFL.ConnectorHost\UFL\File Uploads\"
    Copy-Item $iniFilePath -Destination ($internalPath + $internalFileName)
}
#CopyINIFile -filePath $filePath -InternalFileName $dataRequest.ConfigFile.InternalFileName

