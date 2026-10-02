# Pulse CI

Pulse CI is a repository analysis service built with Python and Flask.

It clones a GitHub repository, runs a set of repository-quality checks, calculates a score, stores the result in PostgreSQL, and shows every analysis on a dashboard. Analyses run from a GitHub push webhook or from a manually entered repository URL.

## Checks

* Dependency manifest
* Potential hardcoded secrets
* README documentation
* Automated tests
* `.env.example`
* `.gitignore`
* Commit message convention (webhook-triggered analyses only; manual analysis has no commit)

## Architecture

```text
GitHub push ──► /webhook ──┐
                           ▼
Manual repo URL ──► Pulse CI (Flask, Docker, EC2)
                           │
                           ├── Clone repository and run checks
                           ├── Parameter Store, Secrets Manager (database password)
                           ├── CloudWatch Logs
                           │
                           ▼
                    PostgreSQL (RDS) ──► Dashboard
```

## Analysis Flow

```text
GitHub push event (/webhook) or manual repository URL
      ↓
Clone repository
      ↓
Run repository checks
      ↓
Evaluate commit message (webhook only)
      ↓
Calculate score
      ↓
Store result in PostgreSQL
```

## Configuration

The application reads these environment variables:

```text
DB_HOST
DB_NAME
DB_USER
DB_PORT
DB_PASSWORD
```

On AWS, the EC2 user data script reads the host, name, user and port from Systems Manager Parameter Store and the password from Secrets Manager, then passes them to the container.

## Deployment

The application is containerized with Docker and runs on an Amazon EC2 instance. Terraform provisions the AWS infrastructure, and EC2 user data runs the application at launch.

AWS services used: EC2, RDS PostgreSQL, VPC, IAM, Systems Manager Parameter Store, Secrets Manager, CloudWatch.

Application logs are sent to Amazon CloudWatch Logs.

## Status

The application was deployed on AWS. It is not currently running. Screenshots are in the LinkedIn Featured section.
