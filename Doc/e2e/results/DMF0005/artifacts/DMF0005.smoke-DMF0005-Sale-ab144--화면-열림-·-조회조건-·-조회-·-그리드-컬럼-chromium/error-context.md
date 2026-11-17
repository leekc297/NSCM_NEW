# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: DMF0005.smoke.spec.ts >> DMF0005 SaleSite_PjtModelMapping 스모크 @smoke >> 화면 열림 · 조회조건 · 조회 · 그리드 컬럼
- Location: ..\..\Doc\e2e\specs\DMF0005.smoke.spec.ts:11:7

# Error details

```
Error: 조회조건 'Project' (ProjectField) — 후보 [PJT | Project]

expect(received).toBeTruthy()

Received: false
```

```
Error: 조회조건 'Detail' (Checkbox) — 후보 [Detail]

expect(received).toBeTruthy()

Received: false
```

```
Error: 그리드 컬럼 누락 (메타 기준)

expect(received).toBeLessThanOrEqual(expected)

Expected: <= 8
Received:    10
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [ref=f2e2]:
    - banner [ref=f2e3]:
      - link "SCM 공급망관리시스템 Supply Chain Management system" [ref=f2e5] [cursor=pointer]:
        - /url: /view/DMF0005
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link "Demand" [ref=f2e11] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Supply" [ref=f2e12] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Shipping" [ref=f2e13] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Report" [ref=f2e14] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Authority" [ref=f2e15] [cursor=pointer]:
          - /url: /view/DMF0005
        - link "Admin" [ref=f2e16] [cursor=pointer]:
          - /url: /view/DMF0005
      - generic [ref=f2e17]:
        - button "KOR" [ref=f2e19] [cursor=pointer]
        - button "이 이민용" [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 이
          - generic [ref=f2e29]: 이민용
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Demand
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e42]: Demand Master
            - link [ref=f2e45] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e46]: Sales Site
            - link [ref=f2e47] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e48]: Sales Site Project Model
            - link [ref=f2e49] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e50]: Sales Site Project Model
            - link [ref=f2e51] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e52]: Customer Model Mapping
            - link [ref=f2e53] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e54]: Customer FCST Master
            - link [ref=f2e55] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e56]: Sales Price
            - link [ref=f2e57] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e58]: Sales Price(82)
            - link [ref=f2e59] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e60]: Model Group Sales Price
            - link [ref=f2e61] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e62]: Contribution Rate Reg.
            - link [ref=f2e63] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e64]: Contribution Sales
            - link [ref=f2e65] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e66]: ERP EDI Master Validation
            - link [ref=f2e67] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e68]: "N: N Master Mapping"
          - generic [ref=f2e69]:
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e71]: Demand Plan
            - link "MKT FCST":
              - /url: /view/DMF0005
              - paragraph [ref=f2e74] [cursor=pointer]: MKT FCST
            - link "MKT FCST_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e75] [cursor=pointer]: MKT FCST_01
            - link "Sales Monitoring":
              - /url: /view/DMF0005
              - paragraph [ref=f2e76] [cursor=pointer]: Sales Monitoring
            - link "Customer FCST Upload":
              - /url: /view/DMF0005
              - paragraph [ref=f2e77] [cursor=pointer]: Customer FCST Upload
            - link "Business Plan":
              - /url: /view/DMF0005
              - paragraph [ref=f2e78] [cursor=pointer]: Business Plan
            - link "Sales Reports":
              - /url: /view/DMF0005
              - paragraph [ref=f2e79] [cursor=pointer]: Sales Reports
            - link "ETC Sales Reports":
              - /url: /view/DMF0005
              - paragraph [ref=f2e80] [cursor=pointer]: ETC Sales Reports
            - link "Metal Link Price":
              - /url: /view/DMF0005
              - paragraph [ref=f2e81] [cursor=pointer]: Metal Link Price
            - link "Fcst&Price MGMT":
              - /url: /view/DMF0005
              - paragraph [ref=f2e82] [cursor=pointer]: Fcst&Price MGMT
            - link "Sales Plan":
              - /url: /view/DMF0005
              - paragraph [ref=f2e83] [cursor=pointer]: Sales Plan
            - link "Sales Plan_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e84] [cursor=pointer]: Sales Plan_01
          - generic [ref=f2e85]:
            - link [ref=f2e86] [cursor=pointer]:
              - /url: /view/DMF0005
              - paragraph [ref=f2e87]: Waterfall
            - link "Demand Plan Waterfall":
              - /url: /view/DMF0005
              - paragraph [ref=f2e90] [cursor=pointer]: Demand Plan Waterfall
            - link "MKT FCST Comparison":
              - /url: /view/DMF0005
              - paragraph [ref=f2e91] [cursor=pointer]: MKT FCST Comparison
            - link "Demand Manager":
              - /url: /view/DMF0005
              - paragraph [ref=f2e92] [cursor=pointer]: Demand Manager
            - link "Customer FCST Waterfall":
              - /url: /view/DMF0005
              - paragraph [ref=f2e93] [cursor=pointer]: Customer FCST Waterfall
            - link "Demand Plan Waterfall_01":
              - /url: /view/DMF0005
              - paragraph [ref=f2e94] [cursor=pointer]: Demand Plan Waterfall_01
      - main [ref=f2e95]:
        - generic [ref=f2e97]:
          - generic [ref=f2e98]:
            - generic [ref=f2e99]:
              - button "Home" [ref=f2e100] [cursor=pointer]
              - button "Sales Site Project Model" [ref=f2e102] [cursor=pointer]
            - generic [ref=f2e107]:
              - button "Scroll tabs left" [disabled] [ref=f2e108]
              - button "Scroll tabs right" [disabled] [ref=f2e111]
              - button "Close others" [ref=f2e114] [cursor=pointer]
              - button "Close All" [ref=f2e115] [cursor=pointer]
          - generic [ref=f2e116]:
            - generic [ref=f2e119]:
              - generic [ref=f2e121]:
                - generic [ref=f2e122]:
                  - img [aria-hidden] [ref=f2e124] [cursor=pointer]
                  - paragraph [ref=f2e127]: Sales Site Project Model
                - generic [ref=f2e128]:
                  - generic [ref=f2e129]: Demand
                  - generic [ref=f2e134]: Demand Master
                  - generic [ref=f2e139]: Sales Site Project Model
                - generic [ref=f2e141]:
                  - generic [ref=f2e142]: Search Area
                  - switch [checked] [ref=f2e145] [cursor=pointer]
                - button "Full screen" [ref=f2e148] [cursor=pointer]
              - generic [ref=f2e158]:
                - generic [ref=f2e159]:
                  - generic [ref=f2e161]:
                    - generic [ref=f2e162]: Div
                    - generic [ref=f2e172]:
                      - combobox [ref=f2e173]: 40 Mobility & IT Battery
                      - button "Open" [ref=f2e175] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e180]:
                    - generic [ref=f2e181]: Team
                    - generic [ref=f2e189] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e190]
                      - button "Open" [ref=f2e192]
                      - group [aria-hidden]
                  - generic [ref=f2e197]:
                    - generic [ref=f2e198]: End Customer
                    - generic [ref=f2e206] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e207]
                      - button "Open" [ref=f2e209]
                      - group [aria-hidden]
                  - generic [ref=f2e214]:
                    - generic [ref=f2e215]: Sales Site
                    - generic [ref=f2e223] [cursor=pointer]:
                      - combobox "ALL" [ref=f2e224]
                      - button "Open" [ref=f2e226]
                      - group [aria-hidden]
                  - generic [ref=f2e231]:
                    - generic [ref=f2e232]: Model/Nickname
                    - generic [ref=f2e238]:
                      - textbox [ref=f2e239]
                      - button [ref=f2e240] [cursor=pointer]
                  - generic [ref=f2e246]:
                    - generic [ref=f2e247]: Owner
                    - generic [ref=f2e253]:
                      - textbox [ref=f2e254]
                      - button [ref=f2e255] [cursor=pointer]
                  - generic [ref=f2e261]:
                    - generic [ref=f2e262]: Active
                    - generic [ref=f2e272]:
                      - combobox [ref=f2e273]: ALL
                      - button "Open" [ref=f2e275] [cursor=pointer]
                      - group [aria-hidden]
                  - generic [ref=f2e280]:
                    - generic [ref=f2e281]:
                      - checkbox [ref=f2e284] [cursor=pointer]
                      - generic [ref=f2e285]: End Customer(Report) Null
                    - generic [ref=f2e288]:
                      - checkbox [ref=f2e291] [cursor=pointer]
                      - generic [ref=f2e292]: Project Null
                - button [active] [ref=f2e296] [cursor=pointer]
              - generic [ref=f2e301]:
                - generic [ref=f2e302]:
                  - paragraph
                  - generic [ref=f2e303]: 총15,675건
                - generic [ref=f2e304]:
                  - generic "Model Code Change" [ref=f2e305]:
                    - button "Model Code Change" [ref=f2e306] [cursor=pointer]
                  - generic "Insert Row" [ref=f2e307]:
                    - button [ref=f2e308] [cursor=pointer]
                  - generic "Remove" [ref=f2e313]:
                    - button [ref=f2e314] [cursor=pointer]
                  - generic "Save" [ref=f2e321]:
                    - button [ref=f2e322] [cursor=pointer]
                  - generic "Sort" [ref=f2e326]:
                    - button [ref=f2e327] [cursor=pointer]
                  - generic "Filter" [ref=f2e332]:
                    - button [ref=f2e333] [cursor=pointer]
                  - generic "Condition" [ref=f2e338]:
                    - button [ref=f2e339] [cursor=pointer]
                  - generic "Reset Condition" [ref=f2e349]:
                    - button [ref=f2e350] [cursor=pointer]
                  - generic "Excel" [ref=f2e357]:
                    - button [ref=f2e358] [cursor=pointer]
              - generic [ref=f2e369]:
                - grid [ref=f2e370]:
                  - rowgroup [ref=f2e371]:
                    - generic:
                      - row "Div. Team Cust Group End Customer Owner Owner Name Sold-To Rep Ship-To Sold-To Customer Cell Prod. Site (S&OP Report) Sales Site Sales Company Sales Plant No":
                        - columnheader "Div." [ref=f2e372]
                        - columnheader "Team" [ref=f2e373]
                        - columnheader "Cust Group" [ref=f2e374]
                        - columnheader "End Customer" [ref=f2e375]
                        - columnheader "Owner" [ref=f2e376]
                        - columnheader "Owner Name" [ref=f2e377]
                        - columnheader "Sold-To" [ref=f2e378]
                        - columnheader "Rep Ship-To" [ref=f2e379]
                        - columnheader "Sold-To Customer" [ref=f2e380]
                        - columnheader "Cell Prod. Site (S&OP Report)" [ref=f2e381]
                        - columnheader "Sales Site" [ref=f2e382]
                        - columnheader "Sales Company" [ref=f2e383]
                        - columnheader "Sales Plant" [ref=f2e384]
                        - gridcell "No" [ref=f2e385]
                        - gridcell [ref=f2e386]
                  - rowgroup [ref=f2e387]:
                    - generic [ref=f2e388]:
                      - row "40 AI/빅데이터1.빅데이터분석팀 LEV Aima kunwonsaw KUN WON SAW AB03499800 AB03499800 AJ상사 AJ상사_AB_TES AB00 AB00 1":
                        - gridcell "40" [selected] [ref=f2e389]
                        - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e390] [cursor=pointer]
                        - gridcell "LEV" [ref=f2e391]
                        - gridcell "Aima" [ref=f2e392]
                        - gridcell "kunwonsaw" [ref=f2e393] [cursor=pointer]
                        - gridcell "KUN WON SAW" [ref=f2e394]
                        - gridcell "AB03499800" [ref=f2e395]
                        - gridcell "AB03499800" [ref=f2e396]
                        - gridcell "AJ상사" [ref=f2e397]
                        - gridcell [ref=f2e398]
                        - gridcell "AJ상사_AB_TES" [ref=f2e399]
                        - gridcell "AB00" [ref=f2e400]
                        - gridcell "AB00" [ref=f2e401]
                        - gridcell "1" [ref=f2e402]
                        - gridcell [ref=f2e403]
                      - row "40 AI/빅데이터1.빅데이터분석팀 LEV Aima kunwonsaw KUN WON SAW AB03499800 AB03499800 AJ상사 AJ상사_AB_TES AB00 AB00 2":
                        - gridcell "40" [ref=f2e404]
                        - gridcell "AI/빅데이터1.빅데이터분석팀" [ref=f2e405] [cursor=pointer]
                        - gridcell "LEV" [ref=f2e406]
                        - gridcell "Aima" [ref=f2e407]
                        - gridcell "kunwonsaw" [ref=f2e408] [cursor=pointer]
                        - gridcell "KUN WON SAW" [ref=f2e409]
                        - gridcell "AB03499800" [ref=f2e410]
                        - gridcell "AB03499800" [ref=f2e411]
                        - gridcell "AJ상사" [ref=f2e412]
                        - gridcell [ref=f2e413]
                        - gridcell "AJ상사_AB_TES" [ref=f2e414]
                        - gridcell "AB00" [ref=f2e415]
                        - gridcell "AB00" [ref=f2e416]
                        - gridcell "2" [ref=f2e417]
                        - gridcell [ref=f2e418]
                      - row "40 ESS.SCM.SCM2팀 ESS전지 Peopleworks hyelin.jung HYE LIN JUNG KR00797800 KR00797800 Peopleworks Peopleworks_KR_KUM NJ00 NJ01 3":
                        - gridcell "40" [ref=f2e419]
                        - gridcell "ESS.SCM.SCM2팀" [ref=f2e420] [cursor=pointer]
                        - gridcell "ESS전지" [ref=f2e421]
                        - gridcell "Peopleworks" [ref=f2e422]
                        - gridcell "hyelin.jung" [ref=f2e423] [cursor=pointer]
                        - gridcell "HYE LIN JUNG" [ref=f2e424]
                        - gridcell "KR00797800" [ref=f2e425]
                        - gridcell "KR00797800" [ref=f2e426]
                        - gridcell "Peopleworks" [ref=f2e427]
                        - gridcell [ref=f2e428]
                        - gridcell "Peopleworks_KR_KUM" [ref=f2e429]
                        - gridcell "NJ00" [ref=f2e430]
                        - gridcell "NJ01" [ref=f2e431]
                        - gridcell "3" [ref=f2e432]
                        - gridcell [ref=f2e433]
                      - row "40 ESS.SCM.SCM2팀 ESS전지 Peopleworks hyelin.jung HYE LIN JUNG KR00797800 KR00797800 Peopleworks Peopleworks_KR_KUM HQ00 HQ06 4":
                        - gridcell "40" [ref=f2e434]
                        - gridcell "ESS.SCM.SCM2팀" [ref=f2e435] [cursor=pointer]
                        - gridcell "ESS전지" [ref=f2e436]
                        - gridcell "Peopleworks" [ref=f2e437]
                        - gridcell "hyelin.jung" [ref=f2e438] [cursor=pointer]
                        - gridcell "HYE LIN JUNG" [ref=f2e439]
                        - gridcell "KR00797800" [ref=f2e440]
                        - gridcell "KR00797800" [ref=f2e441]
                        - gridcell "Peopleworks" [ref=f2e442]
                        - gridcell [ref=f2e443]
                        - gridcell "Peopleworks_KR_KUM" [ref=f2e444]
                        - gridcell "HQ00" [ref=f2e445]
                        - gridcell "HQ06" [ref=f2e446]
                        - gridcell "4" [ref=f2e447]
                        - gridcell [ref=f2e448]
                      - row "40 ESS.SCM.SCM2팀 ESS전지 Peopleworks hyelin.jung HYE LIN JUNG KR00797800 KR00797800 Peopleworks Peopleworks_KR_KUM NJ00 NJ01 5":
                        - gridcell "40" [ref=f2e449]
                        - gridcell "ESS.SCM.SCM2팀" [ref=f2e450] [cursor=pointer]
                        - gridcell "ESS전지" [ref=f2e451]
                        - gridcell "Peopleworks" [ref=f2e452]
                        - gridcell "hyelin.jung" [ref=f2e453] [cursor=pointer]
                        - gridcell "HYE LIN JUNG" [ref=f2e454]
                        - gridcell "KR00797800" [ref=f2e455]
                        - gridcell "KR00797800" [ref=f2e456]
                        - gridcell "Peopleworks" [ref=f2e457]
                        - gridcell [ref=f2e458]
                        - gridcell "Peopleworks_KR_KUM" [ref=f2e459]
                        - gridcell "NJ00" [ref=f2e460]
                        - gridcell "NJ01" [ref=f2e461]
                        - gridcell "5" [ref=f2e462]
                        - gridcell [ref=f2e463]
                      - row "40 ESS.SCM.SCM2팀 ESS전지 Peopleworks hyelin.jung HYE LIN JUNG KR00797800 KR00797800 Peopleworks Peopleworks_KR_KUM NJ00 NJ01 6":
                        - gridcell "40" [ref=f2e464]
                        - gridcell "ESS.SCM.SCM2팀" [ref=f2e465] [cursor=pointer]
                        - gridcell "ESS전지" [ref=f2e466]
                        - gridcell "Peopleworks" [ref=f2e467]
                        - gridcell "hyelin.jung" [ref=f2e468] [cursor=pointer]
                        - gridcell "HYE LIN JUNG" [ref=f2e469]
                        - gridcell "KR00797800" [ref=f2e470]
                        - gridcell "KR00797800" [ref=f2e471]
                        - gridcell "Peopleworks" [ref=f2e472]
                        - gridcell [ref=f2e473]
                        - gridcell "Peopleworks_KR_KUM" [ref=f2e474]
                        - gridcell "NJ00" [ref=f2e475]
                        - gridcell "NJ01" [ref=f2e476]
                        - gridcell "6" [ref=f2e477]
                        - gridcell [ref=f2e478]
                      - row "40 ESS.SCM.SCM2팀 ESS전지 Peopleworks hyelin.jung HYE LIN JUNG KR00797800 KR00797800 Peopleworks Peopleworks_KR_KUM HQ00 HQ06 7":
                        - gridcell "40" [ref=f2e479]
                        - gridcell "ESS.SCM.SCM2팀" [ref=f2e480] [cursor=pointer]
                        - gridcell "ESS전지" [ref=f2e481]
                        - gridcell "Peopleworks" [ref=f2e482]
                        - gridcell "hyelin.jung" [ref=f2e483] [cursor=pointer]
                        - gridcell "HYE LIN JUNG" [ref=f2e484]
                        - gridcell "KR00797800" [ref=f2e485]
                        - gridcell "KR00797800" [ref=f2e486]
                        - gridcell "Peopleworks" [ref=f2e487]
                        - gridcell [ref=f2e488]
                        - gridcell "Peopleworks_KR_KUM" [ref=f2e489]
                        - gridcell "HQ00" [ref=f2e490]
                        - gridcell "HQ06" [ref=f2e491]
                        - gridcell "7" [ref=f2e492]
                        - gridcell [ref=f2e493]
                      - row "40 LGESAU Bosch Anjin kbkwon CN04980000 CN04980000 Anjin Anjin_CN_SHA HQ00 HQ04 8":
                        - gridcell "40" [ref=f2e494]
                        - gridcell "LGESAU" [ref=f2e495] [cursor=pointer]
                        - gridcell "Bosch" [ref=f2e496]
                        - gridcell "Anjin" [ref=f2e497]
                        - gridcell "kbkwon" [ref=f2e498] [cursor=pointer]
                        - gridcell [ref=f2e499]
                        - gridcell "CN04980000" [ref=f2e500]
                        - gridcell "CN04980000" [ref=f2e501]
                        - gridcell "Anjin" [ref=f2e502]
                        - gridcell [ref=f2e503]
                        - gridcell "Anjin_CN_SHA" [ref=f2e504]
                        - gridcell "HQ00" [ref=f2e505]
                        - gridcell "HQ04" [ref=f2e506]
                        - gridcell "8" [ref=f2e507]
                        - gridcell [ref=f2e508]
                      - row "40 소형.PM.PM1팀 FT IM kdh31001 DONGHOON KWON US00100700 USH700188 IM IM_US_SCZ HQ00 HQ06 9":
                        - gridcell "40" [ref=f2e509]
                        - gridcell "소형.PM.PM1팀" [ref=f2e510] [cursor=pointer]
                        - gridcell "FT" [ref=f2e511]
                        - gridcell "IM" [ref=f2e512]
                        - gridcell "kdh31001" [ref=f2e513] [cursor=pointer]
                        - gridcell "DONGHOON KWON" [ref=f2e514]
                        - gridcell "US00100700" [ref=f2e515]
                        - gridcell "USH700188" [ref=f2e516]
                        - gridcell "IM" [ref=f2e517]
                        - gridcell [ref=f2e518]
                        - gridcell "IM_US_SCZ" [ref=f2e519]
                        - gridcell "HQ00" [ref=f2e520]
                        - gridcell "HQ06" [ref=f2e521]
                        - gridcell "9" [ref=f2e522]
                        - gridcell [ref=f2e523]
                      - row "40 소형.PM.PM1팀 FT IM kdh31001 DONGHOON KWON US00100700 USH700188 IM IM_US_SCZ HQ00 HQ06 10":
                        - gridcell "40" [ref=f2e524]
                        - gridcell "소형.PM.PM1팀" [ref=f2e525] [cursor=pointer]
                        - gridcell "FT" [ref=f2e526]
                        - gridcell "IM" [ref=f2e527]
                        - gridcell "kdh31001" [ref=f2e528] [cursor=pointer]
                        - gridcell "DONGHOON KWON" [ref=f2e529]
                        - gridcell "US00100700" [ref=f2e530]
                        - gridcell "USH700188" [ref=f2e531]
                        - gridcell "IM" [ref=f2e532]
                        - gridcell [ref=f2e533]
                        - gridcell "IM_US_SCZ" [ref=f2e534]
                        - gridcell "HQ00" [ref=f2e535]
                        - gridcell "HQ06" [ref=f2e536]
                        - gridcell "10" [ref=f2e537]
                        - gridcell [ref=f2e538]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM IM_CN_NGG NJ00 NJ01 11":
                        - gridcell "40" [ref=f2e539]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e540] [cursor=pointer]
                        - gridcell "FT" [ref=f2e541]
                        - gridcell "IM" [ref=f2e542]
                        - gridcell "kyuhyeon97" [ref=f2e543] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e544]
                        - gridcell "CN01985200" [ref=f2e545]
                        - gridcell "CNH016502" [ref=f2e546]
                        - gridcell "IM" [ref=f2e547]
                        - gridcell [ref=f2e548]
                        - gridcell "IM_CN_NGG" [ref=f2e549]
                        - gridcell "NJ00" [ref=f2e550]
                        - gridcell "NJ01" [ref=f2e551]
                        - gridcell "11" [ref=f2e552]
                        - gridcell [ref=f2e553]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 12":
                        - gridcell "40" [ref=f2e554]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e555] [cursor=pointer]
                        - gridcell "FT" [ref=f2e556]
                        - gridcell "IM" [ref=f2e557]
                        - gridcell "kyuhyeon97" [ref=f2e558] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e559]
                        - gridcell "CN01985200" [ref=f2e560]
                        - gridcell "CNH016502" [ref=f2e561]
                        - gridcell "IM" [ref=f2e562]
                        - gridcell "남경" [ref=f2e563]
                        - gridcell "IM_CN_NGG" [ref=f2e564]
                        - gridcell "NJ00" [ref=f2e565]
                        - gridcell "NJ01" [ref=f2e566]
                        - gridcell "12" [ref=f2e567]
                        - gridcell [ref=f2e568]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 13":
                        - gridcell "40" [ref=f2e569]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e570] [cursor=pointer]
                        - gridcell "FT" [ref=f2e571]
                        - gridcell "IM" [ref=f2e572]
                        - gridcell "kyuhyeon97" [ref=f2e573] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e574]
                        - gridcell "CN01985200" [ref=f2e575]
                        - gridcell "CNH016502" [ref=f2e576]
                        - gridcell "IM" [ref=f2e577]
                        - gridcell "남경" [ref=f2e578]
                        - gridcell "IM_CN_NGG" [ref=f2e579]
                        - gridcell "NJ00" [ref=f2e580]
                        - gridcell "NJ01" [ref=f2e581]
                        - gridcell "13" [ref=f2e582]
                        - gridcell [ref=f2e583]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 14":
                        - gridcell "40" [ref=f2e584]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e585] [cursor=pointer]
                        - gridcell "FT" [ref=f2e586]
                        - gridcell "IM" [ref=f2e587]
                        - gridcell "kyuhyeon97" [ref=f2e588] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e589]
                        - gridcell "CN01985200" [ref=f2e590]
                        - gridcell "CNH016502" [ref=f2e591]
                        - gridcell "IM" [ref=f2e592]
                        - gridcell "남경" [ref=f2e593]
                        - gridcell "IM_CN_NGG" [ref=f2e594]
                        - gridcell "NJ00" [ref=f2e595]
                        - gridcell "NJ01" [ref=f2e596]
                        - gridcell "14" [ref=f2e597]
                        - gridcell [ref=f2e598]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM gwonjung JIWON JUNG CN01985200 CNH016502 IM 오창 IM_CN_NGG HQ00 HQ06 15":
                        - gridcell "40" [ref=f2e599]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e600] [cursor=pointer]
                        - gridcell "FT" [ref=f2e601]
                        - gridcell "IM" [ref=f2e602]
                        - gridcell "gwonjung" [ref=f2e603] [cursor=pointer]
                        - gridcell "JIWON JUNG" [ref=f2e604]
                        - gridcell "CN01985200" [ref=f2e605]
                        - gridcell "CNH016502" [ref=f2e606]
                        - gridcell "IM" [ref=f2e607]
                        - gridcell "오창" [ref=f2e608]
                        - gridcell "IM_CN_NGG" [ref=f2e609]
                        - gridcell "HQ00" [ref=f2e610]
                        - gridcell "HQ06" [ref=f2e611]
                        - gridcell "15" [ref=f2e612]
                        - gridcell [ref=f2e613]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM gwonjung JIWON JUNG CN01985200 CNH016502 IM 오창 IM_CN_NGG HQ00 HQ06 16":
                        - gridcell "40" [ref=f2e614]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e615] [cursor=pointer]
                        - gridcell "FT" [ref=f2e616]
                        - gridcell "IM" [ref=f2e617]
                        - gridcell "gwonjung" [ref=f2e618] [cursor=pointer]
                        - gridcell "JIWON JUNG" [ref=f2e619]
                        - gridcell "CN01985200" [ref=f2e620]
                        - gridcell "CNH016502" [ref=f2e621]
                        - gridcell "IM" [ref=f2e622]
                        - gridcell "오창" [ref=f2e623]
                        - gridcell "IM_CN_NGG" [ref=f2e624]
                        - gridcell "HQ00" [ref=f2e625]
                        - gridcell "HQ06" [ref=f2e626]
                        - gridcell "16" [ref=f2e627]
                        - gridcell [ref=f2e628]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 17":
                        - gridcell "40" [ref=f2e629]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e630] [cursor=pointer]
                        - gridcell "FT" [ref=f2e631]
                        - gridcell "IM" [ref=f2e632]
                        - gridcell "kyuhyeon97" [ref=f2e633] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e634]
                        - gridcell "CN01985200" [ref=f2e635]
                        - gridcell "CNH016502" [ref=f2e636]
                        - gridcell "IM" [ref=f2e637]
                        - gridcell "남경" [ref=f2e638]
                        - gridcell "IM_CN_NGG" [ref=f2e639]
                        - gridcell "NJ00" [ref=f2e640]
                        - gridcell "NJ01" [ref=f2e641]
                        - gridcell "17" [ref=f2e642]
                        - gridcell [ref=f2e643]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM juno95 JUNOH KIM CN01985200 CNH016502 IM 오창 IM_CN_NGG HQ00 HQ06 18":
                        - gridcell "40" [ref=f2e644]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e645] [cursor=pointer]
                        - gridcell "FT" [ref=f2e646]
                        - gridcell "IM" [ref=f2e647]
                        - gridcell "juno95" [ref=f2e648] [cursor=pointer]
                        - gridcell "JUNOH KIM" [ref=f2e649]
                        - gridcell "CN01985200" [ref=f2e650]
                        - gridcell "CNH016502" [ref=f2e651]
                        - gridcell "IM" [ref=f2e652]
                        - gridcell "오창" [ref=f2e653]
                        - gridcell "IM_CN_NGG" [ref=f2e654]
                        - gridcell "HQ00" [ref=f2e655]
                        - gridcell "HQ06" [ref=f2e656]
                        - gridcell "18" [ref=f2e657]
                        - gridcell [ref=f2e658]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 19":
                        - gridcell "40" [ref=f2e659]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e660] [cursor=pointer]
                        - gridcell "FT" [ref=f2e661]
                        - gridcell "IM" [ref=f2e662]
                        - gridcell "kyuhyeon97" [ref=f2e663] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e664]
                        - gridcell "CN01985200" [ref=f2e665]
                        - gridcell "CNH016502" [ref=f2e666]
                        - gridcell "IM" [ref=f2e667]
                        - gridcell "남경" [ref=f2e668]
                        - gridcell "IM_CN_NGG" [ref=f2e669]
                        - gridcell "NJ00" [ref=f2e670]
                        - gridcell "NJ01" [ref=f2e671]
                        - gridcell "19" [ref=f2e672]
                        - gridcell [ref=f2e673]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM juno95 JUNOH KIM CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 20":
                        - gridcell "40" [ref=f2e674]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e675] [cursor=pointer]
                        - gridcell "FT" [ref=f2e676]
                        - gridcell "IM" [ref=f2e677]
                        - gridcell "juno95" [ref=f2e678] [cursor=pointer]
                        - gridcell "JUNOH KIM" [ref=f2e679]
                        - gridcell "CN01985200" [ref=f2e680]
                        - gridcell "CNH016502" [ref=f2e681]
                        - gridcell "IM" [ref=f2e682]
                        - gridcell "남경" [ref=f2e683]
                        - gridcell "IM_CN_NGG" [ref=f2e684]
                        - gridcell "NJ00" [ref=f2e685]
                        - gridcell "NJ01" [ref=f2e686]
                        - gridcell "20" [ref=f2e687]
                        - gridcell [ref=f2e688]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 21":
                        - gridcell "40" [ref=f2e689]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e690] [cursor=pointer]
                        - gridcell "FT" [ref=f2e691]
                        - gridcell "IM" [ref=f2e692]
                        - gridcell "kyuhyeon97" [ref=f2e693] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e694]
                        - gridcell "CN01985200" [ref=f2e695]
                        - gridcell "CNH016502" [ref=f2e696]
                        - gridcell "IM" [ref=f2e697]
                        - gridcell "남경" [ref=f2e698]
                        - gridcell "IM_CN_NGG" [ref=f2e699]
                        - gridcell "NJ00" [ref=f2e700]
                        - gridcell "NJ01" [ref=f2e701]
                        - gridcell "21" [ref=f2e702]
                        - gridcell [ref=f2e703]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM juno95 JUNOH KIM CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 22":
                        - gridcell "40" [ref=f2e704]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e705] [cursor=pointer]
                        - gridcell "FT" [ref=f2e706]
                        - gridcell "IM" [ref=f2e707]
                        - gridcell "juno95" [ref=f2e708] [cursor=pointer]
                        - gridcell "JUNOH KIM" [ref=f2e709]
                        - gridcell "CN01985200" [ref=f2e710]
                        - gridcell "CNH016502" [ref=f2e711]
                        - gridcell "IM" [ref=f2e712]
                        - gridcell "남경" [ref=f2e713]
                        - gridcell "IM_CN_NGG" [ref=f2e714]
                        - gridcell "NJ00" [ref=f2e715]
                        - gridcell "NJ01" [ref=f2e716]
                        - gridcell "22" [ref=f2e717]
                        - gridcell [ref=f2e718]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 23":
                        - gridcell "40" [ref=f2e719]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e720] [cursor=pointer]
                        - gridcell "FT" [ref=f2e721]
                        - gridcell "IM" [ref=f2e722]
                        - gridcell "kyuhyeon97" [ref=f2e723] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e724]
                        - gridcell "CN01985200" [ref=f2e725]
                        - gridcell "CNH016502" [ref=f2e726]
                        - gridcell "IM" [ref=f2e727]
                        - gridcell "남경" [ref=f2e728]
                        - gridcell "IM_CN_NGG" [ref=f2e729]
                        - gridcell "NJ00" [ref=f2e730]
                        - gridcell "NJ01" [ref=f2e731]
                        - gridcell "23" [ref=f2e732]
                        - gridcell [ref=f2e733]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 24":
                        - gridcell "40" [ref=f2e734]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e735] [cursor=pointer]
                        - gridcell "FT" [ref=f2e736]
                        - gridcell "IM" [ref=f2e737]
                        - gridcell "kyuhyeon97" [ref=f2e738] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e739]
                        - gridcell "CN01985200" [ref=f2e740]
                        - gridcell "CNH016502" [ref=f2e741]
                        - gridcell "IM" [ref=f2e742]
                        - gridcell "남경" [ref=f2e743]
                        - gridcell "IM_CN_NGG" [ref=f2e744]
                        - gridcell "NJ00" [ref=f2e745]
                        - gridcell "NJ01" [ref=f2e746]
                        - gridcell "24" [ref=f2e747]
                        - gridcell [ref=f2e748]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 25":
                        - gridcell "40" [ref=f2e749]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e750] [cursor=pointer]
                        - gridcell "FT" [ref=f2e751]
                        - gridcell "IM" [ref=f2e752]
                        - gridcell "kyuhyeon97" [ref=f2e753] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e754]
                        - gridcell "CN01985200" [ref=f2e755]
                        - gridcell "CNH016502" [ref=f2e756]
                        - gridcell "IM" [ref=f2e757]
                        - gridcell "남경" [ref=f2e758]
                        - gridcell "IM_CN_NGG" [ref=f2e759]
                        - gridcell "NJ00" [ref=f2e760]
                        - gridcell "NJ01" [ref=f2e761]
                        - gridcell "25" [ref=f2e762]
                        - gridcell [ref=f2e763]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 26":
                        - gridcell "40" [ref=f2e764]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e765] [cursor=pointer]
                        - gridcell "FT" [ref=f2e766]
                        - gridcell "IM" [ref=f2e767]
                        - gridcell "kyuhyeon97" [ref=f2e768] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e769]
                        - gridcell "CN01985200" [ref=f2e770]
                        - gridcell "CNH016502" [ref=f2e771]
                        - gridcell "IM" [ref=f2e772]
                        - gridcell "남경" [ref=f2e773]
                        - gridcell "IM_CN_NGG" [ref=f2e774]
                        - gridcell "NJ00" [ref=f2e775]
                        - gridcell "NJ01" [ref=f2e776]
                        - gridcell "26" [ref=f2e777]
                        - gridcell [ref=f2e778]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 27":
                        - gridcell "40" [ref=f2e779]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e780] [cursor=pointer]
                        - gridcell "FT" [ref=f2e781]
                        - gridcell "IM" [ref=f2e782]
                        - gridcell "kyuhyeon97" [ref=f2e783] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e784]
                        - gridcell "CN01985200" [ref=f2e785]
                        - gridcell "CNH016502" [ref=f2e786]
                        - gridcell "IM" [ref=f2e787]
                        - gridcell "남경" [ref=f2e788]
                        - gridcell "IM_CN_NGG" [ref=f2e789]
                        - gridcell "NJ00" [ref=f2e790]
                        - gridcell "NJ01" [ref=f2e791]
                        - gridcell "27" [ref=f2e792]
                        - gridcell [ref=f2e793]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 28":
                        - gridcell "40" [ref=f2e794]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e795] [cursor=pointer]
                        - gridcell "FT" [ref=f2e796]
                        - gridcell "IM" [ref=f2e797]
                        - gridcell "kyuhyeon97" [ref=f2e798] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e799]
                        - gridcell "CN01985200" [ref=f2e800]
                        - gridcell "CNH016502" [ref=f2e801]
                        - gridcell "IM" [ref=f2e802]
                        - gridcell "남경" [ref=f2e803]
                        - gridcell "IM_CN_NGG" [ref=f2e804]
                        - gridcell "NJ00" [ref=f2e805]
                        - gridcell "NJ01" [ref=f2e806]
                        - gridcell "28" [ref=f2e807]
                        - gridcell [ref=f2e808]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 29":
                        - gridcell "40" [ref=f2e809]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e810] [cursor=pointer]
                        - gridcell "FT" [ref=f2e811]
                        - gridcell "IM" [ref=f2e812]
                        - gridcell "kyuhyeon97" [ref=f2e813] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e814]
                        - gridcell "CN01985200" [ref=f2e815]
                        - gridcell "CNH016502" [ref=f2e816]
                        - gridcell "IM" [ref=f2e817]
                        - gridcell "남경" [ref=f2e818]
                        - gridcell "IM_CN_NGG" [ref=f2e819]
                        - gridcell "NJ00" [ref=f2e820]
                        - gridcell "NJ01" [ref=f2e821]
                        - gridcell "29" [ref=f2e822]
                        - gridcell [ref=f2e823]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 30":
                        - gridcell "40" [ref=f2e824]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e825] [cursor=pointer]
                        - gridcell "FT" [ref=f2e826]
                        - gridcell "IM" [ref=f2e827]
                        - gridcell "kyuhyeon97" [ref=f2e828] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e829]
                        - gridcell "CN01985200" [ref=f2e830]
                        - gridcell "CNH016502" [ref=f2e831]
                        - gridcell "IM" [ref=f2e832]
                        - gridcell "남경" [ref=f2e833]
                        - gridcell "IM_CN_NGG" [ref=f2e834]
                        - gridcell "NJ00" [ref=f2e835]
                        - gridcell "NJ01" [ref=f2e836]
                        - gridcell "30" [ref=f2e837]
                        - gridcell [ref=f2e838]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 31":
                        - gridcell "40" [ref=f2e839]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e840] [cursor=pointer]
                        - gridcell "FT" [ref=f2e841]
                        - gridcell "IM" [ref=f2e842]
                        - gridcell "kyuhyeon97" [ref=f2e843] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e844]
                        - gridcell "CN01985200" [ref=f2e845]
                        - gridcell "CNH016502" [ref=f2e846]
                        - gridcell "IM" [ref=f2e847]
                        - gridcell "남경" [ref=f2e848]
                        - gridcell "IM_CN_NGG" [ref=f2e849]
                        - gridcell "NJ00" [ref=f2e850]
                        - gridcell "NJ01" [ref=f2e851]
                        - gridcell "31" [ref=f2e852]
                        - gridcell [ref=f2e853]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 32":
                        - gridcell "40" [ref=f2e854]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e855] [cursor=pointer]
                        - gridcell "FT" [ref=f2e856]
                        - gridcell "IM" [ref=f2e857]
                        - gridcell "kyuhyeon97" [ref=f2e858] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e859]
                        - gridcell "CN01985200" [ref=f2e860]
                        - gridcell "CNH016502" [ref=f2e861]
                        - gridcell "IM" [ref=f2e862]
                        - gridcell "남경" [ref=f2e863]
                        - gridcell "IM_CN_NGG" [ref=f2e864]
                        - gridcell "NJ00" [ref=f2e865]
                        - gridcell "NJ01" [ref=f2e866]
                        - gridcell "32" [ref=f2e867]
                        - gridcell [ref=f2e868]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 33":
                        - gridcell "40" [ref=f2e869]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e870] [cursor=pointer]
                        - gridcell "FT" [ref=f2e871]
                        - gridcell "IM" [ref=f2e872]
                        - gridcell "kyuhyeon97" [ref=f2e873] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e874]
                        - gridcell "CN01985200" [ref=f2e875]
                        - gridcell "CNH016502" [ref=f2e876]
                        - gridcell "IM" [ref=f2e877]
                        - gridcell "남경" [ref=f2e878]
                        - gridcell "IM_CN_NGG" [ref=f2e879]
                        - gridcell "NJ00" [ref=f2e880]
                        - gridcell "NJ01" [ref=f2e881]
                        - gridcell "33" [ref=f2e882]
                        - gridcell [ref=f2e883]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 34":
                        - gridcell "40" [ref=f2e884]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e885] [cursor=pointer]
                        - gridcell "FT" [ref=f2e886]
                        - gridcell "IM" [ref=f2e887]
                        - gridcell "kyuhyeon97" [ref=f2e888] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e889]
                        - gridcell "CN01985200" [ref=f2e890]
                        - gridcell "CNH016502" [ref=f2e891]
                        - gridcell "IM" [ref=f2e892]
                        - gridcell "남경" [ref=f2e893]
                        - gridcell "IM_CN_NGG" [ref=f2e894]
                        - gridcell "NJ00" [ref=f2e895]
                        - gridcell "NJ01" [ref=f2e896]
                        - gridcell "34" [ref=f2e897]
                        - gridcell [ref=f2e898]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 35":
                        - gridcell "40" [ref=f2e899]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e900] [cursor=pointer]
                        - gridcell "FT" [ref=f2e901]
                        - gridcell "IM" [ref=f2e902]
                        - gridcell "kyuhyeon97" [ref=f2e903] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e904]
                        - gridcell "CN01985200" [ref=f2e905]
                        - gridcell "CNH016502" [ref=f2e906]
                        - gridcell "IM" [ref=f2e907]
                        - gridcell "남경" [ref=f2e908]
                        - gridcell "IM_CN_NGG" [ref=f2e909]
                        - gridcell "NJ00" [ref=f2e910]
                        - gridcell "NJ01" [ref=f2e911]
                        - gridcell "35" [ref=f2e912]
                        - gridcell [ref=f2e913]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 36":
                        - gridcell "40" [ref=f2e914]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e915] [cursor=pointer]
                        - gridcell "FT" [ref=f2e916]
                        - gridcell "IM" [ref=f2e917]
                        - gridcell "kyuhyeon97" [ref=f2e918] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e919]
                        - gridcell "CN01985200" [ref=f2e920]
                        - gridcell "CNH016502" [ref=f2e921]
                        - gridcell "IM" [ref=f2e922]
                        - gridcell "남경" [ref=f2e923]
                        - gridcell "IM_CN_NGG" [ref=f2e924]
                        - gridcell "NJ00" [ref=f2e925]
                        - gridcell "NJ01" [ref=f2e926]
                        - gridcell "36" [ref=f2e927]
                        - gridcell [ref=f2e928]
                      - row "40 소형.마케팅.FT.FT1팀 FT IM kyuhyeon97 KYUHYEON LEE CN01985200 CNH016502 IM 남경 IM_CN_NGG NJ00 NJ01 37":
                        - gridcell "40" [ref=f2e929]
                        - gridcell "소형.마케팅.FT.FT1팀" [ref=f2e930] [cursor=pointer]
                        - gridcell "FT" [ref=f2e931]
                        - gridcell "IM" [ref=f2e932]
                        - gridcell "kyuhyeon97" [ref=f2e933] [cursor=pointer]
                        - gridcell "KYUHYEON LEE" [ref=f2e934]
                        - gridcell "CN01985200" [ref=f2e935]
                        - gridcell "CNH016502" [ref=f2e936]
                        - gridcell "IM" [ref=f2e937]
                        - gridcell "남경" [ref=f2e938]
                        - gridcell "IM_CN_NGG" [ref=f2e939]
                        - gridcell "NJ00" [ref=f2e940]
                        - gridcell "NJ01" [ref=f2e941]
                        - gridcell "37" [ref=f2e942]
                        - gridcell [ref=f2e943]
                    - row "Focus helper":
                      - gridcell "Focus helper" [ref=f2e944]
                  - generic [aria-hidden]:
                    - gridcell [selected] [ref=f2e945]: "40"
                    - gridcell [ref=f2e946]: "40"
                    - gridcell [ref=f2e947]: "40"
                    - gridcell [ref=f2e948]: "40"
                    - gridcell [ref=f2e949]: "40"
                    - gridcell [ref=f2e950]: "40"
                    - gridcell [ref=f2e951]: "40"
                    - gridcell [ref=f2e952]: "40"
                    - gridcell [ref=f2e953]: "40"
                    - gridcell [ref=f2e954]: "40"
                    - gridcell [ref=f2e955]: "40"
                    - gridcell [ref=f2e956]: "40"
                    - gridcell [ref=f2e957]: "40"
                    - gridcell [ref=f2e958]: "40"
                    - gridcell [ref=f2e959]: "40"
                    - gridcell [ref=f2e960]: "40"
                    - gridcell [ref=f2e961]: "40"
                    - gridcell [ref=f2e962]: "40"
                    - gridcell [ref=f2e963]: "40"
                    - gridcell [ref=f2e964]: "40"
                    - gridcell [ref=f2e965]: "40"
                    - gridcell [ref=f2e966]: "40"
                    - gridcell [ref=f2e967]: "40"
                    - gridcell [ref=f2e968]: "40"
                    - gridcell [ref=f2e969]: "40"
                    - gridcell [ref=f2e970]: "40"
                    - gridcell [ref=f2e971]: "40"
                    - gridcell [ref=f2e972]: "40"
                    - gridcell [ref=f2e973]: "40"
                    - gridcell [ref=f2e974]: "40"
                    - gridcell [ref=f2e975]: "40"
                    - gridcell [ref=f2e976]: "40"
                    - gridcell [ref=f2e977]: "40"
                    - gridcell [ref=f2e978]: "40"
                    - gridcell [ref=f2e979]: "40"
                    - gridcell [ref=f2e980]: "40"
                    - gridcell [ref=f2e981]: "40"
                  - generic [ref=f2e982]:
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
                  - generic [ref=f2e983]:
                    - generic:
                      - row "No"
                - generic [ref=f2e984]:
                  - status
                  - generic [ref=f2e985]: "0"
                - generic:
                  - spinbutton "InputNumber Input" [ref=f2e989]: "0.000"
                  - generic [ref=f2e992]:
                    - combobox "InputDateTime Input" [ref=f2e993]: 2026-11-14 05:53:17
                    - generic [ref=f2e994]:
                      - button "Toggle Calendar" [ref=f2e995] [cursor=pointer]
                      - button "Toggle Time List" [ref=f2e997] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e1002]: "0.000"
                  - generic [ref=f2e1005]:
                    - combobox "InputDateTime Input" [ref=f2e1006]: 2026-11-14 05:53:18
                    - generic [ref=f2e1007]:
                      - button "Toggle Calendar" [ref=f2e1008] [cursor=pointer]
                      - button "Toggle Time List" [ref=f2e1010] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e1015]: "0.000"
                  - generic [ref=f2e1018]:
                    - combobox "InputDateTime Input" [ref=f2e1019]: 2026-11-14 05:53:30
                    - generic [ref=f2e1020]:
                      - button "Toggle Calendar" [ref=f2e1021] [cursor=pointer]
                      - button "Toggle Time List" [ref=f2e1023] [cursor=pointer]
                  - spinbutton "InputNumber Input" [ref=f2e1028]: "0.000"
                  - generic [ref=f2e1031]:
                    - combobox "InputDateTime Input" [ref=f2e1032]: 2026-11-14 05:53:30
                    - generic [ref=f2e1033]:
                      - button "Toggle Calendar" [ref=f2e1034] [cursor=pointer]
                      - button "Toggle Time List" [ref=f2e1036] [cursor=pointer]
            - alert [ref=f2e1038]:
              - generic [ref=f2e1039] [cursor=pointer]
  - link "Wijmo Evaluation Version (5.20252.44)" [ref=f2e1042] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
```

# Test source

```ts
  1   | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-13) · 원천: Doc/gen/DMF0005/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2   | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3   | import * as fs from 'node:fs';
  4   | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/DMF0005.plan.json', 'utf8'));
  5   | const MENU = "DMF0005";
  6   | import { conditionCycle, commonCycle, record } from '../../../tools/E2E/lib/smoke-extra';
  7   | import { loadLabelAliases, aliasFor } from '../../../tools/E2E/lib/labelalias';  // 2026-11-08 (a) 사양 표 공유 — 검사기(_trace G4)와 같은 라벨 별칭 표(label_alias.csv · CR-092 Valid→Active)
  8   | 
  9   | test.describe(`${MENU} SaleSite_PjtModelMapping 스모크 @smoke`, () => {
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
> 64  |     expect.soft(missing.length, `그리드 컬럼 누락 (${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
      |                                                                                       ^ Error: 그리드 컬럼 누락 (메타 기준)
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