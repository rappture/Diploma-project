#!/bin/bash

wget https://dl.pstmn.io/download/latest/linux_64;
tar -xzf linux_64;
~/Postman/Postman 

158.160.81.6/zabbix/api_jsonrpc.php
Headers: Content-Type application/json-rpc


Body: raw json


{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "Admin",
        "password": "zabbix"
    },
    "id": 1,
    "auth": null
}