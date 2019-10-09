#! /usr/bin/env sh

export PGPASSWORD="mysecretpassword"

echo "Setup tables"

cd ./data/storage/postgres
./setup_cgr_db.sh postgres postgres

echo "-----------------------------------Executing cgr-migrator-----------------------------------"
cgr-migrator -config_path=/etc/cgrates -exec=*set_versions

echo "-----------------------------------Starting cgr-engine-----------------------------------"
cgr-engine &

echo "-----------------------------------Loading bootstrap data-----------------------------------"
sleep 5
cgr-loader -config_path=/etc/cgrates -path=/tmp/data/bootstrap -verbose

tail -f /var/log/messages
