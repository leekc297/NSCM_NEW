# SCP0007 TO-BE 설계 기초 (As-is 사실 기반)

## 1. 조회조건 (컨트롤 기준)
| 순서(Designer 선언 순) | 조건명(원문) | AS-IS 컨트롤 | 유형 | 값 원천 후보 | 비고 |
|---:|---|---|---|---|---|
| 1 | Div | clbDivision | 멀티 체크리스트 | **확인 필요**(메인 화면 Division 원천 엔드포인트가 Fact Pack에 없음) | 변경 시 `cboDivision_SelectedIndexChanged`. 동작 **확인 필요** |
| 2 | SSP Incoterms | clbIncotermsSSP | 멀티 체크리스트 | **확인 필요** | GetCheckedListValue(CODE) |
| 3 | Trans Mode | clbTransMode | 멀티 체크리스트 | dtTransMode(LookupCommon)일 가능성. **확인 필요** | 〃 |
| 4 | Incoterms | clbIncoterms | 멀티 체크리스트 | dtIncoterms(LookupCommon)일 가능성. **확인 필요** | 〃 |
| 5 | To Site | clbToSite | 멀티 체크리스트 | **확인 필요**(NowGroupID 사용 필드 존재) | 〃 |
| 6 | From Site | clbFromSite | 멀티 체크리스트 | dtFromSiteAll(NowGroupID). 원천 **확인 필요** | 〃 |
| 7 | Valid | cboValidYN | 단일 콤보 | dtValidYN(`biz:CommonData.YesOrNo`)일 가능성 | – |
| 8 | Input Status | cboInputStatus | 단일 콤보 | **확인 필요** | 값 `"C"`일 때 InsertButton 셀 콤보 설정, `"R"` 분기 존재 |

- 멀티선택 값은 GetCheckedListValue(CODE)로 FindData_Main(517, 518, 530~534)과 SetChangeControl(240)에 넘긴다. 어느 컨트롤이 어느 SP 파라미터로 가는지는 **확인 필요**다.
- 실제 화면 배치 순서는 Designer 선언 순과 다를 수 있다(Location 미추출).

## 2. 액션별 호출 API 후보
| 액션 | AS-IS 진입점 | AS-IS 호출 | TO-BE API 후보 |
|---|---|---|---|
| 조회 | FindButton | GetData_Country → `SCP0007_GET_COUNTRY_CITY`, FindData_Main → `SCP0007_GET_BOD` (순서 **확인 필요**) | 조회 call-proc 2건(Oracle 전환 SP) |
| 저장 | SaveButton | SaveData_Main → `SCP0007_SAVE_BOD` → 오류 시 ERR_MESSAGE 표시 → FindData_Main 재조회 | 저장 call-proc 1건 + 결과 메시지 판정 + 재조회 |
| 행 추가 | InsertButton | 엔드포인트 없음. DIVISION_ID, INCOTERMS, INCOTERMS_SSP 셀 콤보 설정(Input Status=`C`, 시트 `BOD`, 잠금 아님) | FE 그리드 행 추가 + 셀 콤보 데이터(Division, incotermsEdit) |
| 수정 | EditButton | 엔드포인트 없음. TO SITE_TYPE=`PLANT` 행의 INCOTERMS_SSP 콤보를 boolEditChange에 따라 incotermsEdit / LookupCommon `INCOTERMS`로 전환 | FE 셀 편집 제어 |
| From/To Site 변경 | dsdm.Changed → `SpdMain_Changed` > SetCityCode | `SCP0007_GET_ROUTE_CNT` → route_cnt. From/To의 COUNTRY, CITY, VMI_YN, SITE_TYPE 설정 | 셀 변경 시 Route 건수 조회 API |
| From Site 콤보 선택 | `SpdMain_ComboSelChange` | 엔드포인트 없음. TO_SITE_CODE 콤보를 필터 재바인딩(`sFromSite == "E"`, `"A" && OSP_YN == "Y"`) | FE 필터 로직(원천 To Site 목록) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | 엔드포인트 없음. OSP_YN, CITY 참조 | FE paste 처리 |
| 편집 변경 | `SpdMain_EditChange` | 엔드포인트 없음. TO SITE_TYPE 참조 | FE 셀 편집 처리 |
| 셀 더블클릭 | `spdMain_CellDoubleClick` | Route 관련 컬럼(ROUTE_ID 등) 반영. 팝업 호출은 **확인 필요** | Distribution Route 팝업 연동 |
| 팝업 로드/조회 | 팝업 `Form_Load`, FindButton, `btnButtonList_UsrButtonList_Click_Detected` | `SCP0005_GET_DISTRIBUTION_ROUTE` | 팝업 조회 call-proc |
| 팝업 도시 검색 | `btnFromSrch_Click`, `btnToSrch_Click` | popCity 결과(Country/City) → 텍스트 반영. 초기 Enabled=false | 도시 선택 팝업(초기 비활성) |
| 기타 | `SpdMain_TopChange`, `SpdMain_KeyPress`, 팝업 `spdMain_CellDoubleClick`, `spdMainDataModel_Changed` | 엔드포인트 없음 | 동작 **확인 필요** |

## 3. division별 Grid 변형 요약
| 시트 | 40 / 81 / 81_HD / 81_HG / 81_HM / 81_ST / 81_UC / 82 / EE / EE_HD / EE_HG / EE_HM / EE_ST / EE_UC |
|---|---|
| BOD | 모두 표시 34 / 숨김 5 (BEFORE_LEAD_TIME, FROM_COUNTRY, ROUTE_CHK, SAFETY_STOCK, TO_COUNTRY). 차이 없음 |
| Distribution Route | 모두 33(코드추가). 차이 없음. DAYS_MON~SUN bVisible=false 7개는 **확인 필요** |

- division에 따라 표시를 바꾸는 코드 분기는 없다. 다만 DIVISION_ID 셀 콤보는 `GetDivisionWithoutEE`로 EE 계열을 빼는 것으로 보인다. 함수명에서 추정한 것이므로 **확인 필요**다.

## 4. 권한(C/R/U/D) 관련 사실
- TB_FX_GroupMenuAuth에 SCP0007 관련 13행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있다. 그룹별 C/R/U/D 값은 Fact Pack에 없다(**확인 필요**).
- 코드상 확인된 버튼 핸들러: FindButton(R), SaveButton(U/C/D 포함 여부 **확인 필요**), InsertButton(C), EditButton(U). DeleteButton 등 삭제 버튼은 Fact Pack에 없다.
- 저장 SP는 SCP_MST_BOD에 MERGE와 DELETE를 모두 실행하므로 저장 한 번에 C/U/D가 함께 처리될 수 있다. 행 상태별 분기는 **확인 필요**다.
- 사용자 그룹 기반 데이터 범위: `UserInfoContext.Current.NowGroupID`(메인 필드 55/60/63/64, 팝업 58), 공통코드 FromSiteByDivision/ToSiteByDivision/MyDivision의 TB_FX_USERGROUPAUTHEXTENTION 참조.
- 시트 잠금 검사: `siMain.IsLock(siMain.SheetName)`(InsertButton, ComboSelChange).

## 5. 미확정 사항
1. SCP0007_GET_BOD 동적 SQL의 결과 컬럼과 BOD 메타 39개 컬럼의 일치 여부(결과 시트 매칭 없음)
2. 메인 조회조건 각 체크리스트의 데이터 원천 엔드포인트(Division, From/To Site, Incoterms, SSP Incoterms, Trans Mode, Input Status)
3. FindButton 안에서의 호출 순서
4. 메인 더블클릭 → 팝업 호출 방식, 팝업 생성자 인자, 반환 컬럼 매핑
5. Distribution Route DAYS_* 7개 컬럼의 실제 표시 여부와 상단 그룹 헤더 문구
6. InitSpread:277 cellTypeImage 대상 컬럼
7. SAVE_BOD의 UPDATE:X 대상, 하위 SP 4종 전환 상태, #TMP 임시테이블 대체
8. `biz:CommonData.YesOrNo` 원천, `BLUtils.GetDivisionWithoutEE` 원천
9. TB_FX_GroupMenuAuth 13행의 권한 값, TB_FX_SearchCondition 473행의 조회조건 저장 구조
10. `route_cnt` 결과 키 대소문자, ERR_MESSAGE 결과셋 계약
