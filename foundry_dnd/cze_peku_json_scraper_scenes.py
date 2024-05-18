from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import time

# Function to get specific JSON links from a website
def get_json_links(url, cookies):
    # Set up Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Run headless Chrome
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")

    # Set up the Chrome driver
    driver_path = '/usr/local/bin/chromedriver'  # Adjust this path if needed
    driver = webdriver.Chrome(service=Service(driver_path), options=chrome_options)

    print("Navigating to the URL...")
    # Navigate to the URL
    driver.get(url)

    # Add cookies to the browser session
    print("Adding cookies...")
    for name, value in cookies.items():
        driver.add_cookie({'name': name, 'value': value, 'domain': '.patreon.com'})

    # Refresh the page to ensure cookies are applied
    print("Refreshing the page...")
    driver.refresh()

    # Wait for the page to load
    print("Waiting for the page to load...")
    WebDriverWait(driver, 20).until(
        EC.presence_of_element_located((By.CLASS_NAME, 'sc-1cq1psq-0'))
    )

    # Click the "Show more" button if it exists
    try:
        print("Checking for 'Show more' button...")
        show_more_button = WebDriverWait(driver, 10).until(
            EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Show more')]"))
        )
        show_more_button.click()
        print("'Show more' button clicked.")
        time.sleep(2)  # Allow time for the content to load
    except Exception as e:
        print("No 'Show more' button found or an error occurred:", e)

    # Scroll down to load more content if necessary
    print("Scrolling down the page...")
    body = driver.find_element(By.TAG_NAME, "body")
    for _ in range(30):  # Increase the range for more scrolling
        body.send_keys(Keys.PAGE_DOWN)
        time.sleep(1)  # Shorter wait to allow more scrolling

    # Get the page source and close the driver
    print("Getting page source...")
    page_source = driver.page_source
    driver.quit()

    # Parse the HTML content with BeautifulSoup
    print("Parsing HTML content...")
    soup = BeautifulSoup(page_source, 'html.parser')

    # Find all <div> elements with the class "sc-cfnzm4-0 daxSFj"
    print("Finding all specific divs...")
    divs = soup.find_all('div', class_='sc-cfnzm4-0 daxSFj')

    if not divs:
        print("No divs with the specified class found.")
        return []

    # Find all <a> tags with text "JSON" and containing "dropbox.com" in the href attribute within <p> tags in all divs
    print("Finding JSON links...")
    links = []
    for div in divs:
        for p_tag in div.find_all('p'):
            for a_tag in p_tag.find_all('a', href=True):
                if "dropbox.com" in a_tag['href'] and "JSON" in a_tag.text:
                    links.append(a_tag['href'])

    print(f"Found {len(links)} JSON links.")
    return links

# URL of the website to extract links from
url = 'https://www.patreon.com/collection/427286'

# Replace with your actual cookies
cookies = {
    'session_id': 'TO BE FILLED',
    # Add any other cookies that are necessary for authentication
}

# Get the links
print("Getting the links...")
links = get_json_links(url, cookies)

# Write the links to a file
print("Writing links to a file...")
with open('links.txt', 'w') as file:
    for i, link in enumerate(links, start=1):
        file.write(f"{link}\n")
print("Done.")

