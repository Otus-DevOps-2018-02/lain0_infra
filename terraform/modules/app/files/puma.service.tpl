[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=appuser
Environment=DATABASE_URL=${reddit_db_addr}
WorkingDirectory=/home/appuser/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
