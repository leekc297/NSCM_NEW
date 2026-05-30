# Fix multi-line CSV records for 19 failed tables, then reload via sqlldr
param(
  [string]$DataDir = "C:\TRANFILE\DB\DATA",
  [string]$FixedDir = "C:\Projects\NSCM\_artifacts\local-docker-oracle\csv_fixed"
)
$ErrorActionPreference = "Continue"
if (-not (Test-Path $FixedDir)) { New-Item -ItemType Directory -Path $FixedDir -Force | Out-Null }

# Table -> CSV file basename
$map = @{
  'SCM_ADM_USER_M'                    = 'SCM_ADM_USER_M_202605261612.csv'
  'SCM_ADM_MSG_M'                     = 'SCM_ADM_MSG_M_202605261612.csv'
  'SCM_ADM_DQ_EXECUTE_H'              = 'SCM_ADM_DQ_EXECUTE_H_202605261610.csv'
  'SCM_ADM_LOOKUP_MASTER_DETAIL'      = 'SCM_ADM_LOOKUP_MASTER_DETAIL_202605261612.csv'
  'SCM_ADM_LOOKUP_MASTER_DETAIL_BAK'  = 'SCM_ADM_LOOKUP_MASTER_DETAIL_BAK_202605261612.csv'
  'SCM_ADM_NOTICE_CONTENT_MASTER'     = 'SCM_ADM_NOTICE_CONTENT_MASTER_202605261612.csv'
  'SCM_ADM_RECIPIENT_MESSAGE'         = 'SCM_ADM_RECIPIENT_MESSAGE_202605261612.csv'
  'SCM_ADM_RECIPIENT_MESSAGE_H'       = 'SCM_ADM_RECIPIENT_MESSAGE_H_202605261612.csv'
  'SCM_ADM_SMS_MAIL_SEND_LOG'         = 'SCM_ADM_SMS_MAIL_SEND_LOG_202605261612.csv'
  'SCM_COM_ATCH_FILE_M'               = 'SCM_COM_ATCH_FILE_M_202605261612.csv'
  'SCM_MST_CITY'                      = 'SCM_MST_CITY_202605261658.csv'
  'SCM_MST_PROJECT'                   = 'SCM_MST_PROJECT_202605261658.csv'
  'SCM_MST_SHEET_COLUMNS'             = 'SCM_MST_SHEET_COLUMNS_202605261658.csv'
  'SCM_MST_SITE_CUSTOMER'             = 'SCM_MST_SITE_CUSTOMER_202605261658.csv'
  'SCM_MST_SITE_ITEM'                 = 'SCM_MST_SITE_ITEM_202605261658.csv'
  'SCM_MST_SITE_ITEM_PRIORITY'        = 'SCM_MST_SITE_ITEM_PRIORITY_202605261658.csv'
  'SCM_MST_SSO_USER_INFO'             = 'SCM_MST_SSO_USER_INFO_202605261658.csv'
  'SCM_SYS_LOG_BATCH'                 = 'SCM_SYS_LOG_BATCH_202605261658.csv'
}

# Use the proven fix_multiline_csv.ps1 to preprocess each file in place
$fixScript = "C:\Projects\NSCM\_artifacts\local-docker-oracle\fix_multiline_csv.ps1"

foreach ($table in $map.Keys) {
  $csvName = $map[$table]
  $src = Join-Path $DataDir $csvName
  if (-not (Test-Path $src)) { Write-Output "  MISSING: $csvName"; continue }
  $dst = Join-Path $FixedDir $csvName
  & $fixScript -Src $src -Dst $dst
  # Upload fixed CSV to container under the ORIGINAL filename (so existing ctl mapping works)
  docker cp $dst "nscm-oracle:/tmp/csv/$csvName" 2>$null | Out-Null
}
Write-Output "All CSVs processed + uploaded"
