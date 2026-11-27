# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: DMF0042.authcrud.spec.ts >> DMF0042 권한별 CRUD @authcrud [k0101 ADMIN/DM ADMIN/DM Planner/DM Planner (W/S)/FP Viewer/GUEST/JV Planner/SCM PI Admin/SCP Planner/SSP Viewer] >> 메뉴 접근 → 기대 버튼(SAVE/INSERT/DELETE/EDIT) ↔ 실제 노출·편집 → 허용이면 마커 행 CRUD · 비허용이면 편집 불가
- Location: ..\..\Doc\e2e\specs\DMF0042.authcrud.spec.ts:17:9

# Error details

```
Error: [k0101 40] 조회 결과 DIVISION 값 = 선택 Division

expect(received).toBeTruthy()

Received: false
```

```
Error: [k0101] 허용 계정 마커 행 저장 

expect(received).toBeTruthy()

Received: false
```

```
Error: [k0101] 재조회 후 신규 행 존재

expect(received).toBeTruthy()

Received: false
```

# Page snapshot

```yaml
- generic [ref=f2e1]:
  - generic [aria-hidden] [ref=f2e2]:
    - banner [ref=f2e3]:
      - link [ref=f2e5] [cursor=pointer]:
        - /url: /view/DMF0042
        - generic [ref=f2e6]: SCM
        - generic [ref=f2e7]:
          - generic [ref=f2e8]: 공급망관리시스템
          - generic [ref=f2e9]: Supply Chain Management system
      - navigation [ref=f2e10]:
        - link [ref=f2e11] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Demand
        - link [ref=f2e12] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Supply
        - link [ref=f2e13] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Shipping
        - link [ref=f2e14] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Report
        - link [ref=f2e15] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Authority
        - link [ref=f2e16] [cursor=pointer]:
          - /url: /view/DMF0042
          - text: Admin
      - generic [ref=f2e17]:
        - button [ref=f2e19] [cursor=pointer]:
          - generic [ref=f2e20]: KOR
        - button [ref=f2e23] [cursor=pointer]:
          - paragraph [ref=f2e28]: 김
          - generic [ref=f2e29]: 김현기
    - generic [ref=f2e30]:
      - button [ref=f2e31] [cursor=pointer]
      - complementary [ref=f2e37]:
        - navigation [ref=f2e38]:
          - paragraph [ref=f2e39]: Demand
          - generic [ref=f2e40]:
            - link [ref=f2e41] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e42]: Demand Master
            - paragraph [ref=f2e45] [cursor=pointer]: Sales Site
            - paragraph [ref=f2e46] [cursor=pointer]: Sales Site Project Model
            - paragraph [ref=f2e47] [cursor=pointer]: Customer Model Mapping
            - paragraph [ref=f2e48] [cursor=pointer]: Customer FCST Master
            - paragraph [ref=f2e49] [cursor=pointer]: Sales Price(ESS)
            - paragraph [ref=f2e50] [cursor=pointer]: Model Group Sales Price
            - paragraph [ref=f2e51] [cursor=pointer]: Contribution Rate Reg.
            - paragraph [ref=f2e52] [cursor=pointer]: Contribution Sales
            - paragraph [ref=f2e53] [cursor=pointer]: ERP EDI Master Validation
            - paragraph [ref=f2e54] [cursor=pointer]: "N: N Master Mapping"
          - generic [ref=f2e55]:
            - link [ref=f2e56] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e57]: Demand Plan
            - link [ref=f2e60] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e61]: MKT FCST(ESS)
            - link [ref=f2e62] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e63]: Sales Monitoring
            - link [ref=f2e64] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e65]: Customer FCST Upload
            - link [ref=f2e66] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e67]: Business Plan
            - link [ref=f2e68] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e69]: Sales Reports
            - link [ref=f2e70] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e71]: ETC Sales Reports
            - link [ref=f2e72] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e73]: Metal Link Price
            - link [ref=f2e74] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e75]: Fcst&Price MGMT
            - link [ref=f2e76] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e77]: Sales Plan
          - generic [ref=f2e78]:
            - link [ref=f2e79] [cursor=pointer]:
              - /url: /view/DMF0042
              - paragraph [ref=f2e80]: Waterfall
            - paragraph [ref=f2e83] [cursor=pointer]: MKT FCST Comparison
            - paragraph [ref=f2e84] [cursor=pointer]: Demand Manager
            - paragraph [ref=f2e85] [cursor=pointer]: Customer FCST Waterfall
            - paragraph [ref=f2e86] [cursor=pointer]: Demand Plan Waterfall
      - main [ref=f2e87]:
        - generic [ref=f2e89]:
          - generic [ref=f2e90]:
            - generic [ref=f2e91]:
              - button [ref=f2e92] [cursor=pointer]:
                - generic [ref=f2e93]: Home
              - button [ref=f2e94] [cursor=pointer]:
                - generic [ref=f2e95]: Business Plan
            - generic [ref=f2e99]:
              - button [disabled] [ref=f2e100]
              - button [disabled] [ref=f2e103]
              - button [ref=f2e106] [cursor=pointer]: Close others
              - button [ref=f2e107] [cursor=pointer]: Close All
          - generic [ref=f2e108]:
            - generic [ref=f2e111]:
              - generic [ref=f2e113]:
                - generic [ref=f2e114]:
                  - img [aria-hidden] [ref=f2e116] [cursor=pointer]
                  - paragraph [ref=f2e119]: Business Plan
                - generic [ref=f2e120]:
                  - generic [ref=f2e121]: Demand
                  - generic [ref=f2e126]: Demand Plan
                  - generic [ref=f2e131]: Business Plan
                - generic [ref=f2e133]:
                  - generic [ref=f2e134]: Search Area
                  - switch [checked] [ref=f2e137] [cursor=pointer]
                - button [ref=f2e140] [cursor=pointer]
              - generic [ref=f2e150]:
                - generic [ref=f2e151]:
                  - generic [ref=f2e152]:
                    - generic [ref=f2e154]:
                      - generic [ref=f2e155]: Div
                      - generic [ref=f2e165]:
                        - combobox [ref=f2e166]: 40 Mobility & IT Battery
                        - button [ref=f2e168] [cursor=pointer]
                        - group [aria-hidden]
                    - generic [ref=f2e173]:
                      - generic [ref=f2e174]: Team
                      - generic [ref=f2e182] [cursor=pointer]:
                        - combobox [ref=f2e183]
                        - button [ref=f2e185]
                        - group [aria-hidden]
                    - generic [ref=f2e190]:
                      - generic [ref=f2e191]: End Customer
                      - generic [ref=f2e199] [cursor=pointer]:
                        - combobox [ref=f2e200]
                        - button [ref=f2e202]
                        - group [aria-hidden]
                    - generic [ref=f2e207]:
                      - generic [ref=f2e208]: Sales Site
                      - generic [ref=f2e216] [cursor=pointer]:
                        - combobox [ref=f2e217]
                        - button [ref=f2e219]
                        - group [aria-hidden]
                    - generic [ref=f2e224]:
                      - generic [ref=f2e225]: Plant Site
                      - generic [ref=f2e233] [cursor=pointer]:
                        - combobox [disabled] [ref=f2e234]
                        - generic [ref=f2e235]:
                          - button [disabled]
                        - group [aria-hidden]
                    - generic [ref=f2e237]:
                      - generic [ref=f2e238]: Biz. Type
                      - generic [ref=f2e246] [cursor=pointer]:
                        - combobox [ref=f2e247]
                        - button [ref=f2e249]
                        - group [aria-hidden]
                    - generic [ref=f2e254]:
                      - generic [ref=f2e255]: Period
                      - generic [ref=f2e262]:
                        - generic [ref=f2e265]:
                          - img [aria-hidden] [ref=f2e267] [cursor=pointer]
                          - textbox [ref=f2e275]:
                            - /placeholder: YYYY.MM.DD
                            - text: 2026.11.01
                        - generic [ref=f2e276]: ~
                        - generic [ref=f2e279]:
                          - img [aria-hidden] [ref=f2e281] [cursor=pointer]
                          - textbox [ref=f2e289]:
                            - /placeholder: YYYY.MM.DD
                            - text: 2027.05.31
                    - generic [ref=f2e291]:
                      - generic [ref=f2e292]: Bucket
                      - generic [ref=f2e300]:
                        - combobox [ref=f2e301]: Monthly
                        - button [ref=f2e303] [cursor=pointer]
                        - group [aria-hidden]
                  - generic [ref=f2e307]:
                    - button [ref=f2e308] [cursor=pointer]: Search(F5)
                    - button [ref=f2e313] [cursor=pointer]
                - generic [ref=f2e318]:
                  - separator [ref=f2e319]
                  - generic [ref=f2e321]:
                    - generic [ref=f2e323]:
                      - generic [ref=f2e324]: Project
                      - generic [ref=f2e329]:
                        - textbox [disabled] [ref=f2e332]
                        - button [disabled]
                    - generic [ref=f2e334]:
                      - generic [ref=f2e335]: Model/Nickname
                      - generic [ref=f2e340]:
                        - textbox [ref=f2e343]
                        - button [ref=f2e344] [cursor=pointer]
                    - generic [ref=f2e350]:
                      - generic [ref=f2e351]: Owner
                      - generic [ref=f2e356]:
                        - textbox [ref=f2e359]
                        - button [ref=f2e360] [cursor=pointer]
                    - generic [ref=f2e366]:
                      - generic [ref=f2e367]: Item Type
                      - generic [ref=f2e375] [cursor=pointer]:
                        - combobox [ref=f2e376]
                        - button [ref=f2e378]
                        - group [aria-hidden]
                    - generic [ref=f2e390]:
                      - generic [ref=f2e391] [cursor=pointer]:
                        - checkbox [checked] [ref=f2e393]
                        - generic [ref=f2e396]: Sum
                      - generic [ref=f2e397] [cursor=pointer]:
                        - checkbox [ref=f2e399]
                        - generic [ref=f2e400]: Qty≠0
              - generic [ref=f2e401]:
                - generic [ref=f2e402]: 총7,580건
                - generic [ref=f2e404]:
                  - button [ref=f2e406] [cursor=pointer]: Set Price
                  - button [ref=f2e408] [cursor=pointer]
                  - button [ref=f2e413] [cursor=pointer]: Ver. Cutoff
                  - button [ref=f2e415] [cursor=pointer]: Replace
                  - button [ref=f2e417] [cursor=pointer]
                  - button [ref=f2e422] [cursor=pointer]: Insert(F8)
                  - button [ref=f2e428] [cursor=pointer]: Delete(F9)
                  - button [ref=f2e436] [cursor=pointer]: Save(F7)
                  - button [ref=f2e441] [cursor=pointer]: Sort(F3)
                  - button [ref=f2e447] [cursor=pointer]: Filter(F4)
                  - button [ref=f2e453] [cursor=pointer]: Condition(F6)
                  - button [ref=f2e464] [cursor=pointer]: Reset Condition(F10)
                  - button [ref=f2e472] [cursor=pointer]
              - generic [ref=f2e480]:
                - grid [ref=f2e481]:
                  - rowgroup [ref=f2e482]:
                    - columnheader [ref=f2e483]: Division
                    - columnheader [ref=f2e484]: Team
                    - columnheader [ref=f2e485]: End Customer
                    - columnheader [ref=f2e486]: Sales Site
                    - columnheader [ref=f2e487]: Model
                    - columnheader [ref=f2e488]: Model Name
                    - columnheader [ref=f2e489]: Rep. Incoterms
                    - columnheader [ref=f2e490]: FCST Type
                    - columnheader [ref=f2e491]: Cell Prod Site
                    - columnheader [ref=f2e492]: Currency
                    - columnheader [ref=f2e493]: Energy(WH)
                    - columnheader [ref=f2e494]: Measure
                    - columnheader [ref=f2e495]: "2026"
                    - columnheader [ref=f2e496]: "2027"
                    - gridcell [ref=f2e497]: No.
                    - gridcell [ref=f2e498]
                    - columnheader [ref=f2e499]: SUM
                    - columnheader [ref=f2e500]: Q4
                    - columnheader [ref=f2e501]: SUM
                    - columnheader [ref=f2e502]: SUM
                    - columnheader [ref=f2e503]: 2026-11
                    - columnheader [ref=f2e504]: 2026-12
                  - rowgroup [ref=f2e505]:
                    - generic [ref=f2e506]:
                      - gridcell [selected] [ref=f2e507]: "40"
                      - gridcell [ref=f2e508]
                      - gridcell [ref=f2e509]
                      - gridcell [ref=f2e510]:
                        - button [ref=f2e511] [cursor=pointer]
                      - gridcell [ref=f2e513] [cursor=pointer]
                      - gridcell [ref=f2e514]
                      - gridcell [ref=f2e515]:
                        - button [ref=f2e516] [cursor=pointer]
                      - gridcell [ref=f2e518]:
                        - button [ref=f2e519] [cursor=pointer]
                      - gridcell [ref=f2e521]:
                        - button [ref=f2e522] [cursor=pointer]
                      - gridcell [ref=f2e524]:
                        - button [ref=f2e525] [cursor=pointer]
                      - gridcell [ref=f2e527]
                      - gridcell [ref=f2e528]: Business Plan
                      - gridcell [ref=f2e529]
                      - gridcell [ref=f2e530]
                      - gridcell [ref=f2e531]
                      - gridcell [ref=f2e532]
                      - gridcell [ref=f2e533]
                      - gridcell [ref=f2e534]: "1"
                      - gridcell [ref=f2e535]: I
                      - gridcell [ref=f2e536]: Unit Price(LOC)
                      - gridcell [ref=f2e537]
                      - gridcell [ref=f2e538]
                      - gridcell [ref=f2e539]
                      - gridcell [ref=f2e540]
                      - gridcell [ref=f2e541]
                      - gridcell [ref=f2e542]: "2"
                      - gridcell [ref=f2e543]: I
                      - gridcell [ref=f2e544]: Sales Amt.(KRW)
                      - gridcell [ref=f2e545]
                      - gridcell [ref=f2e546]
                      - gridcell [ref=f2e547]
                      - gridcell [ref=f2e548]
                      - gridcell [ref=f2e549]
                      - gridcell [ref=f2e550]: "3"
                      - gridcell [ref=f2e551]: I
                      - gridcell [ref=f2e552]: Sales Amt.(LOC)
                      - gridcell [ref=f2e553]
                      - gridcell [ref=f2e554]
                      - gridcell [ref=f2e555]
                      - gridcell [ref=f2e556]
                      - gridcell [ref=f2e557]
                      - gridcell [ref=f2e558]: "4"
                      - gridcell [ref=f2e559]: I
                      - gridcell [ref=f2e560]: "40"
                      - gridcell [ref=f2e561]: 소형.마케팅.신시장.신시장1팀
                      - gridcell [ref=f2e562]: NT
                      - gridcell [ref=f2e563]: BYD Electronics_CN_SZX
                      - gridcell [ref=f2e564]: MCSS22561-C1
                      - gridcell [ref=f2e565]: MC,S,S,4623,25mAh,6,1,C1
                      - gridcell [ref=f2e566]: DAP
                      - gridcell [ref=f2e567]: Mass
                      - gridcell [ref=f2e568]: 남경
                      - gridcell [ref=f2e569]: USD
                      - gridcell [ref=f2e570]: "0.096"
                      - gridcell [ref=f2e571]: Business Plan
                      - gridcell [ref=f2e572]
                      - gridcell [ref=f2e573]
                      - gridcell [ref=f2e574]
                      - gridcell [ref=f2e575]
                      - gridcell [ref=f2e576]: "0.000"
                      - gridcell [ref=f2e577]: "5"
                      - gridcell [ref=f2e578]
                      - gridcell [ref=f2e579]: Unit Price(LOC)
                      - gridcell [ref=f2e580]
                      - gridcell [ref=f2e581]
                      - gridcell [ref=f2e582]
                      - gridcell [ref=f2e583]
                      - gridcell [ref=f2e584]: "0.000"
                      - gridcell [ref=f2e585]: "6"
                      - gridcell [ref=f2e586]
                      - gridcell [ref=f2e587]: Sales Amt.(KRW)
                      - gridcell [ref=f2e588]
                      - gridcell [ref=f2e589]
                      - gridcell [ref=f2e590]
                      - gridcell [ref=f2e591]
                      - gridcell [ref=f2e592]: "0.000"
                      - gridcell [ref=f2e593]: "7"
                      - gridcell [ref=f2e594]
                      - gridcell [ref=f2e595]: Sales Amt.(LOC)
                      - gridcell [ref=f2e596]
                      - gridcell [ref=f2e597]
                      - gridcell [ref=f2e598]
                      - gridcell [ref=f2e599]
                      - gridcell [ref=f2e600]: "0.000"
                      - gridcell [ref=f2e601]: "8"
                      - gridcell [ref=f2e602]
                      - gridcell [ref=f2e603]: MCSS56831-A1
                      - gridcell [ref=f2e604]: MC,S,S,5735,72.5mAh,1,1,A1
                      - gridcell [ref=f2e605]: DAP
                      - gridcell [ref=f2e606]: Mass
                      - gridcell [ref=f2e607]: 남경
                      - gridcell [ref=f2e608]: USD
                      - gridcell [ref=f2e609]: "0.280"
                      - gridcell [ref=f2e610]: Business Plan
                      - gridcell [ref=f2e611]
                      - gridcell [ref=f2e612]
                      - gridcell [ref=f2e613]
                      - gridcell [ref=f2e614]
                      - gridcell [ref=f2e615]: 3,528,750.000
                      - gridcell [ref=f2e616]: "9"
                      - gridcell [ref=f2e617]
                      - gridcell [ref=f2e618]: Unit Price(LOC)
                      - gridcell [ref=f2e619]
                      - gridcell [ref=f2e620]
                      - gridcell [ref=f2e621]
                      - gridcell [ref=f2e622]
                      - gridcell [ref=f2e623]: "1.390"
                      - gridcell [ref=f2e624]: "10"
                      - gridcell [ref=f2e625]
                      - gridcell [ref=f2e626]: Sales Amt.(KRW)
                      - gridcell [ref=f2e627]
                      - gridcell [ref=f2e628]
                      - gridcell [ref=f2e629]
                      - gridcell [ref=f2e630]
                      - gridcell [ref=f2e631]: 6,534,821,550.000
                      - gridcell [ref=f2e632]: "11"
                      - gridcell [ref=f2e633]
                      - gridcell [ref=f2e634]: Sales Amt.(LOC)
                      - gridcell [ref=f2e635]
                      - gridcell [ref=f2e636]
                      - gridcell [ref=f2e637]
                      - gridcell [ref=f2e638]
                      - gridcell [ref=f2e639]: 4,876,732.500
                      - gridcell [ref=f2e640]: "12"
                      - gridcell [ref=f2e641]
                      - gridcell [ref=f2e642]: Desay_CN_HUI
                      - gridcell [ref=f2e643]: MDP2949A9B11
                      - gridcell [ref=f2e644]: MD,P,2.9㎜,49㎜,109㎜,B11
                      - gridcell [ref=f2e645]: DDP
                      - gridcell [ref=f2e646]: Mass
                      - gridcell [ref=f2e647]: 남경
                      - gridcell [ref=f2e648]: USD
                      - gridcell [ref=f2e649]: "10.38"
                      - gridcell [ref=f2e650]: Business Plan
                      - gridcell [ref=f2e651]
                      - gridcell [ref=f2e652]
                      - gridcell [ref=f2e653]
                      - gridcell [ref=f2e654]
                      - gridcell [ref=f2e655]: "0.000"
                      - gridcell [ref=f2e656]: "13"
                      - gridcell [ref=f2e657]
                      - gridcell [ref=f2e658]: Unit Price(LOC)
                      - gridcell [ref=f2e659]
                      - gridcell [ref=f2e660]
                      - gridcell [ref=f2e661]
                      - gridcell [ref=f2e662]
                      - gridcell [ref=f2e663]: "3.460"
                      - gridcell [ref=f2e664]: "14"
                      - gridcell [ref=f2e665]
                      - gridcell [ref=f2e666]: Sales Amt.(KRW)
                      - gridcell [ref=f2e667]
                      - gridcell [ref=f2e668]
                      - gridcell [ref=f2e669]
                      - gridcell [ref=f2e670]
                      - gridcell [ref=f2e671]: "0.000"
                      - gridcell [ref=f2e672]: "15"
                      - gridcell [ref=f2e673]
                      - gridcell [ref=f2e674]: Sales Amt.(LOC)
                      - gridcell [ref=f2e675]
                      - gridcell [ref=f2e676]
                      - gridcell [ref=f2e677]
                      - gridcell [ref=f2e678]
                      - gridcell [ref=f2e679]: "0.000"
                      - gridcell [ref=f2e680]: "16"
                      - gridcell [ref=f2e681]
                      - gridcell [ref=f2e682]: MDP343993A11
                      - gridcell [ref=f2e683]: MD,P,3.4㎜,39㎜,93㎜,A11
                      - gridcell [ref=f2e684]: DDP
                      - gridcell [ref=f2e685]: Mass
                      - gridcell [ref=f2e686]: 남경
                      - gridcell [ref=f2e687]: USD
                      - gridcell [ref=f2e688]: "7.55"
                      - gridcell [ref=f2e689]: Business Plan
                      - gridcell [ref=f2e690]
                      - gridcell [ref=f2e691]
                      - gridcell [ref=f2e692]
                      - gridcell [ref=f2e693]
                      - gridcell [ref=f2e694]: "0.000"
                      - gridcell [ref=f2e695]: "17"
                      - gridcell [ref=f2e696]
                      - gridcell [ref=f2e697]: Unit Price(LOC)
                      - gridcell [ref=f2e698]
                      - gridcell [ref=f2e699]
                      - gridcell [ref=f2e700]
                      - gridcell [ref=f2e701]
                      - gridcell [ref=f2e702]: "2.260"
                      - gridcell [ref=f2e703]: "18"
                      - gridcell [ref=f2e704]
                      - gridcell [ref=f2e705]: Sales Amt.(KRW)
                      - gridcell [ref=f2e706]
                      - gridcell [ref=f2e707]
                      - gridcell [ref=f2e708]
                      - gridcell [ref=f2e709]
                      - gridcell [ref=f2e710]: "0.000"
                      - gridcell [ref=f2e711]: "19"
                      - gridcell [ref=f2e712]
                      - gridcell [ref=f2e713]: Sales Amt.(LOC)
                      - gridcell [ref=f2e714]
                      - gridcell [ref=f2e715]
                      - gridcell [ref=f2e716]
                      - gridcell [ref=f2e717]
                      - gridcell [ref=f2e718]: "0.000"
                      - gridcell [ref=f2e719]: "20"
                      - gridcell [ref=f2e720]
                      - gridcell [ref=f2e721]: MIF469958A11
                      - gridcell [ref=f2e722]: MI,F,4.6㎜,99㎜,58㎜,A11
                      - gridcell [ref=f2e723]: DDP
                      - gridcell [ref=f2e724]: Mass
                      - gridcell [ref=f2e725]: 남경
                      - gridcell [ref=f2e726]: USD
                      - gridcell [ref=f2e727]: "11.73"
                      - gridcell [ref=f2e728]: Business Plan
                      - gridcell [ref=f2e729]
                      - gridcell [ref=f2e730]
                      - gridcell [ref=f2e731]
                      - gridcell [ref=f2e732]
                      - gridcell [ref=f2e733]: 5,000.000
                      - gridcell [ref=f2e734]: "21"
                      - gridcell [ref=f2e735]
                      - gridcell [ref=f2e736]: Unit Price(LOC)
                      - gridcell [ref=f2e737]
                      - gridcell [ref=f2e738]
                      - gridcell [ref=f2e739]
                      - gridcell [ref=f2e740]
                      - gridcell [ref=f2e741]: "6.550"
                      - gridcell [ref=f2e742]: "22"
                      - gridcell [ref=f2e743]
                      - gridcell [ref=f2e744]: Sales Amt.(KRW)
                      - gridcell [ref=f2e745]
                      - gridcell [ref=f2e746]
                      - gridcell [ref=f2e747]
                      - gridcell [ref=f2e748]
                      - gridcell [ref=f2e749]: 43,885,000.000
                      - gridcell [ref=f2e750]: "23"
                      - gridcell [ref=f2e751]
                      - gridcell [ref=f2e752]: Sales Amt.(LOC)
                      - gridcell [ref=f2e753]
                      - gridcell [ref=f2e754]
                      - gridcell [ref=f2e755]
                      - gridcell [ref=f2e756]
                      - gridcell [ref=f2e757]: 32,750.000
                      - gridcell [ref=f2e758]: "24"
                      - gridcell [ref=f2e759]
                      - gridcell [ref=f2e760]: Foxlink_CN_DGG
                      - gridcell [ref=f2e761]: MCSS20253-A2
                      - gridcell [ref=f2e762]: MC,S,S,4623,2mAh,5,3,A2
                      - gridcell [ref=f2e763]: DAP
                      - gridcell [ref=f2e764]: Mass
                      - gridcell [ref=f2e765]: 남경
                      - gridcell [ref=f2e766]: USD
                      - gridcell [ref=f2e767]: "0.1"
                      - gridcell [ref=f2e768]: Business Plan
                      - gridcell [ref=f2e769]: "0.000"
                      - gridcell [ref=f2e770]: "0.000"
                      - gridcell [ref=f2e771]: "0.000"
                      - gridcell [ref=f2e772]: "0.000"
                      - gridcell [ref=f2e773]: "0.000"
                      - gridcell [ref=f2e774]: "25"
                      - gridcell [ref=f2e775]
                      - gridcell [ref=f2e776]: Unit Price(LOC)
                      - gridcell [ref=f2e777]: "0.000"
                      - gridcell [ref=f2e778]: "0.000"
                      - gridcell [ref=f2e779]: "0.000"
                      - gridcell [ref=f2e780]: "0.000"
                      - gridcell [ref=f2e781]: "0.000"
                      - gridcell [ref=f2e782]: "26"
                      - gridcell [ref=f2e783]
                      - gridcell [ref=f2e784]: Sales Amt.(KRW)
                      - gridcell [ref=f2e785]: "0.000"
                      - gridcell [ref=f2e786]: "0.000"
                      - gridcell [ref=f2e787]: "0.000"
                      - gridcell [ref=f2e788]: "0.000"
                      - gridcell [ref=f2e789]: "0.000"
                      - gridcell [ref=f2e790]: "27"
                      - gridcell [ref=f2e791]
                      - gridcell [ref=f2e792]: Sales Amt.(LOC)
                      - gridcell [ref=f2e793]: "0.000"
                      - gridcell [ref=f2e794]: "0.000"
                      - gridcell [ref=f2e795]: "0.000"
                      - gridcell [ref=f2e796]: "0.000"
                      - gridcell [ref=f2e797]: "0.000"
                      - gridcell [ref=f2e798]: "28"
                      - gridcell [ref=f2e799]
                      - gridcell [ref=f2e800]: MCSS22531-B1
                      - gridcell [ref=f2e801]: MC,S,S,4623,25mAh,3,1,B1
                      - gridcell [ref=f2e802]: DAP
                      - gridcell [ref=f2e803]: Mass
                      - gridcell [ref=f2e804]: 남경
                      - gridcell [ref=f2e805]: USD
                      - gridcell [ref=f2e806]: "0.096"
                      - gridcell [ref=f2e807]: Business Plan
                      - gridcell [ref=f2e808]: 1,666,667.000
                      - gridcell [ref=f2e809]: 1,666,667.000
                      - gridcell [ref=f2e810]: 833,333.000
                      - gridcell [ref=f2e811]: 833,334.000
                      - gridcell [ref=f2e812]: 333,332.000
                      - gridcell [ref=f2e813]: "29"
                      - gridcell [ref=f2e814]
                      - gridcell [ref=f2e815]: Unit Price(LOC)
                      - gridcell [ref=f2e816]: "0.630"
                      - gridcell [ref=f2e817]: "0.630"
                      - gridcell [ref=f2e818]: "0.630"
                      - gridcell [ref=f2e819]: "0.630"
                      - gridcell [ref=f2e820]: "0.620"
                      - gridcell [ref=f2e821]: "30"
                      - gridcell [ref=f2e822]
                      - gridcell [ref=f2e823]: Sales Amt.(KRW)
                      - gridcell [ref=f2e824]: 1,396,500,279.300
                      - gridcell [ref=f2e825]: 1,396,500,279.300
                      - gridcell [ref=f2e826]: 698,249,720.700
                      - gridcell [ref=f2e827]: 698,250,558.600
                      - gridcell [ref=f2e828]: 276,932,225.600
                      - gridcell [ref=f2e829]: "31"
                      - gridcell [ref=f2e830]
                    - gridcell [ref=f2e831]
                  - generic [aria-hidden]:
                    - gridcell [selected] [ref=f2e832]: "40"
                    - gridcell [ref=f2e833]
                    - gridcell [ref=f2e834]
                    - gridcell [ref=f2e835]:
                      - button [ref=f2e836] [cursor=pointer]
                    - gridcell [ref=f2e838] [cursor=pointer]
                    - gridcell [ref=f2e839]
                    - gridcell [ref=f2e840]:
                      - button [ref=f2e841] [cursor=pointer]
                    - gridcell [ref=f2e843]:
                      - button [ref=f2e844] [cursor=pointer]
                    - gridcell [ref=f2e846]:
                      - button [ref=f2e847] [cursor=pointer]
                    - gridcell [ref=f2e849]:
                      - button [ref=f2e850] [cursor=pointer]
                    - gridcell [ref=f2e852]
                    - gridcell [ref=f2e853]: Business Plan
                    - gridcell [ref=f2e854]: Unit Price(LOC)
                    - gridcell [ref=f2e855]: Sales Amt.(KRW)
                    - gridcell [ref=f2e856]: Sales Amt.(LOC)
                    - gridcell [ref=f2e857]: "40"
                    - gridcell [ref=f2e858]: 소형.마케팅.신시장.신시장1팀
                    - gridcell [ref=f2e859]: NT
                    - gridcell [ref=f2e860]: BYD Electronics_CN_SZX
                    - gridcell [ref=f2e861]: MCSS22561-C1
                    - gridcell [ref=f2e862]: MC,S,S,4623,25mAh,6,1,C1
                    - gridcell [ref=f2e863]: DAP
                    - gridcell [ref=f2e864]: Mass
                    - gridcell [ref=f2e865]: 남경
                    - gridcell [ref=f2e866]: USD
                    - gridcell [ref=f2e867]: "0.096"
                    - gridcell [ref=f2e868]: Business Plan
                    - gridcell [ref=f2e869]: Unit Price(LOC)
                    - gridcell [ref=f2e870]: Sales Amt.(KRW)
                    - gridcell [ref=f2e871]: Sales Amt.(LOC)
                    - gridcell [ref=f2e872]: MCSS56831-A1
                    - gridcell [ref=f2e873]: MC,S,S,5735,72.5mAh,1,1,A1
                    - gridcell [ref=f2e874]: DAP
                    - gridcell [ref=f2e875]: Mass
                    - gridcell [ref=f2e876]: 남경
                    - gridcell [ref=f2e877]: USD
                    - gridcell [ref=f2e878]: "0.280"
                    - gridcell [ref=f2e879]: Business Plan
                    - gridcell [ref=f2e880]: Unit Price(LOC)
                    - gridcell [ref=f2e881]: Sales Amt.(KRW)
                    - gridcell [ref=f2e882]: Sales Amt.(LOC)
                    - gridcell [ref=f2e883]: Desay_CN_HUI
                    - gridcell [ref=f2e884]: MDP2949A9B11
                    - gridcell [ref=f2e885]: MD,P,2.9㎜,49㎜,109㎜,B11
                    - gridcell [ref=f2e886]: DDP
                    - gridcell [ref=f2e887]: Mass
                    - gridcell [ref=f2e888]: 남경
                    - gridcell [ref=f2e889]: USD
                    - gridcell [ref=f2e890]: "10.38"
                    - gridcell [ref=f2e891]: Business Plan
                    - gridcell [ref=f2e892]: Unit Price(LOC)
                    - gridcell [ref=f2e893]: Sales Amt.(KRW)
                    - gridcell [ref=f2e894]: Sales Amt.(LOC)
                    - gridcell [ref=f2e895]: MDP343993A11
                    - gridcell [ref=f2e896]: MD,P,3.4㎜,39㎜,93㎜,A11
                    - gridcell [ref=f2e897]: DDP
                    - gridcell [ref=f2e898]: Mass
                    - gridcell [ref=f2e899]: 남경
                    - gridcell [ref=f2e900]: USD
                    - gridcell [ref=f2e901]: "7.55"
                    - gridcell [ref=f2e902]: Business Plan
                    - gridcell [ref=f2e903]: Unit Price(LOC)
                    - gridcell [ref=f2e904]: Sales Amt.(KRW)
                    - gridcell [ref=f2e905]: Sales Amt.(LOC)
                    - gridcell [ref=f2e906]: MIF469958A11
                    - gridcell [ref=f2e907]: MI,F,4.6㎜,99㎜,58㎜,A11
                    - gridcell [ref=f2e908]: DDP
                    - gridcell [ref=f2e909]: Mass
                    - gridcell [ref=f2e910]: 남경
                    - gridcell [ref=f2e911]: USD
                    - gridcell [ref=f2e912]: "11.73"
                    - gridcell [ref=f2e913]: Business Plan
                    - gridcell [ref=f2e914]: Unit Price(LOC)
                    - gridcell [ref=f2e915]: Sales Amt.(KRW)
                    - gridcell [ref=f2e916]: Sales Amt.(LOC)
                    - gridcell [ref=f2e917]: Foxlink_CN_DGG
                    - gridcell [ref=f2e918]: MCSS20253-A2
                    - gridcell [ref=f2e919]: MC,S,S,4623,2mAh,5,3,A2
                    - gridcell [ref=f2e920]: DAP
                    - gridcell [ref=f2e921]: Mass
                    - gridcell [ref=f2e922]: 남경
                    - gridcell [ref=f2e923]: USD
                    - gridcell [ref=f2e924]: "0.1"
                    - gridcell [ref=f2e925]: Business Plan
                    - gridcell [ref=f2e926]: Unit Price(LOC)
                    - gridcell [ref=f2e927]: Sales Amt.(KRW)
                    - gridcell [ref=f2e928]: Sales Amt.(LOC)
                    - gridcell [ref=f2e929]: MCSS22531-B1
                    - gridcell [ref=f2e930]: MC,S,S,4623,25mAh,3,1,B1
                    - gridcell [ref=f2e931]: DAP
                    - gridcell [ref=f2e932]: Mass
                    - gridcell [ref=f2e933]: 남경
                    - gridcell [ref=f2e934]: USD
                    - gridcell [ref=f2e935]: "0.096"
                    - gridcell [ref=f2e936]: Business Plan
                    - gridcell [ref=f2e937]: Unit Price(LOC)
                    - gridcell [ref=f2e938]: Sales Amt.(KRW)
                - generic [ref=f2e941]: "0"
                - spinbutton [ref=f2e946]: "0.000"
                - spinbutton [ref=f2e950]: "0.000"
                - spinbutton [ref=f2e954]: "0.000"
                - spinbutton [ref=f2e958]: "0.000"
            - alert [ref=f2e959]:
              - generic [ref=f2e960] [cursor=pointer]
  - link [ref=f2e963] [cursor=pointer]:
    - /url: https://developer.mescius.com/licensing/wijmo?utm_source=Wijmo-In-App&utm_medium=Click-to-Site&utm_campaign=Wijmo-User-Analysis
    - text: Wijmo Evaluation Version (5.20252.44)
  - dialog [ref=f2e966]:
    - generic [ref=f2e967]:
      - generic [ref=f2e968]:
        - generic [ref=f2e969]:
          - heading [level=2]
        - img [aria-hidden] [ref=f2e972] [cursor=pointer]
      - generic [ref=f2e975]: 수정 중인 데이터가 있습니다. 조회 하시겠습니까?
      - generic [ref=f2e976]:
        - button "Cancel" [ref=f2e977] [cursor=pointer]
        - button "Confirm" [active] [ref=f2e978] [cursor=pointer]
```

# Test source

```ts
  1  | // 자동 생성 — tools/E2E/gen-e2e.js (2026-11-26) · 원천: Doc/gen/DMF0042/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것
  2  | import { test, expect } from '../../../tools/E2E/fixtures/test';
  3  | import * as fs from 'node:fs';
  4  | const PLAN = JSON.parse(fs.readFileSync(__dirname + '/DMF0042.plan.json', 'utf8'));
  5  | const MENU = "DMF0042";
  6  | import { crudCycle } from '../../../tools/E2E/lib/crud';
  7  | import { divisionCascade } from '../../../tools/E2E/lib/cascade';
  8  | 
  9  | // 계정별 권한 CRUD — 기대 권한은 To-Be 메타(그룹 소속 user_group_user.csv × 버튼 권한 btn_auth.csv), 데이터셋 그룹은 표기만. 로그인은 비밀번호 없는 /user/login(id)
  10 | const CODES: string[] = PLAN.menuBtnCodes || [];
  11 | const has = (arr: string[] | null, code: string) => arr ? arr.includes(code) : null;
  12 | for (const acc of PLAN.accounts) {
  13 |   const G = (acc.tobeGroups && acc.tobeGroups.length ? acc.tobeGroups : acc.groups) as string[];
  14 |   test.describe(`${MENU} 권한별 CRUD @authcrud [${acc.id} ${G.join('/')}]`, () => {
  15 |     test.use({ account: acc.id });
  16 |     const MARK = "E2E_" + acc.id.replace(/[^A-Za-z0-9]/g, '').slice(0, 6).toUpperCase() + Date.now().toString(36).toUpperCase().slice(-4);
  17 |     test('메뉴 접근 → 기대 버튼(SAVE/INSERT/DELETE/EDIT) ↔ 실제 노출·편집 → 허용이면 마커 행 CRUD · 비허용이면 편집 불가', async ({ nscm }) => {
  18 |       test.setTimeout(420_000); // 로그인 → 조회(최대 searchTimeoutMs) → CRUD 사이클(저장·재조회 반복) 예산
  19 |       const expSave = has(acc.expectedBtns, 'SAVE'), expIns = CODES.includes('INSERT') ? has(acc.expectedBtns, 'INSERT') : null, expDel = CODES.includes('DELETE') ? has(acc.expectedBtns, 'DELETE') : null, expEdit = CODES.includes('EDIT') ? has(acc.expectedBtns, 'EDIT') : null;
  20 |       test.info().annotations.push({ type: 'authcrud', description: `tobeGroups=${G.join('|') || '-'} menuAccess=${acc.menuAccess || '?'} expected=${acc.expectedBtns ? acc.expectedBtns.join('|') : '(btn_auth 미등록)'} dataset=${acc.groups.join('|')} matrix=${(acc.matrix || []).join(' ') || '-'}` });
  21 |       const r = await nscm.openScreen(MENU);
  22 |       if (!r.authorized || r.notFound) { expect.soft(acc.menuAccess, `[${acc.id}] 메뉴 권한 있음(user_group_menu) 인데 접근 불가 (authorized=${r.authorized} notFound=${r.notFound})`).not.toBe('Y'); return; }
  23 |       // 메뉴 권한 없는 계정도 URL 직접 접근으로는 열린다(To-Be FE 라우트 가드 없음) → 기록하고, 버튼·편집은 '없어야 함' 으로 계속 검증
  24 |       if (acc.menuAccess === 'N') test.info().annotations.push({ type: 'gap', description: `메뉴 권한(user_group_menu) 없는 계정이 /view/${MENU} 직접 접근으로 열림` });
  25 |       // 2026-10-27: division 모드(사용자가 화면 지정) = 계정이 대표하는 Division 마다 CASCADE → 조회 → CRUD. 그 외 모드 = 첫 Division 1회(CASCADE 확인 포함)
  26 |       const divs: string[] = (PLAN.mode === 'division' ? (acc.divisions && acc.divisions.length ? acc.divisions : [PLAN.sample.div]) : [(acc.divisions && acc.divisions[0]) || PLAN.sample.div]).filter(Boolean);
  27 |       test.setTimeout(120_000 + Math.max(1, divs.length) * 420_000);
  28 |       let out: any = null;
  29 |       for (const div of divs) {
  30 |         const cas = await divisionCascade(nscm, test.info(), PLAN, acc, div);
  31 |         if (acc.expectedDivs) expect.soft(cas.leak, `[${acc.id} ${div}] Division 후보 ⊆ 계정 Division 권한(unit_auth) — 권한 밖 Division 노출 0`).toEqual([]);
  32 |         if (cas.divListed !== null) expect.soft(cas.divListed, `[${acc.id}] 대표 Division ${div} 가 Division 후보에 있음`).toBeTruthy();
  33 |         for (const d of cas.deps) expect.soft(d.count, `[${acc.id} ${div}] Division 연동 조회조건 [${d.label}] 후보 1건 이상(CASCADE)`).toBeGreaterThan(0);
  34 |         const calls = await nscm.search(); for (const c of calls) expect.soft(c.status, `[${acc.id} ${div}] call-proc ${c.sheet}/${c.btn}`).toBeLessThan(400);
  35 |         const alert = await nscm.alertText(); if (alert) await nscm.closeAlert();
  36 |         const divVals = (await nscm.gridColumnValues('DIVISION')).concat(await nscm.gridColumnValues('DIVISION_ID')).concat(await nscm.gridColumnValues('Division'));
  37 |         if (divVals.length) expect.soft(divVals.every(v => !v || v.startsWith(div)), `[${acc.id} ${div}] 조회 결과 DIVISION 값 = 선택 Division`).toBeTruthy();
  38 |         const o = await crudCycle(nscm, test.info(), PLAN, MARK + (divs.length > 1 ? div.replace(/[^A-Za-z0-9]/g, '') : ''));
  39 |         test.info().annotations.push({ type: 'authcrud', description: `${acc.id} div=${div} mode=${o.mode} save=${o.saveVisible} insert=${o.insertVisible} delete=${o.deleteVisible} editable=${o.editable} saved=${o.saved} found=${o.found} cleaned=${o.cleaned} restored=${o.restored}` });
  40 |         out = out ? Object.assign({}, out, { saved: out.saved && o.saved, found: out.found && o.found, cleaned: out.cleaned && o.cleaned, restored: out.restored && o.restored, saveCalls: out.saveCalls + o.saveCalls, saveErrors: out.saveErrors.concat(o.saveErrors) }) : o;
  41 |       }
  42 |       if (!out) return;
  43 |       // 버튼 노출 ↔ 기대
  44 |       if (expSave != null) expect.soft(out.saveVisible, `[${acc.id} ${G.join('/')}] btn_auth SAVE=${expSave ? 'Y' : 'N'} → Save 버튼 ${expSave ? '노출' : '비노출'}`).toBe(expSave);
  45 |       if (expIns != null) expect.soft(out.insertVisible, `[${acc.id}] btn_auth INSERT=${expIns ? 'Y' : 'N'} → Insert 버튼`).toBe(expIns);
  46 |       if (expDel != null) expect.soft(out.deleteVisible, `[${acc.id}] btn_auth DELETE=${expDel ? 'Y' : 'N'} → Delete 버튼`).toBe(expDel);
  47 |       // EDIT 코드 = 셀 편집 권한 → 편집기 열림 여부와 대조(판정 가능할 때만)
  48 |       if (expEdit != null && out.editable != null) expect.soft(out.editable, `[${acc.id}] btn_auth EDIT=${expEdit ? 'Y' : 'N'} → 셀 편집기 ${expEdit ? '열림' : '안 열림'}`).toBe(expEdit);
  49 |       if (expSave === true) {
> 50 |         if (out.mode === 'insert') { expect.soft(out.saved, `[${acc.id}] 허용 계정 마커 행 저장 ${out.saveErrors.join(' / ')}`).toBeTruthy(); expect.soft(out.found, `[${acc.id}] 재조회 후 신규 행 존재`).toBeTruthy(); expect(out.cleaned, `[${acc.id}] 마커 행 정리 완료`).toBeTruthy(); }
     |                                                                                                                                                                                          ^ Error: [k0101] 재조회 후 신규 행 존재
  51 |         else if (out.mode === 'edit-save') { expect.soft(out.editable, `[${acc.id}] 허용 계정 편집 가능 셀 존재`).toBeTruthy(); if (out.editable) { expect.soft(out.saved, `[${acc.id}] 수정 저장 성공 ${out.saveErrors.join(' / ')}`).toBeTruthy(); expect.soft(out.found, `[${acc.id}] 재조회 후 수정값 반영`).toBeTruthy(); expect(out.restored, `[${acc.id}] 원래 값 복원 저장·확인`).toBeTruthy(); } }
  52 |       } else if (expSave === false) {
  53 |         if (out.editable != null) expect.soft(out.editable, `[${acc.id}] 비허용 계정 셀 편집 불가`).toBeFalsy();
  54 |         expect.soft(out.saveCalls, `[${acc.id}] 비허용 계정 SAVE 계열 call-proc 0`).toBe(0);
  55 |       } else test.info().annotations.push({ type: 'note', description: 'btn_auth 에 이 계정 그룹의 행이 없어 실측만 기록(기대 없음)' });
  56 |       await nscm.snapshot(`${MENU}_authcrud_${acc.id}`);
  57 |     });
  58 |   });
  59 | }
  60 | 
```