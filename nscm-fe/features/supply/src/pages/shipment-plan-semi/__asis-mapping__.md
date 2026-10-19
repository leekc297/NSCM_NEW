# SCP0010 Shipment Plan SEMI — AS-IS ↔ TO-BE 매핑

> 판정 정정: `.atlas/gscm-design/SCP0010/convert-flow/goal.md`는 신규(NEW)로 판정했으나, 이번 회차(convert-react
> v3) 착수 시 `nscm-fe/features/supply/src/pages/shipment-plan-semi/`가 이미 14개 파일로 구현돼 있음을 확인했다
> (git 미추적 — 이전 회차 산출물이 커밋 없이 남아 있었음). skill.md 핵심 규칙("이전 전환 산출물이 있으면 새로
> 만들지 않는다")에 따라 **보완(gap-fill)으로 전환**했다. backup: `.atlas/gscm-design/SCP0010/backup/react-20260924T051225Z/`.
> AS-IS 원본: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0010_Shipment_Plan_SEMI/SCP0010_Shipment_Plan_SEMI.cs`(5257줄)+`.Designer.cs`.

## 1. 영역1 Layout

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `FindButton`(Click) | `hotkeyConfig.search` → `handleSearch`(`ShipmentPlanSemi.tsx`) | 구현 |
| `SaveButton`(Click) | `hotkeyConfig.save` → `handleSave` | 구현(단, `editable` 상태 게이트는 canOperate=PlanType 잠금 여부만 — EditButton 토글은 §5#4 사용자결정 대기) |
| `DeleteButton`(Click, `.cs` 본문 주석 1줄 NO-OP) | `hotkeyConfig.delete = () => undefined` | 구현(NO-OP 파리티, 버튼은 `SCM_ADM_MNU_BTN_MPG_M` 등록으로 노출 유지) |
| `EditButton`(잠금토글, buttonGuards #2/#3) | 미구현 — 표준 DataGrid 상시편집 모델로 임시 대체 | **미구현(사용자 결정 대기, design 01 §5#4)** — customButtons 에도 없음, 후속 필요 시 별도 작업 |
| `ExcelButton` | `SubTitle excelFileName='ShipmentPlanSemi'` | 구현(표준 컴포넌트) |
| `btnFix`(`BtnFix_Click`, 가드 CanUpdate/IsLock/`Get_IsSaveYn`, confirm 없음) | `handleFix` — hasButton+rows.length+canOperate 가드, confirm 없이 즉시 저장 | 부분구현 — CanUpdate/IsLock 개별 가드 대신 `canOperate`(PlanType FN/TE) 1개로 축약, `SCP0013_GET_PLAN_TYPE_SAVE_YN` 판정은 procedures.d.ts 미등록(convert-sp 후속)이라 미검증(ERROR) |
| `btnUnfix`(Fix 와 동일 가드 + MSG00016 confirm) | `handleUnfix` — 동일 가드 + `setAlert({type:'confirm', ...})` | 구현(Fix/Unfix confirm 유무 차이 재현) |
| `btnNew`(`SCM0002_ShipmentPlanInsertPopup`) | `handleNew` — 가드만 재현, 팝업은 미오픈(안내 alert) | **미구현(의도적 보류)** — SCM0002_ShipmentPlanInsertPopup 은 이 activity 의 design/00~03 분석범위 밖 별도 AS-IS 화면이라 추측 구현 금지(anti-simplification §1). 별도 design 서브태스크 선행 필요 |
| btnFix/Unfix/New 공통 disabled(`Set_FixButtonEnabled`, planType FN/TE 또는 planSeq≠max) | `canOperate = !isLockedPlanType` | 부분구현 — planSeq≠max 축은 Form 이 항상 자동 최댓값을 유지한다는 전제로 생략(§ShipmentPlanSemi.tsx 주석 근거) |
| `pnlCondition`(HidePanel) | `MainTitle openSearchArea/toggleOpenSearchArea` | 구현(표준 패턴) |

## 2. 영역2 조회조건

| AS-IS 콤보 | TO-BE SQL_ID | cascade/필터 | 상태 |
|---|---|---|---|
| cboDivision | `Division_SCP` | 무필터 | 구현 |
| cboOperGroup | `LookupCommon`(lookupType=`OPERATION_GROUP_SEMI`/`_EE`) | division EE 여부 분기 | 구현 |
| clbFromSite | `AllPlantSiteDescription_SCP` | 3갈래 클라 필터(EE_UC/EE/기타) | 구현 |
| clbToSite | `ShipmentPlanSEMIToStie1_SCP_ALL`/`ToSiteShipmentPlanSEMI1_SCP_ALL` | division 2원천 분기 + operationGroup 클라필터 | 구현 |
| clbElecType | `LookupCommon`(lookupType=`ELECTRODE_TYPE`) | 초기 1회, EE 여부로 Enabled 토글만 | 구현 |
| cboPlanDate→Type→Seq | `DATE_WEEKLY1_SCP_ALL`/`PlanType1_SCP_ALL`/`PlanSeq1_SCP_ALL` | 3단 cascade, PlanType 최신행/PlanSeq 최댓값 자동선택 | 구현 |
| cboOperGroup 이중배선(From/To Site 재필터 + `_curSheetName`) | Form 필터 재계산(division/operationGroup 의존 useMemo) + store `setFilter`의 sheetName 파생 | 구현(동등 효과 — React 는 상태기반이라 "그리드 시트명 갱신"은 조회시점 sheetName 파생으로 대체) |
| Period(dCalendar)+W26/W52/WLast | `PeriodField` From/To만 | **부분구현** — W26/W52/WLast 프리셋 버튼 미구현(보조 SP `SCM0001_GET_SCP_DAY_PERIOD`/`_DAILY_PLAN_PERIOD` 2종 TO-BE 미배포 확인, goal.md ②, convert-sp 후속) |
| Model(txtItemId+btnItem_Id) | `ItemByDivisionModal` | 구현(SCP0010 고유 `GetAllDivisionCheckedElectrode` 분기는 division 파라미터 미가공 그대로 전달로 근사 — EE_UC 전용 고정값 분기 없음 확인) |
| dead code 4건(SetChangedPeriod/GetLastPlanVersion/GetDivision/`ValidateUserInput("CHK_PERIOD")`) | 미이식 | 구현(파리티 — 의도적 미구현) |
| 필수 검증(Division/OperationGroup MSG00002, Period MSG00049/108) | `useShipmentPlanSemiValidation.ts` | 구현 |

## 3. 영역3 그리드

| 항목 | TO-BE | 상태 |
|---|---|---|
| 정보컬럼 27개(admin `SCM_MST_SHEET_COLUMNS` 등록 확인) | `shipment-plan-semi.columns.ts` fallback + `buildColumns`(admin 우선) | 구현 |
| EE 조건부 표시 3건(R-A) | `DIVISION_EE_ONLY_COLUMNS` 런타임 오버레이 | 구현 |
| 동적 D_/W_/M_ pivot(calendar SP, Bucket 무관 항상 전체) | `ShipmentPlanSemiGrid.tsx` `dynColMetas`/`dynamicColumns` | 구현 |
| 3-span 헤더 | `dynamicColumns` 중첩 columns(대/소/일) | 구현(SCP0009 와 공용 SP·동일 패턴) |
| Measure 세트(CELL/ELECTRODE, OperationGroup 기준) | `measureSheetGroup`(`ShipmentPlanSemi.tsx`) | 구현 |
| Bucket×chkSum visible 토글(§2.4, chkAll 예외 없음) | `isDynVisible` | 구현 |
| `SHIP_PLAN_AMEND` 편집가능 판정(BlockCellsChecking/_2) | `utils/shipment-plan-semi.editLock.ts` `isMainCellEditable` | 구현(Weekly "중복 주차 컬럼" 방어 로직 1건 미이식 — design 자체도 재현조건 미상으로 확인필요 남김, §6 open item 7 대응) |
| Weekly Dept Day 자동분배(R-DeptDist) | `utils/shipment-plan-semi.deptDayDistribute.ts` + `cellEditEndedHandler` | 구현(요일 코드 도메인 MON/TUE.../SUN 은 가정치 — AS-IS SP 반환값 실측 못함, 확인필요) |
| INVENTORY W_/M_ 후처리(마지막 D_ 값) | `displayRows`(useMemo) | 구현 |
| Fix 하이라이트(O_RC3) | `formatItemHandler`(fixedDayBindings/fixedWeekStarts) | 구현 |
| 인접 정보컬럼 세로 병합(R-I, Freeze=measure_label) | `col.allowMerging` 토글 loop | 구현 |
| 정보컬럼 전건 잠금(R-J) | `isMainCellEditable`의 `dynColKindOf(binding)===null → false` | 구현 |
| BOD 신규행 삽입(`InsertRow`, 4조건+T/S 2갈래) | 미구현 | **미구현** — `SCM0002_GetBODPopup` 대응 팝업이 design/00~03 분석범위 밖(전용 서브 분석 필요), anti-simplification §1 위반 방지 위해 보류 |
| 저장 셀단위 검증(MSG00084/MSG00317) | `cellEditEndedHandler`의 `isQtyInRange` | 구현(문구/로직 불일치 AS-IS 그대로 재현 — 0 허용) |

## 4. 그리드 동작 파리티 게이트 대조 (`grid-behavior-parity.md`)

| 판별축 | 판정 | 근거 |
|---|---|---|
| 셀 병합(SmartColMerge 5건, `.cs:389,466,1105,4456,4718`) | 구현 | `col.allowMerging` 토글, Freeze 경계(measure_label) 일치 |
| Lock 계열(SwitchLock 1/LockColumn 2/LockRange 22/LockRange2 1, 26건) | 구현(판정 로직으로 대체) | `isMainCellEditable`이 AS-IS LockRange 좌표계산을 division/bucket/DeptDay/BOD 순수함수로 재구현 — LockRange2(중복주차 방어, `.cs:3447`)만 미이식 |
| 셀 타입 콤보(`SetCellTypeCombo`) | 해당없음 | design/03 §0 DB 실측 — 이 화면 그리드 콤보/팝업 셀 0건 확정(정보컬럼 전건 read-only, pivot 은 숫자입력) |
| Freeze(`FrozenColumnCount` 상당) | 구현 | `measure_label` 컬럼 `frozen: true`(columns.ts) |

## 5. self-check 결과 (이번 회차, 2026-09-24)

| 축 | 상태 | 근거 |
|---|---|---|
| grep 10종(상대경로/console/inline style/any/direct cast/wijmo 직접/행상태필드/없는 export/deep import/감사키 빈문자열) | **PASS** | 전건 0-hit(`<FlexGrid` 매치 2건은 `useRef<FlexGrid>()` 타입 제네릭으로 JSX 직접 렌더 아님 — SCP0009 동일 패턴, 오탐 아님) |
| type-check(`pnpm --dir nscm-fe/features/supply type-check`) | **ERROR(도메인 패키지 기준 비0, 이 화면 기인 아님)** | 실행 결과 1건: `src/pages/integration-psi/IntegrationPsi.tsx(291,5) TS2353` — git 추적 기존 커밋(`646efe26`) 코드, 이 화면 미변경 파일. `shipment-plan-semi/` 폴더 내 오류 0건. Hard Boundary(convert-core §2.2)상 타 화면 수정 불가 — 원인 파일 자체는 고칠 수 없음, 이 화면은 개별로는 깨끗하나 패키지 전체 게이트는 이 오류 때문에 "0 error" 미충족 |
| lint(`pnpm --dir nscm-fe/features/supply lint:fix`) | **ERROR(도메인 패키지 기준, 이 화면 기인 아님)** | 실행 결과: `bod/Bod.tsx` 경고 2건 + `integration-psi/*` 에러 3건, 전부 `shipment-plan-semi/` 밖. 이 화면 내 lint 이슈 0건 |
| 경계 점검(`packages/shared|foundation` diff / 타 화면 폴더 diff) | PASS | `git status --short` 확인 — 이번 회차 변경은 `shipment-plan-semi/` 4개 파일(`useShipmentPlanSemiStore.ts`/`ShipmentPlanSemi.tsx`/`utils/shipment-plan-semi.save.ts`/`__asis-mapping__.md` 신설) 한정 |
| hotkeyConfig NO-OP 배선(DeleteButton) | PASS | `delete: () => undefined`(키 존재, 명시적 무동작, `false`/생략 아님) |

## 6. 확인 필요/미구현 종합

### 미구현(사용자 결정 또는 별도 서브태스크 필요 — anti-simplification §1, 추측 구현 금지)

1. **EditButton 잠금토글 UX**(design 01 §5#4) — AS-IS 명시적 토글 vs TO-BE 표준 상시편집 모델, 사용자 결정 대기.
2. **New(Insert Plan) 팝업**(`SCM0002_ShipmentPlanInsertPopup`) — 가드만 재현, 팝업 자체는 별도 AS-IS 화면 분석 필요.
3. **BOD 신규행 삽입 팝업**(`SCM0002_GetBODPopup`, `InsertRow` T/S 2갈래) — 별도 AS-IS 화면 분석 필요.
4. **W26/W52/WLast 프리셋 버튼** — 보조 SP 2종 TO-BE 미배포(convert-sp 후속, SCP0009 와 공유 가능성).
5. **Weekly "중복 주차 컬럼" 방어 잠금**(`LockRange2`, `.cs:3447`) — design 문서 자체가 재현조건 미상으로 확인필요 남김.

### 확인 필요(런타임 미검증 — PROC_M/SCP0013 procedures.d.ts 미등록, convert-sp 소관)

6. `SCP0013_GET_PLAN_TYPE_SAVE_YN`(저장가능 판정) — procedures.d.ts 에 SCP0013 SHEETS 없음, `canOperate` 가 대체 판정으로 임시 사용.
7. `PKG_SCP0010`의 `SCM_ADM_PROC_M` 파라미터 메타 0행(2026-09-24 재확인) — PROC_M 미등록 상태에서는 BE 더미 fallback 으로 실호출 시 파라미터 개수 불일치 실패 가능(`proc-m-empty-fallback-dummy-row-breaks-callproc` 메모리 선례). 배선은 완료, 런타임 미검증.
8. Fix/Unfix 저장 SP 실행체인 — `P_SCP0010_SAVE_SEMI_FIX_DS`(ora.py all_procedures 실측 확정, 2026-09-24) 배선 완료, PROC_M 등록 전 런타임 미검증.
9. Dept Day 요일 코드 도메인(MON/TUE.../SUN) — AS-IS SP 반환값 실측 못함, 가정치.
10. 저장 payload 24필드 중 `A`(discriminator), `p_biz_type` 의미 — design 문서도 "확인 필요"로 명시.

### 이번 회차 해소

11. **저장 payload `planType`/`seq` 필드 버그** — 기존 구현이 `row.plan_type`/`row.seq`(존재하지 않는 필드)를 읽어 항상 빈 문자열을 전송하던 결함을 발견·수정. `useShipmentPlanSemiStore`에 `appliedPlanType`/`appliedPlanSeq` 스냅샷을 신설하고 `buildSaveRows`가 이를 인자로 받도록 시그니처 변경(`utils/shipment-plan-semi.save.ts`, `ShipmentPlanSemi.tsx` 2개 호출부).

## 7. CommonCheckList [화면별] 대조 (`nscm-patterns.md §6`)

| 항목 | 판정 | 근거 |
|---|---|---|
| Cascade 콤보 filter 정확 | 통과 | Form.tsx 3갈래(FromSite)/2원천(ToSite) 클라 필터 구현, design 02 실측과 1:1 |
| 조회조건 필수 alert | 통과 | Division/OperationGroup만(design 01 §3), useShipmentPlanSemiValidation |
| 2줄+ 접기/펼치기 | 통과 | conditions(5필드: Division/OperGroup/PlanDate/Type/Seq/Period) vs extraConditions(FromSite/ToSite/Electrode/Model) — 6필드 초과 3단째부터 분리 규칙 적용 |
| CODE 아닌 NAME 표시 | 통과 | `toOptions`가 `NAME`우선(`|| CODE`) |
| Insert 시 확정 searchParams 기준 division | 미해당 | New 팝업 자체 미구현(§6 open item 2) |
| 셀 병합 AS-IS 동일 | 통과 | §4 grid-behavior-parity 대조 참조 |
| C/U/D/R 독립 확인 | 미확인 | 런타임 검증 필요(PROC_M 미등록으로 실행 불가, §6 open item 7) |
| 필요 영역만 재조회 | 통과 | `setFilter()`가 main+calendar 만 갱신, 저장 성공 후 동일 `setFilter()` 재사용 |
| 단축키 동작 | 통과 | hotkeyConfig 표준 배선 |
| SubTitle 공용 아이콘 순서 | 미확인 | 육안 확인 축(사용자 확인 필요) |

## 8. self-check 결과 요약

grep 게이트 PASS(0-hit) / type-check·lint 는 도메인 패키지 기준 비0이나 원인이 전부 타 화면(사전 존재, Hard Boundary 밖) — 이 화면 자체 파일은 0 error/0 warning. §5 표 참조.

## 9. DB 게이트 재확인 (이번 회차, ora.py 실측 2026-09-24)

| 게이트 | 상태 | 근거 |
|---|---|---|
| 메뉴 등록(2.7) | **등록 완료**(이번 회차) | `05_register.sql` 적용 + `SCM_ADM_MNU_M` 재조회 1행 확인 |
| 컬럼/Measure 메타(2.75) | 기존확인 | `SCM_MST_SHEET_COLUMNS` 27행 + `SCM_MST_SHEET_MEASURE` CELL 5/ELECTRODE 8 — 이미 등록돼 있었음(이전 회차 산출) |
| 콤보/Lookup 메타(2.76) | 기존확인 | `SCM_ADM_CMBO_SQL_M` 7종 + `SCM_ADM_LOOKUP_MASTER_DETAIL`(OPERATION_GROUP_SEMI/_EE/ELECTRODE_TYPE) 전건 등록 확인 |
| 권한 입력(2.8) | **등록 완료**(이번 회차) | `SCM_ADM_MNU_BTN_MPG_M` 11행 + `SCM_ADM_USER_GR_MNU_MPG_M` 2행 + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 22행 — 재조회 확인. `SCM_ADM_API_M` 4행은 이미 등록돼 있었음(convert-sp 추정) — 재사용, 신규 INSERT 없음 |
| SP 실행체인(2.9) | **PROC_M 등록 완료**(iter-2 재확인, convert-sp 진행분) | `PKG_SCP0010` VALID + GET/SAVE_DATASET/SAVE_FIX_DS/SAVE_WEEKLY 4개 전건 `SCM_ADM_PROC_M` 등록(SORT_ORD 순서 `ALL_ARGUMENTS` POSITION 과 일치 확인) — iter-1 시점엔 0행이었음. 단 이 등록 상태에서 파라미터 키 배선 버그 3건(G-01/G-02/신규 SAVE payload)을 iter-2 가 발견·수정 |

## 10. 종합 판정 (convert-core §4.3)

**ERROR** — FE 코드(3영역 로직) 구현 완료 + 메뉴/권한 게이트 등록 완료 + 컬럼/콤보 메타 확인 + SP 실행체인 PROC_M 등록 확인 + iter-1 gap-audit HIGH 2건과 iter-2 신규발견 1건(총 3개 파라미터 배선 버그) 수정 완료. 그러나 실제 브라우저 왕복(E2E) 검증은 이 세션 도구(ora.py 는 프로시저 직접 호출·커서 조회 미지원)로 수행하지 못해 아래 ERROR/미확인 축이 남아 "완료" 선언 불가:

- 조회/저장 라운드트립 실제 호출 미검증(정적 DB 메타 대조만 완료, 브라우저 또는 API 클라이언트로 실행 검증 필요).
- New/BOD 팝업 2건 미구현(별도 AS-IS 서브분석 필요, 추측 구현 금지) — iter-1 대비 변경 없음.
- SCP0013 저장가능 판정 SP 배선 미착수(Hard Boundary — 타 화면 메뉴 권한 등록 불가) — iter-1 대비 변경 없음.
- Weekly 동일 주차 반복컬럼 방어잠금 미이식(재현조건 자체 미상) — iter-1 대비 변경 없음.
- EditButton 잠금토글 UX 사용자 결정 대기.
- 브라우저 시각·조작감(셀 병합 렌더/드롭다운/toast) 사용자 확인 축 = 미확인.

## 11. iter 재검증·수정 내역 (v3, 이번 회차)

- 절차 0(회차 확인): `convert-flow/` 아래 `iter-N` 폴더 없음(goal.md/plan.md만 존재) — 이번 실행이 사실상 1회차 산출물 실사에 해당하나, 실제 폴더 산출물은 이전(미기록) 회차가 이미 만든 상태였음. plan.md 의 todo 는 §1(신규 골격)~§8(self-check) 전 항목이 이미 처리돼 있었고, 이번 회차는 gap-fill(백업→검토→버그 1건 수정→DB 게이트 등록→self-check→보고)로 수행.
- 변경 파일: `useShipmentPlanSemiStore.ts`(appliedPlanType/appliedPlanSeq 신설), `ShipmentPlanSemi.tsx`(호출부 2곳), `utils/shipment-plan-semi.save.ts`(buildSaveRows 시그니처), `__asis-mapping__.md`(신규).
- DB 변경: `05_register.sql` 39문 전건 적용(메뉴 1 + 라벨 3 + 버튼배선 11 + 그룹메뉴권한 2 + 그룹버튼권한 22).

## 12. iter-2 재검증·수정 내역 (이번 회차, retry — 직전 `react-gap-audit`(iter-1) issues 반영)

절차 0: `convert-flow/iter-1/gap-audit.md`(verdict fail, issues 7건)를 최우선 작업목록으로 반영. 이번 회차 사이
`SCM_ADM_PROC_M`이 `PKG_SCP0010`의 GET/SAVE_DATASET/SAVE_FIX_DS/SAVE_WEEKLY 4개 프로시저 전건(convert-sp 진행분,
이 activity 소관 아님)으로 채워져 있어, PROC_M COL_NM 을 `ora.py query`로 직접 재실측해 파라미터 키 버그를 정밀
검증할 수 있었다(iter-1 시점엔 PROC_M 0행이라 이 정밀검증 자체가 불가능했음 — §9/§10 참조).

### HIGH 2건 수정 (iter-1 gap-audit 지적, 원인 실측 재확인)

- **SCP0010-G-01** `useShipmentPlanSemiStore.ts` `setFilter()` — `P_SHEET_NAME`에 admin 컬럼메타
  SHEET_NAME 대신 `sheetName`(operationGroupId 기준 CELL/ELECTRODE 분기, 이미 §측정값 있었으나 배선만
  누락)을 전달하도록 수정. `ora.py query SCM_ADM_PROC_M`(SORT_ORD=13) + `ALL_ARGUMENTS`(POSITION=13,
  P_SHEET_NAME) 위치 일치 확인.
- **SCP0010-G-02** 동 파일 CALENDAR 필터 — 키를 `fromYyyymmdd/toYyyymmdd` → `startYyyymmdd/endYyyymmdd`로
  수정. `ora.py query SCM_ADM_PROC_M`(PROC_NM=PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN, SORT_ORD
  1/2 = startYyyymmdd/endYyyymmdd) 재확인.

### 신규 발견·수정 1건 (gap-audit 미포착 — PROC_M 이 iter-1 시점엔 비어 있어 검증 불가했던 영역)

- **저장/Fix/Unfix payload 키 불일치**: `ShipmentPlanSemi.tsx`의 `handleSave`/`saveFixDataset`이
  `{ pData, pUserId }`로 전송하고 있었으나, `SCM_ADM_PROC_M`(SAVE_SEMI_DATASET/SAVE_SEMI_FIX_DS 공통)
  등록 COL_NM 은 `data`/`sesUserId`(SORT_ORD 1/2, `ALL_ARGUMENTS` P_DATA/P_USER_ID 위치와 일치 확인) —
  BE `BaseService.makeProcedure`(L674)가 COL_NM 으로 `params.get(...)` 하는 name-lookup 바인딩이라
  키가 다르면 조용히 NULL 로 치환돼 저장이 전부 실패한다(G-01/G-02 와 동일 클래스의 결함). 두 호출부 모두
  `{ data, sesUserId }`로 수정.

### 확인·검증만 수행(코드 변경 없음)

- **SCP0010-G-07** Dept Day 요일코드 도메인 — `ora.py query "SELECT DISTINCT DEPARTURE_DAY FROM
  SCP_MST_SHIPMENT_SEMI_DEPT_DAY"` 실측 → MON/TUE/THU/SAT 확인, 기존 `DAY_CODE_MAP`(3자 영문 약어)과
  일치. `deptDayDistribute.ts` 주석을 "가정치"에서 "실측 확인"으로 갱신(로직 변경 없음).
  `SCM_ADM_PROC_M` GET 프로시저 4건 전건 등록 확인(§9 갱신) — SP 실행체인(2.9) 상태가 iter-1의
  "미배포"에서 "PROC_M 등록 완료(convert-sp 진행분), 위 2건 배선 버그 수정 완료"로 변경. 단 Weekly LOT
  SIZE 분배 저장(P_SCP0010_SAVE_SEMI_WEEKLY)은 여전히 `SCM_ADM_MNU_BTN_MPG_M`에 버튼 매핑이 없어
  트리거 경로 자체가 미배선(§9 재확인, 변경 없음).

### 미해결(Hard Boundary/anti-simplification 사유로 이번 회차도 보류)

- **SCP0010-G-03/G-04**(BOD 삽입 팝업/New 팝업) — 여전히 이 activity 의 design/00~03 분석범위 밖 별도
  AS-IS 화면 분석이 선행돼야 함(추측 구현 금지). 미착수.
- **SCP0010-G-05**(`SCP0013_GET_PLAN_TYPE_SAVE_YN` 판정 배선) — `PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN`
  이 `SCM_ADM_PROC_M`에 등록돼 있음을 이번 회차 확인했으나(`divisionId`/`planStartYyyymmdd`/`planType`
  /`o_rc1`), `procedures.d.ts`에 SCP0013 SHEETS 가 없어 표준 `useTabProcQuery`로 타입 안전하게 호출할
  수 없고, SCP0013 메뉴에 대한 버튼/그룹권한 매핑도 이 화면(SCP0010) 소관이 아니다(Hard Boundary —
  자기 화면 메타만 등록). SCP0009 도 동일 제약으로 미구현 상태(§6 open item 6). 미착수, 확인 필요 유지.
- **SCP0010-G-06**(Weekly 동일 주차 반복 컬럼 방어잠금, `LockRange2` .cs:3447) — design 문서 자체가
  재현조건을 확정하지 못한 상태(우선순위 낮음, 원 gap-audit 권고와 동일). 미착수.

### self-check(iter-2)

grep 게이트(관계경로 import/console/any/inline style/deep wijmo import/unknown 캐스트) 0-hit(Grep 도구
재확인) · `pnpm --dir nscm-fe/features/supply type-check` — 이 화면 0 error(에러 1건은 `integration-psi`
기인, Hard Boundary 밖) · `pnpm --dir nscm-fe/features/supply lint:fix` — 이 화면 0 error/0 warning(문제
5건은 `bod`/`integration-psi` 기인) · hotkeyConfig NO-OP(`delete: () => undefined`) 유지 확인.

### 이번 회차 미종결 사유(정직 보고, iter-2)

HIGH 2건 + 신규 발견 1건(총 3개 파라미터 배선 버그) 수정으로 "검색하면 항상 빈 그리드"·"저장이 항상
실패" 상태는 해소됐으나, 실제 브라우저 E2E 호출 검증은 이 세션에서 수행하지 못했다(DB 메타데이터
위치·이름 대조로 정적 검증만 완료 — `ora.py`에 프로시저 직접 호출/커서 조회 기능이 없어 런타임 왕복
검증은 별도 환경 필요). BOD/New 팝업 2건, SCP0013 판정 배선, Weekly 반복컬럼 잠금은 여전히 미해결.

## 12. iter-3 (convert-react retry — iter-2 gap-audit 잔여 issues 처리)

`iter-2/gap-audit.md`(verdict fail)가 남긴 issues 8건 중 별도 AS-IS 서브분석이 필요한 G-03/G-04를
제외한 6건(G-05/G-06/G-08/G-09/G-10/G-11)을 이번 회차에서 처리했다.

- **SCP0010-G-08**(주석 드리프트) — `ShipmentPlanSemi.tsx:191-193` `handleFix` 주석을 "PROC_M 미등록"
  →"PROC_M 등록 완료(iter-2, ora.py 재실측 확인), E2E 런타임만 미검증"으로 갱신. 기능 변경 없음.
- **SCP0010-G-05**(SCP0013 판정 SP) — `ShipmentPlanSemi.tsx:134-140` 주석을 "procedures.d.ts 미등록"
  (원인 오분석)에서 "SCP0013 화면 소관 메뉴/버튼 권한에 등록돼 있어 SCP0010이 재사용 배선할 수 없다
  (Hard Boundary §2.2)"로 정정. 코드 동작은 변경 없음(여전히 `canOperate`=PlanType 잠금만 게이트) —
  교차 화면 SP 재사용은 이 activity 단독 범위 밖이므로 확인 필요로 유지.
- **SCP0010-G-09**(Model 팝업 division 파라미터) — `ShipmentPlanSemi.tsx:94-108`에
  `itemModalDivisionId`(useMemo) 신설. AS-IS `UIUtils.GetAllDivisionCheckedElectrode` 재현:
  `sc.divisionId`가 "EE"로 시작(EE_UC 포함)하면 `useTabComboQueries({filters:[COMBO.DIVISION]})` 콤보
  후보 중 접미 "UC" 아니고 접두 "EE" 아닌 코드들을 콤마조인해 치환, 그 외는 원본값 그대로.
  `ItemByDivisionModal preSearchParams.divisionId`에 배선(`:338`). SCP0009의
  `GetAllDivisionChecked`(EE_UC 전용 "81_UC" 고정값 분기)와는 다른 함수 — 복붙하지 않고 이 화면
  전용 로직으로 신규 구현.
- **SCP0010-G-10**(LBL 표기 불일치) — `ShipmentPlanSemiForm.tsx:227,230` `defaultValue`를
  "Plan-date"/"Plan-type"(하이픈)에서 DB 등록값 "Plan Date"/"Plan Type"(공백)으로 정정. `t()`가 정상
  로드 시 DB 값을 반환하므로 실질 영향은 i18n 리소스 로드 실패 시 fallback 문구뿐이나, 등록값과
  fallback을 일치시켜 드리프트를 제거했다. 신규 LBL 채번은 하지 않음(사용자가 하이픈 표기를 요구하면
  그때 채번).
- **SCP0010-G-11**(저장 payload `a`/`bizType` 필드 의미) — `ora.py`로 `PKG_SCP0010` PACKAGE BODY 전문을
  `DBMS_METADATA.GET_DDL`로 직접 실측(원문 정독, 추측 아님). 결론: `a`(JSON_TABLE PATH `$.A`)는
  `P_SCP0010_SAVE_SEMI_DATASET`의 UPDATE/INSERT/DELETE 3구간 어디에도 참조되지 않는 dead
  필드(`GT_SCP0010_DYNAMIC.A`로 복사만 되고 이후 미사용) — 빈 문자열 유지가 맞다. `bizType`은
  `SAVE_SEMI_DATASET` 경로에서는 `GT_SCP0010_DYNAMIC` INSERT 컬럼 목록에 없어 조용히 드롭되지만,
  `P_SEMI_FIX_HIST_DS`(Fix/Unfix 이력) 경로는 `SCP_ANL_SHIPMENT_PLAN_FIX.BIZ_TYPE` 조인키로 실사용 —
  `operationGroup`과 동일 값을 싣는 기존 구현이 맞음을 확인. `save.ts` 주석만 "확인 필요"→"확정"으로
  갱신, 값 자체는 변경 없음.
- **SCP0010-G-06**(Weekly 동일 주차 반복 컬럼 방어, `LockRange2`) — AS-IS `.cs` 원문(`BlockCellsChecking()`,
  `.cs:3218-3243`)을 재독해 "재현조건 미상"을 확정으로 전환: division 81/81_UC 계열 + Bucket=Weekly
  에서만 실행. 헤더 SP(`PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN`)가 ISO 주 경계가 월을 걸치면
  같은 ISO_WEEK 접미(마지막 2자리)를 가진 W_ 컬럼을 연속 2개 내려줄 수 있어, AS-IS는 두 번째 컬럼부터
  행 끝까지 통째로 잠그고 White로 되돌린다. `editLock.ts`에 `findDuplicateWeekLockStart`(순수함수,
  오름차순 W_ binding 목록에서 접미 중복 시작점 탐색) 신설, `EditableCtx.weekBindingsAsc` 필드 추가,
  `isEditableCell`의 Weekly 분기에 is81 조건부로 적용. `ShipmentPlanSemiGrid.tsx`에서
  `dynColMetas`(이미 calendar SP `SORT_ORDER_NO` 오름차순) 필터로 `weekBindingsAsc` 계산해 전달.
  `BlockCellsChecking_2`(비81 계열)에는 이 로직이 없음을 원문 재확인(is81 게이트로 재현).

### self-check(iter-3)

- grep 게이트(관계경로 import 3단+/console/any/inline style/wijmo 직접/unknown 캐스트/deep import) —
  Grep 도구 재확인 0-hit.
- `pnpm --dir nscm-fe/features/supply type-check` — 이 화면 폴더 0 error(도메인 전체 1 error는
  `integration-psi` 기인, Hard Boundary 밖, 변경 없음).
- `pnpm --dir nscm-fe/features/supply lint:fix` — 이 화면 폴더 0 error/0 warning(도메인 전체 3
  error/2 warning은 `bod`/`integration-psi` 기인, Hard Boundary 밖, 변경 없음).
- hotkeyConfig NO-OP(`delete: () => undefined`) 유지 확인.
- DB 게이트 전건 재실측(`ora.py`, 변경 없음 확인): 메뉴 1행(`MNU_URL=shipment-plan-semi`,
  `ROUTE_PATH=supply/shipment-plan-semi`) · 컬럼 27행 · Measure CELL5/ELECTRODE8 · 버튼매핑 11행 ·
  그룹×버튼 22행 · 그룹×메뉴 2행 · `SCM_ADM_PROC_M`에 GET/SAVE_DATASET/SAVE_FIX_DS/SAVE_WEEKLY/
  CALENDAR(SCP0009 공용) 전건 등록 확인.
- 경계 점검 — 이번 회차 변경은 `shipment-plan-semi/` 폴더 내 5개 파일(`ShipmentPlanSemi.tsx`,
  `components/ShipmentPlanSemiForm.tsx`, `components/ShipmentPlanSemiGrid.tsx`,
  `utils/shipment-plan-semi.editLock.ts`, `utils/shipment-plan-semi.save.ts`) + 이 문서뿐,
  `packages/*`·타 화면 폴더 diff 0.

### 이번 회차(iter-3)도 미해결(변경 없음)

- **SCP0010-G-03/G-04**(BOD 삽입 팝업/New 팝업) — 여전히 별도 AS-IS 화면(`SCM0002_GetBODPopup`/
  `SCM0002_ShipmentPlanInsertPopup`) 분석 선행 필요. 미착수.
- **EditButton 잠금토글 UX**(design 01 §5#4) — 사용자 결정 대기, 변경 없음.
- **Weekly LOT SIZE 분배 저장**(`P_SCP0010_SAVE_SEMI_WEEKLY`) 트리거 배선 — `SCM_ADM_MNU_BTN_MPG_M`에
  전용 버튼 매핑이 없어(재확인) 여전히 호출 경로 자체가 없음. 알고리즘 상세도 미확인.
- 브라우저 E2E(Search/Save/Fix/Unfix/Weekly 저장 라운드트립) — 이 세션 도구 범위 밖(§⑦ 정직 보고,
  v7/result.md 참조).

## 13. iter-4 (convert-react retry — G-03/G-04 AS-IS 서브분석 완료, MSG00000 교체)

`iter-3/gap-audit.md`(verdict fail)가 남긴 잔여 issues(G-03/G-04 미구현, G-05 확인필요, Weekly LOT
트리거 부재)를 이번 회차 작업범위로 확정하고 처리했다.

### G-03/G-04 AS-IS 서브분석(완료) — 여전히 미구현이나 사유가 "미분석"에서 "규모 확정·백엔드 미배선"으로 전환

이번 회차가 처음으로 두 AS-IS 소스를 전문 직접 read 했다(이전 회차는 "별도 서브분석 필요"라고만
남기고 실제로 열어보지 않았다):

- **`SCM0002_GetBODPopup.cs`**(GSCM.SCM.Popup.UIL, 429줄) — SCP0010 메인 그리드의 BOD 삽입
  (`InsertRow`, `.cs:3609-3838`)이 호출하는 팝업. `popupType=1`(SEMI)로 열리며
  `SCM.SCM0002_GET_BOD_SEMI_POPUP`을 조회해 체크박스 그리드로 BOD 후보를 보여주고, 선택+OK 시
  `List<BODPopup>`을 리턴한다. 이미 계획 존재하는 조합(division+from+to+transport)은 `IS_LOCK='Y'`로
  체크 고정+행 잠금 처리해 재선택 불가.
- **`SCM0002_ShipmentPlanInsertPopup.cs`**(GSCM.SCM.Popup.UIL, 1635줄) — `BtnNew_Click`(SCP0010 본화면
  `.cs:4896-4951`)이 여는 팝업. **자체 spread 그리드**(Div/Plan-date/Plan-type/Seq/Operation
  Group/Model/Project Code/Electrode/Project/Origin From Div/From Site/Origin To Div/To
  Site/BOD/Incoterms/Trans Mode/Voyage 7요일/L·T Day/From/To — 3-span 헤더, 15열)를 갖고, BOD_ID
  셀 클릭 시 **또 다른 팝업**(`SCM0002_GetBODItemPopup`, 이번 화면 범위 밖 — 미분석)을 열어 후보를
  고르며, division EE 여부로 Origin From/To Div 입력 활성/비활성이 갈린다. 저장은 2단계
  SP(`SCM.SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK`으로 사전 검증 → `SCM.SCM0002_SAVE_SHIPMENT_PLAN_NEW`로
  실제 저장) 왕복이다.
- **결론(규모 확정)**: New 팝업은 "이 화면의 부속 컴포넌트"가 아니라 **자체 그리드·cascade·중첩
  팝업·독립 저장 SP 체인을 가진 축소판 서브화면**이다 — `design/00~03`(SCP0010 본화면 3영역) 분석
  범위 밖이며, 정확한 재현을 위해서는 `SCM0002_ShipmentPlanInsertPopup` 자체의 `design/01~03` 상당
  분석(레이아웃/조회조건 15열 cascade/그리드 편집규칙)이 선행돼야 한다. 자매화면
  SCP0009(`shipment-plan-fg/ShipmentPlanFg.tsx:214-227`)도 동일한 AS-IS 부품(같은 두 팝업 클래스, 다른
  `popupType`/`p_prgram_id` 값)에 대해 동일하게 "미구현+MSG00000 임시 alert"로 결론 내려둔 상태를
  이번 회차에서 재확인했다 — 두 화면이 독립적으로 도달한 동일 결론이라, 화면별 성급한 개별 추측
  구현보다 **팝업 단위 공용 서브화면 설계**가 맞는 접근이라는 근거가 됐다(추가 사용자 결정 필요 사항으로
  남긴다 — Hard Boundary 상 이 activity 가 임의로 그 설계를 만들 수는 없다).
- **백엔드 배선 상태(신규 실측, ora.py)**: `PKG_SCM0002` 3개 프로시저 전부 `ALL_OBJECTS` 상
  VALID(`P_SCM0002_GET_BOD_SEMI_POPUP`/`P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK`/
  `P_SCM0002_SAVE_SHIPMENT_PLAN_NEW`)이나, `SCM_ADM_PROC_M` 재조회 결과
  **`P_SCM0002_SAVE_SHIPMENT_PLAN_NEW`만 등록(18행, 2026-09-17)**돼 있고 GET 2종은 0행(미등록)이다.
  `PKG_SCM0002`는 SCP0010 전용이 아닌 공용 popup 패키지라 이 PROC_M 등록은 skill.md §2.9가 명시한
  "PKG_<code> 는 convert-sp 소관" 범위 밖의 **교차 화면 공용 메타**로 판단해 이번 activity에서 등록하지
  않았다(Hard Boundary — G-05와 동일한 성격의 보류). 향후 New/BOD 팝업 서브화면 설계·구현 activity가
  진행될 때 이 등록 상태를 그대로 이어받으면 된다.
- **잔여 상태**: 여전히 미구현(가드만 재현, `ShipmentPlanSemi.tsx:214-232`). 새 G-ID 부여 없이
  기존 G-03/G-04 유지.

### MSG00000 → MSG00284 교체 (iter-2 권고 #7, 2회차 지연 후 이번 회차 반영)

`ShipmentPlanSemi.tsx:230` 임시 alert 문구가 참조하던 `MSG00000`은 `SCM_ADM_MSG_M` 재조회 결과
여전히 0행(미등록)이었다. 신규 채번은 메타 임의생성이라 anti-simplification 위반 소지가 있어, 이미
등록된 일반 메시지 중 의미가 가장 가까운 `MSG00284`("The grid is not ready.", EN 재확인)로 치환했다
— New 팝업 자체가 "그리드를 가진 서브화면"이라는 점에서 의미가 부합한다. `shipment-plan-semi.constants.ts`
`MSG.NEW_POPUP_NOT_READY`로 등록.

### self-check(iter-4)

- grep 게이트(상대경로 import/console/any/inline style/wijmo 직접/unknown 캐스트/deep import) —
  `shipment-plan-semi/` 폴더 재확인 0-hit.
- `pnpm --dir nscm-fe/features/supply type-check` / `lint:fix` — 아래 §self-check 결과(이번 회차) 참조.
- hotkeyConfig NO-OP(`delete: () => undefined`) 유지 확인(변경 없음).
- 경계 점검 — 이번 회차 변경은 `ShipmentPlanSemi.tsx`·`shipment-plan-semi.constants.ts` +
  이 문서뿐. `packages/*`·타 화면 폴더 diff 0. DB 변경 없음(조회·재확인만, `05_register.sql` 변경 없음).

### 이번 회차(iter-4)도 미해결

- **SCP0010-G-03/G-04**(BOD 삽입 팝업/New 팝업) — AS-IS 서브분석은 완료했으나 구현은 별도 서브화면
  설계 activity 선행 필요(위 결론 참조). 여전히 미구현.
- **SCP0010-G-05**(SCP0013 판정 SP Hard Boundary) — 교차 화면 정책 사용자 결정 대기, 변경 없음.
- **EditButton 잠금토글 UX**(design 01 §5#4) — 사용자 결정 대기, 변경 없음.
- **Weekly LOT SIZE 분배 저장** 트리거 배선 — 전용 버튼 매핑 없음, 변경 없음.
- 브라우저 E2E 라운드트립 — 이 세션 도구 범위 밖, 변경 없음.

## 14. iter-5 (New 팝업 구현 — G-03/G-04 해소, 2026-10-12)

iter-4 가 "별도 서브화면 설계 선행 필요"로 보류했던 New 팝업을, 자매 화면 SCP0009(FG)가 그 사이
공용 모달로 이미 구현해 둔 것을 확인하고 SEMI 에 배선해 해소했다. iter-4 기록("SCP0009 도 동일
미구현")은 그 뒤 SCP0009 가 구현하면서 stale 해진 상태였다.

### 사실 확인(2026-10-12 실측)

- **공용 모달 존재**: `NewPlanModal`/`NewPlanBodModal`/`newPlan.ts`(순수 로직 util, vitest 30건)가
  이미 `programId: 'FG'|'SEMI'` 로 양쪽을 지원하도록 설계돼 있었다. SEMI 분기(Project Code 컬럼 숨김,
  toSite 마스터 PLANT, EE+A 가드 없음, 저장 payload projectCode/incoterms 공백)는 util·모달에 내장.
- **DB 준비(ora.py 실측)**: `SCM_ADM_MNU_BTN_MPG_M` 에 SCP0010 의 `newCheck/SEARCH`·`savePopup/SAVE`·
  `bodPopup/SEARCH` 3라우트 전건 등록(USE_YN='Y'), 그룹권한 각 2그룹. `SCM_ADM_PROC_M` 에
  `P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK`(15)·`SAVE_SHIPMENT_PLAN_NEW`(18)·`GET_BODITEM_FOR_SUPPLY_POPUP`(11)
  등록. 공용 콤보 6종(BODItem_SCP/SiteMasterAll_SCP/OriginDivision_SCP/ProjectCdName_SCP/
  OperationGroup_SCP/OperationGroupEE_SCP) 전건 `SCM_ADM_CMBO_SQL_M` 등록. 모두 이전 회차
  (11·12_register*.sql, 2026-10-07)에 SCP0010 까지 등록돼 있었고 FE 배선만 누락이었다.

### 변경(FE)

- **공용 위치 추출**: `NewPlanModal`·`NewPlanBodModal`·`newPlan.ts`(+test)·scss 를
  `features/supply/src/pages/shipment-plan-fg/` 에서 `features/supply/src/components/newPlanModal/` 로
  이동(git mv). 모달이 `shipment-plan-fg.constants` 에 결합돼 있던 i18n 코드(LBL/MSG/제목)·
  Operation Group 콤보 분기·`isSaveResultFailure` 를 자기완결 `newPlan.constants.ts` 로 분리.
  Operation Group 표시 콤보는 `operationGroupComboArgs(programId, ee)` 로 FG(전용 SQL_ID)/
  SEMI(LookupCommon+OPERATION_GROUP_SEMI/_EE) 분기. 공용 배럴 `features/supply/src/components` 에 추가.
  SCP0009 는 import 경로만 공용 배럴로 갱신(로직 불변, vitest 30건 그대로 통과).
- **SCP0010 배선**(`ShipmentPlanSemi.tsx`): `handleNew` 의 임시 alert(MSG00284 "Grid 가 준비되지
  않았습니다") 제거 → 가드(권한/PlanDate/canOperate) 뒤 공용 `NewPlanModal` open. `context.programId='SEMI'`,
  `onSaved`=비EE 시 Item 조회조건 채우고 재조회 confirm(AS-IS .cs:4932-4948). EE+A 가드는 SEMI 에 없음
  (newPlan.ts isNewPlanBlocked). `MSG.CONFIRM_RESEARCH` 를 MSG00265→MSG01273 으로 교체(DB 실측:
  MSG00265="Excel 업로드 완료" 오매핑, MSG01273="다시 조회하시겠습니까?" 정답, 자매 SCP0009 동일).
  임시 상수 `MSG.NEW_POPUP_NOT_READY`(MSG00284) 제거.

### 검증

- type-check(`pnpm --dir features/supply type-check`) EXIT=0(전체 패키지 0 error).
- `newPlan.test.ts` 30건 전건 통과(이동 후 위치).
- 브라우저 E2E: SCP0010 New 클릭 → 공용 New 팝업 open 확인(임시 alert 아님). 그리드 SEMI 컬럼 정상
  (Project Code 숨김, 비EE division 40 이라 Origin Div/Electrode 숨김, 필수 표시 Model/From·To Site/
  BOD/Incoterms/Trans Mode). 콘솔·네트워크 오류 0. 저장 라운드트립(실데이터 생성)은 미실행.

### 후속 교정 — New 가드(유효 Plan 없음) + MSG 정정 (2026-10-12)

사용자 비교 검증 중 발견: New 팝업 컨텍스트 5컬럼(Div/Plan-date/Plan-type/Seq/Operation Group)
중 **Plan-type·Seq 가 빈칸**인 경우가 있었다. 원인은 조회조건의 planType/planSeq 가 비어 있던 것
— Plan Date 콤보(DATE_WEEKLY1_SCP_ALL)는 **실제 Plan 유무와 무관한 캘린더 주 목록**이라, 최신 주
(예: 당주 20261012)를 고르면 그 주에 Plan 이 아직 없어 하위 PlanType/Seq 콤보가 비고, 그 빈 값이
컨텍스트에 복사돼 3컬럼만 찍힌다. (Div/Plan-date/Operation Group 은 값이 있어 찍힘 — 컨텍스트 복사
자체는 정상, planType/seq 만 빈 값이었다. DB 실측: 예로 `40/20261012` 는 SCM_MST_PLAN 0건.)

AS-IS 는 이 "유효 Plan 없음" 상태에서 `Get_IsSaveYn()` 이 NO_DATA → N → **MSG00182("수정할 수
없는 플랜입니다")** 로 New 자체를 막는다(.cs:1523-1524). TO-BE handleNew 는 planType/seq 유무를
안 봐서 빈 플랜에도 팝업이 열렸다 → 파리티 갭.

- **`ShipmentPlanSemi.tsx` handleNew**: `if (!sc.planType || !sc.planSeq)` 가드 추가 → 빈 플랜이면
  `MSG.SAVE_NOT_ALLOWED` alert 후 return(팝업 미오픈). AS-IS Get_IsSaveYn NO_DATA 분기 대응.
  (FN/TE 잠금은 기존 `canOperate`+버튼 disabled 로 커버. 최신단계·오류복구까지의 완전한 SaveYn 판정은
  여전히 SCP0013 SP Hard Boundary — G-05.)
- **`shipment-plan-semi.constants.ts`**: `SAVE_NOT_ALLOWED` 를 `MSG00182`(TO-BE 미등록, 깨진 참조)
  → `MSG01196`("수정할 수 없는 플랜입니다.", DB 실측 등록 확인, 자매 SCP0009 동일)로 정정.
  handleSave 의 저장불가 문구도 같은 상수라 함께 교정됨.
- 검증: type-check EXIT=0, lint EXIT=0. 브라우저 — 빈 플랜 조회에서 New 클릭 → "수정할 수 없는
  플랜입니다" alert 확인(팝업 미오픈). 유효 Plan(예: division 82 는 당주 20261012 에 SE Plan 존재)
  에서는 planType/seq 가 채워져 5컬럼 전부 표시(Operation Group 이 찍히는 것과 동일 바인딩 경로).

### 후속 교정 — 저장 payload 비워지는 레이스 (2026-10-12)

New 팝업에서 행 입력 후 Save → `ORA-20002: Cannot insert NULL into NOT NULL column` 시스템 오류.
네트워크 실측: `newCheck/SEARCH` 는 행 데이터(itemId/toSite/fromSite/bodId…)를 보내 `RESULT_CODE='S'`,
그런데 직후 `savePopup/SAVE` 는 **같은 행 필드가 전부 빈 값**으로 전송돼 실패. 두 call-proc 은 runSave 에서
같은 `target` 참조를 읽는데, newCheck SP 가 수십 초 걸리는 동안(실측 24s) 그리드 행 객체가 비워졌다.

원인: 호출 화면이 `newPlanContext` 를 매 렌더 새 객체로 넘겨(참조 불안정) 모달의 `staticColumns`(useMemo
dep=context)가 재계산되고, 그리드 핸들러 재부착 effect(`[open, dataMaps, staticColumns]`)가 저장 대기 중
재실행되며 `invalidate()` → spurious `cellEditEnded`(Object.assign 으로 행 in-place mutate)가 행을 비웠다.

- **`NewPlanModal.tsx` handleSave**: `const target = rowsRef.current.map(r => ({ ...r }))` — 행 스냅샷(얕은
  복사)으로 payload 를 원본 mutate 로부터 분리. newCheck/save 가 동일 스냅샷을 읽어 일관.
- **`ShipmentPlanSemi.tsx`/`ShipmentPlanFg.tsx`**: `newPlanContext` 를 `useMemo`(deps=sc 5필드)로 안정화 —
  불필요한 모달 재렌더·재부착 churn 제거(레이스 근원 차단). FG 도 같은 구조라 동일 적용.
- 검증: type-check EXIT=0, lint EXIT=0, New 팝업 재오픈 정상(콘솔 0). 저장 실데이터 라운드트립은
  사용자 재시도로 확인 예정(DB 쓰기).

### 후속 교정 — 저장 플로우 UX (2026-10-12, 사용자 요청)

New 팝업 저장 흐름을 3단계로 정리(공용 `NewPlanModal`, FG/SEMI 공통):

1. **저장 전 확인("저장하시겠습니까", MSG.CONFIRM_SAVE) 제거** — 검증(필수/중복/PlanType) 통과 시 바로 저장.
   `MSG.CONFIRM_SAVE`(MSG00001) 상수도 orphan 제거.
2. **저장 성공 토스트를 팝업 위에서 표시** — 토스트 z-index 9999 > 모달이라 팝업 위에 뜬다. 기존엔
   `setToast` 직후 즉시 `modalClose` 라 팝업이 바로 닫혀 토스트가 메인에 보였다 → `SAVE_TOAST_LINGER_MS`(1200ms)
   동안 팝업을 열어 둔 채 토스트를 보여준다. linger 동안 `saving=true` 유지로 중복 저장 방지.
3. **팝업 닫기 → "다시 조회하시겠습니까"(onSaved)** — linger 후 `modalClose()` → `onSaved()`(비EE 시 Item
   조회조건 채우고 재조회 confirm MSG01273) 순으로 실행.

검증: type-check EXIT=0, lint EXIT=0. 실데이터 저장 라운드트립은 사용자 재시도로 확인 예정.

### 후속 교정 — 저장 성공 UX 를 SCP0013 과 통일 (토스트 복귀, 2026-10-13)

아래 "토스트 → 차단형 alert"(2026-10-12)를 사용자 요청으로 되돌려, 자매 New 팝업 SCP0013
(`production-plan-line/ProductionPlanInsertModal` handleSave)과 **동일한 저장 UX** 로 통일했다.

- **`NewPlanModal.runSave`**: 성공 시 `await setAlert`(차단형) → `setToast({type:'success'})` + `onSaved()` +
  `modalClose()` 로 변경(SCP0013 순서). linger·`closing` 플래그 제거, `finally setSaving(false)`. 저장 중에는
  `saving` 으로 Save 버튼 비활성 + call-proc 중 전역 busy 딤이 걸리고, 성공 토스트(z-index 9999)가 닫힘과
  함께 메인 위에 뜬다. onSaved 는 비EE 만 재조회 confirm(MSG01273), EE 무동작은 그대로(AS-IS .cs:4934-4948).
- **문구**: `MSG.SAVE_DONE=MSG00606`("저장되었습니다.") — `{0}개의 데이터가 저장되었습니다"(MSG00672)에서 변경
  (사용자 요청). `SAVED_COUNT` 상수 orphan 제거.
- 검증: type-check EXIT=0, lint EXIT=0. 브라우저 확인은 사용자 재시도.

### 후속 교정 — 저장 성공 알림: 토스트 → 차단형 alert (AS-IS 파리티, 2026-10-12)

위 "저장 플로우 UX"의 transient 토스트(2번 항목)를 되돌렸다. 사용자 보고: 저장 시 토스트가
안 보임(z-index 의심). 실측 결과 토스트는 `z-index:9999`(라이브 확인), 모달/Alert 은 MUI 기본
`1300`(테마·CustomDialog 오버라이드 없음)이고 레이아웃 조상에 stacking context 생성자도 없어
순수 z-index 트랩은 아니나, 토스트는 **포털이 아니라** `MDIContainer` 안에 그려지고(재조회
confirm 은 body 포털이라 늘 보이는 것과 대비) transient 라 1200ms 뒤 팝업이 닫히며 곧바로 뜨는
재조회 confirm 에 묻혀 놓치기 쉬웠다.

AS-IS `SCM0002_ShipmentPlanInsertPopup.SaveButton`(`.cs:649-652`)은 저장 성공 시 차단형
메시지박스 `MSG00004`("N건 저장되었습니다")를 띄우고 **OK 를 누른 뒤** 팝업을 닫는다 — TO-BE 가
토스트로 바꾼 것이 AS-IS 와 달랐다. 사용자 결정(2026-10-12)에 따라 AS-IS 파리티로 복귀:

- **`NewPlanModal.tsx` runSave**(FG/SEMI 공용): `setToast`+1200ms linger+`setTimeout(modalClose)` →
  `await setAlert({type:'alert', content: MSG.SAVED_COUNT})` 로 교체. 확인하면 `modalClose()` →
  `onSaved()`(재조회 confirm). `await` 필수 — 성공 alert 의 `closeAlert` 와 재조회 `setAlert` 가
  같은 message-store 라 await 없이 열면 재조회 confirm 이 즉시 사라진다. `SAVE_TOAST_LINGER_MS`·
  `setToast` orphan 제거. `closing=true` 로 확인 전까지 Save 비활성(중복 저장 방지) 유지.
- 재조회 confirm("다시 조회하시겠습니까?", `onSaved`)은 AS-IS `BtnNew_Click`(`.cs:4940-4946`,
  MSG00265→TO-BE MSG01273) 그대로 — 저장 성공 1회당 1회. 변경 없음.
- 저장 전 확인(AS-IS MSG00012)은 사용자 결정대로 제거 상태 유지.
- 검증: type-check EXIT=0, lint EXIT=0. 실데이터 저장 E2E 는 사용자 재시도로 확인 예정.

### 후속 교정 — New 팝업 컬럼 하드코딩 → 데이터(SCM_MST_SHEET_COLUMNS) 관리 (2026-10-13, 사용자 요청)

New 팝업 그리드 26열을 컴포넌트 하드코딩에서 admin 메타로 이관해 데이터로 관리한다.

- **등록 SQL**: `.atlas/gscm-design/SCP0010/design/07_newpopup_sheet_columns.sql`(+rollback). `PROGRAM_ID='SCP0010'`,
  `SHEET_NAME='Shipment Plan Insert'`, `COLUMN_NAME`=그리드 바인딩 키(camelCase). 콤보=FPComboBox, 편집후보=INPUT_TP_CD 'IO',
  Voyage 7열=2단 헤더(LARGE/SMALL_CLASS_LABEL_NAME). 기존 'Shipment Plan SEMI' 시트 플래그 관례 준용.
- **FE**(`NewPlanModal.tsx`, FG/SEMI 공용): 열릴 때 `POST /admin/menu/{menuId}/column { sheetNm, divisionId }` 조회 →
  admin 등록본을 바인딩 키 순서로 재정렬해 `staticColumns` 생성. 미등록(FG)·실패 시 하드코딩 fallback. `NEW_POPUP_SHEET`
  상수 신설(`newPlan.constants.ts`).
- **division별 가시성도 데이터 관리**(사용자 결정): EE 전용 3열(Origin From/To Div·Electrode)에 `DIVISION_ID`=EE 계열 목록
  (EE,EE_UC,EE_HM,EE_ST,EE_HD,EE_HG)을 넣어 SP `PR_GET_SHEET_COLUMN_LIST`가 요청 divisionId로 걸러 반환(정확 토큰 매칭).
  admin 경로는 `isColumnVisible` 코드 오버레이를 쓰지 않고 메타(DIVISION_ID 반환여부+VISIBLE_FLAG)로 가시성 결정 —
  필수 `*`만 런타임 오버레이. FG전용 projectCode 는 division 축이 아니라 VISIBLE_FLAG='N'(SCP0010=SEMI 항상 숨김).
  fallback 경로는 메타가 없어 `isColumnVisible` 유지. ⚠ EE 판정이 코드(startsWith 'EE')에서 메타(열거 목록)로 바뀌므로,
  목록에 없는 신규 EE 계열 division이 생기면 그 행에 DIVISION_ID 토큰을 추가해야 한다.
- 검증: type-check EXIT=0, lint EXIT=0. SQL 적용은 사용자가 수행(ora.py 조회 전용). 브라우저 E2E(비EE/EE 조회별 컬럼
  셋·Voyage 헤더·순서) 미검증 — 적용 후 확인 필요.

### 후속 교정 — 조회조건 저장 후 복원 누락 (2026-10-12)

사용자 보고: "condition 클릭해도 조회조건 저장 안 됨". 실측 결과 **저장은 정상**(F6 →
POST `/admin/menu/SCP0010/search-conditions` 200, "저장되었습니다")이나, **복원 로직이 없어** 재진입 시
빈 상태로 시작 → 저장이 안 된 것처럼 보였다. 자매 SCP0009 는 `restoreSearchConditions`(GET 후
searchCondition 패치)를 mount 에서 호출하는데 SCP0010 에는 누락돼 있었다(§2 "필수 검증" 구현 당시 미이식).

- **`useShipmentPlanSemiStore.ts`**: `conditionsRestored` 플래그 + `restoreSearchConditions` 액션 신설
  (GET `/admin/menu/SCP0010/search-conditions` → `paramNm/paramCtn` 역직렬화: 배열=split, 불리언==='true',
  그 외 문자열 → searchCondition 패치, 1회 가드). 날짜 키는 저장 제외라 복원 대상 아님(Form 자동선택이 채움).
  ARRAY_KEYS=fromSiteIds/toSiteIds/electrodeTypeIds, BOOL_KEYS=chkSum. 자매 SCP0009 와 동일 패턴.
- **`ShipmentPlanSemi.tsx`**: mount effect 에서 `void restoreSearchConditions()` 호출.
- 검증: type-check EXIT=0, lint EXIT=0. 브라우저 — 리로드 시 GET 200(저장분 7건) → Division 81/
  Operation Group Cell/Model/Bucket Daily/planType PR/planSeq 1 전부 폼에 복원 확인.

### 잔여

- 저장/BOD 선택 라운드트립의 실데이터 E2E 는 미실행(DB 쓰기 회피) — 조회·렌더·메타는 확인됨.
- 유효 Plan 조회에서 5컬럼 전부 표시는 바인딩 경로가 Operation Group 과 동일해 보장되나, 실화면
  캡처는 미확보(테스트 중 활성 탭이 당주=plan-less 주에 머물러 재현 못함). division 82 조회로 확인 가능.
- G-05(SCP0013 판정 SP)·EditButton·Weekly LOT 트리거는 이번 회차 범위 밖(변경 없음).
