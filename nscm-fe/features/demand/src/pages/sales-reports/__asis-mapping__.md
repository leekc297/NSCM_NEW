# DMF0044 (Sales Reports / MDF Reports) — AS-IS ↔ TO-BE 매핑 (2026-07-22 신규 생성)

> ⭐ AS-IS 정본 = **`GSCM.DM.Forms.UIL\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs` 1,483행**
> (+Designer 707. Plan.UIL 변형 1,405행 대비 ExcelButton [E20240906]/YearSet [E20250107] 2건 신규 — Forms.UIL 판 확정).
> 최신 분석 정본(2026-07-20): `Doc/화면분석서/DMF0044_SalesReports_{제약매트릭스_상세,주요이벤트_상세분석}.md`
> + UI분석서 v2.1. (상세동작_개발용.md 은 참고 — 동일 소스.)
> 사내 실측 계약(2026-07-22): PROC_M 15본 151행 / API 28 / BTN 28 / USER_GR 28·28·19 / CMBO 신규 4 /
> MSG 신규 MSG00681~688(AS-IS TB_FX_MessageInfo 원문 1:1) / MNU_URL='sales-reports'.

## 0. 정책 확정 (사용자 2026-07-22)
| # | 정책 | 반영 |
|---|---|---|
| ① | P_CUTOFF_YYYYMMDD = **빈값 파리티** (AS-IS United 통합 시 공급 경로 소실 — 운영 데이터도 빈값) | save.ts identityOf — 행값 그대로('') |
| ② | dead 팝업 3종(Sales_VersionPopUp/VersionCopyPopUp/MDFVersionPopUp) **이관 제외** — 호출부 주석/부재. 전용 SP(GET_VERSION_POPUP/GET_COPY_VERSION_POPUP)·MSG(00279/280/156/143) 미배선 | 승계 금지 |
| ③ | Textbox 저장 = **행별 반복 호출 교정** (AS-IS 마지막 행만 저장 결함 — SAVE_TEXTBOX 16p=1행분) | TextboxModal handleSave |
| ④ | Exchange 팝업 종료 후 재조회 **없음 파리티** (AS-IS blnOK 재조회 주석 L1446~1454) | ExchangeRateModal — onClose 무동작 |

## 1. 조회조건 (AS-IS 8 컨트롤 → Form 5 + 버튼 3)
| # | AS-IS | TO-BE | 상태 |
|---|---|---|---|
| 1 | clbDivision (MyDivision) | DivisionField 카탈로그 — 변경 시 Version 초기화+Grid reset | ✅ |
| 2 | clbType (lookup MDF_TYPE) | CustomDropdown 'MDF_TYPE' (기등록) — 변경 시 Version 초기화 | ✅ |
| 3 | usrYear (CALENDAR_YYYY) | CustomDropdown 'CALENDAR_YYYY' (P4 신설) — 기본 당해년 | ✅ |
| 4 | usrDataType (MDF_TYPE2 — ALL/1/2) | CustomDropdown 'MDF_TYPE2' (P4 신설) | ✅ |
| 5 | txtSPVersion(readonly)+btnSPVer | InputField readonly + '...' 버튼 → UnitedVersionModal 주입 | ✅ |
| 6 | lblSPVersion (Type 별 라벨 전환) | FormItem label — BP_M='BP Version'/SP_W='SP Version' | ✅ |
| 7 | btnMeasure / btnExchangeRate / lci_btnTextBox(82) | SubTitle customButtons (Measure 아이콘/Exchange/Text[82]) | ✅ |
| 8 | Company (DM_COMPANY) | 캐시만·화면 바인딩 없음 (AS-IS 파리티 — 미노출) | ✅ |
| — | clbDivision 이중 구독 (Designer+코드 — InitSpread 2회) | **승계 금지** — 단일 핸들러 | ✅ |

## 2. 그리드
- 정적 46 = admin SHEET_COLUMNS 'MDF Reports' 메타 100% (hook #113 서버 직접 비교) ✅
- 동적 = M_yyyymm 12컬럼 + **연 span 2단 헤더** (GET_SPREAD_TITLE 1차 + row 키 fallback / SalesReportsMergeManager — hook #108 No. 코너) ✅
- **2행 Measure 블록**: Insert = GET_MEASURE(CODE) 강제 세팅 세트(INSERT_GROUP_ID) / Delete = 블록 전체 (AS-IS multiful=2, L970~1035) ✅
- 편집 게이트 = evalSalesReportCell **4변수 매트릭스** (제약매트릭스 §3 L270~372 6분기 전수):
  ALL 차단 / EDIT_FLAG='Y' 전개방 / LOC 계획구간 / RTF·Business_Plan×40 전체 / 기타×40 과거만 / 비40 잠금 ✅
- InsertRow 정적 잠금 12컬럼 (L997~1023 전수 — MEASURE 강제 세팅 포함) ✅
- 수치셀 빈값→'0' (spdMain_Changed L1295~1302) / cascade DEPARTMENT_ID→DEPT_ID (M-6) ✅
- ITEM_ID dblclick ≠'기타매출' → ItemByDivisionModal (M-8 L93) ✅

## 3. 저장 (Data Type 이원화 — SaveData L502~968)
- ETC(2): 2행 세트, '^' bulk **20키**(21 IN − createdBy BE주입 — cellModelInfo/cellModel=파트너 행) → `PKG.P_DMF0044_SAVE_SALES_PLAN_REPORT_C` ✅
- Cutoff(1): 1행 'M'만, **22키**(23 IN − createdBy — scmSiteId/projectCode/fcstType/incoterms) → `..._C_CF` ✅
- 게이트: Version(MSG00688) → ALL 차단(MSG00681) → Department 필수(MSG00429 {0}) → 0건(MSG00676) ✅
- 결과 passthrough + 성공 MSG00002 + 재조회·스크롤 복원 ✅

## 4. 모달 4종
| 모달 | AS-IS | 핵심 | 상태 |
|---|---|---|---|
| UnitedVersionModal | United_VersionPopup 727행 | 조회(당월-1~+5)/채택(SP_W·BP_M만, 더블클릭/OK)/액션 5종(T·C·D·CP — SEND_YN 게이트 MSG00685~687, confirm MSG00682/683/684, SP_W↔BP 분기 L300~304) | ✅ |
| ExchangeRateModal | SalesReportExchangePopup 721행 | 조회 2종+월 피벗/과거월 차단(L-29)/저장 '^' 7키·'0'→'D' | ✅ |
| TextboxModal | SalesReport_TextboxPopup 453행 (82) | GET 4커서(rc2 MONDAY)/13 코멘트/저장 행별 반복(정책③) | ✅ |
| MeasureSelectModal | DM0002_TitleSetForm_Popup | business-plan 판 복제 (titleSet 'M') | ✅ |

## 5. Validation/MSG 매핑 (hook #114 — AS-IS ID 직승계 금지, 사내 실측 3분기)
| AS-IS | 용법 | TO-BE | 분기 |
|---|---|---|---|
| MSG00283 | 조회 전 버전 | MSG00283 | 재사용(기등록) |
| MSG00281 | 저장/팝업 전 버전 | **MSG00688** (원문 1:1) | 신규 |
| MSG00321 | ALL 편집/저장 차단 | **MSG00681** | 신규 |
| MSG00002 | 필수값 {0} | MSG00429 | 재매핑(선례) |
| MSG00004 | {N}건 저장 | MSG00002(성공)/MSG00004(무변경) | 재매핑(선례) |
| MSG00006 | 저장 실패 | MSG00618 | 재매핑 |
| MSG00142 | Edit 중 환율 차단 | MSG00680 (DMF0042 선례 — 사내 00142는 '환율 잠금' 문구) | 재사용 |
| MSG00314/00016/00195 | 복사/삭제/취소 confirm | **MSG00682/683/684** | 신규 |
| MSG00318/319/320 | SEND_YN 게이트 | **MSG00685/686/687** | 신규 |
| MSG00096 | 권한 없음 | MSG00096 | 재사용 |
| MSG00279/280/156/143/151 | dead 팝업 전용 | — (정책② 제외) | 미배선 |

## 6. 승계 금지 (AS-IS dead/주석 — 제약매트릭스 §9 전수)
clbDivision 이중구독 / btnSPVer 구 팝업 호출(L1156~1163 주석 — CUTOFF 경로 소실=정책①) / 팝업2 SaveData dead(FoxDataRequest("")) / Exchange InitSpread_X(직접 SQL) / 구 YearSet(-5y~+10y) / Delete action=='I' 가드 주석 / 구 ETC 짝수행 수집·"^40" 하드코딩 잔재 / Textbox 마지막행만 저장(정책③ 교정) / Exchange blnOK 재조회 주석(정책④ 파리티).

## 7. 검증 이력
- 2026-07-22: tsc(demand+apps/web) 0 / eslint 0 errors(warnings 12 = 기존 non-null·상대경로 패턴 계열) /
  메타 P1~P4 사내 적용·실측 검증 완료 / viewRegistry DMF0044+'sales-reports'+'dmf0044' 등록.
- 잔여: 브라우저 E2E V1~V6 (플랜 §5) — Version 주입→조회→편집 매트릭스→저장 이원화→United 액션→Exchange/Textbox.
