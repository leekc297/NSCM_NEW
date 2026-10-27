# 대조표 ↔ 검증 추적표 v2 — DMF0044 (AS-IS DMF0044) · 2026-10-26T12:50:50

> 대조표의 **모든 행이 검증 대상**이다(제외·해당없음 행 = 사유 근거 검사 X-REASON). 행마다 카탈로그(`mapping_checks.csv`)가 정한 검사를 대상 단위 인스턴스로 묶어 판정한다.
> **NOT_RUN** = 검사기 있음·이 대상 미실행 · **TODO** = 검사기 미구현(검증 엔진 구현 대상) · **BLOCKED** = 대조표 상태 미구현(구현 엔진 대상 — 구현 후 검증) · REVIEW = 판정필요

- 대상: FE 대조표 244행 (nscm-fe\features\demand\src\pages\sales-reports\__asis-mapping__.md) · AS-IS 액션 1992행(진입점 + 전 문장) = **2236행** → 검사 인스턴스 **1167개**
- 행 판정: 미검증 2043 · FAIL 157 · 해당없음 22 · 미구현 14
- 인스턴스 결과: REVIEW 526 · NOT_RUN 308 · FAIL 152 · NOPATH 80 · PASS 60 · BLOCKED 24 · NA 12 · TODO 5

## 검사별

| 검사 | 층 | 검사기 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED | 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 12 | 0 | 0 | 14 | 0 | 0 | 0 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 5 | 0 | 0 | 10 | 3 | 0 | 1 | 조회조건 표시·라벨·활성 |
| H10 | 정적 디자인 | 있음 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 메시지 표준(방식·코드 단일화) |
| H2 | 정적 디자인 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 11 | 0 | 0 | 0 | 배경·글자색 규칙 |
| H3 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 셀 병합 = AS-IS |
| H4 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 레이아웃·스크롤·크기 |
| H5 | 정적 디자인 | 있음 | 0 | 0 | 0 | 11 | 0 | 0 | 13 | 0 | 0 | 0 | 라벨 명칭 |
| I1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | LBL/MSG 언어별 등록 |
| SC1 | 정적 디자인 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 순서 = 기준표 |
| X-REASON | 정적 디자인 | 있음 | 21 | 0 | 0 | 18 | 0 | 0 | 0 | 0 | 0 | 0 | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| A1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 42 | 0 | 0 | 0 | 0 | 0 | 4 | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A10 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 4 | 0 | 0 | 11 | 0 | 0 | 0 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 |
| G03-WIRE | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G1 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 22 | 0 | 0 | 10 | 0 | 0 | 4 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 9 | 0 | 0 | 1 | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | 동적 생성·조회 | 있음 | 7 | 145 | 0 | 26 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-NOTIMPL | 동적 생성·조회 | 있음 | 0 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 대조표 상태 미구현 = 구현 대상(FAIL) |
| X-REOPEN | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-ROW | 동적 생성·조회 | 있음 | 0 | 0 | 0 | 196 | 0 | 0 | 0 | 0 | 0 | 1 | 대조표 행이 서술한 동작을 화면에서 재현 |
| B1 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 1 | 콤보 후보 빈 행 없음 |
| B2 | 콤보 후보 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 6 | 0 | 1 | 콤보 후보 중복 없음 |
| B3 | 콤보 후보 | **미구현** | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 5 | 0 | 콤보 후보 정렬 = AS-IS |
| B4 | 콤보 후보 | 있음 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 8 | 0 | 1 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C1 | Cascade | 있음 | 0 | 0 | 0 | 5 | 0 | 0 | 5 | 0 | 0 | 0 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C2 | Cascade | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 8 | 0 | 0 | 0 | 그리드 셀 cascade 후보 |
| C3 | Cascade | 있음 | 0 | 0 | 0 | 10 | 0 | 0 | 23 | 0 | 0 | 0 | 연쇄 자동 채움 |
| C4 | Cascade | 있음 | 0 | 0 | 0 | 0 | 0 | 5 | 0 | 0 | 0 | 0 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C6 | Cascade | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 8 | 0 | 0 | 0 | 무변경 편집 종료 시 연쇄 미발동 |
| D1 | 편집·검증 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 18 | 0 | 0 | 0 | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | 편집·검증 | 있음 | 0 | 0 | 0 | 22 | 0 | 0 | 18 | 0 | 0 | 0 | 행 값 기반 조건부 잠금 |
| D4 | 편집·검증 | 있음 | 0 | 0 | 0 | 6 | 0 | 0 | 1 | 0 | 0 | 2 | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | 편집·검증 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 16 | 0 | 0 | 1 | 셀 에디터 유형 |
| D6 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | Insert 위치·상태 유지 |
| E1 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 숫자 소수자리·정수·부호·범위 |
| E2 | 편집·검증 | 있음 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 날짜 형식·유효성 |
| E3 | 편집·검증 | 있음 | 16 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 필수 입력 검증 |
| E4 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 44 | 0 | 0 | 6 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| E5 | 편집·검증 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 콤보 셀 후보 외 값 차단 |
| F1 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 1회 저장(변경 감지) |
| F3 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | CRUD Status 표시 정합 |
| F6 | CRUD | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 저장 후 값 보존 |
| G5 | 팝업 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 0 | 19 | 0 | 0 | 팝업 조건 연동(인자) |
| H6 | 팝업 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 5 | 14 | 0 | 0 | 팝업 표준·열림 |
| M3 | 팝업 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 15 | 0 | 0 | 0 | 팝업 내부 기능(조회·CRUD) |
| M4 | 팝업 | 있음 | 0 | 0 | 0 | 18 | 0 | 0 | 21 | 0 | 0 | 0 | 팝업 선택값 반영 |
| G3 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회조건 저장·복원 |
| K-SA | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 조회영역 토글 |
| K4 | 공통 기능 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 버튼 구성·조건별 노출 |
| J2 | 권한 | 있음 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 권한별 버튼·기능 |
| DB-SYN | DB 실행·접근 | 있음 | 15 | 0 | 0 | 11 | 0 | 0 | 0 | 20 | 0 | 0 | BE 계정 시노님·권한·대상 객체 |
| F4 | DB 실행·접근 | 있음 | 0 | 0 | 0 | 12 | 0 | 0 | 35 | 0 | 0 | 0 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |

## 층별

| 층 | PASS | FAIL | WARN | REVIEW | ERROR | NA | NOT_RUN | NOPATH | TODO | BLOCKED |
|---|---|---|---|---|---|---|---|---|---|---|
| 정적 디자인 | 22 | 0 | 0 | 64 | 0 | 4 | 51 | 3 | 0 | 1 |
| 동적 생성·조회 | 7 | 152 | 0 | 296 | 0 | 0 | 32 | 1 | 0 | 10 |
| 콤보 후보 | 0 | 0 | 0 | 14 | 0 | 0 | 0 | 20 | 5 | 3 |
| Cascade | 0 | 0 | 0 | 27 | 0 | 5 | 44 | 0 | 0 | 0 |
| 편집·검증 | 16 | 0 | 0 | 48 | 0 | 3 | 98 | 1 | 0 | 10 |
| CRUD | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 2 | 0 | 0 |
| 팝업 | 0 | 0 | 0 | 54 | 0 | 0 | 41 | 33 | 0 | 0 |
| 공통 기능 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 0 | 0 |
| 권한 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| DB 실행·접근 | 15 | 0 | 0 | 23 | 0 | 0 | 35 | 20 | 0 | 0 |

## FAIL 인스턴스

- X-LOC|ROW:E01 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E01-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E01-3 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 (대조표 1행)
- X-LOC|ROW:E01-4 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:E01-5 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E02 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 (대조표 1행)
- X-LOC|ROW:E03 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:E03-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E03-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E04 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E04-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts 없음 (대조표 1행)
- X-LOC|ROW:E04-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.save.ts 없음 (대조표 1행)
- X-LOC|ROW:E05 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E05-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E05-5 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음, components/modals/MeasureSelectModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E06 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E07 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:E08 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:E08-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:E08-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:E09 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E09-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E09-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:E10 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:E11 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 (대조표 1행)
- X-LOC|ROW:A-1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:A-12 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:A-14 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:A-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 (대조표 1행)
- X-LOC|ROW:A-3 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:D-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:D-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:D-3 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:D-4 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-01 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-02 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-03 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-04 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-05 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-06 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-07 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-08 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-09 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-10 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-11 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-12 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-13 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-14 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-15 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-16 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-17 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-18 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-19 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-20 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-21 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:L-24 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-26 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-27 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-28 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-29 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:L-30 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:M-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:M-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:M-3 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:M-4 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음, nscm-fe/features/demand/src/pages/sales-reports/uti (대조표 1행)
- X-LOC|ROW:M-5 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:M-6 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts 없음 (대조표 1행)
- X-LOC|ROW:M-7 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts 없음 (대조표 1행)
- X-LOC|ROW:M-8 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-1 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 (대조표 1행)
- X-LOC|ROW:V-10 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-11 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-12 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-13 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-14 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 (대조표 1행)
- X-LOC|ROW:V-15 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 (대조표 1행)
- X-LOC|ROW:V-16 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 (대조표 1행)
- X-LOC|ROW:V-17 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-18 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-19 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-2 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:V-20 — 구현 위치 실존 안 함: components/versionModal/version-modal.constants.ts 없음 (대조표 1행)
- X-LOC|ROW:V-21 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-22 — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-23 — 구현 위치 실존 안 함: components/versionModal/version-modal.api.ts 없음 (대조표 1행)
- X-LOC|ROW:V-3 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:V-4 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:V-5 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 (대조표 1행)
- X-LOC|ROW:V-6 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts 없음 (대조표 1행)
- X-LOC|ROW:V-7 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:V-8 — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E02:SEARCH — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E03:EDIT — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:CRUD:E04:SAVE — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:MODAL:ExchangeRateModal — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:MODAL:SalesReportsModals — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx 없음 (대조표 1행)
- X-LOC|ROW:MODAL:TextboxModal — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:MODAL:MeasureSelectModal — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/modals/MeasureSelectModal.tsx 없음 (대조표 1행)
- X-NOTIMPL|ROW:COMMON:UC-01 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-02 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-03 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-04 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-05 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-06 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-NOTIMPL|ROW:COMMON:UC-07 — 대조표 상태 미구현 — 구현 엔진 대상(impl_engine.py → 구현 대기열) (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-4 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-5 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-6 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-7 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-8 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-9 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-10 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-11 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-12 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:REQ:CHAT-20260820-13 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 2행)
- X-LOC|ROW:1 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:2 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:3 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:4 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:5 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:6 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:7 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:8 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:— — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00283 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00281 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00321 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00002 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00004 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00006 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00142 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00314/00016/00195 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00318/319/320 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00096 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:MSG00279/280/156/143/151 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 (대조표 1행)
- X-LOC|ROW:HANDLER:DeleteButton — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:EditButton — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:ExcelButton — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:FindData — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/useSalesReportsStore.ts 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:Form_Load — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:InsertRow — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:SaveData — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:btnExchangeRate_Click — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:btnMeasure_Click — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:btnSPVer_Click — 구현 위치 실존 안 함: components/versionModal/VersionModal.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:btnTextbox_Click — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:clbDivision_SelectedIndexChanged — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/SalesReports.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:clbType_SelectedIndexChanged — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:spdMain_CellDoubleClick — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)
- X-LOC|ROW:HANDLER:spdMain_Changed — 구현 위치 실존 안 함: nscm-fe/features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx 없음 (대조표 1행)

## TODO — 검증 엔진 구현 대상(검사기 없음)

- B3: 12개 — 콤보 후보 정렬 = AS-IS

## NOT_RUN — 검사기 있음·실행 필요(상위 200)

- SC1|SCREEN — 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke
- J2|SCREEN — 검사기 있음(auth·authcrud spec) — 실행 필요: auth
- M4|BTN:btnSPVer — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnMeasure — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnExchangeRate — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|BTN:btnTextbox — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- F1|SCREEN — 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud
- D6|SCREEN — 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace
- F5|SCREEN — 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace
- K-SA|SCREEN — 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke
- G3|SCREEN — 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke
- G4|COND:clbDivision — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:clbType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:usrYear — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:usrDataType — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G4|COND:txtSPVersion — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G1|COND:clbDivision — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:clbType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:usrYear — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:usrDataType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtSPVersion — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:clbType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:usrYear — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:usrDataType — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G6|COND:txtSPVersion — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- H6|COND:clbDivision — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:clbType — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:usrYear — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:usrDataType — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- H6|COND:txtSPVersion — 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke
- M4|COND:clbDivision — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COND:clbType — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COND:usrYear — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COND:usrDataType — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|COND:txtSPVersion — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|POPUP:DMF0044_United_VersionPopup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- E4|MSG:MSG00688 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- I1|SCREEN — 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta
- M4|POPUP:DMF0044_SalesReportExchangePopup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- M4|POPUP:DMF0044_SalesReport_TextboxPopup — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- C2|COL:DEPARTMENT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- C3|COL:DEPARTMENT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace
- C6|COL:DEPARTMENT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- M4|COL:ITEM_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:EDIT_FLAG — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:EDIT_FLAG — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:MEASURE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:DEPARTMENT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DEPARTMENT_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:DEPT_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DEPT_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:CUTOFF_YYYYMMDD — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CUTOFF_YYYYMMDD — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:NICK_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:NICK_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:SCM_SITE_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:SCM_SITE_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:PROJECT_CODE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:PROJECT_CODE — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:APPLICATION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:APPLICATION — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:BIZ_TYPE_NAME — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:BIZ_TYPE_NAME — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:BIZ_TYPE_NAME40 — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:BIZ_TYPE_NAME40 — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:DMS_SALES — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DMS_SALES — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:DMS_CUSTOMER — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DMS_CUSTOMER — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D4|COL:MEASURE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace
- A5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H5|COL:DIVISION_ID — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H2|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- M4|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DIVISION_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- M4|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- M4|COL:CURRENCY — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- D1|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:CURRENCY — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D1|COL:DEPT_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D1|COL:CUST_REPORT — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace
- D3|COL:DEPT_ID — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- D3|COL:CUST_REPORT — 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace
- H5|COND:usrYear — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- E4|COND:chkResult — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00314 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|COND:txtSPVersion — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00283 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- F4|SP:PKG_DMF0044 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F3|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace
- E4|MSG:MSG00429 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- K4|SCREEN — 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace
- M4|COL:SEND_YN — 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace
- E4|COL:SEND_YN — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00685 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00682 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00281 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00321 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00681 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00002 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00004 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00006 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00618 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00142 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00680 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00318 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00096 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- E4|MSG:MSG00279 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- M3|POPUP:DMF0044_MDFVersionPopUp — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace
- A10|SCREEN — 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace
- X-REOPEN|SCREEN — 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace
- A6|SP:DM0021_GET_DM_MST_VERSION — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:DM0021_GET_DM_MST_VERSION — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- G1|COND:clbDivisions — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtDes — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:txtType — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G1|COND:drpPeriod — 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke
- G6|COND:drpPeriod — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:drpPeriod — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- G6|COND:clbDivisions — 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace
- G4|COND:clbDivisions — 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke
- C1|COND:clbDivisions — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- A5|COL:VERSION_NO — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:VERSION_TYPE — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:VERSION_DESCRIPTION — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:YYYYMMDD — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|PCOL:VER_CRE_SEQ — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- A5|PCOL:LAST_UPDATED_BY — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- A5|PCOL:LAST_UPDATE_DATE — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: tr
- H2|COL:VERSION_NO — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:VERSION_TYPE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:VERSION_DESCRIPTION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:YYYYMMDD — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|PCOL:VER_CRE_SEQ — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|PCOL:LAST_UPDATED_BY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|PCOL:LAST_UPDATE_DATE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:VERSION_NO — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:VERSION_TYPE — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:VERSION_DESCRIPTION — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:YYYYMMDD — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|PCOL:VER_CRE_SEQ — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|PCOL:LAST_UPDATED_BY — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|PCOL:LAST_UPDATE_DATE — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:DIVISION_ID — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:VERSION_NO — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:VERSION_TYPE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:VERSION_DESCRIPTION — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:YYYYMMDD — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|PCOL:VER_CRE_SEQ — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|PCOL:LAST_UPDATED_BY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|PCOL:LAST_UPDATE_DATE — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- E4|MSG:MSG00143 — 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: trace
- H4|SCREEN — 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace
- M3|POPUP:DMF0044_SalesReportExchangePopup — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace
- A6|SP:P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP_DATA — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- C1|COND:clbDivision — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- A5|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:CURRENCY — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- A5|COL:UNIT_CURRENCY — 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Division 별)) — 실행 필요: sm
- H2|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H2|COL:UNIT_CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace
- H5|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:CURRENCY — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- H5|COL:UNIT_CURRENCY — 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace
- D5|COL:CURRENCY_UNITCURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- D5|COL:UNIT_CURRENCY — 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace
- F4|SP:P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- C1|COND:usrYear — 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace
- M3|POPUP:DMF0044_SalesReport_TextboxPopup — 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace
- A6|SP:P_DMF0044_GET_TEXTBOX — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- A6|SP:P_VERSION_NO — 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) A6 조회 결과 행 순서 실측) —
- F4|SP:P_DMF0044_GET_TEXTBOX — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_VERSION_NO — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DMF0044_SAVE_TEXTBOX — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_CREATED_BY — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION1 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION10 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION11 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION12 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION13 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION2 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION3 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION4 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION5 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION6 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION7 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION8 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
- F4|SP:P_DESCRIPTION9 — 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace
