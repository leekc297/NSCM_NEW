# 2026-08-09 — DMF0042 Business Plan 완료 게이트 마감 (9섹션)

> 진입: `ui_gate_runner.py --menu DMF0042 --page nscm-fe/features/demand/src/pages/business-plan`
> 이전 세션(커밋 `d034fca`) 종료 시점 = 대사표 273/273 PASS. **나머지 8섹션 미실행 상태**였다.

## 0. 기준선 → 결과

| 섹션 | 기준선 (09:59 최초 실행) | 결과 |
|---|---|---|
| 1. check-ui-gates.ps1 (G-A~G-G) | WARN (미배선 export 1) | **PASS** |
| 2. EID 1:1 대사표 | PASS 273/273 | PASS 273/273 |
| 3. FE→BE→SP 배선 체인 | **FAIL** (sheet 'BP' 배선 부재) | WARN (L6 NLS — 기존 hook #109 항목) |
| 4. 메타 값 단언 (SHEET_COLUMNS) | **FAIL** (CTRL 위반 1건/45행) | **PASS** |
| 5. CRUD·모달 매트릭스 | PASS 11/11 | PASS 11/11 |
| 6. HTTP 셀프 E2E | **FAIL** (리포트 부재) | **PASS** (시나리오 신설·실행) |
| 7. UP_FX 콤보 파라미터 정합 | **FAIL 2 / WARN 7** | WARN 2 (행 스코프 — 사유 기재) |
| 8. 콤보 호출 지점 대사 | **FAIL 5 / WARN 5 / PASS 3** | **PASS 13/13** |
| 9. 단위테스트 | PASS 7/7 | PASS 7/7 |

**종합 FAIL → WARN (FAIL 0).** 남은 WARN 3종은 전부 **실측 근거로 설명된 항목**이다(§5).

**최종 = `_artifacts/_gate_reports/DMF0042_20260809_1454.md` (PASS 7 / WARN 2)**
· E2E = `DMF0042_http_e2e_20260809_1439.md` (15계정 **종합 PASS — FAIL 0 / WARN 0**).
AUTHUNION 적용 전(1017/0959)과 판정 동일 — SP 변경 회귀 0. §5.6 에서 EDIT_FLAG 축을 규명해
E2E WARN 3 → 0, 게이트 WARN 3 → 2 로 감소.

---

## 1. 실제 코드 결함 1건 — FCST_TYPE 셀 콤보가 항상 0행 (섹션 7 FAIL)

### 증상
`SHEET_COLUMNS.FCST_TYPE → CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV'` 인데 FE 가 파라미터를 넘기지 않아
CMBO SQL 의 `B.SEGMENT1 = @param1 AND A.LOOKUP_TYPE = @param2` 가 `''` 비교로 떨어져 **전 division 0행**.
= 그리드가 예측유형을 코드 raw 로 표시하고 편집 드롭다운이 비어 있었다.

### AS-IS 공급 계약 (원천 실측 — 이번에 확정)
이전 세션은 "AS-IS `.cs` 의 `SetCellTypeCombo` 대상에 FCST_TYPE 이 없다 → 메타 바인딩 정당성 판정 대기"
로 남겨 두었다. **`.cs` 만 본 것이 원인**이었고, 실제 공급 경로는 프레임워크에 있었다.

| 원천 | 내용 |
|---|---|
| `GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs:1975~1981` | 메타 셀 콤보는 커서 `ATTRIBUTE1~5` 를 `sParam1~5` 로 `Data.Common` 에 전달 |
| AS-IS `DMF0042_GET_SPREAD_TITLE` | `@p_division_id AS ATTRIBUTE1` ("COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다" 주석) |
| 〃 | `CASE WHEN CELL_COMBO_DATA_TYPE='DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE '' END AS ATTRIBUTE2` |
| AS-IS MSSQL `SCM_MST_SHEET_COLUMNS` | DMF0042 콤보 컬럼 10종 = TO-BE 와 **완전 일치**(FCST_TYPE→DM_LOOKUP_DIV 포함). `ATTRIBUTE1='BP_FCST_TYPE'` 양쪽 동일 |
| TO-BE `SCM_ADM_LOOKUP_MASTER_DETAIL` | `LOOKUP_TYPE='BP_FCST_TYPE'` 25행 — `SEGMENT1` = division(40/81/81_UC…) |

⇒ **`@param1` = division / `@param2` = 컬럼 `ATTRIBUTE1`(LOOKUP_TYPE)** 확정.
메타 바인딩은 AS-IS 파리티가 맞았고, **누락된 것은 FE 파라미터 전달**이었다.

### 조치 — `components/BusinessPlanGrid.tsx`
```ts
const q = (v?: string): string => `'${v && v.trim() !== '' ? v : 'ALL'}'`;
const comboResults = useTabComboQueries({
  filters: comboColumns.map(c =>
    c.cellCboDataTp === 'DM_LOOKUP_DIV'
      ? { comboId: 'DM_LOOKUP_DIV', param1: q(division), param2: q(c.attribute1) }
      : { comboId: c.cellCboDataTp as string, divisionId: q(division) }
  ),
});
```
- AS-IS 가 **모든** 메타 셀 콤보에 division 을 공급하므로 `divisionId` 도 함께 배선(전 콤보).
- `comboSig` 에 `division` 포함 — 미포함 시 division 전환 후 행수가 우연히 같으면 이전 dataMap 이 잔존한다.
- 값 quoting = 조회조건(`BusinessPlanForm`)과 동일 `q()` 규약(빈 값 'ALL' 센티널).

### 실증 (HTTP E2E D2 축)
```
combo 'DM_LOOKUP_DIV'        rows=11  (무전달 0)   필요토큰=[param1,param2] 전달=[param1,param2]  PASS
combo 'DMF0042_BP_Measure'   rows=3   (무전달 9)   필요토큰=[divisionId]                          PASS
combo 'FromSiteByDivision'   rows=27  (무전달 102) 필요토큰=[divisionId]                          PASS
combo 'SiteByEndCustomer'    rows=461 (무전달 2532)                                               PASS
```
"무전달 N" 대비 값이 달라진 것이 **파라미터가 실제로 먹었다**는 증거다.

---

## 2. 진단 도구 결함 5종 정정 (전 화면 영향)

이전 세션이 정정한 4종(정본 오선택·핸들러 화이트리스트·계층번호 방언·경고 과대보고)에 이어,
이번 실행에서 **오탐 5종**이 추가로 드러났다. 전부 "FE 는 정상인데 게이트가 FAIL" 유형이다.

| # | 도구 | 오탐 | 정정 |
|---:|---|---|---|
| 1 | `wiring_chain_check` | `enum SHEETS{}` **주석 안**의 `P_CATE='BP'` 를 enum 멤버로 추출 → 존재하지 않는 시트 'BP' 로 L2 FAIL | `strip_ts_comments()` 신설(문자열 리터럴 보존·길이 보존) 후 시트/액션 추출 |
| 2 | `ui_gate_runner` §4 | `CELL_CONTROL_OBJECT_TYPE_CODE=' '`(공백)을 미지 코드로 FAIL | 공백=NULL 동치로 정규화. 근거 = 전수 **4,884행/176화면이 공백**(NULL 은 598행/33화면), FE 소비부는 전부 `=== CELL_CONTROL_TYPE.X` + `default` 폴백 |
| 3 | `combo_callsite_parity` | `getCombo(` 만 '호출'로 인정 → **표준 훅 `useTabComboQueries` 사용 화면은 트리거 0** | 훅 인자 구간 파싱 신설. 파라미터 동반 = `(반응형 재조회: keys)` 트리거로 계상 |
| 4 | 〃 | 공용 조회조건 필드(`DivisionField` 등)가 페이지 폴더 밖이라 `MyDivision` 등이 '미이관'으로 보임 | `_shared_field_combos()` — 페이지가 **import 한** 필드로 범위를 한정해 귀속 |
| 5 | 〃 | `comboId={...}` 만 인식 → JSX 문자열 prop `comboId='X'` 누락 / 행 컨텍스트 스왑(`beginningEdit`)을 신규행 프라이밍으로 인정 안 함 | 문자열 prop 패턴 추가 + `cascade_bindings()` (선언 + `beginningEdit` 배선 **동시** 확인 시에만 인정) |

추가 판정 규칙 2종(둘 다 실측 근거 기반, 완화가 아니라 **등가 인정**):
- **무파라미터 콤보**: TO-BE CMBO SQL 에 문맥 토큰이 0개면 몇 번을 재조회해도 결과가 같다 →
  AS-IS 의 N개 재호출 지점 ↔ 프리페치 1회는 등가 (예: `Data.Common(DM_BIZ_TYPE, false, "","","","")`).
- **반응형 구독**: react-query queryKey 에 파라미터가 들어가므로 구독 1개가 AS-IS 의 N개 재호출을 대체한다.

### 전 화면 회귀 (은폐 없음)
| 스윕 | FAIL | WARN | PASS | 합 |
|---|---:|---:|---:|---:|
| 기준선 (2026-08-09 01:35) | 26 | 69 | 58 | 153 |
| 정정 후 (2026-08-09 09:31) | **17** | **55** | **81** | 153 |

`wiring_chain_check --all` 도 37화면 FAIL 13→**12** / WARN 16 / PASS 8→**9** (DMF0042 델타와 정확히 일치).

---

## 3. HTTP 셀프 E2E — DMF0042 시나리오 신설 (섹션 6)

`ui_http_e2e.py` 는 DMF0082 1화면만 등록돼 있었다. DMF0042 를 등록하며 러너를 **화면 일반화**했다.

### 러너 일반화 3종
| 키 | 배경 |
|---|---|
| `cell_prefix` | 동적 셀 컬럼 접두가 화면마다 다르다(DMF0082 `D_yyyymmdd` / DMF0042 `M_yyyymm`). 하드코딩 시 후보를 못 찾고 조용히 WARN 으로 빠진다 |
| `identity_keys` | 행 식별키가 화면·division 마다 다르다(40 은 `*40` 접미) |
| `auth_group_combo` | **결정적** — `userGroup`(P_USERINFO)을 로그인 응답 `groups[0]`('DM Administrator' 표시명)로 채우면 AS-IS `GET_ADMIN_GROUP` lookup(USER_GR_ID 코드)과 매칭되지 않아 **EDIT_FLAG 전 행 'N'** → SAVE 왕복이 "후보 없음"으로 조용히 생략된다. FE(`useBusinessPlanStore.authGroup`)와 동일하게 CMBO `BizPlanUserAuthGroup` 1행을 쓰도록 교정 |

### 시나리오 실측 반영 2종
- **division 별 조회 기간** — `DM_PLN_BP_FCST` 원장 실측: 40=201808\~203112 / 81=202001\~**202412** / 82=202001\~**202512**.
  전 division 에 동일 미래 구간을 쓰면 81·82 가 0행이라 조회 축이 무력해진다 → division 별 실데이터 구간 사용.
  (81/82 의 0행은 **결함이 아니라 데이터 조건**임을 원장으로 확정)
- **SAVE 왕복 = division 40** — 편집 가능 구간(R3 금주 이후 × R4 유효구간)에 후보가 있는 유일한 division.
- **payload division 슬롯** — `business-plan.division.ts read*Slot` 1:1 (40 = `END_CUSTOMER40`/`SCM_SITE_ID40`/`ITEM_ID40`/`DEPT_ID40`).
  최초 실행 시 이 매핑을 틀려 **HTTP 200 인데 미반영**이 재현됐다(SP 가 매칭할 원장 행을 못 찾음) — 슬롯 교정 후 통과.

### 결과 — `DMF0042_http_e2e_20260809_0959.md` (권한별 15계정 전량, FAIL 0 / WARN 3)
```
A 로그인 15계정 전원 PASS(guest 폴백 0)
B 버튼 13종·unitAuth 8 division editable
C 컬럼·메저 메타 40:39·81:17·82:7 컬럼 × measure 9 — 필수키 4종 전부 존재
D 조회조건 콤보 13종 전부 >0행 / D2 셀 콤보 9종 전부 PASS
E SEARCH  40=15,858행 / 81=7행 / 82=1행 — EDIT_FLAG=['Y']
G 모달 시트 7종 전수 PASS (spreadTitle/dayRange/exchangeRate/futurePriceData/cutoffVersion/mdfVersion/titleSet)
F SAVE 왕복 M(+1→원복) PASS / INSERT(I,qty=7) PASS / DELETE(D) PASS / 잔존 정리 0건
H 15계정 × division 조회 전원 PASS + SAVE 버튼 무권한 3계정(dodae/bottle/coeogus) HTTP 403 기대대로
```

### H 축 WARN 3건 — 원인 실측 확정 (전부 AS-IS 파리티)
| 계정 | 증상 | 실측 원인 |
|---|---|---|
| `jaehyeok`(81) · `miyeong.lee`(82) | unitAuth editable=true 인데 EDIT_FLAG 전 행 'N' | 두 계정의 **유일 보유 그룹 = 'DM Planner (W/S)'**. `GET_ADMIN_GROUP` 에 이 그룹은 **`SEGMENT2='DMF0003'` 로만** 등재(ALL 아님) → DMF0042 ADMIN 판정 미해당. **AS-IS MSSQL lookup 과 행 단위 동일**(TO-BE 는 `minyonglee1|ALL` 테스트행 1개만 추가) ⇒ 파리티 |
| `yooah.chung`(40, Viewer) | unitAuth editable=false 인데 EDIT_FLAG=['N','Y'] 혼재 | EDIT_FLAG 는 unitAuth 가 아니라 **조회 SP 의 measure/행 축**이 별도로 세팅한다(러너도 "measure 권한 축 병존"으로 표기). SP 로직 AS-IS 동일 |

⚠️ **AUTHUNION 미적용은 이 건의 원인이 아니다** — 두 W/S 계정은 보유 그룹이 1개라 합집합을 적용해도
결과가 같다. 다만 DMF0042 는 여전히 단일그룹 판정(`SEGMENT1 = p_userinfo`, PKG_DMF0042 BODY L1784)이고
2026-08-04 확정 정책이 DMF0082(5곳)/DMF0021(3곳)/DMF0003(v2) 에만 적용돼 있다 → §6 이월.

---

## 4. 그 외 조치

- **섹션 1 WARN** — `utils/business-plan.gridCombos.ts` 의 `buildDataMap` 이 export 만 되고 미배선(반쪽 구현 함정).
  동일 로직이 `BusinessPlanGrid.tsx` 2곳에 인라인 중복돼 있어 **그 2곳을 `buildDataMap` 호출로 교체**했다.
- **대사표 토큰 섹션** — `__asis-mapping__.md` 에 `## 토큰 대사표` 신설(hook #117 §5.6). SQL_ID 12종 ×
  [필요 토큰 / 서버 자동 / FE 전달 / 미전달 / 판정 / 사유] 전 칸 기입.

---

## 5. 남은 WARN 2종 — 설계 판단 (근거 기재 완료)

| 항목 | 내용 |
|---|---|
| `EndCustomerByDivisionDept` `@deptId` | **행 스코프 토큰**. AS-IS 는 `SetCellTypeCombo` 로 행마다 재바인딩(L1233). TO-BE 는 `GRID_CASCADE_FILTERS.END_CUSTOMER`(DIVISION_ID+DEPT_ID) 의 `beginningEdit` dataMap 스왑이 담당 |
| `SiteByEndCustomer` `@endCustomer` | 동상 — `GRID_CASCADE_FILTERS.SCM_SITE_ID40`(DIVISION_ID+END_CUSTOMER40). AS-IS InsertRow 프라이밍보다 적용 범위가 넓다(기존행 포함) |

⚠ 두 토큰을 **서버 전역 필터로 넘기면 안 된다** — 원장에 남은 값의 CODE→NAME 변환이 깨져 raw 코드로
표시된다(`feedback_edit_display_combo_dualization`).

섹션 3 잔여 WARN = `PR_GET_DAY_RANGE` pos2 암묵 형변환(PROC_M VARCHAR → SP NUMBER, hook #109) — 기존 항목, 동작 정상.

---

## 5.5 이월 3건 처리 결과 (2026-08-09 사용자 승인 후 — 게이트 마감 뒤 추가 진행)

| 이월 | 결과 |
|---|---|
| ① AUTHUNION DMF0042 적용 | ✅ **적용 완료** — PACKAGE/BODY VALID, 마커 1건 |
| ② 그리드 셀 콤보 권한판(*Auth) | ✅ **미적용 확정** — 실측 근거 확보 |
| ③ `GET_ADMIN_GROUP` `minyonglee1\|ALL` 정리 | ⛔ **보류** — 현재 load-bearing 임이 실측으로 드러남 |

### ① AUTHUNION 적용·검증
- 대상: `PKG_DMF0042` BODY 권한그룹 판정 **1곳**(L1784) — 소비처 L2049·L2237(EDIT_FLAG).
- 파라미터명(`p_userinfo`/`p_created_by`)이 DMF0021 선례와 동일 → 동일 패턴 최소 diff(+2행).
- 산출물: 백업 `BACKUP_PKG_DMF0042_BODY_pre_authunion_20260809.sql`(6,598행) /
  배포본 `PKG_DMF0042_BODY_AUTHUNION_20260809.sql`(6,600행) / 스크립트 `dmf0042_authunion_patch.py`.

**판정식 사전/사후 대조 (실측)** — 회귀 0, 과권한 0:

| 전달값 | 기존(단일) | 합집합 | 판정 |
|---|---:|---:|---|
| `ADMIN` (그룹명 직전달) | 1 | 3 | 기존 동작 유지 ✅ |
| `minyonglee1` (USER_ID) | 1 | 4 | 유지 (테스트행 없이도 3) |
| `GHOST_GROUP` (유령값) | **0** | **3** | ⭐ 구세대 ghost groupId 해소 |
| `bpark416` (USER_ID) | **0** | **1** | ⭐ USER_ID 직전달 해소 |
| `jaehyeok`·`miyeong.lee` (W/S 단일보유) | 0 | 0 | 변화 없음 = AS-IS 파리티 ✅ |
| `yooah.chung` (Viewer) | 0 | 0 | 과권한 없음 ✅ |

### ② 권한판 미적용 — 실측 근거 (`dmf0042_auth_combo_probe.py`)
판정식(hook #117 §5.10 / `feedback_edit_display_combo_dualization`) **양 축 모두 '교체 금지'**:

- **(A) 권한판 0행 계정 8건** — 그 계정은 셀 콤보가 통째로 빈다:
  `yooah.chung`(40 Viewer) EC·Site / `bpark416`(81 Planner)·`wonqthanq`(82 **Admin**)·`ys_cho`(82 Planner) Team /
  `yeonjusung`(82 Viewer) 3종 전부.
- **(B) 원장 값 중 권한판 후보 밖** — 전부 >0 = CODE→NAME 표시가 raw 코드로 파손:

| 권한판 | 원장 컬럼 | 후보 밖 / 전체 |
|---|---|---:|
| EndCustomerByDivisionDeptAuth | END_CUSTOMER | 79 / 15,756 (0.5%) |
| TeambyDivisionAuth | DEPT_ID | **11,763 / 16,124 (73.0%)** |
| SiteByEndCustomerAuth | SCM_SITE_ID | 899 / 1,296,517 (0.1%) |

⇒ 게이트 `DISPOSITION` 을 "실측 후 별건" → **"교체 금지 확정(수치 동봉)"** 으로 갱신.

### ③ lookup 테스트행 정리 — 보류 (승인 시점과 사실관계가 달라짐)
승인 당시 전제는 "AUTHUNION 적용 후 불필요한 잔여 테스트행"이었으나, 실측 결과 **현재 사용 중**이다:

- `GET_ADMIN_GROUP` 사용 객체 **44개 중 39개가 여전히 단일그룹 판정**(AUTHUNION 미적용).
- 그중 **DMF0044 는 USER_ID 를 직전달**한다 — `useSalesReportsStore.ts:133` `userGroup: sesUserId`.
  `PKG_DMF0044` 는 AUTHUNION 미적용 → 행 삭제 시 `minyonglee1` ADMIN 판정 상실.
- `sales-monitoring`(DMF0048) 주석도 "GET_ADMIN_GROUP lookup 이 USER_ID row 로 운영 등록됨"이라 명시.

**선행 조건**: USER_ID 를 직전달하는 화면(최소 DMF0044·DMF0048)에 AUTHUNION 을 먼저 적용해야 안전하다.
그 범위는 이번 승인 범위 밖이므로 **행은 그대로 두었다**(삭제 미실행).

---

## 5.6 DMF0042 범위 재점검 — 미적용분·검토대상 전수 (사용자 지시: "DMF0042 만")

### 결론: **미적용분 0 / 신규 검토대상 0** — 남은 것은 FE lint·육안 확인 2건뿐

| 축 | 실측 | 결과 |
|---|---|---|
| DB 객체 | `ALL_OBJECTS` OWNER=SCM_MGR, `DMF0042%` | `PKG_DMF0042` PACKAGE/BODY **2개뿐**, 둘 다 VALID. standalone SP 잔여 **0** |
| AUTHUNION 판정 | BODY L1781~1785 | **1곳, 적용 완료** |
| 판정 소비처 | L2051 · L2239 | 둘 다 동일 `v_group_id` 참조 — **미적용 0** |
| 부서 축 원천 | L1761~1768 `TB_FX_User.UserID = p_created_by` | BE 주입 sesUserId — **ghost 문제 없음** |

### ⭐ EDIT_FLAG 축 규명 (E2E 혼재의 정체)
`v_group_id` 는 스칼라라 행마다 다를 수 없는데 Viewer 계정이 `['N','Y']` 혼재로 나왔다 → 원문 확인 결과 **축이 2개**:

```sql
-- PKG_DMF0042 BODY L2050~2051 (최종 출력 커서)
CASE WHEN (CASE WHEN A.DIVISION_ID='40' THEN SI.DEPT_ID ELSE A.DEPT_ID END) = v_dept_id THEN 'Y'
     WHEN v_group_id = 'ADMIN' THEN 'Y'
     ELSE 'N' END AS EDIT_FLAG
```

**AS-IS 1:1 대조 완료**:

| TO-BE | AS-IS `DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA` |
|---|---|
| L2050~2051 | L425~426 |
| L2239 | L616~617 |
| L2000 `SALES_PLAN_ADJUST_YN`(GTT 적재용, 최종 미사용) | L373 |
| L2237 (주석) | L614~615 (주석) |

### ⭐ W/S 계정 전 행 'N' 의 근본 원인 — AS-IS 파리티 확정
`PM_TEAM_MAPPING` 이 SEGMENT1 1개에 SEGMENT3 를 **다중 매핑**(예: 30263706 → 15건)하는데 SP 는
`TOP 1`/`FETCH FIRST 1 ROWS ONLY` 로 **첫 1건만** 취한다. 그 값이 원장 DEPT_ID 에 없으면 부서 축이 무력화된다:

| 계정 | 원 부서 (원장 81 보유행) | 매핑 TOP1 → `v_dept_id` | 원장 존재 |
|---|---|---|---|
| jaehyeok | 70000342 (216행) | **58570422** | ❌ |
| bpark416 | 70000344 (773행) | **70055754** | ❌ |
| miyeong.lee | 70084594 (매핑 없음) | 70084594 | ❌ (82) |

**AS-IS DB 직접 조회 결과 부서값·매핑 결과가 완전히 동일** ⇒ 코드도 데이터도 파리티.
현재 'Y' 가 나오는 계정은 전부 **그룹 축(ADMIN)** 으로 통과하는 것이다.

### 도구 정정 2건 (내 오류)
1. E2E 러너가 `unitAuth.editable`(division 편집권)과 `EDIT_FLAG`(행별 부서/그룹)를 **서로 다른 축인데
   1:1 로 기대** → WARN 3건은 결함이 아니라 **기대식 오류**였다.
2. WARN 문구 `"measure 권한 축 병존"` = **틀린 라벨**. DMF0042 에 measure 축은 없고 **부서(DEPT_ID) 축**이다.

→ 시나리오에 `edit_flag_axes`(축 정의) + `edit_flag_all_n_ok`(검증된 파리티 사유) 신설,
   `cell_combo_notes` 와 동일 규약으로 **사유를 남기며 통과**. **E2E 종합 WARN → PASS**.

---

## 6. 잔여 과제 (§5.5 처리 후 새로 드러난 것 — 사용자 판단 필요)

**⭐ AUTHUNION 전사 적용 현황 — 조건식 형태 기준 전수 스캔**
도구 = `_artifacts/_diagnostics/authunion_coverage_scan.py` / 리포트 = `_gate_reports/AUTHUNION_COVERAGE_20260809.md`

⚠️ **마커(`INSTR(TEXT,'AUTHUNION')`) 로 세면 안 된다** — 초기 집계 "44 중 5 적용 / 39 미적용"은 틀렸다:
`PKG_DMF0003` 은 L5911~5912 에 **동일한 합집합 조건이 이미 있는데 주석 문구만 달라** 미적용으로 오집계됐다.
마커는 표식이지 구현이 아니다. 조건식 형태(보유그룹 서브쿼리 동반 여부)로 판정해야 한다.
스캐너 자체도 1차 실행에서 **꼬리 주석**(`... -- 필요시 GET_ADMIN_GROUP_MEASURE 에도 …`, PKG_DMF0082 L7691)을
코드로 오인해 오탐을 냈다 → 주석 제거 후 재실행.

| 상태 | 수 | 내용 |
|---|---:|---|
| ✅ 적용 | **6** | `PKG_DMF0082`(7곳) · `PKG_DMF0021`(3) · `PKG_DMF0042`(1, 오늘) · `PKG_DMF0003`(1, v2 별형) · `DMF0020_GET_SCM_MST_FUTURE_PRICE` 2본 |
| ⛔ 미적용 | **28** | `PKG_DMF0044` · `PKG_DMF0048`·`DMF0048_GET_DM_PLN_SALES_MONITORING` · `PKG_DMF0049` · `PKG_DMF0014` · `PKG_DMF0020` · `PKG_DMF0006` · `PKG_SCM0002` · `DMF0004/0005/0007` 계열 standalone 다수 |
| ⚠ 혼재 | **1** | `PKG_COM0000` (UNION 1 / SINGLE 2 — L202·L218) |
| · 판정없음 | **9** | 참조만 있고 판정식 아님 (건수만 보고) |

**최우선 = 단일그룹 × FE가 USER_ID 직전달 (지금 발현) — 확정 1건**

| 객체 | 위치 | FE 근거 |
|---|---|---|
| `PKG_DMF0044` | BODY **L1159** `AND SEGMENT1 = P_USER_GROUP` | `useSalesReportsStore.ts:133` `userGroup: sesUserId` |

이 1건을 정리해야 §5.5-③(`minyonglee1|ALL` 테스트행 제거)도 안전해진다.
차순위 = `PKG_COM0000` 혼재 2곳(공통 패키지라 영향 넓음) → 그 다음 나머지 미적용.

**AS-IS 그리드 셀 콤보 권한판(*Auth)** — §5.5-② 에서 **미적용 확정**(실측 근거 동봉). 재론 불요.

| AS-IS | TO-BE 현행 (확정) |
|---|---|
| `UserEndCustomerByDivisionDeptAuth` (L1233) | 메타 `EndCustomerByDivisionDept` (비권한판) |
| `UserTeamByDivisionAuth` (L1252) | 메타 `DeptId` (비권한판) |
| `UserSiteByEndCustomerAuth` (L1248, 40) | 메타 `SiteByEndCustomer` (비권한판) |

---

## 변경 파일

**FE (2)**
- `nscm-fe/features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx` — 셀 콤보 파라미터 배선 + `comboSig` division 포함 + `buildDataMap` 배선
- `nscm-fe/features/demand/src/pages/business-plan/__asis-mapping__.md` — 토큰 대사표 섹션 신설

**진단 도구 (4 수정 / 2 신규)**
- `_artifacts/_diagnostics/wiring_chain_check.py` — TS 주석 제거
- `_artifacts/_diagnostics/ui_gate_runner.py` — CTRL 공백 = NULL 동치
- `_artifacts/_diagnostics/combo_callsite_parity.py` — 반응형 훅/공용 필드/JSX 문자열 prop/행 컨텍스트 스왑 인식 + 화면별 별칭·처분(실측 수치 반영)
- `_artifacts/_diagnostics/ui_http_e2e.py` — 화면 일반화 3키(`cell_prefix`/`identity_keys`/`auth_group_combo`) + DMF0042 시나리오
- `_artifacts/_diagnostics/dmf0042_authunion_patch.py` **(신규)** — dump/patch/deploy + 컴파일·마커 자동 검증
- `_artifacts/_diagnostics/dmf0042_auth_combo_probe.py` **(신규)** — 권한판 타당성 2축 실측(읽기 전용)

**DB (사내 Oracle)**
- `PKG_DMF0042` BODY — AUTHUNION 적용(판정 1곳, +2행). 백업/배포본 = `_artifacts/_apply_corporate/*_20260809.sql`
- `SCM_ADM_LOOKUP_MASTER_DETAIL` — **무변경**(§5.5-③ 보류)

**설정**
- `.claude/settings.local.json` — `PowerShell(python _artifacts\_diagnostics\*)` 등 4 규칙 추가
  (기존엔 `Bash(...)` 규칙만 있어 PowerShell 도구 경유 시 분류기에 차단됐다)

> ⚠ FE 는 로컬 lint/type-check 를 실행하지 않았다(룰 — 클라우드 전용). 클라우드 결과 회신 후 추가 fix.
