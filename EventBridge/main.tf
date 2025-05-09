provider "aws" {
  region = "us-east-1"
}

variable "instance_ids" {
  default = ["i-09662a8e5a01956f8", "i-02f4cb01ee5b3da30,i-02141221f5e9073ab"]
}

# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda_ec2_role" {
  name = "lambda-ec2-control-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_ec2_attachment" {
  name       = "attach-ec2-policy"
  roles      = [aws_iam_role.lambda_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- Lambda Code Archive ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "ec2_scheduler" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ec2-scheduler"
  role             = aws_iam_role.lambda_ec2_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  environment {
    variables = {
      INSTANCE_IDS = join(",", var.instance_ids)
    }
  }
}

# --- EventBridge Rules (corrected for Eastern Time) ---
resource "aws_cloudwatch_event_rule" "start_rule" {
  name                = "ec2-start-9am"
  schedule_expression = "cron(0 13 ? * MON-FRI *)" # 9 AM EDT/EST (13 UTC)
}

resource "aws_cloudwatch_event_rule" "stop_rule" {
  name                = "ec2-stop-5pm"
  schedule_expression = "cron(0 21 ? * MON-FRI *)" # 5 PM EDT/EST (21 UTC)
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_rule.name
  target_id = "start-ec2"
  arn       = aws_lambda_function.ec2_scheduler.arn

  input = jsonencode({
    action = "start"
  })
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_rule.name
  target_id = "stop-ec2"
  arn       = aws_lambda_function.ec2_scheduler.arn

  input = jsonencode({
    action = "stop"
  })
}

resource "aws_lambda_permission" "allow_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rule.arn
}

resource "aws_lambda_permission" "allow_eventbridge_stop" {
  statement_id  = "AllowExecutionFromEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rule.arn
}
