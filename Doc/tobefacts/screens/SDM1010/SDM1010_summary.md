# SDM1010 — To-Be Fact Pack 요약

- page_key: `spms-demand/project-registration` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 20 · 엔드포인트 호출 24 (미해결 1, 주석 속 1) · 이벤트 47 · 컴포넌트 사용 62 · 하드코딩 컬럼 0 · 메시지 65
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.module.scss | component | 142 |
| features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | component | 771 |
| features/spms-demand/src/pages/project-registration/components/authManagementPopup/authManagementPopup.utils.ts | component | 45 |
| features/spms-demand/src/pages/project-registration/components/authManagementPopup/OrgTree.tsx | component | 33 |
| features/spms-demand/src/pages/project-registration/components/authManagementPopup/useAuthManagementPopupStore.ts | store | 68 |
| features/spms-demand/src/pages/project-registration/components/MyProjectGrid.tsx | component | 132 |
| features/spms-demand/src/pages/project-registration/components/myWorkPopup/MyWorkPopup.module.scss | component | 34 |
| features/spms-demand/src/pages/project-registration/components/myWorkPopup/MyWorkPopup.tsx | component | 144 |
| features/spms-demand/src/pages/project-registration/components/myWorkPopup/useMyWorkPopupStore.ts | store | 42 |
| features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | component | 424 |
| features/spms-demand/src/pages/project-registration/components/ProjectProcessFlow.tsx | component | 67 |
| features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.module.scss | component | 53 |
| features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | component | 199 |
| features/spms-demand/src/pages/project-registration/index.ts | index | 2 |
| features/spms-demand/src/pages/project-registration/project-registration.constants.ts | constants | 51 |
| features/spms-demand/src/pages/project-registration/project-registration.grid-utils.ts | other | 79 |
| features/spms-demand/src/pages/project-registration/project-registration.types.ts | types | 206 |
| features/spms-demand/src/pages/project-registration/ProjectRegistration.module.scss | style | 40 |
| features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | page | 530 |
| features/spms-demand/src/pages/project-registration/useProjectRegistrationStore.ts | store | 336 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SDM1010/popupOrg//call-proc | hook | 1 | Y | AuthManagementPopup.tsx:92 |
| SDM1010/popupUser//call-proc | hook | 1 | Y | AuthManagementPopup.tsx:101 |
| SDM1010/popupAuthWrite//call-proc | hook | 2 | Y | AuthManagementPopup.tsx:109 AuthManagementPopup.tsx:134 |
| SDM1010/popupAuthRead//call-proc | hook | 2 | Y | AuthManagementPopup.tsx:117 AuthManagementPopup.tsx:141 |
| SDM1010/popupAuthReq//call-proc | hook | 1 | Y | AuthManagementPopup.tsx:126 |
| SDM1010/popupAuthReq/REJECT/call-proc | hook | 1 | Y | AuthManagementPopup.tsx:148 |
| /admin/menu/SDM1010/column | http | 7 | Y | useAuthManagementPopupStore.ts:42 useAuthManagementPopupStore.ts:45 useAuthManagementPopupStore.ts:48 useAuthManagementPopupStore.ts:51 useMyWorkPopupStore.ts:30 useProjectRegistrationStore.ts:210 |
| SDM1010/popupMyWork//call-proc | hook | 1 | Y | MyWorkPopup.tsx:81 |
| (useTabComboQueries) | hook | 1 | Y | ProjectRegistrationForm.tsx:30 |
| SDM1010/project//call-proc | hook | 2 | Y | ProjectRegistration.tsx:86 ProjectRegistration.tsx:101 |
| SDM1010/myProject//call-proc | hook | 1 | Y | ProjectRegistration.tsx:93 |
| SDM1010/project/{action}/call-proc | http | 1 | N | ProjectRegistration.tsx:132 |
| /admin/menu/SDM1010/search-conditions | http | 1 | Y | useProjectRegistrationStore.ts:239 |
| SDM1010/project/REQUEST/call-proc | propagated | 1 | Y | ProjectRegistration.tsx:307 |
| SDM1010/project/CANCEL/call-proc | propagated | 1 | Y | ProjectRegistration.tsx:325 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| TAB1 | sesDivisionId userGroup | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| TAB2 | divisionId endCustomer dpjtAuthType dpjtRegStatus regCompDateFr regCompDateTo | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP1_TREE | sesDivisionId | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP1_GRID1 | userInfo deptId sesDivisionId | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP1_GRID2 | dpjtKey sesDivisionId | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP1_GRID3 | dpjtKey sesDivisionId | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP1_GRID4 | dpjtKey sesDivisionId | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| POP2_GRID5 | divisionId dpjtKey | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| period | frBucket frDateVal frBucketType toBucket toDateVal toBucketType | data | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| project | sesDivisionId sesUserId sesMenuId sesUserGrId | projectList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| myProject | divisionId endCustomer dpjtAuthType dpjtRegStatus regCompDateFr regCompDateTo sesUserId | myProjectList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupOrg | sesDivisionId sesUserId | orgList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupUser | userInfo deptId sesDivisionId sesUserId | userList | P_SDM1010_GET_POP_USER_BY_DEPT PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupAuthWrite | pjtKey sesDivisionId sesUserId | authWriteList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupAuthRead | pjtKey sesDivisionId sesUserId | authReadList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupAuthReq | pjtKey sesDivisionId sesUserId | authRequestList | PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |
| popupMyWork | divisionId pjtKey sesUserId | scheduleList | SDM1010_GET_POP_MY_WORK PKG_SDM1010 PKG_SDM1010_NEW_CONTRACT |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setUserKeyword | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 571 |
| InputField | onKeyDown | <arrow> handleSearchUser | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 572 |
| Button | onClick | handleSearchUser | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 581 |
| OrgTree | onSelect | handleSelectDept | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 590 |
| Button | onClick | <arrow> handleAddAuth | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 613 |
| Button | onClick | <arrow> handleRemoveAuth | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 621 |
| Button | onClick | <arrow> handleAddAuth | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 631 |
| Button | onClick | <arrow> handleRemoveAuth | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 639 |
| Button | onClick | <arrow> handleMoveAuth,t | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 663 |
| Button | onClick | <arrow> handleMoveAuth,t | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 678 |
| DataGrid | formatItem | formatRequestProcess | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 710 |
| Button | onClick | <arrow> handleApproveRequest | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 725 |
| Button | onClick | <arrow> handleApproveRequest | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 732 |
| Button | onClick | <arrow> handleRejectRequest | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 739 |
| Button | onClick | onClose | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 756 |
| Button | onClick | <arrow> handleSave | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 763 |
| Tree | onClick | handleClick | jsx | features/spms-demand/src/pages/project-registration/components/authManagementPopup/OrgTree.tsx | 26 |
| DataGrid | initialized | handleInitialized | jsx | features/spms-demand/src/pages/project-registration/components/MyProjectGrid.tsx | 116 |
| DataGrid | gotFocus | handleFocus | jsx | features/spms-demand/src/pages/project-registration/components/MyProjectGrid.tsx | 117 |
| DataGrid | formatItem | handleFormatItem | jsx | features/spms-demand/src/pages/project-registration/components/MyProjectGrid.tsx | 119 |
| MyWorkPopup | onClose | <arrow> setMyWorkOpen | jsx | features/spms-demand/src/pages/project-registration/components/MyProjectGrid.tsx | 127 |
| DataGrid | formatItem | formatScheduleDates | jsx | features/spms-demand/src/pages/project-registration/components/myWorkPopup/MyWorkPopup.tsx | 126 |
| Button | onClick | onClose | jsx | features/spms-demand/src/pages/project-registration/components/myWorkPopup/MyWorkPopup.tsx | 136 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 367 |
| DataGrid | gotFocus | handleFocus | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 369 |
| DataGrid | formatItem | handleFormatItem | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 371 |
| DataGrid | cellEditEnding | handleSopDateEditEnding | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 372 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 373 |
| DataGrid | pastedCell | handleCellEditEnded | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 376 |
| DataGrid | beginningEdit | preventLockedRowEdit | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 377 |
| DataGrid | pastingCell | preventLockedRowEdit | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 378 |
| Button | onClick | <arrow> onRequest | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 395 |
| Button | onClick | <arrow> onCancelRequest | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 404 |
| AuthManagementPopup | onClose | <arrow> setAuthPopupOpen | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 418 |
| AuthManagementPopup | onSaved | onAuthSaved | jsx | features/spms-demand/src/pages/project-registration/components/ProjectGrid.tsx | 419 |
| SearchArea | onSearch | onSearch | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 51 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 69 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 92 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 119 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 145 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 167 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/spms-demand/src/pages/project-registration/components/ProjectRegistrationForm.tsx | 183 |
| ProjectRegistrationForm | onSearch | handleSearch | jsx | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 401 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:columnSettingSheet,columnType:'C',rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map | jsx | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 436 |
| ProjectGrid | onRequest | handleRequest | jsx | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 504 |
| ProjectGrid | onCancelRequest | handleCancelRequest | jsx | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 505 |
| ProjectGrid | onAuthSaved | <arrow> GridUtils.isDirty,refetchProject | jsx | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 511 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 15 |
| DataGrid | 7 |
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| CustomDialog | 2 |
| FunctionSearchIcon | 2 |
| TagLayer | 2 |
| DatePickerCalendar | 2 |
| TabItem | 2 |
| ProgressIndicator | 1 |
| InputField | 1 |
| OrgTree | 1 |
| Tree | 1 |
| MyWorkPopup | 1 |
| AuthManagementPopup | 1 |
| ProcessFlow | 1 |
| SearchArea | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ProjectRegistrationForm | 1 |
| SubTitle | 1 |
| ColumnLayoutModal | 1 |
| TabWrapper | 1 |
| ProjectGrid | 1 |
| MyProjectGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00913 | 1 |
| MSG00014 | 6 |
| MSG00712 | 3 |
| MSG00713 | 3 |
| MSG00002 | 3 |
| MSG00003 | 2 |
| LBL00868 | 1 |
| LBL00869 | 1 |
| LBL00339 | 1 |
| LBL00664 | 1 |
| LBL00866 | 1 |
| LBL00109 | 2 |
| LBL00407 | 2 |
| LBL00872 | 2 |
| LBL00955 | 1 |
| LBL00956 | 1 |
| LBL00867 | 2 |
| LBL00871 | 1 |
| LBL00863 | 1 |
| LBL00627 | 1 |
| LBL00862 | 1 |
| LBL00873 | 1 |
| MSG00714 | 1 |
| LBL00865 | 1 |
| LBL00422 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL01003 | 1 |
| LBL00879 | 1 |
| LBL00878 | 1 |
| LBL00857 | 1 |
| MSG00097 | 1 |
| MSG00013 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| LBL00876 | 1 |
| LBL00875 | 1 |
| MSG00706 | 1 |
| MSG00001 | 1 |
| MSG00709 | 1 |
| MSG00711 | 1 |
| LBL00605 | 3 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 1 |
| LBL00864 | 1 |
| LBL00870 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(13), SDM5010(3), SDM1020(2), DMF0042(1)
- SP/PKG: P_SES_USER_ID(4), SCM0001_GET_LOOKUP_VALUES(3), P_SES_(2), P_SDM1010_GET(2), P_SDM1010_BTN_REQ_PJT_REG_MAIN(2), P_ACTIVE_FLAG(2), P_SES_DIVISION_ID(1), P_SDM1010_GET_POP_USER_ORG(1), P_SDM1010_GET_TAB2_PJT_LIST(1), P_SDM1010_SAVE_TAB1_PJT_REG(1), PKG_SDM1010(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 요청 그리드 PROCESS 셀 버튼 — 하단 Close/OK 버튼과 같은 <Button> 컴포넌트를 그대로 써서 | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 442 |
| jsx | formatItem 이 만드는 순수 DOM이라 <Button> 을 직접 못 앉히므로, formatItem 이 셀 안에 빈 | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 445 |
| jsx | 컨테이너 div만 만들어 두고 그 div로 실제 <Button> 들을 createPortal 한다(JSX는 아래 requestPanel | features/spms-demand/src/pages/project-registration/components/authManagementPopup/AuthManagementPopup.tsx | 446 |
| code | import { ProjectProcessFlow } from './components/ProjectProcessFlow'; | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 34 |
| endpoint | 요청 본문은 useProcMutation(callMutationProc)과 동일한 { data: [...] } 형태를 유지한다. | features/spms-demand/src/pages/project-registration/ProjectRegistration.tsx | 116 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/spms-demand/src/pages/project-registration/useProjectRegistrationStore.ts | 111 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

