# DMF0044 Version Copy 저장 — GROUP BY 불일치(ORA-00979) 보완 (클라우드 이관 · 패치형)

> 마커 `[E20261014-DMF0044VCGRP]` — PKG_DMF0044 BODY 의 Version Copy 저장 프로시저에서 GROUP BY 절 16줄만 변경. 데이터·메타·화면 변경 없음.

| 항목 | 값 |
|---|---|
| 대상 | `P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY` (Version Copy 저장) 의 INSERT 4문장 |
| 원인 | SELECT 는 `NVL(NULLIF(RTRIM(X),''), '/')`, GROUP BY 는 `NVL(X, '/')` — 식이 달라 실행 시점에 ORA-00979 |
| 보완 | GROUP BY 를 SELECT 와 같은 식으로 맞춤 (17곳 · 16줄). SELECT · WHERE 무변경 |
| 발견 경위 | 조회 오류(`DMF0044_GRPUPPER_CLOUD_20261014`) 뒤 패키지 전체 정적 SQL 313문장을 파싱 점검 |
| 사내 적용 | **완료** (ZIOUI1 2026-10-14 09:59 → 리허설 재적용 10:03:33) · [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0044_VCGRP_20261014/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | L2 대상 16줄이 모두 '적용 전 꼴' · L3 마커 0 · L4 실행 중 세션 없음 |
| 2 | [A_DB/10_APPLY_VCGRP_PATCH.sql](A_DB/10_APPLY_VCGRP_PATCH.sql) | `APPLIED — PKG_DMF0044 BODY VALID · Version Copy GROUP BY 16줄 보완` (이미 적용이면 `SKIP`, 대상 줄이나 SELECT 쪽 식이 다르면 ORA-20001 · ORA-20006 으로 중단·원문 무변경) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 PASS(1) · V2 VALID/오류 0 · V3 16줄 모두 '적용 후 꼴' |

롤백: [A_DB/99_ROLLBACK_VCGRP_PATCH.sql](A_DB/99_ROLLBACK_VCGRP_PATCH.sql)

## 주의
- **실제 Version Copy 저장은 사내에서도 실행하지 않았다.** 원장에 쓰는 프로시저라 "4문장이 파싱을 통과한다"까지만 확인했다. 적용 뒤 화면에서 Version Copy 를 한 번 실행해 확인이 필요하다.
- **패치형 v2 (10-14 10:20 교체).** v1 은 대상 줄을 글자 단위로 맞춰 QA 에서 2회 중단됐다. QA 원문은 들여쓰기 · 줄 끝 주석이 다르고 4줄이 아직 `NVL(X, '-')` 였다.
  v2 는 줄을 코드 내용으로만 맞춘다(들여쓰기 · 주석 · `'-'`/`'/'` 무관). 맞은 줄 안의 토큰만 바꾸므로 클라우드의 들여쓰기 · 주석은 그대로 남는다.
- **SELECT 쪽도 확인한다.** GROUP BY 를 SELECT 의 식에 맞추는 것이므로, 프로시저 안 SELECT 식의 개수가 사내 적용 전과 다르면 ORA-20006 으로 중단한다(원문 무변경) → 메시지 전체 회신.
- **원복의 한계.** 99 는 대상 토큰을 `NVL(X, '/')` 로 돌린다. 적용 전에 `'-'` 였던 4줄도 `'/'` 로 돌아간다(어느 쪽이든 오류가 나는 상태다).
- `DMF0044_GRPUPPER_CLOUD_20261014`(조회 보완)과는 프로시저가 달라 적용 순서 무관. 둘 다 적용해야 패키지의 같은 계열 오류가 0 이 된다.
- 결과 값은 달라지지 않는다. 묶음 기준이 결과 컬럼과 같은 식이 될 뿐이다.
- 10 은 패키지 BODY 재생성이라 DMF0044 조회·저장 실행 중이면 대기 — 00 L4 확인 뒤 실행.

## 리허설 (사내 ZIOUI1 2026-10-14 10:23, `test_cloud_sim.py` · `_rehearsal_out/`)
- A. 사내 실제 원문: 99 → 10(`APPLIED`, DB == 사내 적용본) → 10(`SKIP`) → 99(DB == 사내 적용 전) — 7항목 PASS
- B. QA 모양 원문(들여쓰기 공백 · AJS 주석 없음 · 4줄 `'-'`)을 사내 패키지에 잠시 올림: 00(L2 16줄 · `'-'` 4줄) → 10(`APPLIED`) → 패키지 파싱 점검 같은 계열 0건 → 90(V1 PASS · V3 16줄) → 99 — 9항목 PASS
- C. 사내 적용본으로 복귀 · DB == 적용본 PASS. 그 뒤 파싱 점검 0건 · 조회 6케이스 PASS.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0044 BODY Version Copy 프로시저 GROUP BY 16줄 변경 + 주석 1줄 | A_DB/10_APPLY_VCGRP_PATCH.sql |
| 권한·시노님·메타·데이터 변경 | 없음 |
