import subprocess
import tempfile
import os
import shutil

def clone_repo(url):
    temp_path = tempfile.mkdtemp()
    subprocess.run(["git", "clone", url, temp_path])
    return temp_path

def cleanup(path):
    shutil.rmtree(path)