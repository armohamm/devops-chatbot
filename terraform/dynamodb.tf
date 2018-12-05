resource "aws_dynamodb_table" "alert_log" {
  name             = "alert-log"
  hash_key         = "messageID"
  read_capacity    = 20
  write_capacity   = 20
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "messageID"
    type = "S"
  }

  tags {
    Name = "DynamoDB alert log table"
  }
}

resource "aws_dynamodb_table_item" "alert_log_counter_item" {
  table_name = "${aws_dynamodb_table.alert_log.name}"
  hash_key   = "${aws_dynamodb_table.alert_log.hash_key}"

  item = <<ITEM
{
    "messageID": {"S": "counter"},
    "message": {"S":"0"},
    "active": {"B": "true"}
}
ITEM
}



#--Start escalation_target DDB table
#escalation_target table
resource "aws_dynamodb_table" "escalation_target" {
   name = "escalation_target"
   hash_key = "dayName"
   read_capacity = 20
   write_capacity = 20
   stream_enabled = true
   stream_view_type = "NEW_AND_OLD_IMAGES"

   attribute {
      name = "dayName"
      type = "S"
   }

   tags {
     Name = "DynamoDB escalation target table"
   }
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Monday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Monday"},
    "escalationTarget": {"S":"George"},
    "escalationNumber": {"S":"+1511111111"}
}
ITEM
}


#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Tuesday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Tuesday"},
    "escalationTarget": {"S":"Max"},
    "escalationNumber": {"S":"+1511111112"}
}
ITEM
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Wednesday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Wednesday"},
    "escalationTarget": {"S":"Nick"},
    "escalationNumber": {"S":"+1511111113"}
}
ITEM
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Thursday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Thursday"},
    "escalationTarget": {"S":"David"},
    "escalationNumber": {"S":"+1512123124"}
}
ITEM
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Friday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Friday"},
    "escalationTarget": {"S":"Maria"},
    "escalationNumber": {"S":"+1512123125"}
}
ITEM
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Saturday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Saturday"},
    "escalationTarget": {"S":"Anastasia"},
    "escalationNumber": {"S":"+1512123126"}
}
ITEM
}

#escalation_target table item
resource "aws_dynamodb_table_item" "escalation_target_item_Sunday" {
  table_name = "${aws_dynamodb_table.escalation_target.name}"
  hash_key   = "${aws_dynamodb_table.escalation_target.hash_key}"
  item = <<ITEM
{
    "dayName": {"S": "Sunday"},
    "escalationTarget": {"S":"Katerina"},
    "escalationNumber": {"S":"+1512123127"}
}
ITEM
}

#--END escalation_target DDB table