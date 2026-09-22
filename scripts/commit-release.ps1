param(
    [String] $version = ''
)

echo "Git configurations"
git config --global user.email "team_interfaces+github@twilio.com"
git config --global user.name "twilio-dx"
if ($version -like "*draft*") {
 git add .\twiliodraft.json
} else {
 git add .\twilio.json
}

$git_status=git status --porcelain

if ($git_status -eq $null) {
    echo "No changes to commit";
    Exit 1
}

# Direct pushes to main are rejected by the org-level "Twilio default branch
# protections" ruleset (GH013: "Changes must be made through a pull request"),
# so the manifest update lands as a PR instead. This also drops the force push
# that the previous direct-to-main flow used.
#
# The PR is not queued for auto-merge: that is disabled on this repo
# (allow_auto_merge=false), so `gh pr merge --auto` would just fail. It has to
# be reviewed and merged, and the release is not live in Scoop until then.
$runId = $env:GITHUB_RUN_ID
if (-not $runId) { $runId = "manual" }
$prBranch = "release-$version-$runId"

git checkout -b $prBranch
if ($LASTEXITCODE -ne 0) { echo "Failed to create branch $prBranch"; Exit 1 }

git commit -m "Update manifest to version $version"
if ($LASTEXITCODE -ne 0) { echo "Failed to commit"; Exit 1 }

git push origin $prBranch
if ($LASTEXITCODE -ne 0) { echo "Failed to push $prBranch"; Exit 1 }

$prBody = "Updates the Scoop manifest to ``$version``.`n`nOpened by the Update Manifest workflow."
$prUrl = gh pr create --base main --head $prBranch --title "Update manifest to version $version" --body $prBody
if ($LASTEXITCODE -ne 0) { echo "Failed to open a PR for $prBranch"; Exit 1 }
echo "::notice::Manifest PR opened for $version`: $prUrl"
echo "Review and merge it to publish $version to Scoop."
