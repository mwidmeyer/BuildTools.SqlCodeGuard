#######################################################################################################
## Name:             Clear-CacheIfOutdated.ps1
## Description:      Clears the SCG-output cache file, if if was generated by the tool in old version.
#######################################################################################################
function Clear-CacheIfOutdated {
    [OutputType([xml])]
    param (
        [Parameter(Mandatory = $true)]
        [xml]
        $CurrentCache,

        [Parameter(Mandatory = $true)]
        [string]
        $CacheFile,

        [Parameter(Mandatory = $true)]
        [string]
        $CurrentToolsVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $CurrentConfigTimestamp
    )

    $files = $CurrentCache.files

    [string]$toolsVersion = $files.GetAttribute('toolsVersion')
    [string]$configTimestamp = $files.GetAttribute('configTimestamp')

    if ([string]::IsNullOrWhiteSpace($toolsVersion) -or ($CurrentToolsVersion -ne $toolsVersion) `
    -or [string]::IsNullOrWhiteSpace($configTimestamp) -or ($CurrentConfigTimestamp -ne $configTimestamp)) {
        Set-EmptyCacheFile -CacheFile $CacheFile -CurrentToolsVersion $CurrentToolsVersion -CurrentConfigTimestamp $CurrentConfigTimestamp
        $CurrentCache = Get-Content -Path $CacheFile
    }

    return $CurrentCache
}