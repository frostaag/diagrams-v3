# SAP BTP Authentication Fix Guide

## Issue Analysis

The debug output shows SAP BTP authentication is failing with HTTP 401 "Bad credentials". After analyzing your service key, the issue is that the GitHub variables are not set with the complete, correct values.

## Current vs Correct Configuration

### Current (Incorrect) Configuration:
- Client ID: `sb-a89eef4d-1cc2-417...` (truncated)
- Token URL: `https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token`

### Correct Configuration from Service Key:
- Client ID: `sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612|sdm-di-SDM_DI_PROD-prod!b41064`
- Client Secret: `2c7ee8e5-794e-419e-96a8-01aa08ca82d5$TyiKc7U0DRD2WtgXOPJtsq_MsuyaibhyXdX_4yD9cII=`
- Token URL: `https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token` ✅ (correct)
- DM Base URL: `https://api-sdm-di.cfapps.eu10.hana.ondemand.com/`

## GitHub Variables to Update

Go to your GitHub repository → Settings → Secrets and variables → Actions

### Organization Variables:

1. **DIAGRAMS_SAP_BTP_CLIENT_ID**
   ```
   sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612|sdm-di-SDM_DI_PROD-prod!b41064
   ```

2. **DIAGRAMS_SAP_BTP_TOKEN_URL** (already correct)
   ```
   https://frosta-apps-dev.authentication.eu10.hana.ondemand.com/oauth/token
   ```

3. **DIAGRAMS_SAP_BTP_DM_BASE_URL**
   ```
   https://api-sdm-di.cfapps.eu10.hana.ondemand.com
   ```

4. **DIAGRAMS_SAP_BTP_REPOSITORY_ID** (IMPORTANT - NEW!)
   ```
   06b87f25-1e4e-4dfb-8fbb-e5132d74f064
   ```

And this **Secret**:

5. **DIAGRAMS_SAP_BTP_CLIENT_SECRET**
   ```
   2c7ee8e5-794e-419e-96a8-01aa08ca82d5$TyiKc7U0DRD2WtgXOPJtsq_MsuyaibhyXdX_4yD9cII=
   ```

## Key Issues Fixed

1. **Complete Client ID**: The current one is truncated. The full client ID includes the `!b523612|sdm-di-SDM_DI_PROD-prod!b41064` part which is essential for authentication.

2. **Correct Client Secret**: Make sure you're using the exact value from the service key, including the `$` and `=` characters.

3. **DM Base URL**: Remove the trailing slash - use `https://api-sdm-di.cfapps.eu10.hana.ondemand.com` instead of `https://api-sdm-di.cfapps.eu10.hana.ondemand.com/`

4. **Repository ID**: This is crucial! The workflow needs your specific repository ID (`06b87f25-1e4e-4dfb-8fbb-e5132d74f064`) to construct the correct API paths. Without this, it tries to use the generic `/browser/objects/root/` which doesn't work with your setup.

## Verification

Once you update these GitHub variables/secrets:
1. The authentication should work correctly
2. The workflow will automatically pick up the new values on the next run
3. You should see "✅ SAP BTP access token obtained successfully" instead of the HTTP 401 error

## Service Key Reference

Your complete service key for reference:
```json
{
  "uri": "https://api-sdm-di.cfapps.eu10.hana.ondemand.com/",
  "uaa": {
    "clientid": "sb-a89eef4d-1cc2-4171-a69a-19fd2b4dbaa9!b523612|sdm-di-SDM_DI_PROD-prod!b41064",
    "clientsecret": "2c7ee8e5-794e-419e-96a8-01aa08ca82d5$TyiKc7U0DRD2WtgXOPJtsq_MsuyaibhyXdX_4yD9cII=",
    "url": "https://frosta-apps-dev.authentication.eu10.hana.ondemand.com"
  }
}
```

The workflow is already properly configured to handle the special characters in the client ID and secret through multiple authentication methods.

## Critical Fix: Repository ID

The main issue was that the workflow was using the wrong API endpoints. Your Postman success shows you need:
- Working URL: `https://api-sdm-di.cfapps.eu10.hana.ondemand.com/browser/06b87f25-1e4e-4dfb-8fbb-e5132d74f064/root`
- Previous URL: `https://api-sdm-di.cfapps.eu10.hana.ondemand.com/browser/objects/root/`

The workflow has been updated to:
1. Use the repository ID when configured: `/browser/{repository_id}/root`
2. Fall back to the generic path when not configured: `/browser/objects/root`
3. Construct upload URLs correctly based on the API structure
