# SDM5010 — To-Be Fact Pack 요약

- page_key: `spms-demand/project-master` · feature: spms-demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 15 · 엔드포인트 호출 14 (미해결 1, 주석 속 2) · 이벤트 33 · 컴포넌트 사용 37 · 하드코딩 컬럼 0 · 메시지 31
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/spms-demand/src/pages/project-master/components/ProjectMasterForm.module.scss | component | 51 |
| features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | component | 223 |
| features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | component | 388 |
| features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | component | 315 |
| features/spms-demand/src/pages/project-master/index.ts | index | 2 |
| features/spms-demand/src/pages/project-master/project-master.constants.ts | constants | 112 |
| features/spms-demand/src/pages/project-master/project-master.types.ts | types | 22 |
| features/spms-demand/src/pages/project-master/ProjectMaster.module.scss | style | 76 |
| features/spms-demand/src/pages/project-master/ProjectMaster.tsx | page | 484 |
| features/spms-demand/src/pages/project-master/useProjectMasterStore.ts | store | 264 |
| features/spms-demand/src/pages/project-master/utils/project-master.api.test.ts | test | 84 |
| features/spms-demand/src/pages/project-master/utils/project-master.api.ts | api | 75 |
| features/spms-demand/src/pages/project-master/utils/project-master.editLock.ts | util | 42 |
| features/spms-demand/src/pages/project-master/utils/project-master.validate.ts | util | 86 |
| features/spms-demand/src/pages/project-master/utils/project-master.value.ts | util | 3 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | ProjectMasterForm.tsx:44 ProjectMasterForm.tsx:48 ProjectMaster.tsx:197 |
| (useTabLookupQueries) | hook | 1 | Y | ProjectMasterForm.tsx:51 |
| SDM5010/TAB1//call-proc | hook | 1 | Y | ProjectMaster.tsx:98 |
| SDM5010/TAB2//call-proc | hook | 1 | Y | ProjectMaster.tsx:105 |
| /admin/menu/SDM5010/column | http | 1 | Y | useProjectMasterStore.ts:167 |
| /SDM5010/{sheet}/{btnCd}/call-proc | http | 1 | N | project-master.api.ts:20 |
| SDM5010/TAB1/CONFIRM/call-proc | callProc | 1 | Y | project-master.api.ts:49 |
| SDM5010/TAB1/CANCEL/call-proc | callProc | 1 | Y | project-master.api.ts:61 |
| SDM5010/TAB2/SAVE/call-proc | callProc | 1 | Y | project-master.api.ts:74 |
| /SDM5010/TAB1/CONFIRM/call-proc | propagated | 1 | Y | project-master.api.ts:49 |
| /SDM5010/TAB1/CANCEL/call-proc | propagated | 1 | Y | project-master.api.ts:61 |
| /SDM5010/TAB2/SAVE/call-proc | propagated | 1 | Y | project-master.api.ts:74 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| TAB1 | sesDivisionId userGroup | data | PKG_SDM5010 P_SDM5010_GET_TAB1_PJT_REG_REQ P_SES_DIVISION_ID P_SES_USER_ID P_SDM5010_GET_TAB2_PJT_MASTER PKG_SDM1010 P_SDM1010_GET_PERIOD P_SDM5010_BTN_TAB1_CONFIRM P_SDM5010_BTN_TAB1_CANCEL P_SDM5010_SAVE_TAB2_PJT_MASTER |
| TAB2 | divisionId endCustomer cellType bizType dpjtDevelopStatus regCompDateFr regCompDateTo | data | PKG_SDM5010 P_SDM5010_GET_TAB1_PJT_REG_REQ P_SES_DIVISION_ID P_SES_USER_ID P_SDM5010_GET_TAB2_PJT_MASTER PKG_SDM1010 P_SDM1010_GET_PERIOD P_SDM5010_BTN_TAB1_CONFIRM P_SDM5010_BTN_TAB1_CANCEL P_SDM5010_SAVE_TAB2_PJT_MASTER |
| period | frBucket frDateVal frBucketType toBucket toDateVal toBucketType | data | PKG_SDM5010 P_SDM5010_GET_TAB1_PJT_REG_REQ P_SES_DIVISION_ID P_SES_USER_ID P_SDM5010_GET_TAB2_PJT_MASTER PKG_SDM1010 P_SDM1010_GET_PERIOD P_SDM5010_BTN_TAB1_CONFIRM P_SDM5010_BTN_TAB1_CANCEL P_SDM5010_SAVE_TAB2_PJT_MASTER |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 77 |
| CustomDropdown | onChange | <arrow> set,String,onDivisionChange | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 91 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 113 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 131 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 149 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 170 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 191 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterForm.tsx | 207 |
| g | formatItem | formatHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 219 |
| g | beginningEdit | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 238 |
| g | pastingCell | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 239 |
| g.hostElement | click | clickHandler | addEventListener | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 259 |
| g | formatItem | cornerHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 266 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 315 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 348 |
| Button | onClick | <arrow> onConfirmClick | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 367 |
| Button | onClick | <arrow> onCancelClick | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx | 376 |
| g | formatItem | formatHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 193 |
| g | beginningEdit | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 212 |
| g | pastingCell | beginningEditHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 213 |
| g.hostElement | click | clickHandler | addEventListener | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 240 |
| g | formatItem | cornerHandler | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 247 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 284 |
| DataGrid | initialized | handleGridInitialized | jsx | features/spms-demand/src/pages/project-master/components/ProjectMasterTab2Grid.tsx | 305 |
| ProjectMasterForm | onSearch | <arrow> handleSearch | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 361 |
| ProjectMasterForm | onDivisionChange | handleDivisionChange | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 362 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:columnSettingSheet,columnType:'C',rows:visible.map((setting,index)=>({name:setting.COLUMN_NAME,sortOrderNo:index+1,colWidth:setting.COL_WIDTH,cellColor:setting.CELL_COLOR,textColor:setting.TEXT_COLOR,})),}).then,saveTitleSet,visible.map | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 395 |
| ProjectMasterTab1Grid | onConfirmClick | <arrow> handleConfirmRow | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 454 |
| ProjectMasterTab1Grid | onCancelClick | <arrow> handleCancelRow | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 455 |
| ProjectMasterTab1Grid | onAuthRegCellClick | handleAuthRegCellClick | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 456 |
| ProjectMasterTab2Grid | onAuthRegCellClick | handleAuthRegCellClick | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 468 |
| AuthManagementPopup | onClose | closeAuthRegModal | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 478 |
| AuthManagementPopup | onSaved | refreshActive | jsx | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 479 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 5 |
| DatePickerCalendar | 2 |
| TagLayer | 2 |
| DataGrid | 2 |
| Button | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ProjectMasterForm | 1 |
| SubTitle | 1 |
| ColumnLayoutModal | 1 |
| TabWrapper | 1 |
| ProjectMasterTab1Grid | 1 |
| ProjectMasterTab2Grid | 1 |
| AuthManagementPopup | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00703 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG01008 | 1 |
| MSG01009 | 1 |
| MSG01010 | 1 |
| MSG01011 | 1 |
| MSG01012 | 1 |
| MSG01013 | 1 |
| LBL00001 | 1 |
| LBL01003 | 1 |
| LBL01005 | 1 |
| LBL00085 | 1 |
| LBL01007 | 1 |
| LBL01006 | 1 |
| LBL01004 | 1 |
| LBL00863 | 1 |
| LBL00112 | 1 |
| LBL00605 | 3 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 1 |
| MSG00060 | 3 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM5010(9), SDM1010(9), SDM1020(4), DMF0044(2)
- SP/PKG: SCM0001_GET_LOOKUP_VALUES(1), P_SDM1010_GET_PERIOD(1), P_SES_DIVISION_ID(1), P_SES_USER_GR_ID(1), PKG_SDM5010(1), P_SDM5010_BTN_TAB1_CONFIRM(1), P_SDM5010_BTN_TAB1_CANCEL(1), P_DPJT_KEY_PARENT(1), P_SDM5010_SAVE_TAB2_PJT_MASTER(1), P_SOP_DATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | mount 시 persist filters 무효화 + admin 메타 fetch (master hook §2.3 — E01-3) | features/spms-demand/src/pages/project-master/ProjectMaster.tsx | 126 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS — 시트별. hook #113 서버 직접 비교) | features/spms-demand/src/pages/project-master/useProjectMasterStore.ts | 158 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

