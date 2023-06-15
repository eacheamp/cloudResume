import json
import boto3

dynamodb        = boto3.resource('dynamodb')
tableName       = "eacheampongVisitorCounter"
table           = dynamodb.Table(tableName)

def handler (e, context):
    # -> get item - get number of visitors
    response    = table.get_item(
        Key={"siteStat_id":"siteStat_val"} 
        )
    table_item = response["Item"]   
    # update table item
    table.update_item(
            Key={"siteStat_id":"siteStat_val"},
            UpdateExpression="set Visits = Visits + :n",
            ExpressionAttributeValues={
                ":n":1,
            },
            ReturnValues="UPDATED_NEW",
        )
    return {
        "headers": 
            {  
            "Content-Type": "application/json",
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS"
            },
            "statusCode": 200,
            "body": "You are the "+str(table_item["Visits"]) +"th visitor"} or {"statusCode": 404, "body": "Item not found"}