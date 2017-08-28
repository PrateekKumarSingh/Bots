Function Invoke-TwitterLike
{
    [Alias("Like")]
    [Cmdletbinding()]
    param(
        [String[]] $Keyword
    )

    Begin{
        If(-not $Keyword)
        {
            $Keyword = "#joke","#Sarcasm","Funny","#Humor","#Humour","#HAHAHAHA","Comedy"
            cls
        }
    }
    process{

        Foreach($Item in $Keyword){
            $ie = New-Object -ComObject "internetexplorer.application" -Property `
            @{
                Navigate = "https://twitter.com/search?f=tweets&vertical=default&q=$([uri]::EscapeDataString($Item))"
                visible = $false
            }
            # Wait unitl IE is busy
            While($ie.busy){ Write-Verbose "Internet Explorer is Busy, waiting for few seconds";Start-Sleep -Seconds 5 }

            $start = Get-Date; $VerticalScroll = 0
            
            Write-Host "Capturing tweets with keyword : $Item" -ForegroundColor Yellow
            # 30 Secs to Infinitely scroll webpage, So that all items are populated that only come when you scroll down
            While((Get-Date) -lt $($start + [timespan]::new(0,0,30)))
            {
                $ie.Document.parentWindow.scrollTo(0,$VerticalScroll)
                $VerticalScroll = $VerticalScroll + 100
            }
            cls
            $Buttons =  $ie.Document.getElementsByTagName('button')|`
                        Where-Object{$_.classname -eq 'ProfileTweet-actionButton js-actionButton js-actionFavorite'}
            $Buttons.ForEach({$_.click()})
            Write-Host "$($Buttons.Count) Tweets liked with Keyword: $Item" -ForegroundColor Green
            
            $IE.Quit()
            Remove-variable IE
            [GC]::collect()

        }

    }

}

Like -Keyword "#Funny","#Humor","#Humour","#HAHAHAHA","Comedy"