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