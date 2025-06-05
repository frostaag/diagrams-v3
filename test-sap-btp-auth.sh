#!/bin/bash

# Test SAP BTP Authentication Script
# This script tests the SAP BTP OAuth authentication using the correct service key values

echo "🔧 Testing SAP BTP Authentication"
echo "================================="

# Correct values from your service key
SAP_CLIENT_ID="sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612|sdm-di-SDM_DI_PROD-prod!b41064"
SAP_CLIENT_SECRET="2c7ee8e5-794e-419e-96a8-01aa08ca82d5\$TyiKc7U0DRD2WtgXOPJtsq_MsuyaibhyXdX_4yD9cII="
SAP_TOKEN_URL="https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token"
SAP_DM_BASE_URL="https://api-sdm-di.cfapps.eu10.hana.ondemand.com"

echo "🔍 Configuration:"
echo "  Token URL: $SAP_TOKEN_URL"
echo "  Client ID: ${SAP_CLIENT_ID:0:30}..."
echo "  Client Secret: ${SAP_CLIENT_SECRET:0:10}..."
echo "  DM Base URL: $SAP_DM_BASE_URL"
echo ""

echo "📤 Testing OAuth authentication..."

# Method 1: URL encoded form data
echo "🔍 Method 1: URL encoded form data"
response1=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST "$SAP_TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  --data-urlencode "grant_type=client_credentials" \
  --data-urlencode "client_id=$SAP_CLIENT_ID" \
  --data-urlencode "client_secret=$SAP_CLIENT_SECRET" \
  --max-time 30 \
  2>/dev/null || echo "CURL_FAILED")

http_code1=$(echo "$response1" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
response_body1=$(echo "$response1" | sed -E 's/HTTPSTATUS:[0-9]*$//')

echo "  HTTP Status: $http_code1"

if [[ "$http_code1" -eq 200 ]]; then
  access_token=$(echo "$response_body1" | jq -r '.access_token' 2>/dev/null || echo "")
  if [[ -n "$access_token" && "$access_token" != "null" ]]; then
    echo "  ✅ SUCCESS! Access token obtained (${#access_token} chars)"
    echo "  Token preview: ${access_token:0:20}..."
    
    # Test a simple API call with the token
    echo ""
    echo "📋 Testing API access with token..."
    api_response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET \
      "$SAP_DM_BASE_URL/browser/objects/root" \
      -H "Authorization: Bearer $access_token" \
      -H "Accept: application/json" \
      --max-time 30 \
      2>/dev/null || echo "CURL_FAILED")
    
    api_http_code=$(echo "$api_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    api_response_body=$(echo "$api_response" | sed -E 's/HTTPSTATUS:[0-9]*$//')
    
    echo "  API Test HTTP Status: $api_http_code"
    
    if [[ "$api_http_code" -eq 200 ]]; then
      echo "  ✅ API access successful!"
      echo "  Response preview: $(echo "$api_response_body" | head -c 100)..."
    else
      echo "  ❌ API access failed"
      echo "  Response: $(echo "$api_response_body" | head -c 200)..."
    fi
    
    exit 0
  else
    echo "  ❌ Could not extract access token"
    echo "  Response: $(echo "$response_body1" | head -c 200)..."
  fi
else
  echo "  ❌ Authentication failed"
  echo "  Response: $(echo "$response_body1" | head -c 300)..."
fi

# Method 2: Basic Authentication (if Method 1 fails)
if [[ "$http_code1" -ne 200 ]]; then
  echo ""
  echo "🔍 Method 2: Basic Authentication"
  
  basic_auth=$(echo -n "${SAP_CLIENT_ID}:${SAP_CLIENT_SECRET}" | base64 -w 0 2>/dev/null || echo -n "${SAP_CLIENT_ID}:${SAP_CLIENT_SECRET}" | base64)
  
  response2=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST "$SAP_TOKEN_URL" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -H "Accept: application/json" \
    -H "Authorization: Basic $basic_auth" \
    -d "grant_type=client_credentials" \
    --max-time 30 \
    2>/dev/null || echo "CURL_FAILED")
  
  http_code2=$(echo "$response2" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
  response_body2=$(echo "$response2" | sed -E 's/HTTPSTATUS:[0-9]*$//')
  
  echo "  HTTP Status: $http_code2"
  
  if [[ "$http_code2" -eq 200 ]]; then
    access_token=$(echo "$response_body2" | jq -r '.access_token' 2>/dev/null || echo "")
    if [[ -n "$access_token" && "$access_token" != "null" ]]; then
      echo "  ✅ SUCCESS! Access token obtained (${#access_token} chars)"
      echo "  Token preview: ${access_token:0:20}..."
      exit 0
    else
      echo "  ❌ Could not extract access token"
      echo "  Response: $(echo "$response_body2" | head -c 200)..."
    fi
  else
    echo "  ❌ Authentication failed"
    echo "  Response: $(echo "$response_body2" | head -c 300)..."
  fi
fi

echo ""
echo "❌ All authentication methods failed"
echo ""
echo "💡 Next steps:"
echo "1. Verify the service key values are exactly as provided"
echo "2. Check if the SAP BTP service is accessible"
echo "3. Ensure the OAuth client has the necessary permissions"
echo "4. Update the GitHub variables with these exact values"

exit 1
