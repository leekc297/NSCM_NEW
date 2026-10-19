# SCP0087 — To-Be Fact Pack 요약

- page_key: `supply/mdm-class-master` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 9 · 컴포넌트 사용 15 · 하드코딩 컬럼 1 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | component | 104 |
| features/supply/src/pages/mdm-class-master/components/MdmClassMasterGrid.tsx | component | 49 |
| features/supply/src/pages/mdm-class-master/hooks/useMdmClassMasterValidation.ts | hook | 37 |
| features/supply/src/pages/mdm-class-master/index.ts | index | 2 |
| features/supply/src/pages/mdm-class-master/mdm-class-master.constants.ts | constants | 94 |
| features/supply/src/pages/mdm-class-master/mdm-class-master.types.ts | types | 12 |
| features/supply/src/pages/mdm-class-master/MdmClassMaster.module.scss | style | 12 |
| features/supply/src/pages/mdm-class-master/MdmClassMaster.tsx | page | 143 |
| features/supply/src/pages/mdm-class-master/useMdmClassMasterStore.ts | store | 149 |
| features/supply/src/pages/mdm-class-master/utils/mdmClassMasterColumns.ts | util | 38 |
| features/supply/src/pages/mdm-class-master/__asis-mapping__.md | mapping | 90 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | MdmClassMasterForm.tsx:33 |
| SCP0087/main//call-proc | hook | 2 | Y | MdmClassMaster.tsx:52 MdmClassMaster.tsx:59 |
| /admin/menu/SCP0087/column | http | 1 | Y | useMdmClassMasterStore.ts:98 |
| /admin/menu/SCP0087/search-conditions | http | 1 | Y | useMdmClassMasterStore.ts:129 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | classId className useFlag debugMode | o_rc1 | SCP0087_GET_MDM_CLASS_MASTER PKG_SCP0087 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 46 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 60 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 61 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 77 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 78 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterForm.tsx | 94 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/mdm-class-master/components/MdmClassMasterGrid.tsx | 45 |
| MdmClassMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/mdm-class-master/MdmClassMaster.tsx | 118 |
| MdmClassMasterGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/mdm-class-master/MdmClassMaster.tsx | 137 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| InputField | 2 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| MdmClassMasterForm | 1 |
| SubTitle | 1 |
| MdmClassMasterGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | c.key | c.header | c.width | true |  |  | meta-map | features/supply/src/pages/mdm-class-master/utils/mdmClassMasterColumns.ts | 15 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00003 | 2 |
| LBL00017 | 1 |
| LBL00035 | 1 |
| LBL01131 | 1 |
| LBL00112 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0087(8), SCP0023(2)
- SP/PKG: SCP0087_GET_MDM_CLASS_MASTER(1), SCP0087_SAVE_MDM_CLASS_MASTER_ROW_DATASET(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(SCP0087 23행 등록확인, design 03 §1). | features/supply/src/pages/mdm-class-master/useMdmClassMasterStore.ts | 29 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

