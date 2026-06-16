import os

def check_dependencies(repo_path):
    req_path = os.path.join(repo_path, "requirements.txt")
    pkg_path = os.path.join(repo_path, "package.json")
    if os.path.exists(req_path) or os.path.exists(pkg_path):
        return {
            "passed": True,
            "reason": "requirements/package exists"
        }
    else:
        return {
            "passed": False,
            "reason": "recommended: please add requirements.txt or package.json"
        }

def check_secrets(repo_path):
    keywords = ["password=", "api_key=", "secret=", "db_password="]
    for root, dirs, files in os.walk(repo_path):
        for file in files:
            full_path = os.path.join(root, file)
            try:
                with open(full_path, "r") as f:
                    for line in f:
                        line = line.lower()
                        for keyword in keywords:
                            if keyword in line:
                                return {"passed": False,
                                       "reason": "confidentials are hardcoded"
                                       }
            except:
                continue
        return {
            "passed": True,
            "reason": "No confidentials are hardcoded"
        }
    
def check_readme(repo_path):
    keywords = ["README.md", "README.txt", "README"]
    for keyword in keywords:
        readme_path = os.path.join(repo_path, keyword)
        if os.path.exists(readme_path):
            return {
                "passed": True,
                "reason": "Readme exists"
            }
    return {
        "passed": False,
        "reason": "Readme does not exist!"
    }

def check_tests(repo_path):
    for root, dirs, files in os.walk(repo_path):
        for file in files:
            if file.startswith("test_") or file.endswith("_test.py") or file.endswith("_test.js"):
                return {
                    "passed": True,
                    "reason": "test file found"
                }
    return {
        "passed": False,
        "reason": "no test files found"
    }