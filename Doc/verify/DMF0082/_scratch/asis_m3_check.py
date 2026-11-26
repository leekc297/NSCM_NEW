# -*- coding: utf-8 -*-
"""AS-IS MSSQL 읽기 전용: DMF0082_GET_MAIN_DATA 두 번째 결과셋(MONTH_NAME) 원문 + 사업부 분기 여부 + 실제 값"""
import sys, os, re, time
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
from dbconn import connect, describe
print(describe('asis'))
cx = connect('asis'); cur = cx.cursor()
t = time.time()
cur.execute("SELECT o.modify_date, m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id WHERE o.name = 'DMF0082_GET_MAIN_DATA'")
row = cur.fetchone(); print('modify_date', row[0], f'({time.time()-t:.1f}s)')
d = row[1].replace('\r\n', '\n')
lines = d.split('\n')
for i, l in enumerate(lines):
    if 'MONTH_NAME' in l or 'PJ2025-50188' in l and 'M+' in l:
        lo = max(0, i - 6); hi = min(len(lines), i + 4)
        print(f'--- L{i+1}'); print('\n'.join(f'{j+1}: {lines[j]}' for j in range(lo, hi)))
print('81_UC 문자열 건수', d.count('81_UC'), '· DATEADD(MONTH,3 건수', len(re.findall(r'DATEADD\s*\(\s*MONTH\s*,\s*3', d, re.I)))
t = time.time()
cur.execute("SELECT TOP 1 MONTH_NAME, ISO_WEEK FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMM = FORMAT(DATEADD(MONTH,3,GETDATE()),'yyyyMM') ORDER BY BASIS_YYYYMMDD")
print('실제 MONTH_NAME', cur.fetchone(), 'GETDATE 기준', f'({time.time()-t:.1f}s)')
cur.execute("SELECT GETDATE()"); print('AS-IS DB 시각', cur.fetchone()[0])
