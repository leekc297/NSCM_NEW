# 대조표 ↔ 검증 추적표 v2 — SCP0111 (AS-IS SCP0111) · 2026-11-05T07:58:30

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 20행 (nscm-fe\features\supply\src\pages\integration-psi\__asis-mapping__.md) · AS-IS 액션 954행(진입점 + 전 문장) = **974행** → 검사 인스턴스 **269개**
- 행 판정: FAIL 475 · 검증완료 365 · 미검증 106 · 해당없음 28
- 인스턴스 결과: NA 140 · PASS 50 · FAIL 31 · REVIEW 28 · ERROR 12 · NOPATH 7 · WARN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H4 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 2 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 7 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 2 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 20 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 5 | 9 | 0 | 2 | 11 | 9 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 2 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 17 | 0 | 0 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 3 | 0 | 0 | 0 | 29 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 2 | 5 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 0 | 6 | 0 | 0 | 0 | 19 | 0 | 2 | 0 | 0 |
| 동적 생성·조회 | 15 | 12 | 1 | 28 | 11 | 14 | 0 | 0 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 0 | 0 | 12 | 0 | 0 | 0 | 0 |
| Cascade | 3 | 0 | 0 | 0 | 0 | 19 | 0 | 0 | 0 | 0 |
| 편집·검증 | 17 | 4 | 0 | 0 | 0 | 64 | 0 | 0 | 0 | 0 |
| CRUD | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 팝업 | 7 | 0 | 0 | 0 | 0 | 10 | 0 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 권한 | 2 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 6 | 5 | 0 | 0 | 0 | 2 | 0 | 5 | 0 | 0 |

## FAIL 인스턴스

- A6|SP:P_SCP0111_GET_INTEGRATION_PSI — 원장 V-b6cf8233 SP / 정렬대조 FAIL 1번째 키부터 다름: AS-IS ['YYYYMM'] ↔ TO-BE ["(CASE WHEN  / 실측[T-071aaf67]: PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI: 첫 정렬 키 YYYYMM 가 그리드 (대조표 59행)
- F1|SCREEN — 원장 V-1a8b7e39 RULE_SCREEN / 원장 V-bded1ccf RULE_SCREEN / 원장 V-56473196 RULE_SCREEN / 원장 V-6f8e8fd5 RULE_SCREEN / 원장 V-82a6d508 GENERAL / 원장 V-e6efca32 GENERAL /  (대조표 383행)
- F6|SCREEN — 원장 V-2220c069 RULE_SCREEN / 원장 V-4b9aa2ea RULE_SCREEN / 원장 V-b3afa86b RULE_SCREEN / 원장 V-65accf87 RULE_SCREEN / 원장 V-e5cea080 RULE_SCREEN / 원장 V-96ed0872 GENERA (대조표 373행)
- F4|SP:P_SCP0111_SAVE_INTEGRATION_PSI — 실측[T-ea67ed5b]: PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 셀을 수정하고 Save 를 눌렀는데 main/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: SAVE call-proc 없음' (FE handl (대조표 371행)
- F4|SP:P_SCP0111_SAVE — 실측[T-03071eab]: P_SCP0111_SAVE: 셀을 수정하고 Save 를 눌렀는데 main/SAVE 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: SAVE call-proc 없음' (FE handleSave 편집 셀 추적/PROC_M SAVE 배선 (대조표 1행)
- F2|SCREEN — 원장 V-b5cfd22a RULE_SCREEN / 원장 V-129ff7c5 RULE_SCREEN / 원장 V-30816eaf GENERAL / 원장 V-800b7aa0 GENERAL / 원장 V-039a88e2 GENERAL / 원장 V-ab7f0b76 GENERAL / 원장 V-978 (대조표 382행)
- F4|SP:P_SCP0111_SAVE_PSI_ADMIN — 실측[T-81330c67]: PKG_SCP0111.P_SCP0111_SAVE_PSI_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/SAVEDETAIL 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: SAVE call-proc 없음' (FE handl (대조표 1행)
- F4|SP:P_SCP0111_SAVE_ADMIN — 실측[T-c715eadc]: P_SCP0111_SAVE_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/SAVEDETAIL 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: SAVE call-proc 없음' (FE handleSave 편집 셀 추적/PR (대조표 1행)
- A6|SP:P_SCP0111_GET_ESS_PACK_LINE — 원장 V-a77f1a53 SP / 정렬대조 FAIL 3번째 키부터 다름: AS-IS ['LINE_ID'] ↔ TO-BE ['SCM_SITE_I / 실측[T-c2eca54f]: PKG_SCP0111.P_SCP0111_GET_ESS_PACK_LINE: 화면 진입·조회 경로에서 이 SP 가  (대조표 1행)
- D6|SCREEN — 원장 V-65789ebc RULE_SCREEN / 원장 V-7b1419f1 RULE_SCREEN / 원장 V-daa3f0ba RULE_SCREEN / 원장 V-309492cc GENERAL / 원장 V-54aee855 GENERAL / 원장 V-f14b1541 GENERAL / 원장 V (대조표 4행)
- F5|SCREEN — 원장 V-9df393e4 RULE_SCREEN / 원장 V-23d0a714 RULE_SCREEN / 원장 V-271762c3 RULE_SCREEN / 원장 V-222881c4 DEFECT / 원장 V-aa1e3d20 GENERAL / 원장 V-31f5eee3 GENERAL / 원장 V- (대조표 1행)
- I1|SCREEN — 원장 V-a09babe7 RULE_SCREEN / 원장 V-20b686a3 RULE_SCREEN / 원장 V-198950ce RULE_SCREEN / 원장 V-fc7c6b51 DEFECT / 원장 V-9f001c14 DEFECT / 원장 V-e90b80e1 DEFECT / 원장 V-15 (대조표 24행)
- H10|SCREEN — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 (대조표 9행)
- E4|MSG:MSG00004 — 원장 V-e52e3323 ASIS / 원장 V-4d16fe68 ASIS / 실측[T-7258c056]: MSG00004: 저장 성공 응답('S') → 결과 메시지 — CRUD 실저장 F1 최종 FAIL: 저장 요청이 나가지 않아 DB 반영 확인 불가 — 수정 저장 경로 강제(edit-s (대조표 3행)
- X-REOPEN|SCREEN — 실측[T-4488b2b4]: 탭 닫기 → 재오픈: 치명 콘솔 0 · 5xx 1 · 재오픈 직후 행 0(최초 진입 0) (대조표 9행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.FindButton — 진입점 집계 3검사 — REVIEW:1 · FAIL:1 · PASS:1 (대조표 1행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.FindData_Main — 진입점 집계 17검사 — NA:7 · PASS:6 · FAIL:3 · REVIEW:1 (대조표 15행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.GetBucketType — 진입점 집계 5검사 — NOPATH:3 · NA:1 · FAIL:1 (대조표 2행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.GetEssPackLineAll — 진입점 집계 5검사 — NOPATH:2 · NA:1 · PASS:1 · FAIL:1 (대조표 6행)
- G4|COND:cboPlanDate — 원장 V-7ea998d1 SEARCH / E2E smoke labels (대조표 4행)
- G4|COND:cboPlanType — E2E smoke labels / 실측[T-d40c573d]: 조회조건 'plan-type, plantype' 은 TO-BE 조회조건 기준표(search_cond.csv) 대상이 아님(기준표에 없는 AS-IS 조건) — TO-BE 룰 CR-071(기준표 정의 조건만) → 검사 대상 아님 (대조표 4행)
- G4|COND:cboDivision — 원장 V-7678aab0 SEARCH / E2E smoke labels (대조표 4행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.InitControls — 진입점 집계 9검사 — PASS:5 · FAIL:3 · NA:1 (대조표 3행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.InsertButton — 진입점 집계 1검사 — FAIL:1 (대조표 1행)
- F4|SP:SCP0111_SAVE_INTEGRATION_PSI_ADMIN — 실측[T-5c60353e]: SCP0111_SAVE_INTEGRATION_PSI_ADMIN: 셀을 수정하고 Save 를 눌렀는데 main/SAVEDETAIL 호출 0건 — Save 버튼이 저장 호출을 내지 않음 · 알림 'SAVE: SAVE call-proc 없음' (FE handleS (대조표 370행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.SaveData — 진입점 집계 26검사 — NA:12 · FAIL:10 · PASS:3 · NOPATH:1 (대조표 21행)
- E4|LEDGER:V-e52e3323 — 원장 V-e52e3323 / 실측[T-606c7349]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) (대조표 1행)
- E4|LEDGER:V-4d16fe68 — 원장 V-4d16fe68 / 실측[T-c1a21167]: 검사 대상 아님 — catch 블록 예외 메시지(프레임워크 공통 오류 표시) (대조표 1행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI.SpdMain_TopChange — 진입점 집계 1검사 — FAIL:1 (대조표 3행)
- H4|SCREEN — 원장 V-612fbb0b RULE_SCREEN / 원장 V-963e0867 RULE_SCREEN / 원장 V-8511f635 RULE_SCREEN / 원장 V-171648d3 RULE_SCREEN / 원장 V-e1592010 RULE_SCREEN / 원장 V-923a13d7 RULE_S (대조표 4행)
- X-ROW|ENTRY:SCP0111_IntegrationPSI._defaultDataModel_Changed — 진입점 집계 6검사 — NOT_RUN:3 · NA:2 · FAIL:1 (대조표 7행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

