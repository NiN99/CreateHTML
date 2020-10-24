<#Create webpage from CSV file
    .Author = https://github.com/NiN99
    .Date = 4/13/2019
    .ToDo
        Download and Read CSV from Git
        Auto-Upload html and images to list of FTP/Web sites
        Replace generic link titles with actual website names
#>

#Variables
    $sitetitle = "My Site"
    $folder = "$home/wwwroot" #Input and Output folder

#Parameters
    $datafile = "$folder/data.csv"
    #Get CSV
    #Invoke-WebRequest -Uri "https://www.example.org/_/data.csv" -OutFile $datafile
    $OutFile = $datafile #Destination - Can copy to FTP
    $CSVFile = Import-Csv $OutFile #Source Data


    $List = 'News','Events','Apps','Websites','Podcasts','Music','Groups','People' #Define types of items in list. Used as headers
    $null = Remove-Variable body -ErrorAction SilentlyContinue #Clear variable
    $TheDeveloper = "<a href=`"https://github.com/NiN99/CreateHTML`" target=`"_blank`">the developer.</a>"
    $cols = 5 #Number of columns across in webpage
    $SearchQuery = "https://www.startpage.com/do/search?q="

    #HTML cleanup, for replacing quotes, etc in About section
        
        $sq1 = [char] 0x0060 # `
        $sq2 = [char] 0x0027 # '
        $sq3 = [char] 0x2018 # ‘
        $sq4 = [char] 0x2019 # ’
        $dq1 = [char] 0x0022 # "
        $dq2 = [char] 0x201C # “
        $dq3 = [char] 0x201D # ”
        $dq4 = [char] 0x201F # ‟
        $sp1 = [char] 0x00AE # ®
        
        $a1 = [char] 0x0026 # & sign
        $a2 = [char] 0x0023 # # sign
        $DoubleQuote = $a1 + $a2 + "34;"
        $SingleQuote = $a1 + $a2 + "39;"
        $Trademark = $a1 + $a2 + "169;"

function Create-HTML {
    $i=0 #Initilize counter
    
    Write-Output "<div id=`"body`">"
    Write-Output "<table>`r`n"
    Write-Output "<h1>$Type</h1>"
    Write-Output "<table><tr>"
    
    foreach ($Contact in $data) {
        #Convert Name into image filename - removing spaces
        $CleanName = $($Contact.Name).Trim() -replace ' ',''
        $imagesrc = "./png/$CleanName.png"
        $i++ #Increment counter


            $title = $Contact.About -Replace $dq1,$DoubleQuote -Replace $dq2,$DoubleQuote -Replace $dq3,$DoubleQuote -Replace $dq4,$DoubleQuote -Replace $sq1,$SingleQuote -Replace $sq2,$SingleQuote -Replace $sq3,$SingleQuote -Replace $sq4,$SingleQuote -replace $sp1,$Trademark

            #><img width=`"200px`" src=`"./images/default.png`" /> #Add if you want default image
        Write-Output "<td><a href=`"$SearchQuery$($Contact.Name)`" target=`"_blank`" title=`"$title`"><object width=`"100%`" data=`"$imagesrc`" type=`"image/png`"></object></a>"
        Write-Output "<br><a href=`"$SearchQuery$($Contact.Name)`" title=`"$title`" target=`"_blank`"><h3>$($Contact.Name)</h3></a>"
            
        if ($Contact.Website) {Write-Output "<a href = `"$($Contact.Website)`">Website</a>"} else {Write-Output "Website"}
        if ($Contact.Watch) {Write-Output " &iota; <a href = `"$($Contact.Watch)`">Watch</a>"} else {Write-Output " &iota; Watch"}
        if ($Contact.Watch2) {Write-Output " &iota; <a href = `"$($Contact.Watch2)`">Live</a>"} else {Write-Output " &iota; Live"}
        if ($Contact.Listen) {Write-Output "<br/><a href = `"$($Contact.Listen)`">Listen</a>"} else {Write-Output "<br/>Listen"}
        if ($Contact.Read) {Write-Output " &iota; <a href = `"$($Contact.Read)`">Read</a>"} else {Write-Output " &iota; Read"}
        if ($Contact.Contact) {Write-Output " &iota; <a href = `"$($Contact.Contact)`">Contact</a>"} else {Write-Output " &iota; Contact"}
        Write-Output "<br></td>"
        
        if ($i -eq $cols) { #Creates and AND begin row tag
            Write-Output "</tr><tr>" 
            $i=0}
    }
    Write-Output "</table></div>`r`n"

}

function Clean-Images{
    $images = "$folder\images"
    $List = Get-ChildItem $images
        foreach ($item in $List){ 
            $NewName = $item.Name.Trim() -replace '-','' -replace 'new','' -replace 'newlyadded',''
            ren "$images\$($item.Name)" $NewName
            Write-Host $NewName
             }

}

#Create embedded CSS and Header
$head = "<html><head>
    <title>$sitetitle</title>
    <style type=`"text/css`">
    *{
	    font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	    font-size:12px;
	    color: darkblue;
        }

    #content {
	    font-weight:normal;
	    font-size:12px;
	    color: white;
        }

    p {
	    font-weight:normal;
	    font-size:12px;
	    color: darkblue;
        }

    li {
	    font-weight:normal;
	    font-size:14px;
	    color: darkblue;
        }
        
    h1 {
	    font-size: 20pt;
	    color: navy;
	    font-weight:bold;
	    padding-top: 0px;
	    padding-bottom: 0px;
        }

    h2 {
	    font-size: 16pt;
	    font-weight:bold;
	    color: darkblue;
	    padding-top: 0px;
	    padding-bottom: 0px;
        }

    h3 {
	    font-size: 10pt;
	    color: black;
	    font-weight:bold;
	    padding-top: 0px;
	    padding-bottom: 0px;
        }

    hr {
	    color: navy;
	    padding: 1px;
        }
    
    table {
         align: center;
    }

    td {
        text-align: center;
        vertical-align: bottom;
        width: 280px;
        padding-bottom: 10px;
        #height: 240px;
        border: 3px;
        }
    
    tr {
        vertical-align: bottom;
        }
    
    object {
     width:100%;
     max-height:200px;
     }

    html, body {height: 100%;}

    body {
        background-image: url(./images/bg.jpg);
        background-size: 100% 100%;
        background-repeat: no-repeat;
        background-attachment: fixed;
        background-position: center; 
        }

    #menu { 
	    position: relative;
	    width: 640px auto; 
	    margin: 50px auto; 
	    padding: 20px;
	    border:2px solid;
	    border-radius:25px; 
	    background-color:#DBEAF9; -moz-box-shadow: 0 0 20px black; -webkit-box-shadow: 0 0 20px black; box-shadow: 0 0 20px black;
	    }

    #body { 
	    position: relative;
	    width: 75%; 
	    margin: 10px auto; 
	    padding: 20px;
	    border:2px solid;
	    border-radius:25px; 
	    background-color:#DBEAF9; -moz-box-shadow: 0 0 20px black; -webkit-box-shadow: 0 0 20px black; box-shadow: 0 0 20px black;
	    }

    </style>`r`n</head>"

    
    $menu = "<div id=`"body`"><h1>About</h1>
    If you wish to add, remove, or change any of these entries, please contact $TheDeveloper
    <br /><i>***Please notify $TheDeveloper immediately if there is any confedential information or copyright infringement.***</i>

    <br /><br />This page is designed to be duplicated, copied, saved, re-hosted, or stored offline. Think blockchain, IPFS, etc. 
    <br>It is intentionally kept in a single file, only optionally depending on the /images folder. Although, it will function fine without images.
    <br />The page is built with a PowerShell script that imports contents from a local CSV file, and exports HTML with style. All contents have been compiled from various public facing websites.
    <br /><br />Plans are to keep the script and all contents open source, using github. 
    </div>"

#Create Body from data.csv
foreach ($Type in $List){
    Write-Host "Adding $Type"
    $data = $CSVFile | Where-Object Type -EQ $Type | Sort-Object Type,Name
    $body += Create-HTML
}


    $foot = "</table></html>"
    $head | Out-File -File $OutFile -Force -Encoding utf8
    $menu | Add-Content -Path $OutFile
    $body | Add-Content -Path $OutFile
    $foot | Add-Content -Path $OutFile
