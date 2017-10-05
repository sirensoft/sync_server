<h3>A) การเตรียมระบบ</h3>
<ol>
<li>สร้าง mysql database ชื่อ sync</li>
<li>นำเข้าไฟล์ config/sync.sql</li>
</ol>

<h3>B) การติดตั้ง</h3>
<ol>
<li>git clone https://github.com/sirensoft/sync_server.git</li>
<li>cd sync_server && npm install</li>
<li>แก้ไข config/connect-db.json </li>
<li>แก้ไข listen port ที่ bin/www </li>
<li>npm start</li>
</ol>

<h3>C) routing</h3>
<ol>
<li>GET  /api/ = ทดสอบ</li>
<li>GET  /api/sql = แสดงรายการคำสั่งจาก server  [<a href='http://61.19.22.108:3001/api/sql' target='_blank'>demo</a>]</li>
<li>POST /api/send/ชื่อตาราง(เช่น qof_anc12)</li>
</ol>

<h3>D) ตัวอย่าง client</h3>
https://github.com/sirensoft/dhdc3/tree/master/modules/sync
