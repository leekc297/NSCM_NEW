# 대조표 ↔ 검증 추적표 v2 — SCP0097 (AS-IS SCP0097) · 2026-10-26T12:54:42

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 64행 (nscm-fe\features\supply\src\pages\scp-bom-elec\__asis-mapping__.md) · AS-IS 액션 247행(진입점 + 전 문장) = **311행** → 검사 인스턴스 **296개**
- 행 판정: 미검증 254 · FAIL 33 · 검증완료 21 · 해당없음 3
- 인스턴스 결과: REVIEW 96 · NA 83 · NOT_RUN 39 · FAIL 33 · PASS 32 · NOPATH 11 · TODO 2

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 16 | 0 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 11 | 0 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| X-REASON | 정적 디자인 | 있음 | 3 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 0 | 0 | 0 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 11 | 0 | 0 | 3 | 0 | 0 | 0 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 24 | 33 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 27 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | **미구현** | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 2 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 2 | 0 | 0 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 12 | 0 | 0 | 5 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 12 | 0 | 0 | 5 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E3 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 8 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 6 | 0 | 0 | 0 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 팝업 표준·열림 |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 2 | 0 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 4 | 0 | 0 | 4 | 0 | 45 | 3 | 0 | 0 | 0 |
| 동적 생성·조회 | 24 | 33 | 0 | 53 | 0 | 0 | 7 | 1 | 0 | 0 |
| 콤보 후보 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 6 | 2 | 0 |
| Cascade | 0 | 0 | 0 | 1 | 0 | 21 | 1 | 0 | 0 | 0 |
| 편집·검증 | 0 | 0 | 0 | 32 | 0 | 11 | 19 | 2 | 0 | 0 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 0 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 4 | 0 | 0 | 2 | 0 | 0 | 2 | 0 | 0 | 0 |

## FAIL 인스턴스

- X-LOC|ROW:COMMON:UC-05 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`V1` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:FindButton (cs:220) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:SaveButton (cs:231) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:EditButton (cs:241) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:InsertButton (부재) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:DeleteButton (부재) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:(R5) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W1` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W2` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W3` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W4` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W5` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W6` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W7` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W8` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W9` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W10` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W11` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W12` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`W13` — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:ClbDivision_SelectedIndexChanged — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:dsdmMain.Changed → SpdMain_Changed — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.ActiveSheetChanged — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.CellClick — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.CellDoubleClick — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.ClipboardPasted — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.EditChange — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:spdMain.TopChange — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`Data.Common(Type.MyDivision, false, NowGroupID, UserId)`(cs — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:`SelectCombo(cboDivision,"CODE","81")`(cs:513~519) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:txtParentID/txtChildID.Text(개행→콤마 UsrMultiLineEditor) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:P_DEBUG_MODE='F'(cs:309) — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)

- B3: 4개 — 콤보 후보 정렬 = AS-IS

## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace
- D1|COL:USAGE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:USAGE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:SCP_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:SCP_YN — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: auth
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- K4|SCREEN — 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke
- K-SA|SCREEN — 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke
- E4|MSG:MSG00704 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- D5|COL:SCP_YN — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:STOCK_SUM — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00672 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00006 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- G1|COND:cboDivision — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- E4|COND:cboDivision — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00097 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace
- D1|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- F3|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace
- G6|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace
- G4|COND:cboDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- D1|COL:CREATED_BY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CREATED_BY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:LAST_UPDATE_DATE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:LAST_UPDATE_DATE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- A6|SP:P_SCP0097_GET_SCP_BOM_ELEC — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_SCP0097_GET_SCP_BOM_ELEC — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:txtParentID — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtChildID — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- C1|COND:cboDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- F4|SP:P_SCP0097_SAVE_SCP_BOM_ELEC — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
