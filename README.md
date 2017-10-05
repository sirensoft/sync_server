<h3>การเตรียมระบบ</h3>
<ol>
<li>สร้าง mysql database ชื่อ sync</li>
<li>นำเข้าไฟล์ config/sync.sql</li>
</ol>

<h3>การติดตั้ง</h3>
<ol>
<li>git clone https://github.com/sirensoft/sync_server.git</li>
<li>cd sync_server && npm install</li>
<li>แก้ไข config/connect-db.json </li>
<li>แก้ไข listen port ที่ bin/www </li>
<li>npm start</li>
</ol>

<h3>routing</h3>
<ol>
<li>/api/sql = แสดงรายการคำสั่งจาก server <a href='http://61.19.22.108:3001/api/sql' target='_blank'>demo</a></li>
</ol>

<h3>ตัวอย่าง client</h3>
https://github.com/sirensoft/dhdc3/tree/master/modules/sync
