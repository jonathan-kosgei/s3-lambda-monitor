import datetime
import json
import requests

# The PagerDuty API URL
url = "https://events.pagerduty.com/v2/enqueue"
timer = "JTJfJUwGRAL6V5OolhV0cDjC5gk9OwFc"
timer_url = "https://timercheck.io/{name}".format(name=timer)
timestamp = datetime.now().isoformat()

# The Payload
payload = {}
payload['routing_key']          = "523a456b70a049e5976fa5ac9ae86f48"
payload['event_action']         = "trigger" 
payload['payload'] = {}
payload['payload']['summary']   = "Last backup failed!"
payload['payload']['timestamp'] = timestamp
payload['payload']['source']    = "s3://backup-bucket"
payload['payload']['severity']  = "critical"
payload['payload']['component'] = "backups"
payload['payload']['class']     = "backup failed"

# Headers
headers = {}
headers['content-type'] = "application/json"

def handler(event, context):
    r = requests.get(timer_url).status
    if r==504:
        r = requests.post(url, headers=headers, data=json.dumps(payload))
        print r.text
