# 대조표 ↔ 검증 추적표 v2 — DMF0035 (AS-IS DMF0035) · 2026-10-26T12:50:06

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 401행 (nscm-fe\features\report\src\pages\demand-plan-waterfall\__asis-mapping__.md) · AS-IS 액션 889행(진입점 + 전 문장) = **1290행** → 검사 인스턴스 **672개**
- 행 판정: 미검증 1047 · FAIL 127 · 미구현 71 · 검증완료 27 · 해당없음 18
- 인스턴스 결과: REVIEW 329 · NOT_RUN 126 · FAIL 72 · NA 50 · PASS 38 · BLOCKED 30 · NOPATH 23 · TODO 4

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 32 | 0 | 0 | 1 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 8 | 0 | 0 | 17 | 2 | 0 | 2 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 27 | 0 | 0 | 1 | 0 | 0 | 1 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 24 | 0 | 0 | 4 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 4 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 37 | 0 | 0 | 0 | 0 | 0 | 3 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 6 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 19 | 0 | 0 | 18 | 0 | 0 | 4 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 8 | 0 | 0 | 17 | 0 | 0 | 2 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 26 | 47 | 0 | 24 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 0 | 25 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 78 | 0 | 0 | 0 | 0 | 0 | 17 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | **미구현** | 0 | 0 | 0 | 13 | 0 | 0 | 0 | 0 | 4 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 4 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 10 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 16 | 0 | 0 | 1 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 5 | 0 | 0 | 1 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 17 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 4 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 3 | 1 | 0 | 0 | 팝업 표준·열림 |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 3 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 7 | 0 | 0 | 3 | 0 | 0 | 0 | 9 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 3 | 0 | 0 | 16 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 5 | 0 | 0 | 92 | 0 | 3 | 26 | 2 | 0 | 3 |
| 동적 생성·조회 | 26 | 72 | 0 | 167 | 0 | 0 | 43 | 1 | 0 | 26 |
| 콤보 후보 | 0 | 0 | 0 | 27 | 0 | 2 | 0 | 4 | 4 | 0 |
| Cascade | 0 | 0 | 0 | 17 | 0 | 23 | 11 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 11 | 0 | 22 | 19 | 0 | 0 | 1 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 9 | 0 | 0 | 6 | 5 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 7 | 0 | 0 | 6 | 0 | 0 | 16 | 9 | 0 | 0 |

## FAIL 인스턴스

- X-NOTIMPL|ROW:MODAL:WaterfallVersionModal — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 1행)
- X-LOC|ROW:REQ:CHAT-20260828-UM02-DMF0035 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-UM05-DMF0035 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-UM08-DMF0035 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-C1-DMF0035 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-C2-DMF0035 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-C3-DMF0035 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx 없음, nscm-fe/features/repo (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260828-C4-DMF0035 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx 없음, nscm-fe/feature (대조표 3행)
- X-LOC|ROW:COMMON:UC-05 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W01 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W02 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W35 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W36 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W37 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W38 — 구현 위치 실존 안 함: nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.module.scss 없음 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W39 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W40 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W03 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W04 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W05 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W06 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W07 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W08 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W09 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W10 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W11 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W12 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W13 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W14 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W15 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W16 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W17 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W18 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W19 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W20 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W21 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W22 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W23 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W24 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-NOTIMPL|ROW:REQ:CHAT-20260831-W25 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W26 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W27 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W28 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W29 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W30 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W31 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W32 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:REQ:CHAT-20260831-W33 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 3행)
- X-LOC|ROW:UM-07 — 구현 위치 실존 안 함: components/olap-field-rail/OlapFieldRail.tsx 없음 (대조표 11행)
- X-LOC|ROW:REQ:CHAT-20260831-W44 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260831-W45 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-NOTIMPL|ROW:REQ:CHAT-20260901-X12 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:REQ:CHAT-20260901-X13 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-LOC|ROW:(신규) GUBUN — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:cboDivision(필수) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:clbTeam/Customer/SalesSite/PlantSite/BizType/ItemType — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:clbEDISender (0035, div81만) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:txtProject/ItemId/Owner + 팝업 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:txtVersion + 팝업 3종 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:drpPeriod — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:cboBucketType — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:chkSum/chkColor(chkMem) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:cboCellQty — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:InternalYN (0022) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:cbxQty "Qty≠0" (0051) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:cboKRW/USD/LOC/QTY — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:MSG00137 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:MSG00097 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:MSG00013 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:MSG00108 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:MSG00164 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:(MSG00109) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)

## TODO — 검증 엔진 구현 대상(검사기 없음)

- B3: 17개 — 콤보 후보 정렬 = AS-IS

## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: auth
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- SC1|SCREEN — 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace
- K4|SCREEN — 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke
- M4|COL:M — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- G4|COND:cboDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:cboDivision — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbTeam — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbTeam — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:clbTeam — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbEDISender — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbEDISender — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:clbEDISender — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:txtProject — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtProject — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:txtProject — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- H6|COND:txtProject — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtProject — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- G4|COND:txtVersion — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:txtVersion — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:txtVersion — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- H6|COND:txtVersion — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:txtVersion — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:drpPeriod — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- E4|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00164 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- G4|COND:cboBucketType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:cboBucketType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:chkSum — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:chkColor — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:chkSum — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:chkColor — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:chkSum — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:chkColor — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:cboCellQty — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:cboCellQty — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:cboCellQty — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- A6|SP:P_DMF0035_GET_MKT_FCST_WATERFALL — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0035_GET_MKT_FCST_WATERFALL — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- A6|SP:DMF0073_GET_VERSION_SALESPRICE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DMF0073_GET_VERSION_SALESPRICE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0035_SAVE_VERSION_MRF — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- E4|MSG:MSG00137 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00013 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00108 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00109 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- A5|COL:C — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H5|COL:C — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H2|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COND:chkColor — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- A6|SP:DM0035_GET_MKT_FCST_WATERFALL — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0035_GET_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DM0035_GET_MKT_FCST_WATERFALL — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0035_GET_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:clbSalesSite — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbPlantSite — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbBizType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtItemId — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbItemType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbCustomer — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtOwner — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:cboQTY — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- F4|SP:SCM0001_GET_BIZ_TYPE_BY_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:DMF0003_GET_REPORT_BUCKET_TYPE_CODE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_CUSTOMER_BY_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_LOOKUP_VALUES — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:DMF0003_GET_QTY_TYPE_CODE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_SITE_BY_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:SCM0001_GET_TEAM_BY_DIVISION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G6|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbBizType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:txtItemId — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbItemType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:cboQTY — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbCustomer — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbBizType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbSalesSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbPlantSite — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:txtItemId — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbItemType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:cboQTY — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbTeam — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbCustomer — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbBizType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbEDISender — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:clbItemType — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- C1|COND:cboQTY — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- H5|COND:cboBucketType — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COND:chkSum — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- E4|COND:cboQTY — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:cboDivision — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:clbSalesSite — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:clbPlantSite — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:txtProject — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:txtItemId — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:cboBucketType — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:chkSum — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:chkColor — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- D5|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- C3|COL:C — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- E4|COL:C — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H6|COND:cboDivision — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
