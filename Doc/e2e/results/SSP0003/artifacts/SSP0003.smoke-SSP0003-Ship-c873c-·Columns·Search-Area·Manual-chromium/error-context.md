# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0003.smoke.spec.ts >> SSP0003 ShipmentChangeRequestConfirm 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SSP0003.smoke.spec.ts:115:7

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
        - /url: /view/SSP0003
        - generic [ref=f3e6]: SCM
        - generic [ref=f3e7]:
          - generic [ref=f3e8]: 공급망관리시스템
          - generic [ref=f3e9]: Supply Chain Management system
      - navigation [ref=f3e10]:
        - link "Demand" [ref=f3e11] [cursor=pointer]:
          - /url: /view/SSP0003
        - link "Supply" [ref=f3e12] [cursor=pointer]:
          - /url: /view/SSP0003
        - link "Shipping" [ref=f3e13] [cursor=pointer]:
          - /url: /view/SSP0003
        - link "Report" [ref=f3e14] [cursor=pointer]:
          - /url: /view/SSP0003
        - link "Authority" [ref=f3e15] [cursor=pointer]:
          - /url: /view/SSP0003
        - link "Admin" [ref=f3e16] [cursor=pointer]:
          - /url: /view/SSP0003
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
              - /url: /view/SSP0003
              - paragraph [ref=f3e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0003
              - paragraph [ref=f3e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0003
              - paragraph [ref=f3e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0003
              - paragraph [ref=f3e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0003
              - paragraph [ref=f3e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0003
              - paragraph [ref=f3e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0003
              - paragraph [ref=f3e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0003
              - paragraph [ref=f3e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0003
              - paragraph [ref=f3e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f3e53]:
            - link [ref=f3e54] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e55]: Shipping Schedule
            - link [ref=f3e58] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e59]: Shipment Request
            - link [ref=f3e60] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e61]: Shipment Plan(Mobility & IT)
            - link [ref=f3e62] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e63]: Shipment Plan(Electrode)
            - link [ref=f3e64] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f3e66] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e67]: Shipment Plan Detail
            - link [ref=f3e68] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e69]: Shipment Change History
            - link [ref=f3e70] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e71]: Shipment Plan(Auto & ESS)
            - link [ref=f3e72] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e73]: Shipment Request(Mobility & IT)
            - link [ref=f3e74] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e75]: Shipment Request(Electrode)
            - link [ref=f3e76] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e77]: Shipment Change Request
            - link [ref=f3e78] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e79]: Shipment Change Request Confirm
            - link [ref=f3e80] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e81]: Inventory Raw(Mobility & IT)
            - link [ref=f3e82] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e83]: Shipment Change Request(Packer)
            - link [ref=f3e84] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f3e86] [cursor=pointer]:
              - /url: /view/SSP0003
              - paragraph [ref=f3e87]: Shipment Request SEMI
      - main [ref=f3e88]:
        - generic [ref=f3e90]:
          - generic [ref=f3e91]:
            - generic [ref=f3e92]:
              - button "Home" [ref=f3e93] [cursor=pointer]
              - button "Shipment Change Request Confirm" [ref=f3e95] [cursor=pointer]
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
                  - paragraph [ref=f3e120]: Shipment Change Request Confirm
                - generic [ref=f3e121]:
                  - generic [ref=f3e122]: Shipping
                  - generic [ref=f3e127]: Shipping Schedule
                  - generic [ref=f3e132]: Shipment Change Request Confirm
                - generic [ref=f3e134]:
                  - generic [ref=f3e135]: Search Area
                  - switch [checked] [active] [ref=f3e138] [cursor=pointer]
                - button "Full screen" [ref=f3e141] [cursor=pointer]
              - generic [ref=f3e151]:
                - generic [ref=f3e152]:
                  - generic [ref=f3e154]:
                    - generic [ref=f3e155]: Div
                    - generic [ref=f3e163] [cursor=pointer]:
                      - generic "40 Mobility & IT Battery" [ref=f3e164]:
                        - paragraph [ref=f3e168]: 40 Mobility & IT Battery
                      - combobox [ref=f3e173]
                      - button "Open" [ref=f3e175]
                      - group [aria-hidden]
                  - generic [ref=f3e180]:
                    - generic [ref=f3e181]: From Site
                    - generic [ref=f3e189] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e190]
                      - button "Open" [ref=f3e192]
                      - group [aria-hidden]
                  - generic [ref=f3e197]:
                    - generic [ref=f3e198]: Status
                    - generic [ref=f3e206]:
                      - combobox [ref=f3e207]: Drafting
                      - button "Open" [ref=f3e209] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e215]:
                    - generic [ref=f3e216]: Request Date
                    - generic [ref=f3e223]:
                      - generic [ref=f3e226]:
                        - img [aria-hidden] [ref=f3e228] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f3e236]: 2026.10.31
                      - generic [ref=f3e237]: ~
                      - generic [ref=f3e240]:
                        - img [aria-hidden] [ref=f3e242] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f3e250]: 2026.11.14
                  - generic [ref=f3e252]:
                    - generic [ref=f3e253]: Requestor
                    - generic [ref=f3e259]:
                      - textbox [ref=f3e260]
                      - button [ref=f3e261] [cursor=pointer]
                  - generic [ref=f3e267]:
                    - generic [ref=f3e268]: Model/Nickname
                    - generic [ref=f3e274]:
                      - textbox [ref=f3e275]
                      - button [ref=f3e276] [cursor=pointer]
                  - generic [ref=f3e282]:
                    - generic [ref=f3e283]: Change Type
                    - generic [ref=f3e291]:
                      - combobox [ref=f3e292]: ALL
                      - button "Open" [ref=f3e294] [cursor=pointer]
                      - group [aria-hidden]
                - button [ref=f3e299] [cursor=pointer]
              - generic [ref=f3e304]:
                - generic:
                  - paragraph
                - generic [ref=f3e305]:
                  - generic "Approval" [ref=f3e306]:
                    - button "Approval" [disabled]
                  - generic "Reject" [ref=f3e307]:
                    - button "Reject" [disabled]
                  - generic "Self Reject" [ref=f3e308]:
                    - button "Self Reject" [disabled]
                  - generic "Sort" [ref=f3e309]:
                    - button [ref=f3e310] [cursor=pointer]
                  - generic "Filter" [ref=f3e315]:
                    - button [ref=f3e316] [cursor=pointer]
                  - generic "Condition" [ref=f3e321]:
                    - button [ref=f3e322] [cursor=pointer]
                  - generic "Reset Condition" [ref=f3e332]:
                    - button [ref=f3e333] [cursor=pointer]
                  - generic "Excel" [ref=f3e340]:
                    - button [ref=f3e341] [cursor=pointer]
              - generic [ref=f3e350]:
                - generic [ref=f3e354]:
                  - grid [ref=f3e355]:
                    - rowgroup [ref=f3e356]:
                      - generic:
                        - row "Div From Site To Site Change Type Request No Status Model Nick Name Title Change Reason Requestor Requestor Dept Name Request Date Approval No":
                          - columnheader "Div" [ref=f3e357]
                          - columnheader "From Site" [ref=f3e358]
                          - columnheader "To Site" [ref=f3e359]
                          - columnheader "Change Type" [ref=f3e360]
                          - columnheader "Request No" [ref=f3e361]
                          - columnheader "Status" [ref=f3e362]
                          - columnheader "Model" [ref=f3e363]
                          - columnheader "Nick Name" [ref=f3e364]
                          - columnheader "Title" [ref=f3e365]
                          - columnheader "Change Reason" [ref=f3e366]
                          - columnheader "Requestor" [ref=f3e367]
                          - columnheader "Requestor Dept Name" [ref=f3e368]
                          - columnheader "Request Date" [ref=f3e369]
                          - columnheader "Approval" [ref=f3e370]
                          - gridcell "No" [ref=f3e371]
                    - rowgroup [ref=f3e372]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f3e374]
                    - generic [ref=f3e376]:
                      - generic:
                        - row "No"
                  - generic [ref=f3e377]:
                    - status
                    - generic [ref=f3e378]: "0"
                  - generic:
                    - generic [ref=f3e381]:
                      - combobox "InputDateTime Input" [ref=f3e382]: 2026-11-14 19:25:40
                      - generic [ref=f3e383]:
                        - button "Toggle Calendar" [ref=f3e384] [cursor=pointer]
                        - button "Toggle Time List" [ref=f3e386] [cursor=pointer]
                    - generic [ref=f3e390]:
                      - combobox "InputDateTime Input" [ref=f3e391]: 2026-11-14 19:25:40
                      - generic [ref=f3e392]:
                        - button "Toggle Calendar" [ref=f3e393] [cursor=pointer]
                        - button "Toggle Time List" [ref=f3e395] [cursor=pointer]
                    - generic [ref=f3e399]:
                      - combobox "InputDateTime Input" [ref=f3e400]: 2026-11-14 19:25:40
                      - generic [ref=f3e401]:
                        - button "Toggle Calendar" [ref=f3e402] [cursor=pointer]
                        - button "Toggle Time List" [ref=f3e404] [cursor=pointer]
                    - generic [ref=f3e408]:
                      - combobox "InputDateTime Input" [ref=f3e409]: 2026-11-14 19:25:40
                      - generic [ref=f3e410]:
                        - button "Toggle Calendar" [ref=f3e411] [cursor=pointer]
                        - button "Toggle Time List" [ref=f3e413] [cursor=pointer]
                - separator [ref=f3e415]
                - generic [ref=f3e418]:
                  - generic [ref=f3e420]:
                    - generic [ref=f3e421]: Request Confirm Detail
                    - generic [ref=f3e424]:
                      - generic [ref=f3e425]: Request No
                      - textbox [disabled] [ref=f3e432]
                    - generic [ref=f3e435]:
                      - generic [ref=f3e436]: Requestor
                      - textbox [disabled] [ref=f3e443]
                    - generic [ref=f3e445]:
                      - generic [ref=f3e446]: Dept Name
                      - textbox [disabled] [ref=f3e453]
                    - generic [ref=f3e456]:
                      - generic [ref=f3e457]: Approval
                      - textbox [disabled] [ref=f3e464]
                    - generic [ref=f3e466]:
                      - generic [ref=f3e467]: Dept Name
                      - textbox [disabled] [ref=f3e474]
                    - generic [ref=f3e477]:
                      - generic [ref=f3e478]: Title
                      - textbox [disabled] [ref=f3e485]
                    - generic [ref=f3e487]:
                      - generic [ref=f3e488]: Change Reason
                      - textbox [disabled] [ref=f3e495]
                    - generic [ref=f3e498]:
                      - generic [ref=f3e499]: Reason Detail
                      - textbox [disabled] [ref=f3e506]
                    - generic [ref=f3e509]:
                      - generic [ref=f3e510]: Reject Reason
                      - textbox [disabled] [ref=f3e517]
                  - generic [ref=f3e519]:
                    - grid [ref=f3e520]:
                      - rowgroup [ref=f3e521]:
                        - generic:
                          - row "SO No Project Name FCST Type Model From Site To Site Incoterms Confirmed Change Building Remarks Customer requirement No":
                            - columnheader [ref=f3e522]:
                              - checkbox [ref=f3e523]
                            - columnheader "SO No" [ref=f3e524]
                            - columnheader "Project Name" [ref=f3e525]
                            - columnheader "FCST Type" [ref=f3e526]
                            - columnheader "Model" [ref=f3e527]
                            - columnheader "From Site" [ref=f3e528]
                            - columnheader "To Site" [ref=f3e529]
                            - columnheader "Incoterms" [ref=f3e530]
                            - columnheader "Confirmed" [ref=f3e531]
                            - columnheader "Change" [ref=f3e532]
                            - columnheader "Building" [ref=f3e533]
                            - columnheader "Remarks" [ref=f3e534]
                            - columnheader "Customer requirement" [ref=f3e535]
                            - gridcell "No" [ref=f3e536]
                          - row "L/T(Day) ETD ETA Trans Mode Shipment Date Qty L/T(Day) ETD ETA Trans Mode Shipment Date Qty":
                            - columnheader "L/T(Day)" [ref=f3e537]
                            - columnheader "ETD" [ref=f3e538]
                            - columnheader "ETA" [ref=f3e539]
                            - columnheader "Trans Mode" [ref=f3e540]
                            - columnheader "Shipment Date" [ref=f3e541]
                            - columnheader "Qty" [ref=f3e542]
                            - columnheader "L/T(Day)" [ref=f3e543]
                            - columnheader "ETD" [ref=f3e544]
                            - columnheader "ETA" [ref=f3e545]
                            - columnheader "Trans Mode" [ref=f3e546]
                            - columnheader "Shipment Date" [ref=f3e547]
                            - columnheader "Qty" [ref=f3e548]
                      - rowgroup [ref=f3e549]:
                        - row "Focus helper":
                          - gridcell "Focus helper" [ref=f3e551]
                      - generic [ref=f3e553]:
                        - generic:
                          - row "No"
                    - generic [ref=f3e554]:
                      - status
                      - generic [ref=f3e555]: "0"
                    - generic:
                      - generic [ref=f3e558]:
                        - combobox "InputDate Input" [ref=f3e559]: 2026-11-14
                        - button "Choose Date" [ref=f3e561] [cursor=pointer]
                      - generic [ref=f3e565]:
                        - combobox "InputDate Input" [ref=f3e566]: 2026-11-14
                        - button "Choose Date" [ref=f3e568] [cursor=pointer]
                      - generic [ref=f3e572]:
                        - combobox "InputDate Input" [ref=f3e573]: 2026-11-14
                        - button "Choose Date" [ref=f3e575] [cursor=pointer]
                      - spinbutton "InputNumber Input" [ref=f3e580]: "0.000"
                      - generic [ref=f3e583]:
                        - combobox "InputDate Input" [ref=f3e584]: 2026-11-14
                        - button "Choose Date" [ref=f3e586] [cursor=pointer]
                      - generic [ref=f3e590]:
                        - combobox "InputDate Input" [ref=f3e591]: 2026-11-14
                        - button "Choose Date" [ref=f3e593] [cursor=pointer]
                      - generic [ref=f3e597]:
                        - combobox "InputDate Input" [ref=f3e598]: 2026-11-14
                        - button "Choose Date" [ref=f3e600] [cursor=pointer]
                      - spinbutton "InputNumber Input" [ref=f3e605]: "0.000"
                      - generic [ref=f3e608]:
                        - combobox "InputDate Input" [ref=f3e609]: 2026-11-14
                        - button "Choose Date" [ref=f3e611] [cursor=pointer]
                      - generic [ref=f3e615]:
                        - combobox "InputDate Input" [ref=f3e616]: 2026-11-14
                        - button "Choose Date" [ref=f3e618] [cursor=pointer]
                      - generic [ref=f3e622]:
                        - combobox "InputDate Input" [ref=f3e623]: 2026-11-14
                        - button "Choose Date" [ref=f3e625] [cursor=pointer]
                      - spinbutton "InputNumber Input" [ref=f3e630]: "0.000"
                      - generic [ref=f3e633]:
                        - combobox "InputDate Input" [ref=f3e634]: 2026-11-14
                        - button "Choose Date" [ref=f3e636] [cursor=pointer]
                      - generic [ref=f3e640]:
                        - combobox "InputDate Input" [ref=f3e641]: 2026-11-14
                        - button "Choose Date" [ref=f3e643] [cursor=pointer]
                      - generic [ref=f3e647]:
                        - combobox "InputDate Input" [ref=f3e648]: 2026-11-14
                        - button "Choose Date" [ref=f3e650] [cursor=pointer]
                      - spinbutton "InputNumber Input" [ref=f3e655]: "0.000"
            - alert [ref=f3e656]:
              - generic [ref=f3e657] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f3e660] [cursor=pointer]:
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