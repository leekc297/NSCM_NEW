# 검사엔진 자기검증 보고 — 2026-11-08 (UI 재실행 없음 · 6화면 기존 산출물 + 엔진 코드만)

> 사용자 지시(11-08): "UI 에 대해서 각각 테스트 하지 않고 검사엔진 자체를 다시 한번 검증". 모든 수치는 이 세션 실측(출처·시각 병기). 원장·결과 파일은 시험 뒤 md5 로 원복 확인.
> 대상 산출물 = chain6f(11-07 17:16~22:57) 6화면 원장 10,663행 · 엔진 = `tools/Harness/verify/*.py`(98종) · `tools/E2E/lib/*.ts` · `Doc/e2e/specs/_verify|_trace|_snap|eg_*.spec.ts`.

## 1. 결과 요약

| 항목 | 결과 | 근거 |
|---|---|---|
| S1 규칙별 측정 코드 존재(engine_audit) | 101 규칙 중 OK 96 · 대상 생성 없음 5(B5·D2·B8·G03-WIRE·X-LOC) | engine_audit.py 10:0x |
| S2 규칙 입증 등급(doc_proof) | F(PASS·FAIL 모두 실측) 41 · Fm 5 · D(PASS 만) 38 · E(FAIL 만) 2(M1·G10) · C(실측 0) 5(B5·D2·C5·F9·K5) | doc_proof.py 10:0x |
| S3 정적 컴파일 | verify/*.py 98종 py_compile 0 오류 · tsc 기존 1건(`_verify.spec.ts:1865 'reach'`) 외 0 | 10:0x |
| S4 판정 멱등성(6화면 judge 재실행 → 원복) | 결과 변동 0/10,663 (SCP0084 1행은 T159 코드 변경에 따른 결정적 변화 — 정적 G4 가 매 실행 재계산) · 폴더 md5 원복 동일 | idem.log 10:04~10:06 |
| S5 판정 계약 변이 주입(SCP0037 · 5종) | 미승인 스냅샷 PASS 주입 → 차단(SNAP_GUARD 1) · 사용자 PASS 행 FAIL 주입 → 사용자 판정 유지 · 기대원천 없는 FAIL → ERROR[근거 불충분] · 조회 0행 전제 FAIL → ERROR[측정 전제] · **보류 규칙 FAIL → 통과(결함 T163) → 수정 후 판정필요[보류 규칙]** · 변이 뒤 2회 실행 차이 0 | mutate_gate.py 10:1x |
| S6 규칙×화면 측정 매트릭스 | 49 규칙이 화면 간 측정 여부 다름 → 표본 10셀 확인: 8셀 적용성(대상 없음) 정당 · **2셀 엔진 결함(T160 H1 시트명 대응 · T161 F6/F7/F8 날짜 키)** | 10:0x |
| S7 화면 독립성(화면 ID 분기) | judge/ledger/mapping_trace/_verify/_trace 에서 화면 ID 는 주석·증거 문자열뿐 · 분기 로직 0 | grep 10:0x |
| S10 FAIL 3-증거 계약 | 직접 실측 FAIL 19행(사용자 판정 제외) 전부 expect_src·evidence_ref·precond 보유 · GENERAL 0 | 10:1x |
| S11 판정필요 157행 사유 | KEYSET(키 범위 저장 시험) 46 · 시험 검사(CM trial) 25 · SORT 23 · 집계 상속 ~20 · diff 단독행 등 | 10:1x |
| ERROR 원인 상위(6화면) | 다국어 확인 필요 51 · 측정 경로 없음 49 · 확인 대상 36 · 측정 코드 없음 18 · 검증엔진 미기동 9(T151·T156 으로 감소 예상 — 다음 실행 측정) | 10:0x |
| 6화면 어디서도 판정 없는 규칙 | 12: C5 D2 F9 G10 J3 K5 K6 LB1 LB2 M1 SC2 X-NOTIMPL — K6·M1·J3 는 6화면 모두 '대상 없음' NA(정당) · F9·LB1·LB2·SC2·X-NOTIMPL 은 원장 행 자체 없음(측정 경로 미구현) | 10:0x |
| 게이트 강등 추적성 | note '원판정:FAIL' 48행 전부 사유 접두 보유(CR-093/096 · DD-215/216 · CM trial · 사용자 판정) · 규칙 덮어 PASS 3행 = 사용자 판정 2 + 콤보 API 실측 1 | 10:0x |

## 2. 이번 자기검증에서 고친 엔진 결함(T160~T163 · `_checker_defects.md`)
- T160 `align_check.py` 시트명 대응 — 한쪽만 공백 제거 비교 → 공백 있는 시트(SCP0016 'Waterfall Shipment Plan') H1 29행 NA. 양쪽 정규화.
- T161 `db_snapshot.py` 키 바인드 `str(item)` — 날짜 칸 ISO ↔ VARCHAR2 'YYYYMMDD' 불일치 → SCP0127·SCP0131 F6/F7/F8 '변경된 행 없어' ERROR. `_key_value` 정규화 · 실증: SCP0127 기록 행 → 1행.
- T162(잠복) smoke 컬럼 대사가 DOM 헤더(가로 가상화)만 셈 — SCP0084 '누락 24'. `gridHeadersAll()` 로 교체(현재 원장 허위 FAIL 0 · 잠복 제거).
- T163 judge 가 원장의 oracle_class 만 믿어 마스터 HOLD 변경이 무시됨. 마스터 정본 동기화.

## 3. 시험하지 못한 것(정직 보고)
- 브라우저가 필요한 자기검증: `checklist_selftest.py`(화면 안 오류 주입 CL_MUTATE) · eg 팝업·권한 검사기 · smoke/auth 경로 — 이번 지시(UI 재실행 금지)로 미실행.
- 11-07 수정분 중 다음 실행에서야 측정되는 것: T154/T155(authcrud) · T157(SCP0127 F6 원복) · T158(복원 실행) · T160(H1) · T161(F6/F7/F8) · T162(smoke 컬럼).
- 정밀도(실결함/조치필요)는 사용자 검토가 있는 SCP0084·SCP0127(1.000)·SCP0016(0.500) 만 측정.

## 4. 남는 구조적 약점(수정 아닌 기록)
- 규칙의 측정 경로가 '대조표에 걸리는 행'에 의존하는 설계(T159 로 SC1 만 화면 규칙으로 승격) — 같은 유형이 다른 규칙에도 있을 수 있음(F9·LB1·LB2·SC2·X-NOTIMPL 원장 행 없음).
- 시나리오 첫 단계 'search:0행' 은 응답 대기 없이 재는 스펙 측 결함(T153 은 judge 측 완화). 스펙 측 수정은 E2E 로 입증해야 하므로 보류.
- smoke 요약의 어노테이션은 100~300자 절단 → judge 가 원문을 못 읽는 경우가 있음(T149 '근거 불충분' 경로가 그 보호).
- 조치필요 정밀도는 사용자 검토가 있어야 산출된다 — 검토되지 않은 화면은 '미측정'.

## 5. 의견 — 생성·자동보정에 검사엔진을 붙이는 방법(사용자 질문 11-08)
요지: **생성엔진을 새로 만들지 말고, 검사엔진의 '사양 표'를 생성·보정의 입력으로 공유**하고, 검사엔진을 **정적(브라우저 없음)·런타임(E2E)** 두 층으로 나눠 정적 층을 생성 직후 게이트로 쓴다.

1) 단일 사양 원천 공유 — 지금 검사기가 기대값으로 쓰는 표(`search_cond.csv` 기준표 · `sheet_columns`/`SCM_MST_SHEET_COLUMNS` 메타 · `label_alias.csv` · `confirmed_requirements.csv`(CR) · `design_decisions.csv`(DD) · `common_contract.csv`(CC) · `_oracle_class.csv` · `rule_applicability.csv`)를 생성기(`tools/Harness/new-screen.ps1` · `gen-e2e.js` plan.json)가 그대로 읽게 한다. 생성과 검사가 다른 기대값을 보면 허위 FAIL/허위 PASS 가 필연이다(T159 가 그 사례).
2) 정적 검사 층을 '생성 직후 게이트'로 — 브라우저 없이 되는 검사(라벨·조회조건 순서(SC1)·컬럼 메타(A5 정적)·버튼 구성(K4)·대조표 미구현(X-NOTIMPL)·메시지 사전(MS1)·DB 시노님(DB-SYN)·적용성)는 이미 `ledger.py`·`mapping_trace.py`·STATIC 검사기에 있다. 이것만 묶은 `run_verify.py --static` 진입점을 만들어 생성·보정 직후 1~2분 안에 돌리고, 통과해야 E2E 로 넘어간다.
3) 자동보정 = 규칙별 '보정 레시피' 표 — 조치필요 행(fixlist.csv)의 규칙 ID 마다 DB 메타/PKG/FE 패턴 중 어디를 어떻게 고치는지 레시피(`rules/fix_recipes.csv`: rule_id · repairScope(DB_ONLY|DB_FE) · 대상(메타 표·PKG·FE 파일 패턴) · 변경 전/후 패턴 · 재판정 범위)로 적고, 보정기는 레시피에 있는 것만 자동 적용 + 그 규칙만 부분 재판정(`judge --only <rule>` 신설 · 전체 체인 재실행 금지). 레시피 없는 규칙은 지금처럼 가이드(DB MODE)로 남긴다.
4) 생성 직후 '자기 재현' — 생성기가 만든 화면은 E2E 전에 `pattern_coverage.py`(문서 결함 패턴 적용표)와 `applicability.py` 로 "이 화면에 적용될 규칙 N개 중 생성기가 보장한 것 M개"를 산출해 공백을 먼저 드러낸다.
5) 검사엔진 보호 장치 유지 — 생성·보정이 검사 결과를 입력으로 쓰면 검사기 결함이 코드로 굳는다. 그래서 `checker_regress`(기준선 악화 0) · 사용자 판정 오라클(`regress.py`) · 변이 시험(S5 · `checklist_selftest`)을 보정 파이프라인의 고정 단계로 둔다.
6) 우선순위 — (a) `--static` 진입점 + 사양 표 공유(생성기 plan.json 이 search_cond/label_alias 를 읽는지 점검) → (b) `judge --only` 부분 재판정 → (c) fix_recipes.csv 를 11-07 실제 결함(CR-029 기간 키 저장 · 메타 scale · 필수 표시)부터 채움 → (d) 정적 게이트를 `check-ui-gates` 실행 hook 에 연결.
위 (a)~(d) 는 모두 하네스(`tools/Harness`·`tools/E2E`) 안의 작업이라 DB MODE 제약과 무관하며, FE·BE 직접 수정은 레시피의 repairScope 가 결정한다.
