# 확정 룰 → 하네스 등록 현황 (2026-10-29 09:43)

- 확정 룰 76건 · 하네스 등록(생성·게이트에서 강제) 13건 · **정합검증만(사후 검출) 63건**
- 미등록 룰의 규칙 분포: K2 9 · A5 7 · K1 6 · B4 4 · H4 4 · C2 3 · N1 3 · M1 3 · L2 3 · G1 3 · B6 3 · G2 3

## 하네스 등록됨

| CR | 규칙 | 대상 | 강제 위치 |
|---|---|---|---|
| CR-005 | H6 | 전체 팝업 버튼 순서 | check.js 팝업 표준(버튼 순서) · 정합검증 H6 |
| CR-007 | H6;K1;K3 | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리 | check.js 팝업 No. 컬럼 · 정합검증 H6/K3 |
| CR-032 | I1;N1;I4 | LBL/MSG/MENU 코드 사전 | gen-register-sql · check.js I18N2/I18N3 · msgmap MS1 · check-pkg P41 |
| CR-057 | F5 | Delete 버튼·CRUD Status D Flag | 공용 DataGrid CRUD D Flag · 정합검증 F5 |
| CR-063 | I2;I1 | 조회 결과 총/건 표기 | 공용 SubTitle 총/건 표기 · 정합검증 I2 |
| CR-064 | H8 | 총 건수 표시 | 공용 SubTitle 총 건수 · 정합검증 H8 |
| CR-070 | J2;K4;D4;F1 | 공통버튼 Insert(F8)/Delete(F9)/Save(F7)/Upload 노출 | FE 공용 SubTitle 권한 게이트(CR-070) · PR_GET_MNU_BTN_AUTH_DIV · 정합검증 J2/K4 · KEEP F6 |
| CR-071 | H5;G4;SC1;SC2;G1;G6 | SCP·SSP 조회조건(순서·사용여부·라벨) | gen.js search_cond.csv 자동 적용 · check.js SC1/SC2 · KEEP E11 · 정합검증 H5_CR071/G4 |
| CR-072 | H2 | 팝업 입력 셀(FPModal · 더블클릭 팝업으로 값이 채워지는 셀, 예 BOD Route | hook grid-cell-backcolor-standard §1 2-b · KEEP D4 · 정합검증 H2(popupCell) |
| CR-073 | H3 | 그리드 셀 세로 병합 대상 컬럼 | hook datagrid-shared-component §5.4 · KEEP D3 · 정합검증 H3_CR073 |
| CR-074 | D6 | 그리드 Insert 신규행 위치 | 공용 DataGrid Insert 기본(맨 위) · 정합검증 D6_CR074 · hook #144 주석 |
| CR-075 | A6 | 그리드에 표시되는 조회 SP 의 결과 순서 | check-pkg P42 · port_pkg.md §정렬 · KEEP H15 · 정합검증 sort_check CR-075 + golden _order_check |
| CR-076 | DB-SYN,F4 | 앱 계정(SCMP_APP)이 쓰는 DB 객체(PKG·콤보 SQL 테이블/뷰·시노님·권한) | syn_check.py · syn_fix.py · run_verify 차단 게이트 · judge BLOCKER(DB-SYN 행) · make_verify_docs 요약 배너/조치 필요 1번 |

## 정합검증만 — 등록 후보(생성·보완 단계 강제 없음)

| CR | 규칙 | 대상 | 판정 방법 | 등록 제안 |
|---|---|---|---|---|
| CR-001 | A5;K2 | 컬럼/Measure 셋팅(개인화 Default) | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-002 | B4;C1;B8 | 조회조건 Sales Site·End Customer·Sold to Customer·Plan | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-003 | H4;H9 | Main Grid 컬럼 폭 | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-004 | G5 | 팝업 연결 조회조건·그리드 컬럼 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-006 | H7 | Excel Download 양식(공통 모듈) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-008 | I1;I2 | 팝업 메시지 다국어(MSG00445 등) | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-009 | K1 | 그리드 필터(F4) | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-010 | B2;B3;B4 | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-011 | A5;K2 | 컬럼셋팅 팝업 Default | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-012 | C2 | 그리드 End Customer→Sold-to Customer cascade | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-013 | N1;K1 | Company 컬럼 공란 데이터 | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-014 | C2 | 그리드 Sales Company→Sales Plant · Sales Site→Company | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-015 | D4;D1;K1;D6 | Insert 시 Project 컬럼 · Sort | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-016 | H2 | 입력 불가 컬럼 배경색 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-017 | M1 | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | STATIC+E2E+DB | check.js/check-pkg 정적 게이트 |
| CR-018 | H2;D2 | 실적 구간 배경색 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-019 | B8;C3;A2 | Team 컬럼(MKT FCST 조회·신규행) | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-020 | N1 | AS From Site 공란 데이터 | META | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-021 | J1 | Division 조회조건 후보 | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-022 | H10 | 편집 중 타 기능 실행 메시지(MSG00680) | STATIC+E2E | check.js/check-pkg 정적 게이트 |
| CR-023 | L2 | 조회조건(Model·Owner 등) 키 입력 · Main Grid | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-024 | A5;K2;F6 | 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | META+E2E+DB | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-025 | G1;G8;L2;H4 | Lookup 텍스트 조회조건 · 화면 깜빡임 · 상단 Grid 스크롤 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-026 | J1;J4 | Division 기본값 · 메뉴 트리(Admin-System) | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-027 | C3;C2;E4;E5 | Sales Company·Sales Plant 셀 | E2E+DB | check.js/check-pkg 정적 게이트 |
| CR-028 | D4;C4;A5 | Insert 행 Div · Div 변경 시 그리드 | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-029 | G3;K4 | Condition(F6) 저장 · Sales Report ETC Insert 기능 | STATIC+E2E | check.js/check-pkg 정적 게이트 |
| CR-030 | B6;G2;G7 | 조회조건 Item Type | STATIC+META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-031 | H3 | 그리드 셀 병합(신규 입력 중) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-033 | K1;K3 | 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-034 | K1 | 그리드 Sort 토글(동적 영역 포함) | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-035 | M1 | Excel Upload 헤더 검증 메시지 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-036 | M1;E4 | Excel Upload Validation 메시지(Sales Site/Project/Mod | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-037 | K3 | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-038 | H3 | 셀 병합(계층 병합) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-039 | H4 | 화면 축소 시 조회조건·스크롤 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-040 | G2;B6 | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중  | STATIC+E2E | check.js/check-pkg 정적 게이트 |
| CR-041 | K2;A5 | Column Setting 필수 컬럼 표시·Div 전환 End Customer | E2E+META | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-042 | M3;F2;M2;M4 | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-043 | H7;A2 | Excel Download(TEAM·FCST Type·Measure·Project) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-044 | A5;K2 | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | E2E+META | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-045 | K2 | 컬럼·메저 셋팅 Save/OK 재조회 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-046 | M4 | 팝업 입력 컬럼 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-047 | A3;A10 | Sum 행 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-048 | K3 | 그리드 헤더 클릭 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-049 | H6 | 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | STATIC+E2E | check.js/check-pkg 정적 게이트 |
| CR-050 | G1;M3 | 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-051 | H4 | 조회조건·버튼 배치 / 조회조건 콤보 드롭다운 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-052 | F1;F8 | Created By/Date·Updated By/Date 컬럼 | E2E+DB | check.js/check-pkg 정적 게이트 |
| CR-053 | A5;K2 | 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | E2E+META | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-054 | K1 | Message ID 컬럼 필터 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-055 | G1;G8 | API Name 조회조건 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-056 | L2;L1 | 조회조건 텍스트 입력 중 그리드 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-058 | K2 | Measure 순서·메저셋팅 순서 저장 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-059 | B4 | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales S | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-060 | H10 | 저장 완료 플로팅 팝업 배경색 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-061 | K2 | Measure 순서 | E2E | 공용 컴포넌트(DataGrid/SearchArea) 기본 동작 — 컴포넌트 단위 테스트 |
| CR-062 | H6;G5 | From City 검색 버튼 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-065 | G4;H5 | 조회조건 명칭·순서 / 대응 컬럼명 | STATIC+E2E | check.js/check-pkg 정적 게이트 |
| CR-066 | G2;B6 | 멀티선택 조회조건 Select ALL | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-067 | I1;I2 | 메시지 문구 | META+E2E | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
| CR-068 | H3;D1 | 병합 셀 콤보 입력 | E2E | 검토: E2E 동작 규칙 — 생성 템플릿(gen.js) 주석/골격 또는 E2E smoke 표준 항목 |
| CR-069 | B4;N1 | Sales Plant 셀 콤보(3050 Plant) | E2E+META | 메타 등록 SQL 템플릿(gen-register-sql) 또는 check.js 메타 게이트 |
