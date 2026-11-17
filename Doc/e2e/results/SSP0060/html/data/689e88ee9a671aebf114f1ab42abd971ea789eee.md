# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0060.smoke.spec.ts >> SSP0060 ShipmentPlan 스모크 @smoke >> 공통 기능 — Search·F5·Sort·Filter·Condition·Reset Condition·Excel·Columns·Search Area·Manual
- Location: ..\..\Doc\e2e\specs\SSP0060.smoke.spec.ts:115:7

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
        - /url: /view/SSP0060
        - generic [ref=f3e6]: SCM
        - generic [ref=f3e7]:
          - generic [ref=f3e8]: 공급망관리시스템
          - generic [ref=f3e9]: Supply Chain Management system
      - navigation [ref=f3e10]:
        - link "Demand" [ref=f3e11] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Supply" [ref=f3e12] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Shipping" [ref=f3e13] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Report" [ref=f3e14] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Authority" [ref=f3e15] [cursor=pointer]:
          - /url: /view/SSP0060
        - link "Admin" [ref=f3e16] [cursor=pointer]:
          - /url: /view/SSP0060
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
              - /url: /view/SSP0060
              - paragraph [ref=f3e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0060
              - paragraph [ref=f3e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0060
              - paragraph [ref=f3e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0060
              - paragraph [ref=f3e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0060
              - paragraph [ref=f3e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0060
              - paragraph [ref=f3e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0060
              - paragraph [ref=f3e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0060
              - paragraph [ref=f3e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0060
              - paragraph [ref=f3e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f3e53]:
            - link [ref=f3e54] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e55]: Shipping Schedule
            - link [ref=f3e58] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e59]: Shipment Request
            - link [ref=f3e60] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e61]: Shipment Plan(Mobility & IT)
            - link [ref=f3e62] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e63]: Shipment Plan(Electrode)
            - link [ref=f3e64] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f3e66] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e67]: Shipment Plan Detail
            - link [ref=f3e68] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e69]: Shipment Change History
            - link [ref=f3e70] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e71]: Shipment Plan(Auto & ESS)
            - link [ref=f3e72] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e73]: Shipment Request(Mobility & IT)
            - link [ref=f3e74] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e75]: Shipment Request(Electrode)
            - link [ref=f3e76] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e77]: Shipment Change Request
            - link [ref=f3e78] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e79]: Shipment Change Request Confirm
            - link [ref=f3e80] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e81]: Inventory Raw(Mobility & IT)
            - link [ref=f3e82] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e83]: Shipment Change Request(Packer)
            - link [ref=f3e84] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f3e86] [cursor=pointer]:
              - /url: /view/SSP0060
              - paragraph [ref=f3e87]: Shipment Request SEMI
      - main [ref=f3e88]:
        - generic [ref=f3e90]:
          - generic [ref=f3e91]:
            - generic [ref=f3e92]:
              - button "Home" [ref=f3e93] [cursor=pointer]
              - button "Shipment Plan(Auto & ESS)-WA_UC" [ref=f3e95] [cursor=pointer]
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
                  - paragraph [ref=f3e120]: Shipment Plan(Auto & ESS)-WA_UC
                - generic [ref=f3e121]:
                  - generic [ref=f3e122]: Shipping
                  - generic [ref=f3e127]: Shipping Schedule
                  - generic [ref=f3e132]: Shipment Plan(Auto & ESS)-WA_UC
                - generic [ref=f3e134]:
                  - generic [ref=f3e135]: Search Area
                  - switch [checked] [active] [ref=f3e138] [cursor=pointer]
                - button "Full screen" [ref=f3e141] [cursor=pointer]
              - generic [ref=f3e151]:
                - generic [ref=f3e152]:
                  - generic [ref=f3e154]:
                    - generic [ref=f3e155]: Div*
                    - generic [ref=f3e163]:
                      - combobox [ref=f3e164]: 82 ESS Battery
                      - button "Open" [ref=f3e166] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e171]:
                    - generic [ref=f3e172]: Company*
                    - generic [ref=f3e180]:
                      - combobox [ref=f3e181]: ESUC
                      - button "Open" [ref=f3e183] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e188]:
                    - generic [ref=f3e189]: From Site
                    - generic [ref=f3e197] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e198]
                      - button "Open" [ref=f3e200]
                      - group [aria-hidden]
                  - generic [ref=f3e205]:
                    - generic [ref=f3e206]: Bucket
                    - generic [ref=f3e214]:
                      - combobox [ref=f3e215]: Daily
                      - button "Open" [ref=f3e217] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e222]:
                    - generic [ref=f3e223]: Plan Date*
                    - generic [ref=f3e231]:
                      - combobox [ref=f3e232]: 2026-10-09
                      - button "Open" [ref=f3e234] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f3e239]:
                    - generic [ref=f3e240]: Period
                    - generic [ref=f3e247]:
                      - generic [ref=f3e250]:
                        - img [aria-hidden] [ref=f3e252] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f3e260]: 2026.10.09
                      - generic [ref=f3e261]: ~
                      - generic [ref=f3e264]:
                        - img [aria-hidden] [ref=f3e266] [cursor=pointer]
                        - textbox "YYYY.MM.DD" [ref=f3e274]: 2026.10.23
                  - generic [ref=f3e276]:
                    - generic [ref=f3e277]: Model/Nickname
                    - generic [ref=f3e283]:
                      - textbox [ref=f3e284]
                      - button [ref=f3e285] [cursor=pointer]
                  - generic [ref=f3e291]:
                    - generic [ref=f3e292]: Product Level1
                    - generic [ref=f3e300] [cursor=pointer]:
                      - combobox "ALL" [ref=f3e301]
                      - button "Open" [ref=f3e303]
                      - group [aria-hidden]
                - generic [ref=f3e307]:
                  - button [ref=f3e308] [cursor=pointer]
                  - button [ref=f3e313] [cursor=pointer]
              - generic [ref=f3e318]:
                - generic:
                  - paragraph
                - generic [ref=f3e319]:
                  - generic "Measure" [ref=f3e320]:
                    - button "Measure" [ref=f3e321] [cursor=pointer]
                  - generic "Insert Row" [ref=f3e325]:
                    - button [ref=f3e326] [cursor=pointer]
                  - generic "Remove" [ref=f3e331]:
                    - button [ref=f3e332] [cursor=pointer]
                  - generic "Save" [ref=f3e339]:
                    - button [ref=f3e340] [cursor=pointer]
                  - generic "Sort" [ref=f3e344]:
                    - button [ref=f3e345] [cursor=pointer]
                  - generic "Filter" [ref=f3e350]:
                    - button [ref=f3e351] [cursor=pointer]
                  - generic "Condition" [ref=f3e356]:
                    - button [ref=f3e357] [cursor=pointer]
                  - generic "Reset Condition" [ref=f3e367]:
                    - button [ref=f3e368] [cursor=pointer]
                  - generic "Excel" [ref=f3e375]:
                    - button [ref=f3e376] [cursor=pointer]
              - generic [ref=f3e384]:
                - generic [ref=f3e388]:
                  - grid [ref=f3e389]:
                    - rowgroup [ref=f3e390]:
                      - generic:
                        - row "Div From Site Product Level1 Model Nick Name BOH PSI Measure To Site Transmode Incoterms FCST Type 2026-10 No":
                          - columnheader "Div" [ref=f3e391]
                          - columnheader "From Site" [ref=f3e392]
                          - columnheader "Product Level1" [ref=f3e393]
                          - columnheader "Model" [ref=f3e394]
                          - columnheader "Nick Name" [ref=f3e395]
                          - columnheader "BOH" [ref=f3e396]
                          - columnheader "PSI" [ref=f3e397]
                          - columnheader "Measure" [ref=f3e398]
                          - columnheader "To Site" [ref=f3e399]
                          - columnheader "Transmode" [ref=f3e400]
                          - columnheader "Incoterms" [ref=f3e401]
                          - columnheader "FCST Type" [ref=f3e402]
                          - columnheader "2026-10" [ref=f3e403]
                          - gridcell "No" [ref=f3e404]
                          - gridcell [ref=f3e405]
                        - row "W41 W42":
                          - columnheader "W41" [ref=f3e406]
                          - columnheader "W42" [ref=f3e407]
                        - row "09 10 11 12 13 14 15 16 17":
                          - columnheader "09" [ref=f3e408]
                          - columnheader "10" [ref=f3e409]
                          - columnheader "11" [ref=f3e410]
                          - columnheader "12" [ref=f3e411]
                          - columnheader "13" [ref=f3e412]
                          - columnheader "14" [ref=f3e413]
                          - columnheader "15" [ref=f3e414]
                          - columnheader "16" [ref=f3e415]
                          - columnheader "17" [ref=f3e416]
                    - rowgroup [ref=f3e417]:
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f3e419]
                    - generic [ref=f3e421]:
                      - generic:
                        - row "No"
                  - generic [ref=f3e422]:
                    - status
                    - generic [ref=f3e423]: "0"
                - separator [ref=f3e424]
                - generic [ref=f3e427]:
                  - generic [ref=f3e428]:
                    - generic [ref=f3e429]:
                      - generic [ref=f3e431]:
                        - generic [ref=f3e432]: Shipment Date
                        - generic [ref=f3e439]:
                          - generic [ref=f3e442]:
                            - img [aria-hidden] [ref=f3e444] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f3e452]: 2026.10.09
                          - generic [ref=f3e453]: ~
                          - generic [ref=f3e456]:
                            - img [aria-hidden] [ref=f3e458] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f3e466]: 2026.10.23
                      - generic [ref=f3e468]:
                        - generic [ref=f3e469]: Model/Nickname
                        - generic [ref=f3e475]:
                          - textbox [ref=f3e476]: ECE1592F1-01-H01
                          - button [ref=f3e477] [cursor=pointer]
                      - generic [ref=f3e483]:
                        - generic [ref=f3e484]: Requestor
                        - generic [ref=f3e490]:
                          - textbox [ref=f3e491]
                          - button [ref=f3e492] [cursor=pointer]
                      - generic [ref=f3e498]:
                        - generic [ref=f3e499]: Product Level1
                        - generic [ref=f3e507] [cursor=pointer]:
                          - combobox "ALL" [ref=f3e508]
                          - button "Open" [ref=f3e510]
                          - group [aria-hidden]
                    - generic [ref=f3e514]:
                      - button "신규" [ref=f3e515] [cursor=pointer]
                      - button "Search" [ref=f3e516] [cursor=pointer]
                  - generic [ref=f3e517]:
                    - generic [ref=f3e518]:
                      - button "Shipment Plan Detail" [ref=f3e519]
                      - button "Stock Location Detail" [ref=f3e521]
                      - button "oWMS Detail" [ref=f3e523]
                      - button "MES Stock" [ref=f3e525]
                      - button "MES Stock Detail" [ref=f3e527]
                      - button "Shipment Result" [ref=f3e529]
                    - generic [ref=f3e534]:
                      - grid [ref=f3e535]:
                        - rowgroup [ref=f3e536]:
                          - generic:
                            - row "Div Confirm/Plan ID SO No DO No Status Product Level1 Model Nick Name From Site To Site Project Code Project Name End Customer Incoterms FCST Type Shipment Qty Shipment Date Trans Mode Building Remarks Change Reason Reason Detail No":
                              - columnheader "Div" [ref=f3e537]
                              - columnheader "Confirm/Plan ID" [ref=f3e538]
                              - columnheader "SO No" [ref=f3e539]
                              - columnheader "DO No" [ref=f3e540]
                              - columnheader "Status" [ref=f3e541]
                              - columnheader "Product Level1" [ref=f3e542]
                              - columnheader "Model" [ref=f3e543]
                              - columnheader "Nick Name" [ref=f3e544]
                              - columnheader "From Site" [ref=f3e545]
                              - columnheader "To Site" [ref=f3e546]
                              - columnheader "Project Code" [ref=f3e547]
                              - columnheader "Project Name" [ref=f3e548]
                              - columnheader "End Customer" [ref=f3e549]
                              - columnheader "Incoterms" [ref=f3e550]
                              - columnheader "FCST Type" [ref=f3e551]
                              - columnheader "Shipment Qty" [ref=f3e552]
                              - columnheader "Shipment Date" [ref=f3e553]
                              - columnheader "Trans Mode" [ref=f3e554]
                              - columnheader "Building" [ref=f3e555]
                              - columnheader "Remarks" [ref=f3e556]
                              - columnheader "Change Reason" [ref=f3e557]
                              - columnheader "Reason Detail" [ref=f3e558]
                              - gridcell "No" [ref=f3e559]
                              - gridcell [ref=f3e560]
                        - rowgroup [ref=f3e561]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f3e563]
                        - generic [ref=f3e565]:
                          - generic:
                            - row "0 Sum":
                              - gridcell [ref=f3e566]
                              - gridcell [ref=f3e567]
                              - gridcell [ref=f3e568]
                              - gridcell [ref=f3e569]
                              - gridcell [ref=f3e570]
                              - gridcell [ref=f3e571]
                              - gridcell [ref=f3e572]
                              - gridcell [ref=f3e573]
                              - gridcell [ref=f3e574]
                              - gridcell [ref=f3e575]
                              - gridcell [ref=f3e576]
                              - gridcell [ref=f3e577]
                              - gridcell [ref=f3e578]
                              - gridcell [ref=f3e579]
                              - gridcell [ref=f3e580]
                              - gridcell "0" [ref=f3e581]
                              - gridcell [ref=f3e582]
                              - gridcell [ref=f3e583]
                              - gridcell [ref=f3e584]
                              - gridcell [ref=f3e585]
                              - gridcell [ref=f3e586]
                              - gridcell [ref=f3e587]
                              - gridcell [ref=f3e588]
                              - gridcell [ref=f3e589]
                              - gridcell [ref=f3e590]
                              - gridcell [ref=f3e591]
                              - gridcell [ref=f3e592]
                              - gridcell [ref=f3e593]
                              - gridcell [ref=f3e594]
                              - gridcell [ref=f3e595]
                              - gridcell [ref=f3e596]
                              - gridcell [ref=f3e597]
                              - gridcell [ref=f3e598]
                              - gridcell [ref=f3e599]
                              - gridcell [ref=f3e600]
                              - gridcell [ref=f3e601]
                              - gridcell [ref=f3e602]
                              - gridcell [ref=f3e603]
                              - gridcell [ref=f3e604]
                              - gridcell [ref=f3e605]
                              - gridcell [ref=f3e606]
                              - gridcell [ref=f3e607]
                              - gridcell [ref=f3e608]
                              - gridcell "Sum" [ref=f3e609]
                              - gridcell [ref=f3e610]
                        - generic [ref=f3e611]:
                          - generic:
                            - row "Sum 0"
                        - generic [ref=f3e612]:
                          - generic:
                            - row "No"
                      - generic [ref=f3e613]:
                        - status
                        - generic [ref=f3e614]: "0"
                      - generic:
                        - generic [ref=f3e617]:
                          - combobox "InputDate Input" [ref=f3e618]: 2026-11-15
                          - button "Choose Date" [ref=f3e620] [cursor=pointer]
                        - generic [ref=f3e624]:
                          - combobox "InputDate Input" [ref=f3e625]: 2026-11-15
                          - button "Choose Date" [ref=f3e627] [cursor=pointer]
                        - generic [ref=f3e631]:
                          - combobox "InputDate Input" [ref=f3e632]: 2026-11-15
                          - button "Choose Date" [ref=f3e634] [cursor=pointer]
                        - generic [ref=f3e638]:
                          - combobox "InputDateTime Input" [ref=f3e639]: 2026-11-15 04:08:15
                          - generic [ref=f3e640]:
                            - button "Toggle Calendar" [ref=f3e641] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e643] [cursor=pointer]
                        - generic [ref=f3e647]:
                          - combobox "InputDate Input" [ref=f3e648]: 2026-11-15
                          - button "Choose Date" [ref=f3e650] [cursor=pointer]
                        - generic [ref=f3e654]:
                          - combobox "InputDate Input" [ref=f3e655]: 2026-11-15
                          - button "Choose Date" [ref=f3e657] [cursor=pointer]
                        - generic [ref=f3e661]:
                          - combobox "InputDate Input" [ref=f3e662]: 2026-11-15
                          - button "Choose Date" [ref=f3e664] [cursor=pointer]
                        - generic [ref=f3e668]:
                          - combobox "InputDateTime Input" [ref=f3e669]: 2026-11-15 04:08:16
                          - generic [ref=f3e670]:
                            - button "Toggle Calendar" [ref=f3e671] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e673] [cursor=pointer]
                        - generic [ref=f3e677]:
                          - combobox "InputDate Input" [ref=f3e678]: 2026-11-15
                          - button "Choose Date" [ref=f3e680] [cursor=pointer]
                        - generic [ref=f3e684]:
                          - combobox "InputDate Input" [ref=f3e685]: 2026-11-15
                          - button "Choose Date" [ref=f3e687] [cursor=pointer]
                        - generic [ref=f3e691]:
                          - combobox "InputDate Input" [ref=f3e692]: 2026-11-15
                          - button "Choose Date" [ref=f3e694] [cursor=pointer]
                        - generic [ref=f3e698]:
                          - combobox "InputDateTime Input" [ref=f3e699]: 2026-11-15 04:08:16
                          - generic [ref=f3e700]:
                            - button "Toggle Calendar" [ref=f3e701] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e703] [cursor=pointer]
                        - generic [ref=f3e707]:
                          - combobox "InputDate Input" [ref=f3e708]: 2026-11-15
                          - button "Choose Date" [ref=f3e710] [cursor=pointer]
                        - generic [ref=f3e714]:
                          - combobox "InputDate Input" [ref=f3e715]: 2026-11-15
                          - button "Choose Date" [ref=f3e717] [cursor=pointer]
                        - generic [ref=f3e721]:
                          - combobox "InputDate Input" [ref=f3e722]: 2026-11-15
                          - button "Choose Date" [ref=f3e724] [cursor=pointer]
                        - generic [ref=f3e728]:
                          - combobox "InputDateTime Input" [ref=f3e729]: 2026-11-15 04:08:16
                          - generic [ref=f3e730]:
                            - button "Toggle Calendar" [ref=f3e731] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e733] [cursor=pointer]
                        - generic [ref=f3e737]:
                          - combobox "InputDate Input" [ref=f3e738]: 2026-11-15
                          - button "Choose Date" [ref=f3e740] [cursor=pointer]
                        - generic [ref=f3e744]:
                          - combobox "InputDate Input" [ref=f3e745]: 2026-11-15
                          - button "Choose Date" [ref=f3e747] [cursor=pointer]
                        - generic [ref=f3e751]:
                          - combobox "InputDate Input" [ref=f3e752]: 2026-11-15
                          - button "Choose Date" [ref=f3e754] [cursor=pointer]
                        - generic [ref=f3e758]:
                          - combobox "InputDateTime Input" [ref=f3e759]: 2026-11-15 04:08:16
                          - generic [ref=f3e760]:
                            - button "Toggle Calendar" [ref=f3e761] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e763] [cursor=pointer]
                        - generic [ref=f3e767]:
                          - combobox "InputDate Input" [ref=f3e768]: 2026-11-15
                          - button "Choose Date" [ref=f3e770] [cursor=pointer]
                        - generic [ref=f3e774]:
                          - combobox "InputDate Input" [ref=f3e775]: 2026-11-15
                          - button "Choose Date" [ref=f3e777] [cursor=pointer]
                        - generic [ref=f3e781]:
                          - combobox "InputDate Input" [ref=f3e782]: 2026-11-15
                          - button "Choose Date" [ref=f3e784] [cursor=pointer]
                        - generic [ref=f3e788]:
                          - combobox "InputDateTime Input" [ref=f3e789]: 2026-11-15 04:08:16
                          - generic [ref=f3e790]:
                            - button "Toggle Calendar" [ref=f3e791] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e793] [cursor=pointer]
                        - generic [ref=f3e797]:
                          - combobox "InputDate Input" [ref=f3e798]: 2026-11-15
                          - button "Choose Date" [ref=f3e800] [cursor=pointer]
                        - generic [ref=f3e804]:
                          - combobox "InputDate Input" [ref=f3e805]: 2026-11-15
                          - button "Choose Date" [ref=f3e807] [cursor=pointer]
                        - generic [ref=f3e811]:
                          - combobox "InputDate Input" [ref=f3e812]: 2026-11-15
                          - button "Choose Date" [ref=f3e814] [cursor=pointer]
                        - generic [ref=f3e818]:
                          - combobox "InputDateTime Input" [ref=f3e819]: 2026-11-15 04:08:17
                          - generic [ref=f3e820]:
                            - button "Toggle Calendar" [ref=f3e821] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e823] [cursor=pointer]
                        - generic [ref=f3e827]:
                          - combobox "InputDate Input" [ref=f3e828]: 2026-11-15
                          - button "Choose Date" [ref=f3e830] [cursor=pointer]
                        - generic [ref=f3e834]:
                          - combobox "InputDate Input" [ref=f3e835]: 2026-11-15
                          - button "Choose Date" [ref=f3e837] [cursor=pointer]
                        - generic [ref=f3e841]:
                          - combobox "InputDate Input" [ref=f3e842]: 2026-11-15
                          - button "Choose Date" [ref=f3e844] [cursor=pointer]
                        - generic [ref=f3e848]:
                          - combobox "InputDateTime Input" [ref=f3e849]: 2026-11-15 04:08:17
                          - generic [ref=f3e850]:
                            - button "Toggle Calendar" [ref=f3e851] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e853] [cursor=pointer]
                        - generic [ref=f3e857]:
                          - combobox "InputDate Input" [ref=f3e858]: 2026-11-15
                          - button "Choose Date" [ref=f3e860] [cursor=pointer]
                        - generic [ref=f3e864]:
                          - combobox "InputDate Input" [ref=f3e865]: 2026-11-15
                          - button "Choose Date" [ref=f3e867] [cursor=pointer]
                        - generic [ref=f3e871]:
                          - combobox "InputDate Input" [ref=f3e872]: 2026-11-15
                          - button "Choose Date" [ref=f3e874] [cursor=pointer]
                        - generic [ref=f3e878]:
                          - combobox "InputDateTime Input" [ref=f3e879]: 2026-11-15 04:08:17
                          - generic [ref=f3e880]:
                            - button "Toggle Calendar" [ref=f3e881] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e883] [cursor=pointer]
                        - generic [ref=f3e887]:
                          - combobox "InputDate Input" [ref=f3e888]: 2026-11-15
                          - button "Choose Date" [ref=f3e890] [cursor=pointer]
                        - generic [ref=f3e894]:
                          - combobox "InputDate Input" [ref=f3e895]: 2026-11-15
                          - button "Choose Date" [ref=f3e897] [cursor=pointer]
                        - generic [ref=f3e901]:
                          - combobox "InputDate Input" [ref=f3e902]: 2026-11-15
                          - button "Choose Date" [ref=f3e904] [cursor=pointer]
                        - generic [ref=f3e908]:
                          - combobox "InputDateTime Input" [ref=f3e909]: 2026-11-15 04:08:17
                          - generic [ref=f3e910]:
                            - button "Toggle Calendar" [ref=f3e911] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e913] [cursor=pointer]
                        - generic [ref=f3e917]:
                          - combobox "InputDate Input" [ref=f3e918]: 2026-11-15
                          - button "Choose Date" [ref=f3e920] [cursor=pointer]
                        - generic [ref=f3e924]:
                          - combobox "InputDate Input" [ref=f3e925]: 2026-11-15
                          - button "Choose Date" [ref=f3e927] [cursor=pointer]
                        - generic [ref=f3e931]:
                          - combobox "InputDate Input" [ref=f3e932]: 2026-11-15
                          - button "Choose Date" [ref=f3e934] [cursor=pointer]
                        - generic [ref=f3e938]:
                          - combobox "InputDateTime Input" [ref=f3e939]: 2026-11-15 04:08:17
                          - generic [ref=f3e940]:
                            - button "Toggle Calendar" [ref=f3e941] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e943] [cursor=pointer]
                        - generic [ref=f3e947]:
                          - combobox "InputDate Input" [ref=f3e948]: 2026-11-15
                          - button "Choose Date" [ref=f3e950] [cursor=pointer]
                        - generic [ref=f3e954]:
                          - combobox "InputDate Input" [ref=f3e955]: 2026-11-15
                          - button "Choose Date" [ref=f3e957] [cursor=pointer]
                        - generic [ref=f3e961]:
                          - combobox "InputDate Input" [ref=f3e962]: 2026-11-15
                          - button "Choose Date" [ref=f3e964] [cursor=pointer]
                        - generic [ref=f3e968]:
                          - combobox "InputDateTime Input" [ref=f3e969]: 2026-11-15 04:08:17
                          - generic [ref=f3e970]:
                            - button "Toggle Calendar" [ref=f3e971] [cursor=pointer]
                            - button "Toggle Time List" [ref=f3e973] [cursor=pointer]
            - alert [ref=f3e975]:
              - generic [ref=f3e976] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f3e979] [cursor=pointer]:
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