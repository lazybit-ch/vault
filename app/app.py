#!/usr/bin/env python3

import os
import requests
import json

from flask import request, Flask, redirect, url_for
from authlib.integrations.flask_client import OAuth


app = Flask(__name__)
oauth = OAuth(app)

try:
    OIDC_DISCOVERY_URL = os.environ["OIDC_DISCOVERY_URL"]
    OIDC_CLIENT_ID = os.environ["OIDC_CLIENT_ID"]
    OIDC_CLIENT_SECRET = os.environ["OIDC_CLIENT_SECRET"]
except KeyError:
    raise

try:
    response = requests.get(OIDC_DISCOVERY_URL)
    if response.status_code == 200:
        data = json.loads(response.content)
    AUTHORIZATION_ENDPOINT = data["authorization_endpoint"]
    TOKEN_ENDPOINT = data["token_endpoint"]
except requests.exceptions.Timeout:
    print(f"Connection timed out.")
    raise
except requests.exceptions.TooManyRedirects:
    print(f"Too many redirects.")
    raise
except requests.exceptions.RequestException:
    raise

oauth.register(
    "keycloak",
    client_id=OIDC_CLIENT_ID,
    client_secret=OIDC_CLIENT_SECRET,
    authorize_url=AUTHORIZATION_ENDPOINT,
    request_token_url=TOKEN_ENDPOINT,
)

@app.route('/')
def index():
    return 'Hello world!'

@app.route('/login')
def login():
    redirect_uri = url_for('authorize', _external=True)
    return oauth.keycloak.authorize_redirect(redirect_uri)

@app.route('/authorize')
def authorize():
    token = oauth.keycloak.authorize_access_token()
    resp = oauth.keycloak.get('account/verify_credentials.json')
    profile = resp.json()
    return redirect('/')

# @app.route("/login")
# def login():
#     return redirect(AUTHORIZATION_ENDPOINT,code=302)
# 
# @app.route("/auth/callback")
# def custom_callback():
#     print(f"{request}")
#     return "Logged in!"

if __name__ == "__main__":
    app.run()
