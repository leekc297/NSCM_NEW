# -*- coding: utf-8 -*-
"""25_ 콤보 이관 SQL + PENDING FE 재복사 + README/원장 (MEASINDENT)"""
import io, sys, pathlib, shutil
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
root = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260826_PENDING")

sql = """-- DMF0082_CLOUD_20260826_PENDING / 공유 콤보 'Measure' — CUST 종속 데이터 기반 1단 항목 게이트에 DMF0082 추가
-- [E20260826-MEASINDENT] 계층 표기(1단 ' \u2514 ' / 2단 '    \u2514 ') 정본 = 이 콤보 단일 원천 (DMF0003 파리티).
-- 멱등: 이미 반영돼 있으면 0행 UPDATE — 재실행 무해. 게이트 구조라 타 17개 소비 화면 무영향.
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
SET    SQL_DTL_CTN = REPLACE(SQL_DTL_CTN,
         '@mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'')',
         '@mnuId IN (''DMF0003'', ''DMF0035'', ''DMF0003_TEST'', ''DMF0082'')')
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE  SQL_ID = 'Measure'
AND    DBMS_LOB.INSTR(SQL_DTL_CTN, '''DMF0003_TEST'', ''DMF0082''') = 0;
COMMIT;

-- 검증 (기대: 1 = 반영)
SELECT CASE WHEN DBMS_LOB.INSTR(SQL_DTL_CTN, '''DMF0003_TEST'', ''DMF0082''') > 0 THEN 1 ELSE 0 END AS APPLIED
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'Measure';
"""
(root / "A_DB" / "25_CMBO_MEASURE_INDENT.sql").write_text(sql, encoding="utf-8")
print("25_ 생성", flush=True)

repo = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
rel = "features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx"
shutil.copy2(repo / rel, root / "B_FE" / rel)
print("PENDING FE ForecastPriceGrid 재복사", flush=True)

rp = root / "README.md"
r = rp.read_text(encoding="utf-8")
r = r.replace("**적용 순서: `21` → `23` → `24` → `02` → `90`**", "**적용 순서: `21` → `23` → `24` → `25` → `02` → `90`**")
a24 = "*(2026-08-26 재작성 — 구 UPDATE 단문은 클라우드 행 부재로 0건 무효 실측)* |"
assert a24 in r
r = r.replace(a24, a24 + "\n| 25 | `25_CMBO_MEASURE_INDENT.sql` | 멱등 UPDATE | 공유 콤보 `Measure` — CUST 종속 데이터 기반 1단 항목 게이트에 DMF0082 추가 (계층 들여쓰기 표기 정본. 타 17개 소비 화면 무영향) |")
ag = "| `components/ForecastPriceGrid.tsx` | 그리드 음수 = 빨간 글자 (REQ-7)."
assert ag in r
r = r.replace(ag, "| `components/ForecastPriceGrid.tsx` | 그리드 음수 = 빨간 글자 (REQ-7) + **[08-26] CUST 종속 메저 단계별 들여쓰기** — MEASURE 셀 white-space:pre 보존 (DMF0003 MktFcstGrid 파리티, 공백 collapse 로 단계가 안 보이던 것 정정).")
rp.write_text(r, encoding="utf-8")
print("README 갱신", flush=True)

lp = pathlib.Path(r"C:\Projects\NSCM\Doc\단위테스트_보완대상\보완요청_원장.md")
t = lp.read_text(encoding="utf-8")
anchor = "eslint error 0\u00b7type-check PASS. \ud654\uba74 \uc2e4\uc870\uc791 \ud655\uc778=\uc0ac\uc6a9\uc790 \ucd95 |"
assert t.count(anchor) == 1
row = ("\n| REQ:CHAT-20260826-5 | \ub300\ud654 \uc9c0\uc815 2026-08-26 | CUST \uc885\uc18d \uba54\uc800 \ub2e8\uacc4\ubcc4 \ub4e4\uc5ec\uc4f0\uae30 (\ud558\uc704\uc758 \ud558\uc704 = \ud55c \ub2e8\uacc4 \ub354) | DMF0082 "
       "| EV:_artifacts/_deploy_packages/DMF0082_CLOUD_20260826_PENDING/A_DB/25_CMBO_MEASURE_INDENT.sql::E20260826-MEASINDENT | VERIFIED | Y | N "
       "| \ud45c\uae30 \ub2e8\uc77c \uc6d0\ucc9c = \uacf5\uc720 \ucf64\ubcf4 'Measure'(1\ub2e8 ' \u2514 '/2\ub2e8 '    \u2514 ' \uacf5\ubc314 \u2014 DMF0003 \uc815\ubcf8 \ud30c\ub9ac\ud2f0). "
       "\uaca9\ucc28 2\uacf3 \uc815\uc815: \u2460\ucf64\ubcf4 \ub370\uc774\ud130 \uae30\ubc18 1\ub2e8 \ud56d\ubaa9 mnuId \uac8c\uc774\ud2b8\uc5d0 DMF0082 \ucd94\uac00(\uc2e4\ud589 \uac80\uc99d: \uacc4\uce35 23\ud56d\ubaa9\u00b7\ud0c0 17\uac1c \uc18c\ube44 \ud654\uba74 \ubb34\uc601\ud5a5 \uac8c\uc774\ud2b8 \uad6c\uc870) "
       "\u2461ForecastPriceGrid MEASURE \uc140 white-space:pre(\uacf5\ubc31 collapse \ub85c 2\ub2e8\uc774 1\ub2e8\ucc98\ub7fc \ubcf4\uc784 \u2014 MktFcstGrid L891 \ud30c\ub9ac\ud2f0). \uac80\uc99d \ub3c4\uad6c PASS |")
t = t.replace(anchor, anchor + row)
lp.write_text(t, encoding="utf-8")
print("원장 REQ-5 등재", flush=True)
