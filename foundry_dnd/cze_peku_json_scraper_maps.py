import requests
from bs4 import BeautifulSoup

# Function to get specific JSON links from a website
def get_json_links(url, cookies):
    # Define headers to mimic a regular browser
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    
    session = requests.Session()
    
    session.headers.update(headers)
    session.cookies.update(cookies)
    
    response = session.get(url)
    
    if response.status_code != 200:
        print(f"Failed to retrieve page: {response.status_code}")
        return []
    print(f'response code: {response.status_code}')
    
    soup = BeautifulSoup(response.content, 'html.parser')
    
    specific_div = soup.find('div', class_='sc-cfnzm4-0 daxSFj')
    
    if not specific_div:
        print("Div with the specified class not found.")
        return []
    
    # Find all <a> tags with href attribute containing "dropbox.com" and text "JSON"
    links = []
    for a_tag in specific_div.find_all('a', href=True):
        if "dropbox.com" in a_tag['href'] and a_tag.text.strip() == "JSON":
            links.append(a_tag['href'])
    
    return links

# URL of the website to extract links from
url = 'https://www.patreon.com/posts/foundry-vtt-post-57634400'

# Replace with your actual cookies
cookies = {
    'session_id': 'TO BE FILLED',
}

# Get the links
links = get_json_links(url, cookies)


# Write the links to a file
with open('links.txt', 'w') as file:
    for link in links:
        file.write(f"{link}\n")
