"""This module resets the dead man's switch by 24 hours (86400s), every time new files are put in the s3 bucket"""
import requests

timer = "JTJfJUwGRAL6V5OolhV0cDjC5gk9OwFc"
timer_url = "https://timercheck.io/{name}/86400".format(name=timer)

def handler(event, context):
    """GET request to reset the timer"""
    r = requests.get(timer_url)
    print r.text
