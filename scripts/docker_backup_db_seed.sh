#!/bin/bash

# Backup DB Seed
#
# Create a database seed file from the current database
#
# @author    dGilli
# @copyright Copyright (c) 2024 Dennis Gilli
# @link      https://github.com/dgilli
# @package   craft-scripts
# @since     1.2.2
# @license   MIT

# Get the directory of the currently executing script
DIR="$(dirname "${BASH_SOURCE[0]}")"

# Include files
INCLUDE_FILES=(
            "common/defaults.sh"
            ".env.sh"
            "common/common_env.sh"
            "common/common_db.sh"
            )
for INCLUDE_FILE in "${INCLUDE_FILES[@]}"
do
    if [[ ! -f "${DIR}/${INCLUDE_FILE}" ]] ; then
        echo "File ${DIR}/${INCLUDE_FILE} is missing, aborting."
        exit 1
    fi
    source "${DIR}/${INCLUDE_FILE}"
done

CRAFT_VERSION=$(docker-compose exec php composer show 'craftcms/cms' | sed -n 's/versions : \* //p')
BACKUP_DB_PATH="../db-seed/project--$(date +%Y-%m-%d-%H%M%S)--v$CRAFT_VERSION.sql.gz"

docker-compose exec mariadb sh -c 'exec mysqldump -uroot -p"secret" project' | gzip > $BACKUP_DB_PATH

# Normal exit
exit 0
