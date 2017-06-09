# Create the timer lambda function
resource "aws_lambda_function" "timer" {
  filename         = "../lambda/timer.zip"
  function_name    = "timer"
  role             = "${aws_iam_role.lambda-role.arn}"
  handler          = "lambda_handler"
  source_code_hash = "${base64sha256(file("../lambda/timer/timer.zip"))}"
  runtime          = "python2.7"
  depends_on       = ["null_resource.timer_zip"]
}

# Allow s3 to invoke the lambda function
resource "aws_lambda_permission" "allow_s3" {
  statement_id   = "AllowExecutionFromS3"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.timer.function_name}"
  principal      = "s3.amazonaws.com"
  source_account = "${var.account_id}"
  source_arn     = "${aws_iam_role.lambda-role.arn}"
  depends_on = ["aws_lambda_function.timer"]
}

# Enabling notifications for s3 to the timer lambda function
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.timer.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }
}

# Create the pagerduty daily check function
resource "aws_lambda_function" "pagerduty" {
  filename         = "../lambda/pagerduty.zip"
  function_name    = "pagerduty-monitor"
  role             = "${aws_iam_role.lambda-role.arn}"
  handler          = "lambda_handler"
  source_code_hash = "${base64sha256(file("../lambda/pagerduty/pagerduty.zip"))}"
  runtime          = "python2.7"
  depends_on       = ["null_resource.pagerduty_zip"]
  provisioner "local-exec" {
    command = "aws events put-rule --name pagerduty-daily-rule --schedule-expression 'rate(1 day)'"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.pagerduty.function_name}"
  principal      = "events.amazonaws.com"
  source_account = "${var.account_id}"
  source_arn     = "arn:aws:events:${var.region}:${var.account_id}:rule/pagerduty-daily-rule"
  provisioner "local-exec" {
    command = "aws events put-targets --rule pagerduty-daily-rule --targets file://files/targets.json"
  }
  depends_on = ["null_resource.lambda", "aws_lambda_function.pagerduty"]
}
