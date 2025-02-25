# 讓用戶輸入 MySQL 用戶名
DB_USER=`dialog --stdout --inputbox "請輸入資料庫用戶名稱：" 8 40`
DB_PASS=`dialog --stdout --passwordbox "請輸入資料庫用戶密碼：" 8 40`
if mysql -u"$DB_USER" -p"$DB_PASS" -e "EXIT" 2>/dev/null; then
	break
else
	dialog --title "錯誤" --msgbox "無法連接，請檢查名稱或密碼。" 8 40
fi
#選擇資料庫
database=`dialog --stdout --title "選擇資料庫" --menu "請選擇您要查看的資料庫：" 10 50 3 1 "Name" 2 "Note"`
if [[ "$database" == "1" ]]; then
	DB_NAME="Name"
elif [[ "$database" == "2" ]]; then
	DB_NAME="Note"
else
	exit 1
fi
#選擇資料表
if [[ "$DB_NAME" == "Name" ]]; then
	table=`dialog --stdout --title "選擇資料表" --menu "請選擇您要查看的資料表：" 10 50 2 1 "BoyNames" 2 "GirlNames"`
	if [[ "$table" == "1" ]]; then
		TABLE_NAME="BoyNames"
	elif [[ "$table" == "2" ]]; then
		TABLE_NAME="GirlNames"
	else
		exit 1
	fi

else [[ "$DB_NAME" == "Note" ]]
	table=`dialog --stdout --title "選擇資料表" --menu "請選擇您要查看的資料表：" 10 50 2 1 "Today" 2 "Tomorrow"`
	
	if [[ "$table" == "1" ]]; then
		TABLE_NAME="Today"
	elif [[ "$table" == "2" ]]; then
		TABLE_NAME="Tomorrow"
	else
		exit 1
	fi
fi
#查詢選定的表
mysql -u"$DB_USER" -p"$DB_PASS" -D "$DB_NAME" --skip-column-names -e "SELECT * FROM \`$TABLE_NAME\`;" 2>/dev/null > result.txt
#顯示查詢結果
dialog --title "查詢結果 ($DB_NAME.$TABLE_NAME)" --textbox result.txt 20 60
