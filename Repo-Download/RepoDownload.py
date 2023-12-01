import requests
import os
import subprocess

# Replace these with your GitHub credentials and organization name
username = 'AndySaxAtWork'
token = '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'
organization = 'NLA-Media-Access'

# Set the headers for authentication
headers = {
    'Authorization': f'token {token}',
    'Accept': 'application/vnd.github.v3+json'
}

# Define the URL for listing organization repositories
url = f'https://api.github.com/orgs/{organization}/repos?per_page=100'

def clone_repos():
    # Make the initial request to get the list of repositories
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        print(f"Failed to retrieve repositories. Status code: {response.status_code}")
        exit()

    # Create a directory to store the repositories if it doesn't exist
    if not os.path.exists(organization):
        os.makedirs(organization)

    # Iterate through the list of repositories and clone each one
    for repo in response.json():
        repo_name = repo['name']
        repo_url = repo['clone_url']
        repo_dir = os.path.join(organization, repo_name)

        # Check if the repository directory already exists
        if os.path.exists(repo_dir):
            print(f"Repository {repo_name} already exists. Skipping...")
        else:
            print(f"Cloning {repo_name}...")
            subprocess.run(['git', 'clone', repo_url, repo_dir])

    print("All repositories have been cloned.")

if __name__ == "__main__":
    clone_repos()