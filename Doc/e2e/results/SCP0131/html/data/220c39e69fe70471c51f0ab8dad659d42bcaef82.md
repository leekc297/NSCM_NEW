# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SCP0131.smoke.spec.ts >> SCP0131 SalesSitePriority 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SCP0131.smoke.spec.ts:111:7

# Error details

```
Error: 공통 기능 FAIL 1: Condition(F6) Period 비저장(기간 조건 제외)

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
        - /url: /view/SCP0131
        - generic [ref=f3e6]: SCM
        - generic [ref=f3e7]:
          - generic [ref=f3e8]: 공급망관리시스템
          - generic [ref=f3e9]: Supply Chain Management system
      - navigation [ref=f3e10]:
        - link "Demand" [ref=f3e11] [cursor=pointer]:
          - /url: /view/SCP0131
        - link "Supply" [ref=f3e12] [cursor=pointer]:
          - /url: /view/SCP0131
        - link "Shipping" [ref=f3e13] [cursor=pointer]:
          - /url: /view/SCP0131
        - link "Authority" [ref=f3e14] [cursor=pointer]:
          - /url: /view/SCP0131
        - link "Admin" [ref=f3e15] [cursor=pointer]:
          - /url: /view/SCP0131
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
              - /url: /view/SCP0131
              - paragraph [ref=f3e41]: Supply Master
            - link "Line Master":
              - /url: /view/SCP0131
              - paragraph [ref=f3e44] [cursor=pointer]: Line Master
            - link "Project Route":
              - /url: /view/SCP0131
              - paragraph [ref=f3e45] [cursor=pointer]: Project Route
            - link "BOD":
              - /url: /view/SCP0131
              - paragraph [ref=f3e46] [cursor=pointer]: BOD
            - link "Plant Site":
              - /url: /view/SCP0131
              - paragraph [ref=f3e47] [cursor=pointer]: Plant Site
            - link "Production Plan":
              - /url: /view/SCP0131
              - paragraph [ref=f3e48] [cursor=pointer]: Production Plan
            - link "Work Calendar(OSP)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e49] [cursor=pointer]: Work Calendar(OSP)
            - link "Tact Time(OSP)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e50] [cursor=pointer]: Tact Time(OSP)
            - link "Formation":
              - /url: /view/SCP0131
              - paragraph [ref=f3e51] [cursor=pointer]: Formation
            - link "Outsourcing Capacity":
              - /url: /view/SCP0131
              - paragraph [ref=f3e52] [cursor=pointer]: Outsourcing Capacity
            - link "BOD ITEM":
              - /url: /view/SCP0131
              - paragraph [ref=f3e53] [cursor=pointer]: BOD ITEM
            - link "Master Validation":
              - /url: /view/SCP0131
              - paragraph [ref=f3e54] [cursor=pointer]: Master Validation
            - link "Stock OSP":
              - /url: /view/SCP0131
              - paragraph [ref=f3e55] [cursor=pointer]: Stock OSP
            - link "ProjectRoute(Electrode)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e56] [cursor=pointer]: ProjectRoute(Electrode)
            - link "ProjectRoute(Warranty)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e57] [cursor=pointer]: ProjectRoute(Warranty)
            - link "CAPA":
              - /url: /view/SCP0131
              - paragraph [ref=f3e58] [cursor=pointer]: CAPA
            - link "SCP BOM (Cell~Pack)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e59] [cursor=pointer]: SCP BOM (Cell~Pack)
            - link "Model Code Master":
              - /url: /view/SCP0131
              - paragraph [ref=f3e60] [cursor=pointer]: Model Code Master
            - link "MDM Class Master":
              - /url: /view/SCP0131
              - paragraph [ref=f3e61] [cursor=pointer]: MDM Class Master
            - link "Shipment Working Day(OSP)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e62] [cursor=pointer]: Shipment Working Day(OSP)
            - link "SCP BOM(Elec)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e63] [cursor=pointer]: SCP BOM(Elec)
            - link "CAPA (Mobility IT)":
              - /url: /view/SCP0131
              - paragraph [ref=f3e64] [cursor=pointer]: CAPA (Mobility IT)
            - link "Line Assign":
              - /url: /view/SCP0131
              - paragraph [ref=f3e65] [cursor=pointer]: Line Assign
            - link "Speed Plan":
              - /url: /view/SCP0131
              - paragraph [ref=f3e66] [cursor=pointer]: Speed Plan
            - link "Loss Plan":
              - /url: /view/SCP0131
              - paragraph [ref=f3e67] [cursor=pointer]: Loss Plan
            - link "TEEP Report":
              - /url: /view/SCP0131
              - paragraph [ref=f3e68] [cursor=pointer]: TEEP Report
            - link "LOB Report":
              - /url: /view/SCP0131
              - paragraph [ref=f3e69] [cursor=pointer]: LOB Report
            - link "Demand Group Master":
              - /url: /view/SCP0131
              - paragraph [ref=f3e70] [cursor=pointer]: Demand Group Master
            - link "CAPA LineMaster":
              - /url: /view/SCP0131
              - paragraph [ref=f3e71] [cursor=pointer]: CAPA LineMaster
            - link "Operation LT":
              - /url: /view/SCP0131
              - paragraph [ref=f3e72] [cursor=pointer]: Operation LT
          - generic [ref=f3e73]:
            - link [ref=f3e74] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e75]: Supply Plan
            - link "Plan Management":
              - /url: /view/SCP0131
              - paragraph [ref=f3e78] [cursor=pointer]: Plan Management
            - link "Shipment Plan FG":
              - /url: /view/SCP0131
              - paragraph [ref=f3e79] [cursor=pointer]: Shipment Plan FG
            - link "Shipment Plan SEMI":
              - /url: /view/SCP0131
              - paragraph [ref=f3e80] [cursor=pointer]: Shipment Plan SEMI
            - link "Production Plan Line":
              - /url: /view/SCP0131
              - paragraph [ref=f3e81] [cursor=pointer]: Production Plan Line
            - link "Production Plan Fix":
              - /url: /view/SCP0131
              - paragraph [ref=f3e82] [cursor=pointer]: Production Plan Fix
            - link "Shipment Plan Fix":
              - /url: /view/SCP0131
              - paragraph [ref=f3e83] [cursor=pointer]: Shipment Plan Fix
            - link "Global PSI":
              - /url: /view/SCP0131
              - paragraph [ref=f3e84] [cursor=pointer]: Global PSI
            - link "Global PSI Elec":
              - /url: /view/SCP0131
              - paragraph [ref=f3e85] [cursor=pointer]: Global PSI Elec
            - link "Global PSI New":
              - /url: /view/SCP0131
              - paragraph [ref=f3e86] [cursor=pointer]: Global PSI New
            - link "Integration PSI":
              - /url: /view/SCP0131
              - paragraph [ref=f3e87] [cursor=pointer]: Integration PSI
          - generic [ref=f3e88]:
            - link [ref=f3e89] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e90]: Waterfall
            - link "Shipment Plan FG Waterfall":
              - /url: /view/SCP0131
              - paragraph [ref=f3e93] [cursor=pointer]: Shipment Plan FG Waterfall
            - link "Production Plan Waterfall":
              - /url: /view/SCP0131
              - paragraph [ref=f3e94] [cursor=pointer]: Production Plan Waterfall
            - link "Shipment Plan Semi Waterfall":
              - /url: /view/SCP0131
              - paragraph [ref=f3e95] [cursor=pointer]: Shipment Plan Semi Waterfall
          - generic [ref=f3e96]:
            - link [ref=f3e97] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e98]: OPT Plan
            - link [ref=f3e101] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e102]: Plan Control
            - link [ref=f3e103] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e104]: OPT CAPA
            - link [ref=f3e105] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e106]: Workbench
            - link [ref=f3e107] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e108]: Constraint Mgmt
            - link [ref=f3e109] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e110]: Plan Group Master
            - link [ref=f3e111] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e112]: Plan Activity Mgmt
            - link [ref=f3e113] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e114]: Plan Group Dashboard
            - link [ref=f3e115] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e116]: Precede/Safety Stock Day
            - link [ref=f3e117] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e118]: Precede/Safety Stock Qty
            - link [ref=f3e119] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e120]: Demand Exception
            - link [ref=f3e121] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e122]: Scheduled Receipt Information
            - link [ref=f3e123] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e124]: Sales Site Priority
            - link [ref=f3e125] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e126]: Constraint Of Shipment Qty
            - link [ref=f3e127] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e128]: Warehouse Capacity
          - generic [ref=f3e129]:
            - link [ref=f3e130] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e131]: SCM Supply
            - link "Shipment(Allo) Report":
              - /url: /view/SCP0131
              - paragraph [ref=f3e134] [cursor=pointer]: Shipment(Allo) Report
            - link "Long-term stock":
              - /url: /view/SCP0131
              - paragraph [ref=f3e135] [cursor=pointer]: Long-term stock
            - link "Ending Inventory":
              - /url: /view/SCP0131
              - paragraph [ref=f3e136] [cursor=pointer]: Ending Inventory
            - link "Inventory Trend":
              - /url: /view/SCP0131
              - paragraph [ref=f3e137] [cursor=pointer]: Inventory Trend
          - generic [ref=f3e138]:
            - link [ref=f3e139] [cursor=pointer]:
              - /url: /view/SCP0131
              - paragraph [ref=f3e140]: Validation
            - link "Intransit Inventory":
              - /url: /view/SCP0131
              - paragraph [ref=f3e143] [cursor=pointer]: Intransit Inventory
      - main [ref=f3e144]:
        - generic [ref=f3e146]:
          - generic [ref=f3e147]:
            - generic [ref=f3e148]:
              - button "Home" [ref=f3e149] [cursor=pointer]
              - button "Sales Site Priority" [ref=f3e151] [cursor=pointer]
            - generic [ref=f3e156]:
              - button "Scroll tabs left" [disabled] [ref=f3e157]
              - button "Scroll tabs right" [disabled] [ref=f3e160]
              - button "Close others" [ref=f3e163] [cursor=pointer]
              - button "Close All" [ref=f3e164] [cursor=pointer]
          - generic [ref=f3e165]:
            - generic [ref=f3e168]:
              - generic [ref=f3e170]:
                - generic [ref=f3e171]:
                  - img [aria-hidden] [ref=f3e173] [cursor=pointer]
                  - paragraph [ref=f3e176]: Sales Site Priority
                - generic [ref=f3e177]:
                  - generic [ref=f3e178]: Supply
                  - generic [ref=f3e183]: OPT Plan
                  - generic [ref=f3e188]: Sales Site Priority
                - generic [ref=f3e190]:
                  - generic [ref=f3e191]: Search Area
                  - switch [checked] [active] [ref=f3e194] [cursor=pointer]
                - button "Full screen" [ref=f3e197] [cursor=pointer]
              - generic [ref=f3e207]:
                - generic [ref=f3e208]:
                  - generic [ref=f3e210]:
                    - generic [ref=f3e211]: Div
                    - generic [ref=f3e219]:
                      - combobox [ref=f3e220]: 40 Mobility & IT Battery
                      - button "Open" [ref=f3e222] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e227]:
                    - generic [ref=f3e228]: Plan Group
                    - generic [ref=f3e236] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e237]
                      - button "Open" [ref=f3e239]
                      - group [aria-hidden]
                  - generic [ref=f3e244]:
                    - generic [ref=f3e245]: SCM Site
                    - generic [ref=f3e253] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e254]
                      - button "Open" [ref=f3e256]
                      - group [aria-hidden]
                  - generic [ref=f3e261]:
                    - generic [ref=f3e262]: Model/Nickname
                    - generic [ref=f3e268]:
                      - textbox [ref=f3e269]
                      - button [ref=f3e270] [cursor=pointer]
                  - generic [ref=f3e276]:
                    - generic [ref=f3e277]: Period
                    - generic [ref=f3e282]:
                      - generic [ref=f3e283] [cursor=pointer]:
                        - button "Open calendar" [ref=f3e284]
                        - textbox "YYYY.MM.DD" [ref=f3e293]: 2026.11.02
                      - generic [ref=f3e294]: ~
                      - generic [ref=f3e295] [cursor=pointer]:
                        - button "Open calendar" [ref=f3e296]
                        - textbox "YYYY.MM.DD" [ref=f3e305]: 2027.11.01
                  - generic [ref=f3e307]:
                    - generic [ref=f3e308]: Active
                    - generic [ref=f3e316]:
                      - combobox [ref=f3e317]: ALL
                      - button "Open" [ref=f3e319] [cursor=pointer]
                      - group [aria-hidden]
                - button [ref=f3e324] [cursor=pointer]
              - generic [ref=f3e329]:
                - generic:
                  - paragraph
                - generic [ref=f3e330]:
                  - generic "Insert Row" [ref=f3e331]:
                    - button [ref=f3e332] [cursor=pointer]
                  - generic "Remove" [ref=f3e337]:
                    - button [ref=f3e338] [cursor=pointer]
                  - generic "Save" [ref=f3e345]:
                    - button [ref=f3e346] [cursor=pointer]
                  - generic "Sort" [ref=f3e350]:
                    - button [ref=f3e351] [cursor=pointer]
                  - generic "Filter" [ref=f3e356]:
                    - button [ref=f3e357] [cursor=pointer]
                  - generic "Condition" [ref=f3e362]:
                    - button [ref=f3e363] [cursor=pointer]
                  - generic "Reset Condition" [ref=f3e373]:
                    - button [ref=f3e374] [cursor=pointer]
                  - generic "Excel" [ref=f3e381]:
                    - button [ref=f3e382] [cursor=pointer]
              - generic [ref=f3e390]:
                - grid [ref=f3e391]:
                  - rowgroup [ref=f3e392]:
                    - generic:
                      - row "Div Plan Group SCM site Model Priority Valid From Valid To Description Active Create By Creation Date Last Update By Last Update Date No":
                        - columnheader "Div" [ref=f3e393]
                        - columnheader "Plan Group" [ref=f3e394]
                        - columnheader "SCM site" [ref=f3e395]
                        - columnheader "Model" [ref=f3e396]
                        - columnheader "Priority" [ref=f3e397]
                        - columnheader "Valid From" [ref=f3e398]
                        - columnheader "Valid To" [ref=f3e399]
                        - columnheader "Description" [ref=f3e400]
                        - columnheader "Active" [ref=f3e401]
                        - columnheader "Create By" [ref=f3e402]
                        - columnheader "Creation Date" [ref=f3e403]
                        - columnheader "Last Update By" [ref=f3e404]
                        - columnheader "Last Update Date" [ref=f3e405]
                        - gridcell "No" [ref=f3e406]
                        - gridcell [ref=f3e407]
                  - rowgroup [ref=f3e408]:
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f3e410]
                  - generic [ref=f3e412]:
                    - generic:
                      - row "No"
                - generic [ref=f3e413]:
                  - status
                  - generic [ref=f3e414]: "0"
                - generic:
                  - generic [ref=f3e417]:
                    - combobox "InputDate Input" [ref=f3e418]: 2026-11-07
                    - button "Choose Date" [ref=f3e420] [cursor=pointer]
                  - generic [ref=f3e424]:
                    - combobox "InputDate Input" [ref=f3e425]: 2026-11-07
                    - button "Choose Date" [ref=f3e427] [cursor=pointer]
                  - generic [ref=f3e431]:
                    - combobox "InputDate Input" [ref=f3e432]: 2026-11-07
                    - button "Choose Date" [ref=f3e434] [cursor=pointer]
                  - generic [ref=f3e438]:
                    - combobox "InputDate Input" [ref=f3e439]: 2026-11-07
                    - button "Choose Date" [ref=f3e441] [cursor=pointer]
            - alert [ref=f3e443]:
              - generic [ref=f3e444] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f3e447] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  17  |       if (errs0.length) test.info().annotations.push({ type: 'console', description: `열림 직후 오류 ${errs0.length}(치명 ${fatal0.length}): ${[...fatal0, ...errs0.filter(e => !fatal0.includes(e))].slice(0, 3).join(' || ')}` });
  18  |       expect.soft(fatal0.length, `화면 열림 직후 브라우저 콘솔 치명 오류 0 — ${fatal0[0] || ''}`).toBe(0); }
  19  |     // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
  20  |     //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
  21  |     const expanded = await nscm.expandSearchArea();
  22  |     const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
  23  |     for (const f of PLAN.fields) {
  24  |       if (f.excluded) { labelSkip.push(`${f.label}(${f.asis}: ${f.excludedWhy})`); continue; }
  25  |       const hit = await nscm.fieldExistsAny(f.labels && f.labels.length ? f.labels : [f.label]);
  26  |       if (hit) labelHits.push(`${f.label}→${hit}`); else labelMiss.push(f.label);
  27  |       expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
  28  |     }
  29  |     test.info().annotations.push({ type: 'labels', description: `펼침=${expanded} 일치 ${labelHits.length} / 누락 ${labelMiss.length}${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}` });
  30  |     // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
  31  |     const gridCount = await nscm.grids().count();
  32  |     expect(gridCount, `그리드 ≥1 (메인시트 ${PLAN.mainSheets.length})`).toBeGreaterThanOrEqual(1);
  33  |     // Division 선택(있으면) 후 조회
  34  |     if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
  35  |     const calls = await nscm.search();
  36  |     const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
  37  |     expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
  38  |     for (const c of calls) expect.soft(c.status, `call-proc ${c.sheet}/${c.btn} HTTP`).toBeLessThan(400);
  39  |     // 2026-10-21: 브라우저 콘솔 오류/페이지 예외 — Wijmo 단언(그리드 생성 실패)·Uncaught 는 화면 결함으로 FAIL, 나머지는 기록만
  40  |     { const errs = nscm.consoleErrors; const fatal = errs.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  41  |       test.info().annotations.push({ type: 'console', description: errs.length ? `오류 ${errs.length}(치명 ${fatal.length}): ${[...fatal, ...errs.filter(e => !fatal.includes(e))].slice(0, 3).join(' || ')}` : '오류 0' });
  42  |       expect.soft(fatal.length, `브라우저 콘솔 치명 오류 0 — ${fatal[0] || ''}`).toBe(0); }
  43  |     const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
  44  |     expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
  45  |     // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
  46  |     const headers = await nscm.gridHeaders(0);
  47  |     // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
  48  |     const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
  49  |     const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
  50  |     const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
  51  |     const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
  52  |     const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
  53  |     const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  54  |     // 2026-10-21: As-is SetLayout(조회조건에 따라 표시/숨김)이 다루는 컬럼은 기본 조회에서 안 보여도 '누락' 이 아니다(SCP0100 Product Level1~3)
  55  |     const condSet = new Set(((PLAN.condLabels || []) as string[]).map(norm));
  56  |     const missingAll = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
  57  |     const condHidden = missingAll.filter((c: string) => condSet.has(norm(c)));
  58  |     const missing = missingAll.filter((c: string) => !condSet.has(norm(c)));
  59  |     test.info().annotations.push({ type: 'columns', description: `시트 ${sheetName}(${firstSearch ? firstSearch.sheet : '-'}) 헤더 ${headers.length} / 기대 ${expectCols.length} / 누락 ${missing.length}: ${missing.slice(0, 10).join(', ')}${condHidden.length ? ' / 조건부 표시(SetLayout) 제외 ' + condHidden.length + ': ' + condHidden.join(', ') : ''}` });
  60  |     expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
  61  |     // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
  62  |     // As-is 헤더 사양 대조(2026-10-21 SCP0100: 대조표 '구현' 인데 3단 헤더가 144px 한 칸으로 병합되고 "Qty" 행이 없었다) — 행 수·병합 리터럴·행 높이
  63  |     if (PLAN.headerSpec && PLAN.headerSpec.rows > 1) {
  64  |       const HS = PLAN.headerSpec; const hr = await nscm.gridHeaderRows(0);
  65  |       const texts = new Set(hr.rows.flatMap(r => r.texts));
  66  |       const missLit = (HS.literals || []).filter((l: string) => !texts.has(l));
  67  |       test.info().annotations.push({ type: 'header', description: `As-is 헤더 ${HS.rows}행(병합 리터럴 ${(HS.literals || []).join('/') || '-'}) ↔ To-Be 행 ${hr.rows.length}(높이 ${hr.rows.map(r => r.h).join('+')}=${hr.height}px)${missLit.length ? ' · 리터럴 누락 ' + missLit.join(',') : ''}` });
  68  |       // 행 수는 '시각적 단' 기준 — As-is 월간은 3행이어도 Qty 가 1~2행을 병합해 2단으로 보인다. 따라서 2단 이상이면 통과(리터럴·분리·높이 검사가 실질 판정)
  69  |       expect.soft(hr.rows.length, `헤더 시각적 단 수 ≥ 2 (As-is SetSheetHeaderColumn ${HS.rows}행 · 월간은 Qty 2행 병합 = 2단) — 1단이면 columnGroups leaf 라벨 점검`).toBeGreaterThanOrEqual(Math.min(HS.rows, 2));
  70  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
  71  |       expect.soft(hr.height, `헤더 총 높이 ≤ ${HS.maxRowPx}px × ${HS.rows}행 (headerRowHeight 재적용 — check.js H01)`).toBeLessThanOrEqual(HS.maxRowPx * HS.rows);
  72  |       // 2026-10-21 사용자 지적: ① 리터럴(Qty) 칸은 상단 월 칸이 분리돼 있으면 하단도 분리(가로 병합 1칸 금지) ② leaf(Qty) 행이 그룹(월) 행보다 낮으면 As-is 와 역전
  73  |       if (HS.literals && HS.literals.length && hr.rows.length >= 2) {
  74  |         const top = hr.rows[0]; const litRow = hr.rows.find(r => (HS.literals as string[]).some((l: string) => r.texts.includes(l)));
  75  |         if (litRow) {
  76  |           const topDyn = top.cells.filter(c => !/^[A-Za-z가-힣 ./()]+$/.test(c)).length; // 상단 행에서 문자 라벨(고정 컬럼)이 아닌 칸(연월·주차) 수
  77  |           test.info().annotations.push({ type: 'header', description: `리터럴 행 칸 ${litRow.n} / 상단 동적 칸 ${topDyn} · 높이 상단 ${top.h} vs 리터럴 행 ${litRow.h}` });
  78  |           if (topDyn >= 2) expect.soft(litRow.n, `리터럴(${HS.literals.join('/')}) 칸이 월마다 분리(상단 동적 칸 ${topDyn}) — 1칸이면 헤더 가로 병합(check.js H05)`).toBeGreaterThanOrEqual(Math.min(topDyn, 2));
  79  |           expect.soft(litRow.h >= top.h, `leaf(${HS.literals.join('/')}) 행 높이(${litRow.h}) ≥ 상단 그룹 행(${top.h}) — As-is 는 Qty 영역이 더 높다(1~2행 병합)`).toBeTruthy();
  80  |         }
  81  |       }
  82  |     }
  83  |     if (PLAN.dynamicHeader) {
  84  |       const DH = PLAN.dynamicHeader;
  85  |       const binds = await nscm.gridBindings(0);
  86  |       const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
  87  |       const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
  88  |       const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
  89  |       test.info().annotations.push({ type: 'dynamic', description: `As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 ${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 ${binds ? binds.length : '판정불가'} / 정적밖 ${dyn.length} (${dyn.slice(0, 5).join(',')}) · 타이틀 시트 ${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 ${titleCalls.length}` });
  90  |       expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
  91  |       expect.soft(dyn.length, `동적 기간 컬럼 ≥1 (As-is ${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 ${stat.size}개 밖 컬럼)`).toBeGreaterThan(0);
  92  |       if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), `타이틀 시트 '${DH.titleSheets.join("','")}' call-proc 조회`).toBeTruthy();
  93  |     }
  94  |     await nscm.snapshot(`${MENU}_searched`);
  95  |     test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
  96  |     // 2026-10-23 사용자 지시: 다국어 미적용(코드 미등록 → '_기본문구' 노출) = 오류 — 조회조건 펼침·조회 후 보이는 글자 전체
  97  |     { const u = await nscm.untranslatedTexts();
  98  |       test.info().annotations.push({ type: 'i18n', description: u.length ? `'_' 노출 ${u.length}: ${u.slice(0, 15).join(' | ')}` : "'_' 노출 0" });
  99  |       expect.soft(u.length, `다국어 미적용 '_' 노출 0 — ${u.slice(0, 8).join(' | ')} (SCM_ADM_MSG_M 에 코드 등록 또는 기존 LBL/MSG 재사용 · 하네스 I18N1)`).toBe(0); }
  100 |   });
  101 |   // 2026-10-23 사용자 지시: 조회조건 각각의 동작 · 공통 기능 동작 (lib/smoke-extra.ts) — 결과는 cond:/common: 어노테이션 → _summary · 대조표(recon) 열
  102 |   test('조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인', async ({ nscm }) => {
  103 |     test.setTimeout(1_200_000);
  104 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  105 |     const items = await conditionCycle(nscm, test.info(), PLAN);
  106 |     const s = record(test.info(), 'cond', items);
  107 |     await nscm.snapshot(`${MENU}_cond`);
  108 |     expect.soft(s.fail, `조회조건 동작 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  109 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
  110 |   });
  111 |   test('공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual', async ({ nscm }) => {
  112 |     test.setTimeout(600_000);
  113 |     const r = await nscm.openScreen(MENU); expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  114 |     const items = await commonCycle(nscm, test.info(), PLAN);
  115 |     const s = record(test.info(), 'common', items);
  116 |     await nscm.snapshot(`${MENU}_common`);
> 117 |     expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
      |                                                                                                                         ^ Error: 공통 기능 FAIL 1: Condition(F6) Period 비저장(기간 조건 제외)
  118 |   });
  119 | });
  120 | 
```