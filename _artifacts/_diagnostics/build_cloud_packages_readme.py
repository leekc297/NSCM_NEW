#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""build_cloud_packages_readme.py — 생성된 3 패키지에 _README.md + 90_VERIFY.sql 부착 (2026-08-11)

build_cloud_packages_20260811.py 가 남긴 `_BUILD_SUMMARY_{stamp}.json` 의 **실측 건수**를 그대로 써서
적용 순서서와 검증 SQL 을 만든다(숫자 하드코딩 금지 — 기대값이 실제와 갈리면 게이트가 무의미해진다).

사용: python build_cloud_packages_readme.py --stamp 20260811_1532
"""
import argparse
import json
import pathlib
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
PKGROOT = ROOT / "_artifacts" / "_deploy_packages"

VERIFY_UI = """-- ============================================================================
-- {menu} — 적용 후 검증 (기대값 = 사내 live 실측 {stamp})
-- ============================================================================
SET LINESIZE 200
COLUMN 항목 FORMAT A34
COLUMN 판정 FORMAT A6

SELECT '1. PKG SPEC/BODY VALID' AS 항목,
       COUNT(*) AS 실측, 2 AS 기대,
       CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL' END AS 판정
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{pkg}' AND STATUS='VALID'
UNION ALL
SELECT '2. SHEET_COLUMNS', COUNT(*), {columns},
       CASE WHEN COUNT(*) >= {columns} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='{menu}'
UNION ALL
SELECT '3. SHEET_MEASURE', COUNT(*), {measures},
       CASE WHEN COUNT(*) >= {measures} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='{menu}'
UNION ALL
SELECT '4. API_M', COUNT(*), {api},
       CASE WHEN COUNT(*) >= {api} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_API_M WHERE API_ID IN (SELECT API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{menu}')
UNION ALL
SELECT '5. MNU_BTN_MPG_M', COUNT(*), {btn},
       CASE WHEN COUNT(*) >= {btn} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{menu}'
UNION ALL
SELECT '6. PROC_M (SP 파라미터 계약)', COUNT(*), {proc},
       CASE WHEN COUNT(*) >= {proc} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_PROC_M WHERE PROC_NM IN
       ( SELECT DISTINCT A.API_URL FROM SCM_ADM_API_M A
           JOIN SCM_ADM_MNU_BTN_MPG_M B ON B.API_ID=A.API_ID WHERE B.MNU_ID='{menu}' )
UNION ALL
SELECT '7. CMBO (화면 사용 콤보)', COUNT(*), {combos},
       CASE WHEN COUNT(*) >= {combos} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ({combo_list})
UNION ALL
SELECT '8. MSG/LBL 행(KO/EN/CN)', COUNT(*), {msg_rows},
       CASE WHEN COUNT(*) >= {msg_rows} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_MSG_M WHERE MSG_ID IN ({msg_list})
UNION ALL
SELECT '9. 버튼 권한', COUNT(*), {auth_btn},
       CASE WHEN COUNT(*) >= {auth_btn} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='{menu}'
UNION ALL
SELECT '10. 0행 콤보 (조용한 빈콤보)', COUNT(*), 0,
       CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'WARN' END
  FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ({combo_list}) AND USE_YN <> 'Y'
;
"""

README_UI = """# {menu} — 클라우드 이관 패키지 ({stamp})

> 생성: `_artifacts/_diagnostics/build_cloud_packages_20260811.py` — **사내 Oracle live 실측 스냅샷**.
> ⚠️ 클라우드 DB 는 **QA·DEV 2DB 동시 적용** 의무 (feedback_cloud_be_build_out_of_sync_diagnosis §0).

## 0. 이 패키지가 담은 것 (실측 건수)

| 구분 | 파일 | 건수 |
|---|---|---:|
| GTT 자급 DDL | `01_GTT_DDL.sql` | {gtt} |
| PACKAGE SPEC | `02_PKG_SPEC.sql` | 1 |
| PACKAGE BODY | `03_PKG_BODY.sql` | 1 |
| 배선 메타 (MNU/API/BTN/PROC) | `10_META_WIRING.sql` | API {api} / BTN {btn} / PROC {proc} |
| ⭐ **UI Category Setup** | `11_META_SHEET_COLUMNS.sql` | {columns} (**MERGE INTO**) |
| Measure 메타 | `12_META_SHEET_MEASURE.sql` | {measures} (MERGE INTO) |
| ⭐ **화면 사용 COMBO 전수** | `13_META_CMBO_SQL.sql` | **{combos}종** (MERGE INTO) |
| MSG/LBL | `14_META_MSG_LBL.sql` | {msg}코드 / {msg_rows}행 |
| 권한 (메뉴/버튼) | `15_META_AUTH.sql` | 메뉴 {auth_mnu} / 버튼 {auth_btn} |
| i18n 런타임 원천 | `locales_PATCH.json` | FE `public/locales` 병합용 |
| FE 소스 | `fe/` | 화면 폴더 + 공용 `versionModal` |
| 검증 | `90_VERIFY.sql` | 10항목 |

### COMBO {combos}종 (사용자 요청 — "UI 에 사용을 위하여 추가한 COMBO 가 모두")
수집 근거 = **셀 콤보(`SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`) ∪ FE 소스 참조**(조회조건·행별 콤보·모달).
등록만 가고 배선이 빠지면 화면은 **조용히 빈 콤보**가 되므로 `11_META_SHEET_COLUMNS.sql` 과 **반드시 함께** 적용한다.

```
{combo_lines}
```

## 1. 적용 순서 (SCM_MGR 계정)

| 순서 | 파일 | 비고 |
|---:|---|---|
| 0 | (클라우드 BE 정지) | library cache pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` |
| 1 | `01_GTT_DDL.sql` | 미존재 시에만 생성(멱등) |
| 2 | `02_PKG_SPEC.sql` | |
| 3 | `03_PKG_BODY.sql` | ⚠ SPEC 먼저 |
| 4 | `10_META_WIRING.sql` | |
| 5 | `11_META_SHEET_COLUMNS.sql` | ⭐ **MERGE — 값 갱신 반영** |
| 6 | `12_META_SHEET_MEASURE.sql` | |
| 7 | `13_META_CMBO_SQL.sql` | ⭐ COMBO |
| 8 | `14_META_MSG_LBL.sql` | |
| 9 | `15_META_AUTH.sql` | 가드 INSERT (기존 권한 불변) |
| 10 | (클라우드 BE 재기동) | |
| 11 | `90_VERIFY.sql` | 전 항목 PASS 확인 |

## 2. FE 동시 이관 (DB 만 가면 LBL fallback / 팝업 미동작)

> 원칙: **파일 단위 덮어쓰기 금지 — 폴더 전체 checkout** (feedback_cloud_shell_generation_mismatch).

1. `fe/{page}/` → `nscm-fe/features/demand/src/pages/{page}/`
2. `fe/versionModal/` → `nscm-fe/features/demand/src/components/versionModal/`
3. `locales_PATCH.json` 의 KO/EN/CN 을 `nscm-fe/public/locales/{{KO,EN,CN}}.json` 에 **부분 병합**
   (들여쓰기·키 순서 보존 — 전체 재포맷 금지)
4. `configs/types/procedures.d.ts` / viewRegistry / route-paths / Router 배선 확인
5. 클라우드 셸에서 `tsc --noEmit` 0 + `eslint` 0

⚠️ **locales 미등록 코드 {n_missing}건**: {missing}
   → 이 코드는 DB·locales 어디에도 없어 화면에 fallback 문자열이 그대로 뜬다. **신규 채번 필요**
     (임의 생성 금지 — 채번 후 DB 3언어 + locales 3파일 + 본 PATCH 3점 동시 반영. hook #114 §5)

## 3. MERGE 채택 사유 (2026-08-11 사용자 지시)

UI Category Setup 은 **값 갱신**(예: `INPUT_TP_CD`, `VISIBLE_FLAG`)이 목적이라 INSERT-only 로는 반영되지 않는다.
따라서 `MERGE INTO ... WHEN MATCHED THEN UPDATE / WHEN NOT MATCHED THEN INSERT` 를 쓴다.
⭐ **DELETE 절은 없다** — 클라우드에만 있는 행이 지워지지 않는다(2026-08-07 "시트 메타 MERGE 금지" 는
DELETE 동반 사고가 원인이었고, 본 패키지는 그 위험을 구조적으로 제거했다).

## 4. 적용 후 화면 검증

DB 검증(`90_VERIFY.sql`)은 **메타가 들어갔는지**만 본다. 화면 동작은 별도다 (hook #130):
- 조회 → 편집 매트릭스 → Insert 세트 → 저장 → 재조회 (값 반영 육안)
- 셀 콤보가 **명칭(NAME)** 으로 뜨는지 (코드로 뜨면 파라미터 미전달)
- Department/Team 컬럼이 **각 1개**만 보이는지
- 조회조건 라벨이 `_` 접두 fallback 없이 뜨는지
"""

README_UPFX = """# UP_FX SP → COMBO 전환분 — 클라우드 이관 패키지 ({stamp})

> AS-IS 는 콤보 데이터를 `UP_FX_GetCommonDataList` 계열 SP 로 얻었다. TO-BE 는 이를 **CMBO 등록(SQL)** 으로
> 전환했다. 본 패키지는 그 전환분 **전량**과 **배선**을 한 번에 이관한다.
> ⚠️ QA·DEV 2DB 동시 적용 의무.

## 0. 담은 것

| 구분 | 파일 | 건수 |
|---|---|---:|
| UP_FX 전환 COMBO 등록 | `01_CMBO_UPFX.sql` | **{combos}종** (MERGE INTO) |
| 배선 (UI Category Setup) | `02_WIRING_SHEET_COLUMNS.sql` | **{wiring}행** (MERGE INTO) |
| 검증 | `90_VERIFY.sql` | 3항목 |

수집 기준: `SCM_ADM_CMBO_SQL_M.SQL_NM` 에 **AS-IS UP_FX 출처가 명시**된 행 전수(실측).

## 1. 왜 등록만으로는 부족한가 (hook #117 §5.5~§5.10)

UP_FX 콤보의 TO-BE 산출물은 **3개**다. 등록만 세면 누락이 조용히 통과한다.

| # | 산출물 | 본 패키지 | 확인 방법 |
|---|---|---|---|
| 1 | **등록** — `SCM_ADM_CMBO_SQL_M` | ✅ `01_CMBO_UPFX.sql` | `90_VERIFY.sql` 항목1 |
| 2 | **배선** — `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` | ✅ `02_WIRING_SHEET_COLUMNS.sql` | 항목2 |
| 3 | **FE 파라미터** — 화면이 `@토큰`을 실제로 전달 | ⛔ **각 화면 FE 패키지 소관** | 화면별 게이트 섹션7 / E2E D2축 |

⇒ 3번은 화면 코드라 본 패키지에 없다. **해당 화면의 FE 이관과 짝지어 적용**해야 한다.
   미전달 시 증상 = 콤보가 **0행**(조용한 빈 콤보) 또는 코드값 그대로 표시.

## 2. 소비 화면 ({n_screens}개 — 배선 {wiring}행)

```
{screen_lines}
```

⚠️ 본 패키지의 `02_WIRING_SHEET_COLUMNS.sql` 은 **위 화면들의 SHEET_COLUMNS 행을 갱신**한다.
   DMF0044/DMF0049 개별 패키지와 **겹치는 행이 있다** — 어느 쪽을 나중에 적용해도 동일 결과가 되도록
   양쪽 모두 사내 live 스냅샷에서 떴다(같은 값). 순서 무관.

## 3. 적용 순서

| 순서 | 파일 |
|---:|---|
| 1 | `01_CMBO_UPFX.sql` |
| 2 | `02_WIRING_SHEET_COLUMNS.sql` |
| 3 | `90_VERIFY.sql` |
| 4 | 각 화면 FE 이관 (파라미터 전달 축) |
"""

VERIFY_UPFX = """-- UP_FX 콤보 전환분 검증 (기대값 = 사내 live 실측 {stamp})
SET LINESIZE 200
COLUMN 항목 FORMAT A40
SELECT '1. UP_FX 전환 COMBO 등록' AS 항목, COUNT(*) AS 실측, {combos} AS 기대,
       CASE WHEN COUNT(*) >= {combos} THEN 'PASS' ELSE 'FAIL' END AS 판정
  FROM SCM_ADM_CMBO_SQL_M WHERE UPPER(SQL_NM) LIKE '%UP\\_FX%' ESCAPE '\\'
UNION ALL
SELECT '2. 배선 SHEET_COLUMNS', COUNT(*), {wiring},
       CASE WHEN COUNT(*) >= {wiring} THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_MST_SHEET_COLUMNS WHERE CELL_COMBO_DATA_TYPE IN
       ( SELECT SQL_ID FROM SCM_ADM_CMBO_SQL_M WHERE UPPER(SQL_NM) LIKE '%UP\\_FX%' ESCAPE '\\' )
UNION ALL
SELECT '3. 배선됐는데 미등록(고아)', COUNT(*), 0,
       CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END
  FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.CELL_COMBO_DATA_TYPE IS NOT NULL
   AND TRIM(C.CELL_COMBO_DATA_TYPE) IS NOT NULL
   AND NOT EXISTS ( SELECT 1 FROM SCM_ADM_CMBO_SQL_M M WHERE M.SQL_ID = C.CELL_COMBO_DATA_TYPE )
;
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--stamp", required=True)
    a = ap.parse_args()
    s = json.loads((PKGROOT / ("_BUILD_SUMMARY_%s.json" % a.stamp)).read_text(encoding="utf-8"))

    for menu in ("DMF0044", "DMF0049"):
        d = s[menu]
        folder = PKGROOT / ("%s_%s" % (menu, a.stamp))
        page = "sales-reports" if menu == "DMF0044" else "etc-sales-reports"
        pkg = "PKG_%s" % menu
        combo_list = ", ".join("'%s'" % c for c in d["combo_ids"])
        # MSG 목록은 verify 용 — locales_PATCH 에서 코드 복원
        patch = json.loads((folder / "locales_PATCH.json").read_text(encoding="utf-8"))
        msg_ids = sorted(set(patch["KO"]) | set(patch["_missing"]))
        msg_list = ", ".join("'%s'" % m for m in msg_ids) or "'_NONE_'"
        (folder / "90_VERIFY.sql").write_text(
            VERIFY_UI.format(menu=menu, pkg=pkg, stamp=a.stamp, combo_list=combo_list,
                             msg_list=msg_list, **{k: d[k] for k in
                                                   ("columns", "measures", "api", "btn", "proc",
                                                    "combos", "msg_rows", "auth_btn")}),
            encoding="utf-8")
        (folder / "_README.md").write_text(
            README_UI.format(menu=menu, stamp=a.stamp, pkg=pkg, page=page,
                             combo_lines="\n".join(d["combo_ids"]),
                             n_missing=len(d["locale_missing"]),
                             missing=", ".join(d["locale_missing"]) or "없음",
                             **{k: d[k] for k in
                                ("gtt", "api", "btn", "proc", "columns", "measures",
                                 "combos", "msg", "msg_rows", "auth_mnu", "auth_btn")}),
            encoding="utf-8")
        print("[ok] %s — _README.md / 90_VERIFY.sql" % folder.name)

    d = s["UPFX"]
    folder = PKGROOT / ("UPFX_COMBO_%s" % a.stamp)
    lines = ["%-10s %2d컬럼   %s" % (k, len(v), ", ".join(sorted({x.split(" → ")[1] for x in v})))
             for k, v in sorted(d["screens"].items())]
    (folder / "90_VERIFY.sql").write_text(
        VERIFY_UPFX.format(stamp=a.stamp, combos=d["combos"], wiring=d["wiring"]), encoding="utf-8")
    (folder / "_README.md").write_text(
        README_UPFX.format(stamp=a.stamp, combos=d["combos"], wiring=d["wiring"],
                           n_screens=len(d["screens"]), screen_lines="\n".join(lines)),
        encoding="utf-8")
    print("[ok] %s — _README.md / 90_VERIFY.sql" % folder.name)


if __name__ == "__main__":
    main()
