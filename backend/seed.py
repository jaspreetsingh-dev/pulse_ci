import requests

payloads = [
    {
        "repository": {"clone_url": "https://github.com/jaspreetsingh-dev/github-analyzer"},
        "head_commit": {"message": "feat: add authentication flow"}
    },
    {
        "repository": {"clone_url": "https://github.com/jaspreetsingh-dev/github-analyzer"},
        "head_commit": {"message": "fix"}
    },
    {
        "repository": {"clone_url": "https://github.com/jaspreetsingh-dev/github-analyzer"},
        "head_commit": {"message": "refactor: clean up database queries"}
    },
    {
        "repository": {"clone_url": "https://github.com/jaspreetsingh-dev/github-analyzer"},
        "head_commit": {"message": "update"}
    },
    {
        "repository": {"clone_url": "https://github.com/jaspreetsingh-dev/github-analyzer"},
        "head_commit": {"message": "docs: add README setup instructions"}
    }
]

for payload in payloads:
    response = requests.post("http://localhost:5000/webhook", json=payload)
    print(response.json())