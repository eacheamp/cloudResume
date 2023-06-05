resource "aws_dynamodb_table" "site-stats-dynamodb-table" {
  name           = "eacheampongVisitorCounter"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "siteStat_id"
  range_key      = "visitorCount"

  attribute {
    name = "siteStat_id"
    type = "S"
  }

  attribute {
    name = "visitorCount"
    type = "N"
  }

  tags = {
    Name        = "eacheampongVisitorCounter"
    Environment = "production"
    project     = "cloudResumeChallange"
  }
}

resource "aws_dynamodb_table_item" "site_stat_item_1" {
  table_name  = aws_dynamodb_table.site-stats-dynamodb-table.name
  hash_key    = aws_dynamodb_table.site-stats-dynamodb-table.hash_key
  range_key   = aws_dynamodb_table.site-stats-dynamodb-table.range_key

  item = <<ITEM
  {
    "siteStat_id" : {
      "S": "Count"
        },
    "visitorCount" : {
      "N" : "1"
        },
    "noKey" : {
      "S": "nokey"
        }
  }
  ITEM
}