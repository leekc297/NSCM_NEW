# DMF0035 컬럼 개인화('C') 축 정정 — `[E20260904-TSCAXIS]`

> 2026-09-04 · 대상 = 사내 Oracle(`OCGSCMD_P01`) · 짝 작업 = FE 공용 그리드 전환 + GRID COLUMN SET 신설

## 왜 (실측 근거)

DMF0035 는 컬럼 개인화(`SCM_MST_TITLESET_USER`, `USER_INQUIRY_COLUMN_TYPE_CODE='C'`)를
**`mktFcstWaterfall`** 축에서 읽는데, 그 시트명은 `SCM_MST_SHEET_COLUMNS` 에 **0행**이다.

저장 SP `SCM0002_SET_TITLESET_POPUP` 의 `'C'` 분기는 사내 라이브 L138~156 / L213~232 에서
`SCM_MST_SHEET_COLUMNS` 를 **SELECT 해서 INSERT** 한다:

```sql
SELECT ... FROM SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = P_PROGRAM_ID
   AND C.SHEET_NAME = P_SHEET_NAME
   AND C.COLUMN_WIDTH <> 0
```

⇒ `P_SHEET_NAME='mktFcstWaterfall'` 로 저장하면 **DELETE 만 되고 0행이 삽입**된다.
저장 가능한 유일한 축은 `Mkt Fcst Waterfall`(71행)이고, 그것이 **AS-IS 원본 축**이다
(`GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0035_MktFcstWaterfall/DMF0035_MktFcstWaterfall.cs:92`
`shtMain = "Mkt Fcst Waterfall"` → `:1746` btnColumn_Click 이 그 값으로 팝업 호출).
camel 축은 TO-BE 변환 시(`[E20260806-WF]`) 도입된 것이다.

SALES(DMF0022 `salesPlanWaterfall`)·BIZ(DMF0051 `Biz Plan Waterfall`)는 이미 축이 정합이라 **무변경**.

## 파일

| 파일 | 내용 |
|---|---|
| `00_BACKUP_PKG_DMF0035_BODY_20260904.sql` | 적용 직전 사내 라이브 원문(4,234줄) — **원복본** |
| `01_PKG_DMF0035_BODY_TSCAXIS_20260904.sql` | 정정본 (백업 대비 축 4줄 + 강제축 복원 2줄) |
| `02_MIGRATE_TITLESET_C_20260904.sql` | 기존 개인화 328행/23명 을 새 축으로 **복사**(원본 보존·멱등) |
| `03_ROLLBACK_20260904.sql` | 데이터 원복(복사분만 DELETE) + PKG 원복 절차 |
| `90_VERIFY_20260904.sql` | V1 상태 / V2 마커(TSCAXIS 4 + FORCEDAXIS 1) / V3 `'M'` 축 무수정 / V4 이행 결과 / V5 고아 0 |

## 변경 지점 (6줄 — 축 4 + 강제축 복원 2)

| 마커 | 위치 | 전 | 후 |
|---|---|---|---|
| `[E20260904-TSCAXIS]` | TITLE L3815 | `V_TITLESET_SHEET := 'mktFcstWaterfall'` | `:= 'Mkt Fcst Waterfall'` |
| `[E20260904-TSCAXIS]` | MAIN L2927 / L2957 / L2963 | `U.SHEET_NAME = V_P_SHEET_NAME` | `= V_P_COLS_SHEET` |
| `[E20260904-FORCEDAXIS]` | MAIN L2972~2973 (사용자 arm UNION) | `VISIBLE_FLAG='N' AND DEFAULT 공란` | `(VISIBLE_FLAG='N' AND DEFAULT 공란) OR COLUMN_NAME IN ('MEASURE','VERSION_NO')` |

### ⚠ FORCEDAXIS = 선행 결함 수정 (1차 적용 실패에서 발견)

1차 적용(축 4줄만) 직후 MKT 조회가 `ORA-00904: "F"."MEASURE"` 로 실패 → 즉시 원복했다.

- 동적 SQL 템플릿은 집계 특칙에서 **`F.MEASURE` 를 하드코딩**한다(L3591/3601/3616 — BALANCE류 기말값·LOC AVG).
- 그런데 사용자 titleset(`'C'`)이 있으면 컬럼목록이 **사용자 arm** 으로 가고, 거기서 L2960 이
  `MEASURE`·`VERSION_NO` 를 빼며 이를 되살릴 UNION arm 은 "숨은 컬럼(VISIBLE='N' + DEFAULT 공란)"만 담는다.
- 두 컬럼은 메타상 **VISIBLE='Y' · DEFAULT='Y'** 라 어느 쪽에도 안 들어가 목록에서 사라진다.
- ⇒ **축 변경과 무관한 선행 결함**이며, camel 축에 개인화를 가진 **23명은 이미 이 오류 상태**였다
  (전원 `MEASURE`/`VERSION_NO` 행 미보유 실측). 이번 수정으로 함께 해소된다.
- 시뮬레이션(읽기전용): 사용자 arm 컬럼 20 → 22 (강제축 2 복원).

**무수정**: 메저 개인화(`'M'`) 축 = `V_P_SHEET_NAME`(`mktFcstWaterfall`) 사용처 L317 / L327 / L401 / L425.
(라이브 `V_P_SHEET_NAME` 전체 출현 = 112 선언 + 317/327/401/425 `'M'` + 2927/2957/2963 `'C'` — 8곳 실측)

## 적용 순서

1. `01_...sql` 배포 → `ALTER PACKAGE SCM_MGR.PKG_DMF0035 COMPILE BODY` → VALID 확인
2. `02_...sql` 실행 (기대 삽입 328행)
3. `90_VERIFY_20260904.sql` 전 항목 확인
4. 화면 재조회로 회귀 확인 (MKT 조회 건수·컬럼 구성 불변, Column Set 저장→반영)

## 적용 결과 (2026-09-04)

| 단계 | 결과 |
|---|---|
| PKG 배포 | VALID · 컴파일 에러 0 · 마커 TSCAXIS 4 / FORCEDAXIS 1 |
| 이행 | **328행 삽입** → `Mkt Fcst Waterfall`/`'C'` = 342행 / 24명 |
| 고아 | 0 |
| 회귀(HTTP 실호출) | MKT MONTHLY/WEEKLY/DAILY 각 691행 · SALES 2,233행 · BIZ 15,899행 — 변경 전 기준선과 동일 |
| 강제축 | MKT 응답에 `MEASURE`·`VERSION_NO`·`NOTATION` 존재 확인 (사용자 arm 경유) |

## 적용 전 실측치 (기준선)

| 항목 | 값 |
|---|---|
| `SHEET_COLUMNS` DMF0035 / `Mkt Fcst Waterfall` | 71행 (`mktFcstWaterfall` = 0행) |
| `TITLESET_USER` `mktFcstWaterfall` / `'C'` | 328행 / 23명 |
| 그중 `SHEET_COLUMNS('Mkt Fcst Waterfall')` 매칭 | 328 / 328 (고아 0) |
| 대상 축 기존 중복 | 0 |
| `TITLESET_USER` `Mkt Fcst Waterfall` / `'C'` (적용 전) | 14행 / 1명 (2026-09-04 FE E2E 검증 시 생성분) |
