# -*- coding: utf-8 -*-
"""DMF0003 GTT 리네임 산출물 생성 (2026-07-23, 사용자 지시: 명칭에 DMF0003 포함 + SP 사용부 전환)
치환 룰 (전역 prefix, PKG_DMF0003 전용 39종 — GT_GGET_SPLIT_* 구명은 PKG_DMF0005 가 계속 사용):
  GT_GGET_   -> GT_DMF0003_
  GT_MFCP_   -> GT_DMF0003_MFCP_
  GT_SAVEPK_ -> GT_DMF0003_SAVEPK_
산출:
  00B_GTT_DDL_DMF0003_RENAMED.sql  (클라우드 패키지 00_GTT_DDL 전체에 치환 적용 — 미존재분 생성/기존재 -955 skip)
  02_PKG_DMF0003_body_renamed.sql  (사내 라이브 body 덤프 + 치환 + 마커)
"""
import io, os, re, oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
PKG_DDL_SRC = r"C:\Projects\NSCM\_artifacts\_deploy_packages\CLOUD_6SCREENS_20260722_1002\DMF0003\sp\00_GTT_DDL_DMF0003.sql"

REPL = [("GT_GGET_", "GT_DMF0003_"), ("GT_MFCP_", "GT_DMF0003_MFCP_"), ("GT_SAVEPK_", "GT_DMF0003_SAVEPK_")]

def apply(text):
    counts = {}
    for a, b in REPL:
        counts[a] = text.count(a)
        text = text.replace(a, b)
    return text, counts

# 1) GTT DDL
with io.open(PKG_DDL_SRC, "r", encoding="utf-8") as f:
    ddl = f.read()
ddl2, c1 = apply(ddl)
hdr = ("-- [DMF0003 GTT RENAME 20260723] GT_GGET_/GT_MFCP_/GT_SAVEPK_ -> GT_DMF0003_* (DROP 불필요 — ORA-14452 회피)\n"
       "-- 원본: CLOUD_6SCREENS_20260722_1002/DMF0003/sp/00_GTT_DDL_DMF0003.sql (멱등 -955 skip 유지)\n"
       "-- 비대상 테이블(GT_ANLO_*/GT_DMF3_* 등)은 원명 그대로 포함 — 클라우드에서 DROP 후 미재생성분 복구 겸용\n\n")
with io.open(os.path.join(BASE, "00B_GTT_DDL_DMF0003_RENAMED.sql"), "w", encoding="utf-8", newline="") as f:
    f.write(hdr + ddl2)
print("DDL 치환:", c1)

# 2) 사내 라이브 body 덤프 + 치환
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
cur.execute("SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY','PKG_DMF0003','SCM_MGR') FROM DUAL")
body = cur.fetchone()[0].read()
with io.open(os.path.join(BASE, "_backup_PKG_DMF0003_body_original_20260723.sql"), "w", encoding="utf-8", newline="") as f:
    f.write(body)
body2, c2 = apply(body)
marker = "-- [DMF0003 GTT RENAME 20260723] GT_GGET_/GT_MFCP_/GT_SAVEPK_ -> GT_DMF0003_* (39 GTT)\n"
# 마커는 body 첫 줄 주석으로 (CREATE OR REPLACE 앞은 불가 — 첫 IS 뒤에 넣기엔 위치 의존 → 파일 선두 주석은 sqlplus OK, execute로는 포함됨)
body2 = body2.replace(" IS\n", " IS\n" + marker, 1)
with io.open(os.path.join(BASE, "02_PKG_DMF0003_body_renamed.sql"), "w", encoding="utf-8", newline="") as f:
    f.write(body2)
print("body 치환:", c2, "| 원본 lines:", body.count(chr(10)))
assert c2["GT_GGET_"] >= 300, "GT_GGET_ 치환 수 이상"
print("OK")
