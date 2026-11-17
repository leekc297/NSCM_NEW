# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: SSP0023.smoke.spec.ts >> SSP0023 ShipmentPlanElectrode 스모크 @smoke >> 조회조건 동작 — 조건별 값 변경 → 조회 · 기준표 순서 · Checkbox/Radio 디자인
- Location: ..\..\Doc\e2e\specs\SSP0023.smoke.spec.ts:106:7

# Error details

```
Error: 조회조건 판정 불가(ERROR) 1: Result Type

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
                        - combobox [ref=f2e166]: 81 Automotive Battery
                        - button "Open" [ref=f2e168] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e173]:
                      - generic [ref=f2e174]: Company
                      - generic [ref=f2e184]:
                        - combobox [ref=f2e185]: ESMI
                        - button "Open" [ref=f2e187] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e192]:
                      - generic [ref=f2e193]: From Site
                      - generic [ref=f2e201] [cursor=pointer]:
                        - generic "LGESMI Elec MI00" [ref=f2e202]:
                          - paragraph [ref=f2e206]: LGESMI Elec MI00
                        - combobox
                        - generic [ref=f2e211]:
                          - button "Clear" [ref=f2e212]
                          - button "Open" [ref=f2e216]
                        - group [aria-hidden]
                    - generic [ref=f2e221]:
                      - generic [ref=f2e222]: Bucket
                      - generic [ref=f2e230]:
                        - combobox [ref=f2e231]: Weekly
                        - button "Open" [ref=f2e233] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e238]:
                      - generic [ref=f2e239]: Plan Date
                      - generic [ref=f2e249]:
                        - combobox [ref=f2e250]: 2026-10-08
                        - button "Open" [ref=f2e252] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e257]:
                      - generic [ref=f2e258]: Period
                      - generic [ref=f2e265]:
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e278]: 2026.09.28
                        - generic [ref=f2e279]: ~
                        - textbox "YYYY.MM.DD" [disabled] [ref=f2e292]: 2026.12.02
                    - generic [ref=f2e294]:
                      - generic [ref=f2e295]: Material
                      - generic [ref=f2e301]:
                        - textbox [ref=f2e302]
                        - button [ref=f2e303] [cursor=pointer]
                    - generic [ref=f2e309]:
                      - generic [ref=f2e310]: Model/Nickname
                      - generic [ref=f2e316]:
                        - textbox [ref=f2e317]
                        - button [ref=f2e318] [cursor=pointer]
                    - generic [ref=f2e324]:
                      - generic [ref=f2e325]: UOM Type
                      - generic [ref=f2e330]:
                        - generic [ref=f2e331] [cursor=pointer]:
                          - radio "UOM" [ref=f2e332]
                          - generic [ref=f2e333]: UOM
                        - generic [ref=f2e334] [cursor=pointer]:
                          - radio "Cell" [ref=f2e335]
                          - generic [ref=f2e336]: Cell
                        - generic [ref=f2e337] [cursor=pointer]:
                          - radio "Pancake m" [checked] [ref=f2e338]
                          - generic [ref=f2e339]: Pancake m
                  - generic [ref=f2e340]:
                    - button [active] [ref=f2e341] [cursor=pointer]
                    - button [ref=f2e346] [cursor=pointer]
                - generic [ref=f2e351]:
                  - separator [ref=f2e352]
                  - generic [ref=f2e356]:
                    - generic [ref=f2e357] [cursor=pointer]:
                      - checkbox "Sum" [checked] [ref=f2e359]
                      - generic [ref=f2e362]: Sum
                    - generic [ref=f2e363] [cursor=pointer]:
                      - checkbox "Including Past Period" [checked] [ref=f2e365]
                      - generic [ref=f2e368]: Including Past Period
                    - generic [ref=f2e369] [cursor=pointer]:
                      - checkbox "My Model" [ref=f2e371]
                      - generic [ref=f2e372]: My Model
                    - generic [ref=f2e373] [cursor=pointer]:
                      - checkbox "Part Leader" [ref=f2e375]
                      - generic [ref=f2e376]: Part Leader
                    - generic [ref=f2e377] [cursor=pointer]:
                      - checkbox "Team Leader" [ref=f2e379]
                      - generic [ref=f2e380]: Team Leader
                    - generic [ref=f2e381] [cursor=pointer]:
                      - checkbox "Delegatee Model" [ref=f2e383]
                      - generic [ref=f2e384]: Delegatee Model
              - generic [ref=f2e385]:
                - generic [ref=f2e386]:
                  - paragraph
                  - generic [ref=f2e387]: 총22건
                - generic [ref=f2e388]:
                  - generic "Measure" [ref=f2e389]:
                    - button "Measure" [ref=f2e390] [cursor=pointer]
                  - generic "Simulation" [ref=f2e394]:
                    - button "Simulation" [ref=f2e395] [cursor=pointer]
                  - generic "Excel Form" [ref=f2e396]:
                    - button [ref=f2e397] [cursor=pointer]
                  - generic "Excel Upload" [ref=f2e405]:
                    - button [ref=f2e406] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e417]:
                    - button [ref=f2e418] [cursor=pointer]
                  - generic "Remove" [ref=f2e423]:
                    - button [ref=f2e424] [cursor=pointer]
                  - generic "Save" [ref=f2e431]:
                    - button [ref=f2e432] [cursor=pointer]
                  - generic "Sort" [ref=f2e436]:
                    - button [ref=f2e437] [cursor=pointer]
                  - generic "Filter" [ref=f2e442]:
                    - button [ref=f2e443] [cursor=pointer]
                  - generic "Condition" [ref=f2e448]:
                    - button [ref=f2e449] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e459]:
                    - button [ref=f2e460] [cursor=pointer]
                  - generic "Excel" [ref=f2e467]:
                    - button [ref=f2e468] [cursor=pointer]
              - generic [ref=f2e477]:
                - generic [ref=f2e481]:
                  - grid [ref=f2e482]:
                    - rowgroup [ref=f2e483]:
                      - generic:
                        - row "Div Model Nick Name From Site Material Oper. L/T Elec Type BOH PSI Measure 2026-09 2026-10 2026-11 No":
                          - columnheader "Div" [ref=f2e484]
                          - columnheader "Model" [ref=f2e485]
                          - columnheader "Nick Name" [ref=f2e486]
                          - columnheader "From Site" [ref=f2e487]
                          - columnheader "Material" [ref=f2e488]
                          - columnheader "Oper. L/T" [ref=f2e489]
                          - columnheader "Elec Type" [ref=f2e490]
                          - columnheader "BOH" [ref=f2e491]
                          - columnheader "PSI" [ref=f2e492]
                          - columnheader "Measure" [ref=f2e493]
                          - columnheader "2026-09" [ref=f2e494]
                          - columnheader "2026-10" [ref=f2e495]
                          - columnheader "2026-11" [ref=f2e496]
                          - gridcell "No" [ref=f2e497]
                          - gridcell [ref=f2e498]
                        - row "SUM W40 SUM W40 W41 W42 W43 W44 SUM":
                          - columnheader "SUM" [ref=f2e499]
                          - columnheader "W40" [ref=f2e500]
                          - columnheader "SUM" [ref=f2e501]
                          - columnheader "W40" [ref=f2e502]
                          - columnheader "W41" [ref=f2e503]
                          - columnheader "W42" [ref=f2e504]
                          - columnheader "W43" [ref=f2e505]
                          - columnheader "W44" [ref=f2e506]
                          - columnheader "SUM" [ref=f2e507]
                        - row "SUM SUM SUM SUM SUM SUM":
                          - columnheader "SUM" [ref=f2e508]
                          - columnheader "SUM" [ref=f2e509]
                          - columnheader "SUM" [ref=f2e510]
                          - columnheader "SUM" [ref=f2e511]
                          - columnheader "SUM" [ref=f2e512]
                          - columnheader "SUM" [ref=f2e513]
                    - rowgroup [ref=f2e514]:
                      - generic [ref=f2e515]:
                        - row "81 ACEN4069I-A1-501 E71A-501 MI00-E APCAN2950A - ANODE 343,705 S SCP Target (Coater) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 1":
                          - gridcell "81" [selected] [ref=f2e516]
                          - gridcell "ACEN4069I-A1-501" [ref=f2e517]
                          - gridcell "E71A-501" [ref=f2e518]
                          - gridcell "MI00-E" [ref=f2e519]
                          - gridcell "APCAN2950A" [ref=f2e520]
                          - gridcell "-" [ref=f2e521]
                          - gridcell "ANODE" [ref=f2e522]
                          - gridcell "343,705" [ref=f2e523]
                          - gridcell "S" [ref=f2e524]
                          - gridcell "SCP Target (Coater)" [ref=f2e525]
                          - gridcell "0.000" [ref=f2e526]
                          - gridcell "0.000" [ref=f2e527]
                          - gridcell "0.000" [ref=f2e528]
                          - gridcell "0.000" [ref=f2e529]
                          - gridcell "0.000" [ref=f2e530]
                          - gridcell "0.000" [ref=f2e531]
                          - gridcell "0.000" [ref=f2e532]
                          - gridcell "0.000" [ref=f2e533]
                          - gridcell "0.000" [ref=f2e534]
                          - gridcell "1" [ref=f2e535]
                          - gridcell [ref=f2e536]
                        - row "SCP Target (Shipping Target ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 2":
                          - gridcell "SCP Target (Shipping Target ETD)" [ref=f2e537]
                          - gridcell "0.000" [ref=f2e538]
                          - gridcell "0.000" [ref=f2e539]
                          - gridcell "0.000" [ref=f2e540]
                          - gridcell "0.000" [ref=f2e541]
                          - gridcell "0.000" [ref=f2e542]
                          - gridcell "0.000" [ref=f2e543]
                          - gridcell "0.000" [ref=f2e544]
                          - gridcell "0.000" [ref=f2e545]
                          - gridcell "0.000" [ref=f2e546]
                          - gridcell "2" [ref=f2e547]
                          - gridcell [ref=f2e548]
                        - row "Shipment Request (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 3":
                          - gridcell "Shipment Request (ETD)" [ref=f2e549]
                          - gridcell "0.000" [ref=f2e550]
                          - gridcell "0.000" [ref=f2e551]
                          - gridcell "0.000" [ref=f2e552]
                          - gridcell "0.000" [ref=f2e553]
                          - gridcell "0.000" [ref=f2e554]
                          - gridcell "0.000" [ref=f2e555]
                          - gridcell "0.000" [ref=f2e556]
                          - gridcell "0.000" [ref=f2e557]
                          - gridcell "0.000" [ref=f2e558]
                          - gridcell "3" [ref=f2e559]
                          - gridcell [ref=f2e560]
                        - row "Shipment Plan (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 4":
                          - gridcell "Shipment Plan (ETD)" [ref=f2e561]
                          - gridcell "0.000" [ref=f2e562]
                          - gridcell "0.000" [ref=f2e563]
                          - gridcell "0.000" [ref=f2e564]
                          - gridcell "0.000" [ref=f2e565]
                          - gridcell "0.000" [ref=f2e566]
                          - gridcell "0.000" [ref=f2e567]
                          - gridcell "0.000" [ref=f2e568]
                          - gridcell "0.000" [ref=f2e569]
                          - gridcell "0.000" [ref=f2e570]
                          - gridcell "4" [ref=f2e571]
                          - gridcell [ref=f2e572]
                        - row "Shipment Plan Confirm(ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 5":
                          - gridcell "Shipment Plan Confirm(ETD)" [ref=f2e573]
                          - gridcell "0.000" [ref=f2e574]
                          - gridcell "0.000" [ref=f2e575]
                          - gridcell "0.000" [ref=f2e576]
                          - gridcell "0.000" [ref=f2e577]
                          - gridcell "0.000" [ref=f2e578]
                          - gridcell "0.000" [ref=f2e579]
                          - gridcell "0.000" [ref=f2e580]
                          - gridcell "0.000" [ref=f2e581]
                          - gridcell "0.000" [ref=f2e582]
                          - gridcell "5" [ref=f2e583]
                          - gridcell [ref=f2e584]
                        - row "P Assy Plan(Notching) 231,329.000 231,329.000 1,387,467.000 0.000 248,694.000 404,108.000 412,188.000 322,477.000 1,790,193.000 6":
                          - gridcell "P" [ref=f2e585]
                          - gridcell "Assy Plan(Notching)" [ref=f2e586]
                          - gridcell "231,329.000" [ref=f2e587]
                          - gridcell "231,329.000" [ref=f2e588]
                          - gridcell "1,387,467.000" [ref=f2e589]
                          - gridcell "0.000" [ref=f2e590]
                          - gridcell "248,694.000" [ref=f2e591]
                          - gridcell "404,108.000" [ref=f2e592]
                          - gridcell "412,188.000" [ref=f2e593]
                          - gridcell "322,477.000" [ref=f2e594]
                          - gridcell "1,790,193.000" [ref=f2e595]
                          - gridcell "6" [ref=f2e596]
                          - gridcell [ref=f2e597]
                        - row "Coater Plan 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 7":
                          - gridcell "Coater Plan" [ref=f2e598]
                          - gridcell "0.000" [ref=f2e599]
                          - gridcell "0.000" [ref=f2e600]
                          - gridcell "0.000" [ref=f2e601]
                          - gridcell "0.000" [ref=f2e602]
                          - gridcell "0.000" [ref=f2e603]
                          - gridcell "0.000" [ref=f2e604]
                          - gridcell "0.000" [ref=f2e605]
                          - gridcell "0.000" [ref=f2e606]
                          - gridcell "0.000" [ref=f2e607]
                          - gridcell "7" [ref=f2e608]
                          - gridcell [ref=f2e609]
                        - row "Coater Plan+ Post Yield 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 8":
                          - gridcell "Coater Plan+ Post Yield" [ref=f2e610]
                          - gridcell "0.000" [ref=f2e611]
                          - gridcell "0.000" [ref=f2e612]
                          - gridcell "0.000" [ref=f2e613]
                          - gridcell "0.000" [ref=f2e614]
                          - gridcell "0.000" [ref=f2e615]
                          - gridcell "0.000" [ref=f2e616]
                          - gridcell "0.000" [ref=f2e617]
                          - gridcell "0.000" [ref=f2e618]
                          - gridcell "0.000" [ref=f2e619]
                          - gridcell "8" [ref=f2e620]
                          - gridcell [ref=f2e621]
                        - row "I Receipt(Intransit)+Shipment Plan(In) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 9":
                          - gridcell "I" [ref=f2e622]
                          - gridcell "Receipt(Intransit)+Shipment Plan(In)" [ref=f2e623]
                          - gridcell "0.000" [ref=f2e624]
                          - gridcell "0.000" [ref=f2e625]
                          - gridcell "0.000" [ref=f2e626]
                          - gridcell "0.000" [ref=f2e627]
                          - gridcell "0.000" [ref=f2e628]
                          - gridcell "0.000" [ref=f2e629]
                          - gridcell "0.000" [ref=f2e630]
                          - gridcell "0.000" [ref=f2e631]
                          - gridcell "0.000" [ref=f2e632]
                          - gridcell "9" [ref=f2e633]
                          - gridcell [ref=f2e634]
                        - row "Inventory(Simulation) 0.000 0.000 -5,589,332.000 0.000 1,245,504.000 126,764.000 -2,564,585.000 -4,397,015.000 -52,014,253.000 10":
                          - gridcell "Inventory(Simulation)" [ref=f2e635]
                          - gridcell "0.000" [ref=f2e636]
                          - gridcell "0.000" [ref=f2e637]
                          - gridcell "-5,589,332.000" [ref=f2e638]
                          - gridcell "0.000" [ref=f2e639]
                          - gridcell "1,245,504.000" [ref=f2e640]
                          - gridcell "126,764.000" [ref=f2e641]
                          - gridcell "-2,564,585.000" [ref=f2e642]
                          - gridcell "-4,397,015.000" [ref=f2e643]
                          - gridcell "-52,014,253.000" [ref=f2e644]
                          - gridcell "10" [ref=f2e645]
                          - gridcell [ref=f2e646]
                        - row "Inventory(Confirm) 0.000 0.000 -5,589,332.000 0.000 1,245,504.000 126,764.000 -2,564,585.000 -4,397,015.000 -52,014,253.000 11":
                          - gridcell "Inventory(Confirm)" [ref=f2e647]
                          - gridcell "0.000" [ref=f2e648]
                          - gridcell "0.000" [ref=f2e649]
                          - gridcell "-5,589,332.000" [ref=f2e650]
                          - gridcell "0.000" [ref=f2e651]
                          - gridcell "1,245,504.000" [ref=f2e652]
                          - gridcell "126,764.000" [ref=f2e653]
                          - gridcell "-2,564,585.000" [ref=f2e654]
                          - gridcell "-4,397,015.000" [ref=f2e655]
                          - gridcell "-52,014,253.000" [ref=f2e656]
                          - gridcell "11" [ref=f2e657]
                          - gridcell [ref=f2e658]
                        - row "APCCA3074A - CATHODE 409,645 S SCP Target (Coater) 0.000 0.000 1,711,356.000 0.000 427,839.000 427,839.000 427,839.000 427,839.000 1,526,655.000 12":
                          - gridcell "APCCA3074A" [ref=f2e659]
                          - gridcell "-" [ref=f2e660]
                          - gridcell "CATHODE" [ref=f2e661]
                          - gridcell "409,645" [ref=f2e662]
                          - gridcell "S" [ref=f2e663]
                          - gridcell "SCP Target (Coater)" [ref=f2e664]
                          - gridcell "0.000" [ref=f2e665]
                          - gridcell "0.000" [ref=f2e666]
                          - gridcell "1,711,356.000" [ref=f2e667]
                          - gridcell "0.000" [ref=f2e668]
                          - gridcell "427,839.000" [ref=f2e669]
                          - gridcell "427,839.000" [ref=f2e670]
                          - gridcell "427,839.000" [ref=f2e671]
                          - gridcell "427,839.000" [ref=f2e672]
                          - gridcell "1,526,655.000" [ref=f2e673]
                          - gridcell "12" [ref=f2e674]
                          - gridcell [ref=f2e675]
                        - row "SCP Target (Shipping Target ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 13":
                          - gridcell "SCP Target (Shipping Target ETD)" [ref=f2e676]
                          - gridcell "0.000" [ref=f2e677]
                          - gridcell "0.000" [ref=f2e678]
                          - gridcell "0.000" [ref=f2e679]
                          - gridcell "0.000" [ref=f2e680]
                          - gridcell "0.000" [ref=f2e681]
                          - gridcell "0.000" [ref=f2e682]
                          - gridcell "0.000" [ref=f2e683]
                          - gridcell "0.000" [ref=f2e684]
                          - gridcell "0.000" [ref=f2e685]
                          - gridcell "13" [ref=f2e686]
                          - gridcell [ref=f2e687]
                        - row "Shipment Request (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 14":
                          - gridcell "Shipment Request (ETD)" [ref=f2e688]
                          - gridcell "0.000" [ref=f2e689]
                          - gridcell "0.000" [ref=f2e690]
                          - gridcell "0.000" [ref=f2e691]
                          - gridcell "0.000" [ref=f2e692]
                          - gridcell "0.000" [ref=f2e693]
                          - gridcell "0.000" [ref=f2e694]
                          - gridcell "0.000" [ref=f2e695]
                          - gridcell "0.000" [ref=f2e696]
                          - gridcell "0.000" [ref=f2e697]
                          - gridcell "14" [ref=f2e698]
                          - gridcell [ref=f2e699]
                        - row "Shipment Plan (ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 15":
                          - gridcell "Shipment Plan (ETD)" [ref=f2e700]
                          - gridcell "0.000" [ref=f2e701]
                          - gridcell "0.000" [ref=f2e702]
                          - gridcell "0.000" [ref=f2e703]
                          - gridcell "0.000" [ref=f2e704]
                          - gridcell "0.000" [ref=f2e705]
                          - gridcell "0.000" [ref=f2e706]
                          - gridcell "0.000" [ref=f2e707]
                          - gridcell "0.000" [ref=f2e708]
                          - gridcell "0.000" [ref=f2e709]
                          - gridcell "15" [ref=f2e710]
                          - gridcell [ref=f2e711]
                        - row "Shipment Plan Confirm(ETD) 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.000 16":
                          - gridcell "Shipment Plan Confirm(ETD)" [ref=f2e712]
                          - gridcell "0.000" [ref=f2e713]
                          - gridcell "0.000" [ref=f2e714]
                          - gridcell "0.000" [ref=f2e715]
                          - gridcell "0.000" [ref=f2e716]
                          - gridcell "0.000" [ref=f2e717]
                          - gridcell "0.000" [ref=f2e718]
                          - gridcell "0.000" [ref=f2e719]
                          - gridcell "0.000" [ref=f2e720]
                          - gridcell "0.000" [ref=f2e721]
                          - gridcell "16" [ref=f2e722]
                          - gridcell [ref=f2e723]
                        - row "P Assy Plan(Notching) 224,243.000 224,243.000 1,322,259.000 0.000 247,177.000 381,505.000 389,136.000 304,441.000 1,701,512.000 17":
                          - gridcell "P" [ref=f2e724]
                          - gridcell "Assy Plan(Notching)" [ref=f2e725]
                          - gridcell "224,243.000" [ref=f2e726]
                          - gridcell "224,243.000" [ref=f2e727]
                          - gridcell "1,322,259.000" [ref=f2e728]
                          - gridcell "0.000" [ref=f2e729]
                          - gridcell "247,177.000" [ref=f2e730]
                          - gridcell "381,505.000" [ref=f2e731]
                          - gridcell "389,136.000" [ref=f2e732]
                          - gridcell "304,441.000" [ref=f2e733]
                          - gridcell "1,701,512.000" [ref=f2e734]
                          - gridcell "17" [ref=f2e735]
                          - gridcell [ref=f2e736]
                      - row "Focus helper":
                        - gridcell "Focus helper" [ref=f2e737]
                    - generic [aria-hidden]:
                      - gridcell [selected] [ref=f2e738]: "81"
                      - gridcell [ref=f2e739]: ACEN4069I-A1-501
                      - gridcell [ref=f2e740]: E71A-501
                      - gridcell [ref=f2e741]: MI00-E
                      - gridcell [ref=f2e742]: APCAN2950A
                      - gridcell [ref=f2e743]: "-"
                      - gridcell [ref=f2e744]: ANODE
                      - gridcell [ref=f2e745]: 343,705
                      - gridcell [ref=f2e746]: S
                      - gridcell [ref=f2e747]: SCP Target (Coater)
                      - gridcell [ref=f2e748]: SCP Target (Shipping Target ETD)
                      - gridcell [ref=f2e749]: Shipment Request (ETD)
                      - gridcell [ref=f2e750]: Shipment Plan (ETD)
                      - gridcell [ref=f2e751]: Shipment Plan Confirm(ETD)
                      - gridcell [ref=f2e752]: P
                      - gridcell [ref=f2e753]: Assy Plan(Notching)
                      - gridcell [ref=f2e754]: Coater Plan
                      - gridcell [ref=f2e755]: Coater Plan+ Post Yield
                      - gridcell [ref=f2e756]: I
                      - gridcell [ref=f2e757]: Receipt(Intransit)+Shipment Plan(In)
                      - gridcell [ref=f2e758]: Inventory(Simulation)
                      - gridcell [ref=f2e759]: Inventory(Confirm)
                      - gridcell [ref=f2e760]: APCCA3074A
                      - gridcell [ref=f2e761]: "-"
                      - gridcell [ref=f2e762]: CATHODE
                      - gridcell [ref=f2e763]: 409,645
                      - gridcell [ref=f2e764]: S
                      - gridcell [ref=f2e765]: SCP Target (Coater)
                      - gridcell [ref=f2e766]: SCP Target (Shipping Target ETD)
                      - gridcell [ref=f2e767]: Shipment Request (ETD)
                      - gridcell [ref=f2e768]: Shipment Plan (ETD)
                      - gridcell [ref=f2e769]: Shipment Plan Confirm(ETD)
                      - gridcell [ref=f2e770]: P
                      - gridcell [ref=f2e771]: Assy Plan(Notching)
                    - generic [ref=f2e772]:
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
                    - generic [ref=f2e773]:
                      - generic:
                        - row "No"
                  - generic [ref=f2e774]:
                    - status
                    - generic [ref=f2e775]: "0"
                - separator [ref=f2e776]
                - generic [ref=f2e779]:
                  - generic [ref=f2e780]:
                    - generic [ref=f2e781]:
                      - generic [ref=f2e784]:
                        - generic [ref=f2e785]: Shipment Date
                        - generic [ref=f2e792]:
                          - generic [ref=f2e795]:
                            - img [aria-hidden] [ref=f2e797] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e805]: 2026.10.08
                          - generic [ref=f2e806]: ~
                          - generic [ref=f2e809]:
                            - img [aria-hidden] [ref=f2e811] [cursor=pointer]
                            - textbox "YYYY.MM.DD" [ref=f2e819]: 2026.12.02
                      - generic [ref=f2e821]:
                        - generic [ref=f2e822]: Material
                        - generic [ref=f2e828]:
                          - textbox [ref=f2e829]
                          - button [ref=f2e830] [cursor=pointer]
                      - generic [ref=f2e836]:
                        - generic [ref=f2e837]: Model/Nickname
                        - generic [ref=f2e843]:
                          - textbox [ref=f2e844]
                          - button [ref=f2e845] [cursor=pointer]
                      - generic [ref=f2e851]:
                        - generic [ref=f2e852]: Requestor
                        - generic [ref=f2e858]:
                          - textbox [ref=f2e859]
                          - button [ref=f2e860] [cursor=pointer]
                    - button "Search" [ref=f2e866] [cursor=pointer]
                  - generic [ref=f2e867]:
                    - generic [ref=f2e868]:
                      - button "Shipment Plan Detail" [ref=f2e869]
                      - button "Stock Detail" [ref=f2e871]
                      - button "Shipment Result" [ref=f2e873]
                    - generic [ref=f2e878]:
                      - grid [ref=f2e879]:
                        - rowgroup [ref=f2e880]:
                          - generic:
                            - row "Div PO No Confirm/Plan ID Status Model Material Nick Name To Site DOM/EXP. Day Shipment Date Shipping Plan Qty Confirm Qty Gap Confirm Qty (Cut) Package Type No":
                              - columnheader "Div" [ref=f2e881]
                              - columnheader "PO No" [ref=f2e882]
                              - columnheader "Confirm/Plan ID" [ref=f2e883]
                              - columnheader "Status" [ref=f2e884]
                              - columnheader "Model" [ref=f2e885]
                              - columnheader "Material" [ref=f2e886]
                              - columnheader "Nick Name" [ref=f2e887]
                              - columnheader "To Site" [ref=f2e888]
                              - columnheader "DOM/EXP." [ref=f2e889]
                              - columnheader "Day" [ref=f2e890]
                              - columnheader "Shipment Date" [ref=f2e891]
                              - columnheader "Shipping Plan Qty" [ref=f2e892]
                              - columnheader "Confirm Qty" [ref=f2e893]
                              - columnheader "Gap" [ref=f2e894]
                              - columnheader "Confirm Qty (Cut)" [ref=f2e895]
                              - columnheader "Package Type" [ref=f2e896]
                              - gridcell "No" [ref=f2e897]
                              - gridcell [ref=f2e898]
                        - rowgroup [ref=f2e899]:
                          - row "Focus helper":
                            - gridcell "Focus helper" [ref=f2e901]
                        - generic [ref=f2e903]:
                          - generic:
                            - row "No"
                      - generic [ref=f2e904]:
                        - status
                        - generic [ref=f2e905]: "0"
                      - generic:
                        - generic [ref=f2e908]:
                          - combobox "InputDate Input" [ref=f2e909]: 2026-11-14
                          - button "Choose Date" [ref=f2e911] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e916]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e920]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e924]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e928]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e932]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e936]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e940]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e944]: "0.000"
                        - generic [ref=f2e947]:
                          - combobox "InputDate Input" [ref=f2e948]: 2026-11-14
                          - button "Choose Date" [ref=f2e950] [cursor=pointer]
                        - generic [ref=f2e954]:
                          - combobox "InputDate Input" [ref=f2e955]: 2026-11-14
                          - button "Choose Date" [ref=f2e957] [cursor=pointer]
                        - generic [ref=f2e961]:
                          - combobox "InputDateTime Input" [ref=f2e962]: 2026-11-14 23:47:49
                          - generic [ref=f2e963]:
                            - button "Toggle Calendar" [ref=f2e964] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e966] [cursor=pointer]
                        - generic [ref=f2e970]:
                          - combobox "InputDate Input" [ref=f2e971]: 2026-11-14
                          - button "Choose Date" [ref=f2e973] [cursor=pointer]
                        - spinbutton "InputNumber Input" [ref=f2e978]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e982]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e986]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e990]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e994]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e998]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e1002]: "0.000"
                        - spinbutton "InputNumber Input" [ref=f2e1006]: "0.000"
                        - generic [ref=f2e1009]:
                          - combobox "InputDate Input" [ref=f2e1010]: 2026-11-14
                          - button "Choose Date" [ref=f2e1012] [cursor=pointer]
                        - generic [ref=f2e1016]:
                          - combobox "InputDate Input" [ref=f2e1017]: 2026-11-14
                          - button "Choose Date" [ref=f2e1019] [cursor=pointer]
                        - generic [ref=f2e1023]:
                          - combobox "InputDateTime Input" [ref=f2e1024]: 2026-11-14 23:47:49
                          - generic [ref=f2e1025]:
                            - button "Toggle Calendar" [ref=f2e1026] [cursor=pointer]
                            - button "Toggle Time List" [ref=f2e1028] [cursor=pointer]
            - alert [ref=f2e1030]:
              - generic [ref=f2e1031] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1034] [cursor=pointer]:
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
      |                                                                                                                                   ^ Error: 조회조건 판정 불가(ERROR) 1: Result Type
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