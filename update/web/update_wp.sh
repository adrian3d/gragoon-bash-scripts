directory=$1

if [[ -z $directory && -z "${directory-x}" ]]
then
	printf "Directory is not set\n"
	exit 1
fi

if [ ! -d "$directory" ]; then
	printf "Directory doesn't exist\n"
	exit 1
fi

if [ ! -f "$directory/wp-config.php" ]
then
	printf "Wp config not found\n"
	exit 1
fi

now=$(date +"%Y_%m_%d")

while true; do
    read -p "You will update this WP, continue? [y/N]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ -d "$directory/../backup_$now" ]; then
	read -r -p "Another update exist for today? [y/N]" response
	if [[ "$response" =~ ^([yY])+$ ]]
	then
    		rm -rf $directory/../backup_$now
	else
		printf "Aborting"
    		exit 1
	fi
fi


# Download the last version of wordpress cli
printf "Downloading the last version of wp-cli \n"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Backup the file of project
printf "Exporting files to backup archive \n"
tar --exclude=$directory/wp-content/uploads --exclude=$directory/wp-content/updraft -cf $directory/../backup_files_$now.tar $directory

# Export db
printf "Exporting DB \n"
php -q wp-cli.phar db export --path="$directory" --porcelain "$directory/../backup_bdd_$now.sql" --allow-root

# Update all plugins
printf "Updating plugins\n"
php -q wp-cli.phar plugin update --all --path="$directory" --allow-root

# Update core
printf "Updating core \n"
php -q wp-cli.phar core update --path="$directory" --allow-root

# Reupdate plugins after update of core
php -q wp-cli.phar plugin update --all --path="$directory" --allow-root

# Move files in a new directory
printf "Finishing \n"
mkdir $directory/../backup_$now
mv $directory/../backup_files_$now.tar $directory/../backup_$now/backup-files.tar
mv $directory/../backup_bdd_$now.sql $directory/../backup_$now/backup-bdd.sql
rm wp-cli.phar

printf "OK!\n"


