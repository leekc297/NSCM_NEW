# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0023.smoke.spec.ts >> SSP0023 ShipmentPlanElectrode 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\SSP0023.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Result Type' (CustomDropdown) — 후보 [Result Type]

expect(received).toBeTruthy()

Received: false
```

```
Error: 그리드 컬럼 누락 (메타 기준)

expect(received).toBeLessThanOrEqual(expected)

Expected: <= 8
Received:    35
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
        - /url: /view/SSP0023
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/SSP0023
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/SSP0023
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
              - /url: /view/SSP0023
              - paragraph [ref=f2e42]: Shipping Master
            - link "Distribution Route":
              - /url: /view/SSP0023
              - paragraph [ref=f2e45] [cursor=pointer]: Distribution Route
            - link "Shipment Model PIC":
              - /url: /view/SSP0023
              - paragraph [ref=f2e46] [cursor=pointer]: Shipment Model PIC
            - link "Shipment Lot Size":
              - /url: /view/SSP0023
              - paragraph [ref=f2e47] [cursor=pointer]: Shipment Lot Size
            - link "Delegate":
              - /url: /view/SSP0023
              - paragraph [ref=f2e48] [cursor=pointer]: Delegate
            - link "Shipment Master Electrode":
              - /url: /view/SSP0023
              - paragraph [ref=f2e49] [cursor=pointer]: Shipment Master Electrode
            - link "Shipment Requestor PIC":
              - /url: /view/SSP0023
              - paragraph [ref=f2e50] [cursor=pointer]: Shipment Requestor PIC
            - link "Shipment Semi Dept Day":
              - /url: /view/SSP0023
              - paragraph [ref=f2e51] [cursor=pointer]: Shipment Semi Dept Day
            - link "Shipment Working Day":
              - /url: /view/SSP0023
              - paragraph [ref=f2e52] [cursor=pointer]: Shipment Working Day
          - generic [ref=f2e53]:
            - link [ref=f2e54] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e55]: Shipping Schedule
            - link [ref=f2e58] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e59]: Shipment Request
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e61]: Shipment Plan(Mobility & IT)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e63]: Shipment Plan(Electrode)
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e65]: Shipment Plan(Auto & ESS)-WA_UC
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e67]: Shipment Plan Detail
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e69]: Shipment Change History
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e71]: Shipment Plan(Auto & ESS)
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e73]: Shipment Request(Mobility & IT)
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e75]: Shipment Request(Electrode)
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e77]: Shipment Change Request
            - link [ref=f2e78] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e79]: Shipment Change Request Confirm
            - link [ref=f2e80] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e81]: Inventory Raw(Mobility & IT)
            - link [ref=f2e82] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e83]: Shipment Change Request(Packer)
            - link [ref=f2e84] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e85]: Shipment Change Request Confirm(Packer)
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/SSP0023
              - paragraph [ref=f2e87]: Shipment Request SEMI
      - main [ref=f2e88]:
        - generic [ref=f2e90]:
          - generic [ref=f2e91]:
            - generic [ref=f2e92]:
              - button "Home" [ref=f2e93] [cursor=pointer]
              - button "Shipment Plan(Electrode)" [ref=f2e95] [cursor=pointer]
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
                  - paragraph [ref=f2e120]: Shipment Plan(Electrode)
                - generic [ref=f2e121]:
                  - generic [ref=f2e122]: Shipping
                  - generic [ref=f2e127]: Shipping Schedule
                  - generic [ref=f2e132]: Shipment Plan(Electrode)
                - generic [ref=f2e134]:
                  - generic [ref=f2e135]: Search Area
                  - switch [checked] [ref=f2e138] [cursor=pointer]
                - button "Full screen" [ref=f2e141] [cursor=pointer]
              - generic [ref=f2e150]:
                - generic [ref=f2e151]:
                  - generic [ref=f2e152]:
                    - generic [ref=f2e154]:
                      - generic [ref=f2e155]: Div
                      - generic [ref=f2e165]:
                        - combobox [ref=f2e166]: 40 Mobility & IT Battery
                        - button "Open" [ref=f2e168] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e173]:
                      - generic [ref=f2e174]: Company
                      - generic [ref=f2e184]:
                        - combobox [ref=f2e185]: ESOC
                        - button "Open" [ref=f2e187] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e192]:
                      - generic [ref=f2e193]: From Site
                      - generic [ref=f2e201] [cursor=pointer]:
                        - combobox "ALL" [ref=f2e202]
                        - button "Open" [ref=f2e204]
                        - group [aria-hidden]
                    - generic [ref=f2e209]:
                      - generic [ref=f2e210]: Bucket
                      - generic [ref=f2e218]:
                        - combobox [ref=f2e219]: Daily
                        - button "Open" [ref=f2e221] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e226]:
                      - generic [ref=f2e227]: Plan Date
                      - generic [ref=f2e237]:
                        - combobox [ref=f2e238]: 2026-10-10
                        - button "Open" [ref=f2e240] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e245]:
                      - generic [ref=f2e246]: Period
                      - generic [ref=f2e253]:
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e266]: 2026.09.28
                        - generic [ref=f2e267]: ~
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e280]: 2026.12.04
                    - generic [ref=f2e282]:
                      - generic [ref=f2e283]: Material
                      - generic [ref=f2e289]:
                        - textbox [ref=f2e290]
                        - button [ref=f2e291] [cursor=pointer]
                    - generic [ref=f2e297]:
                      - generic [ref=f2e298]: Model/Nickname
                      - generic [ref=f2e304]:
                        - textbox [ref=f2e305]
                        - button [ref=f2e306] [cursor=pointer]
                    - generic [ref=f2e312]:
                      - generic [ref=f2e313]: UOM Type
                      - generic [ref=f2e318]:
                        - generic [ref=f2e319] [cursor=pointer]:
                          - radio "UOM" [checked] [ref=f2e320]
                          - generic [ref=f2e321]: UOM
                        - generic [ref=f2e322] [cursor=pointer]:
                          - radio "Cell" [ref=f2e323]
                          - generic [ref=f2e324]: Cell
                        - generic [ref=f2e325] [cursor=pointer]:
                          - radio "Pancake m" [ref=f2e326]
                          - generic [ref=f2e327]: Pancake m
                  - generic [ref=f2e328]:
                    - button [active] [ref=f2e329] [cursor=pointer]
                    - button [ref=f2e334] [cursor=pointer]
                - generic [ref=f2e339]:
                  - separator [ref=f2e340]
                  - generic [ref=f2e344]:
                    - generic [ref=f2e345] [cursor=pointer]:
                      - checkbox "Sum" [ref=f2e347]
                      - generic [ref=f2e348]: Sum
                    - generic [ref=f2e349] [cursor=pointer]:
                      - checkbox "Including Past Period" [ref=f2e351]
                      - generic [ref=f2e352]: Including Past Period
                    - generic [ref=f2e353] [cursor=pointer]:
                      - checkbox "My Model" [ref=f2e355]
                      - generic [ref=f2e356]: My Model
                    - generic [ref=f2e357] [cursor=pointer]:
                      - checkbox "Part Leader" [ref=f2e359]
                      - generic [ref=f2e360]: Part Leader
                    - generic [ref=f2e361] [cursor=pointer]:
                      - checkbox "Team Leader" [ref=f2e363]
                      - generic [ref=f2e364]: Team Leader
                    - generic [ref=f2e365] [cursor=pointer]:
                      - checkbox "Delegatee Model" [ref=f2e367]
                      - generic [ref=f2e368]: Delegatee Model
              - generic [ref=f2e369]:
                - generic [ref=f2e370]:
                  - paragraph
                  - generic [ref=f2e371]: 총308건
                - generic [ref=f2e372]:
                  - generic "Measure" [ref=f2e373]:
                    - button "Measure" [ref=f2e374] [cursor=pointer]
                  - generic "Simulation" [ref=f2e378]:
                    - button "Simulation" [ref=f2e379] [cursor=pointer]
                  - generic "Excel Form" [ref=f2e380]:
                    - button [ref=f2e381] [cursor=pointer]
                  - generic "Excel Upload" [ref=f2e389]:
                    - button [ref=f2e390] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e401]:
                    - button [ref=f2e402] [cursor=pointer]
                  - generic "Remove" [ref=f2e407]:
                    - button [ref=f2e408] [cursor=pointer]
                  - generic "Save" [ref=f2e415]:
                    - button [ref=f2e416] [cursor=pointer]
                  - generic "Sort" [ref=f2e420]:
                    - button [ref=f2e421] [cursor=pointer]
                  - generic "Filter" [ref=f2e426]:
                    - button [ref=f2e427] [cursor=pointer]
                  - generic "Condition" [ref=f2e432]:
                    - button [ref=f2e433] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e443]:
                    - button [ref=f2e444] [cursor=pointer]
                  - generic "Excel" [ref=f2e451]:
                    - button [ref=f2e452] [cursor=pointer]
              - generic [ref=f2e461]:
                - generic [ref=f2e465]:
                  - grid [ref=f2e466]:
                    - rowgroup [ref=f2e467]:
                      - generic:
                        - row "Div Model Nick Name From Site Material Oper. L/T Elec Type BOH PSI Measure 2026-10 No":
                          - columnheader "Div" [ref=f2e468]
                          - columnheader "Model" [ref=f2e469]
                          - columnheader "Nick Name" [ref=f2e470]
                          - columnheader "From Site" [ref=f2e471]
                          - columnheader "Material" [ref=f2e472]
                          - columnheader "Oper. L/T" [ref=f2e473]
                          - columnheader "Elec Type" [ref=f2e474]
                          - columnheader "BOH" [ref=f2e475]
                          - columnheader "PSI" [ref=f2e476]
                          - columnheader "Measure" [ref=f2e477]
                          - columnheader "2026-10" [ref=f2e478]
                          - gridcell "No" [ref=f2e479]
                          - gridcell [ref=f2e480]
                        - row "W41 W42":
                          - columnheader "W41" [ref=f2e481]
                          - columnheader "W42" [ref=f2e482]
                        - row "10 11 12 13 14 15 16 17 18":
                          - columnheader "10" [ref=f2e483]
                          - columnheader "11" [ref=f2e484]
                          - columnheader "12" [ref=f2e485]
                          - columnheader "13" [ref=f2e486]
                          - columnheader "14" [ref=f2e487]
                          - columnheader "15" [ref=f2e488]
                          - columnheader "16" [ref=f2e489]
                          - columnheader "17" [ref=f2e490]
                          - columnheader "18" [ref=f2e491]
                    - rowgroup [ref=f2e492]:
                      - generic [ref=f2e493]:
                        - row "40 MCCH114030D3 H15 HQ06-E APCAN1199A - ANODE 9,288 S SCP Target (Coater) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 1":
                          - gridcell "40" [selected] [ref=f2e494]
                          - gridcell "MCCH114030D3" [ref=f2e495]
                          - gridcell "H15" [ref=f2e496]
                          - gridcell "HQ06-E" [ref=f2e497]
                          - gridcell "APCAN1199A" [ref=f2e498]
                          - gridcell "-" [ref=f2e499]
                          - gridcell "ANODE" [ref=f2e500]
                          - gridcell "9,288" [ref=f2e501]
                          - gridcell "S" [ref=f2e502]
                          - gridcell "SCP Target (Coater)" [ref=f2e503]
                          - gridcell "0.000" [ref=f2e504]
                          - gridcell "0.000" [ref=f2e505]
                          - gridcell "0.000" [ref=f2e506]
                          - gridcell "0.000" [ref=f2e507]
                          - gridcell "0.000" [ref=f2e508]
                          - gridcell "0.000" [ref=f2e509]
                          - gridcell "0.000" [ref=f2e510]
                          - gridcell "0.000" [ref=f2e511]
                          - gridcell "0.000" [ref=f2e512]
                          - gridcell "1" [ref=f2e513]
                          - gridcell [ref=f2e514]
                        - row "SCP Target (Shipping Target ETD) 0.000 0.000 0.000 0.000 0.000 4,644.000 0.000 0.000 0.000 2":
                          - gridcell "SCP Target (Shipping Target ETD)" [ref=f2e515]
                          - gridcell "0.000" [ref=f2e516]
                          - gridcell "0.000" [ref=f2e517]
                          - gridcell "0.000" [ref=f2e518]
                          - gridcell "0.000" [ref=f2e519]
                          - gridcell "0.000" [ref=f2e520]
                          - gridcell "4,644.000" [ref=f2e521]
                          - gridcell "0.000" [ref=f2e522]
                          - gridcell "0.000" [ref=f2e523]
                          - gridcell "0.000" [ref=f2e524]
                          - gridcell "2" [ref=f2e525]
                          - gridcell [ref=f2e526]
                        - row "Shipment Request (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 3":
                          - gridcell "Shipment Request (ETD)" [ref=f2e527]
                          - gridcell "0.000" [ref=f2e528]
                          - gridcell "0.000" [ref=f2e529]
                          - gridcell "0.000" [ref=f2e530]
                          - gridcell "0.000" [ref=f2e531]
                          - gridcell "0.000" [ref=f2e532]
                          - gridcell "0.000" [ref=f2e533]
                          - gridcell "0.000" [ref=f2e534]
                          - gridcell "0.000" [ref=f2e535]
                          - gridcell "0.000" [ref=f2e536]
                          - gridcell "3" [ref=f2e537]
                          - gridcell [ref=f2e538]
                        - row "Shipment Plan (ETD) 1,000.000 500.000 1,000.000 0.000 0.000 0.000 0.000 0.000 0.000 4":
                          - gridcell "Shipment Plan (ETD)" [ref=f2e539]
                          - gridcell "1,000.000" [ref=f2e540]
                          - gridcell "500.000" [ref=f2e541]
                          - gridcell "1,000.000" [ref=f2e542]
                          - gridcell "0.000" [ref=f2e543]
                          - gridcell "0.000" [ref=f2e544]
                          - gridcell "0.000" [ref=f2e545]
                          - gridcell "0.000" [ref=f2e546]
                          - gridcell "0.000" [ref=f2e547]
                          - gridcell "0.000" [ref=f2e548]
                          - gridcell "4" [ref=f2e549]
                          - gridcell [ref=f2e550]
                        - row "Shipment Plan Confirm(ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 5":
                          - gridcell "Shipment Plan Confirm(ETD)" [ref=f2e551]
                          - gridcell "0.000" [ref=f2e552]
                          - gridcell "0.000" [ref=f2e553]
                          - gridcell "0.000" [ref=f2e554]
                          - gridcell "0.000" [ref=f2e555]
                          - gridcell "0.000" [ref=f2e556]
                          - gridcell "0.000" [ref=f2e557]
                          - gridcell "0.000" [ref=f2e558]
                          - gridcell "0.000" [ref=f2e559]
                          - gridcell "0.000" [ref=f2e560]
                          - gridcell "5" [ref=f2e561]
                          - gridcell [ref=f2e562]
                        - row "P Assy Plan(Notching) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 6":
                          - gridcell "P" [ref=f2e563]
                          - gridcell "Assy Plan(Notching)" [ref=f2e564]
                          - gridcell "0.000" [ref=f2e565]
                          - gridcell "0.000" [ref=f2e566]
                          - gridcell "0.000" [ref=f2e567]
                          - gridcell "0.000" [ref=f2e568]
                          - gridcell "0.000" [ref=f2e569]
                          - gridcell "0.000" [ref=f2e570]
                          - gridcell "0.000" [ref=f2e571]
                          - gridcell "0.000" [ref=f2e572]
                          - gridcell "0.000" [ref=f2e573]
                          - gridcell "6" [ref=f2e574]
                          - gridcell [ref=f2e575]
                        - row "Coater Plan 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 7":
                          - gridcell "Coater Plan" [ref=f2e576]
                          - gridcell "0.000" [ref=f2e577]
                          - gridcell "0.000" [ref=f2e578]
                          - gridcell "0.000" [ref=f2e579]
                          - gridcell "0.000" [ref=f2e580]
                          - gridcell "0.000" [ref=f2e581]
                          - gridcell "0.000" [ref=f2e582]
                          - gridcell "0.000" [ref=f2e583]
                          - gridcell "0.000" [ref=f2e584]
                          - gridcell "0.000" [ref=f2e585]
                          - gridcell "7" [ref=f2e586]
                          - gridcell [ref=f2e587]
                        - row "Coater Plan+ Post Yield 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 8":
                          - gridcell "Coater Plan+ Post Yield" [ref=f2e588]
                          - gridcell "0.000" [ref=f2e589]
                          - gridcell "0.000" [ref=f2e590]
                          - gridcell "0.000" [ref=f2e591]
                          - gridcell "0.000" [ref=f2e592]
                          - gridcell "0.000" [ref=f2e593]
                          - gridcell "0.000" [ref=f2e594]
                          - gridcell "0.000" [ref=f2e595]
                          - gridcell "0.000" [ref=f2e596]
                          - gridcell "0.000" [ref=f2e597]
                          - gridcell "8" [ref=f2e598]
                          - gridcell [ref=f2e599]
                        - row "I Receipt(Intransit)+Shipment Plan(In) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 9":
                          - gridcell "I" [ref=f2e600]
                          - gridcell "Receipt(Intransit)+Shipment Plan(In)" [ref=f2e601]
                          - gridcell "0.000" [ref=f2e602]
                          - gridcell "0.000" [ref=f2e603]
                          - gridcell "0.000" [ref=f2e604]
                          - gridcell "0.000" [ref=f2e605]
                          - gridcell "0.000" [ref=f2e606]
                          - gridcell "0.000" [ref=f2e607]
                          - gridcell "0.000" [ref=f2e608]
                          - gridcell "0.000" [ref=f2e609]
                          - gridcell "0.000" [ref=f2e610]
                          - gridcell "9" [ref=f2e611]
                          - gridcell [ref=f2e612]
                        - row "Inventory(Simulation) 8,288.000 7,788.000 6,788.000 6,788.000 6,788.000 6,788.000 6,788.000 6,788.000 6,788.000 10":
                          - gridcell "Inventory(Simulation)" [ref=f2e613]
                          - gridcell "8,288.000" [ref=f2e614]
                          - gridcell "7,788.000" [ref=f2e615]
                          - gridcell "6,788.000" [ref=f2e616]
                          - gridcell "6,788.000" [ref=f2e617]
                          - gridcell "6,788.000" [ref=f2e618]
                          - gridcell "6,788.000" [ref=f2e619]
                          - gridcell "6,788.000" [ref=f2e620]
                          - gridcell "6,788.000" [ref=f2e621]
                          - gridcell "6,788.000" [ref=f2e622]
                          - gridcell "10" [ref=f2e623]
                          - gridcell [ref=f2e624]
                        - row "Inventory(Confirm) 9,288.000 9,288.000 9,288.000 9,288.000 9,288.000 9,288.000 9,288.000 9,288.000 9,288.000 11":
                          - gridcell "Inventory(Confirm)" [ref=f2e625]
                          - gridcell "9,288.000" [ref=f2e626]
                          - gridcell "9,288.000" [ref=f2e627]
                          - gridcell "9,288.000" [ref=f2e628]
                          - gridcell "9,288.000" [ref=f2e629]
                          - gridcell "9,288.000" [ref=f2e630]
                          - gridcell "9,288.000" [ref=f2e631]
                          - gridcell "9,288.000" [ref=f2e632]
                          - gridcell "9,288.000" [ref=f2e633]
                          - gridcell "9,288.000" [ref=f2e634]
                          - gridcell "11" [ref=f2e635]
                          - gridcell [ref=f2e636]
                        - row "APCCA1244A - CATHODE 0 S SCP Target (Coater) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 12":
                          - gridcell "APCCA1244A" [ref=f2e637]
                          - gridcell "-" [ref=f2e638]
                          - gridcell "CATHODE" [ref=f2e639]
                          - gridcell "0" [ref=f2e640]
                          - gridcell "S" [ref=f2e641]
                          - gridcell "SCP Target (Coater)" [ref=f2e642]
                          - gridcell "0.000" [ref=f2e643]
                          - gridcell "0.000" [ref=f2e644]
                          - gridcell "0.000" [ref=f2e645]
                          - gridcell "0.000" [ref=f2e646]
                          - gridcell "0.000" [ref=f2e647]
                          - gridcell "0.000" [ref=f2e648]
                          - gridcell "0.000" [ref=f2e649]
                          - gridcell "0.000" [ref=f2e650]
                          - gridcell "0.000" [ref=f2e651]
                          - gridcell "12" [ref=f2e652]
                          - gridcell [ref=f2e653]
                        - row "SCP Target (Shipping Target ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 13":
                          - gridcell "SCP Target (Shipping Target ETD)" [ref=f2e654]
                          - gridcell "0.000" [ref=f2e655]
                          - gridcell "0.000" [ref=f2e656]
                          - gridcell "0.000" [ref=f2e657]
                          - gridcell "0.000" [ref=f2e658]
                          - gridcell "0.000" [ref=f2e659]
                          - gridcell "0.000" [ref=f2e660]
                          - gridcell "0.000" [ref=f2e661]
                          - gridcell "0.000" [ref=f2e662]
                          - gridcell "0.000" [ref=f2e663]
                          - gridcell "13" [ref=f2e664]
                          - gridcell [ref=f2e665]
                        - row "Shipment Request (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 14":
                          - gridcell "Shipment Request (ETD)" [ref=f2e666]
                          - gridcell "0.000" [ref=f2e667]
                          - gridcell "0.000" [ref=f2e668]
                          - gridcell "0.000" [ref=f2e669]
                          - gridcell "0.000" [ref=f2e670]
                          - gridcell "0.000" [ref=f2e671]
                          - gridcell "0.000" [ref=f2e672]
                          - gridcell "0.000" [ref=f2e673]
                          - gridcell "0.000" [ref=f2e674]
                          - gridcell "0.000" [ref=f2e675]
                          - gridcell "14" [ref=f2e676]
                          - gridcell [ref=f2e677]
                        - row "Shipment Plan (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 15":
                          - gridcell "Shipment Plan (ETD)" [ref=f2e678]
                          - gridcell "0.000" [ref=f2e679]
                          - gridcell "0.000" [ref=f2e680]
                          - gridcell "0.000" [ref=f2e681]
                          - gridcell "0.000" [ref=f2e682]
                          - gridcell "0.000" [ref=f2e683]
                          - gridcell "0.000" [ref=f2e684]
                          - gridcell "0.000" [ref=f2e685]
                          - gridcell "0.000" [ref=f2e686]
                          - gridcell "0.000" [ref=f2e687]
                          - gridcell "15" [ref=f2e688]
                          - gridcell [ref=f2e689]
                        - row "Shipment Plan Confirm(ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 16":
                          - gridcell "Shipment Plan Confirm(ETD)" [ref=f2e690]
                          - gridcell "0.000" [ref=f2e691]
                          - gridcell "0.000" [ref=f2e692]
                          - gridcell "0.000" [ref=f2e693]
                          - gridcell "0.000" [ref=f2e694]
                          - gridcell "0.000" [ref=f2e695]
                          - gridcell "0.000" [ref=f2e696]
                          - gridcell "0.000" [ref=f2e697]
                          - gridcell "0.000" [ref=f2e698]
                          - gridcell "0.000" [ref=f2e699]
                          - gridcell "16" [ref=f2e700]
                          - gridcell [ref=f2e701]
                        - row "P Assy Plan(Notching) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 17":
                          - gridcell "P" [ref=f2e702]
                          - gridcell "Assy Plan(Notching)" [ref=f2e703]
                          - gridcell "0.000" [ref=f2e704]
                          - gridcell "0.000" [ref=f2e705]
                          - gridcell "0.000" [ref=f2e706]
                          - gridcell "0.000" [ref=f2e707]
                          - gridcell "0.000" [ref=f2e708]
                          - gridcell "0.000" [ref=f2e709]
                          - gridcell "0.000" [ref=f2e710]
                          - gridcell "0.000" [ref=f2e711]
                          - gridcell "0.000" [ref=f2e712]
                          - gridcell "17" [ref=f2e713]
                          - gridcell [ref=f2e714]
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e715]
                    - generic [aria-hidden]:
                      - gridcell [selected] [ref=f2e716]: "40"
                      - gridcell [ref=f2e717]: MCCH114030D3
                      - gridcell [ref=f2e718]: H15
                      - gridcell [ref=f2e719]: HQ06-E
                      - gridcell [ref=f2e720]: APCAN1199A
                      - gridcell [ref=f2e721]: "-"
                      - gridcell [ref=f2e722]: ANODE
                      - gridcell [ref=f2e723]: 9,288
                      - gridcell [ref=f2e724]: S
                      - gridcell [ref=f2e725]: SCP Target (Coater)
                      - gridcell [ref=f2e726]: SCP Target (Shipping Target ETD)
                      - gridcell [ref=f2e727]: Shipment Request (ETD)
                      - gridcell [ref=f2e728]: Shipment Plan (ETD)
                      - gridcell [ref=f2e729]: Shipment Plan Confirm(ETD)
                      - gridcell [ref=f2e730]: P
                      - gridcell [ref=f2e731]: Assy Plan(Notching)
                      - gridcell [ref=f2e732]: Coater Plan
                      - gridcell [ref=f2e733]: Coater Plan+ Post Yield
                      - gridcell [ref=f2e734]: I
                      - gridcell [ref=f2e735]: Receipt(Intransit)+Shipment Plan(In)
                      - gridcell [ref=f2e736]: Inventory(Simulation)
                      - gridcell [ref=f2e737]: Inventory(Confirm)
                      - gridcell [ref=f2e738]: APCCA1244A
                      - gridcell [ref=f2e739]: "-"
                      - gridcell [ref=f2e740]: CATHODE
                      - gridcell [ref=f2e741]: "0"
                      - gridcell [ref=f2e742]: S
                      - gridcell [ref=f2e743]: SCP Target (Coater)
                      - gridcell [ref=f2e744]: SCP Target (Shipping Target ETD)
                      - gridcell [ref=f2e745]: Shipment Request (ETD)
                      - gridcell [ref=f2e746]: Shipment Plan (ETD)
                      - gridcell [ref=f2e747]: Shipment Plan Confirm(ETD)
                      - gridcell [ref=f2e748]: P
                      - gridcell [ref=f2e749]: Assy Plan(Notching)
                    - generic [ref=f2e750]:
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
                    - generic [ref=f2e751]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e752]:
                    - status
                    - generic [ref=f2e753]: "0"
                - separator [ref=f2e754]
                - generic [ref=f2e757]:
                  - generic [ref=f2e758]:
                    - generic [ref=f2e759]:
                      - generic [ref=f2e762]:
                        - generic [ref=f2e763]: Shipment Date
                        - generic [ref=f2e770]:
                          - generic [ref=f2e773]:
                            - img [aria-hidden] [ref=f2e775] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e783]: 2026.10.10
                          - generic [ref=f2e784]: ~
                          - generic [ref=f2e787]:
                            - img [aria-hidden] [ref=f2e789] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e797]: 2026.12.04
                      - generic [ref=f2e799]:
                        - generic [ref=f2e800]: Material
                        - generic [ref=f2e806]:
                          - textbox [ref=f2e807]
                          - button [ref=f2e808] [cursor=pointer]
                      - generic [ref=f2e814]:
                        - generic [ref=f2e815]: Model/Nickname
                        - generic [ref=f2e821]:
                          - textbox [ref=f2e822]
                          - button [ref=f2e823] [cursor=pointer]
                      - generic [ref=f2e829]:
                        - generic [ref=f2e830]: Requestor
                        - generic [ref=f2e836]:
                          - textbox [ref=f2e837]
                          - button [ref=f2e838] [cursor=pointer]
                    - button "Search" [ref=f2e844] [cursor=pointer]
                  - generic [ref=f2e845]:
                    - generic [ref=f2e846]:
                      - button "Shipment Plan Detail" [ref=f2e847]
                      - button "Stock Detail" [ref=f2e849]
                      - button "Shipment Result" [ref=f2e851]
                    - generic [ref=f2e856]:
                      - grid [ref=f2e857]:
                        - rowgroup [ref=f2e858]:
                          - generic:
                            - row "Div PO No Confirm/Plan ID Status Model Material Nick Name To Site DOM/EXP. Day Shipment Date Shipping Plan Qty Confirm Qty Gap Confirm Qty (Cut) Package Type No":
                              - columnheader "Div" [ref=f2e859]
                              - columnheader "PO No" [ref=f2e860]
                              - columnheader "Confirm/Plan ID" [ref=f2e861]
                              - columnheader "Status" [ref=f2e862]
                              - columnheader "Model" [ref=f2e863]
                              - columnheader "Material" [ref=f2e864]
                              - columnheader "Nick Name" [ref=f2e865]
                              - columnheader "To Site" [ref=f2e866]
                              - columnheader "DOM/EXP." [ref=f2e867]
                              - columnheader "Day" [ref=f2e868]
                              - columnheader "Shipment Date" [ref=f2e869]
                              - columnheader "Shipping Plan Qty" [ref=f2e870]
                              - columnheader "Confirm Qty" [ref=f2e871]
                              - columnheader "Gap" [ref=f2e872]
                              - columnheader "Confirm Qty (Cut)" [ref=f2e873]
                              - columnheader "Package Type" [ref=f2e874]
                              - gridcell "No" [ref=f2e875]
                              - gridcell [ref=f2e876]
                        - rowgroup [ref=f2e877]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f2e879]
                        - generic [ref=f2e881]:
                          - generic:
                            - row "No"
                      - generic [ref=f2e882]:
                        - status
                        - generic [ref=f2e883]: "0"
                      - generic:
                        - generic [ref=f2e886]:
                          - combobox "InputDate Input" [ref=f2e887]: 2026-11-14
                          - button "Choose Date" [ref=f2e889] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e894]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e898]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e902]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e906]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e910]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e914]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e918]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e922]: "0.000"
                        - generic [ref=f2e925]:
                          - combobox "InputDate Input" [ref=f2e926]: 2026-11-14
                          - button "Choose Date" [ref=f2e928] [cursor=pointer]
                        - generic [ref=f2e932]:
                          - combobox "InputDate Input" [ref=f2e933]: 2026-11-14
                          - button "Choose Date" [ref=f2e935] [cursor=pointer]
                        - generic [ref=f2e939]:
                          - combobox "InputDateTime Input" [ref=f2e940]: 2026-11-14 23:46:21
                          - generic [ref=f2e941]:
                            - button "Toggle Calendar" [ref=f2e942] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e944] [cursor=pointer]
                        - generic [ref=f2e948]:
                          - combobox "InputDate Input" [ref=f2e949]: 2026-11-14
                          - button "Choose Date" [ref=f2e951] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e956]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e960]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e964]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e968]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e972]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e976]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e980]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e984]: "0.000"
                        - generic [ref=f2e987]:
                          - combobox "InputDate Input" [ref=f2e988]: 2026-11-14
                          - button "Choose Date" [ref=f2e990] [cursor=pointer]
                        - generic [ref=f2e994]:
                          - combobox "InputDate Input" [ref=f2e995]: 2026-11-14
                          - button "Choose Date" [ref=f2e997] [cursor=pointer]
                        - generic [ref=f2e1001]:
                          - combobox "InputDateTime Input" [ref=f2e1002]: 2026-11-14 23:46:21
                          - generic [ref=f2e1003]:
                            - button "Toggle Calendar" [ref=f2e1004] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1006] [cursor=pointer]
            - alert [ref=f2e1008]:
              - generic [ref=f2e1009] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1012] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-14) · 원천: Doc/gen/SSP0023/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/SSP0023.plan.json', 'utf8'));
  5   | const MENU = "SSP0023";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} ShipmentPlanElectrode 스모크 @smoke`, () => {
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