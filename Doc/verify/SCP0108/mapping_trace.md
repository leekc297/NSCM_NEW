# 대조표 ↔ 검증 추적표 v2 — SCP0108 (AS-IS SCP0108) · 2026-11-14T18:04:30

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 75행 (nscm-fe\features\supply\src\pages\capa-lob-report\__asis-mapping__.md) · AS-IS 액션 486행(진입점 + 전 문장) = **561행** → 검사 인스턴스 **543개**
- 행 판정: 미검증 364 · 검증완료 130 · FAIL 57 · 해당없음 10
- 인스턴스 결과: ERROR 207 · NA 195 · REVIEW 67 · PASS 40 · FAIL 26 · NOPATH 7 · NOT_RUN 1

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 12 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 24 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 24 | 0 | 0 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 12 | 0 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 18 | 0 | 0 | 51 | 0 | 3 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 2 | 8 | 0 | 10 | 30 | 33 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | 콤보 후보 | 있음 | 4 | 0 | 0 | 0 | 23 | 21 | 0 | 1 | 0 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 2 | 0 | 0 | 0 | 25 | 21 | 0 | 1 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 3 | 5 | 0 | 3 | 0 | 1 | 0 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 10 | 2 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 9 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 1 | 18 | 0 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 2 | 0 | 0 | 0 | 6 | 1 | 0 | 1 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 8 | 0 | 1 | 1 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 3 | 0 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J1 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한 Division 노출 — 계정별 Division 후보·기본값 = 권한(단일 권한 자동 선택) |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 5 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 2 | 12 | 0 | 0 | 45 | 6 | 0 | 2 | 0 | 0 |
| 동적 생성·조회 | 21 | 8 | 0 | 61 | 64 | 72 | 0 | 1 | 0 | 0 |
| 콤보 후보 | 6 | 0 | 0 | 0 | 48 | 42 | 0 | 2 | 0 | 0 |
| Cascade | 3 | 5 | 0 | 3 | 10 | 31 | 0 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 0 | 10 | 40 | 0 | 0 | 0 | 0 |
| CRUD | 1 | 0 | 0 | 0 | 1 | 2 | 0 | 0 | 0 | 0 |
| 팝업 | 2 | 0 | 0 | 3 | 19 | 1 | 1 | 2 | 0 | 0 |
| 공통 기능 | 0 | 1 | 0 | 0 | 1 | 1 | 0 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 0 |
| DB 실행·접근 | 5 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 0 |

## FAIL 인스턴스

- G4|ROW:entryPoints — 행 집계 — 대조표 entryPoints '15' 의 G4 11요소: FAIL:9 · NOPATH:2 · FAIL 요소: rgrpDivisionType / Division Ty — 원장 V-03c504d5 SEARCH / E2E smoke labels — 누락 라벨; cboDivisio (대조표 1행)
- G4|ROW:`components/CapaLobReportForm.tsx` — 행 집계 — 대조표 `components/CapaLobReportForm.tsx` '`usrConditionPanel1`(dsn:133~141) + LayoutControlI' 의 G4 11요소: FAIL:9 · NOPATH:2 · FAIL 요소: rgrpDivisionType / Di (대조표 1행)
- G4|ROW:필수 조회조건 UI(`*`) · Search 전 alert — 행 집계 — 대조표 필수 조회조건 UI(`*`) · Search 전 alert '`DataUtil.InitCheck`(DataUtil:370~622) 전문 read' 의 G4 11요소: FAIL:9 · NOPATH:2 · FAIL 요소: rgrpDivisionType / Division (대조표 1행)
- G4|COND:rgrpDivisionType — 원장 V-03c504d5 SEARCH / E2E smoke labels — 누락 라벨 (대조표 4행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.Form_Load — 진입점 집계 3검사 — NA:1 · ERROR:1 · FAIL:1 (대조표 1행)
- G4|COND:cboDivision — 원장 V-bc1fc362 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:cboVersion — 원장 V-3c4cbfdf SEARCH / 원장 V-06170cb1 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:cboVersionSeq — 원장 V-06170cb1 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:clbSite — 원장 V-8fc61407 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:clbPlant — 원장 V-c1db73c0 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:clbFactory — 원장 V-a7f8eb15 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:clbLine — 원장 V-151cf204 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- G4|COND:clbOperation — 원장 V-35b893a0 SEARCH / E2E smoke labels — 누락 라벨 (대조표 2행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.RefreshDivision — 진입점 집계 1검사 — FAIL:1 (대조표 3행)
- C1|COND:cboDivision — 원장 V-657b342e SEARCH / 실측[T-cd6ab79d]: 상위 조회조건 [Division | Div | Div.] 칸 없음 (대조표 1행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.RefreshFactory — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- C1|COND:clbFactory — 실측[T-ba90725d]: 상위 조회조건 [Building | Factory] 칸 없음 (대조표 1행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.RefreshLine — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- C1|COND:clbLine — 실측[T-b2c54bd0]: 상위 조회조건 [Line] 칸 없음 (대조표 1행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.RefreshOperation — 진입점 집계 2검사 — ERROR:1 · FAIL:1 (대조표 11행)
- C1|COND:clbOperation — 실측[T-08b32c52]: 상위 조회조건 [Operation] 칸 없음 (대조표 1행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.RefreshPlant — 진입점 집계 1검사 — FAIL:1 (대조표 8행)
- C1|COND:clbPlant — 실측[T-9a195eb8]: 상위 조회조건 [Plant] 칸 없음 (대조표 1행)
- K4|SCREEN — 원장 V-dad03d7f GENERAL / 원장 V-200c362c GENERAL / 원장 V-1814b1bd GENERAL / 원장 V-2811f159 GENERAL / 원장 V-43fd03d9 GENERAL / 원장 V-eacbb577 CONFIRMED / 원장 V-daf0906d  (대조표 9행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.btnColumn_Click — 진입점 집계 7검사 — ERROR:4 · FAIL:1 · PASS:1 · NA:1 (대조표 6행)
- X-ROW|ENTRY:SCP0108_CAPA_LOB_Report.btnItem_Click — 진입점 집계 2검사 — ERROR:1 · FAIL:1 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)


## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- H6|COND:txtItem — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
