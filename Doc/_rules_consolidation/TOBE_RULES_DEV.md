# TO-BE 개발 규칙 — 설계부터 소스 개발까지 지켜야 할 것

> **자동 생성 문서 — 직접 고치지 않는다.** 원천을 고친 뒤 `python tools/Harness/verify/tobe_rule_registry.py --build` 로 다시 만든다.
> 원천: `tools/Harness/rules/confirmed_requirements.csv`(CR) · `design_decisions.csv`(DD) · `sp_replaced.csv` · `allowed_gaps.csv` · `label_alias.csv` · 종류 지정 `tobe_rule_kind.csv`
> 생성 2026-11-19 13:40:58 · 통합 원장 `tools/Harness/rules/tobe_rule_registry.csv`

- 확정 요건(CR) **89**건 · 정밀 룰 문서 15개 · 작업 hook 문서 156개 · 경로별 규약 4개
- 이 문서는 **목록과 위치**를 한곳에 모은 것이다. 룰 본문은 각 원천 문서에 있고, 기계 판정 위치는 '강제 지점' 열(실측)과 §2 표에 있다.
- '생성 연결' 열: 화면·PKG·메타 **생성 단계**에서 강제되면 OK, 사후 검증에서만 잡히면 GEN_UNLINKED, 코드에 룰 번호가 없으면 NO_ENFORCER.

## 1. 확정 요건 (CR) — TO-BE 가 지켜야 할 동작

| 룰 | 범위 | 대상 | 요건 | 검사 규칙 | 생성 연결 | 강제 지점(실측) | 출처 |
|---|---|---|---|---|---|---|---|
| CR-001 | ALL | 컬럼/Measure 셋팅(개인화 Default) | 개인화 정보가 없는 사용자는 모든 화면에서 선택 Div 의 UI Category Default 컬럼·Measure 구성으로 표시한다(Div 전환 시 재구성). | A5;K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-C1 전체 UI(컬럼/measure 개인화 default) |
| CR-002 | ALL | 조회조건 Sales Site·End Customer·Sold to Customer·Plant Site·Tea | Team(DEPT) 콤보·cascade 의 원천은 모든 화면에서 SCM_MST_SITE_ITEM(SSPM).DEPT_ID 로 한다. | B4;C1;B8 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-C2 전체 UI(Combo data) |
| CR-003 | ALL | Main Grid 컬럼 폭 | 개인화 폭이 없을 때 모든 Main Grid 컬럼 기본 폭은 기준정보(META) width 로 하며 그 값은 헤더 문구 길이 이상이어야 한다. | H4;H9 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-C4 전체 UI(Auto Size) |
| CR-004 | ALL | 팝업 연결 조회조건·그리드 컬럼 | 팝업이 연결된 모든 조회조건·셀은 입력된 텍스트를 팝업 조건으로 전달하여 바로 필터된 결과를 보여준다. | G5 | GEN_UNLINKED | popup_args_check.py:13;popup_args_check.py:564 | DM-C5 전체 UI (조회조건) |
| CR-005 | ALL | 전체 팝업 버튼 순서 | 모든 팝업의 확인/닫기 버튼 순서는 OK → CLOSE 로 통일한다. | H6 | OK | _verify.spec.ts:904;ledger.py:639;ledger.py:744 | DM-C6 전체 팝업 UI (팝업) |
| CR-006 | ALL | Excel Download 양식(공통 모듈) | 모든 Excel Download 는 공통 모듈로 테두리 없음·헤더 틀고정·UI Category fixed 컬럼 틀고정을 적용한다. | H7 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-C7 공통 |
| CR-007 | ALL | 전체 팝업 No. 컬럼·건수 · Contribution Sales Version 팝업 그리드 | 모든 팝업 그리드는 공통 그리드를 사용하여 No. 컬럼과 조회·필터 건수를 표시하고 단축키·Sort 동작을 메인 그리드와 동일하게 한다. | H6;K1;K3 | OK | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-C8 전체 팝업 UI |
| CR-008 | ALL | 팝업 메시지 다국어(MSG00445 등) | FE 에서 사용하는 모든 MSG/LBL 코드는 KO/EN/CN 3개 언어로 등록되어 런타임 언어와 일치해야 한다. | I1;I2 | GEN_UNLINKED | eg_ingest.py:252;eg_ingest.py:255 | DM-P4 공통(다국어) |
| CR-009 | ALL | 그리드 필터(F4) | 모든 그리드에서 필터(F4) 해제 시 필터 조건이 초기화되고 전체 행이 복원된다. | K1 | GEN_UNLINKED | _verify.spec.ts:4067 | DM-P6 공통(Grid 필터) |
| CR-010 | ALL | 그리드 Combo(Sales Site 화면 Insert 시 End Customer·Sold-to Custom | 모든 그리드 셀 콤보 후보는 중복 없이 원천 정렬 순서로 표시되고 비어 있지 않아야 한다. | B2;B3;B4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P8 공통(Combo 정렬) |
| CR-011 | ALL | 컬럼셋팅 팝업 Default | 개인화 정보가 없으면 컬럼셋팅 팝업·그리드는 선택 Div 의 Default 컬럼으로 구성한다. | A5;K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-26 Sales Price |
| CR-012 | ALL | 그리드 End Customer→Sold-to Customer cascade | 그리드의 상위 셀(End Customer 등) 선택·변경 시 종속 셀 후보를 재구성하고 이미 선택된 종속 값은 초기화한다. | C2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P3 Sales Site |
| CR-013 | ALL | Company 컬럼 공란 데이터 | 모든 기준 데이터의 공란은 단일 센티널로 통일하여 필터의 Blanks 항목이 하나로 표시되게 한다. | N1;K1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P5 Sales Site |
| CR-014 | ALL | 그리드 Sales Company→Sales Plant · Sales Site→Company/Plant | 그리드 cascade 는 전 화면 전수 정의대로 상위 변경 시 하위 후보 재구성·값 초기화를 수행한다. | C2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P11 Sales Site Project Model |
| CR-015 | ALL | Insert 시 Project 컬럼 · Sort | 모든 화면에서 필터·Sort 적용 여부와 관계없이 Insert 는 선택행 위에 추가되고 Sort/Filter 상태와 신규행 편집 가능 여부가 유지된다. | D4;D1;K1;D6 | GEN_UNLINKED | eg_auth.spec.ts:508;eg_auth.spec.ts:509;gen_expect.py:1128 | DM-32 Demand manager |
| CR-016 | ALL | 입력 불가 컬럼 배경색 | 모든 화면에서 입력 불가 셀 배경은 흰색, 편집 가능 셀은 노랑의 표준 3색을 따른다. | H2 | GEN_UNLINKED | _trace.spec.ts:2412;_trace.spec.ts:2467 | DM-33 Demand manager |
| CR-017 | ALL | Excel Upload 컬럼명 검증 메시지 · 파일 첨부 개수 | 모든 Excel Upload 는 파일 1개만 선택 가능하고 양식 컬럼명 불일치 시 사용자 문구로 안내한다. | M1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-34 Customer FCST Upload |
| CR-018 | ALL | 실적 구간 배경색 | 실적 구간(편집 불가 과거 기간) 셀은 표준 구간색(회색)으로 표시한다. | H2;D2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-38 MKT FCST |
| CR-019 | ALL | Team 컬럼(MKT FCST 조회·신규행) | Owner 소속팀이 아닌 SSPM DEPT_ID 를 Team 으로 표시·세팅하는 규칙을 Team 을 보여주는 모든 화면에 적용한다. | B8;C3;A2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-40 MKT FCST |
| CR-020 | ALL | AS From Site 공란 데이터 | 빈 값은 단일 센티널로 저장·표시하고 Blank/NULL/센티널 혼재를 0 으로 한다. | N1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-41 MKT FCST |
| CR-021 | ALL | Division 조회조건 후보 | 모든 화면의 Division 후보는 로그인 사용자의 그룹 중 해당 메뉴 권한을 가진 그룹의 Div 만으로 구성한다. | J1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-44 MKT FCST |
| CR-022 | ALL | 편집 중 타 기능 실행 메시지(MSG00680) | 편집 중인 데이터가 있을 때 다른 기능 실행을 막는 메시지는 모든 화면에서 단일 코드(MSG00680)를 사용한다. | H10 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-52 FCST&PRICE MGMT |
| CR-023 | ALL | 조회조건(Model·Owner 등) 키 입력 · Main Grid | 모든 화면에서 조회조건 키 입력·변경은 조회 버튼 전까지 그리드를 재렌더·이동시키지 않는다. | L2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-53 FCST&PRICE MGMT |
| CR-024 | ALL | 필수 컬럼(Project Code·Plant Site) 표시 · 저장 | Div 전환 시 개인화 구성에 해당 Div 의 필수 컬럼이 없으면 자동 추가하여 필수 컬럼이 항상 표시되게 한다. | A5;K2;F6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-61 FCST&PRICE MGMT |
| CR-025 | ALL | Lookup 텍스트 조회조건 · 화면 깜빡임 · 상단 Grid 스크롤 | 모든 텍스트 조회조건은 대소문자 무관하게 조회되고, 입력 중 화면 깜빡임이 없어야 한다. | G1;G8;L2;H4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-63 Lookup |
| CR-026 | ALL | Division 기본값 · 메뉴 트리(Admin-System) | 메뉴 트리는 사용자 권한 그룹에 연결된 메뉴만 노출하고 노출 메뉴는 404 없이 열려야 한다. | J1;J4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-65 FCST&PRICE MGMT |
| CR-027 | ALL | Sales Company·Sales Plant 셀 | 콤보 셀은 Key-in 으로 후보 외 값이 저장되지 않도록 차단(또는 검증)한다. | C3;C2;E4;E5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-70 Sales Site Project Model |
| CR-028 | ALL | Insert 행 Div · Div 변경 시 그리드 | 신규행의 Div 기본값은 조회조건 Div 로 하고, 조회조건 Div 변경 시 그리드를 초기화하여 이전 Div 행이 남지 않게 한다. | D4;C4;A5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-71 Sales Site |
| CR-030 | ALL | 조회조건 Item Type | 조회조건 콤보 후보는 코드가 아닌 Name 으로 표시한다(전 화면). | B6;G2;G7 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-83 Business Plan |
| CR-031 | ALL | 그리드 셀 병합(신규 입력 중) | 그리드 편집(신규 행 입력·붙여넣기) 중에는 셀 병합을 해제하고, 병합은 조회 결과 표시에만 적용한다 | H3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-91 Business Plan |
| CR-032 | ALL | LBL/MSG/MENU 코드 사전 | 동일 문구(KO/EN 동일)의 LBL/MSG/MNU 코드는 하나만 채번하고 모든 화면이 재사용한다 | I1;N1;I4 | OK | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-96 공통(label) |
| CR-033 | ALL | 결과 그리드 Sort/Filter(동적 주차 컬럼 W37-0817 등) | 그리드 모든 영역(고정·동적 Bucket 컬럼 포함)에서 Sort/Filter/Hide 가 동일하게 동작해야 한다 | K1;K3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P26 Sales Price |
| CR-034 | ALL | 그리드 Sort 토글(동적 영역 포함) | 그리드 Sort 는 오름차순→내림차순→해제(원 순서 복원) 3단 토글로 동작하며 동적 컬럼에도 동일 적용한다 | K1 | GEN_UNLINKED | _verify.spec.ts:3022;_verify.spec.ts:4008;_verify.spec.ts:4067;eg_auth.spec.ts:495;eg_popup.spec.ts:451 | DM-P31 Sales Price |
| CR-035 | ALL | Excel Upload 헤더 검증 메시지 | 모든 Excel Upload 는 헤더명을 양식과 대조하여 불일치 시 업로드를 차단하고 "Invalid Column Header Title" 를 표시한다 | M1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-104 Customer FCST Upload |
| CR-036 | ALL | Excel Upload Validation 메시지(Sales Site/Project/Model) | Excel Upload 검증 오류는 행·항목별 실제 원인 메시지를 모두 표시하며 무관한 메시지로 대체하지 않는다 | M1;E4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-105 Customer FCST Upload |
| CR-037 | ALL | 그리드 Ctrl+클릭 다중 선택(Version 팝업 포함) | 모든 그리드(팝업 포함)는 Ctrl+클릭 비연속 다중 선택과 Shift/드래그 연속 선택을 지원한다 | K3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-116 전체 UI(Ctrl) |
| CR-038 | ALL | 셀 병합(계층 병합) | 앞(상위) 키 컬럼이 병합된 그룹 안에서는 후속 키 컬럼도 계층 병합하며 중간에 병합되지 않은 셀이 없어야 한다 | H3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-120 MKT FCST Comparison |
| CR-039 | ALL | 화면 축소 시 조회조건·스크롤 | 브라우저 폭이 줄어도 조회조건은 최소 크기를 유지하고 화면 전체에 1개 스크롤만 생긴다 | H4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-128 공통 |
| CR-040 | ALL | Key-in 조회조건(Project·Model/Nickname·Owner 등) 콤마 다중 입력 | Key-in 텍스트 조회조건(Project·Model/Nickname·Owner 등)은 모든 화면에서 공통 컴포넌트로 콤마 다중 입력을 허용하고 입력 값 전부를 조회한다 | G2;G9;B6 | GEN_UNLINKED | _verify.spec.ts:3974;judge.py:1003;ledger.py:437 | DM-129 전체 UI(조회조건, 콤보) |
| CR-041 | ALL | Column Setting 필수 컬럼 표시·Div 전환 End Customer | 컬럼셋팅 팝업의 필수 컬럼(USER_SELECTED_FLAG=N)은 빨간색으로 표시하고 해제·이동 불가 시 다국어 메시지를 표시한다 | K2;A5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-P60 Customer FCST Waterfall |
| CR-042 | ALL | Exchange Rate 팝업(Save 건수·Close/재오픈·BPS I/F) | 팝업을 Close 하면 미저장 편집은 폐기되고 재오픈 시 원천 데이터를 다시 조회한다 | M3;F2;M2;M4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-146 FCST&PRICE MGMT |
| CR-043 | ALL | Excel Download(TEAM·FCST Type·Measure·Project) | 모든 화면의 Excel Download 는 코드 컬럼을 Name 으로 표시하고 화면 컬럼 구성과 동일하게 출력한다 | H7;A2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-150 Sales Plan |
| CR-044 | ALL | Div 전환 컬럼 구성·컬럼셋팅 OK 반영 | 컬럼셋팅 OK 시 팝업이 닫히면서 그리드 컬럼을 즉시 재구성하며 모든 화면이 동일하게 동작한다 | A5;K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-152 Sales Plan |
| CR-045 | ALL | 컬럼·메저 셋팅 Save/OK 재조회 | 컬럼·메저 셋팅 팝업에서 변경 없이 Save/OK 하면 재조회하지 않는다 | K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-158 FCST&PRICE MGMT |
| CR-046 | ALL | 팝업 입력 컬럼 | 팝업으로 값을 입력하는 셀은 팝업에서 선택하는 즉시 셀에 값을 표시한다 | M4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-161 전체 UI(입력 data) |
| CR-047 | ALL | Sum 행 | 조회 전 빈 그리드에는 Sum/Subtotal 행을 표시하지 않는다 | A3;A10 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-170 Demand Plan Waterfall |
| CR-048 | ALL | 그리드 헤더 클릭 | 모든 그리드는 헤더 클릭 시 해당 열 전체를 선택하며 화면 간 동작이 동일해야 한다 | K3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-176 전체UI(GRID HEADER) |
| CR-049 | ALL | 팝업 No. 컬럼(Model/Owner/Project/Version 팝업) | 모든 팝업 그리드는 No. 컬럼을 1개만(공통 코너 헤더) 적정 폭으로 표시한다 | H6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-179 Sales Site Project Model |
| CR-050 | ALL | 텍스트 조회조건 Like 검색(Owner 팝업 User Name/EN) | 모든 화면·팝업의 텍스트 조회조건은 부분일치(Like) 검색이 동작하고 검색 대상 컬럼(ID·명칭·영문명)을 모두 포함한다 | G1;M3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-181 Sales Site Project Model |
| CR-051 | ALL | 조회조건·버튼 배치 / 조회조건 콤보 드롭다운 | 모든 화면은 노트북 해상도에서 조회조건·버튼이 겹치지 않고 콤보 드롭다운 항목이 잘리지 않아야 한다 | H4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-182 전체 UI(해상도) |
| CR-052 | ALL | Created By/Date·Updated By/Date 컬럼 | 모든 저장 화면은 Insert 시 Created/Updated 를 세팅하고 Update 시 Updated 만 갱신하며 Created 는 변경하지 않는다 | F1;F8 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-183 Group Menu |
| CR-053 | ALL | 컬럼셋팅 Company ID(필수 표시·Invisible 이동) | 컬럼셋팅에서 필수 컬럼은 Invisible 영역으로 이동할 수 없고, 사용자가 선택한 컬럼은 조회 결과에 반드시 표시되어야 한다 | A5;K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-185 Sales Plan |
| CR-054 | ALL | Message ID 컬럼 필터 | 모든 그리드 필터 후보는 조회 결과의 전체 고유값을 표시해야 하며 개수 상한으로 잘리지 않아야 한다 | K1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-194 Message |
| CR-055 | ALL | API Name 조회조건 | 모든 화면·팝업의 텍스트 조회조건은 대/소문자를 구분하지 않고 검색해야 한다 | G1;G8 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-201 Menu Botton |
| CR-056 | ALL | 조회조건 텍스트 입력 중 그리드 | 모든 화면은 조회조건 입력 중 그리드를 재렌더(깜박임)하지 않아야 한다 | L2;L1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-206 일부 UI(깜박임) |
| CR-057 | ALL | Delete 버튼·CRUD Status D Flag | Active 컬럼으로 사용여부를 관리하는 화면은 Delete 시 신규행만 제거하고 기존행에 D Flag 를 표시하지 않는다 | F5 | OK | _trace.spec.ts:1144;_trace.spec.ts:1155;_trace.spec.ts:1170;_trace.spec.ts:1172;mergecheck.ts:34;judge.py:3042 | DM-207 전체 UI(D Flag) |
| CR-058 | ALL | Measure 순서·메저셋팅 순서 저장 | 메저셋팅 버튼이 있는 모든 화면은 메저셋팅 순서를 저장하고 조회 결과 Measure 를 그 순서로 표시한다 | K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-210 전체 UI(measure 기준) |
| CR-059 | ALL | Active 관리 마스터 기반 조회조건(End Customer·Sold to·Sales Site·Model/ | Active 로 관리되는 마스터 기반 조회조건은 Active Y/N 과 무관하게 전체 데이터를 후보로 표시한다(입력용 셀 콤보와 구분) | B4 | GEN_UNLINKED | active_policy.py:6;eg_ingest.py:262 | DM-211 전체 UI(combo기준변경) |
| CR-060 | ALL | 저장 완료 플로팅 팝업 배경색 | 저장 완료 등 플로팅/토스트 메시지는 모든 화면에서 공통 스타일(배경색)로 표시한다 | H10 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-228 FCST&PRICE MGMT |
| CR-061 | ALL | Measure 순서 | 메저셋팅이 있는 모든 UI 는 저장된 메저셋팅 순서대로 Measure 를 표시한다 | K2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-244 Demand Plan Waterfall |
| CR-062 | ALL | From City 검색 버튼 | 모든 조회조건 팝업 호출 버튼은 테두리 포함 표시 영역 전체 클릭 시 팝업을 호출해야 한다 | H6;G5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SCPSSP-4 공통 |
| CR-063 | ALL | 조회 결과 총/건 표기 | 조회 결과 건수 표기(총 N건)는 KO/EN/CN 모든 언어 리소스로 표시한다 | I2;I1 | OK | gen_expect.py:1125 | SCPSSP-5 공통 |
| CR-064 | ALL | 총 건수 표시 | 건수·수량 표시값은 모든 화면에서 공통 숫자 포맷터(천단위 구분)를 적용한다 | H8 | OK | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SCPSSP-6 공통 |
| CR-065 | ALL | 조회조건 명칭·순서 / 대응 컬럼명 | 모든 화면 조회조건 명칭·순서는 표준표(search_cond)와 일치하고, 명칭 변경 시 대응 그리드 컬럼명도 동일하게 변경한다(Model/Nickname 제외) | G4;H5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SCPSSP-15 BOD |
| CR-066 | ALL | 멀티선택 조회조건 Select ALL | 모든 멀티선택 조회조건의 Select ALL 은 전체 선택/해제를 토글해야 한다(공통 기능 동기화) | G2;B6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SCPSSP-20 BOD |
| CR-067 | ALL | 메시지 문구 | FE 가 사용하는 모든 MSG/LBL 코드는 언어별로 등록되어 '_' 폴백이 노출되지 않아야 한다 | I1;I2 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SCPSSP-24 BOD |
| CR-068 | DMF0049 | 병합 셀 콤보 입력 | 병합 유지 상태로 입력 가능 | H3;D1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | DM-245 ETC Sales Reports |
| CR-069 | DMF0005 | Sales Plant 셀 콤보(3050 Plant) | SCM_MST_PLANT Active Flag=Y 인 Plant 만 후보 표시 | B4;N1 | GEN_UNLINKED | active_policy.py:7;combo_oracle.py:1083 | DM-178 Sales Site Project Model |
| CR-070 | ALL | 공통버튼 Insert(F8)/Delete(F9)/Save(F7)/Upload 노출 | 공통버튼은 화면에 그 기능이 있고(hotkeyConfig 핸들러) 사용자(조회조건 Division 이 단일이면 그 Division 단위권한 그룹)에게 버튼 코드 권한이 있을 때만 노출한다. AS-IS 가 기능 없는 버튼(override 본문 공백)을 일괄 노출해도 TO-BE 는 숨긴다(= PASS). Division 선택이 바뀌면 권한을 다시 조회해 노출을 바꾼다(cascade). | J2;K4;D4;F1 | OK | eg_auth.spec.ts:136;eg_auth.spec.ts:166;eg_auth.spec.ts:168;eg_auth.spec.ts:169;eg_auth.spec.ts:315;eg_auth.spec.ts:333;eg_auth.spec.ts:344; | 사용자 지시 2026-10-26 (공통버튼 권한·기능 기준 노출 · Division cascade) |
| CR-075 | ALL | 그리드에 표시되는 조회 SP 의 결과 순서 | 그리드에 표시되는 조회 결과는 결정적 순서를 가져야 한다. ① 조회 SP(TO-BE PKG)에 ORDER BY 가 없으면 AS-IS 에도 없었더라도 오류(FAIL) — TO-BE PKG 에 ORDER BY 를 추가한다(DB 객체 보완). ② AS-IS 가 그리드/코드 정렬(SmartColMerge·SetSort 등)로 순서를 만들었으면 TO-BE 도 같은 키로 정렬해야 하며 누락은 오류. ③ 예외: 그리드에 바인딩되지 않는 룩업·보조 SP(countryCity 등)와 결과 1행 집계 SP(routeCnt)는 대상 아님(NA 사유 기재). ④ 빈 값 정렬 위치: MSSQL 은 '' 를 맨 앞, Oracle 은 NULL 을 맨 뒤에 두므로 ORDER BY 컬럼에 NULLS FIRST(또는 NVL 센티널)를 적용 | A6 | OK | port_pkg.md:34;judge.py:272;judge.py:295;judge.py:1085;judge.py:1089;judge.py:1092;sort_check.py:284;sort_check.py:310 …(+8) | 사용자 판정 2026-10-28 ("조회 QUERY 에 ORDER 가 없거나, GRID COLUMN SET 에 따라 SORT 가 적용되어야 하는 |
| CR-076 | ALL | 앱 계정(SCMP_APP)이 쓰는 DB 객체(PKG·콤보 SQL 테이블/뷰)·메타(MNU·PROC_M·SHE | ⑤ 범위(사용자 2026-10-29 추가): DB 객체가 없거나 오류(INVALID·인자 불일치) · 메타가 없거나 오류 · 시노님이 없거나 오류 — 세 경우 모두 비정상 테스트 결과를 결함으로 보이지 않고 'DB 객체/메타 오류' 로 명확히 보인다. 시노님·DB 객체가 없거나 권한이 없어(ORA-00942/00904/01031/04043/06550, SYN_MISSING·PRIV_MISSING·TARGET_MISSING·INVALID) 테스트가 제대로 돌지 못하면 ① 그 오류를 CheckList '조치 필요' 1번에 객체명·원인·조치 SQL(CREATE SYNONYM/GRANT)과 함께 명기하고 ② 같은 행에 'CheckList 재작성 요청'(조치 뒤 재실행해야 실제 검증이 시작됨)을 기재한다 ③ 못 돈  | DB-SYN,F4 | OK | test.ts:102;nscm.ts:872;make_verify_docs.py:288;make_verify_docs.py:405;syn_check.py:130 | 사용자 지시 2026-10-29 ("시노님이 없어서 실행이 안되는 경우에는 시노님 추가하고, 시노님 없어서 오류발생한 이력 남겨주세요" · "시 |
| CR-078 | ALL | 조회조건 Division 콤보(DIVISION_ID 단일 선택 화면) · 하위 조회조건 · 전 그리드 | Div 를 1개만 선택하는 화면은 Div 변경 시 모든 그리드와 하위 조회조건을 초기화한다(CR-028 그리드 초기화 + 조회조건 초기화 확장). | C1;C4;A4 | GEN_UNLINKED | _trace.spec.ts:358;_trace.spec.ts:361 | SSP45REQ-1 공통요건 |
| CR-079 | ALL | 조회조건 콤보 후보 · 그리드 셀 콤보 후보(combo SQL 원천) | 조회조건·그리드 셀 콤보 후보 집합은 AS-IS 원천(+Div·권한·상위값 필터)과 같아야 하며 차이는 분석 후 확정 요구로 등록한다. | B4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-3·SSP45REQ-19 공통요건 |
| CR-080 | ALL | 조회조건 콤보 cascade(상위 → 하위 후보) | 조회조건의 상위 값이 바뀌면 하위 콤보 후보가 AS-IS 규칙대로 재구성되고 선택값은 초기화(ALL)된다. | C1 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-4 공통요건 |
| CR-081 | ALL | 조회조건 콤보 single/multi select | 단일/다중 선택 조회조건은 사양(기준표)대로 단일·복수·ALL 선택이 가능하고 선택값이 조회 결과에 그대로 반영된다. | G1;B6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-5 공통요건 |
| CR-082 | ALL | 공통 버튼 Reset Condition(F10) | Reset Condition(F10) 클릭 시 모든 조회조건이 화면 초기 기본값으로 복원된다. | G3;G6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-12 공통요건 |
| CR-083 | ALL | 팝업 조회조건 텍스트(콤마 다중값) | 팝업 조회조건 텍스트도 콤마로 여러 값을 입력하면 모든 값이 조회되고 결과는 그 값들만 포함한다(CR-040 의 팝업 확장). | G9;M3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-14 공통요건 |
| CR-084 | ALL | 그리드 편집 가능 컬럼(INPUT_TP_CD · AS-IS EDIT(F2) 컬럼) | AS-IS 에서 EDIT(F2) 모드로 편집되던 컬럼은 TO-BE 에서 별도 편집 모드 없이 조회 직후부터 편집 가능해야 한다. | D1 | GEN_UNLINKED | insertpre.ts:95;facts_lockrules.py:258;facts_lockrules.py:776;snap_validate.py:117 | SSP45REQ-15 공통요건 |
| CR-085 | ALL | 공통 버튼 Delete(F9) · CRUD Status D · DB 삭제 반영 | Delete(F9) 는 신규행은 즉시 제거하고 기존행은 D 상태로 표시한 뒤 Save 시 DB 에서 삭제되어야 한다(Active 관리 화면은 CR-057). | F5;F1 | GEN_UNLINKED | _trace.spec.ts:1144 | SSP45REQ-17 공통요건 |
| CR-086 | ALL | 그리드 셀 에디터 유형(CELL_CONTROL_OBJECT_TYPE_CODE FPComboBox/FPModa | 그리드 셀의 콤보/팝업 에디터는 AS-IS 와 같은 컬럼에 같은 종류(콤보·팝업·호출 팝업)로 구성되어야 한다. | D5 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-18 공통요건 |
| CR-087 | ALL | 공통 버튼 Save(F7) 기존행 수정 + Insert 신규행 | Save 는 기존행 수정분과 Insert 신규행을 1회 저장으로 DB 에 반영하고 재조회 후 입력값이 변형 없이 보존되어야 한다. | F1;F2;F6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-20 공통요건 |
| CR-088 | ALL | 다중 그리드 더블클릭 연동 | 그리드가 여러 개인 화면의 더블클릭 연동은 AS-IS 와 같이 동작하고 상단 그리드는 재조회·깜빡임 없이 유지되며 팝업 선택값은 즉시 반영된다. | C5;K6;M4 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-21 공통요건 |
| CR-089 | ALL | 그리드 팝업 셀 Key-in(FPModal 컬럼) 잘못된 값 | 팝업으로 고르는 셀에 Key-in 한 잘못된 값은 AS-IS 와 같은 방식으로 검증(되돌림 또는 검증 메시지)되어야 한다. | E7 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-23 공통요건 |
| CR-090 | ALL | 그리드 필수 컬럼(USER_SELECTABLE_FLAG=N · 라벨 *) 미입력 저장 | 필수 컬럼이 비어 있는 행을 저장하면 어떤 컬럼이 필수인지 알리는 검증 팝업을 띄우고 저장을 차단하며 성공 메시지를 표시하지 않는다. | E3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-24 공통요건 |
| CR-091 | ALL | 그리드 필수 컬럼 Setting(Div 별 META) · 컬럼셋팅 필수 표시 · 저장 필수 검증 | 그리드 필수 컬럼은 Div 별 META(USER_SELECTABLE_FLAG=N)로 정의하고 컬럼셋팅의 필수 표시와 저장 필수 검증 집합이 그 정의와 일치해야 한다(검증 방법은 UI 협의 필요 — 원천 비고). | A5;K2;E3 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | SSP45REQ-25 공통요건 |
| CR-094 | ALL | Reset Condition(F10) | Reset Condition 은 서버에 저장된 조회조건만 삭제하고 화면 조회조건 값은 유지한다(AS-IS 동작). 문서 SSP45REQ-12 의 초기값 복원 요구보다 이 확정이 우선한다. | G3;G6 | NO_ENFORCER | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 결정 2026-10-30·2026-10-31 |
| CR-105 | ALL | 차등 검증(같은 인자로 AS-IS SP ↔ TO-BE PROC 실행 대조)의 결과 판정 | 값 불일치와 행·키 집합 차이는 판정에서 뺀다(해당없음으로 두고 근거를 표시한다). 판정은 결과 컬럼 집합, 공통 행 정렬 순서, 조건 로직 대조로 하고 차이가 있으면 FAIL 이다. TO-BE 조회 자체가 실패하면 FAIL 이다. CR-101 의 판정필요 처리와 차등 검증 정렬의 판정필요 처리(CR-075)를 대체한다. | A7;A1;A5;A6 | OK | diff_ingest.py:77;diff_ingest.py:79 | 사용자 결정 2026-11-16('값 대조를 빼고 컬럼·정렬·조건만 대조해 판정' → '그렇게 판정') · 목표 미검증·미판단 0 |
| CR-107 | ALL | 사용자별 숨김 컬럼의 조회·편집 상태별 폭 처리 | TO-BE 는 편집 버튼이 없어 조회·편집 상태 구분이 없다(CR-084·093). 조회 상태 접기·편집 상태 복원 동작은 구현 대상 아님(NA 로 근거 표시). | H9;A5 | OK | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 확정 2026-11-17 일괄 질의 Q8 · 결정 21 · AS-IS SCP0104_CAPA_Line_Assign.cs:4371-4493 |
| CR-108 | SCP0104 | Operation group(Division Type) 변경 시 그리드 처리 | AS-IS 는 그리드만 비우고 TO-BE 는 비운 뒤 자동 재조회한다. TO-BE 동작을 인정한다(PASS 로 근거 표시). | C4 | OK | (코드에 룰 번호 없음 — ledger 의 CONFIRMED 행 + 산문 기대만) | 사용자 확정 2026-11-17 일괄 질의 Q25 · AS-IS BeforeFindData InitSpread |

## 2. 영역별 문서 룰 ↔ 기계 판정 위치 (`tools/Harness/rules/tobe_rules.md` 취합)

| 영역 | 문서 룰 (원천) | 하네스 판정 위치 | 상태 |
|---|---|---|---|
| 화면 폴더·파일 7종 | `_rules_v2/_tobe/01_file_structure.md`, `.claude/rules/00-fe-screen.md` §B | gen.js 가 그대로 생성 · check.js S01 | 판정 |
| import 별칭·feature 간 금지 | `_tobe/02_imports.md`, 금지 Top 11 #1·#2 | forbidden F01/F02 | 판정 |
| Page 조합(MainTitle/Form/SubTitle/Grid) | `_tobe/03_main_component.md` | gen.js 템플릿 · check.js S03 | 판정 |
| Store(createPersistedStoreWithTab, 검색조건 저장/복원 G1) | `_tobe/04_store.md`, `_mapping/asis_to_tobe.md` §2 | gen.js 템플릿(fetchStaticColumns + search-conditions) | 생성만 |
| constants(MENU_ID/SHEETS 케이싱) | `_tobe/05_constants.md` | gen.js · check.js S00/G01 | 판정 |
| SearchArea/FormItem/콤보 변환/inline 금지 | `_tobe/06_search_area.md` §1·§3·§4 | check.js S02 · forbidden F13/F14/F15 | 판정 |
| 조회조건 카탈로그 13종 + 콤보ID | `_tobe/06_search_area.md` §6, `_dictionary/01_search_conditions.md` | **map_field.csv** → gen.js (카탈로그 필드·콤보ID·LBL) | 판정(생성) |
| 컨트롤 타입 매핑 | `_mapping/asis_to_tobe.md`, `06_search_area.md` §5 | **map_control.csv** · check.js D01(사전 밖 컴포넌트) | 판정 |
| 버튼 → SubTitle/팝업/단축키 | `_tobe/09_subtitle_hotkey.md`, `10_popup_modal.md` | **map_button.csv** → gen.js | 생성만 |
| 이벤트 배선(그리드/폼) | `_tobe/07_datagrid.md`, `09_WIJMO_VALIDATION_EXPRESSION.md` | **map_event.csv** → 스텁 · check.js G03 | 판정(존재) |
| Grid 컬럼 메타 / 하드코딩 허용 | `_tobe/08_column_meta.md`, `_dictionary/02_sheet_columns.md` | gen.js(META→staticColumns, HARDCODED→HARD_COLUMNS) · forbidden F10 | 판정 |
| CRUD_TYPE 전용·행상태 필드 금지 | `check-ui-gates.ps1` G-A | forbidden F06 (중복 판정 — 둘 다 유지) | 판정 |
| 빈 catch·콤보 quoting | `check-ui-gates.ps1` G-F/G-G | forbidden F11 (quoting 은 기존 hook 유지) | 판정 |
| As-is 대사(엔드포인트·이벤트·컨트롤·시트) | `.claude/rules/00-fe-screen.md` §D, `asis-coverage-check` | **__asis-mapping__.md** 생성 + check.js M01~M05/G01~G04 | 판정 |
| 의도된 차이(레이아웃 아티팩트·내장 버튼·SPREAD_TITLE→메타·공통 콤보 SP) | `_mapping/asis_to_tobe.md` 격차 결정, `__asis-mapping__.md` 해당없음 사유 1,747행 | **allowed_gaps.csv** | 판정 |
| Validation/Expression 100% | `09_WIJMO_VALIDATION_EXPRESSION.md`, `Doc/_analysis/.../validation.md·expressions.md` | gen.js → `hooks/use{Page}Validation.ts`(V-nnn 마커)·`use{Page}Expression.ts`(E-nnn) · check.js V01(마커 수 = MD 행 수, 누락 BLOCK) / V02(apply TODO 잔존, final BLOCK) | 판정 |
| SP 등록 4 메타 테이블 | `08_SCREEN_REGISTRATION.md` | gen.js `register.json`(3-키 초안) — 등록 자체는 클라우드 | 생성만 |
| BE 표준(Controller/Service/MyBatis) | `_tobe/11_be_controller_service.md`, `04_BE_RULES.md` | forbidden F08/F09(scope java — check.js 는 FE 폴더만 봄) | 후보(BE 체크 미연결) |
| MSSQL→Oracle 치환 | `02-db-sql.md`, `project_db_migration_rules` | forbidden F07(scope sql) · 기존 `check-dbeaver-sql.ps1` | 기존 hook |
| i18n MSG/LBL 코드 | `_categories/07_i18n_msg.md` | forbidden F12(미확정 코드) · map_field.csv lbl | 판정 |
| SCP·SSP 라벨 명칭 변경(Valid→Active · 조회조건·그리드·팝업 그리드 일괄) | KEEP `H21` · `40_SEARCH_COND.md` 명칭 변경 룰 · `confirmed_requirements.csv CR-092`(사용자 지시 2026-10-30) | **label_alias.csv**(scope·asis_label·tobe_label) → check.js LB1(소스 라벨 리터럴 · FINAL BLOCK)/LB2(TO-BE 메타 · WARN) · judge H5_CR092(AS-IS Valid↔TO-BE Active=PASS)/CR092_LEFT(TO-BE 잔존=CR-092 FAIL) · `_trace.spec` H5(COL·PCOL, labelalias.ts) · mapping_trace E3 | 판정 |

## 3. TO-BE 정밀 룰 문서 (15개 · `Doc/_rules_v2/_tobe/`)

| 문서 | 제목 | 첫 설명 줄 |
|---|---|---|
| `00_SCREEN_ANATOMY.md` | TO-BE 00 — Screen Source Anatomy (소스 내부 골격 청사진) | **추출 reference**: DMF0004 (sales-site) / DMF0005 (sales-site-project-model) / DMF0006 (customer-model-mapping) |
| `01_file_structure.md` | TO-BE 룰 01 — 파일 구조 / 폴더 구조 | **추출 reference**: DMF0004 (sales-site) / DMF0005 (sales-site-project-model) / DMF0006 (customer-model-mapping) / DMF0007 (customer-forecast-master) |
| `02_imports.md` | TO-BE 룰 02 — Import 표준 (alias / 정확 export) | **추출 reference**: DMF0004~7 의 모든 import 통합 |
| `03_main_component.md` | TO-BE 룰 03 — 메인 컴포넌트 (PageName.tsx) 표준 | **추출 reference**: DMF0006 (단순) + DMF0004 (multi-sheet) + DMF0005 (Panel) + DMF0007 (Dynamic) |
| `04_store.md` | TO-BE 룰 04 — Store (Zustand) 표준 | **추출 reference**: DMF0006 (단순 store) + DMF0004 (multi-sheet filters) + DMF0007 (dateColumns 동적) |
| `05_constants.md` | TO-BE 룰 05 — Constants (MENU_ID / SHEETS / RESPONSE_SET) | **추출 reference**: DMF0006 (단순) + DMF0004 (multi-sheet + RESPONSE_SET) + DMF0007 (SHEET_INDEX) |
| `06_search_area.md` | TO-BE 룰 06 — SearchArea / Form / 조회조건 | **추출 reference**: DMF0006 (modal cell 단순) / DMF0004 (extraConditions / Checkbox) / DMF0007 (required + userId 자동 + limitTags) |
| `07_datagrid.md` | TO-BE 룰 07 — DataGrid (Wijmo FlexGrid wrapper) 표준 | **추출 reference**: DMF0006 (단순) + DMF0004 (modal cell + cascade) + DMF0007 (dynamicColumns) |
| `08_column_meta.md` | TO-BE 룰 08 — Column Meta (`_inputEditType` / `_ctrlType` / `_modalKey`) | **추출 reference**: `@foundation/constants` 의 CELL_INPUT_EDIT_TYPE / CELL_CONTROL_TYPE + DMF0007 dateColumns + 메모리 `feedback_grid_editable_coloring_mandatory.md`  |
| `09_subtitle_hotkey.md` | TO-BE 룰 09 — SubTitle + hotkeyConfig (CRUD 6대 + Search Aux 4대 + Excel) | **추출 reference**: 4 reference 화면 모두 동일 패턴 + 메모리 `feedback_asis_button_mapping_mandatory.md` + `feedback_search_aux_default_activation.md` |
| `10_popup_modal.md` | TO-BE 룰 10 — Popup / Modal (CustomDialog + 공용 modal 11종) | **추출 reference**: `@master/components/index.ts` 의 11 공용 modal + DMF0006 / DMF0004 의 modal 사용 패턴 + 메모리 `reference_public_modals_master_components.md` + `feedback |
| `11_be_controller_service.md` | TO-BE 룰 11 — BE 동적 SP 호출 아키텍처 (NSCM 표준) | ⚠️ **전면 재작성 (2026-06-04)**: Phase 6 PoC 에서 사용자 지적으로 룰 11 의 Spring Boot 표준 패턴 (BodController 등 화면별 Controller) 이 NSCM 실제 아키텍처와 **불일치** 발견. 동적 SP 호출 아키텍처 + 메타 SQL |
| `12_metadata_sql.md` | TO-BE 룰 12 — 메타 SQL (BLOCK 1~7 + Lookup combo + AS-IS → Oracle 변환) | **추출 reference**: `_artifacts/{N}_DMF{XXXX}_*.sql` 의 BLOCK 1~7 표준 + 메모리 `feedback_sql_idempotent_insert_all.md` / `feedback_sql_dual_output.md` / `feedback_dbea |
| `13_routing_menu.md` | TO-BE 룰 13 — Routing / Menu (MNU_URL slug + route-paths.ts + 메뉴 미표시 디버깅) | **추출 reference**: `nscm-fe/apps/web/src/app/router/route-paths.ts` (추정) + 메모리 `reference_scm_adm_mnu_m_url_slug.md` / `feedback_mnu_uppr_case_standard.md` / `fe |
| `__TEMPLATE__.md` | TO-BE 룰 v2 작성 템플릿 — `{NN}_{rule_topic}.md` | **사용 의무**: `_tobe/` 폴더의 각 룰 파일은 이 템플릿 구조 100% 준수. anti-simplification 동일 적용. |

## 4. 경로별 규약 (4개 · `.claude/rules/` — 해당 경로 파일을 만질 때 자동 로드)

| 문서 | 제목 | 첫 설명 줄 |
|---|---|---|
| `00-fe-screen.md` | FE 화면 규약 (nscm-fe/** 를 만질 때 자동 로드) — 구 CLAUDE.md Step 3 / 3.5 / 4 / §5 FE / §6 F | - "nscm-fe/**" |
| `01-be.md` | BE 규약 (nscm-be/** 를 만질 때 자동 로드) — 구 CLAUDE.md Step 3 BE / §5 BE / §6 BE 승계 | - "nscm-be/**" |
| `02-db-sql.md` | DB / SQL / SP 규약 (SQL·_artifacts 를 만질 때 자동 로드) — 구 CLAUDE.md 절대금지 ⑩ / Step 2 DB  | - "_artifacts/**" |
| `03-analysis-docs.md` | 분석 산출물 규약 (분석서·설계서·테스트케이스를 만질 때 자동 로드) — 구 CLAUDE.md §11 / §12 / §13 승계 | - "Doc/_analysis/**" |

## 5. 작업 hook 문서 (156개 · `Doc/_rules_v2/hooks/`)

| 문서 | 제목 | 첫 설명 줄 |
|---|---|---|
| `asis-button-mapping.md` | Hook — asis-button-mapping (CRUD 6 + Search Aux 4 = 10 키 매핑 의무) | **트리거**: 신규 화면 hotkeyConfig 작성 시 |
| `asis-coverage-check.md` | Hook — asis-coverage-check (As-Is 4축 100% 매핑 검증) | **트리거**: PR 머지 게이트 (pre-submit 통합 검증의 일부) |
| `asis-db-live-connection-mandatory.md` | Hook #151 — asis-db-live-connection-mandatory (AS-IS 정보 확인 = DB 직접 접속 의무) | **트리거**: AS-IS(GSCM MSSQL) 의 SP/뷰/함수 본문·스키마·데이터·메타를 **확인·인용·대조**하는 모든 작업 |
| `asis-grid-cell-event-full-extraction.md` | Hook #146 — AS-IS 그리드 셀 EVENT 전수 추출 → TO-BE 누락 0 | 신설 2026-08-22 (사용자 명시). 계기 = DMF0082 에서 **AS-IS 그리드 셀 종속(컬럼 변경 → 다른 컬럼 변화)이 |
| `asis-msg-inventory.md` | Hook — AS-IS MSG[숫자] 인벤토리 + To-Be 등록 SQL 생성 | 작성: 2026-06-10 (MSG00096 권한 없음 추적 + AS-IS 33 MSG ID 인벤토리 후) |
| `atomic-design-components.md` | Hook — Atomic Design 컴포넌트 계층 (@lges/design-system 우선) | **Trigger**: T01 (신규 화면) + T04 (Grid) + T06 (Modal/Popup) — 컴포넌트 작성/재사용 시 |
| `auth-by-userid-not-groupid.md` | Hook #128 — auth-by-userid-not-groupid (권한 판정은 UI 가 넘긴 GROUP_ID 가 아니라 **USER_ID 로 서버가 보유 권 | **Trigger**: T01 (신규 화면) / T01M (화면 수정) / T06 (SP 변환) / T07 (사내 DB 적용) — **권한·편집가능 판정이 등장하는 모든 작업** |
| `be-api-contract-ui.md` | Hook — BE API 계약 (UI 호출 관점, javadoc 기준) | **Trigger**: T07 (데이터 조회/SAVE) + T08 (BE/Controller/Service) + T01 (신규 화면의 BE 연동) |
| `be-infrastructure-reuse.md` | Hook — BE 인프라 재사용 의무 (신규 작성 전 검색 우선) | trigger: 신규 BE endpoint / Service / Controller / DTO / SP 작성 의도가 있을 때 |
| `cascade-combo-filter.md` | Hook — Cascade Combo Filter (Form + Grid combo lookup 5단계 표준) | ⭐ **신규 화면 조회조건 Form 또는 Grid 가 Division/Team/Customer 등 종속 combo 사용 시 의무 적용.** |
| `cascade-pattern-check.md` | Hook — cascade 패턴 cross-check | PR 머지 직전 + 신규 화면 작성 직후 의무 hook. AS-IS `DataModel.Changed` handler 수 vs TO-BE `cellEditEnded` sub-pattern 수 cross-check 자동화. |
| `claude-md-changelog-policy.md` | Hook — CLAUDE.md 변경 이력 작성 정책 (2026-06-20) | 사용자 명시 (2026-06-20) — **rule 로 추가**. |
| `cloud-deploy-silent-failure-gates.md` | Hook #148 — 클라우드 이관 "조용한 실패" 6계보 게이트 + 진단 순서 | 신설 2026-08-28 (사용자 지시 — "현재까지의 보완내용 중 RULE 적용 필요한 부분 정리해서 MD, HOOK 보완"). |
| `cloud-ui-db-object-fetch.md` | Hook #122 — cloud-ui-db-object-fetch ⭐⭐ (사용자 명시 2026-08-04) | **트리거**: "클라우드에서 만든 UI/PKG/SP 를 로컬(사내)로 이관" / "클라우드 DB 객체 추출" — 통상 이관(사내→클라우드)의 **역방향** |
| `code-naming-convention-mandatory.md` | Hook — 코드 Naming Convention + 품질 게이트 (공식 인수인계서 §4 / 설계서 §3) | **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE 코드 작성/수정 시 |
| `column-align-code-standard.md` | Hook #96 — column-align-code-standard (컬럼 정렬코드 단일문자 C/L/R 표준) | **트리거**: UI Category Setup 컬럼 메타 작성/적용 (T04 grid / SHEET_COLUMNS INSERT·UPDATE / "정렬이 안 맞아요/우정렬돼요") |
| `column-division-id-visibility.md` | Hook — UI Category Setup `DIVISION_ID` 기반 컬럼 표시 (DIVISION_ID 직접 사용) | ⚠ **Grid 가 admin 컬럼 메타를 동적 fetch 하는 신규/수정 화면 작업 시 적용** |
| `column-lookup-meta-standard.md` | Hook — 컬럼 lookup 메타 표준 + INPUT_TP_CD 표준 (누락 방지) | ⚠ **신규/수정 화면 작업 시 필수 적용** |
| `column-meta-rework-checklist.md` | Hook — Column 속성 재작업 의무 점검 (DMF0008/0020/0043/0043_01 4 화면 + 일반) | ⚠️ **화면 column 속성 재작업 시 누락 없이 적용해야 할 8 점검 의무** |
| `comment-live-code-discrimination.md` | Hook #138 — comment-live-code-discrimination (주석/라이브 코드 판별 의무 — 주석은 분석 근거도, 적용 대상도 아니다) | **유형**: 🅓 문서 hook (전 작업 공통 — 분석·변환·패치·게이트 전부) |
| `common-button-grid-routing.md` | Hook #97 — common-button-grid-routing (공통버튼 표시·활성그리드 라우팅 + 행번호 컬럼) | **트리거**: 화면 버튼/그리드 CRUD (T01 신규 / T01M 수정 / SubTitle hotkeyConfig / 다중 그리드 Insert·Delete / "No 컬럼") |
| `components-folder-pattern.md` | Hook — components/ 폴더 패턴 (진입 페이지 + sub-component 분리 의무) | 적용 trigger: T01 (신규 화면) / T04 (Grid 작성) / T06 (Modal 작성) |
| `corp-meta-integrity-and-wiring.md` | Hook #98 — corp-meta-integrity-and-wiring (사내 메타 INSERT 무결성 + LBL 할당 + generic 배선) | **트리거**: 사내 DB 메타 작업 (corp 스크립트 / `SCM_ADM_MSG_M`·`SCM_ADM_PROC_M`·`SCM_ADM_API_M`·`SCM_ADM_MNU_BTN_MPG_M` INSERT / 신규 LBL / SP 호출 배선) |
| `custom-context-menu-standard.md` | Hook #102 — 커스텀 우클릭(Context) 메뉴 표준 (dismiss 레이스 차단) | 신설: 2026-07-03 (DMF0003 우클릭 PR 메뉴 "무반응" 사고 — 사용자 보고 후 원인 확정) |
| `datagrid-shared-component-mandatory.md` | Hook — DataGrid 공용 컴포넌트 + Foundation Utils 의무 (Grid 작업 표준) | **Trigger**: T01 (신규 화면 / 화면 수정) + T04 (Grid / 컬럼 / dropdown / 체크박스 / DataGrid) |
| `db-corporate-apply.md` | Hook — 사내 Oracle DB 적용 절차 (Docker DB → 사내) | 작성: 2026-06-10 (Docker → 사내 11 화면 일괄 적용 작업 후) |
| `db-error-asis-cross-check.md` | Hook — DB 오류 시 AS-IS DB 직접 cross-check 의무 | ⭐ **2026-06-01 신규.** DB 오류 발생 또는 데이터 미일치 시 추측 금지 — As-Is MSSQL DB 에 직접 연결하여 원본 cross-check. |
| `db-schema-divergence-check.md` | Hook — Docker DB vs 사내 DB Schema 차이 검출 | 작성: 2026-06-10 (사내 적용 중 8가지 schema 차이 발견 후) |
| `db-source-refresh-before-work.md` | Hook #152 — db-source-refresh-before-work (DB 작업 = 새로고침한 최신 원문 기준 의무) ⭐ 실행 hook 동반 | **트리거**: Oracle DB 객체(PACKAGE/BODY/PROCEDURE/FUNCTION/VIEW/TRIGGER/TYPE)·메타 행을 **수정·재반영·원복·이관 패키지 작성**하는 모든 작업 (사내 ZIOUI1 · 클라우드 패키지 공통) |
| `deploy-package-completeness.md` | Hook — Deploy Package 완전성 (Combo / POPUP / Action SP 모두 포함) | ⭐ **신규 화면 deploy zip 작성 시 메인 SP 외 모든 lookup combo / POPUP modal / action SP 의 메타 + body 동봉 의무** |
| `dept-id-derivation-standard.md` | Hook #150 — DEPT_ID 산출 기준 표준 (SCM_MST_SITE_ITEM 단일화 + DIV+SITE MAX 단일건) | ⭐ **사용자 지시 (2026-09-05)** — "DEPT_ID 을 가져오는 기준을 변경하고자 합니다." |
| `destructive-git-ops.md` | Hook — Destructive Git ops (filter-branch / force-push / reset --hard) | ⚠ **history rewrite / shared remote 영향 작업 시 의무 hook** |
| `excel-form-upload-standard.md` | Hook #135 — excel-form-upload-standard ⭐⭐⭐ (사용자 명시 2026-08-14) | **트리거**: 화면에 **Excel Upload 기능이 있는 경우 전부** (신규 T01 / 보완 T01M). |
| `excel-upload-nls-safe-parsing.md` | Hook #147 — Excel Upload 값 파싱 = NLS·셀서식 **무관**이어야 한다 | 신설 2026-08-23 (사용자 명시). 계기 = DMF0014 Excel Upload 가 **사내는 정상, 클라우드만 전건** |
| `fe-cloud-type-lint-readiness.md` | Hook — FE 클라우드 type-check + lint 통과 의무 | ⭐ **사용자 명시 사고 (2026-06-12)**: |
| `feature-button-meta-completeness.md` | Hook — 기능 버튼 메타 등록 완전성 의무 (2026-06-20) | 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**. |
| `figma-layout-parity-mandatory.md` | Hook — Figma 디자인 ↔ 구현 레이아웃 정합 (필수, PR 차단) | 분류: 🆄 UI/화면 · 트리거: **T01(신규) · T01M(수정) · T11(Figma)** · 등급: ⭐⭐⭐ PR 차단 |
| `file-write-fallback.md` | Hook — file-write-fallback (Write 실패 시 우회경로 의무) | **트리거**: `Write` tool 호출 시 `Error writing file` 또는 `File has not been read yet` 에러 발생 |
| `form-common-styles-mandatory.md` | Hook #121 — form-common-styles-mandatory ⭐⭐ (사용자 명시 2026-08-04) | **트리거**: nscm-fe 에서 `SearchArea` 조회조건·입력 폼(`FormItem` / `InputField` / `Checkbox`) 신규 작성 또는 수정 (T01/T01M/T05) |
| `framework-foundation-entry.md` | Hook — Framework Foundation Entry (공식 FE 프레임워크 설계서 준수 진입점) | **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE UI 작업 진입 시 1차 확인 |
| `get-zero-dup-invisible-diagnosis.md` | Hook — 조회 이상 3증상 진단 플레이북 (오류 없는 0행 / 동일 데이터 2행 중복 / 저장 성공인데 미표시) | **트리거**: "조회가 안 된다(에러 없음)" / "같은 데이터가 2행 나온다" / "저장은 됐다는데 화면에 안 보인다" — |
| `grid-cell-backcolor-standard.md` | Hook #95 — grid-cell-backcolor-standard (Grid Cell Backcolor 표준 — 필수·공통) | **트리거**: 모든 TO-BE grid 작업 (T01 신규화면 / T01M 화면수정 / T04 grid / formatItem 작성·수정) |
| `grid-cell-interaction-patterns-mandatory.md` | Hook — Grid Cell Interaction Patterns (Grid 변형 3 시나리오 + drill-down + 다중 popup + CSV 변환) | **Trigger**: T01 (신규 화면) + T04 (Grid / Cell interaction) |
| `grid-column-meta.md` | Hook — grid-column-meta (Column 메타 표준 자동 검증) | **트리거**: Grid 컴포넌트 작성 / 메타 SQL BLOCK 6 작성 시 |
| `grid-column-setting-popup-pattern.md` | Hook — Grid Column Setting Popup 통합 패턴 (사용자 column 표시 설정 5 단계) | ⭐ **신규 화면에 Grid 가 있고 사용자 column 표시 설정 기능이 필요한 경우 의무 적용 패턴** |
| `grid-insert-and-modal-derived-parity.md` | Hook #143 — GRID Insert 복사 · 셀 모달 파생 컬럼 = AS-IS 동작성 1:1 | 신설 2026-08-22 (사용자 지시: "GRID 에서 INSERT 시 AS-IS 와 동일하게 COLUMN DATA 를 복사해주세요 / |
| `grid-insert-position-and-filter-contract.md` | Hook #144 — 그리드 신규행 Insert 위치 · 컬럼 필터 규약 | 신설 2026-08-22 (사용자 제시 규약). 계기 = DMF0044(sales-reports) · DMF0049(etc-sales-reports) |
| `grid-interaction-patterns.md` | Hook — Grid 상호작용 표준 (selectionMode / 액션 버튼 배치 / 자동 체크 금지 / Recently-Added) | **트리거**: 신규 화면이 다중 grid + checkbox + row selection 조합을 사용할 때 |
| `grid-multi-tier-header-height.md` | Hook — Grid 다단(2단/3단) 헤더 높이 정합 | ⚠ **동적 컬럼/다단 헤더 grid 작업 시 적용** |
| `i18n-ko-en-alignment.md` | Hook — i18n KO=EN 전체 통일 (다국어 영문화 정책) | ⭐ **사용자 명시 요구 (2026-06-12)**: |
| `issue-feed-rules.md` | issue-feed-rules — 일일 이슈목록 → 룰 후보 누적 피드 | **성격**: append-only 누적 피드. `C:\Projects\NSCM\Doc\issue\이슈목록관리.xlsx` 또는 `C:\Projects\NSCM\_analysis\이슈목록관리.xlsx` 일일 스냅샷에서 도출한 룰 후보를 날짜별로 누적한다. (2026-11-13 정정: 원본 위치 `C:\TR |
| `issue-log-daily-workflow.md` | issue-log-daily-workflow — 일일 이슈목록 정리·룰 후보 편입 절차 | **트리거**: 사용자가 "이슈목록 정리", "오늘 이슈 정리해줘", "이슈 룰 반영", **"이슈목록 Rule 적용"** 등을 요청할 때. |
| `local-server-startup-standard.md` | Hook — 로컬 서버 기동 표준 (pnpm 금지) | **트리거**: 사용자가 "서버 기동" / "FE 띄워" / "로컬 시작" / "BE 띄우기" 등 요청 시 |
| `localstorage-persist-pattern.md` | Hook — localStorage Tab-Cross Persist 패턴 | ⚠ **화면 close/reopen 후에도 유지되어야 하는 state 작성 시 의무 hook** |
| `mdi-tab-isolation-mandatory.md` | Hook — MDI 탭 상태 격리 (Multiton Store + Query Key 격리, 공식 설계서 §4) | **Trigger**: T01 (신규 화면 / 화면 수정) + T04 (Grid 데이터 fetch) + T05 (조회조건 store) |
| `menu-button-dynamic-fetch.md` | Hook — Menu Button 동적 fetch (Visible/Enable) | ⚠ **신규/수정 화면 작업 시 반드시 적용** |
| `menu-not-displayed-debug.md` | Hook — menu-not-displayed-debug (메뉴 미표시 7-단계 디버깅) | **트리거**: 사용자 신고 "메뉴 클릭 후 화면 안 나옴" / "권한 없다고 떠요" / 신규 화면 메뉴 미표시 |
| `messaging-api-and-search-fields-mandatory.md` | Hook — Messaging / apiClient / searchFields 카탈로그 / CustomDialog 표준 | **Trigger**: T01 (신규 화면) + T05 (Form / SearchArea) + T07 (Button / 데이터 fetch / SAVE) |
| `modal-callback-cascade-check.md` | Hook — modal callback cascade 자기 점검 | §2.10.6 modal callback cascade 패턴의 PR 머지 게이트. |
| `msg-id-asis-tobe-conversion.md` | Hook #114 — msg-id-asis-tobe-conversion (AS-IS MSG_ID 그대로 사용 절대 금지 — 의미 확인 후 TO-BE MSG_ID  | 작성: 2026-07-16 (**사용자 명시 요구** — "AS-IS 의 MESSAGE_ID 을 그대로 사용하지 않고, 의미를 확인 후 TO-BE 기준의 MESSAGE_ID 로 변환해야 하는 부분도 RULE 로 적용해서 반드시 지켜지도록") |
| `msg-table-cloud-sync-and-insert-only.md` | Hook — MSG TABLE 클라우드 동기화 + 이관은 INSERT(NOT EXISTS) 전용 | ⭐ **두 가지 의무를 한 룰로 묶는다.** |
| `mssql-ci-collation-parity.md` | Hook #118 — MSSQL 암묵 등가(CI collation·숫자 표기) 상실 함정 (Oracle 1:1 변환 시) | **트리거**: MSSQL→Oracle 변환 SP에서 문자열 리터럴 비교(IN/=/DELETE WHERE) 존재 · `REPLACE(숫자컬럼, '.0', ...)` 류 표기 의존 로직 · "AS-IS는 되는데 Oracle만 중복/순서 동률/필터 미작동" |
| `mutation-onsuccess-defaults.md` | Hook — useProcMutation `onSuccess` override 시 default 동작 명시 호출 의무 | **트리거**: `mutate(payload, { onSuccess: ... })` 사용 시 |
| `oracle-bulk-clob-buffer.md` | Hook #106 — Oracle 대량 조회/저장 CLOB 버퍼 (VARCHAR2 4000/32767 초과 방지) | 신설: 2026-07-06 (DMF0014 / DMF0043 / DMF0048 대량 조회·저장 오류 3연발 후) |
| `oracle-cmbo-varname-quote.md` | Hook — CMBO_SQL_M `@varName` 치환 + Oracle VARCHAR2 비교 사고 방지 | `SCM_ADM_CMBO_SQL_M` 의 SQL 안에서 `@divisionId` 등 substitution 시 **BE 가 quote 안 함** → VARCHAR2 컬럼 비교 시 ORA-01722. |
| `oracle-db-workflow.md` | Hook — oracle-db-workflow (Oracle SP/DB 작업 단일 진입점) ⭐ 2026-06-11 신설 | **트리거**: "SP 변환 / PKG / PL/SQL / Oracle / ORA-XXXXX / PLS-XXXXX / DB 적용 / MSSQL 변환 / SP 오류 / 저장 안 됨" |
| `oracle-load-dedup-and-exception-propagation.md` | Hook #137 — oracle-load-dedup-and-exception-propagation ⭐⭐⭐ (2026-08-18 DMF0014 실사고 계기 신설) | **트리거**: 원장 적재 SP 작성·변환·보완 전부 (`INSERT ... SELECT` / `MERGE` 로 PK 있는 표에 적재). |
| `oracle-nls-implicit-conversion.md` | Hook #109 — oracle-nls-implicit-conversion (암묵 형변환 = 세션 NLS 의존 폭탄) ⭐ 2026-07-08 신설 | **트리거**: ORA-01861 / ORA-01843 / ORA-01722 / "로컬은 되는데 클라우드만 실패" / -9994 / InvocationTargetException / TO_DATE / DATE 파라미터 |
| `oracle-null-sentinel-and-notnull-default.md` | Hook — Oracle 널 센티널 `'/'` 과 NOT NULL 초기값 (MSSQL `ISNULL(x,'')` 이관 규약) | 신설: 2026-07-30 (사용자 확정 `'-'` — DMF0044/0049 PKG 변환결함 전수 감사 후) |
| `oracle-nvl-null-antipattern.md` | Hook #127 — oracle-nvl-null-antipattern (`NVL(x, NULL)` 금지 — 표현식은 `NVL(x,'-')`, 술어는 NVL 제거 | **Trigger**: T19 (SP 변환) / T18 (사내 DB 적용) (2026-11-13 정정: T06/T07 → TRIGGER_ROUTER 현행 번호 T19/T18) / SP 본문을 읽거나 고치는 모든 작업 |
| `oracle-perf-fix-priority-order.md` | Hook #129 — oracle-perf-fix-priority-order (SP/PKG 속도 개선은 **정해진 순서**로 — 힌트는 마지막) | **Trigger**: T19 (SP 변환·MSSQL→Oracle 변환) / T18 (사내 DB 적용) / T10 (DB 오류·이상치) (2026-11-13 정정: T06 (SP 변환)/T07 (사내 DB 적용) → TRIGGER_ROUTER 현행 번호 T19/T18) — **속도 이슈가 보고된 모든 S |
| `oracle-save-payload-integrity.md` | Hook — Oracle SAVE Payload 무결성 & 서버 검증 대응 (#99) | **트리거**: Oracle SAVE SP(`*_SAVE_*`, delete-then-insert / ^-delim 배열) 호출 화면의 저장 로직 작성·디버깅. |
| `oracle-sp-perf-anti-patterns.md` | Hook — Oracle SP 변환 성능 안티패턴 (MSSQL → Oracle) | ⚠ **반드시 지켜야 할 룰 — MSSQL 에서 OK 였던 패턴이 Oracle 에서 급격한 속도저하 유발.** |
| `oracle-sp-perf-correlated-setbased-and-live-redeploy.md` | hook: Oracle 조회 SP 성능 최적화(상관→set-based) + 라이브 PKG 재배포 운영 | 트리거: 조회 SP/PKG hang·스피너·느림 / 상관 UPDATE·DELETE·LATERAL / 라이브 PKG 재배포 / GTT 정밀도 |
| `pinpoint-request-scope-first.md` | Hook #153 — pinpoint-request-scope-first (대상 특정 보완요청 = 지정 지점 즉시 수정 · 재현값 = FE 실전송값) | **트리거**: 보완요청(T01M/T08/T10) 중 사용자가 **대상 값·위치·처리방식**을 문장으로 특정한 경우 (예: "X 값 뒤 '( )' 를 제거해서 조회되게") |
| `pivot-dynamic-column-nvl.md` | Hook — PIVOT dynamic 컬럼 NULL → NVL wrap 의무 | ⚠️ **PIVOT + 동적 컬럼 SP 작성 시 SELECT list NVL wrap 의무** |
| `pivot-header-drilldown.md` | Hook #103 — PIVOT 그리드 헤더 드릴다운 표준 (합계 헤더 클릭 → 하위 버킷 펼침/접힘) | 신설: 2026-07-03 (DMF0003 SUM 헤더 드릴다운 구현 — AS-IS spdMain_CellDoubleClick e.ColumnHeader L3416~3455 1:1) |
| `popup-asis-analysis.md` | Hook — popup-asis-analysis (Popup 9 category 정밀 분석 의무) | **트리거**: POPUP 작업 / 신규 modal 작성 시 |
| `popup-dialog-layout.md` | Hook — CustomDialog Layout (Popup 잘림 / 중앙 표시 방지) | Popup 작성 시 `CustomDialog` 의 height 정책 + position 선택 + container/grid flex layout 일관 적용. |
| `popup-modal-and-routing-mandatory.md` | Hook — Popup Modal 작성 + Router 등록 표준 (DMF0004 RegionModal master) | **Trigger**: T01 (신규 화면 / popup 작성) + T06 (Modal / Popup) + T09 (메뉴 / 라우팅) (2026-11-14 정정: T13 → T06, T09. `TRIGGER_ROUTER.md` 에서 T13 은 CSV 적재) |
| `post-write.md` | Hook — post-write (파일 작성 직후 검증) | **트리거**: 모든 `.ts / .tsx / .java / .sql / .md` 파일 작성 / 수정 직후 |
| `pre-submit.md` | Hook — pre-submit (PR 제출 직전 최종 검증) | **트리거**: PR 작성 / 제출 직전 (모든 작업 종료 직후) |
| `pre-write.md` | Hook — pre-write (파일 작성 직전 자기 점검) | **트리거**: 모든 `.ts / .tsx / .java / .sql / .md` 파일 작성 직전 |
| `proc-meta-signature-match.md` | Hook — PROC_M ↔ 실제 SP signature (ALL_ARGUMENTS) 일치 의무 + FE filter key 매핑 | **트리거**: 신규 SP 작성 또는 SCM_ADM_PROC_M 메타 등록 시 |
| `procedure-dts-ssot-mandatory.md` | Hook — procedure.d.ts SSOT 타입 체인 (백엔드 통신 규격 단일화) | **Trigger**: T01 (신규 화면) + T07 (데이터 조회/SAVE) + T08 (BE/SP) |
| `react-query-foundation-reexport.md` | Hook — `@tanstack/react-query` 직접 import 금지 | 작성: 2026-06-10 (authority 의 AuthApproval/AuthRequest lint 사고 후) |
| `regression-zero-mandatory.md` | Hook — Regression Zero (신규 화면 작업 시 type/lint 오류 0 + 기존 화면 regression 0) | **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 FE 파일 변경 |
| `relative-import-order.md` | Hook — Relative imports 알파벳/계층 순서 정렬 | 작성: 2026-06-10 (AuthApproval.tsx import/order lint 사고 후) |
| `remediation-closure-symptom-reproduction.md` | Hook #149 — remediation-closure-symptom-reproduction (보완요청 종결 게이트: 증상 재현·해소 실측 의무) | **트리거**: 보완요청(`REQ:`) 상태 전이(PENDING→APPLIED/VERIFIED) 직전 · "보완 완료/확인 완료/종결" 보고 직전 (T 전 유형) |
| `request-ledger-and-subclause-mapping.md` | Hook #139 — request-ledger-and-subclause-mapping (보완요청 원장 + 하위문구 대사 의무 — 지정 보완요청 미적용 재발 방지 | **유형**: 🅓 문서 hook + 기계 게이트 (asis_mapping_gate REQ 축 + ui_gate_runner 섹션 10) |
| `runtime-error-prevention.md` | Hook — runtime-error-prevention (기본 런타임 오류 사전 차단) | **트리거**: 신규 FE 화면 / 모달 작성 시 |
| `scmd-app-grant-mandatory.md` | Hook — SCMD_APP 권한 (BE 사용계정) 의무 | ⭐ **사용자 명시 사고 (2026-06-12)**: |
| `screen-additional-skills-mandatory.md` | Hook — Screen Additional Skills (DMF0004/0005/0006 cross-check 누락 보강) | **Trigger**: T01 (신규 화면 / 화면 수정) |
| `screen-analysis-workbook-standard.md` | Hook #105 — 화면설계서·UI분석서 표준 (설계서 8시트 / UI분석서 10시트 + 전면 자연어 서술 + AS-IS DB 소스 전수분석) | 신설: 2026-07-03 (DMF0003 v1.0/v1.1) · 확장: 2026-07-07 (DMF0003 v1.7) |
| `screen-asis-pre-analysis-mandatory.md` | Hook #124 — screen-asis-pre-analysis-mandatory (UI 생성·보완 4영역 AS-IS 선행 분석·md 의무 + 모달=MAIN 동 | **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M) — **구현 착수 전** |
| `screen-combo-validation-message-mandatory.md` | Hook — Combo Lookup + Date Validation + Message Code 정합 (화면 QA 이슈 도출) | 작성 / Authored: 2026-06-23 (일일 이슈목록 `이슈목록_2026-06-23.md` 룰 후보 R-1·R-2·R-3·R-4·R-5 정식 승격) |
| `screen-completion-gate.md` | Hook — screen-completion-gate (UI 화면 완성도 통합 게이트) ⭐ 2026-06-11 신설 | **트리거**: 신규 화면 작성 완료 직전 / 화면 수정 작업 종료 직전 / "화면 다 됐어?" / PR 제출 전 |
| `screen-conventions-mandatory.md` | Hook — Screen Conventions (신규 화면 컨벤션 종합, DMF0004/0005/0006 master) | **Trigger**: T01 (신규 화면 / 화면 수정) + 모든 화면 영역 |
| `screen-create-checklist.md` | Hook — screen-create-checklist (신규 화면 생성 강제 체크리스트) | **트리거**: 키워드 "신규 화면 / 화면 추가 / DMFXXXX 만들어 / 화면 생성" 감지 시 |
| `screen-entry-asis-baseline.md` | Hook — 신규/수정 화면 진입 시 As-Is DB baseline 자동 점검 | ⭐⭐ **2026-06-01 신규** (Plan Stage 5). |
| `screen-grid-edit-merge-and-meta-mandatory.md` | Hook — Grid 머지·편집 제어 + admin 메타(API_ID/INPUT_TP_CD) + Division cascade/period 정합 (화면 QA 이슈 | 작성 / Authored: 2026-06-23 (PM — 일일 이슈목록 `이슈목록_2026-06-23.md` 룰 후보 **R-6·R-7·R-8·R-9·R-10** 정식 승격) |
| `screen-meta-and-permissions-mandatory.md` | Hook — Screen Meta & Permissions (`useTabBtnPermissions` + `__asis-mapping__.md` + i18n 3  | **Trigger**: T01 (신규 화면 / 수정) + T20 (화면 완성도 게이트) |
| `screen-modal-cascade-filter-analysis.md` | Hook #123 — screen-modal-cascade-filter-analysis (신규화면 Modal AS-IS 기능분석 + Cascade/Filter 상 | **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M) |
| `screen-runtime-pitfalls-mandatory.md` | Hook — Screen Runtime Pitfalls (런타임 사고 9종 통합 차단) | 작성 / Authored: 2026-06-19 (DMF0043 룰 전면 점검 작업 중 발견된 사고 패턴 통합) |
| `screen-shell-composition-mandatory.md` | Hook — Screen Shell Composition (Page / Form / Hook 인프라 의무, DMF0004 master) | **Trigger**: T01 (신규 화면 / 화면 수정) + T05 (조회조건 Form) + T07 (데이터 조회 / SAVE) |
| `sdm-domain-development-standard.md` | sdm-domain-development-standard — SDM 도메인 개발 표준 (hook #134) | **신설**: 2026-08-12 (사용자 명시 — "SDM 개발관련은 SDM 으로 별도 RULE 생성") |
| `search-area-bulk-input-button-popup.md` | Hook #155 — 조회영역 일괄 입력(Input 버튼) = 버튼 영역 버튼 + 입력 팝업 ⭐⭐⭐ (공통 패턴) | trigger: AS-IS 조회조건 영역에 '그리드 일괄 입력' 컨트롤 묶음(Day of the week / Day Type / Category + Input Value + Input 버튼)이 있는 화면의 신규 작성·보정 (T01/T01M/T05) |
| `search-area-button-position-and-toggle.md` | Hook — SearchArea 의 검색 버튼 위치 + 펼침/닫기 토글 의무 (2026-06-20) | 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**. |
| `search-area-extra-conditions.md` | Hook — SearchArea 2단 초과 시 extraConditions 분리 의무 (확장 화살표 자동) | trigger: 조회조건 form 작성 / 수정 시 (T01 신규 화면, T04 Grid/Column 메타, T05 SearchArea 부재 등) |
| `search-button-when-no-searcharea.md` | Hook — search-button-when-no-searcharea | **트리거**: 신규 화면이 SearchArea (조회조건 영역) 를 사용하지 않을 때 (`MainTitle disableSearchArea` 또는 SearchArea 컴포넌트 미사용) |
| `search-condition-asis-tobe-catalog.md` | Hook #112 — search-condition-asis-tobe-catalog (SCP·DM 조회조건 AS-IS↔TO-BE 카탈로그 적용 의무) | 🅕 T01 / T01M / T03 / T05 · 문서 hook(guide) · 2026-07-13 신설 (사용자 명시) |
| `search-condition-datasource-asis-parity.md` | Hook #117 — 조회조건 데이터 추출 AS-IS 정합 + 공유 CMBO 보호 프로토콜 | **트리거**: 조회조건 콤보/팝업의 **데이터 소스** 작성·수정 · "AS-IS 와 후보가 다르다" 류 이슈 · `SCM_ADM_CMBO_SQL_M` 공유 SQL_ID 수정 시도 |
| `search-condition-height-uniformity.md` | Hook — 조회조건 객체 높이 동일화 (디자인 필수) + Figma 1단 4개 배치 | ⚠️ **디자인 필수 룰 (사용자 명시 2026-06-27)** |
| `search-condition-labelless-toggle-input-column.md` | Hook #154 — 조회조건 Radio/CheckBox 디자인 = 좌측 라벨 열(조건명) + 입력 열 시작선(컨트롤) ⭐⭐⭐ (디자인 필수) | trigger: 조회조건(SearchArea conditions/extraConditions · 팝업 모달 조회조건) 에 RadioGroup/Radio · Checkbox 신규 작성 또는 위치·라벨 수정 (T01/T01M/T05) |
| `sheet-columns-binding-match.md` | Hook — SHEET_COLUMNS binding ↔ SP 반환 컬럼 일치 의무 + 하드코딩 staticColumns 금지 | **트리거**: 신규 화면 SHEET_COLUMNS 등록 또는 grid sub-component 작성 시 |
| `sheet-columns-meta-completeness.md` | Hook — SHEET_COLUMNS 메타 완전성 + 미사용 데이터 정리 의무 (2026-06-20) | 사용자 명시 (2026-06-20, DMF0072 fix 중) — **rule 로 추가**. |
| `sheet-name-asis-preserve-mandatory.md` | Hook — SHEET_NAME = AS-IS 원본 그대로 (개명 금지, 필수) | 분류: 🆄/🅑 · 트리거: **T01(신규) · T01M(수정) · T04 · T08** · 등급: ⭐⭐⭐ PR 차단 |
| `sp-body-minimal-change.md` | Hook — Oracle SP body minimal change (원본 1바이트도 변경 금지) | ⚠ **dual cursor 추가 / EXCEPTION 보강 등 SP signature 변경 작업 시 의무 hook** |
| `sp-cursor-name-response-key.md` | Hook — SP OUT cursor 이름 ↔ FE response 키 정합 (fallback chain 의무) | **Trigger**: T07 (데이터 조회/SAVE) + T08 (BE/SP) — FE 가 `useTabProcQuery` / `useProcMutation` 결과에서 cursor data 추출 시 |
| `sp-deploy-verify-target-object.md` | Hook #136 — sp-deploy-verify-target-object ⭐⭐⭐ (2026-08-18 실사고 계기 신설) | **트리거**: Oracle **PACKAGE / PACKAGE BODY / PROCEDURE / FUNCTION 배포**(사내·클라우드 공통). |
| `sp-dual-cursor-pattern.md` | Hook — Oracle GET SP `o_rc` + `O_RESULT_CURSOR` Dual OUT Cursor 표준 | **트리거**: 신규 GET (조회) SP 작성 또는 PROC_M 등록 시 |
| `sp-exception-handler-debug-friendly.md` | Hook — SP EXCEPTION OTHERS 디버그 친화 패턴 | 적용 trigger: T08 (BE/SP) + T10 (DB 오류 진단) |
| `sp-hang-runaway-loop-diagnosis.md` | Hook — sp-hang-runaway-loop-diagnosis (SP hang·폭주 진단 + FETCH_STATUS 무한루프 + GTT TRUNCATE mu | **트리거**: "업로드/저장 무반응" / "OK 클릭 반응 없음" / BE 무응답 / SP hang / 세션 kill / ORA-00026 / ORA-01031 / library cache pin / `CREATE OR REPLACE` 가 안 끝남 |
| `sp-inline-function-gtt-mandatory.md` | Hook — SP Inline Function GTT Temp Table Mandatory (사용자 명시 룰) | **트리거**: SP body / Dynamic Query 변환 시 |
| `sp-json-table-array-pattern.md` | Hook — SAVE SP 의 JSON_TABLE array 처리 표준 ('$[*]' + cursor FOR LOOP) | ⚠ **SAVE SP 작성·수정 시 필수 적용** |
| `sp-multiselect-filter-and-conversion-pitfalls.md` | hook: SP 멀티선택 필터 표준(GTT+skip) + 변환 3대 폭발/오정합 함정 | 트리거: AS-IS→TO-BE SP 변환 / SP 조회 0행·hang·폭발 진단 / `IN (split(...))` 필터 / 멀티선택 조회조건 |
| `sp-no-fake-data-extraction.md` | Hook — PKG/SP 데이터 추출 가짜 구현 절대 금지 | 적용 trigger: T08 (BE/SP 신규/변경) + T19 (AS-IS → TO-BE SP 변환) + T10 (조회 데이터 0/이상치 진단) |
| `sp-parallel-dml-txn-guard.md` | Hook #116 — SP 도입부 ALTER SESSION PARALLEL DML = 트랜잭션 가드 의무 (ORA-12841) | **트리거**: SP/PKG 멤버 도입부에 `ALTER SESSION (DIS¦EN)ABLE PARALLEL DML` 존재 · SP 가 다른 SP 의 DML 이후 내부 호출됨 · 저장 시 `ORA-12841: 트랜잭션안에 세션 병렬 DML 상태를 고칠 수 없습니다` |
| `sp-patch-file-deploy.md` | Hook — SP patch 파일 종결자 + 의존 순서 + fallback 의무 | ⚠️ **SP 패치 SQL 파일 작성 + 클라우드 적용 시 의무 점검 룰** |
| `sp-side-effect-test-gate.md` | Hook #104 — SP 테스트 실행 게이트 (부작용 실측 → 실행 방식 판정) | 신설: 2026-07-03 (DMF0003 SAVE_PRPOPUP — "4기능 전체 동작?" 검증 중 임의 실행 직전 부작용 발견으로 중단한 사례의 룰화) |
| `sp-substr-zero-index-audit.md` | Hook — SP body 의 SUBSTR(s, 0, n) 일괄 audit + fix | ⚠ **^ 구분 bulk SAVE SP 작성/패치 시 의무 hook** |
| `sp-utl-call-stack-safety.md` | Hook — UTL_CALL_STACK.SUBPROGRAM 안전 사용 | 적용 trigger: T08 (BE/SP) |
| `subtitle-button-actions-mandatory.md` | Hook — SubTitle 공통 버튼 11종 자동 매핑 의무 (추가/삭제/저장/Sort/Filter/Condition/Reset Condition + 4종) | **Trigger**: T01 (신규 화면) + T07 (Button / CRUD / hotkeyConfig) |
| `tab-driven-lazy-fetch.md` | Hook — Tab 전환 시 sub-grid lazy fetch (multi-tab + row-context 화면) | **Trigger**: T01 (신규 화면) + T07 (Button / CRUD / SubTitle hotkey) (2026-11-13 정정: T07 라벨 "데이터 조회" → `TRIGGER_ROUTER.md` T07 정의) — 다단 grid + 하단 multi-tab sub-grid 패턴 화면 |
| `titleset-cache-immunization.md` | Hook #115 — titleset 'C' 캐시 오염 면역화 (동적 PIVOT V_COLUMN 조립 SP) | **트리거**: 동적 PIVOT 컬럼목록(V_COLUMN)을 `SCM_MST_TITLESET_USER`(TYPE='C') 캐시로 조립하는 SP 작성/수정 · Column Setting/Measure Setting 모달 작업 · ORA-00918(중복 컬럼)/ORA-00904(미산출 컬럼) 조회 오류 |
| `type-check-error-patterns.md` | Hook — Type-Check 오류 17 패턴 정밀 가이드 | ⚠ **신규 FE 파일 작성 시 의무 hook (cloud type-check 8 회 push 차단 사고 후, 2026-06-09)** |
| `ui-category-division-direct-compare.md` | Hook #113 — UI Category DIVISION_ID 가시성 = 서버 직접 비교 (attr 우회·하드코딩·화이트리스트 금지) | 제정: 2026-07-15 (사용자 지정 — DMF0021 Sales Plan Grid Column 표시 사고). |
| `ui-category-setup-column-meta.md` | Hook — UI Category Setup Column 메타 동적 fetch 의무 | ⚠ **신규/수정 화면 작업 시 반드시 적용** |
| `ui-category-setup-no-arbitrary-data.md` | Hook — UI Category Setup 데이터 임의 생성 절대 금지 (강력 룰) | ⚠️ **이 룰은 `anti-simplification.md` 와 동급 우선순위입니다.** |
| `ui-common-testitem-mapping-axis.md` | Hook #133 — ui-common-testitem-mapping-axis ⭐⭐⭐ (사용자 명시 2026-08-12) | **트리거**: UI 생성(T01)·보완(T01M) 시 대조표(`__asis-mapping__.md`) 생성·검증 전부. (2026-11-13 정정: 용어 대사표 → 대조표) |
| `ui-dynamic-property-management.md` | Hook — UI 생성의 동적 속성관리 (Menu Button / Column / Measure) | ⭐ **사용자 명시 요구 (2026-06-12)**: |
| `ui-grid-corner-no-header.md` | Hook #108 — ui-grid-corner-no-header (그리드 No. 코너 헤더 머지+라벨 공통 표준) ⭐ 2026-07-08 신설 | **트리거**: T01(신규 화면) / T01M(화면 수정) / grid / 헤더 머지 / 다단 헤더 / MergeManager / "No." 컬럼 |
| `ui-layout-shell-modal-feedback-standard.md` | Hook #132 — ui-layout-shell-modal-feedback-standard ⭐⭐⭐ (사용자 명시 2026-08-12) | **트리거**: nscm-fe UI 생성(T01)·보완(T01M) 전부 — 페이지 최상위 구조 / DataGrid 배치 / 조회조건 FormItem / |
| `ui-mandatory-12-behaviors.md` | Hook #156 — ui-mandatory-12-behaviors ⭐⭐⭐ (사용자 명시 2026-08-28) | **트리거**: nscm-fe UI **신규 생성(T01)·보완(T01M) 전부** — 조회조건(Division/Team/End Customer/Biz.Type/Plant Site/기간/Bucket) · |
| `ui-meta-consumption-and-crud-path-coverage.md` | Hook #130 — ui-meta-consumption-and-crud-path-coverage (UI 메타 실소비 + CRUD 경로 전수 커버리지) | **트리거**: UI 신규 추가(T01) / UI 보완·수정(T01M) / 화면 완료 선언 전(T20) |
| `ui-meta-dictionary-mandatory.md` | Hook — UI 메타 지식사전 대조 의무 (조회조건 / SHEET_COLUMN / SHEET_MEASURE) | ⛔ 신규·보완 화면의 **조회조건·그리드 컬럼 메타·MEASURE** 를 "화면마다 다시 판단" 하지 말 것. |
| `ui-save-idempotent-readback.md` | Hook #131 — ui-save-idempotent-readback (저장 멱등성 — 저장이 조회 그룹 축을 보존해야 한다) | **트리거**: UI 신규 추가(T01) / UI 보완·수정(T01M) / 저장 SP 작성·변환(T08/T10) / 화면 완료 선언 전(T20) |
| `ui-selfcheck-runtime-mandatory.md` | Hook #125 — ui-selfcheck-runtime-mandatory (신규 UI 완료 선언 전 셀프 런타임 검증 의무 — 권한별 + 모달 전 기능) | **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M) — **완료 선언 직전** |
| `ui-title-icon-buttons-standard.md` | Hook #120 — ui-title-icon-buttons-standard (타이틀 아이콘 버튼 표준: 환율 아이콘화 + 복수 아이콘 순서) | ⭐ **2026-08-10 최종 확정** — 아이콘 순서 = **환율 → Column Set → Measure**. §2 참조. |
| `ui-work-entry-playbook.md` | Hook — UI 작업 진입 플레이북 (보완 = T01M 전면 점검·교정 / 신규 생성 = T01 전체 룰 적용) | **트리거 (자동 첨부 — attach-context.ps1 배선)**: |
| `verification-completion-honesty.md` | Hook — verification-completion-honesty (검증 완료 선언 정직성 계약) ⭐ 2026-08-08 신설 (사용자 명시) | **트리거**: 신규 UI(T01) / UI 보완(T01M) / SP·메타 보완(T08/T10/T18) **완료·검증 결과를 사용자에게 회신하기 직전** |
| `verification-evidence-and-scale.md` | Hook #145 — 검증 근거·기대값·규모 게이트 (거짓 PASS 방지) | 신설 2026-08-22 (사용자 지시). 계기 = DMF0082 에서 **수정·삭제가 아예 동작하지 않는 상태**가 |
| `wijmo-flexgrid-entry.md` | Hook — Wijmo FlexGrid 작업 진입점 (사용자 가이드 2 파일 의무 참조) | ⚠️ **Wijmo FlexGrid 코드 작성 / 수정 시 본 hook 이 단일 진입점** |
| `wijmo-insert-cell-dropdown.md` | Hook — Wijmo Insert Cell Dropdown 적용 패턴 | ⚠ **신규 화면의 Insert row 에 cell dropdown / popup 적용 시 의무 hook** |
| `wijmo-merge-row-data-only.md` | Hook — Wijmo 병합(MergeManager): 병합 경계는 **행 데이터만** 본다 | ⛔ `MergeManager.getMergedRange()` 에 **선택/포커스/편집 상태를 섞지 말 것.** |
| `wijmo-merge-sticky-content.md` | Hook — Wijmo Cell Merge + Viewport Sticky Content (viewport row 제한 패턴) | ⭐ 신규 화면에 세로 cell merge 가 필요하면 **viewport 안에서만 머지 범위 제한** 패턴 의무 적용. |

## 6. 실행 hook (저장·명령 시 자동 차단 — `.claude/hooks/`)

- `attach-context.ps1`
- `block-dev-commands.ps1`
- `check-db-fresh-source.ps1`
- `check-dbeaver-sql.ps1`
- `check-fe-import.ps1`
- `check-meta-sql.ps1`
- `check-notnull-insert.ps1`
- `check-rules-read.ps1`
- `check-ui-gates.ps1`
- `check-work-mode.ps1`
