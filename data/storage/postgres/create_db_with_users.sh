
#
# Sample db and users creation. Replace here with your own details
#

# dropdb -e cgrates
# dropuser -e cgrates
psql -c "CREATE USER cgrates password '${PGPASSWORD}';"
createdb -e -O cgrates cgrates
