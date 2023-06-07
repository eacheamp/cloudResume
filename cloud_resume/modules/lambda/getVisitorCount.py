import json
import boto3

dynamodb        = boto3.resource('dynamodb')
tableName       = "eacheampongVisitorCounter"
table           = dynamodb.Table(tableName)

def handler (e, context):
    # -> get item - get number of visitors
    response    = table.get_item(Key={
        "siteStat_id":"Count"} 
        )

    return {
    "headers": 
    {"Access-Control-Allow-Origin": "*"
        },
        "statusCode": 200, 
        "body": str(response['Item']['siteStat_id'] )} or {"statusCode": 404, "body": "Item not found"}
