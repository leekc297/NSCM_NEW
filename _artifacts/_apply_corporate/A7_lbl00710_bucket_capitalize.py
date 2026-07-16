#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
A7_lbl00710_bucket_capitalize.py — LBL00710 'bucket' → 'Bucket' (3 lang, 멱등)
2026-07-13 사용자 요청 (SCP0013 Bucket 라벨 대문자화 — 키 재사용 확정, DMF0003 공유 라벨 동반 통일).
FE 짝: locales {KO,EN,CN}.json + SCP0013/DMF0003 fallback '_Bucket'.
실행: python A7_lbl00710_bucket_capitalize.py --apply   (없으면 dry-run)
"""
import sys

import oracledb

APPLY = "--apply" in sys.argv


def connect():
    last = None
    for kw in (dict(service_name="OCGSCMD_P01"), dict(sid="ESSCMD")):
        try:
            dsn = oracledb.makedsn(host="121.162.245.167", port=2521, **kw)
            return oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn=dsn)
        except Exception as e:
            last = e
    raise last


conn = connect()
cur = conn.cursor()

cur.execute("SELECT LANG_CD, MSG_NM, MSG_DESC FROM SCM_ADM_MSG_M WHERE MSG_ID='LBL00710' ORDER BY LANG_CD")
rows = cur.fetchall()
print("before:", rows)

target = [r for r in rows if r[1] == "bucket"]
print(f"교정 대상: {len(target)}행 ('bucket' → 'Bucket')")

if APPLY and target:
    cur.execute("""UPDATE SCM_ADM_MSG_M
        SET MSG_NM='Bucket',
            MSG_DESC=CASE WHEN MSG_DESC='bucket' THEN 'Bucket' ELSE MSG_DESC END,
            LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
      WHERE MSG_ID='LBL00710' AND MSG_NM='bucket'""")
    print("updated:", cur.rowcount)
    conn.commit()
    cur.execute("SELECT LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID='LBL00710' ORDER BY LANG_CD")
    print("after:", cur.fetchall())
    print("COMMIT 완료")
else:
    conn.rollback()
    print("dry-run — 변경 없음. 적용: --apply")

cur.close()
conn.close()
