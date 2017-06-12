#!/usr/bin/env ruby
# Notify by Slack
# yum install -y ruby ruby-json

require 'net/http'
require 'uri'
require 'cgi'
require 'json'

# To create a webhook_url, login to the web page of your slack instance.
# https://my.slack.com/services/new/incoming-webhook/
# Select the slack channel to post to
# Click "Add incoming WebHooks integration"
# Paste the Webhook URL into the variable "webhook_url" below

## Chinh sua thong tin Slack va OMD
domain = 'meditechjsc.slack.com'
webhook_url = 'https://hooks.slack.com/services/T43EZN8L8/XXXXXXXXX/1RPRoM6iZYXGKPRTraDr6IDB'
monitoring_server = '192.168.100.139'
monitoring_site = 'monitoring'

COLOURS = {
	'CRITICAL'    => '#d00000',
	'UNKNOWN'     => '#e3e4e6',
	'WARNING'     => '#daa038',
	'OK'          => '#36a64f',
	'DOWN'        => '#d00000',
	'UNREACHABLE' => '#e3e4e6',
	'UP'          => '#36a64f',
	'PENDING'     => '#888888',
	'DOWNTIME'    => '#00aaff'
}

payload = {
	'username'   => 'Check_MK',
	'icon_emoji' => ':check_mk:',
	'channel'    => ENV['NOTIFY_PARAMETER_1']
}

host_start_url = "/#{monitoring_site}/check_mk/view.py?view_name=host&host=#{ENV['NOTIFY_HOSTALIAS']}"
host_url = "http://#{monitoring_server}/#{monitoring_site}/check_mk/index.py?start_url=#{CGI::escape(host_start_url)}"

# Check if NOTIFY_SERVICESTATE is set. If it's not, it's a host notification
if ENV.has_key?('NOTIFY_SERVICESTATE') && ENV['NOTIFY_SERVICESTATE'] != '$SERVICESTATE$'
	service_start_url = "/#{monitoring_site}/check_mk/view.py?view_name=service&service=#{ENV['NOTIFY_SERVICEDESC']}&host=#{ENV['NOTIFY_HOSTALIAS']}"
	service_url = "http://#{monitoring_server}/#{monitoring_site}/check_mk/index.py?start_url=#{CGI::escape(service_start_url)}"

	message = "<#{host_url}|#{ENV['NOTIFY_HOSTALIAS']}>/<#{service_url}|#{ENV['NOTIFY_SERVICEDESC']}> is #{ENV['NOTIFY_SERVICESTATE']}:\n#{ENV['NOTIFY_SERVICEOUTPUT']}"

	fields = [
		{'title' => 'State', 'value' => ENV['NOTIFY_SERVICESTATE'], 'short' => true},
		{'title' => 'Host', 'value' => "<#{host_url}|#{ENV['NOTIFY_HOSTALIAS']}>", 'short' => true},
		{'title' => 'Service', 'value' => "<#{service_url}|#{ENV['NOTIFY_SERVICEDESC']}>", 'short' => true},
		{'title' => 'Detail', 'value' => ENV['NOTIFY_SERVICEOUTPUT']},
	]

	if ENV.has_key?('NOTIFY_SERVICEACKCOMMENT') and ENV['NOTIFY_SERVICEACKCOMMENT'].length > 0
		fields.push({'title' => 'Comment', 'value' => ENV['NOTIFY_SERVICEACKCOMMENT']})
	end

	payload['attachments'] = [{
		'fallback'  => message,
		'color'     => COLOURS[ENV['NOTIFY_SERVICESTATE']],
		'fields'    => fields,
    		'mrkdwn_in' => ['text']
	}]
else
	message = "<#{host_url}|#{ENV['NOTIFY_HOSTALIAS']}>> is #{ENV['NOTIFY_HOSTSTATE']}:\n#{ENV['NOTIFY_HOSTOUTPUT']}"

	payload['attachments'] = [{
		'fallback'  => message,
		'color'     => COLOURS[ENV['NOTIFY_HOSTSTATE']],
		'fields'    => [
			{'title' => 'State', 'value' => ENV['NOTIFY_HOSTSTATE'], 'short' => true},
			{'title' => 'Host', 'value' => "<#{host_url}|#{ENV['NOTIFY_HOSTALIAS']}>", 'short' => true},
			{'title' => 'Detail', 'value' => ENV['NOTIFY_HOSTOUTPUT']},
		],
    		'mrkdwn_in' => ['text']
	}]
end

response = Net::HTTP.post_form(URI.parse(webhook_url), { 'payload' => payload.to_json })