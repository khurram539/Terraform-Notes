provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "ssm_logs" {
  name              = "kaytheon-system-manager"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_role" {
  name = "ssm-patch-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_ssm_ec2" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_ec2_read" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# ➕ S3 PutObject Permission for Lambda
resource "aws_iam_policy" "lambda_s3_put_policy" {
  name = "lambda-s3-put-kaytheon"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject"],
        Resource = "arn:aws:s3:::kaytheon-system-manager/*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_s3_attach" {
  name       = "attach-s3-put"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_s3_put_policy.arn
}

resource "aws_lambda_function" "patch_lambda" {
  filename         = "lambda.zip"
  function_name    = "patch_all_instances"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_patch.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_cloudwatch_event_rule" "every_friday_3pm" {
  name                = "Patch-now-friday"
  description         = "Patch EC2s every Friday at 3PM EST"
  schedule_expression = "cron(0 19 ? * 6 *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_friday_3pm.name
  target_id = "patchLambda"
  arn       = aws_lambda_function.patch_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.patch_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_friday_3pm.arn
}
