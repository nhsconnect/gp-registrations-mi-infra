resource "aws_sns_topic" "enriched_events_topic" {
  name = "gp-registrations-mi-enriched-events-sns-topic"
  kms_master_key_id = "alias/aws/sns"

  sqs_failure_feedback_role_arn = aws_iam_policy.sns_topic_enriched_mi_events_log_access.arn
  sqs_success_feedback_role_arn = aws_iam_policy.sns_topic_enriched_mi_events_log_access.arn


  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-gp-registrations-mi-enriched-events-sns-topic"
      ApplicationRole = "AwsSnsTopic"
    }
  )
}

resource "aws_sns_topic_subscription" "enriched_events_to_s3_event_uploader_sqs_target" {
  topic_arn = aws_sns_topic.enriched_events_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.incoming_mi_events_for_s3_event_uploader.arn
}

resource "aws_sns_topic_subscription" "enriched_events_to_splunk_cloud_event_uploader_sqs_target" {
  topic_arn = aws_sns_topic.enriched_events_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.incoming_mi_events_for_splunk_cloud_event_uploader.arn
}