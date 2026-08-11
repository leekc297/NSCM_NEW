#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PUSHED PREDICATE 가 plan 에 어떤 (operation, options) 로 저장되는지 확인 — 내 카운터 버그 규명"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
print("[사고 커서의 실제 저장형태]")
show(*fetch(cur, """SELECT id, operation, options, LENGTH(options) len_opt
                      FROM v$sql_plan WHERE sql_id='5dchxk6z8k7hg'
                       AND (options LIKE '%PUSH%' OR operation LIKE '%PUSH%') ORDER BY id"""))
con.close()
