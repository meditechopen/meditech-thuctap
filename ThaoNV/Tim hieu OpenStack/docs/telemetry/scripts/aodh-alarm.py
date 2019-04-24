#!/usr/bin/python
from flask import Flask, request
import requests
import json
import logging
app = Flask(__name__)


logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO)
loger = logging.getLogger(__name__)

@app.route("/cpu", methods=['POST'])
def alarm_image():
    status = json.loads(request.data)['current']
    reason = json.loads(request.data)['reason']
    value = json.loads(request.data)['reason_data']['most_recent']
    previous = json.loads(request.data)['previous']
    notify='''
            *STATUS OF CPU CHANGED*
        STATUS: `{0}`
        REASON: `{1}`
        VALUE: `{2}`
        PREVIOUS STATUS: `{3}`
            '''.format(status, reason, value, previous)
    json_payload = {
        "text" : notify,
        "channel" : "#alerts",
        "username" : "AODH",
    }

    headers = {'content-type': 'application/json', 'accept': 'application'}
    requests.post(url='https://hooks.slack.com/services/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',
                                       data=json.dumps(json_payload),
                                       headers=headers)
    return "cpu was changed"
    
@app.route("/memory", methods=['POST'])
def alarm_image():
    status = json.loads(request.data)['current']
    reason = json.loads(request.data)['reason']
    value = json.loads(request.data)['reason_data']['most_recent']
    previous = json.loads(request.data)['previous']
    notify='''
            *STATUS OF MEMORY CHANGED*
        STATUS: `{0}`
        REASON: `{1}`
        VALUE: `{2}`
        PREVIOUS STATUS: `{3}`
            '''.format(status, reason, value, previous)
    json_payload = {
        "text" : notify,
        "channel" : "#alerts",
        "username" : "AODH",
    }

    headers = {'content-type': 'application/json', 'accept': 'application'}
    requests.post(url='https://hooks.slack.com/services/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',
                                       data=json.dumps(json_payload),
                                       headers=headers)
    return "memory was changed"
    
if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5123)
