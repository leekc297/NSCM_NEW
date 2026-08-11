# AS-IS ↔ TO-BE 콤보 **호출 지점 수(N:N)** 대사

> 실행 2026-08-09 09:31 · `_artifacts/_diagnostics/combo_callsite_parity.py` · **읽기 전용**
> 룰 = hook #117 §5.12. SQL·파라미터가 맞아도 **부르는 시점이 빠지면 조용히 죽는다.**
> 섹션 7·E2E D2축이 못 보는 축 — 이 대사표가 유일한 방어선이다.

판정: **FAIL** = 배선 자체 부재(AS-IS ≥2 지점) 또는 **행 생성(InsertRow) 지점 누락** /
**WARN** = AS-IS 지점 수 > TO-BE(트리거 부족 의심) 또는 대응 콤보 미식별 / **PASS** = 그 외

## 종합 — FAIL **17** / WARN **55** / PASS **81** (화면 37개)

## DMF0003 (FAIL 0 / WARN 9 / PASS 9)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0003_MktFcst/DMF0003_MktFcst.cs (7143행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_FROM_SITE | AS_FROM_SITE | 3 | 6 | 3 | 0 | O | ✅ PASS |  |
| AS_INCOTERMS | AS_INCOTERMS | 1 | 2 | 0 | 1 | - | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 2 | 0 | O | ✅ PASS |  |
| DM_PLANNER_EDIT_FLAG | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DM_UI_EDITABLE_DIVISION | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DM_VMI_YN | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DefaultBucketDay | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivision40 | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivisionDeptAuth | EndCustomerByDivisionDeptAuth | 1 | 2 | 3 | 0 | O | ✅ PASS |  |
| FCST_TYPE | FcstType | 2 | 5 | 2 | 0 | O | ✅ PASS |  |
| MktFcstEditMeasure | MktFcstEditMeasure | 4 | 12 | 0 | 1 | - | ⚠ WARN | AS-IS 이벤트 4종 > TO-BE 트리거 0 — 부족 의심 |
| PlantSiteByItem | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SCP_PLANNER_EDIT_FLAG | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SalesPlant | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomer | SiteByEndCustomer | 5 | 7 | 3 | 0 | O | ✅ PASS | AS-IS 5지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId); (메타 반응형 재조회: mnuId) |
| SiteByEndCustomer40 | ScmSitebyEndCustomer40 | 3 | 3 | 0 | 1 | - | ✅ PASS | AS-IS 3지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| SiteByEndCustomerAuth | SiteByEndCustomerAuth | 1 | 3 | 3 | 0 | O | ✅ PASS |  |
| TeamByDivisionAuth | TeambyDivisionAuth | 1 | 1 | 3 | 0 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **DM_PLANNER_EDIT_FLAG** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **DM_UI_EDITABLE_DIVISION** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **DM_VMI_YN** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음
- **DefaultBucketDay** → `-` · AS-IS 호출 메서드: FindData · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **EndCustomerByDivision40** → `-` · AS-IS 호출 메서드: spdMain_ComboSelChange · 주석처리 4건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **MktFcstEditMeasure** → `MktFcstEditMeasure` · AS-IS 호출 메서드: Form_Load, spdMain_CellClick, spdMain_Changed, spdMain_ClipboardPasted, spdMain_ComboSelChange · 주석처리 2건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **PlantSiteByItem** → `-` · AS-IS 호출 메서드: spdMain_CellClick
  - TO-BE 트리거: 없음
- **SCP_PLANNER_EDIT_FLAG** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **SalesPlant** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음

## DMF0004 (FAIL 0 / WARN 3 / PASS 5)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0004_SalesSite/DMF0004_SalesSite.cs (2769행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| COMPANY_ID_INTERNAL_TXN | CompanyIdInternalTxn | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| EndCustomer | EndCustomer | 2 | 2 | 0 | 1 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| Incoterms | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| MyDivision | MyDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SaleSiteByDivision | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SoldCustomer | SoldCustomer | 4 | 4 | 0 | 1 | O | ✅ PASS | AS-IS 4지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| SpreadTitle | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 1 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **Incoterms** → `-` · AS-IS 호출 메서드: (전역) · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **SaleSiteByDivision** → `-` · AS-IS 호출 메서드: spdSub_ComboSelChange
  - TO-BE 트리거: 없음
- **SpreadTitle** → `-` · AS-IS 호출 메서드: SetGridHeader · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음

## DMF0005 (FAIL 6 / WARN 4 / PASS 3)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0005_SaleSite_PjtModelMapping/DMF0005_SaleSite_PjtModelMapping.cs (4668행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| Auth_Dept | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| CompanySalesSite | CompanySalesSite | 5 | 5 | 0 | 0 | O | ⛔ FAIL | AS-IS 에 **행 생성 지점**(InsertRow)이 있고 콤보가 행 종속 토큰(divisionId, scmSiteId)을 갖는데 TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가 |
| DMF0005_DM_CONTRIBUTION_TYPE_CD | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0005_DM_OS_CORP_CD | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivisionDeptAuth | - | 2 | 3 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| ITEM_TYPE_CODE | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| ItemType | ItemType | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| PlantByDivisionCompany | PlantByDivisionCompany | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| SSPM_CRGE_ORG_NM | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| SSPM_CUST_ENG_NM | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| SiteByEndCustomerAuth | - | 2 | 4 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| TeamByDivisionAuth | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 1 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **Auth_Dept** → `-` · AS-IS 호출 메서드: DefineProperty
  - TO-BE 트리거: 없음
- **CompanySalesSite** → `CompanySalesSite` · AS-IS 호출 메서드: InsertRow, spdMain_CellClick, spdMain_Changed, spdSub_CellClick, spdSub_Changed
  - TO-BE 트리거: 없음
- **DMF0005_DM_CONTRIBUTION_TYPE_CD** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **DMF0005_DM_OS_CORP_CD** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **ITEM_TYPE_CODE** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **SSPM_CRGE_ORG_NM** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_CellClick
  - TO-BE 트리거: 없음
- **SSPM_CUST_ENG_NM** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_CellClick
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **TeamByDivisionAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음

## DMF0006 (FAIL 4 / WARN 1 / PASS 4)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0006_CustomerModelMapping/DMF0006_CustomerModelMapping.cs (1213행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| EndCustomerByDivision40 | - | 4 | 5 | 0 | 0 | - | ⛔ FAIL | AS-IS 4지점인데 TO-BE 배선 자체가 없음 |
| EndCustomerByDivisionDept | - | 4 | 5 | 0 | 0 | - | ⛔ FAIL | AS-IS 4지점인데 TO-BE 배선 자체가 없음 |
| EndCustomerByDivisionDeptAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| MyDivision | MyDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 5 | 6 | 0 | 0 | O | ✅ PASS |  |
| SiteByEndCustomerAuth | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| TeamByDivision | TeambyDivision | 2 | 2 | 0 | 1 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| TeamByDivisionAuth | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 1 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **EndCustomerByDivision40** → `-` · AS-IS 호출 메서드: InitControls, InsertRow, clbDivision_SelectedIndexChanged, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDept** → `-` · AS-IS 호출 메서드: InitControls, clbDivision_SelectedIndexChanged, clbTeam_SelectedIndexChanged, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **TeamByDivisionAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음

## DMF0007 (FAIL 1 / WARN 3 / PASS 6)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0007_CustFcstMaster/DMF0007_CustFcstMaster.cs (1912행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| Auth_Dept | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| BucketType | BucketType | 1 | 1 | 0 | 1 | O | ✅ PASS |  |
| EndCustomerByDivision40 | - | 2 | 2 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| EndCustomerByDivisionDept | EndCustomerByDivisionDept | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| MyDivision | MyDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| SpreadTitle | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| TeamByDivision | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| UploadUOM | UploadUOM | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 1 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **Auth_Dept** → `-` · AS-IS 호출 메서드: DefineProperty
  - TO-BE 트리거: 없음
- **EndCustomerByDivision40** → `-` · AS-IS 호출 메서드: (전역), InitControls · 주석처리 3건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **SpreadTitle** → `-` · AS-IS 호출 메서드: GetSpdTitle
  - TO-BE 트리거: 없음
- **TeamByDivision** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음

## DMF0008 (FAIL 0 / WARN 3 / PASS 8)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0008_ErpEdiMaster/DMF0008_ErpEdiMaster.cs (3370행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| Auth_Dept | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomer | EndCustomer | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| Incoterms | Incoterms | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| MyDivision | MyDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SalesCompany | SalesCompany | 2 | 3 | 0 | 0 | O | ✅ PASS |  |
| SalesPlant | SalesPlant | 2 | 3 | 0 | 0 | O | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| SiteByEndCustomerAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SoldCustomer | SoldCustomer | 2 | 2 | 0 | 0 | O | ✅ PASS |  |
| SpreadTitle | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 0 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **Auth_Dept** → `-` · AS-IS 호출 메서드: DefineProperty
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: spdSub_ComboSelChange
  - TO-BE 트리거: 없음
- **SpreadTitle** → `-` · AS-IS 호출 메서드: SetGridHeader
  - TO-BE 트리거: 없음

## DMF0020 (FAIL 2 / WARN 6 / PASS 4)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0020_SalesFuturePrice/DMF0020_SalesFuturePrice.cs (3969행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 4개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| DM_UI_EDITABLE_DIVISION | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 2 | 3 | 0 | 0 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | - | 2 | 4 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| INCOTERMS | Incoterms | 2 | 2 | 0 | 1 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| PlantSiteByItem | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SalesPlant | - | 1 | 2 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomer | SiteByEndCustomer | 2 | 2 | 1 | 1 | O | ⚠ WARN | AS-IS 이벤트 2종 > TO-BE 트리거 1 — 부족 의심 |
| SiteByEndCustomerAuth | - | 2 | 5 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| TeamByDivision | TeambyDivision | 1 | 1 | 1 | 0 | O | ✅ PASS |  |
| TeamByDivisionAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| UpperDeptId | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **DM_UI_EDITABLE_DIVISION** → `-` · AS-IS 호출 메서드: EditButton
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **PlantSiteByItem** → `-` · AS-IS 호출 메서드: Raw_CellClick
  - TO-BE 트리거: 없음
- **SalesPlant** → `-` · AS-IS 호출 메서드: Dsdm_Changed
  - TO-BE 트리거: 없음
- **SiteByEndCustomer** → `SiteByEndCustomer` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: (행 컨텍스트 스왑: SCM_SITE_ID)
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **TeamByDivisionAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **UpperDeptId** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음

## DMF0021 (FAIL 3 / WARN 5 / PASS 5)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0021_SalesPlan/DMF0021_SalesPlan.cs (5643행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_INCOTERMS | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| CELL_PROD_SITE_ID | CELL_PROD_SITE_ID | 2 | 4 | 1 | 1 | O | ⚠ WARN | AS-IS 이벤트 2종 > TO-BE 트리거 1 — 부족 의심 |
| CURRENCY_LIST | CurrencyList | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DM_CUSTOMS_HANDBOOK | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 1 | 1 | 1 | 1 | O | ✅ PASS |  |
| EndCustomerByDivisionDept | EndCustomerByDivisionDept | 1 | 1 | 1 | 1 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | - | 2 | 3 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| FCST_TYPE | FcstType | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| PlantSiteByDivision | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SALES_PLAN_ITEM_ID | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomer | SiteByEndCustomer | 1 | 1 | 1 | 1 | - | ✅ PASS |  |
| SiteByEndCustomerAuth | - | 2 | 3 | 0 | 0 | - | ⛔ FAIL | AS-IS 2지점인데 TO-BE 배선 자체가 없음 |
| TeamByDivisionAuth | - | 3 | 3 | 0 | 0 | - | ⛔ FAIL | AS-IS 3지점인데 TO-BE 배선 자체가 없음 |

### 상세 (FAIL/WARN)

- **AS_INCOTERMS** → `-` · AS-IS 호출 메서드: spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **CELL_PROD_SITE_ID** → `CELL_PROD_SITE_ID` · AS-IS 호출 메서드: InsertRow, spdMain_ClipboardPasted, spdMain_ComboSelChange · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: (행 컨텍스트 스왑: CELL_PROD_SITE_ID)
- **DM_CUSTOMS_HANDBOOK** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **PlantSiteByDivision** → `-` · AS-IS 호출 메서드: spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **SALES_PLAN_ITEM_ID** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음
- **TeamByDivisionAuth** → `-` · AS-IS 호출 메서드: EditButton, InsertRow, spdMain_ComboSelChange
  - TO-BE 트리거: 없음

## DMF0022 (FAIL 0 / WARN 0 / PASS 3)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0022_SalesPlanWaterfall/DMF0022_SalesPlanWaterfall.cs (2769행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 4개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| SALES_PLAN_AMOUNT_KRW | SALES_PLAN_AMOUNT_KRW | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SALES_PLAN_AMOUNT_LOC | SALES_PLAN_AMOUNT_LOC | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SALES_PLAN_AMOUNT_USD | SALES_PLAN_AMOUNT_USD | 1 | 1 | 0 | 1 | - | ✅ PASS |  |

## DMF0035 (FAIL 0 / WARN 0 / PASS 1)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0035_MktFcstWaterfall/DMF0035_MktFcstWaterfall.cs (2316행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| SiteByEndCustomer | SiteByEndCustomer | 1 | 1 | 0 | 0 | O | ✅ PASS |  |

## DMF0042 (FAIL 0 / WARN 0 / PASS 13)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0042_BizPlan/DMF0042_BizPlan.cs (3564행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CURRENCY_LIST | CurrencyList | 2 | 2 | 0 | 1 | - | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| DMF0042_BP_Measure | DMF0042_BP_Measure | 2 | 6 | 1 | 0 | O | ✅ PASS | AS-IS 2지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId) |
| DM_BIZ_TYPE | DmBizType | 2 | 2 | 0 | 1 | - | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 4 | 4 | 2 | 1 | O | ✅ PASS | AS-IS 4지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| EndCustomerByDivisionDept | EndCustomerByDivisionDept | 3 | 5 | 2 | 0 | O | ✅ PASS | AS-IS 3지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId) |
| EndCustomerByDivisionDeptAuth | EndCustomerByDivisionDept | 1 | 1 | 2 | 0 | O | ✅ PASS | 이식 안 함(사유 기재): AS-IS InsertRow 권한판 → TO-BE 메타 비권한판 EndCustomerByDivisionDept (권한판 전환은 원장 실측 후 별건 — hook #117 §5.10, DMF0082 선례) |
| MyDivision | MyDivision | 1 | 1 | 1 | 4 | - | ✅ PASS |  |
| PlantSiteByDivision | PlantSitebyEndCustomer | 2 | 2 | 1 | 0 | - | ✅ PASS | AS-IS 2지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (반응형 재조회: divisionId) |
| SiteByEndCustomer | SiteByEndCustomer | 6 | 7 | 2 | 0 | O | ✅ PASS | AS-IS 6지점 ↔ TO-BE **반응형 구독 1개**로 대체 — queryKey 파라미터 변화 시 자동 재조회 (메타 반응형 재조회: divisionId) |
| SiteByEndCustomer40 | UserSiteByEndCustomer | 2 | 2 | 2 | 2 | - | ✅ PASS |  |
| SiteByEndCustomerAuth | SiteByEndCustomer | 1 | 1 | 2 | 0 | O | ✅ PASS | 이식 안 함(사유 기재): AS-IS InsertRow 권한판(40) → TO-BE 메타 비권한판 SiteByEndCustomer (동상) |
| TeamByDivision | TeambyDivision | 2 | 2 | 1 | 1 | - | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| TeamByDivisionAuth | DeptId | 1 | 1 | 3 | 0 | O | ✅ PASS | 이식 안 함(사유 기재): AS-IS InsertRow 권한판 → TO-BE 메타 비권한판 DeptId (동상 — 권한판 0행 리스크) |

## DMF0043 (FAIL 0 / WARN 1 / PASS 0)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0043_Contribute_Main/DMF0043_Contribute_Main.cs (941행) — 선택 근거: 레지스트리 등록 / 후보 1개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| DMF0005_DM_CONTRIBUTION_TYPE_CD | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **DMF0005_DM_CONTRIBUTION_TYPE_CD** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음

## DMF0044 (FAIL 0 / WARN 5 / PASS 1)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0044_Sales_Reports/DMF0044_Sales_Reports.cs (1483행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CALENDAR_YYYY | CALENDAR_YYYY | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DMF0005_REPORT_GROUP2 | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0044_DEPARTMENT_TEAM | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0044_DEPARTMENT_TEAM2 | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0044_ETC_SALE_RESULT_TYPE_40 | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0044_MDF_ENDCUST_REPORT | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **DMF0005_REPORT_GROUP2** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음
- **DMF0044_DEPARTMENT_TEAM** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음
- **DMF0044_DEPARTMENT_TEAM2** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **DMF0044_ETC_SALE_RESULT_TYPE_40** → `-` · AS-IS 호출 메서드: spdMain_Changed · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **DMF0044_MDF_ENDCUST_REPORT** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음

## DMF0048 (FAIL 0 / WARN 2 / PASS 0)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs (2180행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 3개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CURRENCY_LIST | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SALES_PLAN_ITEM_ID | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **CURRENCY_LIST** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **SALES_PLAN_ITEM_ID** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음

## DMF0049 (FAIL 1 / WARN 4 / PASS 3)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0049_Sales_ETC_Reports/DMF0049_Sales_ETC_Reports.cs (1727행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| CALENDAR_YYYY | CALENDAR_YYYY | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| DMF0005_REPORT_GROUP2 | DMF0005_REPORT_GROUP2 | 2 | 3 | 0 | 1 | - | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| DMF0044_DEPARTMENT_TEAM | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DMF0044_DEPARTMENT_TEAM2 | DMF0044_DEPARTMENT_TEAM2 | 2 | 2 | 1 | 0 | O | ⚠ WARN | AS-IS 이벤트 2종 > TO-BE 트리거 1 — 부족 의심 |
| DM_LOOKUP_DIV | DM_LOOKUP_DIV | 2 | 2 | 1 | 0 | O | ⛔ FAIL | AS-IS 에 **행 생성 지점**(InsertRow)이 있고 콤보가 행 종속 토큰(param1, param2)을 갖는데 TO-BE 신규행 프라이밍 없음 — 메타 자동 바인딩은 렌더 1회라 대체 불가 |
| END_CUST_REPORT | END_CUST_REPORT | 1 | 1 | 0 | 0 | O | ✅ PASS |  |
| EndCustomerByDivisionDeptAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomer | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **DMF0044_DEPARTMENT_TEAM** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음
- **DMF0044_DEPARTMENT_TEAM2** → `DMF0044_DEPARTMENT_TEAM2` · AS-IS 호출 메서드: InsertRow, spdMain_Changed
  - TO-BE 트리거: (행 컨텍스트 스왑: DEPT_ID)
- **DM_LOOKUP_DIV** → `DM_LOOKUP_DIV` · AS-IS 호출 메서드: EditButton, InsertRow
  - TO-BE 트리거: (반응형 재조회: param1, param2)
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **SiteByEndCustomer** → `-` · AS-IS 호출 메서드: spdMain_Changed
  - TO-BE 트리거: 없음

## DMF0068 (FAIL 0 / WARN 1 / PASS 0)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0068_DemandManager40/DMF0068_DemandManager40.cs (1337행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| MyDivision | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **MyDivision** → `-` · AS-IS 호출 메서드: (전역)
  - TO-BE 트리거: 없음

## DMF0072 (FAIL 0 / WARN 6 / PASS 2)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Master/DMF0072_NNMasterMapping/DMF0072_NNMasterMapping.cs (1577행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 1개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| DM_EDI_COMPANY_LIST | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| DM_EDI_DATA_TYPE_CODE | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivision40 | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| EndCustomerByDivisionDeptAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| MyDivision | MyDivision | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| SALES_PLAN_ITEM_ID | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| SiteByEndCustomerAuth | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |
| YesOrNo | YesOrNo | 1 | 1 | 0 | 0 | O | ✅ PASS |  |

### 상세 (FAIL/WARN)

- **DM_EDI_COMPANY_LIST** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **DM_EDI_DATA_TYPE_CODE** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **EndCustomerByDivision40** → `-` · AS-IS 호출 메서드: InsertRow · 주석처리 3건(사문=미이관 파리티)
  - TO-BE 트리거: 없음
- **EndCustomerByDivisionDeptAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음
- **SALES_PLAN_ITEM_ID** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음
- **SiteByEndCustomerAuth** → `-` · AS-IS 호출 메서드: InsertRow
  - TO-BE 트리거: 없음

## DMF0074 (FAIL 0 / WARN 1 / PASS 0)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0074_MetalLinkPrice/DMF0074_MetalLinkPrice.cs (760행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 1개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| UpperDeptId | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **UpperDeptId** → `-` · AS-IS 호출 메서드: InitControls
  - TO-BE 트리거: 없음

## DMF0082 (FAIL 0 / WARN 0 / PASS 14)

> AS-IS 원천: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0082_FcstNPrice_Mgmt/DMF0082_FcstNPrice_Mgmt.cs (9419행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 1개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 가 pastedCell 에 편집 핸들러를 공유하므로 **Paste 는 AS-IS 집계에서 제외**했다.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| AS_INCOTERMS | AsIncotermsEdit | 0 | 1 | 1 | 0 | - | ✅ PASS |  |
| CELL_PROD_SITE_ID | CELL_PROD_SITE_ID | 2 | 4 | 6 | 0 | O | ✅ PASS |  |
| CURRENCY_LIST | CurrencyList | 2 | 2 | 1 | 2 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 2회로 등가 |
| DM_CUSTOMS_HANDBOOK | CustomsHandbook | 1 | 1 | 1 | 1 | - | ✅ PASS |  |
| DefaultBucketDay | DefaultBucketDay | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| EndCustomerByDivision40 | EndCustomerByDivision40 | 2 | 3 | 1 | 0 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 0회로 등가 |
| FCST_PRICE_EDIT_MEASURE | FcstPriceEditMeasure | 3 | 6 | 4 | 0 | - | ✅ PASS |  |
| FCST_TYPE | FcstType | 1 | 1 | 1 | 0 | - | ✅ PASS |  |
| INCOTERMS | Incoterms | 2 | 3 | 1 | 1 | O | ✅ PASS | AS-IS 2지점이나 TO-BE 콤보가 **무파라미터**(문맥 토큰 0) — 재조회해도 동일 결과라 프리페치 1회로 등가 |
| NO_DATA | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): AS-IS 는 빈 목록 콤보로 입력 차단 — TO-BE 는 빈 DataMap 스왑으로 동등 구현(콤보 불요) |
| SALES_BUCKET | SalesBucket | 2 | 3 | 2 | 0 | - | ✅ PASS |  |
| SiteByEndCustomer | SiteByEndCustomer | 3 | 5 | 5 | 0 | O | ✅ PASS |  |
| SiteByEndCustomer40 | ScmSitebyEndCustomer40 | 1 | 1 | 0 | 1 | - | ✅ PASS |  |
| TeamByDivisionAuth | - | 1 | 1 | 0 | 0 | - | ✅ PASS | 이식 안 함(사유 기재): TEAM_ID 는 SAVE 파라미터 부재 = 표시 전용 → 편집판 미적용(hook #117 §5.10) |

## SCP0013 (FAIL 0 / WARN 1 / PASS 0)

> AS-IS 원천: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0013_ProductionPlanLine/SCP0013_ProductionPlanLine.cs (4171행) — 선택 근거: Forms.UIL 폴더단위 유일 / 후보 2개`

> 비교 단위 = **구별된 이벤트 핸들러 수**(AS-IS) ↔ **트리거 수**(TO-BE). TO-BE 는 Paste 핸들러 공유가 없다 — Paste 지점도 집계에 포함.

| AS-IS CODE | TO-BE 콤보 | AS-IS 이벤트 | (원호출수) | TO-BE 트리거 | 프리페치 | 메타 | 판정 | 사유 |
|---|---|---:|---:|---:|---:|:-:|---|---|
| LookupCommon | - | 1 | 1 | 0 | 0 | - | ⚠ WARN | TO-BE 대응 콤보 미식별 (명명 상이 or 미이관) |

### 상세 (FAIL/WARN)

- **LookupCommon** → `-` · AS-IS 호출 메서드: (전역) · 주석처리 1건(사문=미이관 파리티)
  - TO-BE 트리거: 없음

## SYS0001 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0002 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0003 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0004 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0005 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0006 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0007 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0008 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0009 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0010 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0011 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0012 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0013 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0014 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0015 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0016 — SKIP

AS-IS 정본 미확정 — 후보 없음

## SYS0017 — SKIP

AS-IS 정본 미확정 — 후보 없음

## 한계 (은폐 없음)
- AS-IS 명명 헬퍼는 **1단계**만 해소한다(헬퍼 안의 헬퍼는 미추적).
- TO-BE 트리거 추출은 `binding === 'X'` 정적 매칭 — 동적 분기(맵/스위치)는 누락될 수 있다.
- 이름이 다른 대응 콤보는 정규화(영숫자 소문자) 매칭이 실패하면 '미식별 WARN' 으로 노출한다(조용한 통과 없음).
- 주석 처리된 AS-IS 호출은 **제외하되 건수를 표에 기록**한다 — 사문 = 미이관이 파리티.

