#!/bin/bash

# === Configuration ===
CONTAINER_NAME="mysql1"     # <-- Replace with your MariaDB container name
DB_USER="root"                           # <-- Replace with your MariaDB user
DB_PASSWORD=""             # <-- Replace with your MariaDB root password
SQL_DIR="$HOME"               # <-- Directory where .sql files are stored

# === Script Starts ===
echo "📦 Starting import of all .sql files in $SQL_DIR into MariaDB container '$CONTAINER_NAME'..."

for sql_file in "$SQL_DIR"/*.sql; do
  filename=$(basename "$sql_file")
  db_name="${filename%.sql}"   # Remove .sql extension to get db name

  echo "📁 Processing $filename → DB: $db_name"

  # 1. Create database if it doesn't exist
  docker exec -i "$CONTAINER_NAME" mysql -u"$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$db_name\`;"

  # 2. Import the SQL file into the database
  docker exec -i "$CONTAINER_NAME" mysql -u"$DB_USER" -p"$DB_PASSWORD" "$db_name" < "$sql_file"

  if [ $? -ne 0 ]; then
    echo "❌ Failed to import $filename"
  else
    echo "✅ Successfully imported into $db_name"
  fi
done

echo "🎉 All SQL files processed."
