[cmdletbinding()]
param()


if(-not (Get-module poshtwit)) {
    Import-Module poshtwit
}   

$Hashtag = "#Joke", "#Humour", "#Funny", "#HAHAHAHA", '#DryHumour','#MustRead','#Sarcasm', "#comedy"
$Producer = ' via @singhPrateik'
$HashtagString = ''

$Joke =  ((Get-Content C:\data\Powershell\Scripts\365Jokes.json |`
         ConvertFrom-Json).WHere({($_.length+$Producer.Length) -lt 130}) | Get-Random).trim() 

$Remainder = 140 - "$Joke $Producer".Length - 1

$Hashtag | Get-Random -Count $Hashtag.Count | Foreach{
        if(($HashtagString.length+$_.length) -le $Remainder)
        {           
                $HashtagString += "$_ "
                #"$($HashtagString.Length)/$Remainder"
        }
}
$HashtagString = ($HashtagString).trim()

$TweetString = "$Joke $Producer`n$HashtagString"
        
If($TweetString.length -le 140)
{
        $Tweet = @{
        ConsumerKey = '';
        ConsumerSecret = '';
        AccessToken = '';
        AccessSecret = '';
        Tweet = $TweetString;
        }

        Write-Verbose "Tweeting -> $TweetString"
        Write-Host "$TweetString" -ForegroundColor Yellow
        Publish-Tweet @Tweet
        Write-Verbose "Done."
}
