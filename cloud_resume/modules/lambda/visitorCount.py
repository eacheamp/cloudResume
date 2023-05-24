import json
import boto3

dynamodb        = boto3.resource('dynamodb')
tableName       = "eacheampongVisitorCounter"
table           = dynamodb.Table(tableName)

def lambda_handler (e, context):
    response    = table.get_item(Key={"siteStat_id":'Count'})
    count       = response["Item"]["visitorCount"]

    newCount    = str(int(count)+1)
    response    = table.update_item(
        Key = {"siteStat_id":'Count'},
        UpdateExpression= "set visitorCount = :c",
        ExpressionAttributeValues = {':c':newCount},
        ReturnValues = "UPDATES_NEW"
    )
    return {'Count':newCount}