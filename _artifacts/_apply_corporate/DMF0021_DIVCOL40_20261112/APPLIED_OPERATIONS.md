# DMF0021 [E20261112-DIVCOL40] 사내 적용 기록 — 2026-11-12

## 증상
minyonglee1 · Div 40 · DMF0021 에서 RTF[R+P] 입력 후 저장 → SUCCESS 응답인데 재조회하면 입력값이 그 행에서 사라진다.

## 원인 (사내 ZIOUI1 실측 10:55~10:58)
- 사용자 컬럼 개인화(`SCM_MST_TITLESET_USER` 'C' · 15컬럼 · 11-02 16:16 저장)가 81 형 구성: `PROJECT_CODE` · `TEXT` · `FROM_SITE_ID` · `PLANT_SITE_ID` 포함, 40 전용 `END_CUSTOMER40` · `CELL_PROD_SITE_ID` · `TEXT4082` 없음.
- 조회 SP `PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX` 는 개인화 컬럼으로 행 키를 만든다 → 40 조회 행에 40 전용 키가 실리지 않는다.
- FE 저장(40)은 행의 `END_CUSTOMER40` · `CELL_PROD_SITE_ID` 를 읽는다(`sales-plan.save.ts:76·90`) → 빈 값 전송(BE 로그 10:53:16 · 10:53:49: `projectCode "^^^^"` · `cellProdSiteId "^^^^"`).
- 저장 SP 가 빈 값을 `'/'` · `'-'` 로 바꿔 저장 → 실제 키(`PROJECT_CODE 'IM'` · `CELL_PROD_SITE_ID 'NJ01-A'`)와 다른 키에 들어가, 재조회 시 프로젝트 '/' 인 별도 행에만 보인다.

## 보완
- 대상: `SCM_MGR.PKG_DMF0021` PACKAGE BODY — 순수 추가 55줄(기존 줄 무변경), 마커 `[E20261112-DIVCOL40]`.
- 내용: `p_division_id = '40'` 일 때 40 대상이 아닌 컬럼 3종을 40 대응 컬럼으로 치환 — `PROJECT_CODE→END_CUSTOMER40` · `FROM_SITE_ID→CELL_PROD_SITE_ID` · `TEXT→TEXT4082`. 40 대응 컬럼이 이미 키에 있으면 그대로 둔다. 그 밖의 컬럼은 건드리지 않는다.
- 적용: 10:58:47 (기준본 LAST_DDL 2026-11-11 17:48:18 → FRESH-GATE 통과 → 적용 후 LAST_DDL 2026-11-12 10:58:47 · VALID · ALL_ERRORS 0 · 적용본 == DB 원문 · DMF0021 INVALID 0).
- 원복: `PKG_DMF0021_BODY.ASIS.sql`.

## 적용 전후 대조 (같은 인자 — minyonglee1 · 40 · MONTHLY · 20261101~20270531)
| 항목 | 적용 전 | 적용 후 |
|---|---|---|
| 결과 행 수 | 1,681 | 1,681 |
| 결과 컬럼 수 | 64 | 64 |
| 동적 값 전체 합 | 6067288067571.169 | 6067288067571.169 |
| 행에 실린 키 컬럼 | PROJECT_CODE · FROM_SITE_ID · TEXT · PLANT_SITE_ID | END_CUSTOMER40 · CELL_PROD_SITE_ID · TEXT4082 · PLANT_SITE_ID |
| 대상 품목(MCCM349215A1-111) 행 수 | 15 | 15 |

상세 = `GET_BEFORE.json` · `GET_AFTER.json` · `apply_20261112.log`.

## 미확인 · 남은 것
- 화면에서 RTF 재입력 → 저장 → 재조회 왕복은 실행하지 않았다(사용자 확인 필요).
- 기본 개인화(40 전용 컬럼 보유)를 쓰는 다른 40 사용자의 조회 결과 전후 대조는 하지 않았다(치환 대상 컬럼이 없으면 목록이 그대로인 로직).
- 82 사업부도 FE 저장이 `CELL_PROD_SITE_ID` · `TEXT4082` 를 읽는다 — 82 에서 같은 증상이 나는지는 확인하지 않았다.
- 개인화에 `PROJECT_CODE` 와 `END_CUSTOMER40` 이 둘 다 없는 경우는 이 보완으로 해결되지 않는다(행에 프로젝트 키가 없어 여전히 '/' 로 저장).
- 잘못된 키로 저장된 행(10:53:16 · 10:53:49 저장분): `DM_PLN_SALES_PLAN` — Div 40 · IM_CN_NGG · MCCM349215A1-111 · PROJECT_CODE '/' · CELL_PROD_SITE_ID '-' · 6개 메저 × 5개월 = 30행. 삭제하지 않았다(사용자 결정 대기).

## 클라우드
`_artifacts/_deploy_packages/DMF0021_CLOUD_DB_MOD_20261112_1059/` (cloud_pkg 1.4.1 수정본 · BODY 5개 구간 패치 · 사내 리허설 OK · 경고 0). 클라우드 적용·회신 대기.
