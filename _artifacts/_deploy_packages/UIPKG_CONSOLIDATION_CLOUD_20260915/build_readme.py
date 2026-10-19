"""UIPKG_CONSOLIDATION — README 생성 (루트 00_README.md · PKG 별 README.md · 사내 LOCAL_VERIFY_GUIDE.md)
입력: _BUILD.json · 사내 LEDGER.json · 00_refresh/mnu_m.csv · 03_meta/VERIFY.md · 04_drop/JUDGE.md
FRESH-GATE(hook #152) 해당 없음: DB 접속·ALL_SOURCE 조회·DDL 실행 없음. 원문 추출·게이트는 build_cloud.py 가 수행하고
이 스크립트는 그 결과(_BUILD.json)로 문서만 만든다 — 파일 안 'CREATE OR REPLACE' 는 README 안내 문구다.
"""
import csv, json, pathlib

HERE = pathlib.Path(__file__).resolve().parent
CORP = HERE.parents[1] / "_apply_corporate" / "UIPKG_CONSOLIDATION_20260915"

INTERNAL_PATH = {  # 내부 호출 전용 SP → 호출 PKG 멤버(화면 동작) — 로컬 검증 시나리오
    "SCM_ADM_MAIL_SEND": ("DMF0003", "PKG_DMF0003.P_DMF0003_SAVE_PRPOPUP (MKT FCST 의 PR 팝업 저장 → 메일 발송)"),
    "PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST": ("DMF0006", "PKG_DMF0006.P_PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA (저장 → 이력 적재)"),
    "PR_DM_MST_CUSTOMER_FCST_HIST": ("DMF0007", "PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA (저장 → 이력 적재)"),
    "DMF0000_GET_UPDATE_HISTORY": ("DMF0008", "PKG_DMF0008.P_DMF0008_GET_UPDATE_HISTORY (Update History 조회)"),
    "PR_DM_CUST_ITEM_MAPPING": ("DMF0014", "P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST(_40) 내부 (Excel Upload [OK] 저장 → MKT FCST 반영)"),
    "PR_DM_PLN_CUST_FCST_TO_MKT_FCST": ("DMF0014", "P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=1)·P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA (Div 81/82 저장)"),
    "PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40": ("DMF0014", "P_DMF0014_CUST_FCST_EXCEL_UPLOAD(mode=1) (Div 40 저장)"),
    "PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE": ("DMF0020", "PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP (Sales Price 저장 → 금액 재계산)"),
    "PR_DM_PLN_CFM_TO_MKT_FCST": ("DMF0082", "PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA (Fcst MGMT 저장)"),
    "PR_SCM_MST_EXCHANGE_RATE": ("DMF0082", "P_PR_SCM_MST_EXCHANGE_RATE_UI (환율 모달 BPS I/F)"),
    "PR_SCM_ADM_RECIPIENT_ASSIGN_HIST": ("SYS0017", "PKG_SYS0017.P_SYS0017_SAVE_RECIPIENT_ASSIGN (수신자 지정 저장 → 이력)"),
}
FILE_DESC = [
    ("00_PRECHECK.sql", "SCM_MGR", "조회 전용 — 판정표 확인(아래 §판정)", "-"),
    ("10_SPEC.sql", "SCM_MGR", "PKG SPEC 교체 (멤버 선언 추가/교체)", "SHOW ERRORS 0 · 실패 시 적용 직전 백업한 클라우드 원문으로 원복(§원복 요약)"),
    ("11_BODY.sql", "SCM_MGR", "PKG BODY 교체 (standalone 본문 → 멤버, 내부 호출 → 멤버)", "SHOW ERRORS 0"),
    ("12_CALLER_*.sql", "SCM_MGR", "PKG 밖 호출부 본문 교체 (대상 SP 호출 → PKG.멤버)", "VALID"),
    ("20_GRANT_SCM_MGR.sql", "SCM_MGR", "GRANT EXECUTE → SCMP_APP (멱등)", "오류 없음"),
    ("21_SYNONYM_SCMP_APP.sql", "**SCMP_APP**", "CREATE OR REPLACE SYNONYM (멱등)", "오류 없음"),
    ("90_VERIFY.sql", "SCM_MGR", "적용 확인 — STATUS VALID · SOURCE_CHK SAME · USER_ERRORS 0 · 멤버 N행", "-"),
    ("30_META_SWITCH.sql", "SCM_MGR", "META 전환 — PROC_M 복제 MERGE + API_M.API_URL → PKG.멤버 (COMMIT 포함)", "영향 행수 = README 표"),
    ("31_PROC_M_DATATYPE_FIX.sql", "SCM_MGR", "PROC_M 기존 결함 정정 (DMF0043 만)", "2행"),
    ("38_META_VERIFY.sql", "SCM_MGR", "META 확인 — CHK=OK · NEW_ROWS=STANDALONE_ROWS=MEMBER_ARGS · IN/OUT 순서 동일", "-"),
    ("39_META_ROLLBACK.sql", "SCM_MGR", "META 원복 — API_URL → standalone · 복제 PROC_M 삭제", "-"),
    ("40_DROP_STANDALONE_SCM_MGR.sql", "SCM_MGR", "미사용 standalone 삭제 (가드 통과 SP 만 · 기존 PROC_M 행 삭제 + DROP)", "DROPPED N · SKIP 0"),
    ("41_DROP_SYNONYM_SCMP_APP.sql", "**SCMP_APP**", "삭제된 SP 의 SCMP_APP 시노님 정리", "DROPPED SYNONYM N"),
    ("49_RESTORE.sql", "SCM_MGR (+SCMP_APP 주석분)", "40·41 원복 — standalone·GRANT·PROC_M 복원", "-"),
]


def main():
    B = json.loads((HERE / "_BUILD.json").read_text(encoding="utf-8"))
    L = json.loads((CORP / "LEDGER.json").read_text(encoding="utf-8"))
    mnu = {r["MNU_ID"]: r for r in csv.DictReader((CORP / "00_refresh/mnu_m.csv").open(encoding="utf-8-sig"))}
    tmap = {t["sp"]: t for t in L["targets"]}
    plan = json.loads((CORP / "03_meta/PLAN.json").read_text(encoding="utf-8"))

    # ── PKG 별 README ──
    for s in B["packages"]:
        pkg, d = s["pkg"], HERE / s["pkg"]
        files = set(s["files"])
        has_obj = any(f in files for f in ("10_SPEC.sql", "11_BODY.sql"))
        callers = [f for f in s["files"] if f.startswith("12_CALLER_")]
        md = [f"# {pkg} — standalone SP → PKG 취합 이관 (2026-09-15)", "",
              "> 원천: 사내 ZIOUI1 적용·검증본 · 전체 순서/공통 주의 = `../00_README.md` · 로컬 검증 = 사내 `UIPKG_CONSOLIDATION_20260915/LOCAL_VERIFY_GUIDE.md`", "",
              "## 대상 SP", "| standalone SP | PKG 멤버 | 처리 | 화면 API (META) |", "|---|---|---|---|"]
        build = json.loads((CORP / "02_apply/BUILD.json").read_text(encoding="utf-8"))["pkgs"].get(pkg, {})
        act = {m["sp"]: m["action"] for m in build.get("members", [])}
        for sp in s["targets"]:
            t = tmap[sp]
            apis = ", ".join(f"{b['mnu']}/{b['sht']}/{b['btn']}" for b in t["meta"]["btn_mpg"]) or f"(내부 호출) {INTERNAL_PATH.get(sp, ('', ''))[1]}"
            md.append(f"| {sp} | {pkg}.{t['member']} | {act.get(sp, '-')} | {apis} |")
        md += ["", "## 파일", "| 파일 | 실행 계정 | 내용 | 기대 결과 |", "|---|---|---|---|"]
        for fn, acct, desc, exp in FILE_DESC:
            present = fn in files or (fn == "12_CALLER_*.sql" and callers)
            if present:
                md.append(f"| `{fn if fn != '12_CALLER_*.sql' else ' · '.join(callers)}` | {acct} | {desc} | {exp} |")
        if not has_obj:
            md += ["", f"> ℹ {pkg} 는 **PKG 본문 변경 없음** — 기존 멤버 코드가 standalone 과 동일해 재배선만 한다. 10/11 없음."]
        md += ["", "## 적용 순서", "",
               "### ① 사전 점검", "1. `@00_PRECHECK.sql` (SCM_MGR) — 결과를 아래 판정표로 해석",
               "   | [A] VERDICT | 조치 |", "   |---|---|",
               "   | PRE | 해당 파일 적용 |", "   | POST | 이미 적용됨 — 해당 파일 SKIP |",
               "   | ABSENT → 신규 생성 대상 | 적용 (PKG_SYS0012 등 신규) |", "   | ABSENT → ⚠ 기존 객체 부재 | **중단** — 선행 이관 누락. 결과 공유 |",
               "   | DIFF | **중단 · 전체교체 금지** — 클라우드 본문이 사내와 다름. 결과 공유 후 차이 병합 |",
               "   - [B] standalone VERDICT 가 DIFF → 클라우드에만 있는 수정이 standalone 에 있음 → 멤버에 반영돼야 하므로 **중단·결과 공유**",
               "   - [C] MISSING 행 → 의존 객체 부재 → 컴파일 실패 조건 → **중단·결과 공유**",
               "   - [D] META 현재값 확인(전환 전 = API_URL 이 standalone 이름) · [E] SCMP_APP 권한/시노님 현황", ""]
        step = 2
        if has_obj or callers:
            md += [f"### ② DB 객체 (SCM_MGR)", f"{step}. 공통 선처리 `../00_COMMON/00_RECOMPILE_INVALID_STANDALONE.sql` (전체에서 1회 · 이미 실행했으면 생략)"]
            n = 3
            if "10_SPEC.sql" in files: md.append(f"{n}. `@10_SPEC.sql` → SHOW ERRORS 0 확인"); n += 1
            if "11_BODY.sql" in files: md.append(f"{n}. `@11_BODY.sql` → SHOW ERRORS 0 확인"); n += 1
            for c in callers: md.append(f"{n}. `@{c}` → VALID 확인"); n += 1
            md.append(f"{n}. 공통 후처리 `../00_COMMON/90_RECOMPILE_DEPENDENTS.sql` (전체에서 1회)"); n += 1
            step = n
        md += ["", "### ③ 앱계정 권한·시노님", f"{step}. `@20_GRANT_SCM_MGR.sql` (SCM_MGR){' ⭐ 신규 필수' if pkg in ('PKG_DMF0008', 'PKG_SYS0012') else ' (기존 보유 시 무해)'}",
               f"{step + 1}. `@21_SYNONYM_SCMP_APP.sql` (**SCMP_APP 로 접속**)", "",
               "### ④ 적용 확인", f"{step + 2}. `@90_VERIFY.sql` — STATUS VALID · SOURCE_CHK=SAME · USER_ERRORS 0행 · 멤버 {len(s['targets'])}행(PKG_DMF0000 은 기존 멤버 1행)",
               f"{step + 3}. 화면 실측 — META 전환 **전** 이므로 화면은 아직 standalone 호출. 내부 호출 전환분(아래 §실측)만 영향", ""]
        n = step + 4
        if s["apis"]:
            it = plan.get(pkg, [])
            md += ["### ⑤ META 전환", f"{n}. `@30_META_SWITCH.sql` — 대상 API {sum(len(i['apis']) for i in it)}건 (COMMIT 포함)"]
            n += 1
            if "31_PROC_M_DATATYPE_FIX.sql" in files:
                md.append(f"{n}. `@31_PROC_M_DATATYPE_FIX.sql` — DMF0043 mainTitle createdBy DATA_TP_CD 정정(미정정 시 PLS-00103)"); n += 1
            md += [f"{n}. `@38_META_VERIFY.sql` — CHK 전부 OK · NEW_ROWS = STANDALONE_ROWS = MEMBER_ARGS · PROC_M_INOUT = MEMBER_INOUT", f"{n + 1}. 화면 재실측(§실측) — BE 재기동 불요(META 매 호출 조회)",
                   f"   - 실패 시 `@39_META_ROLLBACK.sql` 로 즉시 원복(화면이 standalone 호출로 복귀)", ""]
            n += 2
        md += ["### ⑥ 미사용 standalone 삭제 (화면 실측 완료 후)", f"{n}. (선택) 판정만: `40_DROP_STANDALONE_SCM_MGR.sql` 머리 `c_execute := FALSE` 로 실행 → 전부 PASS 확인",
               f"{n + 1}. `@40_DROP_STANDALONE_SCM_MGR.sql` (SCM_MGR, c_execute=TRUE) — `DROPPED` {len(s['targets'])} · `SKIP 0` 기대. SKIP 이 있으면 사유 확인(META 미전환/의존 잔존)",
               f"{n + 2}. `@41_DROP_SYNONYM_SCMP_APP.sql` (**SCMP_APP**)",
               f"   - 원복: `@49_RESTORE.sql` (SCM_MGR, 파일 내 시노님 주석분은 SCMP_APP 로)", "",
               "## 실측 (화면)", "| 메뉴 | 화면 | 동작 | 기대 |", "|---|---|---|---|"]
        seen = set()
        for sp in s["targets"]:
            t = tmap[sp]
            for b in t["meta"]["btn_mpg"]:
                k = (b["mnu"], b["sht"], b["btn"])
                if k in seen: continue
                seen.add(k); m = mnu.get(b["mnu"], {})
                md.append(f"| {b['mnu']} | {m.get('MNU_DESC', '')} (`/{m.get('MNU_URL', '')}`) | 시트 `{b['sht']}` · 버튼 `{b['btn']}` | 오류 없이 동작 · 결과 전환 전과 동일 |")
            if not t["meta"]["btn_mpg"] and sp in INTERNAL_PATH:
                mid, path = INTERNAL_PATH[sp]; m = mnu.get(mid, {})
                md.append(f"| {mid} | {m.get('MNU_DESC', '')} (`/{m.get('MNU_URL', '')}`) | 내부 호출: {path} | 저장 성공 · SQL ERROR 없음 |")
        md += ["", "## 원복 요약", "| 단계 | 원복 |", "|---|---|",
               "| ② PKG/호출부 | 적용 전 클라우드 원문을 **적용 직전에 반드시 백업**: `SELECT TEXT FROM USER_SOURCE WHERE NAME='<객체>' AND TYPE='<타입>' ORDER BY LINE;` → 그 원문으로 CREATE OR REPLACE |",
               "| ③ 권한·시노님 | 신규분만 `REVOKE EXECUTE ON SCM_MGR.<PKG> FROM SCMP_APP;` · SCMP_APP `DROP SYNONYM <PKG>;` |",
               "| ⑤ META | `39_META_ROLLBACK.sql` |", "| ⑥ DROP | `49_RESTORE.sql` |"]
        (d / "README.md").write_text("\n".join(md) + "\n", encoding="utf-8")

    # ── 루트 README ──
    rows = []
    for s in B["packages"]:
        f = set(s["files"])
        rows.append(f"| {s['pkg']} | {len(s['targets'])} | {'Y' if '11_BODY.sql' in f else '-'} | {len([x for x in s['files'] if x.startswith('12_CALLER_')])} | {'Y' if s['apis'] else '-'} | {len(s['apis'])} | [README]({s['pkg']}/README.md) |")
    root = ["# UIPKG_CONSOLIDATION_CLOUD_20260915 — UI별 standalone SP → PKG 취합 클라우드 이관", "",
            f"> 빌드 {B['built']} · 원천 = 사내 ZIOUI1 적용·검증본 (`_artifacts/_apply_corporate/UIPKG_CONSOLIDATION_20260915/`)",
            "> ⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 · 모든 객체 SQL 머리 `SOURCE-FRESH`(사내 추출 시각) — 24시간 경과·사내 재변경 시 `python build_cloud.py` 재빌드", "",
            "## 개요", "- 대상: 15 PKG · standalone 43건 (목록 원본 `Doc/화면분석서/TOBE_UI별_PKG전환대상_20260914.md`, 09-15 재조회 확정)",
            "- 원칙: standalone 본문 무수정 이관(동일명 기존 멤버는 META 실사용 standalone 본문으로 교체 — PKG_DMF0008 AJS 멤버 포함) · 내부 호출은 PKG 멤버로 전환",
            "- 신규 PKG: `PKG_SYS0012` · 신규 앱계정 권한/시노님: `PKG_DMF0008`, `PKG_SYS0012`",
            "- 부수 영향: 이관된 본문의 `$$PLSQL_UNIT` 이 PKG 이름을 반환 → `SCM_SYS_LOG_BATCH.PROGRAM_NAME` 표기가 PKG 이름으로 바뀜(조회 로직 영향 0 확인)", "",
            "## PKG 목록", "| PKG | 대상 SP | BODY 교체 | 외부 호출부 | META 전환 | API 버튼 | 상세 |", "|---|---:|---|---:|---|---:|---|", *rows, "",
            "## 전체 적용 순서 (환경별 · QA → DEV)", "",
            "### 0. 준비", "1. 모든 PKG 폴더의 `00_PRECHECK.sql` 을 먼저 실행해 **DIFF · ⚠ABSENT · MISSING 이 하나도 없는지** 확인. 하나라도 있으면 전체 중단·결과 공유",
            "2. 교체할 객체(10/11/12 대상)의 클라우드 현재 원문을 백업(각 PKG README §원복)", "",
            "### 1. DB 객체 (SCM_MGR)", "1. `00_COMMON/00_RECOMPILE_INVALID_STANDALONE.sql`",
            "2. PKG 폴더를 **아래 순서**로 각 README ②(10 → 11 → 12) 실행",
            "   `PKG_DMF0000`(본문 없음) → `PKG_DMF0003` → `PKG_DMF0006` → `PKG_DMF0007` → **`PKG_DMF0008`(PKG_DMF0000 멤버 호출)** → `PKG_DMF0014` → `PKG_DMF0020` → `PKG_DMF0040` → **`PKG_DMF0043`(11_BODY 직후 반드시 12_CALLER_DMF0043_GET_MAIN_SPREAD_TITLE)** → `PKG_DMF0048`(본문 없음) → `PKG_DMF0072` → `PKG_DMF0082` → **`PKG_SYS0012`(신규)** → `PKG_SYS0014` → `PKG_SYS0017`",
            "3. `00_COMMON/90_RECOMPILE_DEPENDENTS.sql`",
            "4. 각 PKG `20_GRANT_SCM_MGR.sql` (SCM_MGR) → `21_SYNONYM_SCMP_APP.sql` (**SCMP_APP**)",
            "5. 각 PKG `90_VERIFY.sql` — 전부 VALID·SAME·ERRORS 0", "6. 화면 실측(내부 호출 전환분 — 저장 경로)", "",
            "### 2. META 전환 (SCM_MGR)", "1. META 전환 대상 8 PKG(DMF0008·0040·0043·0048·0072·0082·SYS0012·SYS0014) `30_META_SWITCH.sql` → DMF0043 은 `31_PROC_M_DATATYPE_FIX.sql` 추가",
            "2. 각 `38_META_VERIFY.sql` → 화면 실측(조회·저장 버튼) · 실패 PKG 는 `39_META_ROLLBACK.sql`", "",
            "### 3. standalone 정리 (화면 실측 완료 후 · 담당자 판단)", "1. 각 PKG `40_DROP_STANDALONE_SCM_MGR.sql` (가드 통과분만 삭제) → `41_DROP_SYNONYM_SCMP_APP.sql` (SCMP_APP)",
            "2. 원복 필요 시 `49_RESTORE.sql`", "",
            "## ⚠ 주의", "- `PKG_DMF0043` : 11_BODY 적용 순간 기존 멤버가 `P_DMF0043_GET_MAIN_SPREAD_TITLE_CORE` 로 바뀐다 → **12_CALLER_DMF0043_GET_MAIN_SPREAD_TITLE 를 바로 이어서** 실행해야 standalone 래퍼·`DMF0043_GET_CONTRIBUTE_MAIN_DATA` 가 INVALID 되지 않는다(사내 18:58 실측 — 1분간 INVALID 후 보정).",
            "- DIFF 판정 PKG 는 전체교체 금지 — 클라우드에만 있는 수정이 사라진다. 결과 공유 후 차이분 병합본을 다시 만든다.",
            "- 범위 밖 발견(미조치): PROC_M `DATA_TP_CD='VARCHAR2'` 행이 SCM0005 11행 · SCM0008 11행 · DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL 1행에 존재 — 값이 비어 호출문이 깨질 수 있음(별도 확인 권장).", "",
            "## 사내 검증 근거", "- STEP 2 `VERIFY.md` 멤버 43 시그니처·코드 동일 0 불일치 · 신규 INVALID 0",
            "- STEP 3 `VERIFY.md` API 38 · PR_GET_PROC_INFO_LIST 해석 전부 PKG 멤버 · BE 실호출 17 API 성공(mainTitle 은 PROC_M 결함 정정 후 125행)",
            "- STEP 4 `JUDGE.md` 43 PASS (판정 전용) · 음성 시험(사용중 SP → SKIP) 확인",
            "- STEP 5 PRECHECK 사내 자가시험: 교체 객체 32 POST · standalone 43 SAME · 가짜 해시 → DIFF 검출",
            f"- 누락 게이트: 사내 적용 작업 원장(`02_apply/APPLIED_OPERATIONS.md`) 파일 {len(B['gate_checked'])}건 전부 폴더 포함"]
    (HERE / "00_README.md").write_text("\n".join(root) + "\n", encoding="utf-8")

    # ── 로컬 검증 가이드 ──
    g = ["# 로컬 검증 가이드 — UI별 standalone SP → PKG 취합 (2026-09-15)", "",
         "> 대상 DB = 사내 ZIOUI1 (로컬 BE 가 붙는 DB). 사내에는 PKG 취합(STEP 2)·META 전환(STEP 3)이 **적용 완료**, standalone 삭제(STEP 4)는 **미적용**.",
         "> 즉 지금 로컬 화면은 **PKG 멤버를 호출**한다. 문제가 생기면 해당 PKG `03_meta/<PKG>/39_META_ROLLBACK.sql` 로 즉시 standalone 호출로 되돌릴 수 있다.", "",
         "## 1. 기동", "```", "cd C:\\Projects\\NSCM\\nscm-be   → .\\gradlew.bat bootRun   (local 프로파일)",
         "cd C:\\Projects\\NSCM\\nscm-fe   → vite.cmd --port 5173 --host 127.0.0.1", "```",
         "- BE 재기동 불요(META 는 호출 때마다 DB 조회). 이미 떠 있으면 그대로 사용.", "- 로그인 후 아래 메뉴 순서대로 확인. BE 로그 `nscm-be/logs/nscm.log` 에서 `{call PKG_…` 로 호출 이름 확인 가능.", "",
         "## 2. 호출 경로 확인 (선택 · DB)", "```sql", "-- 화면 버튼이 어떤 객체를 부르는지 (전환 후 = PKG_X.P_…)",
         "SELECT T1.MNU_ID, T1.SHT_NM, T1.MNU_BTN_CD, T2.API_URL FROM SCM_ADM_MNU_BTN_MPG_M T1 JOIN SCM_ADM_API_M T2 ON T1.API_ID = T2.API_ID",
         " WHERE T2.API_URL LIKE 'PKG_DMF0008.%' OR T2.API_URL LIKE 'PKG_DMF004_.%' OR T2.API_URL LIKE 'PKG_DMF0072.%' OR T2.API_URL LIKE 'PKG_DMF0082.P_PR_%' OR T2.API_URL LIKE 'PKG_SYS001_.%'",
         " ORDER BY 1, 2, 3;", "```", "",
         "## 3. 화면별 체크리스트", "| # | 메뉴 | 화면(경로) | 확인 동작 | 호출 객체(전환 후) | 기대 | 결과 |", "|---:|---|---|---|---|---|---|"]
    n = 0
    order = ["DMF0008", "DMF0040", "DMF0043", "DMF0043_01", "DMF0048", "DMF0072", "DMF0082", "SYS0012", "SYS0014", "DMF0003", "DMF0006", "DMF0007", "DMF0014", "DMF0020", "SYS0017"]
    rowsby = {}
    for t in L["targets"]:
        for b in t["meta"]["btn_mpg"]:
            rowsby.setdefault(b["mnu"], {})[(b["sht"], b["btn"])] = f"{t['pkg']}.{t['member']}"
        if not t["meta"]["btn_mpg"] and t["sp"] in INTERNAL_PATH:
            mid, path = INTERNAL_PATH[t["sp"]]
            rowsby.setdefault(mid, {})[("(내부)", path)] = f"{t['pkg']}.{t['member']}"
    hint = {"SEARCH": "조회", "SAVE": "저장(테스트 데이터로 1건 수정 후 저장 → 재조회로 반영 확인)", "APPROVE": "승인(테스트 요청 1건)", "REJECT": "반려(테스트 요청 1건)",
            "IF": "환율 모달 BPS I/F", "VERSION_MGMT": "버전 관리 팝업 조회"}
    for mid in order:
        m = mnu.get(mid, {})
        for (sht, btn), obj in sorted(rowsby.get(mid, {}).items()):
            n += 1
            action = f"내부 호출 경로: {btn}" if sht == "(내부)" else f"시트 `{sht}` — {hint.get(btn, btn)}"
            g.append(f"| {n} | {mid} | {m.get('MNU_DESC', '')} (`/{m.get('MNU_URL', '')}`) | {action} | `{obj}` | 오류 토스트/SQL ERROR 없음 · 데이터 표시(전환 전과 동일) | ☐ |")
    g += ["", "## 4. 이상 시 확인 순서",
          "1. 화면 오류 메시지 / BE 로그 `nscm.log` 의 `ORA-` · `PLS-` 전문",
          "2. `PLS-00306`(인자 개수/유형) → PROC_M 행과 멤버 인자 불일치 → `03_meta/<PKG>/38_META_VERIFY.sql` 결과 확인",
          "3. `PLS-00201`(식별자 없음) → SCMP_APP 권한/시노님 → `02_apply/<PKG>/20·21` (DMF0008·SYS0012)",
          "4. 호출문에 빈 인자 `, ,` → PROC_M DATA_TP_CD 가 VARCHAR/NUMBER/CLOB/CURSOR 이외(예: VARCHAR2)",
          "5. 급하면 그 PKG 만 `03_meta/<PKG>/39_META_ROLLBACK.sql` 실행 → 화면이 standalone 호출로 복귀(standalone 은 아직 삭제 안 됨)", "",
          "## 5. 사내 사전 실측 (19:07~19:12)",
          "- BE 실호출(SEARCH) 17 API 성공: DMF0072 dataType 3 · team 107 · endCustomer 153 · salesSite 475 / DMF0043 version 8 · yearPopup 9 · ratePopup 1 · mainTitle 125 / DMF0040 spreadTitle 448 / DMF0048 spreadTitle 87 / DMF0008 summary 10 · salesSite · updateHistory 1 / SYS0012 main / SYS0014 main 19 · UserInfo · division",
          "- 저장(SAVE)·승인/반려·I/F 는 데이터를 바꾸므로 사전 실측하지 않음 → 위 체크리스트로 로컬 확인 필요"]
    (CORP / "LOCAL_VERIFY_GUIDE.md").write_text("\n".join(g) + "\n", encoding="utf-8")
    print("README", len(B["packages"]), "+ root + LOCAL_VERIFY_GUIDE rows", n)


if __name__ == "__main__":
    main()
