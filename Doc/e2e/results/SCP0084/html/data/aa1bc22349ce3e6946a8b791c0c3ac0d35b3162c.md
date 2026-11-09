# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SCP0084.smoke.spec.ts >> SCP0084 LongTermStock 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SCP0084.smoke.spec.ts:115:7

# Error details

```
Error: 공통 기능 FAIL 1: Excel 다운로드

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 1
```

# Page snapshot

```yaml
- generic [ref=f3e1]:
  - generic [ref=f3e2]:
    - banner [ref=f3e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f3e5] [cursor=pointer]:
        - /url: /view/SCP0084
        - generic [ref=f3e6]: SCM
        - generic [ref=f3e7]:
          - generic [ref=f3e8]: 공급망관리시스템
          - generic [ref=f3e9]: Supply Chain Management system
      - navigation [ref=f3e10]:
        - link "Demand" [ref=f3e11] [cursor=pointer]:
          - /url: /view/SCP0084
        - link "Supply" [ref=f3e12] [cursor=pointer]:
          - /url: /view/SCP0084
        - link "Shipping" [ref=f3e13] [cursor=pointer]:
          - /url: /view/SCP0084
        - link "Authority" [ref=f3e14] [cursor=pointer]:
          - /url: /view/SCP0084
        - link "Admin" [ref=f3e15] [cursor=pointer]:
          - /url: /view/SCP0084
      - generic [ref=f3e16]:
        - button "KOR" [ref=f3e18] [cursor=pointer]
        - button "이 이민용" [ref=f3e22] [cursor=pointer]:
          - paragraph [ref=f3e27]: 이
          - generic [ref=f3e28]: 이민용
    - generic [ref=f3e29]:
      - button [ref=f3e30] [cursor=pointer]
      - complementary [ref=f3e36]:
        - navigation [ref=f3e37]:
          - paragraph [ref=f3e38]: Supply
          - generic [ref=f3e39]:
            - link [ref=f3e40] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e41]: Supply Master
            - link "Line Master":
              - /url: /view/SCP0084
              - paragraph [ref=f3e44] [cursor=pointer]: Line Master
            - link "Project Route":
              - /url: /view/SCP0084
              - paragraph [ref=f3e45] [cursor=pointer]: Project Route
            - link "BOD":
              - /url: /view/SCP0084
              - paragraph [ref=f3e46] [cursor=pointer]: BOD
            - link "Plant Site":
              - /url: /view/SCP0084
              - paragraph [ref=f3e47] [cursor=pointer]: Plant Site
            - link "Production Plan":
              - /url: /view/SCP0084
              - paragraph [ref=f3e48] [cursor=pointer]: Production Plan
            - link "Work Calendar(OSP)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e49] [cursor=pointer]: Work Calendar(OSP)
            - link "Tact Time(OSP)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e50] [cursor=pointer]: Tact Time(OSP)
            - link "Formation":
              - /url: /view/SCP0084
              - paragraph [ref=f3e51] [cursor=pointer]: Formation
            - link "Outsourcing Capacity":
              - /url: /view/SCP0084
              - paragraph [ref=f3e52] [cursor=pointer]: Outsourcing Capacity
            - link "BOD ITEM":
              - /url: /view/SCP0084
              - paragraph [ref=f3e53] [cursor=pointer]: BOD ITEM
            - link "Master Validation":
              - /url: /view/SCP0084
              - paragraph [ref=f3e54] [cursor=pointer]: Master Validation
            - link "Stock OSP":
              - /url: /view/SCP0084
              - paragraph [ref=f3e55] [cursor=pointer]: Stock OSP
            - link "ProjectRoute(Electrode)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e56] [cursor=pointer]: ProjectRoute(Electrode)
            - link "ProjectRoute(Warranty)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e57] [cursor=pointer]: ProjectRoute(Warranty)
            - link "CAPA":
              - /url: /view/SCP0084
              - paragraph [ref=f3e58] [cursor=pointer]: CAPA
            - link "SCP BOM (Cell~Pack)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e59] [cursor=pointer]: SCP BOM (Cell~Pack)
            - link "Model Code Master":
              - /url: /view/SCP0084
              - paragraph [ref=f3e60] [cursor=pointer]: Model Code Master
            - link "MDM Class Master":
              - /url: /view/SCP0084
              - paragraph [ref=f3e61] [cursor=pointer]: MDM Class Master
            - link "Shipment Working Day(OSP)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e62] [cursor=pointer]: Shipment Working Day(OSP)
            - link "SCP BOM(Elec)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e63] [cursor=pointer]: SCP BOM(Elec)
            - link "CAPA (Mobility IT)":
              - /url: /view/SCP0084
              - paragraph [ref=f3e64] [cursor=pointer]: CAPA (Mobility IT)
            - link "Line Assign":
              - /url: /view/SCP0084
              - paragraph [ref=f3e65] [cursor=pointer]: Line Assign
            - link "Speed Plan":
              - /url: /view/SCP0084
              - paragraph [ref=f3e66] [cursor=pointer]: Speed Plan
            - link "Loss Plan":
              - /url: /view/SCP0084
              - paragraph [ref=f3e67] [cursor=pointer]: Loss Plan
            - link "TEEP Report":
              - /url: /view/SCP0084
              - paragraph [ref=f3e68] [cursor=pointer]: TEEP Report
            - link "LOB Report":
              - /url: /view/SCP0084
              - paragraph [ref=f3e69] [cursor=pointer]: LOB Report
            - link "Demand Group Master":
              - /url: /view/SCP0084
              - paragraph [ref=f3e70] [cursor=pointer]: Demand Group Master
            - link "CAPA LineMaster":
              - /url: /view/SCP0084
              - paragraph [ref=f3e71] [cursor=pointer]: CAPA LineMaster
            - link "Operation LT":
              - /url: /view/SCP0084
              - paragraph [ref=f3e72] [cursor=pointer]: Operation LT
          - generic [ref=f3e73]:
            - link [ref=f3e74] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e75]: Supply Plan
            - link "Plan Management":
              - /url: /view/SCP0084
              - paragraph [ref=f3e78] [cursor=pointer]: Plan Management
            - link "Shipment Plan FG":
              - /url: /view/SCP0084
              - paragraph [ref=f3e79] [cursor=pointer]: Shipment Plan FG
            - link "Shipment Plan SEMI":
              - /url: /view/SCP0084
              - paragraph [ref=f3e80] [cursor=pointer]: Shipment Plan SEMI
            - link "Production Plan Line":
              - /url: /view/SCP0084
              - paragraph [ref=f3e81] [cursor=pointer]: Production Plan Line
            - link "Production Plan Fix":
              - /url: /view/SCP0084
              - paragraph [ref=f3e82] [cursor=pointer]: Production Plan Fix
            - link "Shipment Plan Fix":
              - /url: /view/SCP0084
              - paragraph [ref=f3e83] [cursor=pointer]: Shipment Plan Fix
            - link "Global PSI":
              - /url: /view/SCP0084
              - paragraph [ref=f3e84] [cursor=pointer]: Global PSI
            - link "Global PSI Elec":
              - /url: /view/SCP0084
              - paragraph [ref=f3e85] [cursor=pointer]: Global PSI Elec
            - link "Global PSI New":
              - /url: /view/SCP0084
              - paragraph [ref=f3e86] [cursor=pointer]: Global PSI New
            - link "Integration PSI":
              - /url: /view/SCP0084
              - paragraph [ref=f3e87] [cursor=pointer]: Integration PSI
          - generic [ref=f3e88]:
            - link [ref=f3e89] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e90]: Waterfall
            - link "Shipment Plan FG Waterfall":
              - /url: /view/SCP0084
              - paragraph [ref=f3e93] [cursor=pointer]: Shipment Plan FG Waterfall
            - link "Production Plan Waterfall":
              - /url: /view/SCP0084
              - paragraph [ref=f3e94] [cursor=pointer]: Production Plan Waterfall
            - link "Shipment Plan Semi Waterfall":
              - /url: /view/SCP0084
              - paragraph [ref=f3e95] [cursor=pointer]: Shipment Plan Semi Waterfall
          - generic [ref=f3e96]:
            - link [ref=f3e97] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e98]: OPT Plan
            - link "Plan Control":
              - /url: /view/SCP0084
              - paragraph [ref=f3e101] [cursor=pointer]: Plan Control
            - link "OPT CAPA":
              - /url: /view/SCP0084
              - paragraph [ref=f3e102] [cursor=pointer]: OPT CAPA
            - link "Workbench":
              - /url: /view/SCP0084
              - paragraph [ref=f3e103] [cursor=pointer]: Workbench
            - link "Constraint Mgmt":
              - /url: /view/SCP0084
              - paragraph [ref=f3e104] [cursor=pointer]: Constraint Mgmt
            - link "Plan Group Master":
              - /url: /view/SCP0084
              - paragraph [ref=f3e105] [cursor=pointer]: Plan Group Master
            - link "Plan Activity Mgmt":
              - /url: /view/SCP0084
              - paragraph [ref=f3e106] [cursor=pointer]: Plan Activity Mgmt
            - link "Plan Group Dashboard":
              - /url: /view/SCP0084
              - paragraph [ref=f3e107] [cursor=pointer]: Plan Group Dashboard
            - link "Precede/Safety Stock Day":
              - /url: /view/SCP0084
              - paragraph [ref=f3e108] [cursor=pointer]: Precede/Safety Stock Day
            - link "Precede/Safety Stock Qty":
              - /url: /view/SCP0084
              - paragraph [ref=f3e109] [cursor=pointer]: Precede/Safety Stock Qty
            - link "Demand Exception":
              - /url: /view/SCP0084
              - paragraph [ref=f3e110] [cursor=pointer]: Demand Exception
            - link "Scheduled Receipt Information":
              - /url: /view/SCP0084
              - paragraph [ref=f3e111] [cursor=pointer]: Scheduled Receipt Information
            - link "Sales Site Priority":
              - /url: /view/SCP0084
              - paragraph [ref=f3e112] [cursor=pointer]: Sales Site Priority
            - link "Constraint Of Shipment Qty":
              - /url: /view/SCP0084
              - paragraph [ref=f3e113] [cursor=pointer]: Constraint Of Shipment Qty
            - link "Warehouse Capacity":
              - /url: /view/SCP0084
              - paragraph [ref=f3e114] [cursor=pointer]: Warehouse Capacity
          - generic [ref=f3e115]:
            - link [ref=f3e116] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e117]: SCM Supply
            - link [ref=f3e120] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e121]: Shipment(Allo) Report
            - link [ref=f3e122] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e123]: Long-term stock
            - link [ref=f3e124] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e125]: Ending Inventory
            - link [ref=f3e126] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e127]: Inventory Trend
          - generic [ref=f3e128]:
            - link [ref=f3e129] [cursor=pointer]:
              - /url: /view/SCP0084
              - paragraph [ref=f3e130]: Validation
            - link "Intransit Inventory":
              - /url: /view/SCP0084
              - paragraph [ref=f3e133] [cursor=pointer]: Intransit Inventory
      - main [ref=f3e134]:
        - generic [ref=f3e136]:
          - generic [ref=f3e137]:
            - generic [ref=f3e138]:
              - button "Home" [ref=f3e139] [cursor=pointer]
              - button "Long-term stock" [ref=f3e141] [cursor=pointer]
            - generic [ref=f3e146]:
              - button "Scroll tabs left" [disabled] [ref=f3e147]
              - button "Scroll tabs right" [disabled] [ref=f3e150]
              - button "Close others" [ref=f3e153] [cursor=pointer]
              - button "Close All" [ref=f3e154] [cursor=pointer]
          - generic [ref=f3e155]:
            - generic [ref=f3e158]:
              - generic [ref=f3e160]:
                - generic [ref=f3e161]:
                  - img [aria-hidden] [ref=f3e163] [cursor=pointer]
                  - paragraph [ref=f3e166]: Long-term stock
                - generic [ref=f3e167]:
                  - generic [ref=f3e168]: Supply
                  - generic [ref=f3e173]: SCM Supply
                  - generic [ref=f3e178]: Long-term stock
                - generic [ref=f3e180]:
                  - generic [ref=f3e181]: Search Area
                  - switch [checked] [active] [ref=f3e184] [cursor=pointer]
                - button "Full screen" [ref=f3e187] [cursor=pointer]
              - generic [ref=f3e197]:
                - generic [ref=f3e198]:
                  - generic [ref=f3e200]:
                    - generic [ref=f3e201]: Month
                    - generic [ref=f3e206]:
                      - button "calendar" [ref=f3e207] [cursor=pointer]
                      - textbox "YYYY.MM" [ref=f3e218]: "2026.09"
                  - generic [ref=f3e220]:
                    - generic [ref=f3e221]: Div
                    - generic [ref=f3e229] [cursor=pointer]:
                      - generic "40 Mobility & IT Battery" [ref=f3e230]:
                        - paragraph [ref=f3e234]: 40 Mobility & IT Battery
                      - combobox
                      - button "Open" [ref=f3e240]
                      - group [aria-hidden]
                  - generic [ref=f3e245]:
                    - generic [ref=f3e246]: Plant
                    - generic [ref=f3e254] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e255]
                      - button "Open" [ref=f3e257]
                      - group [aria-hidden]
                  - generic [ref=f3e262]:
                    - generic [ref=f3e263]: Long Term Type
                    - generic [ref=f3e271] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e272]
                      - button "Open" [ref=f3e274]
                      - group [aria-hidden]
                - button [ref=f3e279] [cursor=pointer]
              - generic [ref=f3e284]:
                - generic:
                  - paragraph
                - generic [ref=f3e285]:
                  - generic "Save" [ref=f3e286]:
                    - button [ref=f3e287] [cursor=pointer]
                  - generic "Sort" [ref=f3e291]:
                    - button [ref=f3e292] [cursor=pointer]
                  - generic "Filter" [ref=f3e297]:
                    - button [ref=f3e298] [cursor=pointer]
                  - generic "Condition" [ref=f3e303]:
                    - button [ref=f3e304] [cursor=pointer]
                  - generic "Reset Condition" [ref=f3e314]:
                    - button [ref=f3e315] [cursor=pointer]
                  - generic "Excel" [ref=f3e322]:
                    - button [ref=f3e323] [cursor=pointer]
              - generic [ref=f3e331]:
                - grid [ref=f3e332]:
                  - rowgroup [ref=f3e333]:
                    - generic:
                      - row "YY.MM DIV Plant Site Plant Material Description Unit Long term Type Item Type Process Group Material Group GPLM Cell Model MDM Project Nick name Extra Spec GPLM Cell Conversion factor MDM class_Lv1 No":
                        - columnheader "YY.MM" [ref=f3e334]
                        - columnheader "DIV" [ref=f3e335]
                        - columnheader "Plant Site" [ref=f3e336]
                        - columnheader "Plant" [ref=f3e337]
                        - columnheader "Material" [ref=f3e338]
                        - columnheader "Description" [ref=f3e339]
                        - columnheader "Unit" [ref=f3e340]
                        - columnheader "Long term Type" [ref=f3e341]
                        - columnheader "Item Type" [ref=f3e342]
                        - columnheader "Process Group" [ref=f3e343]
                        - columnheader "Material Group" [ref=f3e344]
                        - columnheader "GPLM Cell Model" [ref=f3e345]
                        - columnheader "MDM Project Nick name" [ref=f3e346]
                        - columnheader "Extra Spec" [ref=f3e347]
                        - columnheader "GPLM Cell Conversion factor" [ref=f3e348]
                        - columnheader "MDM class_Lv1" [ref=f3e349]
                        - gridcell "No" [ref=f3e350]
                        - gridcell [ref=f3e351]
                  - rowgroup [ref=f3e352]:
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f3e354]
                  - generic [ref=f3e356]:
                    - generic:
                      - row "No"
                - generic [ref=f3e357]:
                  - status
                  - generic [ref=f3e358]: "0"
                - generic:
                  - spinbutton "InputNumber Input" [ref=f3e362]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e366]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e370]: "0.0000000"
                  - spinbutton "InputNumber Input" [ref=f3e374]: "0.00"
                  - spinbutton "InputNumber Input" [ref=f3e378]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e382]: "0.00"
                  - spinbutton "InputNumber Input" [ref=f3e386]: "0.0000000"
                  - spinbutton "InputNumber Input" [ref=f3e390]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e394]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e398]: "0.0000000"
                  - spinbutton "InputNumber Input" [ref=f3e402]: "0.00"
                  - spinbutton "InputNumber Input" [ref=f3e406]: "0"
                  - spinbutton "InputNumber Input" [ref=f3e410]: "0.00"
                  - spinbutton "InputNumber Input" [ref=f3e414]: "0.0000000"
            - alert [ref=f3e415]:
              - generic [ref=f3e416] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f3e419] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  21  |     //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
  22  |     const expanded = await nscm.expandSearchArea();
  23  |     const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
  24  |     for (const f of PLAN.fields) {
  25  |       if (f.excluded) { labelSkip.push(`${f.label}(${f.asis}: ${f.excludedWhy})`); continue; }
  26  |       // 2026-11-08 (a): 별칭 표의 TO-BE 명칭(예 Valid→Active)도 후보 — 검사기와 기대값 원천을 같이 쓴다(종전엔 smoke 만 별칭 없이 '누락' → 검사기 PASS 와 불일치)
  27  |       const cands0: string[] = f.labels && f.labels.length ? f.labels : [f.label];
  28  |       const AL = loadLabelAliases(MENU); const cands = [...new Set([...cands0, ...cands0.map((l: string) => aliasFor(l, AL)?.tobe_label || '').filter(Boolean)])];
  29  |       const hit = await nscm.fieldExistsAny(cands);
  30  |       if (hit) labelHits.push(`${f.label}→${hit}`); else labelMiss.push(f.label);
  31  |       expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
  32  |     }
  33  |     test.info().annotations.push({ type: 'labels', description: `펼침=${expanded} 일치 ${labelHits.length} / 누락 ${labelMiss.length}${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}` });
  34  |     // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
  35  |     const gridCount = await nscm.grids().count();
  36  |     expect(gridCount, `그리드 ≥1 (메인시트 ${PLAN.mainSheets.length})`).toBeGreaterThanOrEqual(1);
  37  |     // Division 선택(있으면) 후 조회
  38  |     if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
  39  |     const calls = await nscm.search();
  40  |     const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
  41  |     expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
  42  |     for (const c of calls) expect.soft(c.status, `call-proc ${c.sheet}/${c.btn} HTTP`).toBeLessThan(400);
  43  |     // 2026-10-21: 브라우저 콘솔 오류/페이지 예외 — Wijmo 단언(그리드 생성 실패)·Uncaught 는 화면 결함으로 FAIL, 나머지는 기록만
  44  |     { const errs = nscm.consoleErrors; const fatal = errs.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  45  |       test.info().annotations.push({ type: 'console', description: errs.length ? `오류 ${errs.length}(치명 ${fatal.length}): ${[...fatal, ...errs.filter(e => !fatal.includes(e))].slice(0, 3).join(' || ')}` : '오류 0' });
  46  |       expect.soft(fatal.length, `브라우저 콘솔 치명 오류 0 — ${fatal[0] || ''}`).toBe(0); }
  47  |     const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
  48  |     expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
  49  |     // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
  50  |     const headers = await nscm.gridHeadersAll(0);  // T162: 가로 가상화로 DOM 헤더가 일부만 보여 허위 누락
  51  |     // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
  52  |     const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
  53  |     const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
  54  |     const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
  55  |     const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
  56  |     const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
  57  |     const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  58  |     // 2026-10-21: As-is SetLayout(조회조건에 따라 표시/숨김)이 다루는 컬럼은 기본 조회에서 안 보여도 '누락' 이 아니다(SCP0100 Product Level1~3)
  59  |     const condSet = new Set(((PLAN.condLabels || []) as string[]).map(norm));
  60  |     const missingAll = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
  61  |     const condHidden = missingAll.filter((c: string) => condSet.has(norm(c)));
  62  |     const missing = missingAll.filter((c: string) => !condSet.has(norm(c)));
  63  |     test.info().annotations.push({ type: 'columns', description: `시트 ${sheetName}(${firstSearch ? firstSearch.sheet : '-'}) 헤더 ${headers.length} / 기대 ${expectCols.length} / 누락 ${missing.length}: ${missing.slice(0, 10).join(', ')}${condHidden.length ? ' / 조건부 표시(SetLayout) 제외 ' + condHidden.length + ': ' + condHidden.join(', ') : ''}` });
  64  |     expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
  65  |     // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
  66  |     // As-is 헤더 사양 대조(2026-10-21 SCP0100: 대조표 '구현' 인데 3단 헤더가 144px 한 칸으로 병합되고 "Qty" 행이 없었다) — 행 수·병합 리터럴·행 높이
  67  |     if (PLAN.headerSpec && PLAN.headerSpec.rows > 1) {
  68  |       const HS = PLAN.headerSpec; const hr = await nscm.gridHeaderRows(0);
  69  |       const texts = new Set(hr.rows.flatMap(r => r.texts));
  70  |       const missLit = (HS.literals || []).filter((l: string) => !texts.has(l));
  71  |       test.info().annotations.push({ type: 'header', description: `As-is 헤더 ${HS.rows}행(병합 리터럴 ${(HS.literals || []).join('/') || '-'}) ↔ To-Be 행 ${hr.rows.length}(높이 ${hr.rows.map(r => r.h).join('+')}=${hr.height}px)${missLit.length ? ' · 리터럴 누락 ' + missLit.join(',') : ''}` });
  72  |       // 행 수는 '시각적 단' 기준 — As-is 월간은 3행이어도 Qty 가 1~2행을 병합해 2단으로 보인다. 따라서 2단 이상이면 통과(리터럴·분리·높이 검사가 실질 판정)
  73  |       expect.soft(hr.rows.length, `헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn ${HS.rows}행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검`).toBeGreaterThanOrEqual(Math.min(HS.rows, 2));
  74  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
  75  |       expect.soft(hr.height, `헤더 총 높이 ≤ ${HS.maxRowPx}px × ${HS.rows}행 (headerRowHeight 재적용 — check.js H01)`).toBeLessThanOrEqual(HS.maxRowPx * HS.rows);
  76  |       // 2026-10-21 사용자 지적: ① 리터럴(Qty) 칸은 상단 월 칸이 분리돼 있으면 하단도 분리(가로 병합 1칸 금지) ② leaf(Qty) 행이 그룹(월) 행보다 낮으면 As-is 와 역전
  77  |       if (HS.literals && HS.literals.length && hr.rows.length >= 2) {
  78  |         const top = hr.rows[0]; const litRow = hr.rows.find(r => (HS.literals as string[]).some((l: string) => r.texts.includes(l)));
  79  |         if (litRow) {
  80  |           const topDyn = top.cells.filter(c => !/^[A-Za-z가-힣 ./()]+$/.test(c)).length; // 상단 행에서 문자 라벨(고정 컬럼)이 아닌 칸(연월·주차) 수
  81  |           test.info().annotations.push({ type: 'header', description: `리터럴 행 칸 ${litRow.n} / 상단 동적 칸 ${topDyn} · 높이 상단 ${top.h} vs 리터럴 행 ${litRow.h}` });
  82  |           if (topDyn >= 2) expect.soft(litRow.n, `리터럴(${HS.literals.join('/')}) 칸이 월마다 분리(상단 동적 칸 ${topDyn}) — 1칸이면 헤더 가로 병합(check.js H05)`).toBeGreaterThanOrEqual(Math.min(topDyn, 2));
  83  |           expect.soft(litRow.h >= top.h, `leaf(${HS.literals.join('/')}) 행 높이(${litRow.h}) ≥ 상단 그룹 행(${top.h}) — As-is 는 Qty 영역이 더 높다(1~2행 병합)`).toBeTruthy();
  84  |         }
  85  |       }
  86  |     }
  87  |     if (PLAN.dynamicHeader) {
  88  |       const DH = PLAN.dynamicHeader;
  89  |       const binds = await nscm.gridBindings(0);
  90  |       const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
  91  |       const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
  92  |       const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
  93  |       test.info().annotations.push({ type: 'dynamic', description: `As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 ${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 ${binds ? binds.length : '판정불가'} / 정적밖 ${dyn.length} (${dyn.slice(0, 5).join(',')}) · 타이틀 시트 ${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 ${titleCalls.length}` });
  94  |       expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
  95  |       expect.soft(dyn.length, `동적 기간 컬럼 ≥1 (As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 ${stat.size}개 밖 컬럼)`).toBeGreaterThan(0);
  96  |       if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), `타이틀 시트 '${DH.titleSheets.join("','")}' call-proc 조회`).toBeTruthy();
  97  |     }
  98  |     await nscm.snapshot(`${MENU}_searched`);
  99  |     test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
  100 |     // 2026-10-23 사용자 지시: 다국어 미적용(코드 미등록 → '_기본문구' 노출) = 오류 — 조회조건 펼침·조회 후 보이는 글자 전체
  101 |     { const u = await nscm.untranslatedTexts();
  102 |       test.info().annotations.push({ type: 'i18n', description: u.length ? `'_' 노출 ${u.length}: ${u.slice(0, 15).join(' | ')}` : "'_' 노출 0" });
  103 |       expect.soft(u.length, `다국어 미적용 '_' 노출 0 — ${u.slice(0, 8).join(' | ')} (SCM_ADM_MSG_M 에 코드 등록 또는 기존 LBL/MSG 재사용 · 하네스 I18N1)`).toBe(0); }
  104 |   });
  105 |   // 2026-10-23 사용자 지시: 조회조건 각각의 동작 · 공통 기능 동작 (lib/smoke-extra.ts) — 결과는 cond:/common: 어노테이션 → _summary · 대조표(recon) 열
  106 |   test('조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인', async ({ nscm }) => {
  107 |     test.setTimeout(1_200_000);
  108 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  109 |     const items = await conditionCycle(nscm, test.info(), PLAN);
  110 |     const s = record(test.info(), 'cond', items);
  111 |     await nscm.snapshot(`${MENU}_cond`);
  112 |     expect.soft(s.fail, `조회조건 동작 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  113 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
  114 |   });
  115 |   test('공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual', async ({ nscm }) => {
  116 |     test.setTimeout(600_000);
  117 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  118 |     const items = await commonCycle(nscm, test.info(), PLAN);
  119 |     const s = record(test.info(), 'common', items);
  120 |     await nscm.snapshot(`${MENU}_common`);
> 121 |     expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
      |                                                                                                                         ^ Error: 공통 기능 FAIL 1: Excel 다운로드
  122 |   });
  123 | });
  124 | 
```