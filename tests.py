#!/usr/bin/env python3

import requests

# base URL of service
base_url = "https://172.17.0.2:8080/api/v1"

# user credentials
test_user = {
    "username": "testuser",
    "password": "testpass"
}

headers = {
    "Content-Type": "application/json"
}

# Test the signup endpoint
def test_signup():
    response = requests.post(f"{base_url}/signup", json=test_user, headers=headers, verify=False)
    print("Signup Status:", response.status_code)
    if response.status_code == 200:
        print("Signup Response:", response.json())
    else:
        print("Signup Error:", response.text)

# Test the login endpoint
def test_login():
    response = requests.post(f"{base_url}/login", json=test_user, headers=headers, verify=False)
    print("Login Status:", response.status_code)
    if response.status_code == 200:
        print("Login Response:", response.json())
        return response.json().get("token")
    else:
        print("Login Error:", response.text)
        return None

# Test file creation
def test_create_file(token, username, doc_id, content):
    response = requests.post(f"{base_url}/{username}/{doc_id}", headers={"Authorization": token}, data=content, verify=False)
    print("Create File Status:", response.status_code)
    print("Create File Response:", response.json())

# Test getting all user docs
def test_get_all_user_docs(token, username):
    response = requests.get(f"{base_url}/{username}/_all_docs", headers={"Authorization": token}, verify=False)
    print("Get All User Docs Status:", response.status_code)
    print("Get All User Docs Response:", response.json())

# Run tests
test_signup()
token = test_login()
if token:
    test_create_file(token.access_token, test_user["username"], "doc1", "Sample content for doc1")
    test_get_all_user_docs(token, test_user["username"])
else:
    print("Login failed, cannot test file operations without a token.")
