# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SCP0108.smoke.spec.ts >> SCP0108 CAPA_LOB_Report 스모크 @smoke >> 조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인
- Location: ..\..\Doc\e2e\specs\SCP0108.smoke.spec.ts:106:7

# Error details

```
Error: 조회조건 판정 불가(ERROR) 2: Operation, Line Type

expect(received).toBe(expected) // Object.is equality

Expected: 0
Received: 2
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SCP0108
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SCP0108
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SCP0108
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SCP0108
        - link "Authority" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SCP0108
        - link "Admin" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SCP0108
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
              - /url: /view/SCP0108
              - paragraph [ref=f2e41]: Supply Master
            - link [ref=f2e44] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e45]: Line Master
            - link [ref=f2e46] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e47]: Project Route
            - link [ref=f2e48] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e49]: BOD
            - link [ref=f2e50] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e51]: Plant Site
            - link [ref=f2e52] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e53]: Production Plan
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e55]: Work Calendar(OSP)
            - link [ref=f2e56] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e57]: Tact Time(OSP)
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e59]: Formation
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e61]: Outsourcing Capacity
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e63]: BOD ITEM
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e65]: Master Validation
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e67]: Stock OSP
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e69]: ProjectRoute(Electrode)
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e71]: ProjectRoute(Warranty)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e73]: CAPA
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e75]: SCP BOM (Cell~Pack)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e77]: Model Code Master
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e79]: MDM Class Master
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e81]: Shipment Working Day(OSP)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e83]: SCP BOM(Elec)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e85]: CAPA (Mobility IT)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e87]: Line Assign
            - link [ref=f2e88] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e89]: Speed Plan
            - link [ref=f2e90] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e91]: Loss Plan
            - link [ref=f2e92] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e93]: TEEP Report
            - link [ref=f2e94] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e95]: LOB Report
            - link [ref=f2e96] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e97]: Demand Group Master
            - link [ref=f2e98] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e99]: CAPA LineMaster
            - link [ref=f2e100] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e101]: Operation LT
          - generic [ref=f2e102]:
            - link [ref=f2e103] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e104]: Supply Plan
            - link "Plan Management":
              - /url: /view/SCP0108
              - paragraph [ref=f2e107] [cursor=pointer]: Plan Management
            - link "Shipment Plan FG":
              - /url: /view/SCP0108
              - paragraph [ref=f2e108] [cursor=pointer]: Shipment Plan FG
            - link "Shipment Plan SEMI":
              - /url: /view/SCP0108
              - paragraph [ref=f2e109] [cursor=pointer]: Shipment Plan SEMI
            - link "Production Plan Line":
              - /url: /view/SCP0108
              - paragraph [ref=f2e110] [cursor=pointer]: Production Plan Line
            - link "Production Plan Fix":
              - /url: /view/SCP0108
              - paragraph [ref=f2e111] [cursor=pointer]: Production Plan Fix
            - link "Shipment Plan Fix":
              - /url: /view/SCP0108
              - paragraph [ref=f2e112] [cursor=pointer]: Shipment Plan Fix
            - link "Global PSI":
              - /url: /view/SCP0108
              - paragraph [ref=f2e113] [cursor=pointer]: Global PSI
            - link "Global PSI Elec":
              - /url: /view/SCP0108
              - paragraph [ref=f2e114] [cursor=pointer]: Global PSI Elec
            - link "Global PSI New":
              - /url: /view/SCP0108
              - paragraph [ref=f2e115] [cursor=pointer]: Global PSI New
            - link "Integration PSI":
              - /url: /view/SCP0108
              - paragraph [ref=f2e116] [cursor=pointer]: Integration PSI
          - generic [ref=f2e117]:
            - link [ref=f2e118] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e119]: Waterfall
            - link "Shipment Plan FG Waterfall":
              - /url: /view/SCP0108
              - paragraph [ref=f2e122] [cursor=pointer]: Shipment Plan FG Waterfall
            - link "Production Plan Waterfall":
              - /url: /view/SCP0108
              - paragraph [ref=f2e123] [cursor=pointer]: Production Plan Waterfall
            - link "Shipment Plan Semi Waterfall":
              - /url: /view/SCP0108
              - paragraph [ref=f2e124] [cursor=pointer]: Shipment Plan Semi Waterfall
          - generic [ref=f2e125]:
            - link [ref=f2e126] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e127]: OPT Plan
            - link "Plan Control":
              - /url: /view/SCP0108
              - paragraph [ref=f2e130] [cursor=pointer]: Plan Control
            - link "OPT CAPA":
              - /url: /view/SCP0108
              - paragraph [ref=f2e131] [cursor=pointer]: OPT CAPA
            - link "Workbench":
              - /url: /view/SCP0108
              - paragraph [ref=f2e132] [cursor=pointer]: Workbench
            - link "Constraint Mgmt":
              - /url: /view/SCP0108
              - paragraph [ref=f2e133] [cursor=pointer]: Constraint Mgmt
            - link "Plan Group Master":
              - /url: /view/SCP0108
              - paragraph [ref=f2e134] [cursor=pointer]: Plan Group Master
            - link "Plan Activity Mgmt":
              - /url: /view/SCP0108
              - paragraph [ref=f2e135] [cursor=pointer]: Plan Activity Mgmt
            - link "Plan Group Dashboard":
              - /url: /view/SCP0108
              - paragraph [ref=f2e136] [cursor=pointer]: Plan Group Dashboard
            - link "Precede/Safety Stock Day":
              - /url: /view/SCP0108
              - paragraph [ref=f2e137] [cursor=pointer]: Precede/Safety Stock Day
            - link "Precede/Safety Stock Qty":
              - /url: /view/SCP0108
              - paragraph [ref=f2e138] [cursor=pointer]: Precede/Safety Stock Qty
            - link "Demand Exception":
              - /url: /view/SCP0108
              - paragraph [ref=f2e139] [cursor=pointer]: Demand Exception
            - link "Scheduled Receipt Information":
              - /url: /view/SCP0108
              - paragraph [ref=f2e140] [cursor=pointer]: Scheduled Receipt Information
            - link "Sales Site Priority":
              - /url: /view/SCP0108
              - paragraph [ref=f2e141] [cursor=pointer]: Sales Site Priority
            - link "Constraint Of Shipment Qty":
              - /url: /view/SCP0108
              - paragraph [ref=f2e142] [cursor=pointer]: Constraint Of Shipment Qty
            - link "Warehouse Capacity":
              - /url: /view/SCP0108
              - paragraph [ref=f2e143] [cursor=pointer]: Warehouse Capacity
          - generic [ref=f2e144]:
            - link [ref=f2e145] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e146]: SCM Supply
            - link "Shipment(Allo) Report":
              - /url: /view/SCP0108
              - paragraph [ref=f2e149] [cursor=pointer]: Shipment(Allo) Report
            - link "Long-term stock":
              - /url: /view/SCP0108
              - paragraph [ref=f2e150] [cursor=pointer]: Long-term stock
            - link "Ending Inventory":
              - /url: /view/SCP0108
              - paragraph [ref=f2e151] [cursor=pointer]: Ending Inventory
            - link "Inventory Trend":
              - /url: /view/SCP0108
              - paragraph [ref=f2e152] [cursor=pointer]: Inventory Trend
          - generic [ref=f2e153]:
            - link [ref=f2e154] [cursor=pointer]:
              - /url: /view/SCP0108
              - paragraph [ref=f2e155]: Validation
            - link "Intransit Inventory":
              - /url: /view/SCP0108
              - paragraph [ref=f2e158] [cursor=pointer]: Intransit Inventory
      - main [ref=f2e159]:
        - generic [ref=f2e161]:
          - generic [ref=f2e162]:
            - generic [ref=f2e163]:
              - button "Home" [ref=f2e164] [cursor=pointer]
              - button "LOB Report" [ref=f2e166] [cursor=pointer]
            - generic [ref=f2e171]:
              - button "Scroll tabs left" [disabled] [ref=f2e172]
              - button "Scroll tabs right" [disabled] [ref=f2e175]
              - button "Close others" [ref=f2e178] [cursor=pointer]
              - button "Close All" [ref=f2e179] [cursor=pointer]
          - generic [ref=f2e180]:
            - generic [ref=f2e183]:
              - generic [ref=f2e185]:
                - generic [ref=f2e186]:
                  - img [aria-hidden] [ref=f2e188] [cursor=pointer]
                  - paragraph [ref=f2e191]: LOB Report
                - generic [ref=f2e192]:
                  - generic [ref=f2e193]: Supply
                  - generic [ref=f2e198]: Supply Master
                  - generic [ref=f2e203]: LOB Report
                - generic [ref=f2e205]:
                  - generic [ref=f2e206]: Search Area
                  - switch [checked] [ref=f2e209] [cursor=pointer]
                - button "Full screen" [ref=f2e212] [cursor=pointer]
              - generic [ref=f2e221]:
                - generic [ref=f2e222]:
                  - generic [ref=f2e223]:
                    - generic [ref=f2e225]:
                      - generic [ref=f2e226]: Division
                      - generic [ref=f2e234]:
                        - combobox [ref=f2e235]: 81 Automotive Battery
                        - button "Open" [ref=f2e237] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e242]:
                      - generic [ref=f2e243]: Plan Month
                      - generic [ref=f2e251]:
                        - combobox [ref=f2e252]: "202609"
                        - button "Open" [ref=f2e254] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e259]:
                      - generic [ref=f2e260]: Version
                      - generic [ref=f2e265]:
                        - generic [ref=f2e270]:
                          - combobox [ref=f2e271]: "1"
                          - button "Open" [ref=f2e273] [cursor=pointer]
                          - group [aria-hidden]
                        - textbox [ref=f2e280]: RP
                    - generic [ref=f2e282]:
                      - generic [ref=f2e283]: Status
                      - generic [ref=f2e291]:
                        - combobox [disabled] [ref=f2e292]: "2`nd Cut off"
                        - generic [ref=f2e293]:
                          - button "Open" [disabled]
                        - group [aria-hidden]
                    - generic [ref=f2e295]:
                      - generic [ref=f2e296]: Site
                      - generic [ref=f2e304] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e305]
                        - button "Open" [ref=f2e307]
                        - group [aria-hidden]
                    - generic [ref=f2e312]:
                      - generic [ref=f2e313]: Plant
                      - generic [ref=f2e321] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e322]
                        - button "Open" [ref=f2e324]
                        - group [aria-hidden]
                    - generic [ref=f2e329]:
                      - generic [ref=f2e330]: Building
                      - generic [ref=f2e338] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e339]
                        - button "Open" [ref=f2e341]
                        - group [aria-hidden]
                    - generic [ref=f2e346]:
                      - generic [ref=f2e347]: Line
                      - generic [ref=f2e355] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e356]
                        - button "Open" [ref=f2e358]
                        - group [aria-hidden]
                  - generic [ref=f2e362]:
                    - button [active] [ref=f2e363] [cursor=pointer]
                    - button [ref=f2e368] [cursor=pointer]
                - generic [ref=f2e373]:
                  - separator [ref=f2e374]
                  - generic [ref=f2e376]:
                    - generic [ref=f2e378]:
                      - generic [ref=f2e379]: Operation group
                      - generic [ref=f2e387]:
                        - combobox [ref=f2e388]: Electrode
                        - button "Open" [ref=f2e390] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e397]:
                      - generic [ref=f2e398]: Basic Nickname
                      - generic [ref=f2e404]:
                        - textbox [ref=f2e405]
                        - button [ref=f2e406] [cursor=pointer]
                    - generic [ref=f2e412]:
                      - generic [ref=f2e413]: Bottleneck
                      - generic [ref=f2e421]:
                        - combobox [ref=f2e422]: "Y"
                        - button "Open" [ref=f2e424] [cursor=pointer]
                        - group [aria-hidden]
              - generic [ref=f2e428]:
                - generic [ref=f2e429]:
                  - paragraph
                  - generic [ref=f2e430]: 총95건
                - generic [ref=f2e431]:
                  - generic "Column Setting" [ref=f2e432]:
                    - button "Column Setting" [ref=f2e433] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e437]:
                    - button [ref=f2e438] [cursor=pointer]
                  - generic "Remove" [ref=f2e443]:
                    - button [ref=f2e444] [cursor=pointer]
                  - generic "Sort" [ref=f2e451]:
                    - button [ref=f2e452] [cursor=pointer]
                  - generic "Filter" [ref=f2e457]:
                    - button [ref=f2e458] [cursor=pointer]
                  - generic "Condition" [ref=f2e463]:
                    - button [ref=f2e464] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e474]:
                    - button [ref=f2e475] [cursor=pointer]
                  - generic "Excel" [ref=f2e482]:
                    - button [ref=f2e483] [cursor=pointer]
              - generic [ref=f2e491]:
                - grid [ref=f2e492]:
                  - rowgroup [ref=f2e493]:
                    - generic:
                      - row "Div Plant Name Line Name Basic Nickname Operation Name Line Type Operation Plan No":
                        - columnheader "Div" [ref=f2e494]
                        - columnheader "Plant Name" [ref=f2e495]
                        - columnheader "Line Name" [ref=f2e496]
                        - columnheader "Basic Nickname" [ref=f2e497]
                        - columnheader "Operation Name" [ref=f2e498]
                        - columnheader "Line Type" [ref=f2e499]
                        - columnheader "Operation Plan" [ref=f2e500]
                        - gridcell "No" [ref=f2e501]
                      - row "2026 2027":
                        - columnheader "2026" [ref=f2e502]
                        - columnheader "2027" [ref=f2e503]
                      - row "10 11 12 01 02 03 04 05 06 07 08":
                        - columnheader "10" [ref=f2e504]
                        - columnheader "11" [ref=f2e505]
                        - columnheader "12" [ref=f2e506]
                        - columnheader "01" [ref=f2e507]
                        - columnheader "02" [ref=f2e508]
                        - columnheader "03" [ref=f2e509]
                        - columnheader "04" [ref=f2e510]
                        - columnheader "05" [ref=f2e511]
                        - columnheader "06" [ref=f2e512]
                        - columnheader "07" [ref=f2e513]
                        - columnheader "08" [ref=f2e514]
                  - rowgroup [ref=f2e515]:
                    - generic [ref=f2e516]:
                      - 'row "81 MI Michigan Holland Auto Prod A4)Assy #01 P56A Notching Anode 32,092.9 32,093.4 32,094.0 32,190.0 32,190.0 32,190.0 32,190.0 32,190.0 32,190.0 32,190.0 32,190.0 1"':
                        - gridcell "81" [selected] [ref=f2e517]
                        - gridcell "MI Michigan Holland Auto Prod" [ref=f2e518]
                        - 'gridcell "A4)Assy #01" [ref=f2e519]'
                        - gridcell "P56A" [ref=f2e520]
                        - gridcell "Notching" [ref=f2e521]
                        - gridcell "Anode" [ref=f2e522]
                        - gridcell "32,092.9" [ref=f2e523]
                        - gridcell "32,093.4" [ref=f2e524]
                        - gridcell "32,094.0" [ref=f2e525]
                        - gridcell "32,190.0" [ref=f2e526]
                        - gridcell "32,190.0" [ref=f2e527]
                        - gridcell "32,190.0" [ref=f2e528]
                        - gridcell "32,190.0" [ref=f2e529]
                        - gridcell "32,190.0" [ref=f2e530]
                        - gridcell "32,190.0" [ref=f2e531]
                        - gridcell "32,190.0" [ref=f2e532]
                        - gridcell "32,190.0" [ref=f2e533]
                        - gridcell "1" [ref=f2e534]
                      - row "Cathode 2":
                        - gridcell "Cathode" [ref=f2e535]
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
                        - gridcell "2" [ref=f2e547]
                      - row "Lamination Mono 3":
                        - gridcell "Lamination" [ref=f2e548]
                        - gridcell "Mono" [ref=f2e549]
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
                        - gridcell "3" [ref=f2e561]
                      - row "Packaging - 4":
                        - gridcell "Packaging" [ref=f2e562]
                        - gridcell "-" [ref=f2e563]
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
                        - gridcell "4" [ref=f2e575]
                      - 'row "A4)Assy #02 E71A Notching Anode 5"':
                        - 'gridcell "A4)Assy #02" [ref=f2e576]'
                        - gridcell "E71A" [ref=f2e577]
                        - gridcell "Notching" [ref=f2e578]
                        - gridcell "Anode" [ref=f2e579]
                        - gridcell [ref=f2e580]
                        - gridcell [ref=f2e581]
                        - gridcell [ref=f2e582]
                        - gridcell [ref=f2e583]
                        - gridcell [ref=f2e584]
                        - gridcell [ref=f2e585]
                        - gridcell [ref=f2e586]
                        - gridcell [ref=f2e587]
                        - gridcell [ref=f2e588]
                        - gridcell [ref=f2e589]
                        - gridcell [ref=f2e590]
                        - gridcell "5" [ref=f2e591]
                      - row "Cathode 6":
                        - gridcell "Cathode" [ref=f2e592]
                        - gridcell [ref=f2e593]
                        - gridcell [ref=f2e594]
                        - gridcell [ref=f2e595]
                        - gridcell [ref=f2e596]
                        - gridcell [ref=f2e597]
                        - gridcell [ref=f2e598]
                        - gridcell [ref=f2e599]
                        - gridcell [ref=f2e600]
                        - gridcell [ref=f2e601]
                        - gridcell [ref=f2e602]
                        - gridcell [ref=f2e603]
                        - gridcell "6" [ref=f2e604]
                      - row "Lamination Mono 35,819.4 7":
                        - gridcell "Lamination" [ref=f2e605]
                        - gridcell "Mono" [ref=f2e606]
                        - gridcell "35,819.4" [ref=f2e607]
                        - gridcell [ref=f2e608]
                        - gridcell [ref=f2e609]
                        - gridcell [ref=f2e610]
                        - gridcell [ref=f2e611]
                        - gridcell [ref=f2e612]
                        - gridcell [ref=f2e613]
                        - gridcell [ref=f2e614]
                        - gridcell [ref=f2e615]
                        - gridcell [ref=f2e616]
                        - gridcell [ref=f2e617]
                        - gridcell "7" [ref=f2e618]
                      - row "Packaging - 35,843.4 35,843.4 36,240.0 36,240.0 36,240.0 36,240.0 36,240.0 36,240.0 36,240.0 36,240.0 8":
                        - gridcell "Packaging" [ref=f2e619]
                        - gridcell "-" [ref=f2e620]
                        - gridcell [ref=f2e621]
                        - gridcell "35,843.4" [ref=f2e622]
                        - gridcell "35,843.4" [ref=f2e623]
                        - gridcell "36,240.0" [ref=f2e624]
                        - gridcell "36,240.0" [ref=f2e625]
                        - gridcell "36,240.0" [ref=f2e626]
                        - gridcell "36,240.0" [ref=f2e627]
                        - gridcell "36,240.0" [ref=f2e628]
                        - gridcell "36,240.0" [ref=f2e629]
                        - gridcell "36,240.0" [ref=f2e630]
                        - gridcell "36,240.0" [ref=f2e631]
                        - gridcell "8" [ref=f2e632]
                      - 'row "MI Michigan LS Auto/ESS Prod DUM_LS_A01_Assy #01 E79C Notching Anode 32,306.1 30,152.4 11,076.4 14,923.9 19,297.5 24,423.4 30,152.4 30,152.4 30,152.4 30,152.4 9"':
                        - gridcell "MI Michigan LS Auto/ESS Prod" [ref=f2e633]
                        - 'gridcell "DUM_LS_A01_Assy #01" [ref=f2e634]'
                        - gridcell "E79C" [ref=f2e635]
                        - gridcell "Notching" [ref=f2e636]
                        - gridcell "Anode" [ref=f2e637]
                        - gridcell [ref=f2e638]
                        - gridcell "32,306.1" [ref=f2e639]
                        - gridcell "30,152.4" [ref=f2e640]
                        - gridcell "11,076.4" [ref=f2e641]
                        - gridcell "14,923.9" [ref=f2e642]
                        - gridcell "19,297.5" [ref=f2e643]
                        - gridcell "24,423.4" [ref=f2e644]
                        - gridcell "30,152.4" [ref=f2e645]
                        - gridcell "30,152.4" [ref=f2e646]
                        - gridcell "30,152.4" [ref=f2e647]
                        - gridcell "30,152.4" [ref=f2e648]
                        - gridcell "9" [ref=f2e649]
                      - row "Lamination Mono 32,770.1 10":
                        - gridcell "Lamination" [ref=f2e650]
                        - gridcell "Mono" [ref=f2e651]
                        - gridcell "32,770.1" [ref=f2e652]
                        - gridcell [ref=f2e653]
                        - gridcell [ref=f2e654]
                        - gridcell [ref=f2e655]
                        - gridcell [ref=f2e656]
                        - gridcell [ref=f2e657]
                        - gridcell [ref=f2e658]
                        - gridcell [ref=f2e659]
                        - gridcell [ref=f2e660]
                        - gridcell [ref=f2e661]
                        - gridcell [ref=f2e662]
                        - gridcell "10" [ref=f2e663]
                      - 'row "DUM_LS_A02_Assy #02 E79C Notching Anode 30,152.4 30,152.4 30,152.4 11,076.4 14,923.9 19,297.5 24,423.4 30,152.4 30,152.4 30,152.4 30,152.4 11"':
                        - 'gridcell "DUM_LS_A02_Assy #02" [ref=f2e664]'
                        - gridcell "E79C" [ref=f2e665]
                        - gridcell "Notching" [ref=f2e666]
                        - gridcell "Anode" [ref=f2e667]
                        - gridcell "30,152.4" [ref=f2e668]
                        - gridcell "30,152.4" [ref=f2e669]
                        - gridcell "30,152.4" [ref=f2e670]
                        - gridcell "11,076.4" [ref=f2e671]
                        - gridcell "14,923.9" [ref=f2e672]
                        - gridcell "19,297.5" [ref=f2e673]
                        - gridcell "24,423.4" [ref=f2e674]
                        - gridcell "30,152.4" [ref=f2e675]
                        - gridcell "30,152.4" [ref=f2e676]
                        - gridcell "30,152.4" [ref=f2e677]
                        - gridcell "30,152.4" [ref=f2e678]
                        - gridcell "11" [ref=f2e679]
                      - 'row "DUM_LS_A03_Assy #03 E79C Notching Anode 24,423.4 30,152.4 30,152.4 11,076.4 14,923.9 19,297.5 24,423.4 30,152.4 30,152.4 30,152.4 30,152.4 12"':
                        - 'gridcell "DUM_LS_A03_Assy #03" [ref=f2e680]'
                        - gridcell "E79C" [ref=f2e681]
                        - gridcell "Notching" [ref=f2e682]
                        - gridcell "Anode" [ref=f2e683]
                        - gridcell "24,423.4" [ref=f2e684]
                        - gridcell "30,152.4" [ref=f2e685]
                        - gridcell "30,152.4" [ref=f2e686]
                        - gridcell "11,076.4" [ref=f2e687]
                        - gridcell "14,923.9" [ref=f2e688]
                        - gridcell "19,297.5" [ref=f2e689]
                        - gridcell "24,423.4" [ref=f2e690]
                        - gridcell "30,152.4" [ref=f2e691]
                        - gridcell "30,152.4" [ref=f2e692]
                        - gridcell "30,152.4" [ref=f2e693]
                        - gridcell "30,152.4" [ref=f2e694]
                        - gridcell "12" [ref=f2e695]
                      - 'row "DUM_LS_A04_Assy #04 E79C Notching Anode 16,261.9 20,581.5 30,152.4 11,076.4 14,923.9 19,297.5 24,423.4 30,152.4 30,152.4 30,152.4 30,152.4 13"':
                        - 'gridcell "DUM_LS_A04_Assy #04" [ref=f2e696]'
                        - gridcell "E79C" [ref=f2e697]
                        - gridcell "Notching" [ref=f2e698]
                        - gridcell "Anode" [ref=f2e699]
                        - gridcell "16,261.9" [ref=f2e700]
                        - gridcell "20,581.5" [ref=f2e701]
                        - gridcell "30,152.4" [ref=f2e702]
                        - gridcell "11,076.4" [ref=f2e703]
                        - gridcell "14,923.9" [ref=f2e704]
                        - gridcell "19,297.5" [ref=f2e705]
                        - gridcell "24,423.4" [ref=f2e706]
                        - gridcell "30,152.4" [ref=f2e707]
                        - gridcell "30,152.4" [ref=f2e708]
                        - gridcell "30,152.4" [ref=f2e709]
                        - gridcell "30,152.4" [ref=f2e710]
                        - gridcell "13" [ref=f2e711]
                      - 'row "DUM_LS_A05_Assy #05 E79C Notching Anode 9,334.0 12,576.3 16,261.9 9,334.0 12,576.3 16,261.9 24,423.4 30,152.4 30,152.4 25,409.3 25,409.3 14"':
                        - 'gridcell "DUM_LS_A05_Assy #05" [ref=f2e712]'
                        - gridcell "E79C" [ref=f2e713]
                        - gridcell "Notching" [ref=f2e714]
                        - gridcell "Anode" [ref=f2e715]
                        - gridcell "9,334.0" [ref=f2e716]
                        - gridcell "12,576.3" [ref=f2e717]
                        - gridcell "16,261.9" [ref=f2e718]
                        - gridcell "9,334.0" [ref=f2e719]
                        - gridcell "12,576.3" [ref=f2e720]
                        - gridcell "16,261.9" [ref=f2e721]
                        - gridcell "24,423.4" [ref=f2e722]
                        - gridcell "30,152.4" [ref=f2e723]
                        - gridcell "30,152.4" [ref=f2e724]
                        - gridcell "25,409.3" [ref=f2e725]
                        - gridcell "25,409.3" [ref=f2e726]
                        - gridcell "14" [ref=f2e727]
                      - 'row "DUM_LS_A06_Assy #06 E79C Notching Anode 15"':
                        - 'gridcell "DUM_LS_A06_Assy #06" [ref=f2e728]'
                        - gridcell "E79C" [ref=f2e729]
                        - gridcell "Notching" [ref=f2e730]
                        - gridcell "Anode" [ref=f2e731]
                        - gridcell [ref=f2e732]
                        - gridcell [ref=f2e733]
                        - gridcell [ref=f2e734]
                        - gridcell [ref=f2e735]
                        - gridcell [ref=f2e736]
                        - gridcell [ref=f2e737]
                        - gridcell [ref=f2e738]
                        - gridcell [ref=f2e739]
                        - gridcell [ref=f2e740]
                        - gridcell [ref=f2e741]
                        - gridcell [ref=f2e742]
                        - gridcell "15" [ref=f2e743]
                      - 'row "DUM_LS_A07_Assy #07 E79C Notching Anode 16"':
                        - 'gridcell "DUM_LS_A07_Assy #07" [ref=f2e744]'
                        - gridcell "E79C" [ref=f2e745]
                        - gridcell "Notching" [ref=f2e746]
                        - gridcell "Anode" [ref=f2e747]
                        - gridcell [ref=f2e748]
                        - gridcell [ref=f2e749]
                        - gridcell [ref=f2e750]
                        - gridcell [ref=f2e751]
                        - gridcell [ref=f2e752]
                        - gridcell [ref=f2e753]
                        - gridcell [ref=f2e754]
                        - gridcell [ref=f2e755]
                        - gridcell [ref=f2e756]
                        - gridcell [ref=f2e757]
                        - gridcell [ref=f2e758]
                        - gridcell "16" [ref=f2e759]
                      - 'row "DUM_LS_A08_Assy #08 E79C Notching Anode 17"':
                        - 'gridcell "DUM_LS_A08_Assy #08" [ref=f2e760]'
                        - gridcell "E79C" [ref=f2e761]
                        - gridcell "Notching" [ref=f2e762]
                        - gridcell "Anode" [ref=f2e763]
                        - gridcell [ref=f2e764]
                        - gridcell [ref=f2e765]
                        - gridcell [ref=f2e766]
                        - gridcell [ref=f2e767]
                        - gridcell [ref=f2e768]
                        - gridcell [ref=f2e769]
                        - gridcell [ref=f2e770]
                        - gridcell [ref=f2e771]
                        - gridcell [ref=f2e772]
                        - gridcell [ref=f2e773]
                        - gridcell [ref=f2e774]
                        - gridcell "17" [ref=f2e775]
                      - 'row "DUM_LS_A09_Assy #09-1 E79C Notching Anode 18"':
                        - 'gridcell "DUM_LS_A09_Assy #09-1" [ref=f2e776]'
                        - gridcell "E79C" [ref=f2e777]
                        - gridcell "Notching" [ref=f2e778]
                        - gridcell "Anode" [ref=f2e779]
                        - gridcell [ref=f2e780]
                        - gridcell [ref=f2e781]
                        - gridcell [ref=f2e782]
                        - gridcell [ref=f2e783]
                        - gridcell [ref=f2e784]
                        - gridcell [ref=f2e785]
                        - gridcell [ref=f2e786]
                        - gridcell [ref=f2e787]
                        - gridcell [ref=f2e788]
                        - gridcell [ref=f2e789]
                        - gridcell [ref=f2e790]
                        - gridcell "18" [ref=f2e791]
                      - 'row "NA Nanjing Auto Prod Assy #01 P2.7 Stacking & Folding Folding 8,000.0 8,000.0 8,000.0 7,816.7 7,816.7 7,816.7 7,816.7 7,816.7 7,816.7 7,816.7 7,816.7 19"':
                        - gridcell "NA Nanjing Auto Prod" [ref=f2e792]
                        - 'gridcell "Assy #01" [ref=f2e793]'
                        - gridcell "P2.7" [ref=f2e794]
                        - gridcell "Stacking & Folding" [ref=f2e795]
                        - gridcell "Folding" [ref=f2e796]
                        - gridcell "8,000.0" [ref=f2e797]
                        - gridcell "8,000.0" [ref=f2e798]
                        - gridcell "8,000.0" [ref=f2e799]
                        - gridcell "7,816.7" [ref=f2e800]
                        - gridcell "7,816.7" [ref=f2e801]
                        - gridcell "7,816.7" [ref=f2e802]
                        - gridcell "7,816.7" [ref=f2e803]
                        - gridcell "7,816.7" [ref=f2e804]
                        - gridcell "7,816.7" [ref=f2e805]
                        - gridcell "7,816.7" [ref=f2e806]
                        - gridcell "7,816.7" [ref=f2e807]
                        - gridcell "19" [ref=f2e808]
                      - row "P30B Stacking & Folding Folding 7,002.4 7,002.8 7,003.1 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 20":
                        - gridcell "P30B" [ref=f2e809]
                        - gridcell "Stacking & Folding" [ref=f2e810]
                        - gridcell "Folding" [ref=f2e811]
                        - gridcell "7,002.4" [ref=f2e812]
                        - gridcell "7,002.8" [ref=f2e813]
                        - gridcell "7,003.1" [ref=f2e814]
                        - gridcell "7,018.0" [ref=f2e815]
                        - gridcell "7,018.0" [ref=f2e816]
                        - gridcell "7,018.0" [ref=f2e817]
                        - gridcell "7,018.0" [ref=f2e818]
                        - gridcell "7,018.0" [ref=f2e819]
                        - gridcell "7,018.0" [ref=f2e820]
                        - gridcell "7,018.0" [ref=f2e821]
                        - gridcell "7,018.0" [ref=f2e822]
                        - gridcell "20" [ref=f2e823]
                      - row "P34 Stacking & Folding Folding 7,002.4 7,002.8 7,003.1 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 7,018.0 21":
                        - gridcell "P34" [ref=f2e824]
                        - gridcell "Stacking & Folding" [ref=f2e825]
                        - gridcell "Folding" [ref=f2e826]
                        - gridcell "7,002.4" [ref=f2e827]
                        - gridcell "7,002.8" [ref=f2e828]
                        - gridcell "7,003.1" [ref=f2e829]
                        - gridcell "7,018.0" [ref=f2e830]
                        - gridcell "7,018.0" [ref=f2e831]
                        - gridcell "7,018.0" [ref=f2e832]
                        - gridcell "7,018.0" [ref=f2e833]
                        - gridcell "7,018.0" [ref=f2e834]
                        - gridcell "7,018.0" [ref=f2e835]
                        - gridcell "7,018.0" [ref=f2e836]
                        - gridcell "7,018.0" [ref=f2e837]
                        - gridcell "21" [ref=f2e838]
                      - 'row "Assy #02 H07B Packaging - 13,700.1 13,699.9 13,699.9 13,755.9 13,755.9 13,755.9 13,755.9 13,755.9 13,755.9 13,755.9 13,755.9 22"':
                        - 'gridcell "Assy #02" [ref=f2e839]'
                        - gridcell "H07B" [ref=f2e840]
                        - gridcell "Packaging" [ref=f2e841]
                        - gridcell "-" [ref=f2e842]
                        - gridcell "13,700.1" [ref=f2e843]
                        - gridcell "13,699.9" [ref=f2e844]
                        - gridcell "13,699.9" [ref=f2e845]
                        - gridcell "13,755.9" [ref=f2e846]
                        - gridcell "13,755.9" [ref=f2e847]
                        - gridcell "13,755.9" [ref=f2e848]
                        - gridcell "13,755.9" [ref=f2e849]
                        - gridcell "13,755.9" [ref=f2e850]
                        - gridcell "13,755.9" [ref=f2e851]
                        - gridcell "13,755.9" [ref=f2e852]
                        - gridcell "13,755.9" [ref=f2e853]
                        - gridcell "22" [ref=f2e854]
                      - row "K4 Notching Anode 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 23":
                        - gridcell "K4" [ref=f2e855]
                        - gridcell "Notching" [ref=f2e856]
                        - gridcell "Anode" [ref=f2e857]
                        - gridcell "0.0" [ref=f2e858]
                        - gridcell "0.0" [ref=f2e859]
                        - gridcell "0.0" [ref=f2e860]
                        - gridcell "0.0" [ref=f2e861]
                        - gridcell "0.0" [ref=f2e862]
                        - gridcell "0.0" [ref=f2e863]
                        - gridcell "0.0" [ref=f2e864]
                        - gridcell "0.0" [ref=f2e865]
                        - gridcell "0.0" [ref=f2e866]
                        - gridcell "0.0" [ref=f2e867]
                        - gridcell "0.0" [ref=f2e868]
                        - gridcell "23" [ref=f2e869]
                      - row "Cathode 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 24":
                        - gridcell "Cathode" [ref=f2e870]
                        - gridcell "0.0" [ref=f2e871]
                        - gridcell "0.0" [ref=f2e872]
                        - gridcell "0.0" [ref=f2e873]
                        - gridcell "0.0" [ref=f2e874]
                        - gridcell "0.0" [ref=f2e875]
                        - gridcell "0.0" [ref=f2e876]
                        - gridcell "0.0" [ref=f2e877]
                        - gridcell "0.0" [ref=f2e878]
                        - gridcell "0.0" [ref=f2e879]
                        - gridcell "0.0" [ref=f2e880]
                        - gridcell "0.0" [ref=f2e881]
                        - gridcell "24" [ref=f2e882]
                      - row "Lamination A 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 25":
                        - gridcell "Lamination" [ref=f2e883]
                        - gridcell "A" [ref=f2e884]
                        - gridcell "0.0" [ref=f2e885]
                        - gridcell "0.0" [ref=f2e886]
                        - gridcell "0.0" [ref=f2e887]
                        - gridcell "0.0" [ref=f2e888]
                        - gridcell "0.0" [ref=f2e889]
                        - gridcell "0.0" [ref=f2e890]
                        - gridcell "0.0" [ref=f2e891]
                        - gridcell "0.0" [ref=f2e892]
                        - gridcell "0.0" [ref=f2e893]
                        - gridcell "0.0" [ref=f2e894]
                        - gridcell "0.0" [ref=f2e895]
                        - gridcell "25" [ref=f2e896]
                      - row "C 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 26":
                        - gridcell "C" [ref=f2e897]
                        - gridcell "0.0" [ref=f2e898]
                        - gridcell "0.0" [ref=f2e899]
                        - gridcell "0.0" [ref=f2e900]
                        - gridcell "0.0" [ref=f2e901]
                        - gridcell "0.0" [ref=f2e902]
                        - gridcell "0.0" [ref=f2e903]
                        - gridcell "0.0" [ref=f2e904]
                        - gridcell "0.0" [ref=f2e905]
                        - gridcell "0.0" [ref=f2e906]
                        - gridcell "0.0" [ref=f2e907]
                        - gridcell "0.0" [ref=f2e908]
                        - gridcell "26" [ref=f2e909]
                      - row "Stacking & Folding Folding 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 27":
                        - gridcell "Stacking & Folding" [ref=f2e910]
                        - gridcell "Folding" [ref=f2e911]
                        - gridcell "0.0" [ref=f2e912]
                        - gridcell "0.0" [ref=f2e913]
                        - gridcell "0.0" [ref=f2e914]
                        - gridcell "0.0" [ref=f2e915]
                        - gridcell "0.0" [ref=f2e916]
                        - gridcell "0.0" [ref=f2e917]
                        - gridcell "0.0" [ref=f2e918]
                        - gridcell "0.0" [ref=f2e919]
                        - gridcell "0.0" [ref=f2e920]
                        - gridcell "0.0" [ref=f2e921]
                        - gridcell "0.0" [ref=f2e922]
                        - gridcell "27" [ref=f2e923]
                      - row "Packaging - 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 28":
                        - gridcell "Packaging" [ref=f2e924]
                        - gridcell "-" [ref=f2e925]
                        - gridcell "0.0" [ref=f2e926]
                        - gridcell "0.0" [ref=f2e927]
                        - gridcell "0.0" [ref=f2e928]
                        - gridcell "0.0" [ref=f2e929]
                        - gridcell "0.0" [ref=f2e930]
                        - gridcell "0.0" [ref=f2e931]
                        - gridcell "0.0" [ref=f2e932]
                        - gridcell "0.0" [ref=f2e933]
                        - gridcell "0.0" [ref=f2e934]
                        - gridcell "0.0" [ref=f2e935]
                        - gridcell "0.0" [ref=f2e936]
                        - gridcell "28" [ref=f2e937]
                      - row "LV9.8A Packaging - 13,900.1 13,900.1 13,900.1 14,120.2 14,120.2 14,120.2 14,120.2 14,120.2 14,120.2 14,120.2 14,120.2 29":
                        - gridcell "LV9.8A" [ref=f2e938]
                        - gridcell "Packaging" [ref=f2e939]
                        - gridcell "-" [ref=f2e940]
                        - gridcell "13,900.1" [ref=f2e941]
                        - gridcell "13,900.1" [ref=f2e942]
                        - gridcell "13,900.1" [ref=f2e943]
                        - gridcell "14,120.2" [ref=f2e944]
                        - gridcell "14,120.2" [ref=f2e945]
                        - gridcell "14,120.2" [ref=f2e946]
                        - gridcell "14,120.2" [ref=f2e947]
                        - gridcell "14,120.2" [ref=f2e948]
                        - gridcell "14,120.2" [ref=f2e949]
                        - gridcell "14,120.2" [ref=f2e950]
                        - gridcell "14,120.2" [ref=f2e951]
                        - gridcell "29" [ref=f2e952]
                      - 'row "Assy #03 LV15A Formation - 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 30"':
                        - 'gridcell "Assy #03" [ref=f2e953]'
                        - gridcell "LV15A" [ref=f2e954]
                        - gridcell "Formation" [ref=f2e955]
                        - gridcell "-" [ref=f2e956]
                        - gridcell "13,600.0" [ref=f2e957]
                        - gridcell "13,600.0" [ref=f2e958]
                        - gridcell "13,600.0" [ref=f2e959]
                        - gridcell "13,600.0" [ref=f2e960]
                        - gridcell "13,600.0" [ref=f2e961]
                        - gridcell "13,600.0" [ref=f2e962]
                        - gridcell "13,600.0" [ref=f2e963]
                        - gridcell "13,600.0" [ref=f2e964]
                        - gridcell "13,600.0" [ref=f2e965]
                        - gridcell "13,600.0" [ref=f2e966]
                        - gridcell "13,600.0" [ref=f2e967]
                        - gridcell "30" [ref=f2e968]
                      - row "LV15B Formation - 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 13,600.0 31":
                        - gridcell "LV15B" [ref=f2e969]
                        - gridcell "Formation" [ref=f2e970]
                        - gridcell "-" [ref=f2e971]
                        - gridcell "13,600.0" [ref=f2e972]
                        - gridcell "13,600.0" [ref=f2e973]
                        - gridcell "13,600.0" [ref=f2e974]
                        - gridcell "13,600.0" [ref=f2e975]
                        - gridcell "13,600.0" [ref=f2e976]
                        - gridcell "13,600.0" [ref=f2e977]
                        - gridcell "13,600.0" [ref=f2e978]
                        - gridcell "13,600.0" [ref=f2e979]
                        - gridcell "13,600.0" [ref=f2e980]
                        - gridcell "13,600.0" [ref=f2e981]
                        - gridcell "13,600.0" [ref=f2e982]
                        - gridcell "31" [ref=f2e983]
                      - 'row "Assy #04 H5.5A Packaging - 39,000.2 39,000.2 39,000.2 39,308.0 39,308.0 39,308.0 39,308.0 39,308.0 39,308.0 39,308.0 39,308.0 32"':
                        - 'gridcell "Assy #04" [ref=f2e984]'
                        - gridcell "H5.5A" [ref=f2e985]
                        - gridcell "Packaging" [ref=f2e986]
                        - gridcell "-" [ref=f2e987]
                        - gridcell "39,000.2" [ref=f2e988]
                        - gridcell "39,000.2" [ref=f2e989]
                        - gridcell "39,000.2" [ref=f2e990]
                        - gridcell "39,308.0" [ref=f2e991]
                        - gridcell "39,308.0" [ref=f2e992]
                        - gridcell "39,308.0" [ref=f2e993]
                        - gridcell "39,308.0" [ref=f2e994]
                        - gridcell "39,308.0" [ref=f2e995]
                        - gridcell "39,308.0" [ref=f2e996]
                        - gridcell "39,308.0" [ref=f2e997]
                        - gridcell "39,308.0" [ref=f2e998]
                        - gridcell "32" [ref=f2e999]
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f2e1000]
                  - generic [aria-hidden]:
                    - gridcell [selected] [ref=f2e1001]: "81"
                    - gridcell [ref=f2e1002]: MI Michigan Holland Auto Prod
                    - gridcell [ref=f2e1003]: "A4)Assy #01"
                    - gridcell [ref=f2e1004]: P56A
                    - gridcell [ref=f2e1005]: Notching
                    - gridcell [ref=f2e1006]: Anode
                    - gridcell [ref=f2e1007]: Cathode
                    - gridcell [ref=f2e1008]: Lamination
                    - gridcell [ref=f2e1009]: Mono
                    - gridcell [ref=f2e1010]: Packaging
                    - gridcell [ref=f2e1011]: "-"
                    - gridcell [ref=f2e1012]: "A4)Assy #02"
                    - gridcell [ref=f2e1013]: E71A
                    - gridcell [ref=f2e1014]: Notching
                    - gridcell [ref=f2e1015]: Anode
                    - gridcell [ref=f2e1016]: Cathode
                    - gridcell [ref=f2e1017]: Lamination
                    - gridcell [ref=f2e1018]: Mono
                    - gridcell [ref=f2e1019]: Packaging
                    - gridcell [ref=f2e1020]: "-"
                    - gridcell [ref=f2e1021]: MI Michigan LS Auto/ESS Prod
                    - gridcell [ref=f2e1022]: "DUM_LS_A01_Assy #01"
                    - gridcell [ref=f2e1023]: E79C
                    - gridcell [ref=f2e1024]: Notching
                    - gridcell [ref=f2e1025]: Anode
                    - gridcell [ref=f2e1026]: Lamination
                    - gridcell [ref=f2e1027]: Mono
                    - gridcell [ref=f2e1028]: "DUM_LS_A02_Assy #02"
                    - gridcell [ref=f2e1029]: E79C
                    - gridcell [ref=f2e1030]: Notching
                    - gridcell [ref=f2e1031]: Anode
                    - gridcell [ref=f2e1032]: "DUM_LS_A03_Assy #03"
                    - gridcell [ref=f2e1033]: E79C
                    - gridcell [ref=f2e1034]: Notching
                    - gridcell [ref=f2e1035]: Anode
                    - gridcell [ref=f2e1036]: "DUM_LS_A04_Assy #04"
                    - gridcell [ref=f2e1037]: E79C
                    - gridcell [ref=f2e1038]: Notching
                    - gridcell [ref=f2e1039]: Anode
                    - gridcell [ref=f2e1040]: "DUM_LS_A05_Assy #05"
                    - gridcell [ref=f2e1041]: E79C
                    - gridcell [ref=f2e1042]: Notching
                    - gridcell [ref=f2e1043]: Anode
                    - gridcell [ref=f2e1044]: "DUM_LS_A06_Assy #06"
                    - gridcell [ref=f2e1045]: E79C
                    - gridcell [ref=f2e1046]: Notching
                    - gridcell [ref=f2e1047]: Anode
                    - gridcell [ref=f2e1048]: "DUM_LS_A07_Assy #07"
                    - gridcell [ref=f2e1049]: E79C
                    - gridcell [ref=f2e1050]: Notching
                    - gridcell [ref=f2e1051]: Anode
                    - gridcell [ref=f2e1052]: "DUM_LS_A08_Assy #08"
                    - gridcell [ref=f2e1053]: E79C
                    - gridcell [ref=f2e1054]: Notching
                    - gridcell [ref=f2e1055]: Anode
                    - gridcell [ref=f2e1056]: "DUM_LS_A09_Assy #09-1"
                    - gridcell [ref=f2e1057]: E79C
                    - gridcell [ref=f2e1058]: Notching
                    - gridcell [ref=f2e1059]: Anode
                    - gridcell [ref=f2e1060]: NA Nanjing Auto Prod
                    - gridcell [ref=f2e1061]: "Assy #01"
                    - gridcell [ref=f2e1062]: P2.7
                    - gridcell [ref=f2e1063]: Stacking & Folding
                    - gridcell [ref=f2e1064]: Folding
                    - gridcell [ref=f2e1065]: P30B
                    - gridcell [ref=f2e1066]: Stacking & Folding
                    - gridcell [ref=f2e1067]: Folding
                    - gridcell [ref=f2e1068]: P34
                    - gridcell [ref=f2e1069]: Stacking & Folding
                    - gridcell [ref=f2e1070]: Folding
                    - gridcell [ref=f2e1071]: "Assy #02"
                    - gridcell [ref=f2e1072]: H07B
                    - gridcell [ref=f2e1073]: Packaging
                    - gridcell [ref=f2e1074]: "-"
                    - gridcell [ref=f2e1075]: K4
                    - gridcell [ref=f2e1076]: Notching
                    - gridcell [ref=f2e1077]: Anode
                    - gridcell [ref=f2e1078]: Cathode
                    - gridcell [ref=f2e1079]: Lamination
                    - gridcell [ref=f2e1080]: A
                    - gridcell [ref=f2e1081]: C
                    - gridcell [ref=f2e1082]: Stacking & Folding
                    - gridcell [ref=f2e1083]: Folding
                    - gridcell [ref=f2e1084]: Packaging
                    - gridcell [ref=f2e1085]: "-"
                    - gridcell [ref=f2e1086]: LV9.8A
                    - gridcell [ref=f2e1087]: Packaging
                    - gridcell [ref=f2e1088]: "-"
                    - gridcell [ref=f2e1089]: "Assy #03"
                    - gridcell [ref=f2e1090]: LV15A
                    - gridcell [ref=f2e1091]: Formation
                    - gridcell [ref=f2e1092]: "-"
                    - gridcell [ref=f2e1093]: LV15B
                    - gridcell [ref=f2e1094]: Formation
                    - gridcell [ref=f2e1095]: "-"
                    - gridcell [ref=f2e1096]: "Assy #04"
                    - gridcell [ref=f2e1097]: H5.5A
                    - gridcell [ref=f2e1098]: Packaging
                    - gridcell [ref=f2e1099]: "-"
                  - generic [ref=f2e1100]:
                    - generic:
                      - row "1"
                      - row "2"
                      - row "3"
                      - row "4"
                      - row "5"
                      - row "6"
                      - row "7"
                      - row "8"
                      - row "9"
                      - row "10"
                      - row "11"
                      - row "12"
                      - row "13"
                      - row "14"
                      - row "15"
                      - row "16"
                      - row "17"
                      - row "18"
                      - row "19"
                      - row "20"
                      - row "21"
                      - row "22"
                      - row "23"
                      - row "24"
                      - row "25"
                      - row "26"
                      - row "27"
                      - row "28"
                      - row "29"
                      - row "30"
                      - row "31"
                      - row "32"
                  - generic [ref=f2e1101]:
                    - generic:
                      - row "No"
                - generic [ref=f2e1102]:
                  - status
                  - generic [ref=f2e1103]: "0"
            - alert [ref=f2e1104]:
              - generic [ref=f2e1105] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1108] [cursor=pointer]:
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
      |                                                                                                                                   ^ Error: 조회조건 판정 불가(ERROR) 2: Operation, Line Type
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