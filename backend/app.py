from flask import Flask, request, jsonify
from checker import check_dependencies, check_secrets, check_readme, check_tests, check_env, check_commit_message, check_gitignore
from cloner import cleanup, clone_repo
from database import init_db, save_result, get_results

app = Flask(__name__)
init_db()

@app.route("/results", methods=["GET"])
def get_results_route():
    results = get_results()
    return jsonify(results)

@app.route("/analyze", methods=["POST"])
def analysis():
    data = request.json
    repo_url = data.get("repo_url")
    repo_path = clone_repo(repo_url)
    try:
        result1 = check_dependencies(repo_path)
        result2 = check_secrets(repo_path)
        result3 = check_readme(repo_path)
        result4 = check_tests(repo_path)
        result5 = check_env(repo_path)
        result6 = check_commit_message("manual analysis")
        result7 = check_gitignore(repo_path)
        checks = [result1, result2, result3, result4, result5, result6, result7]
        passed = sum(1 for check in checks if check["passed"])
        score = int(passed / len(checks) * 100)
        save_result(repo_url, score, "manual analysis", passed)
        return jsonify({
            "repo_url": repo_url,
            "score": score,
            "checks": checks
        })
    finally:
        cleanup(repo_path)