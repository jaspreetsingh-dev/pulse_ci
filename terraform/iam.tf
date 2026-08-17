resource "aws_iam_role" "ec2" {

  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"

      }

    ]

  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
} 

resource "aws_iam_policy" "ec2" {

  name = "${var.project_name}-ec2-policy"

  description = "Permissions required by the Pulse CI EC2 instance."

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
      Effect = "Allow"

      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ]

      Resource = [
        "arn:aws:ssm:${var.region}:*:parameter/${var.project_name}/*"
      ]
      },

      {
      Effect = "Allow"
 
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]

      Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          aws_db_instance.postgres.master_user_secret[0].secret_arn
        ]
      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "ec2" {

  role = aws_iam_role.ec2.name

  policy_arn = aws_iam_policy.ec2.arn

}

resource "aws_iam_instance_profile" "ec2" {

  name = "${var.project_name}-instance-profile"

  role = aws_iam_role.ec2.name

}