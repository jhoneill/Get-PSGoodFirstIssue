Update-FormatData -AppendPath (Join-Path -Path $PSScriptRoot -ChildPath "GitHubIssue.format.ps1xml")

Update-TypeData -TypeName PSGFI.GithubIssue -DefaultDisplayPropertySet "title", "repository_url", "number", "state", "assignee", "html_url" -Force

function Get-PSGoodFirstIssue {
    [CmdletBinding()]
    param (
        $OauthToken,
        $Repo = "powershell/powershell",
        $Labels = "up-for-grabs"
    )

    process {
        $irmbody = @{
            labels = $Labels
            state = "open"
        }
        if ($OauthToken) {
            $irmheader = @{
                Authorization = "token $OauthToken"
            }
        }

        $issue = Invoke-RestMethod "https://api.github.com/repos/$Repo/issues" -Body $irmbody -Headers $irmheader -FollowRelLink | ForEach-Object {$_} | Get-Random

        $issue.pstypenames.insert(0,"PSGFI.GithubIssue")

        $issue
    }
}

function Get-PSHacktoberFestIssue {
    [CmdletBinding()]
    param (
        $OauthToken,
        $Language = 'powershell',
        $Label = 'hacktoberfest',
        $State = 'open'

    )

    process {
        $irmbody = @{
            labels = $Label
            state = $state
        }
        if ($OauthToken) {
            $irmheader = @{
                Authorization = "token $OauthToken"
            }
        }

        $uri = "https://api.github.com/search/issues?q=language:{0}+label:{1}+state:{2}" -f $Language, $Label, $State

        $result = Invoke-RestMethod $uri -Body $irmbody -Headers $irmheader -FollowRelLink
        $issue = $result.items | Get-Random
        $issue.pstypenames.insert(0,"PSGFI.GithubIssue")

        $issue
    }
}

Export-ModuleMember -Function *-*
