# File containing comments

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 🚀 Demo: fetch the titles of the top‑5 trending GitHub repos
# 🎯 Goal: showcase HTTP requests, JSON handling, and simple formatting
# 📦 Uses only the Python standard library – no extra packages needed

import json
import sys
from urllib.request import Request, urlopen


# Comment with wide string ぁ
def fetch_trending(limit: int = 5):
    """
    Query GitHub’s public search API for the most‑starred repos.
    👀 Note: Unauthenticated calls have low rate limits; add a token for heavy use.
    """
    url = (
        f"https://api.github.com/search/repositories"
        f"?q=stars:>50000&sort=stars&order=desc&per_page={limit}"
    )
    headers = {"Accept": "application/vnd.github.v3+json"}
    req = Request(url, headers=headers)

    with urlopen(req) as resp:
        data = json.load(resp)

    # Extract only the fields we care about
    repos = [
        {
            "name": item["full_name"],
            "stars": item["stargazers_count"],
            "url": item["html_url"],
        }
        for item in data.get("items", [])
    ]
    return repos

def commentMain():
    # 🧩 Run the fetch and pretty‑print the result
    repos = fetch_trending()
    if not repos:
        print("No data received.")  # ⚠️ Simple fallback
        return

    print("\nTop trending GitHub repos:\n")
    for idx, repo in enumerate(repos, start=1):
        # 👉 Show rank, name, star count (with commas), and URL
        print(f"{idx}. {repo['name']} – {repo['stars']:,} stars")
        print(f"   {repo['url']}\n")

    # ✅ Finished – you can now extend or integrate this logic elsewhere
    # 💡 Tip: wrap the request in a try/except block for production robustness

if __name__ == "__main__":
    # 💡 Entry‑point guard – keeps imports clean when used as a module
    commentMain()