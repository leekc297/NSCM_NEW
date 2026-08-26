#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0074 Excel Form 0건 정정 — 원장 W34 스냅샷을 마스터 최신 버전에 정합 (사용자 승인 2026-08-23).

## 장애
DMF0074 Excel Form 조회 시 "다운로드할 템플릿 대상 데이터가 없습니다."(MSG01015 / 구 MSG00656).

## 원인 (실측)
`P_DMF0074_GET_METAL_LINK_TEMPLATE` 은 화면에서 고른 버전을 쓰지 않고
`MAX(VERSION_NO) FROM DM_MST_VERSION WHERE DIVISION_ID=:div AND VERSION_TYPE='SP_W'` 로 기준 버전을 정한다.
div 40 의 MAX = `SP_W_20260820_V002` 인데 이 버전은 `DM_PLN_SALES_PLAN_C` 에 **0행**이다
(마스터는 system 배치가 계속 생성 / 원장은 2026-08-17 20:10 이 마지막 적재 — 두 축이 어긋남).
반증 실험: 기준 버전만 `SP_W_20260817_V001`(원장 28,085행)로 바꾸면 조인 체인 최종 **2,703행** 정상.

## 조치 (사용자 선택 = "원장을 마스터에 맞춤" / 범위 = div 40 만)
`DM_PLN_SALES_PLAN_C` 의 div 40 `SP_W_20260817_V001` 행의 VERSION_NO 를 현 MAX `SP_W_20260820_V002` 로 UPDATE.
같은 주(W34: 2026-08-17 월 ~ 08-23 일) 스냅샷이므로 기간 산식(RESULT_TO~PLAN_TO)은 동일 결과가 된다.

## 안전장치
· 대상 테이블 PK 15컬럼에 VERSION_NO 포함 → 타깃 버전에 기존 행이 있으면 ORA-00001. 사전 0행 확인 후에만 진행.
· CTAS 백업 선생성(있으면 중단). · UPDATE 건수 ≠ 사전 실측 SRC 면 ROLLBACK.
· 감사컬럼(LAST_UPDATED_BY/DATE)은 **건드리지 않는다** — AS-IS 스냅샷 원본 보존, 변경 이력은 본 스크립트/백업표가 담당.
· 트리거 0개·비파티션 실측 확인함.

실행: python apply.py        (점검만: python apply.py --dry)
원복: 아래 ROLLBACK SQL 참조 (백업표에서 되돌리거나 VERSION_NO 를 되돌림)
"""
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402
from ora import conn_info  # noqa: E402

DIV = "40"
SRC_VER = "SP_W_20260817_V001"
TGT_VER = "SP_W_20260820_V002"
TBL = "SCM_MGR.DM_PLN_SALES_PLAN_C"
BAK = "SCM_MGR.BAK_DMF0074_SPC_W34_20260823"
DRY = "--dry" in sys.argv

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q1(sql, binds=None):
    cur.execute(sql, binds or {})
    return cur.fetchone()[0]


print("=" * 90)
print(f"DMF0074 W34 버전 정합 — div {DIV} : {SRC_VER} → {TGT_VER}   ({'DRY' if DRY else 'APPLY'})")
print("=" * 90)

# ── [1] 사전 실측 ────────────────────────────────────────────────
src = q1(f"SELECT COUNT(*) FROM {TBL} WHERE DIVISION_ID=:d AND VERSION_NO=:v", {"d": DIV, "v": SRC_VER})
tgt = q1(f"SELECT COUNT(*) FROM {TBL} WHERE DIVISION_ID=:d AND VERSION_NO=:v", {"d": DIV, "v": TGT_VER})
mst = q1("SELECT COUNT(*) FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
         {"d": DIV, "v": TGT_VER})
mx = q1("SELECT MAX(VERSION_NO) FROM SCM_MGR.DM_MST_VERSION WHERE DIVISION_ID=:d AND VERSION_TYPE='SP_W'",
        {"d": DIV})
print(f"[1] 원장 SRC({SRC_VER})   = {src:,}행")
print(f"    원장 TGT({TGT_VER})   = {tgt:,}행   (기대 0 — PK 충돌 방지)")
print(f"    마스터 TGT 등재       = {mst}행 / 마스터 현재 MAX = {mx}")

if src == 0:
    sys.exit("⛔ 중단 — 원장 SRC 0행. 원천이 재적재됐을 수 있음(고정 건수 가정 금지). 재진단 필요.")
if tgt != 0:
    sys.exit(f"⛔ 중단 — 타깃 버전에 이미 {tgt}행 존재. UPDATE 시 PK 충돌(ORA-00001) 위험.")
if mst != 1:
    sys.exit(f"⛔ 중단 — 마스터에 {TGT_VER}({DIV}) 행이 {mst}건. 1건이어야 함.")
if mx != TGT_VER:
    sys.exit(f"⛔ 중단 — 마스터 MAX 가 {mx} 로 바뀜. SP 가 잡는 기준 버전이 달라졌으니 재진단 필요.")

# ── [2] 백업 ────────────────────────────────────────────────────
bak_exists = q1("SELECT COUNT(*) FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t",
                {"t": BAK.split(".")[1]})
if bak_exists:
    sys.exit(f"⛔ 중단 — 백업표 {BAK} 가 이미 존재. 이전 실행분 확인 후 진행할 것.")
if DRY:
    print(f"[2] (dry) 백업표 {BAK} 생성 예정 — {src:,}행")
else:
    cur.execute(f"CREATE TABLE {BAK} AS SELECT * FROM {TBL} "
                f"WHERE DIVISION_ID='{DIV}' AND VERSION_NO='{SRC_VER}'")
    bn = q1(f"SELECT COUNT(*) FROM {BAK}")
    print(f"[2] 백업 생성 {BAK} = {bn:,}행")
    if bn != src:
        con.rollback()
        sys.exit(f"⛔ 중단 — 백업 행수 불일치 ({bn} vs {src})")

# ── [3] UPDATE ──────────────────────────────────────────────────
if DRY:
    print(f"[3] (dry) UPDATE {TBL} SET VERSION_NO='{TGT_VER}' "
          f"WHERE DIVISION_ID='{DIV}' AND VERSION_NO='{SRC_VER}'  → {src:,}행 예정")
    con.rollback()
    con.close()
    sys.exit(0)

cur.execute(f"UPDATE {TBL} SET VERSION_NO=:t WHERE DIVISION_ID=:d AND VERSION_NO=:s",
            {"t": TGT_VER, "d": DIV, "s": SRC_VER})
moved = cur.rowcount
print(f"[3] UPDATE {moved:,}행 (기대 {src:,})")
if moved != src:
    con.rollback()
    sys.exit(f"⛔ ROLLBACK — 갱신 건수 불일치 ({moved} vs {src})")

# ── [4] 커밋 전 검증 ────────────────────────────────────────────
after_src = q1(f"SELECT COUNT(*) FROM {TBL} WHERE DIVISION_ID=:d AND VERSION_NO=:v", {"d": DIV, "v": SRC_VER})
after_tgt = q1(f"SELECT COUNT(*) FROM {TBL} WHERE DIVISION_ID=:d AND VERSION_NO=:v", {"d": DIV, "v": TGT_VER})
print(f"[4] 검증 — SRC {after_src}행(기대 0) / TGT {after_tgt:,}행(기대 {src:,})")
if after_src != 0 or after_tgt != src:
    con.rollback()
    sys.exit("⛔ ROLLBACK — 검증 실패")

con.commit()
print("[5] COMMIT 완료")
print(f"""
=== ROLLBACK SQL (필요 시) ===
UPDATE {TBL} SET VERSION_NO='{SRC_VER}'
 WHERE DIVISION_ID='{DIV}' AND VERSION_NO='{TGT_VER}';
COMMIT;
-- 또는 백업표 복원: {BAK} ({src:,}행)
""")
con.close()
