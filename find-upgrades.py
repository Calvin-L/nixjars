#!/usr/bin/env python3

# nix-shell -p python3 python3Packages.requests --run ./find-upgrades.py

import os
from pathlib import PurePath
import re
import subprocess
import json

import requests

gh_url_re = re.compile(r"^https://(?:\w+\.)?github\.com/([^/]*)/([^/]*)/archive/(.*)\.tar\.gz$")

assert gh_url_re.match("https://github.com/antlr/antlr4/archive/4.13.1.tar.gz") is not None
assert gh_url_re.match("https://github.com/apache/commons-io/archive/rel/commons-io-2.16.1.tar.gz") is not None

def tags_at_page(owner, repo, page):
    return requests.get(f"https://api.github.com/repos/{owner}/{repo}/tags?page={page}", headers={"Accept": "application/vnd.github+json"}).json()

def tags(owner, repo):
    pagenum = 1
    result = []
    while page := tags_at_page(owner, repo, pagenum):
        result.extend(page)
        pagenum += 1
    return result

cache = {}
def latest_release(owner, repo):
    key = (owner, repo)
    result = cache.get(key)
    if result is None:
        url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
        response = requests.get(url, headers={"Accept": "application/vnd.github+json"}).json()
        result = response.get("tag_name")
        cache[key] = result
    return result

def run():
    print("Collecting packages...")
    pkgs = subprocess.run(
        ["nix-env", "-qaP", "--no-name", "-f", "."],
        stdout=subprocess.PIPE,
        check=True).stdout.decode("us-ascii").split("\n")

    print("Finding upgrades...")
    for attrPath in sorted(pkgs):
        attrPath = attrPath.strip()
        if attrPath:
            print(f"{attrPath}")
            try:
                url = json.loads(subprocess.run(
                    ["nix", "--extra-experimental-features", "nix-command", "eval", "--json", "-f", ".", attrPath + ".src.url"],
                    stdout=subprocess.PIPE,
                    check=True).stdout)
            except subprocess.CalledProcessError:
                url = None
            if url:
                if m := gh_url_re.match(url):
                    owner = m.group(1)
                    repo = m.group(2)
                    rev = m.group(3)
                    latest = latest_release(owner, repo)
                    if latest:
                        if latest != rev:
                            print(f"  {owner}/{repo}@{rev} ==> {latest}")
                        else:
                            print("  OK")
                    else:
                        print("  [SKIPPED: no GitHub releases]")
                else:
                    print("  [SKIPPED: not a github.com URL]")
            else:
                print("  [SKIPPED: no source URL]")

if __name__ == "__main__":
    run()
