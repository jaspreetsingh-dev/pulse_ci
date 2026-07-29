import os


def check_dependencies(repo_path):
    req_path = os.path.join(repo_path, "requirements.txt")
    pkg_path = os.path.join(repo_path, "package.json")

    if os.path.exists(req_path) or os.path.exists(pkg_path):
        return {
            "name": "Dependencies",
            "passed": True,
            "status": "Dependency manifest detected.",
            "recommendation": None
        }

    return {
        "name": "Dependencies",
        "passed": False,
        "status": "No dependency manifest was found.",
        "recommendation": "Add a requirements.txt or package.json file to document project dependencies."
    }


def check_secrets(repo_path):
    keywords = ["password=", "api_key=", "secret=", "db_password="]

    for root, dirs, files in os.walk(repo_path):
        for file in files:
            full_path = os.path.join(root, file)

            try:
                with open(full_path, "r", encoding="utf-8", errors="ignore") as f:
                    for line in f:
                        line = line.lower()

                        for keyword in keywords:
                            if keyword in line:
                                return {
                                    "name": "Secrets",
                                    "passed": False,
                                    "status": "Potential hardcoded credentials detected.",
                                    "recommendation": "Move sensitive values into environment variables or a secrets manager."
                                }

            except:
                continue

    return {
        "name": "Secrets",
        "passed": True,
        "status": "No hardcoded secrets detected.",
        "recommendation": None
    }


def check_readme(repo_path):
    for filename in ["README.md", "README.txt", "README"]:
        if os.path.exists(os.path.join(repo_path, filename)):
            return {
                "name": "README",
                "passed": True,
                "status": "Repository documentation detected.",
                "recommendation": None
            }

    return {
        "name": "README",
        "passed": False,
        "status": "Repository documentation is missing.",
        "recommendation": "Add a README describing the project purpose, installation and usage."
    }


def check_tests(repo_path):
    for root, dirs, files in os.walk(repo_path):
        for file in files:
            if (
                file.startswith("test_")
                or file.endswith("_test.py")
                or file.endswith("_test.js")
            ):
                return {
                    "name": "Tests",
                    "passed": True,
                    "status": "Automated tests detected.",
                    "recommendation": None
                }

    return {
        "name": "Tests",
        "passed": False,
        "status": "No automated tests were found.",
        "recommendation": "Add a basic test suite to improve code reliability."
    }


def check_env(repo_path):
    if os.path.exists(os.path.join(repo_path, ".env.example")):
        return {
            "name": "Environment Template",
            "passed": True,
            "status": ".env.example detected.",
            "recommendation": None
        }

    return {
        "name": "Environment Template",
        "passed": False,
        "status": ".env.example is missing.",
        "recommendation": "Provide a sample environment configuration without exposing sensitive values."
    }


def check_gitignore(repo_path):
    if os.path.exists(os.path.join(repo_path, ".gitignore")):
        return {
            "name": "Git Ignore",
            "passed": True,
            "status": ".gitignore detected.",
            "recommendation": None
        }

    return {
        "name": "Git Ignore",
        "passed": False,
        "status": ".gitignore file is missing.",
        "recommendation": "Add a .gitignore file to prevent temporary files and secrets entering version control."
    }


def check_commit_message(commit_message):
    keywords = ["feat:", "fix:", "refactor:", "docs:", "chore:"]

    for keyword in keywords:
        if commit_message.lower().startswith(keyword):
            return {
                "name": "Commit Message",
                "passed": True,
                "status": "Commit message follows the recommended convention.",
                "recommendation": None
            }

    return {
        "name": "Commit Message",
        "passed": False,
        "status": "Commit message does not follow the recommended convention.",
        "recommendation": "Use Conventional Commit prefixes such as feat:, fix:, docs:, refactor: or chore:."
    }