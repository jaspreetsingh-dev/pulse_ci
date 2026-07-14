import subprocess
import tempfile
import os
import shutil
import stat

def clone_repo(url):
    temp_path = tempfile.mkdtemp()
    subprocess.run(["git", "clone", url, temp_path])
    return temp_path

def cleanup(path):
    def handle_remove_readonly(func, path, exc):
        os.chmod(path, stat.S_IWRITE)
        func(path)
    shutil.rmtree(path, onerror=handle_remove_readonly)