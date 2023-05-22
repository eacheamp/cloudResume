resource "aws_dynamodb_table" "site-stats-dynamodb-table" {
  name           = "eacheampongVisitorCounter"
  billing_mode   = "PROVISIONED"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "siteStat_id"
  range_key      = "visitorCount"

  attribute {
    name = "siteStat_id"
    type = "S"
  }

  attribute {
    name = "visitorCount"
    type = "S"
  }

  tags = {
    Name        = "eacheampongVisitorCounter"
    Environment = "production"
    project     = "cloudResumeChallange"
  }
}