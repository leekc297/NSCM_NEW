# DMF0035 `SCM_MST_SHEET_COLUMNS` 전체 이관 (클라우드)

> 범위: **`PROGRAM_ID='DMF0035'` 전체 198행** (사용자 재확인 2026-09-16 — 테이블 전체 아님)
> 사내(ZIOUI1 = 로컬 환경이 바라보는 바로 그 DB) 기준 · 클라우드 **미적용**
> ⭐ **v2 재생성 (2026-09-16)** — 로컬 UI Category Setup 에서 DMF0035 컬럼 정보를 변경하여 재추출.
> v1 대비 변경 = **키 증감 0 · 값 변경 108건**(VISIBLE_FLAG 19 · DIVISION_ID 19 · USER_SELECTABLE_FLAG 1 · ATTRIBUTE1~6 69).
> 관련 원장: `REQ:CHAT-20260916-W67`(VERSION 빈값) / `REQ:CHAT-20260916-W68`(본 건)

## 1. 담는 것

DMF0035 3 시트의 **모든 컬럼 메타**를 통째로 싣는다. 특정 컬럼만 고르지 않으므로
**DIVISION_ID 를 조정한 행 · VISIBLE/DEFAULT 를 조정한 행이 모두 자동 포함**된다(사용자 지적 2026-09-16).

| SHEET_NAME | 행수 | VIS_Y | DEF_Y | DIVISION 공백 |
|---|---:|---:|---:|---:|
| Mkt Fcst Waterfall | 71 | 61 | 17 | 9 |
| Sales Plan Waterfall | 66 | 61 | 19 | 5 |
| Biz Plan Waterfall | 61 | 42 | 17 | 16 |
| **합계** | **198** | **164** | **53** | **30** |

이관 대상 컬럼 = **업무 32컬럼**(키 3 + 비키 29). 감사 4컬럼(`CREATED_BY`/`CREATION_DATE`/`LAST_UPDATED_BY`/`LAST_UPDATE_DATE`)은
값을 옮기지 않고 `'admin'`/`SYSDATE` 로 기록한다(메타 감사컬럼 규약).

## 1-1. v1 → v2 변경분 (로컬 UI Category Setup 반영)

직전 패키지(v1)를 임시표로 복원해 현재 DB 와 32 업무컬럼 전수 대조한 결과:

| 구분 | 건수 | 내용 |
|---|---:|---|
| 키 증감 | **0** | 추가·삭제 컬럼 없음 (198행 유지) |
| `VISIBLE_FLAG` `Y`→`N` | 19 | Biz Plan 6 · Mkt Fcst 8 · Sales Plan 5 |
| `DIVISION_ID` → 공백 | 19 | `'40'` 또는 `'82,81,81_UC,…'` → `' '` |
| `USER_SELECTABLE_FLAG` | 1 | Mkt Fcst `PROJECT_S_OP_REPORT` `' '`→`'Y'` |
| `ATTRIBUTE1~6` `' '`→`NULL` | 69 | UI 저장 시 공백을 NULL 로 기록하는 동작 |
| **합계** | **108** | |

## 2. 동반 반영된 사내 변경 — `[E20260916-DIVBLANK]`

사용자 지시: *"DMF0035 의 SHEET_COLUMNS 데이터 중 DIVISION 에 값이 비어있으면 VISIBLE='N', DEFAULT='N' 처리"*

- 대상 = `PROGRAM_ID='DMF0035' AND TRIM(DIVISION_ID) IS NULL`
  (`DIVISION_ID` 실측값은 NULL 이 아니라 **`CHR(32)` 단일 공백**)
- **1회차** (UI 변경 전): 대상 11행 → **10행 갱신** (1행은 이미 `N`/`N`)
- **2회차** (UI 변경 후): 대상 **30행** 으로 증가 → 규칙 미달 **9행 갱신**
  ⚠ UI Category Setup 은 `VISIBLE_FLAG` 만 `'N'` 으로 바꾸고 `DEFAULT_FLAG` 는 그대로 둔다.
  그 결과 `VIS='N'` + `DEFAULT` 공백/`'-'` 조합이 되어 **9행 전부가 '숨은컬럼 arm' 에 진입**,
  보이지도 않는 컬럼이 SP 의 `GROUP BY` 축으로 주입되는 상태였다(MKT FCST `PROJECT_STATUS` 포함).
  지시하신 `DEFAULT='N'` 규칙이 정확히 이 경로를 차단한다.
- 두 회차 모두 **재실행 0건(멱등)** · 잔여 위반 **0**
- 사내 적용 SQL·원복 = `_artifacts/_apply_corporate/DMF0035_SHEETCOL_DIVBLANK_20260916/`

**왜 필요했나** — FE 컬럼메타 SP `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` 의 division 필터는
`C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',') > 0` 이라 **NULL 만 통과**시킨다.
공백(`' '`)행은 어떤 division 에서도 걸러져 **화면에는 이미 안 보였는데**, 그중 4행이 `DEFAULT_FLAG='Y'` 라
워터폴 SP 의 컬럼목록(= `SELECT`/`GROUP BY`/`PIVOT` 축)에는 들어가 **보이지도 않는 컬럼이 집계 grain 을 쪼개고** 있었다.
(`[E20260910-GRAINFIX]` 와 동일 계보)

⚠ **`DEFAULT_FLAG` 는 공백이 아니라 `'N'`** 으로 둔다. 공백이면 `VISIBLE='N'` 과 결합해
'숨은컬럼 arm'(`VISIBLE_FLAG='N' AND RTRIM(DEFAULT_FLAG,' -') IS NULL`)에 걸려 **되레 재주입**된다.

### 변경 10행

| SHEET_NAME | COLUMN_NAME | 변경 전 VIS/DEF | 변경 후 |
|---|---|---|---|
| Biz Plan Waterfall | SCM_SITE_ID82 | Y / Y | N / N |
| Biz Plan Waterfall | PROJECT_CODE82 | Y / Y | N / N |
| Biz Plan Waterfall | PROJECT_NAME | Y / Y | N / N |
| Biz Plan Waterfall | BIZ_TYPE_NAME81 | Y / Y | N / N |
| Biz Plan Waterfall | SHIPTO_DESCRIPTION | Y / `' '` | N / N |
| Biz Plan Waterfall | INTERNAL_YN | Y / `' '` | N / N |
| Biz Plan Waterfall | CELL_PER_PACK | Y / `' '` | N / N |
| Biz Plan Waterfall | CELL_PER_MODULE | Y / `' '` | N / N |
| Biz Plan Waterfall | MODULE_PER_PACK | Y / `' '` | N / N |
| Biz Plan Waterfall | PRIORITY | Y / `' '` | N / N |

## 3. 파일 ↔ 작업 대조표

| 파일 | 내용 | 실행 |
|---|---|---|
| `01_SHEET_COLUMNS_DMF0035_MERGE.sql` | DMF0035 198행 **멱등 MERGE** (빌드 시점 사내 DB 추출) | 1회 실행 후 COMMIT |
| `02_VERIFY.sql` | V1~V7 검증 (행수·분포·규칙 충족·멱등·키 안전성·비파괴·런타임) | 01 직후 |

## 4. 멱등·안전 설계

| 항목 | 설계 |
|---|---|
| 키 | `(PROGRAM_ID, SHEET_NAME, COLUMN_NAME)` — ⚠ 이 표에 **PK/UNIQUE 제약 없음**(`PK_SCM_MST_SHEET_COLUMNS` 는 NONUNIQUE 인덱스). 사내 실측으로 **중복 그룹 0건** 확인 후 채택 |
| 멱등 | `WHEN MATCHED ... UPDATE ... WHERE` 가 **업무 29컬럼의 실제 차이**가 있을 때만 갱신. 감사컬럼은 비교 제외 → **2회차 0행** |
| 비파괴 | `DELETE` 없음. 클라우드 전용 행은 보존되며 `02_VERIFY.sql` V6 로 사람이 판단 |
| 사내 전값 | `USING` 절은 값 리터럴만 — 사내 접속·사내 WHERE 없음 |
| NULL 안전 | 차이 판정 = `DECODE(T.c, S.c, 0, 1) = 1` (NULL=NULL 을 동일로 처리) |

## 5. 멱등 실증 (사내 2026-09-16)

| # | 시험 | 결과 |
|---|---|---|
| ① | 사내 원표(이미 동기)에 그대로 실행 | **merged 0행** — 동기 상태에서 무동작 확인 |
| ② | 임시 사본(198행)을 **클라우드 = UI 변경 이전 상태**로 모사한 뒤 1회차<br>(VIS/DIVISION 23행 되돌림 · DEFAULT 공백 5행 · ATTRIBUTE 공백 3행 · **4행 삭제**) | **merged 21행** |
| ③ | 동일 사본에 2회차 | **merged 0행 — 멱등 확인** |
| ④ | 적용 후 사본 ↔ 사내 원표 업무 32컬럼 `MINUS` 대조 | **불일치 0행** · 사본 행수 **198** 복원 |

> 시험용 테이블은 검증 후 `DROP ... PURGE` 완료 (사내 원표 무변경).
> ⚠ 검증 절차 주의: MERGE 문의 대상 테이블명을 사본으로 **치환**해야 한다. 치환을 빠뜨리면 사본이 아니라
> 원표에 실행되어 (이미 동기이므로) 0행이 나오고 **검증이 통과한 것처럼 보인다**. v2 스크립트는 치환 ASSERT 를 건다.

## 6. 영향 고지

- **BIZ PLAN(TYPE=Business Plan) 조회**: 숨은 grain 축 4개(`SCM_SITE_ID82`/`PROJECT_CODE82`/`PROJECT_NAME`/`BIZ_TYPE_NAME81`)가
  컬럼목록에서 빠지므로 **쪼개져 있던 행이 합쳐질 수 있다**(행 수 감소 방향). 합계는 불변.
  FE 표시는 변화 없음 — 이 컬럼들은 division 필터 때문에 애초에 Column Setting·그리드에 노출되지 않았다.
- **MKT FCST / Sales Plan 무영향**: 두 시트의 `VERSION_NO`·`MEASURE` 는 `DIVISION_ID` 가 채워져 있어 대상이 아니다
  (`[40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG]`).
- **개인화 잔존(미조치)**: `SCM_MST_TITLESET_USER` 에 위 4컬럼을 개인화한 사용자가 **각 1명** 있다.
  개인화 보유자는 ELSE 분기 조인으로 해당 축이 계속 따라붙는다. 정리하려면 별도 지시 필요(본 패키지 범위 밖).

## 7. 원복

`_artifacts/_apply_corporate/DMF0035_SHEETCOL_DIVBLANK_20260916/00_BEFORE_and_ROLLBACK.sql`
(적용 직전 11행 스냅샷 + 행별 원복 UPDATE)

## 8. 선행/후행

- 선행 권장: `_artifacts/_deploy_packages/DMF0035_VERCOL_CLOUD_20260916/` (MKT FCST VERSION 빈값 정정 `PKG_DMF0035`)
- 본 패키지는 메타 데이터만 바꾼다 — PKG·FE 변경 없음.
