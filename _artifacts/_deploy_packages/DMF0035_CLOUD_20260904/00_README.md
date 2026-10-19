# DMF0035 Demand Plan Waterfall — 클라우드 이관 패키지 (2026-09-04)

> 범위 = **OLAP GRID 제거 → 공용 DataGrid 전환 + GRID COLUMN SET 신설 + TYPE(GUBUN)별 메타 축 정합**
> 직전 패키지 = `DMF0035_CLOUD_20260827`(메타 전세트) · `DMF0035_DB_CLOUD_20260831`(PKG 3본) · `DMF0035_FE_CLOUD_20260902`(FE)
> 취합 방식 = `_artifacts/_tools/make_cloud_package_full.py` **전 축 기계 스윕**(손나열 금지, hook #140) + 종속 PROGRAM 축 보강

---

## 1. 이번 변경 요지

| 구분 | 내용 |
|---|---|
| FE | Wijmo OLAP(PivotGrid) 제거 → **공용 `DataGrid`(@shared)** 로 재구현. wide 커서를 unpivot 없이 직접 바인딩 |
| FE | AS-IS 표시 규칙 복원 — 3단 헤더 병합 / MEASURE 까지 좌측 고정 / footer SUM / 행별 NOTATION / 버킷·Sum 토글 / 헤더 더블클릭 드릴 / 당기 Green Bold / 주말색 / **세로 셀 병합(SmartColMerge)** |
| FE | **GRID COLUMN SET 신설** — `@shared ColumnLayoutModal`, GUBUN별 `programId`+`sheetNm` 축. 표시·순서·폭·색 반영 |
| FE | Measure 모달은 기존 유지(축 정상). Excel/Filter/Sort 는 공용 경로 복귀 |
| FE | ⭐ **Waterfall Type(GUBUN) 변경 시 Grid 초기화** — TYPE 이 바뀌면 시트·종속 PROGRAM_ID·컬럼/메저 축이 통째로 바뀌므로 이전 결과는 무효(Division 변경과 동일 규약, 재조회는 Search) |
| FE | ⭐ **셀 콤보 명칭 표시** — `buildStaticColumns` 가 UI CATEGORY 메타를 통째로 승계(`cellCtrlObjTpCd`·`cellCboDataTp`·ATTRIBUTE1~5)하고 `comboParams`(`@mnuId`=GUBUN별 종속 PROGRAM_ID / `@divisionId`, 따옴표 전달)를 넘긴다. 미승계 시 dataMap 이 없어 **MEASURE 가 코드로 표시**됐다(사용자 신고 2026-09-04) |
| FE | ⭐ **메저·컬럼 설정 진입 시 서버값 재시드** — `/column`·`/measure` 응답의 `display`(개인화 반영본, 모달과 같은 원천)로 화면 진입·division·GUBUN 변경 때 **항상 덮어쓴다**. 스토어가 탭을 닫아도 남아 **이전 세션 선택이 서버 저장분을 이기던 문제** 해소(사용자 신고 2026-09-04). 모달 OK 직후 재조회는 덮지 않는다 |
| FE | `o_rc2` 를 **구조적 접근**으로 읽어 `procedures.d.ts` 블록 미병합 저장소에서도 빌드가 깨지지 않게(클라우드 TS2551 대응) |
| FE | ⭐ **헤더 높이 자급**(#93 총 48px = 3단 × 16) — 공용 `mapRawColumnsToWijmoColumns` 가 정적 컬럼에 넣는 `height:48` 이 wijmo 를 통해 **각 헤더 row 의 명시 height** 로 박혀 3단이 144px 로 벌어지는 문제. 공용 DataGrid 의 2026-08-28 정정본은 이를 되돌리지만 **그 이전 세대(클라우드)에는 없어** 실제로 드러났다(2026-09-04 사용자 신고). 화면이 `updatedLayout` 마다 직접 강제해 세대 차를 흡수한다 |
| DB | `[E20260904-TSCAXIS]` 컬럼 개인화(`'C'`) 축 4곳 `mktFcstWaterfall` → `Mkt Fcst Waterfall` |
| DB | `[E20260904-FORCEDAXIS]` **선행 결함 수정** — 사용자 arm 컬럼목록에 `MEASURE`·`VERSION_NO` 복원 |
| 메타 | 신규 메타 없음. 현행 상태 전량 재적재(시트 단위) + 종속 PROGRAM 축 동봉 |
| BE | **없음** (`C_BE/_NO_BE_CHANGE.md`) |

### DB 정정이 필요한 이유 (실측 근거)

저장 SP `SCM0002_SET_TITLESET_POPUP` 의 `'C'` 분기는 `SCM_MST_SHEET_COLUMNS` 에서 **SELECT 해서 INSERT** 한다
(사내 라이브 L138~156 / L213~232). `mktFcstWaterfall` 은 `SHEET_COLUMNS` 에 **0행**이라 그 축으로는
**DELETE 만 되고 0행이 삽입**된다 = Column Set 저장이 성립하지 않는다. 저장 가능한 유일 축이
`Mkt Fcst Waterfall`(71행)이며, 그것이 **AS-IS 원본 축**(`DMF0035_MktFcstWaterfall.cs:92` `shtMain`)이다.

`FORCEDAXIS` 는 그 과정에서 드러난 **선행 결함**이다 — 동적 SQL 이 `F.MEASURE` 를 하드코딩(L3591 등)하는데
사용자 titleset 이 있으면 컬럼목록에서 `MEASURE`/`VERSION_NO` 가 빠져 `ORA-00904` 로 조회가 죽는다.
사내에서는 camel 축 개인화 보유 23명이 이미 이 상태였고, 이번 수정으로 함께 해소된다.

---

## 2. 파일

### A_DB

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0035_SPEC.sql` / `02_PKG_DMF0035_BODY.sql` | 사내 라이브 정본(BODY 4,235줄). 직전 패키지 대비 **+37행**, 마커 `E20260904-TSCAXIS`(4) · `E20260904-FORCEDAXIS`(1) 포함 |
| `03A/03B_PKG_DMF0022_*` · `04A/04B_PKG_DMF0051_*` | **종속 PKG** — SALES/BIZ GUBUN 이 호출. 사내 최신본 |
| `10_SHEET_COLUMNS.sql`(71) · `11_SHEET_MEASURE.sql`(49) | DMF0035 시트 메타 — 시트 단위 DELETE 후 전량 재적재(hook #98 §9) |
| `12_SHEET_META_DEP_PROGRAMS.sql` | **종속 PROGRAM 메타** — DMF0022 `Sales Plan Waterfall`(66)·`salesPlanWaterfall`(65) / DMF0051 `Biz Plan Waterfall`(61) + MEASURE 31·9. **없으면 SALES/BIZ 가 컬럼 0 으로 조용히 빈다**(hook #148 G2) |
| `13_MIGRATE_TITLESET_C.sql` | 기존 컬럼 개인화(`'C'`)를 새 축으로 **복사**(원본 보존·멱등·PK NOT EXISTS) |
| `20_WIRING_AUTH.sql` | PROGRAM / MNU_M / MNU_BTN_MPG_M(8) / API_M(9) / PROC_M(32) / 권한(메뉴 5 · 버튼 40) |
| `30_MSG_LBL_MNU.sql` | MSG/LBL/MNU **INSERT-only(NOT EXISTS)** 87행 — 기존재 문구는 덮지 않는다 |
| `90_VERIFY.sql` | V1 PKG·마커 / V2 시트 메타 / V3 배선 / V4 권한 / V5 MSG / V6 titleset 축 / V7 고아 / V8 GRANT |

### B_FE — **통째 덮어쓰기 대상** (저장소 실경로 그대로, §1.8)

```
B_FE/nscm-fe/features/report/src/pages/demand-plan-waterfall/**        (19파일 = 폴더 전체)
```

`B_FE/` 하위를 **저장소 루트에 그대로 덮어쓰면 끝**이다. 경로 자체가 적용 명세다.
화면 폴더는 **전체**를 담았다 — 부분 이관 시 `pages/<화면>/index.ts` 누락으로 `resolveView()` 가 실패해
"Page Not Found" 가 된다(hook #148, 2026-08-14 실사고).

### FE_MERGE — **기존 소스에 부분 병합해야 하는 대상** (덮어쓰기 ⛔)

```
FE_MERGE/nscm-fe/configs/types/procedures.d.ts.DMF0035_BLOCK.txt
```

| 파일 | 병합 방법 |
|---|---|
| `procedures.d.ts.DMF0035_BLOCK.txt` | `nscm-fe/configs/types/procedures.d.ts` 안 `DMF0035: {` ~ **다음 MENU 블록 직전**까지를 이 내용으로 교체. 파일 전체 덮어쓰기 시 타 화면 블록이 통째로 사라진다(hook #148). 이번 변경 = 메인 3시트에 `o_rc2`(BASIS_DATE / ISO_WEEK) 선언 추가 |

> ⭐ **B_FE / FE_MERGE 분리는 상시 규약**(사용자 지시 2026-09-04) — 공용 배럴(`index.ts`), 타입 카탈로그
> (`procedures.d.ts`), 공용 상수처럼 **여러 화면이 한 파일을 공유하는 산출물**은 통째 덮어쓰면 타 화면분이
> 소실되므로 항상 `FE_MERGE/` 로 분리하고 병합 지점을 명시한다.

#### ⚠ FE 삭제 대상 (덮어쓰기로는 지워지지 않는다 — 적용자가 직접 삭제)

```
nscm-fe/features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/   (폴더 전체 4파일)
nscm-fe/features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.tsx
nscm-fe/features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.module.scss
```

### C_BE
`_NO_BE_CHANGE.md` — BE 변경 없음.

---

## 3. 적용 순서

1. **A_DB** `01` → `02` → `03A/03B` → `04A/04B` 배포 후 `ALTER PACKAGE ... COMPILE BODY` · 3본 VALID 확인
2. `10` → `11` → `12` (시트 메타) → `20` (배선/권한) → `30` (MSG/LBL/MNU)
3. `90_VERIFY.sql` **V6 먼저 실행해 클라우드 원본 titleset 행수 기록** → `13_MIGRATE_TITLESET_C.sql` → V6 재실행 대조
4. **B_FE** 를 저장소 루트에 덮어쓰기 → 위 **FE 삭제 대상** 제거 → **FE_MERGE** 블록 병합 → 빌드
5. `90_VERIFY.sql` 전 항목 확인 → 화면 실조회(3 GUBUN × 대표 division)

---

## 4. 이관 제외 (사유 명시)

| 대상 | 사유 |
|---|---|
| `SCM_MST_TITLESET_USER` 전량 | 사용자 개인화 데이터. 단 `'C'` 축 이행분만 `13_MIGRATE` 로 별도 처리 |
| `SCM_ADM_USER_MNU_SRCH_COND_M`(14행) | 사용자별 조회조건 개인화 |
| `SCM_ADM_SMS_MAIL_SEND_LOG`(52행) | 실행 로그 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408`(각 71행) | 날짜 백업 사본 테이블 |
| standalone `DMF0035_GET_MKT_FCST_WATERFALL` (**INVALID**) | PKG 합류로 대체된 레거시. 정본은 `PKG_DMF0035` 멤버 |
| `packages/shared/.../organisms/index.ts` | 이번 변경은 **주석 전용**(OlapPivotGrid 보존 사유 갱신) — 코드 영향 없음 |
| `@shared/.../olap-pivot-grid/*` | 사용자 지시(2026-09-04)로 **보존**. 현재 무참조지만 삭제 금지 |

---

## 5. 검증 (사내 실측 = 클라우드 기대 기준선)

| 축 | 사내 실측 |
|---|---|
| PKG | 3본 VALID · 컴파일 에러 0 · TSCAXIS 4 / FORCEDAXIS 1 |
| 조회 | MKT 691행(MONTHLY/WEEKLY/DAILY 동일) · SALES 2,233행 · BIZ 15,899행 — 변경 전과 동일 |
| 강제축 | MKT 응답에 `MEASURE`·`VERSION_NO`·`NOTATION` 존재(사용자 arm 경유) |
| 헤더 높이 | 총 48px (1단 16 / 2·3단 병합 32) · 정적 컬럼 48 세로 스팬 — 실측 |
| 화면 | 3단 헤더(MKT `2026-08 > W31 > 01` / BIZ `2026 > Q3 > 2026-09`) · frozen 12컬럼 · 집계행 · 당기 Green(`2026-08`) · 주말색(토 파랑/일 빨강) · 드릴(2026-09 → W36~W40) · 세로 병합(20px 기본, 40/80/120/620px 병합) |
| 콤보 표시 | MEASURE 가 명칭으로 표시 — 실측 `MKT FCST[P+P]` · `SCM FCST[R+P]` |
| TYPE 변경 | Waterfall Type 전환 즉시 그리드 비움 실측(행 0) |
| Column Set | 저장 Toast → 그리드 비움 → 재조회 반영 → 재진입 복원 → DB 기록 확인 |
| FE 검증 | 유닛테스트 29 통과 · 린트 통과 · 타입체크 화면 오류 0 |

---

## 6. 잔여 (침묵 금지)

1. **COLUMN_SETUP / MEASURE_SELECT 버튼 메타 미등재** — `SCM_ADM_MNU_BTN_MPG_M` 에 DMF0035 는 SEARCH 8건뿐.
   현재 두 버튼은 무게이트 노출이며, 등재 후 `hasButton` 게이트로 전환해야 한다.
2. **Measure 모달 초기 좌/우 복원** — 목록축(`measureSheetNm`)과 저장축(`titleSetSheetNm`)이 MKT·SALES 에서 달라
   새로고침 후 저장값이 모달에 복원되지 않는다. 사용자 결정(2026-09-04)으로 **이번 범위 미처리**.
3. **chkColor(실적구간 회색)** — 사용자 결정으로 전 TYPE 미구현(당기 Green Bold 로 대체).
4. **Version 팝업 sPeriod 계약 결손** — DMF0073 공유 SP 에 버전 기준일 컬럼 부재.
5. 홈 화면 권한목록(로그인 응답 `groups` 누락)은 **DMF0035 범위 밖** — `C_BE/_NO_BE_CHANGE.md` 에 기록.

---

## 7. 패키지 변경 이력 (같은 날 증분)

| 시각 | 내용 | 영향 |
|---|---|---|
| 최초 취합 | 전 축 기계 스윕 + 종속 PROGRAM 축 보강 | A_DB 13본 / B_FE 19파일 |
| 증분 1 | `B_FE`(통째 덮어쓰기) / `FE_MERGE`(부분 병합) **폴더 분리** (사용자 지시) | 구조 |
| 증분 2 | 세로 셀 병합(SmartColMerge) + 헤더 병합 규칙(월 합계 2·3단 단일 SUM) | `DemandPlanWaterfallGrid.tsx` · `utils/waterfall.merge.ts`(신규) |
| 증분 3 | 헤더 높이 자급(3단 총 48px) — 클라우드 구세대 wrapper 대응 | `DemandPlanWaterfallGrid.tsx` · `utils/waterfall.columns.ts` |
| 증분 4 | 메저·컬럼 설정 진입 시 서버값 재시드 | `DemandPlanWaterfall.tsx` · `useDemandPlanWaterfallStore.ts` |
| 증분 5 | `o_rc2` 구조적 접근(TS2551 방어) | `DemandPlanWaterfall.tsx` |
| 증분 6 | Waterfall Type 변경 시 Grid 초기화 · 셀 콤보 명칭 표시(메타 승계 + comboParams) | `DemandPlanWaterfall.tsx` · `components/DemandPlanWaterfallForm.tsx` · `components/DemandPlanWaterfallGrid.tsx` · `demand-plan-waterfall.constants.ts` · `utils/waterfall.columns.ts` |

**A_DB 는 최초 취합 이후 변경 없음** — 재생성 시점에 사내 라이브와 6/6 일치(PKG SPEC/BODY 3종),
`E20260904-TSCAXIS`(4) + `E20260904-FORCEDAXIS`(1) 마커 합계 5 실측 확인.
