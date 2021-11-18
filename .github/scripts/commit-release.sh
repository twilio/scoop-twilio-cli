echo "Git configurations"
git config --global user.email "team_interfaces+github@twilio.com"
git config --global user.name "twilio-dx"
branch=$(git branch --show-current)

echo "Current branch: $branch"

git add -A
if [ -n "$(git status --porcelain)" ]; then
    echo "There are changes to commit.";
    git commit -m "Update manifest to version $version"
    git push origin "$branch"
else
    echo "No changes to commit";
    exit
fi