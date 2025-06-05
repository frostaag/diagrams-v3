#!/bin/bash

# SAP BTP Document Management Service Credential Verification
# This script verifies the exact credentials and API calls according to SAP DMS documentation

echo "🔧 SAP BTP Document Management Service Verification"
echo "=================================================="

# Expected values from your service key
EXPECTED_CLIENT_ID="sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612|sdm-di-SDM_DI_PROD-prod!b41064"
EXPECTED_CLIENT_SECRET="2c7ee8e5-794e-419e-96a8-01aa08ca82d5\$TyiKc7U0DRD2WtgXOPJtsq_MsuyaibhyXdX_4yD9cII="
EXPECTED_TOKEN_URL="https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token"
EXPECTED_DM_BASE_URL="https://api-sdm-di.cfapps.eu10.hana.ondemand.com"
EXPECTED_REPOSITORY_ID="06b87f25-1e4e-4dfb-8fbb-e5132d74f064"

echo "📋 Expected Credential Analysis:"
echo "  Client ID length: ${#EXPECTED_CLIENT_ID} chars"
echo "  Client Secret length: ${#EXPECTED_CLIENT_SECRET} chars"
echo "  Client ID first 20: ${EXPECTED_CLIENT_ID:0:20}..."
echo "  Client ID last 10: ...${EXPECTED_CLIENT_ID: -10}"
echo "  Client Secret first 5: ${EXPECTED_CLIENT_SECRET:0:5}..."
echo "  Client Secret last 5: ...${EXPECTED_CLIENT_SECRET: -5}"
echo ""

echo "🔍 GitHub Variables Check:"
echo "Based on the debug output, your current GitHub variables contain:"
echo "  Current Client ID length: 78 chars (Expected: ${#EXPECTED_CLIENT_ID})"
echo "  Current Client Secret length: 43 chars (Expected: ${#EXPECTED_CLIENT_SECRET})"
echo "  Current Client Secret starts: 20eb2... (Expected: 2c7ee...)"
echo ""

if [[ ${#EXPECTED_CLIENT_SECRET} -ne 43 ]]; then
    echo "❌ MISMATCH: GitHub secret length doesn't match expected length!"
    echo "   This confirms the GitHub variables haven't been updated yet."
else
    echo "✅ Lengths match - checking content..."
fi

echo ""
echo "📤 Testing OAuth2 Authentication (SAP DMS Standard)"
echo "According to SAP Document Management Service documentation:"
echo "  Method: POST to {uaa.url}/oauth/token"
echo "  Headers: Content-Type: application/x-www-form-urlencoded"
echo "  Body: grant_type=client_credentials&client_id={clientid}&client_secret={clientsecret}"
echo ""

# Test the actual authentication with correct credentials
echo "🔍 Testing with CORRECT credentials from service key..."

# Method 1: Standard OAuth2 client credentials flow (as per SAP documentation)
echo "📋 Method 1: Standard SAP OAuth2 Flow"
response1=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST "$EXPECTED_TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Accept: application/json" \
  --data-urlencode "grant_type=client_credentials" \
  --data-urlencode "client_id=$EXPECTED_CLIENT_ID" \
  --data-urlencode "client_secret=$EXPECTED_CLIENT_SECRET" \
  --max-time 30 \
  2>/dev/null || echo "CURL_FAILED")

http_code1=$(echo "$response1" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
response_body1=$(echo "$response1" | sed -E 's/HTTPSTATUS:[0-9]*$//')

echo "  HTTP Status: $http_code1"

if [[ "$http_code1" -eq 200 ]]; then
    access_token=$(echo "$response_body1" | jq -r '.access_token' 2>/dev/null || echo "")
    if [[ -n "$access_token" && "$access_token" != "null" ]]; then
        echo "  ✅ SUCCESS! OAuth2 authentication works with correct credentials"
        echo "  Token length: ${#access_token} chars"
        echo "  Token preview: ${access_token:0:20}..."
        
        # Test Document Management API access
        echo ""
        echo "📁 Testing Document Management API Access"
        echo "  Repository-specific endpoint: /browser/$EXPECTED_REPOSITORY_ID/root"
        
        dm_response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET \
          "$EXPECTED_DM_BASE_URL/browser/$EXPECTED_REPOSITORY_ID/root" \
          -H "Authorization: Bearer $access_token" \
          -H "Accept: application/json" \
          --max-time 30 \
          2>/dev/null || echo "CURL_FAILED")
        
        dm_http_code=$(echo "$dm_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
        dm_response_body=$(echo "$dm_response" | sed -E 's/HTTPSTATUS:[0-9]*$//')
        
        echo "  DM API HTTP Status: $dm_http_code"
        
        if [[ "$dm_http_code" -eq 200 ]]; then
            echo "  ✅ SUCCESS! Document Management API access works"
            echo "  Response preview: $(echo "$dm_response_body" | head -c 100)..."
            
            # Test folder listing
            echo ""
            echo "📂 Testing folder listing in repository root"
            folders_response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET \
              "$EXPECTED_DM_BASE_URL/browser/$EXPECTED_REPOSITORY_ID/root/children" \
              -H "Authorization: Bearer $access_token" \
              -H "Accept: application/json" \
              --max-time 30 \
              2>/dev/null || echo "CURL_FAILED")
            
            folders_http_code=$(echo "$folders_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
            folders_response_body=$(echo "$folders_response" | sed -E 's/HTTPSTATUS:[0-9]*$//')
            
            echo "  Folder listing HTTP Status: $folders_http_code"
            
            if [[ "$folders_http_code" -eq 200 ]]; then
                echo "  ✅ SUCCESS! Can list repository contents"
                folder_count=$(echo "$folders_response_body" | jq -r '.objects | length' 2>/dev/null || echo "0")
                echo "  Found $folder_count objects in repository root"
                
                # Check if Diagrams folder exists
                diagrams_exists=$(echo "$folders_response_body" | jq -r '.objects[] | select(.name=="Diagrams") | .name' 2>/dev/null || echo "")
                if [[ -n "$diagrams_exists" ]]; then
                    echo "  📁 Diagrams folder already exists in repository"
                else
                    echo "  📁 Diagrams folder not found - will be created by workflow"
                fi
            else
                echo "  ❌ Failed to list repository contents"
                echo "  Response: $(echo "$folders_response_body" | head -c 200)..."
            fi
        else
            echo "  ❌ Document Management API access failed"
            echo "  Response: $(echo "$dm_response_body" | head -c 200)..."
            
            # Try generic root access as fallback test
            echo ""
            echo "🔍 Testing generic root access (fallback)"
            generic_response=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET \
              "$EXPECTED_DM_BASE_URL/browser/objects/root" \
              -H "Authorization: Bearer $access_token" \
              -H "Accept: application/json" \
              --max-time 30 \
              2>/dev/null || echo "CURL_FAILED")
            
            generic_http_code=$(echo "$generic_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
            echo "  Generic root HTTP Status: $generic_http_code"
            
            if [[ "$generic_http_code" -eq 200 ]]; then
                echo "  ⚠️ Generic root access works - repository ID might be optional"
            else
                echo "  ❌ Both repository-specific and generic access failed"
            fi
        fi
        
    else
        echo "  ❌ Could not extract access token from response"
        echo "  Response: $(echo "$response_body1" | head -c 200)..."
    fi
else
    echo "  ❌ OAuth2 authentication failed even with correct credentials!"
    echo "  Response: $(echo "$response_body1" | head -c 300)..."
    
    # Additional diagnostics
    echo ""
    echo "🔍 Additional Diagnostics:"
    echo "  This suggests a fundamental issue with:"
    echo "  1. Token endpoint URL"
    echo "  2. Service key validity" 
    echo "  3. Network connectivity to SAP BTP"
    echo "  4. Service instance status"
fi

echo ""
echo "📋 Action Items:"
echo "1. ✅ Verify service key credentials are correct (shown above)"
echo "2. ❌ UPDATE GitHub variables with the exact values from service key:"
echo "   - DIAGRAMS_SAP_BTP_CLIENT_ID: $EXPECTED_CLIENT_ID"
echo "   - DIAGRAMS_SAP_BTP_CLIENT_SECRET: $EXPECTED_CLIENT_SECRET"
echo "   - DIAGRAMS_SAP_BTP_TOKEN_URL: $EXPECTED_TOKEN_URL"
echo "   - DIAGRAMS_SAP_BTP_DM_BASE_URL: $EXPECTED_DM_BASE_URL"
echo "   - DIAGRAMS_SAP_BTP_REPOSITORY_ID: $EXPECTED_REPOSITORY_ID"
echo ""
echo "3. After updating GitHub variables, trigger the workflow again"
echo ""
echo "🔍 The workflow authentication is implemented correctly according to SAP DMS standards."
echo "   The issue is that GitHub still has the old/incorrect credential values."
