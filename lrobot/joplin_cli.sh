

export HOME=/root


joplin_cli_setup() 
{
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
NPM_CONFIG_PREFIX=~/.joplin-bin npm install --unsafe-perm --verbose -g joplin
sudo ln -s ~/.joplin-bin/bin/joplin /usr/bin/joplin
}


joplin_cli_auto_backup() {
#https://github.com/laurent22/joplin/issues/449

BACKUP_DIR="$HOME/joplin_notes_backup"
JOPLIN_BIN="$HOME/.joplin-bin/bin/joplin"
JOPLIN_BIN=joplin
$JOPLIN_BIN config
$JOPLIN_BIN sync
#$JOPLIN_BIN e2ee decrypt
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"
rm -f *.md
rm -f resources/*
$JOPLIN_BIN export --format raw "$BACKUP_DIR"
git init .
git add .
git commit -m "Update"
git remote add origin git@bitbucket.org:lrobot/joplin_notes_backup
git push origin master
}



joplin_cli_auto_backup


