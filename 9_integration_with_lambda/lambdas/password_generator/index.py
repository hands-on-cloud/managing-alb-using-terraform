import json
import random
import string
import random
import string
import re

def lambda_handler(event, context):
    max = 8
    password = ''.join(random.choices(string.ascii_lowercase+string.ascii_uppercase, k=max))
    mandatory = ''.join(''.join(random.choices(choice)) for choice in [string.ascii_lowercase, string.ascii_uppercase, "_@", string.digits])
    password_list = list(password+mandatory)
    random.shuffle(password_list)
    while re.match("^[0-9]|@|_",''.join(list(password_list))) != None:
        random.shuffle(password_list)
        password_list=list(password+mandatory)
    response_json = {
        'password': ''.join(password_list)
    }
    return {
        'statusCode': 200,
        'statusDescription': '200 OK',
        'isBase64Encoded': False,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(response_json)
    }
