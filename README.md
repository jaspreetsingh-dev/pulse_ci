# Pulse CI

Pulse CI is a lightweight repository analysis service built with Python and Flask.

It clones a GitHub repository, runs a set of repository-quality checks, calculates a score, and stores analysis results in PostgreSQL.

## Checks

Pulse CI currently checks:

- Dependency manifest
- Potential hardcoded secrets
- README documentation
- Automated tests
- `.env.example`
- `.gitignore`
- Commit message convention for webhook-triggered analyses

Manual repository analysis does not evaluate commit messages because no commit is associated with a manual request.

## Architecture

```text
GitHub
   │
   ├── Manual analysis
   │
   └── Webhook
          │
          ▼
       EC2
        │
      Docker
        │
     Pulse CI
        │
        ├── Repository checks
        │
        └── PostgreSQL
              │
             RDS
````

### AWS Services Used

* EC2
* RDS PostgreSQL
* VPC
* IAM
* Systems Manager Parameter Store
* Secrets Manager
* CloudWatch

## Deployment

The application is containerized with Docker and deployed to an Amazon EC2 instance.

Database credentials are retrieved from AWS services rather than stored directly in the application source code.

Application logs are sent to Amazon CloudWatch Logs.

## Analysis Flow

### Manual Analysis

```text
Repository URL
      ↓
Clone repository
      ↓
Run repository checks
      ↓
Calculate score
      ↓
Store result in PostgreSQL
```

### Webhook Analysis

```text
GitHub push event
      ↓
/webhook
      ↓
Clone repository
      ↓
Run repository checks
      ↓
Evaluate commit message
      ↓
Calculate score
      ↓
Store result in PostgreSQL
```

## Purpose

The project was built as a practical exercise in Python application development, Docker, AWS infrastructure, database connectivity, secrets management, logging, and troubleshooting.

````