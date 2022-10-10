import json

def lambda_handler(event, context):
  body = json.loads(event['body'])
  message = 'Hello {} !'.format(body['key1'])
  response = {
      "statusCode": 200,
      "headers": {
        "Content-Type": "application/json"
      },
      "isBase64Encoded": False,
      "multiValueHeaders": { 
        "X-Custom-Header": ["My value", "My other value"],
      },
      "body": "{\n  \"TotalCodeSize\": 104330022,\n  \"FunctionCount\": 26\n}"
    }
  return {
    "statusCode": 200,
    "body": json.dumps(message)
  }

