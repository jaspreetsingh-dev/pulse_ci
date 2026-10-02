# Pulse CI

Pulse CI is a repository analysis service built with Python and Flask.

It clones a GitHub repository, runs a set of repository-quality checks, calculates a score, stores the result in PostgreSQL, and shows every analysis on a dashboard. Analyses run from a GitHub push webhook or from a manually entered repository URL.

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

### AWS Services Used

* EC2
* RDS PostgreSQL
* VPC
* IAM
* Systems Manager Parameter Store
* Secrets Manager
* CloudWatch

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

## Deployment

The application is containerized with Docker and runs on an Amazon EC2 instance. Terraform provisions the AWS infrastructure listed above, and EC2 user data runs the application at launch.

Database credentials are retrieved from AWS services rather than stored directly in the application source code.

Application logs are sent to Amazon CloudWatch Logs.

## Known Limitations

* `/webhook` does not verify GitHub's webhook signature, so any request to the endpoint can trigger an analysis.
* Manual analysis does not validate the repository URL.
* Checks are filename and keyword heuristics, not static analysis. The secrets check looks for strings such as `password=` and `api_key=`, so it can flag harmless lines and miss real secrets written another way (for example `password = "..."`).
* The dependency, README, `.env.example` and `.gitignore` checks only look in the repository root, and the dependency check only recognizes `requirements.txt` and `package.json`.
* The commit message check requires one of `feat:`, `fix:`, `refactor:`, `docs:` or `chore:` at the start, so a scoped message such as `feat(api): ...` fails.
* The score is the percentage of checks passed, with every check weighted equally. Manual analysis runs 6 checks and webhook analysis runs 7, so scores from the two modes are not directly comparable.

## Status

The application was deployed on AWS. It is not currently running. Screenshots are in the LinkedIn Featured section.

## Purpose

The project was built as a practical exercise in Python application development, Docker, AWS infrastructure, database connectivity, secrets management, logging, and troubleshooting.
