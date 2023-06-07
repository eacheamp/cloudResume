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
    site_count = response['Item']['visitorCount']
    site_count = site_count + 1
    print(site_count)

    new_response    =   table.put_item(Item={
        "siteStat_id":"Count",
        'visitorCount': site_count
    })

    return  {
        'statusCode' : 200,
        'headers':{
            "Access-Control-Allow-Origin":"*"
        }
    }
