# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0023.smoke.spec.ts >> SSP0023 ShipmentPlanElectrode 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SSP0023.smoke.spec.ts:115:7

# Error details

```
Error: 공통 기능 FAIL 1: Search Area 조회영역 토글

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
        - /url: /view/SSP0023
        - generic [ref=f3e6]: SCM
        - generic [ref=f3e7]:
          - generic [ref=f3e8]: 공급망관리시스템
          - generic [ref=f3e9]: Supply Chain Management system
      - navigation [ref=f3e10]:
        - link "Demand" [ref=f3e11] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Supply" [ref=f3e12] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Shipping" [ref=f3e13] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Report" [ref=f3e14] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Authority" [ref=f3e15] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Admin" [ref=f3e16] [cursor=pointer]:
          - /url: /view/SSP0023
      - generic [ref=f3e17]:
        - button "KOR" [ref=f3e19] [cursor=pointer]
        - button "이 이민용" [ref=f3e23] [cursor=pointer]:
          - paragraph [ref=f3e28]: 이
          - generic [ref=f3e29]: 이민용
    - generic [ref=f3e30]:
      - button [ref=f3e31] [cursor=pointer]
      - complementary [ref=f3e37]:
        - navigation [ref=f3e38]:
          - paragraph [ref=f3e39]: Shipping
          - generic [ref=f3e40]:
            - link [ref=f3e41] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0023
              - paragraph [ref=f3e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0023
              - paragraph [ref=f3e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0023
              - paragraph [ref=f3e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0023
              - paragraph [ref=f3e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0023
              - paragraph [ref=f3e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0023
              - paragraph [ref=f3e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0023
              - paragraph [ref=f3e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0023
              - paragraph [ref=f3e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f3e53]:
            - link [ref=f3e54] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e55]: Shipping Schedule
            - link [ref=f3e58] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e59]: Shipment Request
            - link [ref=f3e60] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e61]: Shipment Plan(Mobility & IT)
            - link [ref=f3e62] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e63]: Shipment Plan(Electrode)
            - link [ref=f3e64] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f3e66] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e67]: Shipment Plan Detail
            - link [ref=f3e68] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e69]: Shipment Change History
            - link [ref=f3e70] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e71]: Shipment Plan(Auto & ESS)
            - link [ref=f3e72] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e73]: Shipment Request(Mobility & IT)
            - link [ref=f3e74] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e75]: Shipment Request(Electrode)
            - link [ref=f3e76] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e77]: Shipment Change Request
            - link [ref=f3e78] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e79]: Shipment Change Request Confirm
            - link [ref=f3e80] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e81]: Inventory Raw(Mobility & IT)
            - link [ref=f3e82] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e83]: Shipment Change Request(Packer)
            - link [ref=f3e84] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f3e86] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f3e87]: Shipment Request SEMI
      - main [ref=f3e88]:
        - generic [ref=f3e90]:
          - generic [ref=f3e91]:
            - generic [ref=f3e92]:
              - button "Home" [ref=f3e93] [cursor=pointer]
              - button "Shipment Plan(Electrode)" [ref=f3e95] [cursor=pointer]
            - generic [ref=f3e100]:
              - button "Scroll tabs left" [disabled] [ref=f3e101]
              - button "Scroll tabs right" [disabled] [ref=f3e104]
              - button "Close others" [ref=f3e107] [cursor=pointer]
              - button "Close All" [ref=f3e108] [cursor=pointer]
          - generic [ref=f3e109]:
            - generic [ref=f3e112]:
              - generic [ref=f3e114]:
                - generic [ref=f3e115]:
                  - img [aria-hidden] [ref=f3e117] [cursor=pointer]
                  - paragraph [ref=f3e120]: Shipment Plan(Electrode)
                - generic [ref=f3e121]:
                  - generic [ref=f3e122]: Shipping
                  - generic [ref=f3e127]: Shipping Schedule
                  - generic [ref=f3e132]: Shipment Plan(Electrode)
                - generic [ref=f3e134]:
                  - generic [ref=f3e135]: Search Area
                  - switch [checked] [active] [ref=f3e138] [cursor=pointer]
                - button "Full screen" [ref=f3e141] [cursor=pointer]
              - generic [ref=f3e151]:
                - generic [ref=f3e152]:
                  - generic [ref=f3e154]:
                    - generic [ref=f3e155]: Div
                    - generic [ref=f3e165]:
                      - combobox [ref=f3e166]: 40 Mobility & IT Battery
                      - button "Open" [ref=f3e168] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e173]:
                    - generic [ref=f3e174]: Company
                    - generic [ref=f3e184]:
                      - combobox [ref=f3e185]: ESOC
                      - button "Open" [ref=f3e187] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e192]:
                    - generic [ref=f3e193]: From Site
                    - generic [ref=f3e201] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e202]
                      - button "Open" [ref=f3e204]
                      - group [aria-hidden]
                  - generic [ref=f3e209]:
                    - generic [ref=f3e210]: Bucket
                    - generic [ref=f3e218]:
                      - combobox [ref=f3e219]: Daily
                      - button "Open" [ref=f3e221] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e226]:
                    - generic [ref=f3e227]: Plan Date
                    - generic [ref=f3e237]:
                      - combobox [ref=f3e238]: 2026-10-10
                      - button "Open" [ref=f3e240] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e245]:
                    - generic [ref=f3e246]: Period
                    - generic [ref=f3e253]:
                      - textbox "YYYY.MM.DD" [disabled] [ref=f3e266]: 2026.09.28
                      - generic [ref=f3e267]: ~
                      - textbox "YYYY.MM.DD" [disabled] [ref=f3e280]: 2026.12.04
                  - generic [ref=f3e282]:
                    - generic [ref=f3e283]: Material
                    - generic [ref=f3e289]:
                      - textbox [ref=f3e290]
                      - button [ref=f3e291] [cursor=pointer]
                  - generic [ref=f3e297]:
                    - generic [ref=f3e298]: Model/Nickname
                    - generic [ref=f3e304]:
                      - textbox [ref=f3e305]
                      - button [ref=f3e306] [cursor=pointer]
                  - generic [ref=f3e312]:
                    - generic [ref=f3e313]: UOM Type
                    - generic [ref=f3e318]:
                      - generic [ref=f3e319] [cursor=pointer]:
                        - radio "UOM" [checked] [ref=f3e320]
                        - generic [ref=f3e321]: UOM
                      - generic [ref=f3e322] [cursor=pointer]:
                        - radio "Cell" [ref=f3e323]
                        - generic [ref=f3e324]: Cell
                      - generic [ref=f3e325] [cursor=pointer]:
                        - radio "Pancake m" [ref=f3e326]
                        - generic [ref=f3e327]: Pancake m
                - generic [ref=f3e328]:
                  - button [ref=f3e329] [cursor=pointer]
                  - button [ref=f3e334] [cursor=pointer]
              - generic [ref=f3e339]:
                - generic:
                  - paragraph
                - generic [ref=f3e340]:
                  - generic "Measure" [ref=f3e341]:
                    - button "Measure" [ref=f3e342] [cursor=pointer]
                  - generic "Simulation" [ref=f3e346]:
                    - button "Simulation" [ref=f3e347] [cursor=pointer]
                  - generic "Excel Form" [ref=f3e348]:
                    - button [ref=f3e349] [cursor=pointer]
                  - generic "Excel Upload" [ref=f3e357]:
                    - button [ref=f3e358] [cursor=pointer]
                  - generic "Insert Row" [ref=f3e369]:
                    - button [ref=f3e370] [cursor=pointer]
                  - generic "Remove" [ref=f3e375]:
                    - button [ref=f3e376] [cursor=pointer]
                  - generic "Save" [ref=f3e383]:
                    - button [ref=f3e384] [cursor=pointer]
                  - generic "Sort" [ref=f3e388]:
                    - button [ref=f3e389] [cursor=pointer]
                  - generic "Filter" [ref=f3e394]:
                    - button [ref=f3e395] [cursor=pointer]
                  - generic "Condition" [ref=f3e400]:
                    - button [ref=f3e401] [cursor=pointer]
                  - generic "Reset Condition" [ref=f3e411]:
                    - button [ref=f3e412] [cursor=pointer]
                  - generic "Excel" [ref=f3e419]:
                    - button [ref=f3e420] [cursor=pointer]
              - generic [ref=f3e429]:
                - generic [ref=f3e433]:
                  - grid [ref=f3e434]:
                    - rowgroup [ref=f3e435]:
                      - generic:
                        - row "Div Model Nick Name From Site Material Oper. L/T Elec Type BOH PSI Measure No":
                          - columnheader "Div" [ref=f3e436]
                          - columnheader "Model" [ref=f3e437]
                          - columnheader "Nick Name" [ref=f3e438]
                          - columnheader "From Site" [ref=f3e439]
                          - columnheader "Material" [ref=f3e440]
                          - columnheader "Oper. L/T" [ref=f3e441]
                          - columnheader "Elec Type" [ref=f3e442]
                          - columnheader "BOH" [ref=f3e443]
                          - columnheader "PSI" [ref=f3e444]
                          - columnheader "Measure" [ref=f3e445]
                          - gridcell "No" [ref=f3e446]
                          - gridcell [ref=f3e447]
                    - rowgroup [ref=f3e448]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f3e450]
                    - generic [ref=f3e452]:
                      - generic:
                        - row "No"
                  - generic [ref=f3e453]:
                    - status
                    - generic [ref=f3e454]: "0"
                - separator [ref=f3e455]
                - generic [ref=f3e458]:
                  - generic [ref=f3e459]:
                    - generic [ref=f3e460]:
                      - generic [ref=f3e463]:
                        - generic [ref=f3e464]: Shipment Date
                        - generic [ref=f3e471]:
                          - generic [ref=f3e474]:
                            - img [aria-hidden] [ref=f3e476] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f3e484]: 2026.10.10
                          - generic [ref=f3e485]: ~
                          - generic [ref=f3e488]:
                            - img [aria-hidden] [ref=f3e490] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f3e498]: 2026.12.04
                      - generic [ref=f3e500]:
                        - generic [ref=f3e501]: Material
                        - generic [ref=f3e507]:
                          - textbox [ref=f3e508]
                          - button [ref=f3e509] [cursor=pointer]
                      - generic [ref=f3e515]:
                        - generic [ref=f3e516]: Model/Nickname
                        - generic [ref=f3e522]:
                          - textbox [ref=f3e523]
                          - button [ref=f3e524] [cursor=pointer]
                      - generic [ref=f3e530]:
                        - generic [ref=f3e531]: Requestor
                        - generic [ref=f3e537]:
                          - textbox [ref=f3e538]
                          - button [ref=f3e539] [cursor=pointer]
                    - button "Search" [ref=f3e545] [cursor=pointer]
                  - generic [ref=f3e546]:
                    - generic [ref=f3e547]:
                      - button "Shipment Plan Detail" [ref=f3e548]
                      - button "Stock Detail" [ref=f3e550]
                      - button "Shipment Result" [ref=f3e552]
                    - generic [ref=f3e557]:
                      - grid [ref=f3e558]:
                        - rowgroup [ref=f3e559]:
                          - generic:
                            - row "Div PO No Confirm/Plan ID Status Model Material Nick Name To Site DOM/EXP. Day Shipment Date Shipping Plan Qty Confirm Qty Gap Confirm Qty (Cut) Package Type No":
                              - columnheader "Div" [ref=f3e560]
                              - columnheader "PO No" [ref=f3e561]
                              - columnheader "Confirm/Plan ID" [ref=f3e562]
                              - columnheader "Status" [ref=f3e563]
                              - columnheader "Model" [ref=f3e564]
                              - columnheader "Material" [ref=f3e565]
                              - columnheader "Nick Name" [ref=f3e566]
                              - columnheader "To Site" [ref=f3e567]
                              - columnheader "DOM/EXP." [ref=f3e568]
                              - columnheader "Day" [ref=f3e569]
                              - columnheader "Shipment Date" [ref=f3e570]
                              - columnheader "Shipping Plan Qty" [ref=f3e571]
                              - columnheader "Confirm Qty" [ref=f3e572]
                              - columnheader "Gap" [ref=f3e573]
                              - columnheader "Confirm Qty (Cut)" [ref=f3e574]
                              - columnheader "Package Type" [ref=f3e575]
                              - gridcell "No" [ref=f3e576]
                              - gridcell [ref=f3e577]
                        - rowgroup [ref=f3e578]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f3e580]
                        - generic [ref=f3e582]:
                          - generic:
                            - row "No"
                      - generic [ref=f3e583]:
                        - status
                        - generic [ref=f3e584]: "0"
                      - generic:
                        - generic [ref=f3e587]:
                          - combobox "InputDate Input" [ref=f3e588]: 2026-11-14
                          - button "Choose Date" [ref=f3e590] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f3e595]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e599]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e603]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e607]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e611]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e615]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e619]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e623]: "0.000"
                        - generic [ref=f3e626]:
                          - combobox "InputDate Input" [ref=f3e627]: 2026-11-14
                          - button "Choose Date" [ref=f3e629] [cursor=pointer]
                        - generic [ref=f3e633]:
                          - combobox "InputDate Input" [ref=f3e634]: 2026-11-14
                          - button "Choose Date" [ref=f3e636] [cursor=pointer]
                        - generic [ref=f3e640]:
                          - combobox "InputDateTime Input" [ref=f3e641]: 2026-11-14 23:49:14
                          - generic [ref=f3e642]:
                            - button "Toggle Calendar" [ref=f3e643] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e645] [cursor=pointer]
                        - generic [ref=f3e649]:
                          - combobox "InputDate Input" [ref=f3e650]: 2026-11-14
                          - button "Choose Date" [ref=f3e652] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f3e657]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e661]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e665]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e669]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e673]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e677]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e681]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f3e685]: "0.000"
                        - generic [ref=f3e688]:
                          - combobox "InputDate Input" [ref=f3e689]: 2026-11-14
                          - button "Choose Date" [ref=f3e691] [cursor=pointer]
                        - generic [ref=f3e695]:
                          - combobox "InputDate Input" [ref=f3e696]: 2026-11-14
                          - button "Choose Date" [ref=f3e698] [cursor=pointer]
                        - generic [ref=f3e702]:
                          - combobox "InputDateTime Input" [ref=f3e703]: 2026-11-14 23:49:14
                          - generic [ref=f3e704]:
                            - button "Toggle Calendar" [ref=f3e705] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e707] [cursor=pointer]
            - alert [ref=f3e709]:
              - generic [ref=f3e710] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f3e713] [cursor=pointer]:
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
      |                                                                                                                         ^ Error: 공통 기능 FAIL 1: Search Area 조회영역 토글
  122 |   });
  123 | });
  124 | 
```