@echo off
cd /d C:\Projects\NSCM
echo [%date% %time%] claude fill DMF0052 start > C:\Projects\NSCM\Doc\gen\harness-claude-log.txt
claude -p "Read tools/Harness/prompts/new_screen.md and follow it for screen DMF0052. Skeleton: nscm-fe/features/demand/src/pages/edi-summary. Notes: Doc/gen/DMF0052/GEN_NOTES.md. Fill only the spots marked TODO, then update __asis-mapping__.md statuses and summarize remaining items with reasons in Korean." --allowedTools "Read,Edit,Write,Glob,Grep,Bash(node *),Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *)" --output-format text >> C:\Projects\NSCM\Doc\gen\harness-claude-log.txt 2>&1
echo [%date% %time%] exit %ERRORLEVEL% >> C:\Projects\NSCM\Doc\gen\harness-claude-log.txt
