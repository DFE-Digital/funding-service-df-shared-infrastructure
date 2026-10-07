
param($Request, $TriggerMetadata)

try {

    Test-RequestBody -Body $Request.Body
    Write-Information ($Request.Body | ConvertTo-Json -Depth 10)

    $AlertData = $Request.Body.data

    $Message = New-Message -AlertData $AlertData -Channel $ENV:SlackDefaultChannel
    Send-SlackMessage -Message $Message -Channel $ENV:SlackDefaultChannel
    Push-OutputBindingWrapper -StatusCode 202 -Body "Message accepted"

}
catch [System.FormatException] {
    Push-OutputBindingWrapper -StatusCode 400 -Body $_.Exception.Message
}
catch [Microsoft.PowerShell.Commands.HttpResponseException] {
    Push-OutputBindingWrapper -StatusCode $_.Exception.Response.StatusCode.Value__ -Body $_
}
catch {
    throw $_
}
