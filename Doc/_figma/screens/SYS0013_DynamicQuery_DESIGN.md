# SYS0013 Dynamic Query — 재개발 UI 설계 (AS-IS 캡쳐 기반)

> 원본: `Doc/화면설계서/SYS0013_01.png`(TABPAGE1) · `SYS0013_02.png`(TABPAGE2) — **AS-IS UI 캡쳐**. Figma 없음.
> 생성: 2026-06-26 · 캡쳐 이미지 판독(레이아웃·항목명·위치·그리드 컬럼).
> ⚠️ **추출 범위 = 구조만**: 레이아웃 / 항목 명칭 / 위치 / 그리드 컬럼. **시각 디자인(색·폰트·간격·컴포넌트 외형)은 AS-IS를 따르지 않고 기존 TO-BE 화면 표준 패턴 유지** (사용자 명시).
> TO-BE 디자인 표준 reference: admin `user-management`(SYS0002) / `group-user`(SYS0014) + `DMF0004`(tab) / `DMF0005`(panel). 컴포넌트 = `@shared/components`(MainTitle/SubTitle/Tab/Panel/DataGrid) + `@shared/lges`(TitleArea) + SearchArea/FormItem/CustomDropdown.

---

## 0. 화면 개요
- **SYS0013 = Dynamic Query** (동적 쿼리/리포트 정의·관리). admin 도메인.
- AS-IS는 **상단 탭 2개(Register / View)** 구조. 본 설계는 두 탭페이지를 그대로 매핑.
  - **TABPAGE1 = Query List** (저장된 리포트 검색 + 목록 그리드).
  - **TABPAGE2 = Query Designer/Detail** (리포트 메타 + 컬럼정의 그리드 + 조건 그리드 + SQL 미리보기 + 결과 미리보기).
- TO-BE 셸 표준: `MainTitle`(메뉴명/검색토글) → `SubTitle`(버튼바/건수) → 본문. 탭 = `@shared/components` Tab(또는 Register/View 상태 전환).

---

## 1. TABPAGE1 — Query List (Register 탭, `SYS0013_01.png`)

### 1.1 레이아웃 (위→아래)
```
┌ Tab bar: [Register] [View] ───────────────────────────────────────────┐
├ Search Area: Report Name [____]   Description [____]   Role [ALL ▼] ───┤
├ Grid (Query 목록) ─────────────────────────────────────────────────────┤
│  No | Report Name | Description | Role | Valid | Created By | Created   │
│     |             |             |      |       |            | Date | …  │
└────────────────────────────────────────────────────────────────────────┘
```

### 1.2 검색 영역 항목 (위치: 상단 1행, 좌→우)
| 순서 | 항목명 | 컨트롤 | 기본값 | 비고 |
|---:|---|---|---|---|
| 1 | Report Name | Text input | (빈값) | 리포트명 부분검색 |
| 2 | Description | Text input | (빈값) | 설명 부분검색 |
| 3 | Role | Dropdown | `ALL` | 권한(Role) 필터 |

> TO-BE: `SearchArea` + `FormItem` 3개 (Text 2 + `CustomDropdown` 1). Role 콤보는 admin 메타(권한 목록) 동적 fetch.

### 1.3 그리드 컬럼 (Query 목록)
| 순서 | 컬럼명 | 타입 | 정렬 | 비고 |
|---:|---|---|---|---|
| 1 | No | 행번호 | C | 시퀀스(표시용) |
| 2 | Report Name | Text | L | 리포트명 |
| 3 | Description | Text | L | 설명 |
| 4 | Role | Text | L | 권한명 (예: System Administrator) |
| 5 | Valid | Y/N | C | 사용여부 |
| 6 | Created By | Text | L | 생성자 (예: zytchoi) |
| 7 | Created Date | DateTime | C | 생성일시 (예: 2018-03-30 오후 4:0x) |
| 8 | Updated By | Text | L | 수정자 |
| 9 | Updated Date | DateTime | C | 수정일시 |

> TO-BE: `DataGrid`(@shared/components) + SHEET_COLUMNS 메타. 행 더블클릭/선택 → TABPAGE2(Designer) 진입.

---

## 2. TABPAGE2 — Query Designer / Detail (`SYS0013_02.png`)

### 2.1 레이아웃 (좌측 정의영역 + 우측 결과 미리보기)
```
┌ Tab bar: [Register] [View] ───────────────────────────────────────────┐
├ 상단 메타: Report Name [SITE Modify History]  Description [SITE 수정 이력]  Role [System Administrator ▼] ┤
├──────────────── 좌(정의) ────────────────┬──────── 우(미리보기) ────────┤
│ ▣ Column 그리드                          │  결과 미리보기 그리드          │
│   Column | Type | AGGREGATE | SEQNO | USE │  Col1 | Col2 | Col3 | Col4 …  │
│   …(컬럼 정의 N행)…                        │  (실행 결과 동적 컬럼)         │
│ ▣ Condition 그리드                        │                               │
│   Type | Column | OPERATOR | VALUE | USE  │                               │
│ ▣ SQL 미리보기 (read-only textarea)        │                               │
│   SELECT TOP 1000 [HISTORY_SEQ], …        │                               │
└──────────────────────────────────────────┴───────────────────────────────┘
```

### 2.2 상단 메타 항목 (위치: 상단 1행, 좌→우)
| 순서 | 항목명 | 컨트롤 | 예시값 |
|---:|---|---|---|
| 1 | Report Name | Text input | SITE Modify History |
| 2 | Description | Text input | SITE 수정 이력 |
| 3 | Role | Dropdown | System Administrator |

### 2.3 ▣ Column 그리드 (좌-상) — 조회 컬럼 정의
| 컬럼명 | 타입 | 정렬 | 컨트롤/옵션 | 비고 |
|---|---|---|---|---|
| Column | Text | L | (컬럼 식별자) | 예: HISTORY_SEQ / DIVISION_ID / SCM_SITE_ID … |
| Type | Dropdown | L | `System.Int64` / `System.String` 등 .NET 타입 | 데이터 타입 |
| AGGREGATE | Dropdown | C | `SUM` / `Group` (그 외 집계) | 집계/그룹 구분 |
| SEQNO | Number | C | 1,2,3… | 컬럼 순서 |
| USE | Y/N | C | Y/N | 사용여부 |

> 예시 데이터(SITE Modify History 쿼리, 15행): HISTORY_SEQ(Int64/SUM/1/Y), DIVISION_ID, SCM_SITE_ID, PLANT_ID, OPERATION_GROUP, SITE_DESCRIPTION, SITE_TYPE, CITY, COUNTRY, DEPT_ID, VMI_YN, VALID_YN, NEW_YN, SITE_HRCY, OSP_YN (2~15 = String/Group). ← **구조 예시일 뿐, 행 데이터는 동적**.

### 2.4 ▣ Condition 그리드 (좌-중) — 조건/파라미터 정의
| 컬럼명 | 타입 | 정렬 | 컨트롤/옵션 | 비고 |
|---|---|---|---|---|
| Type | Dropdown | L | `Parameter` 등 | 조건 유형 |
| Column | Text | L | `@PARAM_DIV` / `@PARAM_SCM` … | 파라미터/컬럼명 |
| OPERATOR | Dropdown | C | `=` 등 (비교 연산자) | 연산자 |
| VALUE | Text | L | (조건 값) | 값 |
| USE | Y/N | C | Y/N | 사용여부 |

### 2.5 ▣ SQL 미리보기 (좌-하) — read-only
- 멀티라인 텍스트 영역(편집 불가 또는 자동생성). 예: `SELECT TOP 1000 [HISTORY_SEQ], [DIVISION_ID], [SCM_SITE_ID], [PLANT_ID], [OPERATION_GROUP], [SITE_DESCRIPTION] …`
- ⚠️ **MSSQL `SELECT TOP` → TO-BE Oracle `FETCH FIRST n ROWS` 변환 대상** (DB 변환 룰). 표시 SQL은 TO-BE 표준에 맞춤.

### 2.6 ▣ 결과 미리보기 그리드 (우) — 동적 컬럼
- 헤더 `Col1 | Col2 | Col3 | Col4 …` (실행 시 정의 컬럼으로 동적 생성). 빈 상태로 시작.
- TO-BE: `DataGrid` + 동적 컬럼(staticColumns 미사용, 실행 결과 컬럼 바인딩).

---

## 3. TO-BE 컴포넌트 매핑 (디자인 표준 = 기존 패턴)
| AS-IS 요소 | TO-BE 표준 |
|---|---|
| 상단 Register/View 탭 | `@shared/components` Tab(`TabWrapper/TabItem`) 또는 상태 전환 |
| 검색 영역(Report Name/Description/Role) | `SearchArea` + `FormItem` + `CustomDropdown` (admin 메타 동적 콤보) |
| 목록/정의/조건/결과 그리드 4종 | `@shared/components` `DataGrid` + `@foundation/utils`(EditTracker/GridAction). FlexGrid JSX 직접사용 금지 |
| 좌(정의)·우(미리보기) 분할 | `@shared/panel` `PanelGroup`/`Panel` (resize) |
| SQL 미리보기 | read-only textarea (TO-BE 표준 input 컴포넌트) |
| 버튼(Register/저장/삭제/실행 등) | `SubTitle` `hotkeyConfig` + `useTabBtnPermissions`(권한 분기) |
| 색/폰트/간격/아이콘 | **AS-IS 무시** → TO-BE 디자인 토큰·SCSS Module 표준 (respond-to HD/FHD) |

## 4. 후속(요청 시)
- 본 MD는 **레이아웃·항목·그리드컬럼 구조**까지. 실제 화면 컬럼 메타(`SCM_MST_SHEET_COLUMNS`)·SP·권한·i18n 은 재개발 단계에서 표준 hook(#60~) 따라 작성.
- 기존 SYS0013 자산(`SYS0013_DynamicQuery_화면설계서_v2.0.xlsx` + 기 개발 FE/SP)과 cross-check 후 재개발 범위 확정 필요.
