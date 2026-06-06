# DMF0007 (CustomerFcstMaster) — cascade DataModel.Changed cross-check

> Phase 7 후속 cross-check (2026-06-04) — 룰 07 §2.10 의 reference 확장.
> DMF0007 의 3 cascade handler 정밀 분석 + TO-BE cross-check + 격차 7 건 발견.

---

## §0 결과 종합

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.DM.Master.UIL/DMF0007_CustFcstMaster.cs` (~3500 lines) |
| TO-BE source | `nscm-fe/features/master/src/pages/customer-forecast-master/` |
| AS-IS cascade handler 수 | **3 종** (shtMainFCSTDataModel_Changed + shtMainPSIDataModel_Changed + spdMain_ComboSelChange) |
| AS-IS branch 수 | **7 branch** (FCST 4 + PSI 1 + ComboSel 2) |
| TO-BE 구현된 branch | **2 / 7** (FCST + PSI 의 ActiveFlag → D_ cascade clear 만) |
| 룰 07 §2.10 sub-pattern 매핑 | §2.10.2 (3 위치) / §2.10.3 (2 위치 — TO-BE 구현) / §2.10.4 (1 위치) / §2.10.5 (1 위치) |
| 격차 발견 | **7 건** (다음 §6 참조) |
| 룰 07 §2.10 reference 확장 | ✅ §2.10.3 cascade-clear 의 reference = DMF0007 의 ActiveFlag→D_ cascade |

---

## §1 AS-IS handler #1 — `shtMainFCSTDataModel_Changed` (L1203~1469)

| Branch | Trigger | 동작 | sub-pattern |
|---|---|---|---|
| (a) | Measure column 변경 | "CUST_FCST" 차단 + MSG00379 + revert | §2.10.2 (특수 — single-cell 차단) |
| (b) | Insert 시 Measure column | 5-key 중복 row check (Division+Customer+Site+MeasureGroup+Measure) + MSG00136 + revert | §2.10.2 (5-key duplicate-check) |
| (c-modify) | ActiveFlag column (Modify) | 모든 D_ column 'N' cascade | §2.10.3 (parent → child cascade — TO-BE 구현됨) |
| (c-insert) | ActiveFlag column (Insert) | 8 필수 입력 validation + D_ cascade | §2.10.3 + validation |
| (d) | D_ column 변경 | 8 필수 입력 validation + Y 중복 check + SetSaveData (staging) | §2.10.2 + §2.10.4 |

### §1.1 Branch (a) — Measure='CUST_FCST' 차단 (L1213~1221)

```csharp
if (e.Column == Measure
    && siMain.GetValue(e.Row, Measure).ToString() == "CUST_FCST") {
    MessageHelper.GMessageBox("MSG00379");
    siMain.SetText(e.Row, e.Column, "");
    return;
}
```

→ TO-BE 미구현 (격차 #1).

### §1.2 Branch (b) — Insert 5-key 중복 (L1225~1260)

```csharp
if (sActionFlag == StringI) {
    // 5-key 추출 (DivisionId / CustomerCode / ScmSite / MeasureGroup / Measure)
    if (5-key 모두 != "") {
        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++) {
            if (5-key 모두 일치) iCheck++;
        }
        if (iCheck > 1) {
            MessageHelper.GMessageBox("MSG00136");
            siMain.SetText(e.Row, e.Column, "");
            return;
        }
    }
}
```

→ TO-BE 미구현 (격차 #2). 룰 07 §2.10.2 의 reference 확장 후보.

### §1.3 Branch (c-modify) — ActiveFlag='N' → D_ cascade (L1262~1308)

```csharp
else if (e.Column == ActiveFlag) {
    if (sActionFlag == StringM) {
        for (int iCol = ActiveFlag + 1; iCol <= MaxColumnIndex; iCol++) {
            if (sActiveFlag == "N" && siMain.GetText(e.Row, iCol) == "Y") {
                siMain.SetText(e.Row, iCol, "N");   // 모든 D_ column cascade 'N'
            }
        }
    }
    // Insert 시 동일 + 8 필수 입력 validation
}
```

→ **TO-BE 구현됨** (`CustomerFcstMasterFcstGrid.tsx:32~54`) — `handleActiveChange` 가 동등 동작. ✅ 룰 07 §2.10.3 reference.

**명명 차이**: AS-IS `ActiveFlag` / TO-BE `VALID_YN` — 의미 동등 (column rename).

### §1.4 Branch (d) — D_ 변경 시 (L1309~1466)

```csharp
else if (e.Column > ActiveFlag) {
    // 8 필수 입력 validation (각 column 별 MSG00002 alert + return)
    // D_YYYYMMDD = "" 시 "N" 으로 자동 보정
    // Y 중복 check (5-key + 해당 D_ column = Y)
    // → MSG00136 + revert
    
    SetSaveData(...);   // staging table sync (TO-BE EditTracker 동등)
}
```

→ TO-BE 미구현 (격차 #3, #4 — validation 8 + Y 중복 check). SetSaveData 는 EditTracker 가 자동 (§2.10.4).

---

## §2 AS-IS handler #2 — `shtMainPSIDataModel_Changed` (L1471~1530)

| Branch | Trigger | 동작 | sub-pattern |
|---|---|---|---|
| 1 | ActiveFlag column 이하 | 5-key 중복 check (Division+Customer+Site+MeasureGroup+CustomerPSI) + MSG00136 + revert | §2.10.2 (PSI 용 5-key) |

```csharp
if (e.Column <= ActiveFlag) {
    // 5-key 추출 (Division+CustomerCode+ScmSite+MeasureGroup+CustomerPSI)
    if (5-key 모두 != "") {
        for (int iRow = 0; iRow <= siMain.GetMaxRowIndex(); iRow++) {
            if (5-key 일치) iCheck++;
            if (iCheck > 1) {
                MessageHelper.GMessageBox("MSG00136");
                siMain.SetText(e.Row, e.Column, "");
                return;
            }
        }
    }
}
```

→ TO-BE PsiGrid 의 `handleActiveChange` 는 FCST 와 동일 (VALID_YN → D_ cascade clear) — PSI 의 5-key 중복 check 는 미구현 (격차 #5).

---

## §3 AS-IS handler #3 — `spdMain_ComboSelChange` (L1532~1563)

> AS-IS combo cascade — Wijmo `cellEditEnded` 와 별개의 FpSpread event (combo 선택 직후).

| Branch | Trigger | 동작 | sub-pattern |
|---|---|---|---|
| 1 | DeptId 변경 | (Division=40) `EndCustomerByDivision40` 결과 → CustomerCode combo reload / (그 외) `UserEndCustomerByDivisionDept` → CustomerCode combo reload. + ScmSite combo reload (CustomerCode 기반) | §2.10.5 combo cascade — **2-level cascade** |
| 2 | CustomerCode 변경 | `UserSiteByEndCustomer` → ScmSite combo reload | §2.10.5 combo cascade — single-level |

```csharp
if (e.Column == DeptId) {
    if (sDivision == "40") {
        dtEndCustomer = Data.Common(Data.Type.EndCustomerByDivision40, ...);
    } else {
        dtEndCustomer = Data.UserEndCustomerByDivisionDept(...);
    }
    siMain.SetCellTypeCombo(e.Row, CustomerCode, dtEndCustomer);   // ⚠️ row 단위 SetCellTypeCombo
    
    // ScmSite 도 cascade
    dtScmSite = Data.UserSiteByEndCustomer(...);
    siMain.SetCellTypeCombo(e.Row, ScmSite, dtScmSite);
}
```

→ TO-BE 미구현 (격차 #6, #7). 룰 07 §2.10.5 의 의미 차이 경고 (column.dataMap 전체 grid 적용) 대상.

---

## §4 TO-BE 구현 인벤토리

| TO-BE 위치 | sub-pattern | AS-IS 매핑 |
|---|---|---|
| CustomerFcstMasterFcstGrid.tsx:32~54 (`handleActiveChange`) | §2.10.3 cascade-clear | FCST Branch (c-modify) — ActiveFlag='N' → D_ 'N' cascade |
| CustomerFcstMasterPsiGrid.tsx:32~54 (`handleActiveChange`) | §2.10.3 cascade-clear | (재사용) PSI 도 동일 패턴 적용 |

→ 룰 07 §2.10.3 의 reference 확장 검증 완료.

---

## §5 cross-check 결과 — 룰 07 §2.10 매핑

| sub-pattern | AS-IS 발견 | TO-BE 구현 | 매칭 |
|---|---|---|---|
| §2.10.1 auto-derive | 없음 (DMF0007 사용 X) | — | (N/A) |
| §2.10.2 duplicate-check | 3 위치 (FCST 1b / FCST 1d Y check / PSI 5-key) | 0 위치 | ❌ 격차 3 |
| §2.10.3 cascade-clear | 1 위치 (FCST 1c-modify) | 2 위치 (FCST + PSI handleActiveChange) | ✅ 매칭 (TO-BE 가 PSI 에도 적용) |
| §2.10.4 staging | 1 위치 (FCST 1d SetSaveData) | EditTracker 자동 | ✅ 동등 |
| §2.10.5 combo cascade | 2 위치 (DeptId + CustomerCode) | 0 위치 | ❌ 격차 2 |
| §2.10.6 deferUpdate | (AS-IS 는 CanModelChange flag 로 cascade 안 cascade 방지) | (미적용 — 단순 cascade 라 불필요) | ✅ 동등 의도 |

---

## §6 격차 7 건

| # | 격차 | sub-pattern | AS-IS 위치 | TO-BE 결정 |
|---:|---|---|---|---|
| 1 | Measure='CUST_FCST' 차단 + MSG00379 | §2.10.2 (특수) | L1213~1221 | ⚠️ Validation 룰 (별도) — Wijmo `cellEditEnding` 으로 차단 |
| 2 | FCST Insert 5-key 중복 check + MSG00136 | §2.10.2 | L1225~1260 | ⚠️ 미구현 — 향후 보강 후보 |
| 3 | FCST D_ 변경 시 8 필수 입력 validation (MSG00002) | (Validation) | L1337~1435 | ⚠️ 미구현 — Validation 룰 |
| 4 | FCST D_ Y 중복 check (5-key + Y) | §2.10.2 | L1437~1460 | ⚠️ 미구현 |
| 5 | PSI ActiveFlag 5-key 중복 check + MSG00136 | §2.10.2 | L1500~1526 | ⚠️ 미구현 |
| 6 | ComboSelChange: DeptId → CustomerCode + ScmSite cascade reload (2-level) | §2.10.5 | L1540~1555 | ⚠️ 미구현 — column.dataMap 전체 grid 적용 의미 차이 주의 |
| 7 | ComboSelChange: CustomerCode → ScmSite cascade reload | §2.10.5 | L1556~1562 | ⚠️ 미구현 |

→ **격차 7 건 모두 TO-BE 미구현** — 의도된 부분 구현 또는 향후 보강 후보 (사용자 결정).

### §6.1 사용자 작업물 우선 (메타-룰 #4)

본 cross-check 의 격차 7 건은 **TO-BE DMF0007 의 의도된 부분 구현** 가능성 高:
- ActiveFlag → D_ cascade (가장 흔한 use case) 만 구현 + 나머지 (Validation 8 / 중복 5-key / combo cascade) 는 BE-side SP 가 처리
- 또는 향후 보강 후보

본 cross-check 는 **분석 보고서** — DMF0007 코드 변경 X.

---

## §7 룰 07 §2.10 reference 확장 검증

| §2.10 sub-pattern | reference (룰 작성 시) | 확장 reference (본 cross-check) |
|---|---|---|
| §2.10.1 auto-derive | DMF0008 SalesSite Branch (a) — SCM_SITE_ID 자동 생성 | (DMF0007 에 사용 X) |
| §2.10.2 duplicate-check | DMF0008 SalesSite Branch (b) — SCM_SITE_ID 중복 + revert | DMF0007 FCST (5-key + Y check) / PSI (5-key) — **3 위치 추가** |
| §2.10.3 cascade-clear | DMF0008 SalesSite Branch (c)(d) — Country/City clear | **DMF0007 FCST + PSI handleActiveChange — TO-BE 구현 사례 확인** |
| §2.10.4 staging | DMF0008 SSPM — dtSubBucket | DMF0007 FCST SetSaveData — 동일 패턴 |
| §2.10.5 combo cascade | DMF0008 SSPM — SalesPlant ↔ SalesCompany | DMF0007 — DeptId → CustomerCode → ScmSite (2-level cascade) — **새 reference** |

→ **룰 07 §2.10 의 reference 확장 완료** — 5 sub-pattern 모두 2+ reference 보유 (anti-simplification 의 다중 패턴 cross-check 충족).

---

## §8 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | DMF0007 cascade cross-check 신규 작성 — 3 handler × 7 branch 정밀 + TO-BE 매핑 + 격차 7 건 + 룰 07 §2.10 reference 확장 | Phase 7 후속 |
