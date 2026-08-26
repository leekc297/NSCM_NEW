# DMF0020 (Sales Future Price) — **클라우드 이관 후 / PKG 통합 전** 사내 백업 (2026-08-24)

> ⛔ **사고 기록.** 이 폴더는 원래 "클라우드 이관 **전**" 백업이었으나, 백업 스크립트를 같은 출력 폴더로
> 재실행해 **이관 후 내용으로 덮어써졌다.** 유실 = 오늘 바뀐 8본의 이관 전 사내 버전
> (`PKG_DMF0020` SPEC·BODY / `..._GET_SCM_MST_FUTURE_PRICE` / `..._GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` /
> `..._GET_SPREAD_TITLE_DATE` / `..._SAVE_SCM_MST_FUTURE_PRICE_ALL` / `..._SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` /
> `..._SAVE_SCM_MST_FUTURE_PRICE_POPUP`). git 미추적 + 딕셔너리 flashback 불가 → **복구 경로 없음**.
> 나머지 14본은 오늘 미변경이라 내용 동일(영향 없음).
> **이 폴더의 현재 값 = 클라우드 이관 직후 상태** = PKG 통합 작업의 원복 지점.

> 목적: 클라우드에 적용된 최신 SP/PKG 로 사내를 UPDATE 하기 전, **현재 사내 정본을 통째로 보존**한다.
> 원복 단위 = 이 폴더 하나. 소스(22본) + 배선 메타(3표) + 컴파일 오류 원문.

## 1. 보존 범위

| 구분 | 내용 | 위치 |
|---|---|---|
| PKG | `PKG_DMF0020` SPEC 195줄 / BODY 4,619줄 | `A_PKG/` |
| 단독 SP | 20본 (조회 12 · 저장 4 · 업로드/기타 4) | `B_SP/` |
| 배선 | `SCM_ADM_API_M` 12행 · `SCM_ADM_MNU_BTN_MPG_M` 14행 · `SCM_ADM_PROC_M` 63행 | `C_WIRING/` (멱등 MERGE) |
| 진단 | INVALID 7본의 `ALL_ERRORS` 원문 | `_meta/ALL_ERRORS.txt` |
| 목록 | 객체별 상태·LAST_DDL·줄수·백업파일 | `_meta/OBJECT_LIST.md` |

각 소스 파일은 `CREATE OR REPLACE` 로 시작해 **그대로 실행하면 원복**된다(헤더 주석에 원본 `LAST_DDL` 기재).

## 2. ⚠ 백업 시점 상태 — INVALID 7본

| 객체 | 자체 컴파일 오류 | 해석 |
|---|---|---|
| `PKG_DMF0020` BODY | **0건** | 의존 객체 무효화로 전파된 INVALID → **재컴파일만으로 VALID 가능성** |
| `DMF0020_GET_SCM_MST_FUTURE_PRICE` (⭐ main·priceBatch **조회** 배선 대상) | **0건** | 〃 |
| `DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` | 0건 | 〃 |
| `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` | 0건 | 〃 |
| `DMF0020_EXCEL_UPLOAD` | 0건 | 〃 |
| `DMF0020_GET_OWNER_DATA` | 0건 | 〃 |
| `P_DMF0020_GET_OWNER_DATA` | **2건** | **실 문법오류** — `L110 C42 ORA-00907 누락된 우괄호` |

`ALL_ERRORS` 0건 = 자기 코드는 멀쩡한데 참조 객체가 바뀌어 무효화된 상태다.
`ALTER ... COMPILE` 만으로 살아날 수 있으니, 클라우드본으로 덮기 전에 **현재본이 원래 정상이었는지** 판단할 근거가 된다.

## 3. 현재 배선 (교체 후 이 표대로 유지되는지 확인할 것)

| 시트 | 버튼 | 호출 대상 | 형태 |
|---|---|---|---|
| main | SEARCH | `DMF0020_GET_SCM_MST_FUTURE_PRICE` | 단독 SP |
| main | SPREAD_TITLE_DATE | `DMF0020_GET_SPREAD_TITLE_DATE` | 단독 SP |
| main | SAVE | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | 단독 SP |
| exchange | SEARCH | `PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO` | PKG |
| exchange | SAVE | `PKG_DMF0020.P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` | PKG |
| priceBatch | SEARCH | `DMF0020_GET_SCM_MST_FUTURE_PRICE` | 단독 SP (main 공유) |
| priceBatch | SAVE | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | 단독 SP |
| salesPriceRange | SEARCH | `PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` | PKG |
| salesPriceRange | SAVE | `PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` | PKG |
| salesPriceTemplate | SEARCH | `PKG_DMF0020.P_DMF0020_GET_SALES_PRICE_TEMPLATE` | PKG |
| titleSet | SEARCH | `DMF0002_GET_TITLESET_POPUP` | **공용 — 타 화면 소유** |
| version | SEARCH | `DMF0073_GET_VERSION_SALESPRICE` | **공용 — 타 화면 소유** |

⚠ **PKG 경유와 단독 SP 가 혼재**한다(UI별 PKG 원칙 미완 잔재). 같은 이름의 프로시저가 PKG 안에도,
단독으로도 존재하므로 클라우드본을 올릴 때 **배선이 가리키는 쪽**이 무엇인지 먼저 확정해야 한다.
`titleSet` / `version` 2건은 타 화면 소유 공용이라 **DMF0020 교체 범위 밖**이다.

## 4. 원복 절차

```sql
-- 소스 (필요한 것만 골라 실행 — 각 파일이 CREATE OR REPLACE ... / 로 완결)
@A_PKG/PKG_DMF0020_SPEC.sql
@A_PKG/PKG_DMF0020_BODY.sql
@B_SP/<객체명>.sql

-- 배선 (멱등 MERGE)
@C_WIRING/01_API_M.sql
@C_WIRING/02_MNU_BTN_MPG_M.sql
@C_WIRING/03_PROC_M.sql
```

원복 후 확인:
```sql
SELECT OBJECT_TYPE, OBJECT_NAME, STATUS FROM ALL_OBJECTS
WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%DMF0020%' ORDER BY 1,2;
```
