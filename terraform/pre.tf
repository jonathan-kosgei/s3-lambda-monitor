# provision targets.json
resource "null_resource" "lambda" {
  provisioner "local-exec" {
    command = "file=`jq --arg arn arn:aws:lambda:${var.region}:${var.account_id}:function:${aws_lambda_function.pagerduty.function_name} '(.[].Arn) = $arn' ../terraform/files/targets.json` && echo $file > ../terraform/files/targets.json"
  }
}

resource "null_resource" "pagerduty_zip" {
  provisioner "local-exec" {
    command = "cd ../lambda/pagerduty/venv/lib/python2.7/site-packages && zip -r9 pagerduty.zip * && mv pagerduty.zip ../../../../pagerduty.zip && cd ../../../../ && zip -g pagerduty.zip pagerduty.py"
  }
}

resource "null_resource" "timer_zip" {
  provisioner "local-exec" {
    command = "cd ../lambda/timer/venv/lib/python2.7/site-packages && zip -r9 timer.zip * && mv timer.zip ../../../../timer.zip && cd ../../../../ && zip -g timer.zip timer.py"
  }
}