# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SCP0127.smoke.spec.ts >> SCP0127 PrecedeSafetyStockDay 스모크 @smoke >> 조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인
- Location: ..\..\Doc\e2e\specs\SCP0127.smoke.spec.ts:106:7

# Error details

```
Error: 조회조건 동작 FAIL 1: (기준표 순서)

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 1
```

```
Error: 조회조건 판정 불가(ERROR) 1: Period

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
        - /url: /view/SCP0127
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SCP0127
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SCP0127
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SCP0127
        - link "Authority" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SCP0127
        - link "Admin" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SCP0127
      - generic [ref=f2e16]:
        - button "KOR" [ref=f2e18] [cursor=pointer]
        - button "이 이민용" [ref=f2e22] [cursor=pointer]:
          - paragraph [ref=f2e27]: 이
          - generic [ref=f2e28]: 이민용
    - generic [ref=f2e29]:
      - button [ref=f2e30] [cursor=pointer]
      - complementary [ref=f2e36]:
        - navigation [ref=f2e37]:
          - paragraph [ref=f2e38]: Supply
          - generic [ref=f2e39]:
            - link [ref=f2e40] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e41]: Supply Master
            - link "Line Master":
              - /url: /view/SCP0127
              - paragraph [ref=f2e44] [cursor=pointer]: Line Master
            - link "Project Route":
              - /url: /view/SCP0127
              - paragraph [ref=f2e45] [cursor=pointer]: Project Route
            - link "BOD":
              - /url: /view/SCP0127
              - paragraph [ref=f2e46] [cursor=pointer]: BOD
            - link "Plant Site":
              - /url: /view/SCP0127
              - paragraph [ref=f2e47] [cursor=pointer]: Plant Site
            - link "Production Plan":
              - /url: /view/SCP0127
              - paragraph [ref=f2e48] [cursor=pointer]: Production Plan
            - link "Work Calendar(OSP)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e49] [cursor=pointer]: Work Calendar(OSP)
            - link "Tact Time(OSP)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e50] [cursor=pointer]: Tact Time(OSP)
            - link "Formation":
              - /url: /view/SCP0127
              - paragraph [ref=f2e51] [cursor=pointer]: Formation
            - link "Outsourcing Capacity":
              - /url: /view/SCP0127
              - paragraph [ref=f2e52] [cursor=pointer]: Outsourcing Capacity
            - link "BOD ITEM":
              - /url: /view/SCP0127
              - paragraph [ref=f2e53] [cursor=pointer]: BOD ITEM
            - link "Master Validation":
              - /url: /view/SCP0127
              - paragraph [ref=f2e54] [cursor=pointer]: Master Validation
            - link "Stock OSP":
              - /url: /view/SCP0127
              - paragraph [ref=f2e55] [cursor=pointer]: Stock OSP
            - link "ProjectRoute(Electrode)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e56] [cursor=pointer]: ProjectRoute(Electrode)
            - link "ProjectRoute(Warranty)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e57] [cursor=pointer]: ProjectRoute(Warranty)
            - link "CAPA":
              - /url: /view/SCP0127
              - paragraph [ref=f2e58] [cursor=pointer]: CAPA
            - link "SCP BOM (Cell~Pack)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e59] [cursor=pointer]: SCP BOM (Cell~Pack)
            - link "Model Code Master":
              - /url: /view/SCP0127
              - paragraph [ref=f2e60] [cursor=pointer]: Model Code Master
            - link "MDM Class Master":
              - /url: /view/SCP0127
              - paragraph [ref=f2e61] [cursor=pointer]: MDM Class Master
            - link "Shipment Working Day(OSP)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e62] [cursor=pointer]: Shipment Working Day(OSP)
            - link "SCP BOM(Elec)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e63] [cursor=pointer]: SCP BOM(Elec)
            - link "CAPA (Mobility IT)":
              - /url: /view/SCP0127
              - paragraph [ref=f2e64] [cursor=pointer]: CAPA (Mobility IT)
            - link "Line Assign":
              - /url: /view/SCP0127
              - paragraph [ref=f2e65] [cursor=pointer]: Line Assign
            - link "Speed Plan":
              - /url: /view/SCP0127
              - paragraph [ref=f2e66] [cursor=pointer]: Speed Plan
            - link "Loss Plan":
              - /url: /view/SCP0127
              - paragraph [ref=f2e67] [cursor=pointer]: Loss Plan
            - link "TEEP Report":
              - /url: /view/SCP0127
              - paragraph [ref=f2e68] [cursor=pointer]: TEEP Report
            - link "LOB Report":
              - /url: /view/SCP0127
              - paragraph [ref=f2e69] [cursor=pointer]: LOB Report
            - link "Demand Group Master":
              - /url: /view/SCP0127
              - paragraph [ref=f2e70] [cursor=pointer]: Demand Group Master
            - link "CAPA LineMaster":
              - /url: /view/SCP0127
              - paragraph [ref=f2e71] [cursor=pointer]: CAPA LineMaster
            - link "Operation LT":
              - /url: /view/SCP0127
              - paragraph [ref=f2e72] [cursor=pointer]: Operation LT
          - generic [ref=f2e73]:
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e75]: Supply Plan
            - link "Plan Management":
              - /url: /view/SCP0127
              - paragraph [ref=f2e78] [cursor=pointer]: Plan Management
            - link "Shipment Plan FG":
              - /url: /view/SCP0127
              - paragraph [ref=f2e79] [cursor=pointer]: Shipment Plan FG
            - link "Shipment Plan SEMI":
              - /url: /view/SCP0127
              - paragraph [ref=f2e80] [cursor=pointer]: Shipment Plan SEMI
            - link "Production Plan Line":
              - /url: /view/SCP0127
              - paragraph [ref=f2e81] [cursor=pointer]: Production Plan Line
            - link "Production Plan Fix":
              - /url: /view/SCP0127
              - paragraph [ref=f2e82] [cursor=pointer]: Production Plan Fix
            - link "Shipment Plan Fix":
              - /url: /view/SCP0127
              - paragraph [ref=f2e83] [cursor=pointer]: Shipment Plan Fix
            - link "Global PSI":
              - /url: /view/SCP0127
              - paragraph [ref=f2e84] [cursor=pointer]: Global PSI
            - link "Global PSI Elec":
              - /url: /view/SCP0127
              - paragraph [ref=f2e85] [cursor=pointer]: Global PSI Elec
            - link "Global PSI New":
              - /url: /view/SCP0127
              - paragraph [ref=f2e86] [cursor=pointer]: Global PSI New
            - link "Integration PSI":
              - /url: /view/SCP0127
              - paragraph [ref=f2e87] [cursor=pointer]: Integration PSI
          - generic [ref=f2e88]:
            - link [ref=f2e89] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e90]: Waterfall
            - link "Shipment Plan FG Waterfall":
              - /url: /view/SCP0127
              - paragraph [ref=f2e93] [cursor=pointer]: Shipment Plan FG Waterfall
            - link "Production Plan Waterfall":
              - /url: /view/SCP0127
              - paragraph [ref=f2e94] [cursor=pointer]: Production Plan Waterfall
            - link "Shipment Plan Semi Waterfall":
              - /url: /view/SCP0127
              - paragraph [ref=f2e95] [cursor=pointer]: Shipment Plan Semi Waterfall
          - generic [ref=f2e96]:
            - link [ref=f2e97] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e98]: OPT Plan
            - link [ref=f2e101] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e102]: Plan Control
            - link [ref=f2e103] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e104]: OPT CAPA
            - link [ref=f2e105] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e106]: Workbench
            - link [ref=f2e107] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e108]: Constraint Mgmt
            - link [ref=f2e109] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e110]: Plan Group Master
            - link [ref=f2e111] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e112]: Plan Activity Mgmt
            - link [ref=f2e113] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e114]: Plan Group Dashboard
            - link [ref=f2e115] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e116]: Precede/Safety Stock Day
            - link [ref=f2e117] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e118]: Precede/Safety Stock Qty
            - link [ref=f2e119] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e120]: Demand Exception
            - link [ref=f2e121] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e122]: Scheduled Receipt Information
            - link [ref=f2e123] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e124]: Sales Site Priority
            - link [ref=f2e125] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e126]: Constraint Of Shipment Qty
            - link [ref=f2e127] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e128]: Warehouse Capacity
          - generic [ref=f2e129]:
            - link [ref=f2e130] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e131]: SCM Supply
            - link "Shipment(Allo) Report":
              - /url: /view/SCP0127
              - paragraph [ref=f2e134] [cursor=pointer]: Shipment(Allo) Report
            - link "Long-term stock":
              - /url: /view/SCP0127
              - paragraph [ref=f2e135] [cursor=pointer]: Long-term stock
            - link "Ending Inventory":
              - /url: /view/SCP0127
              - paragraph [ref=f2e136] [cursor=pointer]: Ending Inventory
            - link "Inventory Trend":
              - /url: /view/SCP0127
              - paragraph [ref=f2e137] [cursor=pointer]: Inventory Trend
          - generic [ref=f2e138]:
            - link [ref=f2e139] [cursor=pointer]:
              - /url: /view/SCP0127
              - paragraph [ref=f2e140]: Validation
            - link "Intransit Inventory":
              - /url: /view/SCP0127
              - paragraph [ref=f2e143] [cursor=pointer]: Intransit Inventory
      - main [ref=f2e144]:
        - generic [ref=f2e146]:
          - generic [ref=f2e147]:
            - generic [ref=f2e148]:
              - button "Home" [ref=f2e149] [cursor=pointer]
              - button "Precede/Safety Stock Day" [ref=f2e151] [cursor=pointer]
            - generic [ref=f2e156]:
              - button "Scroll tabs left" [disabled] [ref=f2e157]
              - button "Scroll tabs right" [disabled] [ref=f2e160]
              - button "Close others" [ref=f2e163] [cursor=pointer]
              - button "Close All" [ref=f2e164] [cursor=pointer]
          - generic [ref=f2e165]:
            - generic [ref=f2e168]:
              - generic [ref=f2e170]:
                - generic [ref=f2e171]:
                  - img [aria-hidden] [ref=f2e173] [cursor=pointer]
                  - paragraph [ref=f2e176]: Precede/Safety Stock Day
                - generic [ref=f2e177]:
                  - generic [ref=f2e178]: Supply
                  - generic [ref=f2e183]: OPT Plan
                  - generic [ref=f2e188]: Precede/Safety Stock Day
                - generic [ref=f2e190]:
                  - generic [ref=f2e191]: Search Area
                  - switch [checked] [ref=f2e194] [cursor=pointer]
                - button "Full screen" [ref=f2e197] [cursor=pointer]
              - generic [ref=f2e207]:
                - generic [ref=f2e208]:
                  - generic [ref=f2e210]:
                    - generic [ref=f2e211]: Div
                    - generic [ref=f2e219]:
                      - combobox [ref=f2e220]: 81 Automotive Battery
                      - button "Open" [ref=f2e222] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e227]:
                    - generic [ref=f2e228]: SCM Site
                    - generic [ref=f2e236] [cursor=pointer]:
                      - generic "AC00-A" [ref=f2e237]:
                        - paragraph [ref=f2e241]: AC00-A
                      - combobox [ref=f2e246]
                      - button "Open" [ref=f2e248]
                      - group [aria-hidden]
                  - generic [ref=f2e253]:
                    - generic [ref=f2e254]: Type
                    - generic [ref=f2e262]:
                      - combobox [ref=f2e263]: MIN
                      - button "Open" [ref=f2e265] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e270]:
                    - generic [ref=f2e271]: Stage
                    - generic [ref=f2e279]:
                      - combobox [ref=f2e280]: ASSY
                      - button "Open" [ref=f2e282] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e287]:
                    - generic [ref=f2e288]: Plan Group
                    - generic [ref=f2e296] [cursor=pointer]:
                      - generic "E129A_E128A" [ref=f2e297]:
                        - paragraph [ref=f2e301]: E129A_E128A
                      - combobox [ref=f2e306]
                      - button "Open" [ref=f2e308]
                      - group [aria-hidden]
                  - generic [ref=f2e313]:
                    - generic [ref=f2e314]: Model/Nickname
                    - generic [ref=f2e320]:
                      - textbox [ref=f2e321]: AAEF1001I-A1-000
                      - button [ref=f2e322] [cursor=pointer]
                  - generic [ref=f2e328]:
                    - generic [ref=f2e329]: Period
                    - generic [ref=f2e334]:
                      - generic [ref=f2e335] [cursor=pointer]:
                        - button "Open calendar" [ref=f2e336]
                        - textbox "YYYY.MM.DD" [ref=f2e345]: 2026.11.09
                      - generic [ref=f2e346]: ~
                      - generic [ref=f2e347] [cursor=pointer]:
                        - button "Open calendar" [ref=f2e348]
                        - textbox "YYYY.MM.DD" [ref=f2e357]: 2027.11.08
                  - generic [ref=f2e359]:
                    - generic [ref=f2e360]: Active
                    - generic [ref=f2e368]:
                      - combobox [ref=f2e369]: "Y"
                      - button "Open" [ref=f2e371] [cursor=pointer]
                      - group [aria-hidden]
                - button [active] [ref=f2e376] [cursor=pointer]
              - generic [ref=f2e381]:
                - generic:
                  - paragraph
                - generic [ref=f2e382]:
                  - generic "Insert Row" [ref=f2e383]:
                    - button [ref=f2e384] [cursor=pointer]
                  - generic "Remove" [ref=f2e389]:
                    - button [ref=f2e390] [cursor=pointer]
                  - generic "Save" [ref=f2e397]:
                    - button [ref=f2e398] [cursor=pointer]
                  - generic "Sort" [ref=f2e402]:
                    - button [ref=f2e403] [cursor=pointer]
                  - generic "Filter" [ref=f2e408]:
                    - button [ref=f2e409] [cursor=pointer]
                  - generic "Condition" [ref=f2e414]:
                    - button [ref=f2e415] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e425]:
                    - button [ref=f2e426] [cursor=pointer]
                  - generic "Excel" [ref=f2e433]:
                    - button [ref=f2e434] [cursor=pointer]
              - generic [ref=f2e442]:
                - grid [ref=f2e443]:
                  - rowgroup [ref=f2e444]:
                    - generic:
                      - row "Type Div Plan Group SCM site Model Stage Valid From Valid To Day Description Active Create By Creation Date Last Update By No":
                        - columnheader "Type" [ref=f2e445]
                        - columnheader "Div" [ref=f2e446]
                        - columnheader "Plan Group" [ref=f2e447]
                        - columnheader "SCM site" [ref=f2e448]
                        - columnheader "Model" [ref=f2e449]
                        - columnheader "Stage" [ref=f2e450]
                        - columnheader "Valid From" [ref=f2e451]
                        - columnheader "Valid To" [ref=f2e452]
                        - columnheader "Day" [ref=f2e453]
                        - columnheader "Description" [ref=f2e454]
                        - columnheader "Active" [ref=f2e455]
                        - columnheader "Create By" [ref=f2e456]
                        - columnheader "Creation Date" [ref=f2e457]
                        - columnheader "Last Update By" [ref=f2e458]
                        - gridcell "No" [ref=f2e459]
                        - gridcell [ref=f2e460]
                  - rowgroup [ref=f2e461]:
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f2e463]
                  - generic [ref=f2e465]:
                    - generic:
                      - row "No"
                - generic [ref=f2e466]:
                  - status
                  - generic [ref=f2e467]: "0"
                - generic:
                  - generic [ref=f2e470]:
                    - combobox "InputDate Input" [ref=f2e471]: 2026-11-08
                    - button "Choose Date" [ref=f2e473] [cursor=pointer]
                  - generic [ref=f2e477]:
                    - combobox "InputDate Input" [ref=f2e478]: 2026-11-08
                    - button "Choose Date" [ref=f2e480] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e485]: "0"
                  - generic [ref=f2e488]:
                    - combobox "InputDate Input" [ref=f2e489]: 2026-11-08
                    - button "Choose Date" [ref=f2e491] [cursor=pointer]
                  - generic [ref=f2e495]:
                    - combobox "InputDate Input" [ref=f2e496]: 2026-11-08
                    - button "Choose Date" [ref=f2e498] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e503]: "0"
                  - generic [ref=f2e506]:
                    - combobox "InputDate Input" [ref=f2e507]: 2026-11-08
                    - button "Choose Date" [ref=f2e509] [cursor=pointer]
                  - generic [ref=f2e513]:
                    - combobox "InputDate Input" [ref=f2e514]: 2026-11-08
                    - button "Choose Date" [ref=f2e516] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e521]: "0"
                  - generic [ref=f2e524]:
                    - combobox "InputDate Input" [ref=f2e525]: 2026-11-08
                    - button "Choose Date" [ref=f2e527] [cursor=pointer]
                  - generic [ref=f2e531]:
                    - combobox "InputDate Input" [ref=f2e532]: 2026-11-08
                    - button "Choose Date" [ref=f2e534] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e539]: "0"
                  - generic [ref=f2e542]:
                    - combobox "InputDate Input" [ref=f2e543]: 2026-11-08
                    - button "Choose Date" [ref=f2e545] [cursor=pointer]
                  - generic [ref=f2e549]:
                    - combobox "InputDate Input" [ref=f2e550]: 2026-11-08
                    - button "Choose Date" [ref=f2e552] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e557]: "0"
                  - generic [ref=f2e560]:
                    - combobox "InputDate Input" [ref=f2e561]: 2026-11-08
                    - button "Choose Date" [ref=f2e563] [cursor=pointer]
                  - generic [ref=f2e567]:
                    - combobox "InputDate Input" [ref=f2e568]: 2026-11-08
                    - button "Choose Date" [ref=f2e570] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e575]: "0"
                  - generic [ref=f2e578]:
                    - combobox "InputDate Input" [ref=f2e579]: 2026-11-08
                    - button "Choose Date" [ref=f2e581] [cursor=pointer]
                  - generic [ref=f2e585]:
                    - combobox "InputDate Input" [ref=f2e586]: 2026-11-08
                    - button "Choose Date" [ref=f2e588] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e593]: "0"
                  - generic [ref=f2e596]:
                    - combobox "InputDate Input" [ref=f2e597]: 2026-11-08
                    - button "Choose Date" [ref=f2e599] [cursor=pointer]
                  - generic [ref=f2e603]:
                    - combobox "InputDate Input" [ref=f2e604]: 2026-11-08
                    - button "Choose Date" [ref=f2e606] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e611]: "0"
                  - generic [ref=f2e614]:
                    - combobox "InputDate Input" [ref=f2e615]: 2026-11-08
                    - button "Choose Date" [ref=f2e617] [cursor=pointer]
                  - generic [ref=f2e621]:
                    - combobox "InputDate Input" [ref=f2e622]: 2026-11-08
                    - button "Choose Date" [ref=f2e624] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e629]: "0"
                  - generic [ref=f2e632]:
                    - combobox "InputDate Input" [ref=f2e633]: 2026-11-08
                    - button "Choose Date" [ref=f2e635] [cursor=pointer]
                  - generic [ref=f2e639]:
                    - combobox "InputDate Input" [ref=f2e640]: 2026-11-08
                    - button "Choose Date" [ref=f2e642] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e647]: "0"
                  - generic [ref=f2e650]:
                    - combobox "InputDate Input" [ref=f2e651]: 2026-11-08
                    - button "Choose Date" [ref=f2e653] [cursor=pointer]
                  - generic [ref=f2e657]:
                    - combobox "InputDate Input" [ref=f2e658]: 2026-11-08
                    - button "Choose Date" [ref=f2e660] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e665]: "0"
                  - generic [ref=f2e668]:
                    - combobox "InputDate Input" [ref=f2e669]: 2026-11-08
                    - button "Choose Date" [ref=f2e671] [cursor=pointer]
                  - generic [ref=f2e675]:
                    - combobox "InputDate Input" [ref=f2e676]: 2026-11-08
                    - button "Choose Date" [ref=f2e678] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e683]: "0"
                  - generic [ref=f2e686]:
                    - combobox "InputDate Input" [ref=f2e687]: 2026-11-08
                    - button "Choose Date" [ref=f2e689] [cursor=pointer]
                  - generic [ref=f2e693]:
                    - combobox "InputDate Input" [ref=f2e694]: 2026-11-08
                    - button "Choose Date" [ref=f2e696] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e701]: "0"
                  - generic [ref=f2e704]:
                    - combobox "InputDate Input" [ref=f2e705]: 2026-11-08
                    - button "Choose Date" [ref=f2e707] [cursor=pointer]
                  - generic [ref=f2e711]:
                    - combobox "InputDate Input" [ref=f2e712]: 2026-11-08
                    - button "Choose Date" [ref=f2e714] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e719]: "0"
                  - generic [ref=f2e722]:
                    - combobox "InputDate Input" [ref=f2e723]: 2026-11-08
                    - button "Choose Date" [ref=f2e725] [cursor=pointer]
                  - generic [ref=f2e729]:
                    - combobox "InputDate Input" [ref=f2e730]: 2026-11-08
                    - button "Choose Date" [ref=f2e732] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e737]: "0"
                  - generic [ref=f2e740]:
                    - combobox "InputDate Input" [ref=f2e741]: 2026-11-08
                    - button "Choose Date" [ref=f2e743] [cursor=pointer]
                  - generic [ref=f2e747]:
                    - combobox "InputDate Input" [ref=f2e748]: 2026-11-08
                    - button "Choose Date" [ref=f2e750] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e755]: "0"
                  - generic [ref=f2e758]:
                    - combobox "InputDate Input" [ref=f2e759]: 2026-11-08
                    - button "Choose Date" [ref=f2e761] [cursor=pointer]
                  - generic [ref=f2e765]:
                    - combobox "InputDate Input" [ref=f2e766]: 2026-11-08
                    - button "Choose Date" [ref=f2e768] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e773]: "0"
                  - generic [ref=f2e776]:
                    - combobox "InputDate Input" [ref=f2e777]: 2026-11-08
                    - button "Choose Date" [ref=f2e779] [cursor=pointer]
                  - generic [ref=f2e783]:
                    - combobox "InputDate Input" [ref=f2e784]: 2026-11-08
                    - button "Choose Date" [ref=f2e786] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e791]: "0"
            - alert [ref=f2e792]:
              - generic [ref=f2e793] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e796] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
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
> 113 |     expect.soft(s.error, `조회조건 판정 불가(ERROR) ${s.error}: ${items.filter(i => i.verdict === 'ERROR').map(i => i.name).join(', ')}`).toBe(0);
      |                                                                                                                                   ^ Error: 조회조건 판정 불가(ERROR) 1: Period
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