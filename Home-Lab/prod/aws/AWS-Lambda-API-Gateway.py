import json

def lambda_handler(event, context):
    personId = event["queryStringParameters"]["personId"]

    print(f"The personID extracted from the GET request is {personId}")
    return {"firstName": "Daniel"}