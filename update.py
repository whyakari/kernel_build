import os
import requests
import subprocess

repo_url = "https://github.com/ZyCromerZ/Clang"
release_url = f"{repo_url}/releases/latest"
date_file_path = "date_.txt"

def get_tag_release():
    response = requests.get(release_url)
    latest_release_tag = response.url.split("/")[-1]
    return latest_release_tag

def read_date_from_file():
    if os.path.exists(date_file_path):
        with open(date_file_path, "r") as f:
            return f.read().strip()
    else:
        return ""

def write_date_to_file(date):
    with open(date_file_path, "w") as f:
        f.write(date)

latest_release_tag = get_tag_release()[10:].replace("-release", "")
local_date = read_date_from_file()

if latest_release_tag != local_date:
    print("New release detected. Updating date and committing.")
    write_date_to_file(latest_release_tag)

    subprocess.run(["git", "config", "--global", "user.email", "barryofc11@gmail.com"])
    subprocess.run(["git", "config", "--global", "user.name", "Akari"])
    subprocess.run(["git", "add", date_file_path])
    subprocess.run(["git", "commit", "-m", f"Update clang date to {latest_release_tag}"])
    subprocess.run(["git", "push"])
else:
    print("No new release detected.")

