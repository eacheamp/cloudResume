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
        {  
        "Content-Type": "application/json",
		"Access-Control-Allow-Headers": "Content-Type",
		"Access-Control-Allow-Origin": "*",
		"Access-Control-Allow-Methods": "OPTIONS,GET"
        },
        "statusCode": 200, 
        "body": str(response['Item']['visitorCount'])} or {"statusCode": 404, "body": "Item not found"}
