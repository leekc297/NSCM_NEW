# -*- coding: utf-8 -*-
"""REQ:CHAT-20260820-13 — 환율 팝업 편집 권한을 **시트 스코프**로 분리 (AS-IS 파리티).

문제: `useTabBtnPermissions` 의 `/admin/menu/{id}/auth` 는 BTN 코드 **문자열 목록**만 준다
  (시트 정보 없음 = 메뉴 단위 합집합). DMF0044 는 `titleSet/SAVE` 가 **DM Viewer** 에도 부여돼 있어
  `hasButton('SAVE')` 가 DM Viewer 에게 true → 환율 팝업 Insert/Save 가 열린다.
  AS-IS(`DMF0044_SalesReportExchangePopup.cs:148~162`)는 ADMIN/DM ADMIN 만 편집·저장이고
  나머지 그룹은 `Set_ButtonVisibleFalse` 로 버튼 자체가 숨는다.
해법(프로젝트 표준 — "시트 전용 권한은 코드 분리 등재"): 환율 시트 전용 코드 `EXRATE_SAVE` 를
  신설하고 ADMIN/DM ADMIN 에만 부여. FE 는 `hasButton('EXRATE_SAVE')` 로 판정한다.
  ⚠ 기존 `exchangeRate/SAVE` 행은 **그대로 둔다** — call-proc 라우팅(API_ID)이 그 코드에 걸려 있어
    지우면 저장 호출 자체가 깨진다. 신규 코드는 **권한 판정 전용**(API_ID 없음).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

MNU, SHT, NEW_CD, SRC_CD = "DMF0044", "exchangeRate", "EXRATE_SAVE", "SAVE"
GROUPS = ["ADMIN", "DM ADMIN"]  # AS-IS case 통과 그룹 (L148~162 LIVE)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("""SELECT MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
               WHERE MNU_ID=:m AND SHT_NM=:s ORDER BY MNU_BTN_CD""", {"m": MNU, "s": SHT})
before = cur.fetchall()
print("[BEFORE] BTN_MPG:", before)
assert any(r[0] == SRC_CD for r in before), "원본 SAVE 행 부재 — 중단"
if any(r[0] == NEW_CD for r in before):
    print("  이미 등재됨 — INSERT skip")
else:
    cur.execute("""INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
                   (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:m, :s, :c, NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)""",
                {"m": MNU, "s": SHT, "c": NEW_CD})
    assert cur.rowcount == 1
    print(f"[insert] BTN_MPG {MNU}/{SHT}/{NEW_CD} (API_ID=NULL — 권한 판정 전용)")

cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='SCM_ADM_USER_GR_MNU_BTN_MPG_M' ORDER BY COLUMN_ID""")
ug_cols = [r[0] for r in cur.fetchall()]
print("[USER_GR 컬럼]", ug_cols)

for grp in GROUPS:
    cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
                   WHERE MNU_ID=:m AND SHT_NM=:s AND MNU_BTN_CD=:c AND USER_GR_ID=:g""",
                {"m": MNU, "s": SHT, "c": NEW_CD, "g": grp})
    if cur.fetchone()[0]:
        print(f"  {grp}: 이미 부여 — skip")
        continue
    cur.execute("""INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
                   (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:g, :m, :s, :c, 'admin', SYSDATE, 'admin', SYSDATE)""",
                {"g": grp, "m": MNU, "s": SHT, "c": NEW_CD})
    assert cur.rowcount == 1
    print(f"[grant ] {grp} → {NEW_CD}")

con.commit()
cur.execute("""SELECT B.MNU_BTN_CD, LISTAGG(G.USER_GR_ID, ',') WITHIN GROUP (ORDER BY G.USER_GR_ID)
               FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
               LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M G
                 ON G.MNU_ID=B.MNU_ID AND G.SHT_NM=B.SHT_NM AND G.MNU_BTN_CD=B.MNU_BTN_CD
               WHERE B.MNU_ID=:m AND B.SHT_NM=:s GROUP BY B.MNU_BTN_CD ORDER BY 1""",
            {"m": MNU, "s": SHT})
print("\n[AFTER] exchangeRate 시트 버튼·권한")
for r in cur.fetchall():
    print(f"  {r[0]:14} {r[1]}")
con.close()
print("[OK] 시트 스코프 권한 코드 등재 완료")
