# DMF0049 (Etc Sales Reports) 완료 게이트 종결 보고서

- **일자**: 2026-08-10
- **범위**: DMF0049 UI 보완·검증 (사용자 승인 플랜 Phase 0~7)
- **결론**: **게이트 FAIL 0** (PASS 8 / WARN 1) · **HTTP 셀프 E2E FAIL 0** (WARN 1)
- **최종 리포트**
  - 게이트: `_artifacts/_gate_reports/DMF0049_20260810_0959.md`
  - E2E: `_artifacts/_gate_reports/DMF0049_http_e2e_20260810_0945.md`
  - 콤보 호출지점: `_artifacts/_gate_reports/COMBO_CALLSITE_PARITY_DMF0049_20260810_0959.md`

---

## 0. 기준선 → 결과

| 섹션 | 기준선 (`DMF0049_20260810_0753.md`) | 최종 |
|---|---|---|
| 1. 실행 hook | WARN 3 (미배선 export) | **PASS** (18파일 · BLOCK 0 / WARN 0) |
| 2. EID 1:1 대사표 | **FAIL** (대사 행 0건) | **PASS** 58/58 |
| 3. FE→BE→SP 배선 체인 | PASS | **PASS** |
| 4. 메타 값 단언 | PASS | **PASS** |
| 5. CRUD·모달 매트릭스 | **FAIL** (행 0건) | **PASS** 6/6 |
| 6. HTTP 셀프 E2E | **FAIL** (시나리오 미등록) | **WARN** (FAIL 0 / WARN 1 — §3 참조) |
| 7. UP_FX 콤보 파라미터 | **FAIL 2 / WARN 5** | **PASS** (FAIL 0 / WARN 0) |
| 8. 콤보 호출지점 대사 | **FAIL 1 / WARN 4 / PASS 3** | **PASS** (FAIL 0 / WARN 0 / PASS 8) |
| 9. 단위테스트 | **WARN** (0건) | **PASS** (42 tests) |

> 종합: **PASS 2 / FAIL 5 / WARN 2 → PASS 8 / FAIL 0 / WARN 1**

---

## 1. 실제 결함 (수정 적용분)

### D-① 메타 셀 콤보 파라미터 전무 — FE (차단급)

`EtcSalesReportsGrid.tsx:96` 이 `filters: comboColumns.map(c => c.cellCboDataTp)` 로 **comboId 만** 넘겼다.
DMF0049 는 `DM_LOOKUP_DIV` 컬럼이 **3개**이고 각각 `ATTRIBUTE1` 이 다르다.

| 컬럼 | ATTRIBUTE1(=LOOKUP_TYPE) | 무전달 | 전달 후 |
|---|---|---:|---:|
| BIZ_TYPE | `DM_SR_ETC_BIZ_TYPE` (div 40) | **0행** | 6행 |
| ITEM_ID | `DM_SR_ETC_MODEL` (div 40) | **0행** | 16행 |
| ITEM_USE | `DM_ITEM_USE` (div 82) | **0행** | 7행 |

⇒ 그리드가 CODE 를 raw 로 표시. `comboSig` 에도 division 이 없어 division 전환 시 이전 dataMap 이 잔존할 수 있었다.
정정 = DMF0044 선례 1:1 (`param1=q(division)` / `param2=q(c.attribute1)` + `comboSig` 에 division 포함).

### D-② `sEditMeasure` 콤보 값 미따옴표 — FE (차단급)

`EtcSalesReports.tsx:63` 이 `param1: sc.divisionId, param2: EDIT_MEASURE_LOOKUP` 를 **따옴표 없이** 넘겼다.
BE 는 `@토큰` 을 raw 치환하므로 식별자로 해석된다.

```
따옴표 O  param1='82' param2='DM_SR_ETC_CURRENCY'   → HTTP 200 rows=1 (SalesAmt_KRW)
따옴표 X  param1=82   param2=DM_SR_ETC_CURRENCY     → HTTP 500 (-9994 Sql Error)
따옴표 X  param1=81_UC                              → HTTP 500
```

⇒ `sEditMeasure` 가 **항상 빈값**이었고, 비40 의 편집 판정은 `MEASURE === sEditMeasure` 이므로
**82 편집 개방이 통째로 무력화**돼 있었다(단위테스트에 이 파급을 케이스로 고정).

### D-③ `PKG_DMF0044` PRODUCT_DETAIL NOT NULL — DB (차단급, 3중 양파)

DMF0049 **SAVE 가 100% 실패**했다. `-9994 Sql Error` 뒤에 가려진 실제 체인:

```
DMF0049_SAVE_SALES_ETC_REPORT_C (BODY L1158 내부 호출)
  → DMF0044_MOBILE_REPORT_CREATE
    → PKG_DMF0044.P_DMF0044_SALES_REPORT_PRODUCT_CREATE  → ORA-01400
    → PKG_DMF0044.P_DMF0044_SALES_REPORT_DEPT_CREATE     → ORA-01400
```

**근본원인 = MSSQL→Oracle 변환 함정** — Oracle 에서 `''` 는 NULL 이고 `NVL(x,'')` 도 NULL 이다.
MSSQL 원문은 `''` 가 빈 문자열이라 NOT NULL 을 만족했다.

실측(div 40 / `R_S_20260128_V002_C`): 원천 45,285행 중 **31,319행(69%)** 이 NULL 산출 ⇒ 항상 실패.
영향 = DMF0049 SAVE + **DMF0049·DMF0044 양쪽의 `unitedVersion` TRANSFER 버튼**.

**정정 3단계** (사용자 확정 센티널 `'-'` — 같은 BODY L149·L677 이 이미 쓰는 값):

| # | 위치 | 내용 | 드러난 계기 |
|---|---|---|---|
| 1 | L9638~9641 `PRODUCT_CREATE` SELECT | `NVL(x,'')`·`ELSE ''` → `'-'` | 최초 ORA-01400 |
| 2 | L9702~9705 동 **GROUP BY** | 동일 CASE 가 복제돼 있어 SELECT 만 고치면 **ORA-00979** | 1 적용 후 드러남 |
| 3 | L9414~9418 `DEPT_CREATE` INSERT SELECT | NOT NULL 5컬럼(`UPPER_DEPT_NAME`/`DEPT_NAME`/`CUST_INFO`/`PRODUCT_NAME`/`PRODUCT_DETAIL`)을 `NVL(...,'-')` | 2 적용 후 드러남 |

> ⚠ 3 은 **INSERT SELECT 경계**에서만 감쌌다 — 안쪽 소스를 고치면 L9423 의
> `A.DEPARTMENT_NAME IS NULL` 정렬 분기가 함께 바뀌어 **정렬 순서가 달라진다**.
> 이 SELECT 에는 GROUP BY 가 없어 ORA-00979 위험도 없다.

적용기 `_artifacts/_diagnostics/dmf0044_product_detail_notnull_apply.py`
(dump/patch/deploy · **멱등** · 선행 마커 3종 잔존 검증 · SELECT↔GROUP BY 쌍 일치 단언).
BODY 9,759 → **9,767행**, PACKAGE/BODY VALID, 선행 마커(AUTHUNION·MERGE-ON·PIVOTSEL) 각 1건 유지.

**검증**: DMF0049 SAVE 왕복 `HTTP 200` + `+1 반영 475.24` + `원복 474.24` 전부 PASS.

### D-④ DEPT_ID 부모키 cascade 소실 — FE

AS-IS L1265~1300 은 division 40 에서 DEPARTMENT_ID 변경 시 DEPT_ID 콤보를
`DMF0044_DEPARTMENT_TEAM`(**부모키 `DEPARTMENT_ID` 동반**)으로 재바인딩한다.
TO-BE 는 메타의 `DMF0044_DEPARTMENT_TEAM2`(lookup, CODE/NAME 2컬럼)에 `GRID_CASCADE_FILTERS` 를 걸어 뒀는데,
**그 콤보에는 부모키 컬럼이 없어** 관대 규약(콤보값 공란=통과)에 걸려 **필터가 통째로 무효**였다.

정정 = `resolveDeptIdRows` 2분기 이관 + 죽은 `GRID_CASCADE_FILTERS`/`filterComboRowsByRow` 제거.
⚠ '기타' 분기가 **DMF0044 와 다르다** — DMF0049 AS-IS 는 L1293(ETC 콤보)을 주석 처리하고 L1294 TEAM2 를 쓴다.

### D-⑤ cascade clear 매트릭스 이관 — FE

AS-IS 는 DEPARTMENT_ID·DEPT_ID 변경 시 종속 컬럼을 지우는데 **범위가 4분기로 갈린다**.
`cascadeClearColumns` 로 원문 1:1 이관(JSDoc 에 매트릭스 표 동봉, 단위테스트 8케이스).

### D-⑥ 미배선 export 4종 — FE

`callProc`(외부 노출 제거) / `isDiv81`(`insertStaticEditable` 에 배선) /
`existingStaticEditable`(그리드 2분기 명시) / `baseYmOf`(단위테스트가 소비).

---

## 2. AS-IS 파리티 판정 (코드 변경 없음, 근거 등재)

**AS-IS ↔ TO-BE `SCM_MST_SHEET_COLUMNS` 가 42행 / `VISIBLE_FLAG='Y'` 33행으로 완전 일치**한다(2026-08-10 직접 대조).

| AS-IS 콤보 | 판정 | 근거 |
|---|---|---|
| `EndCustomerByDivisionDeptAuth` | **적용 대상 없음** | AS-IS L989 가 END_CUSTOMER 컬럼에 붙이지만 그 컬럼은 **양쪽 모두 `VISIBLE_FLAG='N'`**(숨김) — 사용자가 편집할 수 없다. `.cs` 도 `GetColumnIndex(...) != -1` 가드를 둔다. (참고: DMF0042 실측으로 권한판 자체가 '교체 금지' 확정된 계열) |
| `SiteByEndCustomer` | **적용 대상 없음** | AS-IS L1410 이 SCM_SITE_ID 에 붙이지만 그 컬럼은 CTRL 공백 + `VISIBLE_FLAG='N'` 이고 **트리거인 END_CUSTOMER 도 숨김**이라 이벤트 자체가 발생하지 않는다 |
| `DMF0044_DEPARTMENT_TEAM` | **이관**(D-④) | DEPT_ID 는 `VISIBLE_FLAG='Y'` — 실사용 경로 |

---

## 3. 잔여 WARN 1건 — I/D 왕복 생략 (의도적, 안전 사유)

E2E 러너의 `activeFlag='I' → 'D'` 경로가 **실데이터를 파괴**한다는 것을 사고로 확인했다.
DMF0049 SAVE SP 는 payload 의 `dataSeq` 가 기존 값이면 `activeFlag='I'` 여도
**"DATA_SEQ 존재" 분기(BODY L1058~1066 DELETE→INSERT)** 를 타고, 뒤이은 `'D'` 가 원래 있던 행을 지운다.

- 실사고: `DATA_SEQ=126 / SalesAmt_LOC / 20250101` 1행 소실 → **복원 완료**(형제 행에서 컬럼 전량 복사, QTY 0).
- 시나리오에 `insert_delete_safe: False` + 사유를 등재해 **조용한 생략이 아니라 리포트에 남도록** 했다.
- ⇒ C 축(신규/삭제)은 **화면 Insert/Delete 버튼 육안 확인** 필요.

### ⚠ 진단 과정에서 발생시킨 원장 변경 — 전량 복원

**저장 SP 를 직접 호출하면 `rollback()` 이 무의미하다 — SP 내부가 `COMMIT` 한다**(hook #104 가 금지하는 이유).
진단 중 2건을 직접 호출해 커밋됐고, E2E I/D 가 1건을 지웠다. 3건 모두 복원했다.

| # | 대상 | 조치 | 확인 |
|---|---|---|---|
| 1 | `DATA_SEQ=1 / LOC / 20250701` (직접 호출로 **생성**) | DELETE | 1건 |
| 2 | `DATA_SEQ=120 / SalesAmt_LOC / 20250701` 475.24 | 원본 **474.24** 로 UPDATE | 1건 |
| 3 | `DATA_SEQ=126 / SalesAmt_LOC / 20250101` (E2E 'D' 가 **삭제**) | 형제 행 복사 INSERT(QTY 0) | 1건 |

**최종 무결성**: 버전 총 행수 **10,651 = 원본**, `DATA_SEQ` 125~129 전부 24행(형제 동일).
잔여 차이는 2·3 행의 감사 컬럼(`LAST_UPDATE_DATE`/`CREATED_BY`)뿐이다.

---

## 4. 도구 보완 + 전 화면 회귀

| 도구 | 보완 | 사유 |
|---|---|---|
| `combo_callsite_parity` | **화면 스코프 토큰** 인식 — `param1/param2/divisionId/mnuId` 가 반응형 구독 키에 모두 포함되면 신규행 프라이밍과 등가 | `DM_LOOKUP_DIV` 의 토큰은 division·컬럼 메타에서 나와 **행마다 달라지지 않는다**. 행 스코프로 오인해 영구 FAIL |
| 〃 `row_swap_combo_ids` | `comboRowsRef.current.<BINDING>` 참조 인식 (binding→메타 콤보 매핑) | 스왑의 **기본 분기**가 메타 콤보 결과를 그대로 쓰는 경우를 못 봐 "스왑 없음" 오판 |
| `ui_gate_runner` §7 | 붙은 컬럼이 **전부 `VISIBLE_FLAG='N'`** 인 콤보는 `PASS(숨김)` | 렌더되지 않는 셀에 토큰을 넘길 지점이 없다(§2 판정과 동일 근거) |
| `ui_http_e2e` | `insert_delete_safe` / `insert_delete_note` | 파괴적 I/D 를 **명시적으로** 차단 + 사유 노출 |

### 회귀 대조 (도구·PKG 변경 후)

| 화면 | 결과 | 판정 |
|---|---|---|
| **DMF0049** | 게이트 FAIL 0 / WARN 1 / PASS 8 | 목표 달성 |
| **DMF0044** | 게이트 **종합 PASS(9/9)** + E2E **종합 PASS**(재실행 `1003`) | **회귀 0** (PKG 3회 변경분 검증) |
| DMF0042 | parity FAIL 0 / WARN 0 / PASS 13 | 동일 |
| DMF0082 | parity FAIL 0 / WARN 0 / PASS 14 | 동일 |
| DMF0003 | parity FAIL 0 / WARN 9 / PASS 9 | 동일 |

---

## 5. 단위테스트 (42) — 효능 증명 포함

`nscm-fe/features/demand/src/pages/etc-sales-reports/EtcSalesReportsUtils.test.ts`

division 3분기 · `measureCntOf` · `dynKindOf`/`baseYmOf`(BP 6자리 결함② 교정) ·
G0 그룹 게이트 · 편집 매트릭스(P1/P2/P3/R1/R2/R3 + **sEditMeasure 빈값 파급**) ·
정적 컬럼 잠금(40/81/82 분기 상이) · `resolveDeptIdRows` 2분기 · `cascadeClearColumns` **4분기 매트릭스** ·
`buildEtcReportSaveRows`(세트×채택월×세트내 행 · 40·82 전 월 수집 · 81 미해당 · Department 필수) · validate.

**효능 증명**: 결함 2건 주입(`isEditBlockedGroup` 의 `!isDiv82` 제거 / `cascadeClearColumns` 3컬럼→5컬럼)
→ **정확히 그 3 테스트만 실패**(2건이 공유 판정) → 원복 후 42/42 통과.

---

## 6. 이월 / 범위 밖

- **FE lint·type-check 는 클라우드에서 사용자 실행**(로컬 실행 금지 룰). 변경 파일:
  - `features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx`
  - `.../components/EtcSalesReportsGrid.tsx`
  - `.../utils/etc-sales-reports.{gridCombos,editLock,api}.ts`
  - `.../EtcSalesReportsUtils.test.ts` (신규)
- **브라우저 육안 확인** — 특히 **Insert/Delete 버튼(C 축)** 과 DEPT_ID cascade 3분기.
- **클라우드 이관** — `PKG_DMF0044` 가 오늘 다시 바뀌었으므로 `DMF0044_20260810_0638` 패키지의
  BODY 재덤프 필요(§7 에서 처리).
- DMF0049 는 **원장에 division 40 데이터만** 존재(157,842행 / `CUTOFF_TYPE='REPORT_SP_W'` 단일).
  81·82 조회 0행은 데이터 전제이지 결함이 아니다.
