# List of YouTube URLs
$youtubeUrls = Get-Content -Path 'input.txt'
$opmlFile = "output.opml"
$errorFile = "errors.txt"
$opmlContent = '<?xml version="1.0" encoding="UTF-8"?><opml version="2.0"><head><title>Ham Radio YouTube Channels</title></head><body>'
$errorContent = ""

foreach ($url in $youtubeUrls) {
    try {
        # Send a web request to the URL
		
        $response = Invoke-WebRequest -Uri $url -Method Head -ErrorAction Stop

        # Check if the response status code is 200 (OK)
        
		if ($response.StatusCode -eq 200) {
			$opmlContent += "`n<outline text='' title='' type='rss' xmlUrl='$url' htmlUrl='$url' />"
			 Write-Output "YouTube feed:   $url" 
           		
        } else {
			$errorContent += "`n'$url'"
            Write-Output "$url is not a valid YouTube RSS feed." 
			#| Out-File -FilePath $errorFile -Encoding UTF8
        }	
    } catch {
			$errorContent += "`n'$url'"
            Write-Output "$url is not a valid YouTube RSS feed." 
			#| Out-File -FilePath $errorFile -Encoding UTF8			
    }	
}
	$opmlContent += "`n</body></opml>"
	
	$opmlContent | Out-File -FilePath $opmlFile -Encoding UTF8
	$errorContent | Out-File -FilePath $errorFile -Encoding UTF8
	
	
