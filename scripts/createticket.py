#!/usr/bin/env python
# create ticket
import json
import requests
import os

if("NOTIFY_WHAT"=="HOST"):
	ticket_host = {"autorespond":"false", "source": "API", "name": "BOT MDT", "email":"mdtbot@meditech.vn", "subject": "host" + " " + os.environ.get('NOTIFY_HOSTNAME'), "message": "STATUS : " + " " + os.environ.get('NOTIFY_HOSTSTATE')}
	data_ticket_host = json.dumps(ticket_host)
	#ticket_json = json.loads(ticket)
	headers = {'X-API-Key' : '24B07C94FD38DE3D2C9A0311D84353C8'}
	response = requests.request("POST", "http://192.168.30.121/helpdesk/api/http.php/tickets.json", data=data_ticket_host, headers=headers)
	print(response.text)
else:
	ticket_services = {"autorespond":"false", "source": "API", "name": "BOT MDT", "email":"mdtbot@meditech.vn", "subject": "service :" + " " + os.environ.get('NOTIFY_SERVICEDESC'), "message": "STATUS : " + " " + os.environ.get('NOTIFY_SERVICEOUTPUT')}
	data_ticket_services = json.dumps(ticket_services)
	#ticket_json = json.loads(ticket)
	headers = {'X-API-Key' : '24B07C94FD38DE3D2C9A0311D84353C8'}
	response = requests.request("POST", "http://192.168.30.121/helpdesk/api/http.php/tickets.json", data=data_ticket_services, headers=headers)
	print(response.text)
