# [SCREEN_ID] — As-Is 정밀 분석

> **이 파일의 역할**: 한 화면의 As-Is 동작을 클로드 코드가 To-Be를 작성할 수 있을 만큼 정밀하게 기록합니다. 비즈니스 룰까지 포함하되, To-Be 설계는 `tobe_design.md`에서 별도로 다룹니다.

작성일: YYYY-MM-DD | 분석자: (Claude / 사용자) | 화면 ID: [SCREEN_ID]

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | [SCREEN_ID] |
| 화면명 (한글) | (예: 마켓 Forecast 입력) |
| 화면명 (영문) | (csproj명) |
| 메뉴 경로 | (예: Demand → Plan → 마켓 Forecast) |
| 도메인 | DM / FP / SCP / SSP / SCM / Common |
| 화면 종류 | Form / Popup / Report / Master / Setup |
| 권한 그룹 | (SystemMgmt 권한 정의에서 식별) |
| 사용 빈도 | 일별 / 주별 / 월별 / 비정기 (운영팀 인터뷰 또는 추정) |

## 2. 화면 구성 (레이아웃)

```
┌────────────────────────────────────────────────────┐
│  Header: [버튼 영역]                                │
├──────────┬─────────────────────────────────────────┤
│  Filter  │  Main Grid                              │
│  (좌)    │                                         │
├──────────┴─────────────────────────────────────────┤
│  Footer: [상태 / 합계]                              │
└────────────────────────────────────────────────────┘
```

(Designer.cs 분석 결과 기반 텍스트 레이아웃 — Phase 2-B 산출 활용)

## 3. 컨트롤 인벤토리

| 컨트롤 | 종류 | 이름 | 역할 | 데이터 바인딩 |
|---|---|---|---|---|
| 검색 영역 | TextBox | txtKeyword | 키워드 검색 | - |
| 검색 영역 | DropDown | cmbDivision | 사업부 선택 | UP_FX_GetCommonDataList |
| 메인 그리드 | FarPoint Spread | spMain | 데이터 표시·편집 | DataSet → SP 결과 |
| 버튼 | Button | btnSearch | 조회 | Click → 조회 SP 호출 |
| 버튼 | Button | btnSave | 저장 | Click → 저장 SP 호출 (트랜잭션) |

## 4. 이벤트 핸들러 (.cs 파일에서 추출)

| 이벤트 | 핸들러 | 동작 요약 | 호출 SP/Endpoint |
|---|---|---|---|
| Form_Load | 화면 초기화 | 사업부 콤보 채우기, 그리드 헤더 설정 | UP_FX_GetCommonDataList |
| btnSearch_Click | 조회 | 입력값 검증 → SP 호출 → 그리드 바인딩 | (도메인)0001_GET_xxx |
| btnSave_Click | 저장 | 그리드 변경 행 식별 → SP 호출 → 결과 표시 | (도메인)0001_SAVE_xxx (TX) |
| spMain_CellChanged | 셀 편집 | 검증 룰 적용, 합계 재계산 | - |

## 5. 비즈니스 룰

(코드 본문에서 추출 — 검증·계산·분기 로직)

- **R1. 입력 검증**: 사업부 미선택 시 조회 불가 → MessageBox 후 return
- **R2. 합계 계산**: 그리드 N열 변경 시 합계 행 자동 갱신 (클라이언트 측)
- **R3. 저장 트랜잭션**: 메인 + 디테일 SP 두 단계 호출. 메인 실패 시 전체 rollback
- **R4. 권한 체크**: 사업부별 사용자 권한 확인 (서버 측 SP 응답 코드)
- ...

## 6. 호출 SP / Endpoint 전수

| 시점 | SP / Endpoint | 입력 | 출력 | 비고 |
|---|---|---|---|---|
| Load | UP_FX_GetCommonDataList | (codeType) | 코드 리스트 | TheOne 표준 |
| Search | (도메인)0001_GET_DATA | (검색 파라미터) | 그리드 데이터 | 행수 제한? |
| Save | (도메인)0001_SAVE_DATA | TVP 또는 datatable | 결과 코드 | 트랜잭션 사용 |
| Validation | (도메인)0001_VALIDATE | (행) | OK/Err 코드 | 즉시 검증 |

## 7. 사용 테이블 (직접 + SP 통한 간접)

| 테이블 | 용도 | 읽기 | 쓰기 |
|---|---|---|---|
| (도메인)_PLN_xxx | 주 데이터 | ○ | ○ |
| SCM_MST_yyy | 마스터 (코드 표) | ○ | - |
| SCM_DNM_zzz | 다이나믹 마스터 | ○ | - |
| TB_FX_USER | 사용자 정보 | ○ | - |

## 8. 외부 시스템 연동

| 외부 시스템 | 호출 시점 | 데이터 | 비고 |
|---|---|---|---|
| NERP | 저장 시 | (도메인) 변경 사항 | NERP_PR_xxx SP 통해 |
| Mail | 저장 후 | 알림 메일 | SCM_ADM_MAIL_SEND |

## 9. 알려진 이슈·기술 부채

(주석·TODO·HACK·XXX 코멘트, 또는 명백한 문제)

- (예: SP 5,000라인 초과로 유지보수 어려움)
- (예: 2025-08 운영 이슈 — 동시저장 deadlock 발생 → trigger로 임시 회피)
- (예: SCM_DNM_STOCK_V_YMH_20251106 사용 — 임시 view)

## 10. 참고

- Legacy 소스: [`source_links.md`](./source_links.md)
- To-Be 설계: [`tobe_design.md`](./tobe_design.md)
- 컴포넌트 매핑: [`web_components.md`](./web_components.md)
- DB 변환 가이드: [`oracle_migration.md`](./oracle_migration.md)
