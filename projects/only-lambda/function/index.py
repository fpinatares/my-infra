import json
import boto3
import uuid

def lambda_handler(event, context):
  dynamodb = boto3.client('dynamodb')
  body = json.loads(event['body'])
  dynamodb.put_item(TableName='Persons', Item={'Id':{'S':str(uuid.uuid4)},'Name':{'S':body['name']},'Age':{'N':body['age']}})
  message = 'Hello {} !'.format(body['name'])
  return {
    "statusCode": 200,
    "body": json.dumps(message)
  }

