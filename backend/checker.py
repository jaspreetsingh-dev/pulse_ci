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