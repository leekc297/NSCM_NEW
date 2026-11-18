# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SCP0111.smoke.spec.ts >> SCP0111 IntegrationPSI 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SCP0111.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Qty ＜ 0' (Checkbox) — 후보 [Qty ＜ 0 | Qty ≥ 0]

expect(received).toBeTruthy()

Received: false
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/SCP0111
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SCP0111
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SCP0111
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SCP0111
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SCP0111
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SCP0111
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SCP0111
      - generic [ref=f2e17]:
        - button "KOR" [ref=f2e19] [cursor=pointer]
        - button "이 이민용" [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 이
          - generic [ref=f2e29]: 이민용
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Supply
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e42]: Supply Master
            - link "Line Master":
              - /url: /view/SCP0111
              - paragraph [ref=f2e45] [cursor=pointer]: Line Master
            - link "Project Route":
              - /url: /view/SCP0111
              - paragraph [ref=f2e46] [cursor=pointer]: Project Route
            - link "BOD":
              - /url: /view/SCP0111
              - paragraph [ref=f2e47] [cursor=pointer]: BOD
            - link "Plant Site":
              - /url: /view/SCP0111
              - paragraph [ref=f2e48] [cursor=pointer]: Plant Site
            - link "Production Plan":
              - /url: /view/SCP0111
              - paragraph [ref=f2e49] [cursor=pointer]: Production Plan
            - link "Work Calendar(OSP)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e50] [cursor=pointer]: Work Calendar(OSP)
            - link "Tact Time(OSP)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e51] [cursor=pointer]: Tact Time(OSP)
            - link "Formation":
              - /url: /view/SCP0111
              - paragraph [ref=f2e52] [cursor=pointer]: Formation
            - link "Outsourcing Capacity":
              - /url: /view/SCP0111
              - paragraph [ref=f2e53] [cursor=pointer]: Outsourcing Capacity
            - link "BOD ITEM":
              - /url: /view/SCP0111
              - paragraph [ref=f2e54] [cursor=pointer]: BOD ITEM
            - link "Master Validation":
              - /url: /view/SCP0111
              - paragraph [ref=f2e55] [cursor=pointer]: Master Validation
            - link "Stock OSP":
              - /url: /view/SCP0111
              - paragraph [ref=f2e56] [cursor=pointer]: Stock OSP
            - link "ProjectRoute(Electrode)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e57] [cursor=pointer]: ProjectRoute(Electrode)
            - link "ProjectRoute(Warranty)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e58] [cursor=pointer]: ProjectRoute(Warranty)
            - link "CAPA":
              - /url: /view/SCP0111
              - paragraph [ref=f2e59] [cursor=pointer]: CAPA
            - link "SCP BOM (Cell~Pack)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e60] [cursor=pointer]: SCP BOM (Cell~Pack)
            - link "Model Code Master":
              - /url: /view/SCP0111
              - paragraph [ref=f2e61] [cursor=pointer]: Model Code Master
            - link "MDM Class Master":
              - /url: /view/SCP0111
              - paragraph [ref=f2e62] [cursor=pointer]: MDM Class Master
            - link "Shipment Working Day(OSP)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e63] [cursor=pointer]: Shipment Working Day(OSP)
            - link "SCP BOM(Elec)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e64] [cursor=pointer]: SCP BOM(Elec)
            - link "CAPA (Mobility IT)":
              - /url: /view/SCP0111
              - paragraph [ref=f2e65] [cursor=pointer]: CAPA (Mobility IT)
            - link "Demand Group Master":
              - /url: /view/SCP0111
              - paragraph [ref=f2e66] [cursor=pointer]: Demand Group Master
            - link "Operation LT":
              - /url: /view/SCP0111
              - paragraph [ref=f2e67] [cursor=pointer]: Operation LT
          - generic [ref=f2e68]:
            - link [ref=f2e69] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e70]: Supply Plan
            - link [ref=f2e73] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e74]: Plan Management
            - link [ref=f2e75] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e76]: Shipment Plan FG
            - link [ref=f2e77] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e78]: Shipment Plan SEMI
            - link [ref=f2e79] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e80]: Production Plan Line
            - link [ref=f2e81] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e82]: Production Plan Fix
            - link [ref=f2e83] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e84]: Shipment Plan Fix
            - link [ref=f2e85] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e86]: Global PSI
            - link [ref=f2e87] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e88]: Global PSI Elec
            - link [ref=f2e89] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e90]: Global PSI New
            - link [ref=f2e91] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e92]: Integration PSI
          - generic [ref=f2e93]:
            - link [ref=f2e94] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e95]: Validation
            - link "Intransit Inventory":
              - /url: /view/SCP0111
              - paragraph [ref=f2e98] [cursor=pointer]: Intransit Inventory
          - generic [ref=f2e99]:
            - link [ref=f2e100] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e101]: Capa Plan
            - link "CAPA LineMaster":
              - /url: /view/SCP0111
              - paragraph [ref=f2e104] [cursor=pointer]: CAPA LineMaster
            - link "Line Assign":
              - /url: /view/SCP0111
              - paragraph [ref=f2e105] [cursor=pointer]: Line Assign
            - link "Speed Plan":
              - /url: /view/SCP0111
              - paragraph [ref=f2e106] [cursor=pointer]: Speed Plan
            - link "Loss Plan":
              - /url: /view/SCP0111
              - paragraph [ref=f2e107] [cursor=pointer]: Loss Plan
            - link "LOB Report":
              - /url: /view/SCP0111
              - paragraph [ref=f2e108] [cursor=pointer]: LOB Report
            - link "TEEP Report":
              - /url: /view/SCP0111
              - paragraph [ref=f2e109] [cursor=pointer]: TEEP Report
          - generic [ref=f2e110]:
            - link [ref=f2e111] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e112]: OPT Plan
            - link "Plan Control":
              - /url: /view/SCP0111
              - paragraph [ref=f2e115] [cursor=pointer]: Plan Control
            - link "OPT CAPA":
              - /url: /view/SCP0111
              - paragraph [ref=f2e116] [cursor=pointer]: OPT CAPA
            - link "Workbench":
              - /url: /view/SCP0111
              - paragraph [ref=f2e117] [cursor=pointer]: Workbench
            - link "Constraint Mgmt":
              - /url: /view/SCP0111
              - paragraph [ref=f2e118] [cursor=pointer]: Constraint Mgmt
            - link "Plan Group Master":
              - /url: /view/SCP0111
              - paragraph [ref=f2e119] [cursor=pointer]: Plan Group Master
            - link "Plan Activity Mgmt":
              - /url: /view/SCP0111
              - paragraph [ref=f2e120] [cursor=pointer]: Plan Activity Mgmt
            - link "Plan Group Dashboard":
              - /url: /view/SCP0111
              - paragraph [ref=f2e121] [cursor=pointer]: Plan Group Dashboard
            - link "Precede/Safety Stock Day":
              - /url: /view/SCP0111
              - paragraph [ref=f2e122] [cursor=pointer]: Precede/Safety Stock Day
            - link "Precede/Safety Stock Qty":
              - /url: /view/SCP0111
              - paragraph [ref=f2e123] [cursor=pointer]: Precede/Safety Stock Qty
            - link "Demand Exception":
              - /url: /view/SCP0111
              - paragraph [ref=f2e124] [cursor=pointer]: Demand Exception
            - link "Scheduled Receipt Information":
              - /url: /view/SCP0111
              - paragraph [ref=f2e125] [cursor=pointer]: Scheduled Receipt Information
            - link "Sales Site Priority":
              - /url: /view/SCP0111
              - paragraph [ref=f2e126] [cursor=pointer]: Sales Site Priority
            - link "Constraint Of Shipment Qty":
              - /url: /view/SCP0111
              - paragraph [ref=f2e127] [cursor=pointer]: Constraint Of Shipment Qty
            - link "Warehouse Capacity":
              - /url: /view/SCP0111
              - paragraph [ref=f2e128] [cursor=pointer]: Warehouse Capacity
          - generic [ref=f2e129]:
            - link [ref=f2e130] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e131]: Waterfall
            - link "Shipment Plan FG Waterfall":
              - /url: /view/SCP0111
              - paragraph [ref=f2e134] [cursor=pointer]: Shipment Plan FG Waterfall
            - link "Production Plan Waterfall":
              - /url: /view/SCP0111
              - paragraph [ref=f2e135] [cursor=pointer]: Production Plan Waterfall
            - link "Shipment Plan Semi Waterfall":
              - /url: /view/SCP0111
              - paragraph [ref=f2e136] [cursor=pointer]: Shipment Plan Semi Waterfall
          - generic [ref=f2e137]:
            - link [ref=f2e138] [cursor=pointer]:
              - /url: /view/SCP0111
              - paragraph [ref=f2e139]: SCM Supply
            - link "Shipment(Allo) Report":
              - /url: /view/SCP0111
              - paragraph [ref=f2e142] [cursor=pointer]: Shipment(Allo) Report
            - link "Long-term stock":
              - /url: /view/SCP0111
              - paragraph [ref=f2e143] [cursor=pointer]: Long-term stock
            - link "Ending Inventory":
              - /url: /view/SCP0111
              - paragraph [ref=f2e144] [cursor=pointer]: Ending Inventory
            - link "Inventory Trend":
              - /url: /view/SCP0111
              - paragraph [ref=f2e145] [cursor=pointer]: Inventory Trend
      - main [ref=f2e146]:
        - generic [ref=f2e148]:
          - generic [ref=f2e149]:
            - generic [ref=f2e150]:
              - button "Home" [ref=f2e151] [cursor=pointer]
              - button "Integration PSI" [ref=f2e153] [cursor=pointer]
            - generic [ref=f2e158]:
              - button "Scroll tabs left" [disabled] [ref=f2e159]
              - button "Scroll tabs right" [disabled] [ref=f2e162]
              - button "Close others" [ref=f2e165] [cursor=pointer]
              - button "Close All" [ref=f2e166] [cursor=pointer]
          - generic [ref=f2e167]:
            - generic [ref=f2e170]:
              - generic [ref=f2e172]:
                - generic [ref=f2e173]:
                  - img [aria-hidden] [ref=f2e175] [cursor=pointer]
                  - paragraph [ref=f2e178]: Integration PSI
                - generic [ref=f2e179]:
                  - generic [ref=f2e180]: Supply
                  - generic [ref=f2e185]: Supply Plan
                  - generic [ref=f2e190]: Integration PSI
                - generic [ref=f2e192]:
                  - generic [ref=f2e193]: Search Area
                  - switch [checked] [ref=f2e196] [cursor=pointer]
                - button "Full screen" [ref=f2e199] [cursor=pointer]
              - generic [ref=f2e209]:
                - generic [ref=f2e210]:
                  - generic [ref=f2e212]:
                    - generic [ref=f2e213]: Div
                    - generic [ref=f2e223]:
                      - combobox [ref=f2e224]: 40 Mobility & IT Battery
                      - button "Open" [ref=f2e226] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e231]:
                    - generic [ref=f2e232]: Model/Nickname
                    - generic [ref=f2e238]:
                      - textbox [ref=f2e239]
                      - button [ref=f2e240] [cursor=pointer]
                  - generic [ref=f2e246]:
                    - generic [ref=f2e247]: Cell Model
                    - textbox [ref=f2e254]
                  - generic [ref=f2e256]:
                    - generic [ref=f2e257]: Plan Date
                    - generic [ref=f2e267]:
                      - combobox [ref=f2e268]: 2026-10-26 (W44)
                      - button "Open" [ref=f2e270] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e275]:
                    - generic [ref=f2e276]: Period
                    - generic [ref=f2e281]:
                      - generic [ref=f2e282] [cursor=pointer]: "2026.10"
                      - generic [ref=f2e292]: ~
                      - generic [ref=f2e293] [cursor=pointer]: "2027.03"
                  - generic [ref=f2e308] [cursor=pointer]:
                    - checkbox "Qty < 0" [ref=f2e310]
                    - generic [ref=f2e311]: Qty < 0
                - button [active] [ref=f2e313] [cursor=pointer]
              - generic [ref=f2e318]:
                - generic [ref=f2e319]:
                  - paragraph
                  - generic [ref=f2e320]: 총1,898건
                - generic [ref=f2e321]:
                  - generic "Insert Row" [ref=f2e322]:
                    - button [ref=f2e323] [cursor=pointer]
                  - generic "Remove" [ref=f2e328]:
                    - button [ref=f2e329] [cursor=pointer]
                  - generic "Save" [ref=f2e336]:
                    - button [ref=f2e337] [cursor=pointer]
                  - generic "Sort" [ref=f2e341]:
                    - button [ref=f2e342] [cursor=pointer]
                  - generic "Filter" [ref=f2e347]:
                    - button [ref=f2e348] [cursor=pointer]
                  - generic "Condition" [ref=f2e353]:
                    - button [ref=f2e354] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e364]:
                    - button [ref=f2e365] [cursor=pointer]
                  - generic "Excel" [ref=f2e372]:
                    - button [ref=f2e373] [cursor=pointer]
              - generic [ref=f2e381]:
                - grid [ref=f2e382]:
                  - rowgroup [ref=f2e383]:
                    - generic:
                      - row "Plan Type Div Operation Cell Model Nick Name Cell Model Nick Name Model Cell Coversion Factor Company Plant Measure To Product Valuation Type Line To Site Incoterms BOH UOM SEQ_FLAG MEASURE No":
                        - columnheader "Plan Type" [ref=f2e384]
                        - columnheader "Div" [ref=f2e385]
                        - columnheader "Operation" [ref=f2e386]
                        - columnheader "Cell Model Nick Name" [ref=f2e387]
                        - columnheader "Cell Model" [ref=f2e388]
                        - columnheader "Nick Name" [ref=f2e389]
                        - columnheader "Model" [ref=f2e390]
                        - columnheader "Cell Coversion Factor" [ref=f2e391]
                        - columnheader "Company" [ref=f2e392]
                        - columnheader "Plant" [ref=f2e393]
                        - columnheader "Measure" [ref=f2e394]
                        - columnheader "To Product" [ref=f2e395]
                        - columnheader "Valuation Type" [ref=f2e396]
                        - columnheader "Line" [ref=f2e397]
                        - columnheader "To Site" [ref=f2e398]
                        - columnheader "Incoterms" [ref=f2e399]
                        - columnheader "BOH" [ref=f2e400]
                        - columnheader "UOM" [ref=f2e401]
                        - columnheader "SEQ_FLAG" [ref=f2e402]
                        - columnheader "MEASURE" [ref=f2e403]
                        - gridcell "No" [ref=f2e404]
                        - gridcell [ref=f2e405]
                  - rowgroup [ref=f2e406]:
                    - generic [ref=f2e407]:
                      - row "FN 40 Pack C4 MCCE127501B1 MPCHPPHS042C 4.000000 - - MKT FCST - - - acer_CN_CKG DAP 0 EA 100 MKT_FCST 1":
                        - gridcell "FN" [selected] [ref=f2e408]
                        - gridcell "40" [ref=f2e409]
                        - gridcell "Pack" [ref=f2e410]
                        - gridcell "C4" [ref=f2e411]
                        - gridcell "MCCE127501B1" [ref=f2e412]
                        - gridcell [ref=f2e413]
                        - gridcell "MPCHPPHS042C" [ref=f2e414]
                        - gridcell "4.000000" [ref=f2e415]
                        - gridcell "-" [ref=f2e416]
                        - gridcell "-" [ref=f2e417]
                        - gridcell "MKT FCST" [ref=f2e418]
                        - gridcell "-" [ref=f2e419]
                        - gridcell "-" [ref=f2e420]
                        - gridcell "-" [ref=f2e421]
                        - gridcell "acer_CN_CKG" [ref=f2e422]
                        - gridcell "DAP" [ref=f2e423]
                        - gridcell "0" [ref=f2e424]
                        - gridcell "EA" [ref=f2e425]
                        - gridcell "100" [ref=f2e426]
                        - gridcell "MKT_FCST" [ref=f2e427]
                        - gridcell "1" [ref=f2e428]
                        - gridcell [ref=f2e429]
                      - row "Cell E1T MCCE130705A4-M07 E1T MCCE130705A4-M07 1.000000 - - MKT FCST - - - IM_US_SPK FCA 0 EA 300 MKT_FCST 2":
                        - gridcell "Cell" [ref=f2e430]
                        - gridcell "E1T" [ref=f2e431]
                        - gridcell "MCCE130705A4-M07" [ref=f2e432]
                        - gridcell "E1T" [ref=f2e433]
                        - gridcell "MCCE130705A4-M07" [ref=f2e434]
                        - gridcell "1.000000" [ref=f2e435]
                        - gridcell "-" [ref=f2e436]
                        - gridcell "-" [ref=f2e437]
                        - gridcell "MKT FCST" [ref=f2e438]
                        - gridcell "-" [ref=f2e439]
                        - gridcell "-" [ref=f2e440]
                        - gridcell "-" [ref=f2e441]
                        - gridcell "IM_US_SPK" [ref=f2e442]
                        - gridcell "FCA" [ref=f2e443]
                        - gridcell "0" [ref=f2e444]
                        - gridcell "EA" [ref=f2e445]
                        - gridcell "300" [ref=f2e446]
                        - gridcell "MKT_FCST" [ref=f2e447]
                        - gridcell "2" [ref=f2e448]
                        - gridcell [ref=f2e449]
                      - row "NJ00 NJ01 Prod Plan - - - - - 0 EA 350 PROD_PLAN 3":
                        - gridcell "NJ00" [ref=f2e450]
                        - gridcell "NJ01" [ref=f2e451]
                        - gridcell "Prod Plan" [ref=f2e452]
                        - gridcell "-" [ref=f2e453]
                        - gridcell "-" [ref=f2e454]
                        - gridcell "-" [ref=f2e455]
                        - gridcell "-" [ref=f2e456]
                        - gridcell "-" [ref=f2e457]
                        - gridcell "0" [ref=f2e458]
                        - gridcell "EA" [ref=f2e459]
                        - gridcell "350" [ref=f2e460]
                        - gridcell "PROD_PLAN" [ref=f2e461]
                        - gridcell "3" [ref=f2e462]
                        - gridcell [ref=f2e463]
                      - row "Inv. - - - - - 0 EA 360 INV 4":
                        - gridcell "Inv." [ref=f2e464]
                        - gridcell "-" [ref=f2e465]
                        - gridcell "-" [ref=f2e466]
                        - gridcell "-" [ref=f2e467]
                        - gridcell "-" [ref=f2e468]
                        - gridcell "-" [ref=f2e469]
                        - gridcell "0" [ref=f2e470]
                        - gridcell "EA" [ref=f2e471]
                        - gridcell "360" [ref=f2e472]
                        - gridcell "INV" [ref=f2e473]
                        - gridcell "4" [ref=f2e474]
                        - gridcell [ref=f2e475]
                      - row "MACE130705A4-M07 1.000000 NJ00 NJ01 In-house Moving MCCE130705A4-M07 - - NJ01 - 0 EA 430 IN_HOUSE_MOVING 5":
                        - gridcell "MACE130705A4-M07" [ref=f2e476]
                        - gridcell "1.000000" [ref=f2e477]
                        - gridcell "NJ00" [ref=f2e478]
                        - gridcell "NJ01" [ref=f2e479]
                        - gridcell "In-house Moving" [ref=f2e480]
                        - gridcell "MCCE130705A4-M07" [ref=f2e481]
                        - gridcell "-" [ref=f2e482]
                        - gridcell "-" [ref=f2e483]
                        - gridcell "NJ01" [ref=f2e484]
                        - gridcell "-" [ref=f2e485]
                        - gridcell "0" [ref=f2e486]
                        - gridcell "EA" [ref=f2e487]
                        - gridcell "430" [ref=f2e488]
                        - gridcell "IN_HOUSE_MOVING" [ref=f2e489]
                        - gridcell "5" [ref=f2e490]
                        - gridcell [ref=f2e491]
                      - row "Prod Plan - - M7C04 - - 0 EA 450 PROD_PLAN 6":
                        - gridcell "Prod Plan" [ref=f2e492]
                        - gridcell "-" [ref=f2e493]
                        - gridcell "-" [ref=f2e494]
                        - gridcell "M7C04" [ref=f2e495]
                        - gridcell "-" [ref=f2e496]
                        - gridcell "-" [ref=f2e497]
                        - gridcell "0" [ref=f2e498]
                        - gridcell "EA" [ref=f2e499]
                        - gridcell "450" [ref=f2e500]
                        - gridcell "PROD_PLAN" [ref=f2e501]
                        - gridcell "6" [ref=f2e502]
                        - gridcell [ref=f2e503]
                      - row "Inv. - - - - - 0 EA 460 INV 7":
                        - gridcell "Inv." [ref=f2e504]
                        - gridcell "-" [ref=f2e505]
                        - gridcell "-" [ref=f2e506]
                        - gridcell "-" [ref=f2e507]
                        - gridcell "-" [ref=f2e508]
                        - gridcell "-" [ref=f2e509]
                        - gridcell "0" [ref=f2e510]
                        - gridcell "EA" [ref=f2e511]
                        - gridcell "460" [ref=f2e512]
                        - gridcell "INV" [ref=f2e513]
                        - gridcell "7" [ref=f2e514]
                        - gridcell [ref=f2e515]
                      - row "Pack H15 MCCH114030D3 GM GEN12 MPCLGEGM121G 1.000000 - - MKT FCST - - - LGE_VN_HAP DAP 0 EA 100 MKT_FCST 8":
                        - gridcell "Pack" [ref=f2e516]
                        - gridcell "H15" [ref=f2e517]
                        - gridcell "MCCH114030D3" [ref=f2e518]
                        - gridcell "GM GEN12" [ref=f2e519]
                        - gridcell "MPCLGEGM121G" [ref=f2e520]
                        - gridcell "1.000000" [ref=f2e521]
                        - gridcell "-" [ref=f2e522]
                        - gridcell "-" [ref=f2e523]
                        - gridcell "MKT FCST" [ref=f2e524]
                        - gridcell "-" [ref=f2e525]
                        - gridcell "-" [ref=f2e526]
                        - gridcell "-" [ref=f2e527]
                        - gridcell "LGE_VN_HAP" [ref=f2e528]
                        - gridcell "DAP" [ref=f2e529]
                        - gridcell "0" [ref=f2e530]
                        - gridcell "EA" [ref=f2e531]
                        - gridcell "100" [ref=f2e532]
                        - gridcell "MKT_FCST" [ref=f2e533]
                        - gridcell "8" [ref=f2e534]
                        - gridcell [ref=f2e535]
                      - row "HQ00 DONGHWAES_KR Ship. Plan(RTF) - - - LGE_VN_HAP DAP 0 EA 110 SHIP_PLAN_RTF 9":
                        - gridcell "HQ00" [ref=f2e536]
                        - gridcell "DONGHWAES_KR" [ref=f2e537]
                        - gridcell "Ship. Plan(RTF)" [ref=f2e538]
                        - gridcell "-" [ref=f2e539]
                        - gridcell "-" [ref=f2e540]
                        - gridcell "-" [ref=f2e541]
                        - gridcell "LGE_VN_HAP" [ref=f2e542]
                        - gridcell "DAP" [ref=f2e543]
                        - gridcell "0" [ref=f2e544]
                        - gridcell "EA" [ref=f2e545]
                        - gridcell "110" [ref=f2e546]
                        - gridcell "SHIP_PLAN_RTF" [ref=f2e547]
                        - gridcell "9" [ref=f2e548]
                        - gridcell [ref=f2e549]
                      - row "Prod Plan - - - - - 0 EA 150 PROD_PLAN 10":
                        - gridcell "Prod Plan" [ref=f2e550]
                        - gridcell "-" [ref=f2e551]
                        - gridcell "-" [ref=f2e552]
                        - gridcell "-" [ref=f2e553]
                        - gridcell "-" [ref=f2e554]
                        - gridcell "-" [ref=f2e555]
                        - gridcell "0" [ref=f2e556]
                        - gridcell "EA" [ref=f2e557]
                        - gridcell "150" [ref=f2e558]
                        - gridcell "PROD_PLAN" [ref=f2e559]
                        - gridcell "10" [ref=f2e560]
                        - gridcell [ref=f2e561]
                      - row "Inv. - - - - - 0 EA 160 INV 11":
                        - gridcell "Inv." [ref=f2e562]
                        - gridcell "-" [ref=f2e563]
                        - gridcell "-" [ref=f2e564]
                        - gridcell "-" [ref=f2e565]
                        - gridcell "-" [ref=f2e566]
                        - gridcell "-" [ref=f2e567]
                        - gridcell "0" [ref=f2e568]
                        - gridcell "EA" [ref=f2e569]
                        - gridcell "160" [ref=f2e570]
                        - gridcell "INV" [ref=f2e571]
                        - gridcell "11" [ref=f2e572]
                        - gridcell [ref=f2e573]
                      - row "LGE TOYOTA DCM MPCLGE19CY1M 1.000000 HQ00 ITM_KR_VN Prod Plan - - - - - 0 EA 150 PROD_PLAN 12":
                        - gridcell "LGE TOYOTA DCM" [ref=f2e574]
                        - gridcell "MPCLGE19CY1M" [ref=f2e575]
                        - gridcell "1.000000" [ref=f2e576]
                        - gridcell "HQ00" [ref=f2e577]
                        - gridcell "ITM_KR_VN" [ref=f2e578]
                        - gridcell "Prod Plan" [ref=f2e579]
                        - gridcell "-" [ref=f2e580]
                        - gridcell "-" [ref=f2e581]
                        - gridcell "-" [ref=f2e582]
                        - gridcell "-" [ref=f2e583]
                        - gridcell "-" [ref=f2e584]
                        - gridcell "0" [ref=f2e585]
                        - gridcell "EA" [ref=f2e586]
                        - gridcell "150" [ref=f2e587]
                        - gridcell "PROD_PLAN" [ref=f2e588]
                        - gridcell "12" [ref=f2e589]
                        - gridcell [ref=f2e590]
                      - row "Inv. - - - - - 0 EA 160 INV 13":
                        - gridcell "Inv." [ref=f2e591]
                        - gridcell "-" [ref=f2e592]
                        - gridcell "-" [ref=f2e593]
                        - gridcell "-" [ref=f2e594]
                        - gridcell "-" [ref=f2e595]
                        - gridcell "-" [ref=f2e596]
                        - gridcell "0" [ref=f2e597]
                        - gridcell "EA" [ref=f2e598]
                        - gridcell "160" [ref=f2e599]
                        - gridcell "INV" [ref=f2e600]
                        - gridcell "13" [ref=f2e601]
                        - gridcell [ref=f2e602]
                      - row "OCU3 5PIN MPCLGE5PIN1M 2.000000 HQ00 DONGHWAES_KR Prod Plan - - - - - 0 EA 150 PROD_PLAN 14":
                        - gridcell "OCU3 5PIN" [ref=f2e603]
                        - gridcell "MPCLGE5PIN1M" [ref=f2e604]
                        - gridcell "2.000000" [ref=f2e605]
                        - gridcell "HQ00" [ref=f2e606]
                        - gridcell "DONGHWAES_KR" [ref=f2e607]
                        - gridcell "Prod Plan" [ref=f2e608]
                        - gridcell "-" [ref=f2e609]
                        - gridcell "-" [ref=f2e610]
                        - gridcell "-" [ref=f2e611]
                        - gridcell "-" [ref=f2e612]
                        - gridcell "-" [ref=f2e613]
                        - gridcell "0" [ref=f2e614]
                        - gridcell "EA" [ref=f2e615]
                        - gridcell "150" [ref=f2e616]
                        - gridcell "PROD_PLAN" [ref=f2e617]
                        - gridcell "14" [ref=f2e618]
                        - gridcell [ref=f2e619]
                      - row "Inv. - - - - - 0 EA 160 INV 15":
                        - gridcell "Inv." [ref=f2e620]
                        - gridcell "-" [ref=f2e621]
                        - gridcell "-" [ref=f2e622]
                        - gridcell "-" [ref=f2e623]
                        - gridcell "-" [ref=f2e624]
                        - gridcell "-" [ref=f2e625]
                        - gridcell "0" [ref=f2e626]
                        - gridcell "EA" [ref=f2e627]
                        - gridcell "160" [ref=f2e628]
                        - gridcell "INV" [ref=f2e629]
                        - gridcell "15" [ref=f2e630]
                        - gridcell [ref=f2e631]
                      - row "Cell H15 MCCH114030D3 H15 MCCH114030D3 1.000000 HQ00 HQ06 Ship. Plan(Semi) - - - DONGHWAES_KR DAP 0 EA 320 SHIP_PLAN_SEMI 16":
                        - gridcell "Cell" [ref=f2e632]
                        - gridcell "H15" [ref=f2e633]
                        - gridcell "MCCH114030D3" [ref=f2e634]
                        - gridcell "H15" [ref=f2e635]
                        - gridcell "MCCH114030D3" [ref=f2e636]
                        - gridcell "1.000000" [ref=f2e637]
                        - gridcell "HQ00" [ref=f2e638]
                        - gridcell "HQ06" [ref=f2e639]
                        - gridcell "Ship. Plan(Semi)" [ref=f2e640]
                        - gridcell "-" [ref=f2e641]
                        - gridcell "-" [ref=f2e642]
                        - gridcell "-" [ref=f2e643]
                        - gridcell "DONGHWAES_KR" [ref=f2e644]
                        - gridcell "DAP" [ref=f2e645]
                        - gridcell "0" [ref=f2e646]
                        - gridcell "EA" [ref=f2e647]
                        - gridcell "320" [ref=f2e648]
                        - gridcell "SHIP_PLAN_SEMI" [ref=f2e649]
                        - gridcell "16" [ref=f2e650]
                        - gridcell [ref=f2e651]
                      - row "ITM_KR_VN CIF 0 EA 320 SHIP_PLAN_SEMI 17":
                        - gridcell "ITM_KR_VN" [ref=f2e652]
                        - gridcell "CIF" [ref=f2e653]
                        - gridcell "0" [ref=f2e654]
                        - gridcell "EA" [ref=f2e655]
                        - gridcell "320" [ref=f2e656]
                        - gridcell "SHIP_PLAN_SEMI" [ref=f2e657]
                        - gridcell "17" [ref=f2e658]
                        - gridcell [ref=f2e659]
                      - row "Prod Plan - - - - - 0 EA 350 PROD_PLAN 18":
                        - gridcell "Prod Plan" [ref=f2e660]
                        - gridcell "-" [ref=f2e661]
                        - gridcell "-" [ref=f2e662]
                        - gridcell "-" [ref=f2e663]
                        - gridcell "-" [ref=f2e664]
                        - gridcell "-" [ref=f2e665]
                        - gridcell "0" [ref=f2e666]
                        - gridcell "EA" [ref=f2e667]
                        - gridcell "350" [ref=f2e668]
                        - gridcell "PROD_PLAN" [ref=f2e669]
                        - gridcell "18" [ref=f2e670]
                        - gridcell [ref=f2e671]
                      - row "Inv. - - - - - 0 EA 360 INV 19":
                        - gridcell "Inv." [ref=f2e672]
                        - gridcell "-" [ref=f2e673]
                        - gridcell "-" [ref=f2e674]
                        - gridcell "-" [ref=f2e675]
                        - gridcell "-" [ref=f2e676]
                        - gridcell "-" [ref=f2e677]
                        - gridcell "0" [ref=f2e678]
                        - gridcell "EA" [ref=f2e679]
                        - gridcell "360" [ref=f2e680]
                        - gridcell "INV" [ref=f2e681]
                        - gridcell "19" [ref=f2e682]
                        - gridcell [ref=f2e683]
                      - row "MACH114030D3 1.000000 HQ00 HQ06 In-house Moving MCCH114030D3 - - HQ06 - 0 EA 430 IN_HOUSE_MOVING 20":
                        - gridcell "MACH114030D3" [ref=f2e684]
                        - gridcell "1.000000" [ref=f2e685]
                        - gridcell "HQ00" [ref=f2e686]
                        - gridcell "HQ06" [ref=f2e687]
                        - gridcell "In-house Moving" [ref=f2e688]
                        - gridcell "MCCH114030D3" [ref=f2e689]
                        - gridcell "-" [ref=f2e690]
                        - gridcell "-" [ref=f2e691]
                        - gridcell "HQ06" [ref=f2e692]
                        - gridcell "-" [ref=f2e693]
                        - gridcell "0" [ref=f2e694]
                        - gridcell "EA" [ref=f2e695]
                        - gridcell "430" [ref=f2e696]
                        - gridcell "IN_HOUSE_MOVING" [ref=f2e697]
                        - gridcell "20" [ref=f2e698]
                        - gridcell [ref=f2e699]
                      - row "Prod Plan - - M2C07 - - 0 EA 450 PROD_PLAN 21":
                        - gridcell "Prod Plan" [ref=f2e700]
                        - gridcell "-" [ref=f2e701]
                        - gridcell "-" [ref=f2e702]
                        - gridcell "M2C07" [ref=f2e703]
                        - gridcell "-" [ref=f2e704]
                        - gridcell "-" [ref=f2e705]
                        - gridcell "0" [ref=f2e706]
                        - gridcell "EA" [ref=f2e707]
                        - gridcell "450" [ref=f2e708]
                        - gridcell "PROD_PLAN" [ref=f2e709]
                        - gridcell "21" [ref=f2e710]
                        - gridcell [ref=f2e711]
                      - row "Inv. - - - - - 0 EA 460 INV 22":
                        - gridcell "Inv." [ref=f2e712]
                        - gridcell "-" [ref=f2e713]
                        - gridcell "-" [ref=f2e714]
                        - gridcell "-" [ref=f2e715]
                        - gridcell "-" [ref=f2e716]
                        - gridcell "-" [ref=f2e717]
                        - gridcell "0" [ref=f2e718]
                        - gridcell "EA" [ref=f2e719]
                        - gridcell "460" [ref=f2e720]
                        - gridcell "INV" [ref=f2e721]
                        - gridcell "22" [ref=f2e722]
                        - gridcell [ref=f2e723]
                      - row "MCCH114030D3 1.000000 HQ00 DONGHWAES_KR In-house Moving MPCLGE5PIN1M - - DONGHWAES_KR - 0 EA 330 IN_HOUSE_MOVING 23":
                        - gridcell "MCCH114030D3" [ref=f2e724]
                        - gridcell "1.000000" [ref=f2e725]
                        - gridcell "HQ00" [ref=f2e726]
                        - gridcell "DONGHWAES_KR" [ref=f2e727]
                        - gridcell "In-house Moving" [ref=f2e728]
                        - gridcell "MPCLGE5PIN1M" [ref=f2e729]
                        - gridcell "-" [ref=f2e730]
                        - gridcell "-" [ref=f2e731]
                        - gridcell "DONGHWAES_KR" [ref=f2e732]
                        - gridcell "-" [ref=f2e733]
                        - gridcell "0" [ref=f2e734]
                        - gridcell "EA" [ref=f2e735]
                        - gridcell "330" [ref=f2e736]
                        - gridcell "IN_HOUSE_MOVING" [ref=f2e737]
                        - gridcell "23" [ref=f2e738]
                        - gridcell [ref=f2e739]
                      - row "MPCLGEGM121G - - DONGHWAES_KR - 0 EA 330 IN_HOUSE_MOVING 24":
                        - gridcell "MPCLGEGM121G" [ref=f2e740]
                        - gridcell "-" [ref=f2e741]
                        - gridcell "-" [ref=f2e742]
                        - gridcell "DONGHWAES_KR" [ref=f2e743]
                        - gridcell "-" [ref=f2e744]
                        - gridcell "0" [ref=f2e745]
                        - gridcell "EA" [ref=f2e746]
                        - gridcell "330" [ref=f2e747]
                        - gridcell "IN_HOUSE_MOVING" [ref=f2e748]
                        - gridcell "24" [ref=f2e749]
                        - gridcell [ref=f2e750]
                      - row "Semi WH In - - - - - 0 EA 340 SEMI_WH_IN 25":
                        - gridcell "Semi WH In" [ref=f2e751]
                        - gridcell "-" [ref=f2e752]
                        - gridcell "-" [ref=f2e753]
                        - gridcell "-" [ref=f2e754]
                        - gridcell "-" [ref=f2e755]
                        - gridcell "-" [ref=f2e756]
                        - gridcell "0" [ref=f2e757]
                        - gridcell "EA" [ref=f2e758]
                        - gridcell "340" [ref=f2e759]
                        - gridcell "SEMI_WH_IN" [ref=f2e760]
                        - gridcell "25" [ref=f2e761]
                        - gridcell [ref=f2e762]
                      - row "Inv. - - - - - 0 EA 360 INV 26":
                        - gridcell "Inv." [ref=f2e763]
                        - gridcell "-" [ref=f2e764]
                        - gridcell "-" [ref=f2e765]
                        - gridcell "-" [ref=f2e766]
                        - gridcell "-" [ref=f2e767]
                        - gridcell "-" [ref=f2e768]
                        - gridcell "0" [ref=f2e769]
                        - gridcell "EA" [ref=f2e770]
                        - gridcell "360" [ref=f2e771]
                        - gridcell "INV" [ref=f2e772]
                        - gridcell "26" [ref=f2e773]
                        - gridcell [ref=f2e774]
                      - row "ITM_KR_VN In-house Moving MPCLGE19CY1M - - ITM_KR_VN - 0 EA 330 IN_HOUSE_MOVING 27":
                        - gridcell "ITM_KR_VN" [ref=f2e775]
                        - gridcell "In-house Moving" [ref=f2e776]
                        - gridcell "MPCLGE19CY1M" [ref=f2e777]
                        - gridcell "-" [ref=f2e778]
                        - gridcell "-" [ref=f2e779]
                        - gridcell "ITM_KR_VN" [ref=f2e780]
                        - gridcell "-" [ref=f2e781]
                        - gridcell "0" [ref=f2e782]
                        - gridcell "EA" [ref=f2e783]
                        - gridcell "330" [ref=f2e784]
                        - gridcell "IN_HOUSE_MOVING" [ref=f2e785]
                        - gridcell "27" [ref=f2e786]
                        - gridcell [ref=f2e787]
                      - row "Semi WH In - - - - - 0 EA 340 SEMI_WH_IN 28":
                        - gridcell "Semi WH In" [ref=f2e788]
                        - gridcell "-" [ref=f2e789]
                        - gridcell "-" [ref=f2e790]
                        - gridcell "-" [ref=f2e791]
                        - gridcell "-" [ref=f2e792]
                        - gridcell "-" [ref=f2e793]
                        - gridcell "0" [ref=f2e794]
                        - gridcell "EA" [ref=f2e795]
                        - gridcell "340" [ref=f2e796]
                        - gridcell "SEMI_WH_IN" [ref=f2e797]
                        - gridcell "28" [ref=f2e798]
                        - gridcell [ref=f2e799]
                      - row "Inv. - - - - - 0 EA 360 INV 29":
                        - gridcell "Inv." [ref=f2e800]
                        - gridcell "-" [ref=f2e801]
                        - gridcell "-" [ref=f2e802]
                        - gridcell "-" [ref=f2e803]
                        - gridcell "-" [ref=f2e804]
                        - gridcell "-" [ref=f2e805]
                        - gridcell "0" [ref=f2e806]
                        - gridcell "EA" [ref=f2e807]
                        - gridcell "360" [ref=f2e808]
                        - gridcell "INV" [ref=f2e809]
                        - gridcell "29" [ref=f2e810]
                        - gridcell [ref=f2e811]
                      - row "Pack H15 MCCH114030L1 GM GEN11 CNT MPCLGEGEN23G 2.000000 - - MKT FCST - - - LGE VC_CN_NKG DAP 0 EA 100 MKT_FCST 30":
                        - gridcell "Pack" [ref=f2e812]
                        - gridcell "H15" [ref=f2e813]
                        - gridcell "MCCH114030L1" [ref=f2e814]
                        - gridcell "GM GEN11 CNT" [ref=f2e815]
                        - gridcell "MPCLGEGEN23G" [ref=f2e816]
                        - gridcell "2.000000" [ref=f2e817]
                        - gridcell "-" [ref=f2e818]
                        - gridcell "-" [ref=f2e819]
                        - gridcell "MKT FCST" [ref=f2e820]
                        - gridcell "-" [ref=f2e821]
                        - gridcell "-" [ref=f2e822]
                        - gridcell "-" [ref=f2e823]
                        - gridcell "LGE VC_CN_NKG" [ref=f2e824]
                        - gridcell "DAP" [ref=f2e825]
                        - gridcell "0" [ref=f2e826]
                        - gridcell "EA" [ref=f2e827]
                        - gridcell "100" [ref=f2e828]
                        - gridcell "MKT_FCST" [ref=f2e829]
                        - gridcell "30" [ref=f2e830]
                        - gridcell [ref=f2e831]
                      - row "LGE_VN_HAP DAP 0 EA 100 MKT_FCST 31":
                        - gridcell "LGE_VN_HAP" [ref=f2e832]
                        - gridcell "DAP" [ref=f2e833]
                        - gridcell "0" [ref=f2e834]
                        - gridcell "EA" [ref=f2e835]
                        - gridcell "100" [ref=f2e836]
                        - gridcell "MKT_FCST" [ref=f2e837]
                        - gridcell "31" [ref=f2e838]
                        - gridcell [ref=f2e839]
                      - row "HQ00 DONGHWAES_KR Ship. Plan(RTF) - - - LGE VC_CN_NKG DAP 0 EA 110 SHIP_PLAN_RTF 32":
                        - gridcell "HQ00" [ref=f2e840]
                        - gridcell "DONGHWAES_KR" [ref=f2e841]
                        - gridcell "Ship. Plan(RTF)" [ref=f2e842]
                        - gridcell "-" [ref=f2e843]
                        - gridcell "-" [ref=f2e844]
                        - gridcell "-" [ref=f2e845]
                        - gridcell "LGE VC_CN_NKG" [ref=f2e846]
                        - gridcell "DAP" [ref=f2e847]
                        - gridcell "0" [ref=f2e848]
                        - gridcell "EA" [ref=f2e849]
                        - gridcell "110" [ref=f2e850]
                        - gridcell "SHIP_PLAN_RTF" [ref=f2e851]
                        - gridcell "32" [ref=f2e852]
                        - gridcell [ref=f2e853]
                      - row "LGE_VN_HAP DAP 0 EA 110 SHIP_PLAN_RTF 33":
                        - gridcell "LGE_VN_HAP" [ref=f2e854]
                        - gridcell "DAP" [ref=f2e855]
                        - gridcell "0" [ref=f2e856]
                        - gridcell "EA" [ref=f2e857]
                        - gridcell "110" [ref=f2e858]
                        - gridcell "SHIP_PLAN_RTF" [ref=f2e859]
                        - gridcell "33" [ref=f2e860]
                        - gridcell [ref=f2e861]
                      - row "Prod Plan - - - - - 0 EA 150 PROD_PLAN 34":
                        - gridcell "Prod Plan" [ref=f2e862]
                        - gridcell "-" [ref=f2e863]
                        - gridcell "-" [ref=f2e864]
                        - gridcell "-" [ref=f2e865]
                        - gridcell "-" [ref=f2e866]
                        - gridcell "-" [ref=f2e867]
                        - gridcell "0" [ref=f2e868]
                        - gridcell "EA" [ref=f2e869]
                        - gridcell "150" [ref=f2e870]
                        - gridcell "PROD_PLAN" [ref=f2e871]
                        - gridcell "34" [ref=f2e872]
                        - gridcell [ref=f2e873]
                      - row "Inv. - - - - - 0 EA 160 INV 35":
                        - gridcell "Inv." [ref=f2e874]
                        - gridcell "-" [ref=f2e875]
                        - gridcell "-" [ref=f2e876]
                        - gridcell "-" [ref=f2e877]
                        - gridcell "-" [ref=f2e878]
                        - gridcell "-" [ref=f2e879]
                        - gridcell "0" [ref=f2e880]
                        - gridcell "EA" [ref=f2e881]
                        - gridcell "160" [ref=f2e882]
                        - gridcell "INV" [ref=f2e883]
                        - gridcell "35" [ref=f2e884]
                        - gridcell [ref=f2e885]
                      - row "GM GEN11 MPCLGEGM122G 1.000000 - - MKT FCST - - - LGE_VN_HAP DAP 0 EA 100 MKT_FCST 36":
                        - gridcell "GM GEN11" [ref=f2e886]
                        - gridcell "MPCLGEGM122G" [ref=f2e887]
                        - gridcell "1.000000" [ref=f2e888]
                        - gridcell "-" [ref=f2e889]
                        - gridcell "-" [ref=f2e890]
                        - gridcell "MKT FCST" [ref=f2e891]
                        - gridcell "-" [ref=f2e892]
                        - gridcell "-" [ref=f2e893]
                        - gridcell "-" [ref=f2e894]
                        - gridcell "LGE_VN_HAP" [ref=f2e895]
                        - gridcell "DAP" [ref=f2e896]
                        - gridcell "0" [ref=f2e897]
                        - gridcell "EA" [ref=f2e898]
                        - gridcell "100" [ref=f2e899]
                        - gridcell "MKT_FCST" [ref=f2e900]
                        - gridcell "36" [ref=f2e901]
                        - gridcell [ref=f2e902]
                      - row "HQ00 DONGHWAES_KR Ship. Plan(RTF) - - - LGE_VN_HAP DAP 0 EA 110 SHIP_PLAN_RTF 37":
                        - gridcell "HQ00" [ref=f2e903]
                        - gridcell "DONGHWAES_KR" [ref=f2e904]
                        - gridcell "Ship. Plan(RTF)" [ref=f2e905]
                        - gridcell "-" [ref=f2e906]
                        - gridcell "-" [ref=f2e907]
                        - gridcell "-" [ref=f2e908]
                        - gridcell "LGE_VN_HAP" [ref=f2e909]
                        - gridcell "DAP" [ref=f2e910]
                        - gridcell "0" [ref=f2e911]
                        - gridcell "EA" [ref=f2e912]
                        - gridcell "110" [ref=f2e913]
                        - gridcell "SHIP_PLAN_RTF" [ref=f2e914]
                        - gridcell "37" [ref=f2e915]
                        - gridcell [ref=f2e916]
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f2e917]
                  - generic [aria-hidden]:
                    - gridcell [selected] [ref=f2e918]: FN
                    - gridcell [ref=f2e919]: "40"
                    - gridcell [ref=f2e920]: Pack
                    - gridcell [ref=f2e921]: C4
                    - gridcell [ref=f2e922]: MCCE127501B1
                    - gridcell [ref=f2e923]
                    - gridcell [ref=f2e924]: MPCHPPHS042C
                    - gridcell [ref=f2e925]: "4.000000"
                    - gridcell [ref=f2e926]: "-"
                    - gridcell [ref=f2e927]: "-"
                    - gridcell [ref=f2e928]: MKT FCST
                    - gridcell [ref=f2e929]: "-"
                    - gridcell [ref=f2e930]: "-"
                    - gridcell [ref=f2e931]: "-"
                    - gridcell [ref=f2e932]: acer_CN_CKG
                    - gridcell [ref=f2e933]: DAP
                    - gridcell [ref=f2e934]: "0"
                    - gridcell [ref=f2e935]: EA
                    - gridcell [ref=f2e936]: Cell
                    - gridcell [ref=f2e937]: E1T
                    - gridcell [ref=f2e938]: MCCE130705A4-M07
                    - gridcell [ref=f2e939]: E1T
                    - gridcell [ref=f2e940]: MCCE130705A4-M07
                    - gridcell [ref=f2e941]: "1.000000"
                    - gridcell [ref=f2e942]: "-"
                    - gridcell [ref=f2e943]: "-"
                    - gridcell [ref=f2e944]: MKT FCST
                    - gridcell [ref=f2e945]: "-"
                    - gridcell [ref=f2e946]: "-"
                    - gridcell [ref=f2e947]: "-"
                    - gridcell [ref=f2e948]: IM_US_SPK
                    - gridcell [ref=f2e949]: FCA
                    - gridcell [ref=f2e950]: "0"
                    - gridcell [ref=f2e951]: EA
                    - gridcell [ref=f2e952]: NJ00
                    - gridcell [ref=f2e953]: NJ01
                    - gridcell [ref=f2e954]: Prod Plan
                    - gridcell [ref=f2e955]: "-"
                    - gridcell [ref=f2e956]: "-"
                    - gridcell [ref=f2e957]: "-"
                    - gridcell [ref=f2e958]: "-"
                    - gridcell [ref=f2e959]: "-"
                    - gridcell [ref=f2e960]: "0"
                    - gridcell [ref=f2e961]: EA
                    - gridcell [ref=f2e962]: Inv.
                    - gridcell [ref=f2e963]: "-"
                    - gridcell [ref=f2e964]: "-"
                    - gridcell [ref=f2e965]: "-"
                    - gridcell [ref=f2e966]: "-"
                    - gridcell [ref=f2e967]: "-"
                    - gridcell [ref=f2e968]: "0"
                    - gridcell [ref=f2e969]: EA
                    - gridcell [ref=f2e970]: MACE130705A4-M07
                    - gridcell [ref=f2e971]: "1.000000"
                    - gridcell [ref=f2e972]: NJ00
                    - gridcell [ref=f2e973]: NJ01
                    - gridcell [ref=f2e974]: In-house Moving
                    - gridcell [ref=f2e975]: MCCE130705A4-M07
                    - gridcell [ref=f2e976]: "-"
                    - gridcell [ref=f2e977]: "-"
                    - gridcell [ref=f2e978]: NJ01
                    - gridcell [ref=f2e979]: "-"
                    - gridcell [ref=f2e980]: "0"
                    - gridcell [ref=f2e981]: EA
                    - gridcell [ref=f2e982]: Prod Plan
                    - gridcell [ref=f2e983]: "-"
                    - gridcell [ref=f2e984]: "-"
                    - gridcell [ref=f2e985]: M7C04
                    - gridcell [ref=f2e986]: "-"
                    - gridcell [ref=f2e987]: "-"
                    - gridcell [ref=f2e988]: "0"
                    - gridcell [ref=f2e989]: EA
                    - gridcell [ref=f2e990]: Inv.
                    - gridcell [ref=f2e991]: "-"
                    - gridcell [ref=f2e992]: "-"
                    - gridcell [ref=f2e993]: "-"
                    - gridcell [ref=f2e994]: "-"
                    - gridcell [ref=f2e995]: "-"
                    - gridcell [ref=f2e996]: "0"
                    - gridcell [ref=f2e997]: EA
                    - gridcell [ref=f2e998]: Pack
                    - gridcell [ref=f2e999]: H15
                    - gridcell [ref=f2e1000]: MCCH114030D3
                    - gridcell [ref=f2e1001]: GM GEN12
                    - gridcell [ref=f2e1002]: MPCLGEGM121G
                    - gridcell [ref=f2e1003]: "1.000000"
                    - gridcell [ref=f2e1004]: "-"
                    - gridcell [ref=f2e1005]: "-"
                    - gridcell [ref=f2e1006]: MKT FCST
                    - gridcell [ref=f2e1007]: "-"
                    - gridcell [ref=f2e1008]: "-"
                    - gridcell [ref=f2e1009]: "-"
                    - gridcell [ref=f2e1010]: LGE_VN_HAP
                    - gridcell [ref=f2e1011]: DAP
                    - gridcell [ref=f2e1012]: "0"
                    - gridcell [ref=f2e1013]: EA
                    - gridcell [ref=f2e1014]: HQ00
                    - gridcell [ref=f2e1015]: DONGHWAES_KR
                    - gridcell [ref=f2e1016]: Ship. Plan(RTF)
                    - gridcell [ref=f2e1017]: "-"
                    - gridcell [ref=f2e1018]: "-"
                    - gridcell [ref=f2e1019]: "-"
                    - gridcell [ref=f2e1020]: LGE_VN_HAP
                    - gridcell [ref=f2e1021]: DAP
                    - gridcell [ref=f2e1022]: "0"
                    - gridcell [ref=f2e1023]: EA
                    - gridcell [ref=f2e1024]: Prod Plan
                    - gridcell [ref=f2e1025]: "-"
                    - gridcell [ref=f2e1026]: "-"
                    - gridcell [ref=f2e1027]: "-"
                    - gridcell [ref=f2e1028]: "-"
                    - gridcell [ref=f2e1029]: "-"
                    - gridcell [ref=f2e1030]: "0"
                    - gridcell [ref=f2e1031]: EA
                    - gridcell [ref=f2e1032]: Inv.
                    - gridcell [ref=f2e1033]: "-"
                    - gridcell [ref=f2e1034]: "-"
                    - gridcell [ref=f2e1035]: "-"
                    - gridcell [ref=f2e1036]: "-"
                    - gridcell [ref=f2e1037]: "-"
                    - gridcell [ref=f2e1038]: "0"
                    - gridcell [ref=f2e1039]: EA
                    - gridcell [ref=f2e1040]: LGE TOYOTA DCM
                    - gridcell [ref=f2e1041]: MPCLGE19CY1M
                    - gridcell [ref=f2e1042]: "1.000000"
                    - gridcell [ref=f2e1043]: HQ00
                    - gridcell [ref=f2e1044]: ITM_KR_VN
                    - gridcell [ref=f2e1045]: Prod Plan
                    - gridcell [ref=f2e1046]: "-"
                    - gridcell [ref=f2e1047]: "-"
                    - gridcell [ref=f2e1048]: "-"
                    - gridcell [ref=f2e1049]: "-"
                    - gridcell [ref=f2e1050]: "-"
                    - gridcell [ref=f2e1051]: "0"
                    - gridcell [ref=f2e1052]: EA
                    - gridcell [ref=f2e1053]: Inv.
                    - gridcell [ref=f2e1054]: "-"
                    - gridcell [ref=f2e1055]: "-"
                    - gridcell [ref=f2e1056]: "-"
                    - gridcell [ref=f2e1057]: "-"
                    - gridcell [ref=f2e1058]: "-"
                    - gridcell [ref=f2e1059]: "0"
                    - gridcell [ref=f2e1060]: EA
                    - gridcell [ref=f2e1061]: OCU3 5PIN
                    - gridcell [ref=f2e1062]: MPCLGE5PIN1M
                    - gridcell [ref=f2e1063]: "2.000000"
                    - gridcell [ref=f2e1064]: HQ00
                    - gridcell [ref=f2e1065]: DONGHWAES_KR
                    - gridcell [ref=f2e1066]: Prod Plan
                    - gridcell [ref=f2e1067]: "-"
                    - gridcell [ref=f2e1068]: "-"
                    - gridcell [ref=f2e1069]: "-"
                    - gridcell [ref=f2e1070]: "-"
                    - gridcell [ref=f2e1071]: "-"
                    - gridcell [ref=f2e1072]: "0"
                    - gridcell [ref=f2e1073]: EA
                    - gridcell [ref=f2e1074]: Inv.
                    - gridcell [ref=f2e1075]: "-"
                    - gridcell [ref=f2e1076]: "-"
                    - gridcell [ref=f2e1077]: "-"
                    - gridcell [ref=f2e1078]: "-"
                    - gridcell [ref=f2e1079]: "-"
                    - gridcell [ref=f2e1080]: "0"
                    - gridcell [ref=f2e1081]: EA
                    - gridcell [ref=f2e1082]: Cell
                    - gridcell [ref=f2e1083]: H15
                    - gridcell [ref=f2e1084]: MCCH114030D3
                    - gridcell [ref=f2e1085]: H15
                    - gridcell [ref=f2e1086]: MCCH114030D3
                    - gridcell [ref=f2e1087]: "1.000000"
                    - gridcell [ref=f2e1088]: HQ00
                    - gridcell [ref=f2e1089]: HQ06
                    - gridcell [ref=f2e1090]: Ship. Plan(Semi)
                    - gridcell [ref=f2e1091]: "-"
                    - gridcell [ref=f2e1092]: "-"
                    - gridcell [ref=f2e1093]: "-"
                    - gridcell [ref=f2e1094]: DONGHWAES_KR
                    - gridcell [ref=f2e1095]: DAP
                    - gridcell [ref=f2e1096]: "0"
                    - gridcell [ref=f2e1097]: EA
                    - gridcell [ref=f2e1098]: ITM_KR_VN
                    - gridcell [ref=f2e1099]: CIF
                    - gridcell [ref=f2e1100]: "0"
                    - gridcell [ref=f2e1101]: EA
                    - gridcell [ref=f2e1102]: Prod Plan
                    - gridcell [ref=f2e1103]: "-"
                    - gridcell [ref=f2e1104]: "-"
                    - gridcell [ref=f2e1105]: "-"
                    - gridcell [ref=f2e1106]: "-"
                    - gridcell [ref=f2e1107]: "-"
                    - gridcell [ref=f2e1108]: "0"
                    - gridcell [ref=f2e1109]: EA
                    - gridcell [ref=f2e1110]: Inv.
                    - gridcell [ref=f2e1111]: "-"
                    - gridcell [ref=f2e1112]: "-"
                    - gridcell [ref=f2e1113]: "-"
                    - gridcell [ref=f2e1114]: "-"
                    - gridcell [ref=f2e1115]: "-"
                    - gridcell [ref=f2e1116]: "0"
                    - gridcell [ref=f2e1117]: EA
                    - gridcell [ref=f2e1118]: MACH114030D3
                    - gridcell [ref=f2e1119]: "1.000000"
                    - gridcell [ref=f2e1120]: HQ00
                    - gridcell [ref=f2e1121]: HQ06
                    - gridcell [ref=f2e1122]: In-house Moving
                    - gridcell [ref=f2e1123]: MCCH114030D3
                    - gridcell [ref=f2e1124]: "-"
                    - gridcell [ref=f2e1125]: "-"
                    - gridcell [ref=f2e1126]: HQ06
                    - gridcell [ref=f2e1127]: "-"
                    - gridcell [ref=f2e1128]: "0"
                    - gridcell [ref=f2e1129]: EA
                    - gridcell [ref=f2e1130]: Prod Plan
                    - gridcell [ref=f2e1131]: "-"
                    - gridcell [ref=f2e1132]: "-"
                    - gridcell [ref=f2e1133]: M2C07
                    - gridcell [ref=f2e1134]: "-"
                    - gridcell [ref=f2e1135]: "-"
                    - gridcell [ref=f2e1136]: "0"
                    - gridcell [ref=f2e1137]: EA
                    - gridcell [ref=f2e1138]: Inv.
                    - gridcell [ref=f2e1139]: "-"
                    - gridcell [ref=f2e1140]: "-"
                    - gridcell [ref=f2e1141]: "-"
                    - gridcell [ref=f2e1142]: "-"
                    - gridcell [ref=f2e1143]: "-"
                    - gridcell [ref=f2e1144]: "0"
                    - gridcell [ref=f2e1145]: EA
                    - gridcell [ref=f2e1146]: MCCH114030D3
                    - gridcell [ref=f2e1147]: "1.000000"
                    - gridcell [ref=f2e1148]: HQ00
                    - gridcell [ref=f2e1149]: DONGHWAES_KR
                    - gridcell [ref=f2e1150]: In-house Moving
                    - gridcell [ref=f2e1151]: MPCLGE5PIN1M
                    - gridcell [ref=f2e1152]: "-"
                    - gridcell [ref=f2e1153]: "-"
                    - gridcell [ref=f2e1154]: DONGHWAES_KR
                    - gridcell [ref=f2e1155]: "-"
                    - gridcell [ref=f2e1156]: "0"
                    - gridcell [ref=f2e1157]: EA
                    - gridcell [ref=f2e1158]: MPCLGEGM121G
                    - gridcell [ref=f2e1159]: "-"
                    - gridcell [ref=f2e1160]: "-"
                    - gridcell [ref=f2e1161]: DONGHWAES_KR
                    - gridcell [ref=f2e1162]: "-"
                    - gridcell [ref=f2e1163]: "0"
                    - gridcell [ref=f2e1164]: EA
                    - gridcell [ref=f2e1165]: Semi WH In
                    - gridcell [ref=f2e1166]: "-"
                    - gridcell [ref=f2e1167]: "-"
                    - gridcell [ref=f2e1168]: "-"
                    - gridcell [ref=f2e1169]: "-"
                    - gridcell [ref=f2e1170]: "-"
                    - gridcell [ref=f2e1171]: "0"
                    - gridcell [ref=f2e1172]: EA
                    - gridcell [ref=f2e1173]: Inv.
                    - gridcell [ref=f2e1174]: "-"
                    - gridcell [ref=f2e1175]: "-"
                    - gridcell [ref=f2e1176]: "-"
                    - gridcell [ref=f2e1177]: "-"
                    - gridcell [ref=f2e1178]: "-"
                    - gridcell [ref=f2e1179]: "0"
                    - gridcell [ref=f2e1180]: EA
                    - gridcell [ref=f2e1181]: ITM_KR_VN
                    - gridcell [ref=f2e1182]: In-house Moving
                    - gridcell [ref=f2e1183]: MPCLGE19CY1M
                    - gridcell [ref=f2e1184]: "-"
                    - gridcell [ref=f2e1185]: "-"
                    - gridcell [ref=f2e1186]: ITM_KR_VN
                    - gridcell [ref=f2e1187]: "-"
                    - gridcell [ref=f2e1188]: "0"
                    - gridcell [ref=f2e1189]: EA
                    - gridcell [ref=f2e1190]: Semi WH In
                    - gridcell [ref=f2e1191]: "-"
                    - gridcell [ref=f2e1192]: "-"
                    - gridcell [ref=f2e1193]: "-"
                    - gridcell [ref=f2e1194]: "-"
                    - gridcell [ref=f2e1195]: "-"
                    - gridcell [ref=f2e1196]: "0"
                    - gridcell [ref=f2e1197]: EA
                    - gridcell [ref=f2e1198]: Inv.
                    - gridcell [ref=f2e1199]: "-"
                    - gridcell [ref=f2e1200]: "-"
                    - gridcell [ref=f2e1201]: "-"
                    - gridcell [ref=f2e1202]: "-"
                    - gridcell [ref=f2e1203]: "-"
                    - gridcell [ref=f2e1204]: "0"
                    - gridcell [ref=f2e1205]: EA
                    - gridcell [ref=f2e1206]: Pack
                    - gridcell [ref=f2e1207]: H15
                    - gridcell [ref=f2e1208]: MCCH114030L1
                    - gridcell [ref=f2e1209]: GM GEN11 CNT
                    - gridcell [ref=f2e1210]: MPCLGEGEN23G
                    - gridcell [ref=f2e1211]: "2.000000"
                    - gridcell [ref=f2e1212]: "-"
                    - gridcell [ref=f2e1213]: "-"
                    - gridcell [ref=f2e1214]: MKT FCST
                    - gridcell [ref=f2e1215]: "-"
                    - gridcell [ref=f2e1216]: "-"
                    - gridcell [ref=f2e1217]: "-"
                    - gridcell [ref=f2e1218]: LGE VC_CN_NKG
                    - gridcell [ref=f2e1219]: DAP
                    - gridcell [ref=f2e1220]: "0"
                    - gridcell [ref=f2e1221]: EA
                    - gridcell [ref=f2e1222]: LGE_VN_HAP
                    - gridcell [ref=f2e1223]: DAP
                    - gridcell [ref=f2e1224]: "0"
                    - gridcell [ref=f2e1225]: EA
                    - gridcell [ref=f2e1226]: HQ00
                    - gridcell [ref=f2e1227]: DONGHWAES_KR
                    - gridcell [ref=f2e1228]: Ship. Plan(RTF)
                    - gridcell [ref=f2e1229]: "-"
                    - gridcell [ref=f2e1230]: "-"
                    - gridcell [ref=f2e1231]: "-"
                    - gridcell [ref=f2e1232]: LGE VC_CN_NKG
                    - gridcell [ref=f2e1233]: DAP
                    - gridcell [ref=f2e1234]: "0"
                    - gridcell [ref=f2e1235]: EA
                    - gridcell [ref=f2e1236]: LGE_VN_HAP
                    - gridcell [ref=f2e1237]: DAP
                    - gridcell [ref=f2e1238]: "0"
                    - gridcell [ref=f2e1239]: EA
                    - gridcell [ref=f2e1240]: Prod Plan
                    - gridcell [ref=f2e1241]: "-"
                    - gridcell [ref=f2e1242]: "-"
                    - gridcell [ref=f2e1243]: "-"
                    - gridcell [ref=f2e1244]: "-"
                    - gridcell [ref=f2e1245]: "-"
                    - gridcell [ref=f2e1246]: "0"
                    - gridcell [ref=f2e1247]: EA
                    - gridcell [ref=f2e1248]: Inv.
                    - gridcell [ref=f2e1249]: "-"
                    - gridcell [ref=f2e1250]: "-"
                    - gridcell [ref=f2e1251]: "-"
                    - gridcell [ref=f2e1252]: "-"
                    - gridcell [ref=f2e1253]: "-"
                    - gridcell [ref=f2e1254]: "0"
                    - gridcell [ref=f2e1255]: EA
                    - gridcell [ref=f2e1256]: GM GEN11
                    - gridcell [ref=f2e1257]: MPCLGEGM122G
                    - gridcell [ref=f2e1258]: "1.000000"
                    - gridcell [ref=f2e1259]: "-"
                    - gridcell [ref=f2e1260]: "-"
                    - gridcell [ref=f2e1261]: MKT FCST
                    - gridcell [ref=f2e1262]: "-"
                    - gridcell [ref=f2e1263]: "-"
                    - gridcell [ref=f2e1264]: "-"
                    - gridcell [ref=f2e1265]: LGE_VN_HAP
                    - gridcell [ref=f2e1266]: DAP
                    - gridcell [ref=f2e1267]: "0"
                    - gridcell [ref=f2e1268]: EA
                    - gridcell [ref=f2e1269]: HQ00
                    - gridcell [ref=f2e1270]: DONGHWAES_KR
                    - gridcell [ref=f2e1271]: Ship. Plan(RTF)
                    - gridcell [ref=f2e1272]: "-"
                    - gridcell [ref=f2e1273]: "-"
                    - gridcell [ref=f2e1274]: "-"
                    - gridcell [ref=f2e1275]: LGE_VN_HAP
                    - gridcell [ref=f2e1276]: DAP
                    - gridcell [ref=f2e1277]: "0"
                    - gridcell [ref=f2e1278]: EA
                  - generic [ref=f2e1279]:
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
                      - row "33"
                      - row "34"
                      - row "35"
                      - row "36"
                      - row "37"
                  - generic [ref=f2e1280]:
                    - generic:
                      - row "No"
                - generic [ref=f2e1281]:
                  - status
                  - generic [ref=f2e1282]: "0"
                - generic:
                  - spinbutton "InputNumber Input" [ref=f2e1286]: "0.0000"
                  - spinbutton "InputNumber Input" [ref=f2e1290]: "0.0000"
            - alert [ref=f2e1291]:
              - generic [ref=f2e1292] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1295] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-17) · 원천: Doc/gen/SCP0111/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SCP0111.plan.json', 'utf8'));
  5   | const MENU = "SCP0111";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} IntegrationPSI 스모크 @smoke`, () => {
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
> 31  |       expect.soft(!!hit, `조회조건 '${f.label}' (${f.component}) — 후보 [${(f.labels || [f.label]).join(' | ')}]`).toBeTruthy();
      |                                                                                                              ^ Error: 조회조건 'Qty ＜ 0' (Checkbox) — 후보 [Qty ＜ 0 | Qty ≥ 0]
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
  121 |     expect.soft(s.fail, `공통 기능 FAIL ${s.fail}: ${items.filter(i => i.verdict === 'FAIL').map(i => i.name).join(', ')}`).toBe(0);
  122 |   });
  123 | });
  124 | 
```