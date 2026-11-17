# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0021.smoke.spec.ts >> SSP0021 ShipmentPlan 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SSP0021.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Show SQL' (Checkbox) — 후보 [Show SQL]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'item.UserName' (InputField) — 후보 [item.UserName]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Box ID' (InputField) — 후보 [Box ID]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]

expect(received).toBeTruthy()

Received: false
```

```
Error: 그리드 컬럼 누락 (메타 기준)

expect(received).toBeLessThanOrEqual(expected)

Expected: <= 2
Received:    6
```

```
Error: As-is 병합 헤더 리터럴 노출 [SUM]

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 1
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SSP0021
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SSP0021
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SSP0021
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SSP0021
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SSP0021
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SSP0021
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SSP0021
      - generic [ref=f2e17]:
        - button "KOR" [ref=f2e19] [cursor=pointer]
        - button "이 이민용" [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 이
          - generic [ref=f2e29]: 이민용
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Shipping
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0021
              - paragraph [ref=f2e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0021
              - paragraph [ref=f2e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0021
              - paragraph [ref=f2e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0021
              - paragraph [ref=f2e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0021
              - paragraph [ref=f2e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0021
              - paragraph [ref=f2e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0021
              - paragraph [ref=f2e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0021
              - paragraph [ref=f2e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f2e53]:
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e55]: Shipping Schedule
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e59]: Shipment Request
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e61]: Shipment Plan(Mobility & IT)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e63]: Shipment Plan(Electrode)
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e67]: Shipment Plan Detail
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e69]: Shipment Change History
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e71]: Shipment Plan(Auto & ESS)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e73]: Shipment Request(Mobility & IT)
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e75]: Shipment Request(Electrode)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e77]: Shipment Change Request
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e79]: Shipment Change Request Confirm
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e81]: Inventory Raw(Mobility & IT)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e83]: Shipment Change Request(Packer)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SSP0021
              - paragraph [ref=f2e87]: Shipment Request SEMI
      - main [ref=f2e88]:
        - generic [ref=f2e90]:
          - generic [ref=f2e91]:
            - generic [ref=f2e92]:
              - button "Home" [ref=f2e93] [cursor=pointer]
              - button "Shipment Plan(Auto & ESS)" [ref=f2e95] [cursor=pointer]
            - generic [ref=f2e100]:
              - button "Scroll tabs left" [disabled] [ref=f2e101]
              - button "Scroll tabs right" [disabled] [ref=f2e104]
              - button "Close others" [ref=f2e107] [cursor=pointer]
              - button "Close All" [ref=f2e108] [cursor=pointer]
          - generic [ref=f2e109]:
            - generic [ref=f2e112]:
              - generic [ref=f2e114]:
                - generic [ref=f2e115]:
                  - img [aria-hidden] [ref=f2e117] [cursor=pointer]
                  - paragraph [ref=f2e120]: Shipment Plan(Auto & ESS)
                - generic [ref=f2e121]:
                  - generic [ref=f2e122]: Shipping
                  - generic [ref=f2e127]: Shipping Schedule
                  - generic [ref=f2e132]: Shipment Plan(Auto & ESS)
                - generic [ref=f2e134]:
                  - generic [ref=f2e135]: Search Area
                  - switch [checked] [ref=f2e138] [cursor=pointer]
                - button "Full screen" [ref=f2e141] [cursor=pointer]
              - generic [ref=f2e150]:
                - generic [ref=f2e151]:
                  - generic [ref=f2e152]:
                    - generic [ref=f2e154]:
                      - generic [ref=f2e155]: Div*
                      - generic [ref=f2e163]:
                        - combobox [ref=f2e164]: 81 Automotive Battery
                        - button "Open" [ref=f2e166] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e171]:
                      - generic [ref=f2e172]: Company*
                      - generic [ref=f2e180]:
                        - combobox [ref=f2e181]: ESOC
                        - button "Open" [ref=f2e183] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e188]:
                      - generic [ref=f2e189]: From Site
                      - generic [ref=f2e197] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e198]
                        - button "Open" [ref=f2e200]
                        - group [aria-hidden]
                    - generic [ref=f2e205]:
                      - generic [ref=f2e206]: Bucket
                      - generic [ref=f2e214]:
                        - combobox [ref=f2e215]: Daily
                        - button "Open" [ref=f2e217] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e222]:
                      - generic [ref=f2e223]: Plan Date*
                      - generic [ref=f2e231]:
                        - combobox [ref=f2e232]: 2026-09-19
                        - button "Open" [ref=f2e234] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e239]:
                      - generic [ref=f2e240]: Period
                      - generic [ref=f2e247]:
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e260]: 2026.09.19
                        - generic [ref=f2e261]: ~
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e274]: 2026.11.13
                    - generic [ref=f2e276]:
                      - generic [ref=f2e277]: Model/Nickname
                      - generic [ref=f2e283]:
                        - textbox [ref=f2e284]
                        - button [ref=f2e285] [cursor=pointer]
                  - generic [ref=f2e290]:
                    - button [active] [ref=f2e291] [cursor=pointer]
                    - button [ref=f2e296] [cursor=pointer]
                - generic [ref=f2e301]:
                  - separator [ref=f2e302]
                  - generic [ref=f2e310] [cursor=pointer]:
                    - checkbox "Sum" [ref=f2e312]
                    - generic [ref=f2e313]: Sum
              - generic [ref=f2e314]:
                - generic:
                  - paragraph
                - generic [ref=f2e315]:
                  - generic "Measure" [ref=f2e316]:
                    - button "Measure" [ref=f2e317] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e321]:
                    - button [ref=f2e322] [cursor=pointer]
                  - generic "Remove" [ref=f2e327]:
                    - button [ref=f2e328] [cursor=pointer]
                  - generic "Save" [ref=f2e335]:
                    - button [ref=f2e336] [cursor=pointer]
                  - generic "Sort" [ref=f2e340]:
                    - button [ref=f2e341] [cursor=pointer]
                  - generic "Filter" [ref=f2e346]:
                    - button [ref=f2e347] [cursor=pointer]
                  - generic "Condition" [ref=f2e352]:
                    - button [ref=f2e353] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e363]:
                    - button [ref=f2e364] [cursor=pointer]
                  - generic "Excel" [ref=f2e371]:
                    - button [ref=f2e372] [cursor=pointer]
              - generic [ref=f2e380]:
                - generic [ref=f2e384]:
                  - grid [ref=f2e385]:
                    - rowgroup [ref=f2e386]:
                      - generic:
                        - row "Div From Site Model Nick Name BOH PSI Measure 2026-09 No":
                          - columnheader "Div" [ref=f2e387]
                          - columnheader "From Site" [ref=f2e388]
                          - columnheader "Model" [ref=f2e389]
                          - columnheader "Nick Name" [ref=f2e390]
                          - columnheader "BOH" [ref=f2e391]
                          - columnheader "PSI" [ref=f2e392]
                          - columnheader "Measure" [ref=f2e393]
                          - columnheader "2026-09" [ref=f2e394]
                          - gridcell "No" [ref=f2e395]
                        - row "W38 W39 W40":
                          - columnheader "W38" [ref=f2e396]
                          - columnheader "W39" [ref=f2e397]
                          - columnheader "W40" [ref=f2e398]
                        - row "19 20 21 22 23 24 25 26 27 28 29 30":
                          - columnheader "19" [ref=f2e399]
                          - columnheader "20" [ref=f2e400]
                          - columnheader "21" [ref=f2e401]
                          - columnheader "22" [ref=f2e402]
                          - columnheader "23" [ref=f2e403]
                          - columnheader "24" [ref=f2e404]
                          - columnheader "25" [ref=f2e405]
                          - columnheader "26" [ref=f2e406]
                          - columnheader "27" [ref=f2e407]
                          - columnheader "28" [ref=f2e408]
                          - columnheader "29" [ref=f2e409]
                          - columnheader "30" [ref=f2e410]
                    - rowgroup [ref=f2e411]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e413]
                    - generic [ref=f2e415]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e416]:
                    - status
                    - generic [ref=f2e417]: "0"
                - separator [ref=f2e418]
                - generic [ref=f2e421]:
                  - generic [ref=f2e422]:
                    - generic [ref=f2e423]:
                      - generic [ref=f2e425]:
                        - generic [ref=f2e426]: Shipment Date
                        - generic [ref=f2e433]:
                          - generic [ref=f2e436]:
                            - img [aria-hidden] [ref=f2e438] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e446]: 2026.09.19
                          - generic [ref=f2e447]: ~
                          - generic [ref=f2e450]:
                            - img [aria-hidden] [ref=f2e452] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e460]: 2026.11.13
                      - generic [ref=f2e462]:
                        - generic [ref=f2e463]: Model/Nickname
                        - generic [ref=f2e469]:
                          - textbox [ref=f2e470]: FMC-HEVC
                          - button [ref=f2e471] [cursor=pointer]
                      - generic [ref=f2e477]:
                        - generic [ref=f2e478]: Requestor
                        - generic [ref=f2e484]:
                          - textbox [ref=f2e485]
                          - button [ref=f2e486] [cursor=pointer]
                    - button "Search" [ref=f2e492] [cursor=pointer]
                  - generic [ref=f2e493]:
                    - generic [ref=f2e494]:
                      - button "Shipment Plan Detail" [ref=f2e495]
                      - button "Stock Location Detail" [ref=f2e497]
                      - button "oWMS Detail" [ref=f2e499]
                      - button "MES Stock" [ref=f2e501]
                      - button "MES Stock Detail" [ref=f2e503]
                      - button "Shipment Result" [ref=f2e505]
                    - generic [ref=f2e510]:
                      - grid [ref=f2e511]:
                        - rowgroup [ref=f2e512]:
                          - generic:
                            - row "Div Status SO No Confirm/Plan ID Model Nick Name From Site To Site Project Code Project Name End Customer MKT Owner Team Shipment Requestor Shipment Qty No":
                              - columnheader "Div" [ref=f2e513]
                              - columnheader "Status" [ref=f2e514]
                              - columnheader "SO No" [ref=f2e515]
                              - columnheader "Confirm/Plan ID" [ref=f2e516]
                              - columnheader "Model" [ref=f2e517]
                              - columnheader "Nick Name" [ref=f2e518]
                              - columnheader "From Site" [ref=f2e519]
                              - columnheader "To Site" [ref=f2e520]
                              - columnheader "Project Code" [ref=f2e521]
                              - columnheader "Project Name" [ref=f2e522]
                              - columnheader "End Customer" [ref=f2e523]
                              - columnheader "MKT Owner" [ref=f2e524]
                              - columnheader "Team" [ref=f2e525]
                              - columnheader "Shipment Requestor" [ref=f2e526]
                              - columnheader "Shipment Qty" [ref=f2e527]
                              - gridcell "No" [ref=f2e528]
                              - gridcell [ref=f2e529]
                        - rowgroup [ref=f2e530]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f2e532]
                        - generic [ref=f2e534]:
                          - generic:
                            - row "0 Sum":
                              - gridcell [ref=f2e535]
                              - gridcell [ref=f2e536]
                              - gridcell [ref=f2e537]
                              - gridcell [ref=f2e538]
                              - gridcell [ref=f2e539]
                              - gridcell [ref=f2e540]
                              - gridcell [ref=f2e541]
                              - gridcell [ref=f2e542]
                              - gridcell [ref=f2e543]
                              - gridcell [ref=f2e544]
                              - gridcell [ref=f2e545]
                              - gridcell [ref=f2e546]
                              - gridcell [ref=f2e547]
                              - gridcell [ref=f2e548]
                              - gridcell "0" [ref=f2e549]
                              - gridcell [ref=f2e550]
                              - gridcell [ref=f2e551]
                              - gridcell [ref=f2e552]
                              - gridcell [ref=f2e553]
                              - gridcell [ref=f2e554]
                              - gridcell [ref=f2e555]
                              - gridcell [ref=f2e556]
                              - gridcell [ref=f2e557]
                              - gridcell [ref=f2e558]
                              - gridcell [ref=f2e559]
                              - gridcell [ref=f2e560]
                              - gridcell [ref=f2e561]
                              - gridcell [ref=f2e562]
                              - gridcell [ref=f2e563]
                              - gridcell [ref=f2e564]
                              - gridcell [ref=f2e565]
                              - gridcell [ref=f2e566]
                              - gridcell [ref=f2e567]
                              - gridcell [ref=f2e568]
                              - gridcell [ref=f2e569]
                              - gridcell [ref=f2e570]
                              - gridcell [ref=f2e571]
                              - gridcell [ref=f2e572]
                              - gridcell [ref=f2e573]
                              - gridcell [ref=f2e574]
                              - gridcell [ref=f2e575]
                              - gridcell "Sum" [ref=f2e576]
                              - gridcell [ref=f2e577]
                        - generic [ref=f2e578]:
                          - generic:
                            - row "Sum 0"
                        - generic [ref=f2e579]:
                          - generic:
                            - row "No"
                      - generic [ref=f2e580]:
                        - status
                        - generic [ref=f2e581]: "0"
                      - generic:
                        - generic [ref=f2e584]:
                          - combobox "InputDate Input" [ref=f2e585]: 2026-11-14
                          - button "Choose Date" [ref=f2e587] [cursor=pointer]
                        - generic [ref=f2e591]:
                          - combobox "InputDate Input" [ref=f2e592]: 2026-11-14
                          - button "Choose Date" [ref=f2e594] [cursor=pointer]
                        - generic [ref=f2e598]:
                          - combobox "InputDate Input" [ref=f2e599]: 2026-11-14
                          - button "Choose Date" [ref=f2e601] [cursor=pointer]
                        - generic [ref=f2e605]:
                          - combobox "InputDateTime Input" [ref=f2e606]: 2026-11-14 22:32:18
                          - generic [ref=f2e607]:
                            - button "Toggle Calendar" [ref=f2e608] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e610] [cursor=pointer]
                        - generic [ref=f2e614]:
                          - combobox "InputDate Input" [ref=f2e615]: 2026-11-14
                          - button "Choose Date" [ref=f2e617] [cursor=pointer]
                        - generic [ref=f2e621]:
                          - combobox "InputDate Input" [ref=f2e622]: 2026-11-14
                          - button "Choose Date" [ref=f2e624] [cursor=pointer]
                        - generic [ref=f2e628]:
                          - combobox "InputDate Input" [ref=f2e629]: 2026-11-14
                          - button "Choose Date" [ref=f2e631] [cursor=pointer]
                        - generic [ref=f2e635]:
                          - combobox "InputDate Input" [ref=f2e636]: 2026-11-14
                          - button "Choose Date" [ref=f2e638] [cursor=pointer]
                        - generic [ref=f2e642]:
                          - combobox "InputDateTime Input" [ref=f2e643]: 2026-11-14 22:32:18
                          - generic [ref=f2e644]:
                            - button "Toggle Calendar" [ref=f2e645] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e647] [cursor=pointer]
                        - generic [ref=f2e651]:
                          - combobox "InputDate Input" [ref=f2e652]: 2026-11-14
                          - button "Choose Date" [ref=f2e654] [cursor=pointer]
            - alert [ref=f2e656]:
              - generic [ref=f2e657] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e660] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-14) · 원천: Doc/gen/SSP0021/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0021.plan.json', 'utf8'));
  5   | const MENU = "SSP0021";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} ShipmentPlan 스모크 @smoke`, () => {
  10  |   test.use({ account: PLAN.sample.account || undefined });
  11  |   test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
  12  |     const r = await nscm.openScreen(MENU);
  13  |     expect(r.notFound, '404 아님').toBeFalsy();
  14  |     expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
  15  |     await nscm.snapshot(`${MENU}_open`);
  16  |     // 2026-10-21: 화면 열자마자 콘솔 치명 오류를 먼저 확인 — 그리드 생성이 Wijmo 단언으로 죽으면(SCP0100 "Unknown property inner") 뒤의 라벨/그리드 검사는 전부 부수 증상이다
  17  |     { await page.waitForTimeout(800); const errs0 = nscm.consoleErrors; const fatal0 = errs0.filter(e => /Assertion failed|Uncaught|is not a function|Cannot read propert|Unknown property/i.test(e));
  18  |       if (errs0.length) test.info().annotations.push({ type: 'console', description: `열림 직후 오류 ${errs0.length}(치명 ${fatal0.length}): ${[...fatal0, ...errs0.filter(e => !fatal0.includes(e))].slice(0, 3).join(' || ')}` });
  19  |       expect.soft(fatal0.length, `화면 열림 직후 브라우저 콘솔 치명 오류 0 — ${fatal0[0] || ''}`).toBe(0); }
  20  |     // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
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
> 74  |       expect.soft(missLit.length, `As-is 병합 헤더 리터럴 노출 [${(HS.literals || []).join(', ')}]`).toBe(0);
      |                                                                                             ^ Error: As-is 병합 헤더 리터럴 노출 [SUM]
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
  121 |     expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  122 |   });
  123 | });
  124 | 
```