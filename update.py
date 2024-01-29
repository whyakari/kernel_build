import os
import requests
import subprocess

repo_url = "https://github.com/ZyCromerZ/Clang"
release_url = f"{repo_url}/releases/latest"

def get_tag_release():
    response = requests.get(release_url)
    latest_release_tag = response.url.split("/")[-1]
    return latest_release_tag

tag = get_tag_release()[10:].replace("-release", "")
print(tag)
