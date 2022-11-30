resource "aws_sns_topic" "enriched_events_topic" {
  name = "gp-registrations-mi-enriched-events-sns-topic"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-gp-registrations-mi-enriched-events-sns-topic"
    }
  )
}

resource "aws_sns_topic_subscription" "enriched_events_sqs_target" {
  topic_arn = aws_sns_topic.enriched_events_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.incoming_mi_events_for_s3_uploader.arn
}