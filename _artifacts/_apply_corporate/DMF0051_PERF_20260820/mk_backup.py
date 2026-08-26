import io,sys
sys.stdout=io.TextIOWrapper(sys.stdout.buffer,encoding="utf-8",errors="replace")
raw=open("00_BACKUP_PKG_DMF0051_BODY_raw.sql",encoding="utf-8").read()
assert raw.lstrip().upper().startswith("PACKAGE BODY")
assert raw.rstrip().endswith("END PKG_DMF0051;")
hdr=("-- 00_BACKUP_PKG_DMF0051_BODY.sql — 패치 직전 사내 라이브 원문 (2026-08-21)\n"
     "--   원복용: SQL*Plus 에서 그대로 @실행\n"
     "--   원본 마커: [E20260820-DS2]x1 / [E20260806-00979]x3 / [E20260806-WF]x3 (D51* 신규 마커 없음)\n"
     "SET DEFINE OFF\nSET SQLBLANKLINES ON\n")
out=hdr+"CREATE OR REPLACE "+raw.lstrip("\n")+"/\nSHOW ERRORS\n"
open("00_BACKUP_PKG_DMF0051_BODY.sql","w",encoding="utf-8",newline="\n").write(out)
print("[saved] 00_BACKUP_PKG_DMF0051_BODY.sql",len(out),"bytes")
assert "E20260820-D51" not in out
print("[assert] 백업본에 D51 마커 없음 OK")

