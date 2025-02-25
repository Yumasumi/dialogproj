# 檢查是否以 root 權限執行
if [[ $EUID -ne 0 ]]; then
	echo "請使用 root 權限執行此腳本：sudo ./myprojsetup.sh"
	exit 1
fi

sudo apt install -y mariadb-server dialog

sudo systemctl start mariadb
sudo systemctl enable mariadb

mysql -u root -e "
DROP USER IF EXISTS 'admin'@'localhost';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
"

mysql -u admin -padmin -e "
CREATE DATABASE IF NOT EXISTS \`Name\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS \`Note\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
"

mysql -u admin -padmin -D Name -e "
CREATE TABLE IF NOT EXISTS \`BoyNames\` (\`name\` VARCHAR(255) NOT NULL);
CREATE TABLE IF NOT EXISTS \`GirlNames\` (\`name\` VARCHAR(255) NOT NULL);
"

mysql -u admin -padmin -D Note -e "
CREATE TABLE IF NOT EXISTS \`Today\` (\`memo\` VARCHAR(255) NOT NULL);
CREATE TABLE IF NOT EXISTS \`Tomorrow\` (\`memo\` VARCHAR(255) NOT NULL);
"

mysql -u admin -padmin -D Name -e "
INSERT INTO \`BoyNames\` (\`name\`) VALUES ('Nino'), ('Davi');
INSERT INTO \`GirlNames\` (\`name\`) VALUES ('Lulu'), ('Bonie');
"

mysql -u admin -padmin -D Note -e "
INSERT INTO \`Today\` (\`memo\`) VALUES ('123'), ('456'), ('789');
INSERT INTO \`Tomorrow\` (\`memo\`) VALUES ('ABC'), ('DEF'), ('GHI');
"

echo "啟動資料庫查詢腳本"
chmod +x myproj.sh
./myproj.sh
