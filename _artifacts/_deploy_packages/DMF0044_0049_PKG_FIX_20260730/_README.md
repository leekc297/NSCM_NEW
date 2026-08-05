# DMF0044 / DMF0049 PKG — MSSQL→Oracle 변환 결함 정정 (2026-07-30)

감사표: `Doc/화면분석서/DMF0044_0049_PKG_변환결함_감사표_v1.0.xlsx`

## 왜 필요한가

`PKG_DMF0044` 는 구형 자동변환본으로, MSSQL 관용구가 Oracle 의미로 옮겨지지 않은 지점이 남아 있었다.
이 부류는 **오류를 내지 않고 조용히 틀린 값을 보여주기** 때문에 화면을 열어보기 전까지 드러나지 않는다.
(`PKG_DMF0049` 는 2026-06-05 에 이미 전면 재변환되어 대부분 정상이었다.)

## 확정 결함과 조치 (총 33건)

| 규칙 | 결함 | 패키지 | 건수 | 근거 |
|---|---|---|---:|---|
| R4 | `CREATION_DATE`/`LAST_UPDATE_DATE` 에 `TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')` 대입 | 0044 | 2 | 세션 `NLS_DATE_FORMAT=RR/MM/DD` 라 **ORA-01861 로 조회 자체가 실패**. titleset 이 없는 사용자가 처음 들어올 때 재현 |
| R1 | `NVL(x,'') <> ''` → 항상 거짓 | 0044·0049 | 27 | AS-IS `ISNULL(x,'') <> ''` 의 오역. 실측 `NVL('ABC','') <> ''` → **0건**. CASE 가 언제나 ELSE 로 빠져 대체값만 표시됨 |
| R3 | `NVL(ATTRIBUTE1,'') <> 'MOVE'` | 0044 | 1 | `ATTRIBUTE1` 이 NULL 인 행이 통째로 탈락 |
| R5 | PIVOT IN 별칭 누락 | 0044 | 1 | 결과 컬럼명이 `'M_202601'`(따옴표 포함)이 되어 화면 바인딩 어긋남 |
| R6 | 정렬 CASE 의 `X = ''` | 0044 | 2 | Oracle 에서 성립하지 않아 정렬 순서가 AS-IS 와 달라짐 |

판정은 전부 **AS-IS 원문**(`Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1_DDL.sql`)과 대조해 확정했다.

## 결함이 아닌 것으로 판정한 항목

| 항목 | 건수 | 근거 |
|---|---:|---|
| `NVL(x, NULL)` | 77 | 동작상 no-op. Oracle 은 연결 시 NULL 을 빈문자로 취급하므로 표시 결과가 AS-IS 와 같다 |
| `LIKE '%' \|\| p \|\| '%'` | 2 | 실측 `'%'\|\|NULL\|\|'%'` → `'%%'` 이며 매치됨. 결함 아님 |
| `V_X := ''` 대입 | 85 | 술어가 아니라 대입 |
| `GT_` 테이블 언급 | 275 | 패턴 스캔 노이즈 |

## 적용 — ⭐ 클라우드 이관 시 실행할 파일 2개

> ⛔ **2026-08-05 정본 변경 — 본 패키지의 BODY 를 클라우드에 실행하지 말 것.**
> diff 검증(2026-08-05) 결과 `DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301/02_DB_SP/10·12_PKG_DMF004x_BODY.sql`(22:38 live 스냅샷)이
> 본 패키지 정정 전량(0044 33+477 / 0049 5건)을 포함한 **superset** 이다(+GTT TRUNCATE→DELETE 11건 + PK 센티널 NVL + L7416 CURRENCY 사용자 수정분).
> 본 패키지 판을 나중에 실행하면 **07-30 후속 3작업이 되돌아간다**. 클라우드 이관 정본 = `DBWORK_7UI_...` 판. 아래 절차는 이력 보존용.

**적용 순서 (구 안내 — 정본 변경으로 무효):**

| 순서 | 파일 | 비고 |
|---:|---|---|
| 1 | `02_DB_SP/02_PKG_DMF0049_BODY.sql` | DMF0049 (1차 정정 5건) |
| 2 | `02_DB_SP/03_PKG_DMF0044_BODY_v2.sql` | DMF0044 **1차 33건 + 2차 477건 누적 최종본** |

⚠️ `02_DB_SP/01_PKG_DMF0044_BODY.sql` 은 **1차본이며 `03..._v2.sql` 에 포함**되어 있다.
**실행하지 말 것** (실행하면 2차 정정이 되돌아간다). 이력 보존용으로만 남겨둔다.

```
python _artifacts/_diagnostics/ora.py exec "_artifacts/_deploy_packages/DMF0044_0049_PKG_FIX_20260730/02_DB_SP/02_PKG_DMF0049_BODY.sql"
python _artifacts/_diagnostics/ora.py exec "_artifacts/_deploy_packages/DMF0044_0049_PKG_FIX_20260730/02_DB_SP/03_PKG_DMF0044_BODY_v2.sql"
```

각 파일은 `CREATE OR REPLACE PACKAGE BODY` 단일 문 + 종결자 `/` 로 **멱등**이다. 순서 의존 없음.

SPEC 은 변경하지 않았다(시그니처 무변경) → `PROC_M` / `API_M` / `SHEET_COLUMNS` **메타 변경 없음**.
FE 변경도 없다. 즉 **DB 오브젝트 2개만 교체**하면 이관 완료다.

적용 후 확인:
```sql
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_DMF0044','PKG_DMF0049');   -- 4행 전부 VALID
SELECT COUNT(*) FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME IN ('PKG_DMF0044','PKG_DMF0049');          -- 0
```

본문에서 정정 지점 외에는 1바이트도 바꾸지 않았다(라인 수 보존).

## 사내 적용 결과 (2026-07-30 실측)

| 항목 | 적용 전 | 적용 후 |
|---|---|---|
| 두 패키지 SPEC/BODY | VALID | **VALID · ALL_ERRORS 0행** |
| `0044 GET_SALES_REPORTS_DATA` | **ORA-01861 실패** | **정상 (61열)** |
| `0044` 월 컬럼명 | `'M_202601'` (따옴표 포함) | **`M_202601`** (따옴표 컬럼 0) |
| `0044` SPREAD_TITLE / MEASURE / VERSION_POPUP | 43 / 16 / 0행 | 43 / 16 / 0행 (회귀 0) |
| `0049` SPREAD_TITLE / MEASURE / DATA | 24 / 1 / 0행 | 24 / 1 / 0행 (회귀 0) |
| 잔존 `NVL(x,'')` 비교 | 33건 | **0건** |

---

# 2차 정정 (2026-07-30, 사용자 지시) — `03_PKG_DMF0044_BODY_v2.sql`

> 지시: "비교문으로 사용하거나 JOIN 으로 사용하는 것은 `IS NOT NULL` 이나 `NVL(x,'-')` 로 변경.
> NOT NULL COLUMN 에서 초기값은 `NVL(x,'-')` 로 처리. 보이는 것은 유지."

## 왜 필요한가

MSSQL 은 빈 문자열이 실제 값이라 `ISNULL(x,'')` 를 **JOIN 키 정규화**와 **NOT NULL 컬럼 채우기**에 썼다.
Oracle 은 빈 문자열이 NULL 이므로 그 의도가 두 방향으로 깨진다.

- **JOIN/비교**: `NVL(a,'') = b` → 양쪽이 NULL 인 행이 매칭되지 않는다(AS-IS 는 `''=''` 로 매칭).
- **NOT NULL 컬럼 INSERT**: `NVL(x,'')` 가 NULL 이라 **ORA-01400 (NOT NULL 위반)** 이 난다.
  대상 테이블 실측: `DM_PLN_BP_FCST_REPORT_C` NOT NULL **26개** / `DM_PLN_SALES_PLAN_REPORT_C` NOT NULL **24개**.

## 적용 내역 (총 477건)

| 구분 | 치환 | 건수 |
|---|---|---:|
| 비교·JOIN | `NVL(a,NULL) = NVL(b,NULL)` → `NVL(a,'-') = NVL(b,'-')` | 2 |
| 비교·JOIN | 한쪽만 보정돼 있던 JOIN 의 **반대편도** `NVL(NULLIF(TRIM(x),''),'-')` 로 맞춤 | 6 |
| NOT NULL | 문자 컬럼 INSERT 식 → `NVL(x, '-')` | 441 |
| NOT NULL | 숫자 컬럼(QTY) INSERT 식 → `NVL(x, 0)` | 28 |

- 대상 INSERT 블록 **28개 전부** 처리(컬럼 목록 뒤 주석 때문에 초기 스캔에서 23개가 빠졌던 것을 파서 보완으로 해결).
- 컬럼↔식은 **위치 기반 1:1 대조**로 매핑하고, 개수가 어긋나면 건너뛰지 않고 오류로 드러나게 했다(누락 0).
- 이미 안전한 식(리터럴 / `NVL(...)` / `SYSDATE` / 변수 / 숫자)은 건드리지 않았다.
- 식 마지막 줄에 라인 주석이 있는 10건은 **닫는 괄호를 다음 줄로 내려** 주석에 먹히지 않게 처리했다.
- **표시용(SELECT 단순 출력) `NVL(x,'')` 는 지시대로 유지**했다.

## 남겨둔 1건 — 사용자가 직접 수정 (L7416)

`L7416  CASE WHEN( NVL(A.CURRENCY, NULL) = '-' ) THEN ''`

내가 AS-IS 대칭성(`ISNULL(A.CURRENCY,'') = '-'` → NULL 과 `'-'` 를 구분)을 근거로 보존을 주장했으나,
**사용자 확정: `NVL(A.CURRENCY,'-')` 가 의도에 합당하다** — NULL 과 `'-'` 는 같은 뜻으로 취급한다.
**이 1건은 사용자가 직접 수정**하므로 본 패키지에서는 손대지 않았다.
→ **2026-08-05 확인**: 사내 live 에 `NVL(A.CURRENCY,'-') = '-'` 로 수정 반영 완료 (`DBWORK_7UI_...` 22:38 스냅샷 diff 로 실측). 잔여 아님.

→ 이 판정은 룰로 반영됨: `Doc/_rules_v2/hooks/oracle-null-sentinel-and-notnull-default.md` (hook #119) §1·§2.

## 2차 적용 결과 (사내 실측)

| 항목 | 결과 |
|---|---|
| `PKG_DMF0044` SPEC/BODY | **VALID · ALL_ERRORS 0행** |
| 조회 7종 전후 비교 | 43 / 16 / 0 / 0(61열) / 24 / 1 / 0행 — **회귀 0** |
| 잔존 `NVL(x,'')` 비교식 | **0건** |
| 잔존 `NVL(x,NULL)` 비교식 | 1건 (위 의도적 보존분) |

## 별건 보고 — JOIN 조건 누락 의심

AS-IS `DMF0044_GET_SALES_REPORTS_DATA` 의 JOIN 은 `project_code / scm_site_id / dom_exp / fcst_type /
incoterms / CELL_MODEL_INFO / CELL_MODEL` **7개**를 ISNULL 로 비교하는데, TO-BE 대응 블록에는
`dom_exp` 등 일부가 **빠져 있다**. 조건이 적으면 매칭 범위가 넓어져 중복·과다 집계가 생길 수 있다.
이번 지시 범위(널 처리)를 넘으므로 **손대지 않고 보고만** 한다 — 확인 후 별건 처리 필요.

## 원복

정정 전 원본은 적용 시점의 `ALL_SOURCE` 그대로다. 되돌리려면 감사표의 정정내역을 역으로 적용하거나,
백업된 원문(`scratchpad/aud/PKG_DMF00xx_BODY.raw.sql`)을 `CREATE OR REPLACE` 로 다시 올리면 된다.

## 남은 확인

**화면 런타임 확인이 필요하다.** DMF0044(Sales Reports) / DMF0049(ETC Sales Reports) 진입 → 조회 → 저장까지.
특히 R1 정정으로 **부서명·팀명·모델명 등이 대체값 대신 실제 값으로 바뀌어 보일 것**이므로,
그 변화가 업무적으로 맞는지 확인이 필요하다.
