# SCP0111 — To-Be Fact Pack 요약

- page_key: `supply/integration-psi` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 16 · 엔드포인트 호출 10 (미해결 1, 주석 속 4) · 이벤트 20 · 컴포넌트 사용 23 · 하드코딩 컬럼 1 · 메시지 19
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | component | 332 |
| features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | component | 351 |
| features/supply/src/pages/integration-psi/index.ts | index | 2 |
| features/supply/src/pages/integration-psi/integration-psi.constants.ts | constants | 166 |
| features/supply/src/pages/integration-psi/integration-psi.types.ts | types | 23 |
| features/supply/src/pages/integration-psi/IntegrationPsi.module.scss | style | 12 |
| features/supply/src/pages/integration-psi/IntegrationPsi.tsx | page | 458 |
| features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | store | 236 |
| features/supply/src/pages/integration-psi/utils/integrationPsiApi.ts | api | 72 |
| features/supply/src/pages/integration-psi/utils/integrationPsiColumns.test.ts | test | 65 |
| features/supply/src/pages/integration-psi/utils/integrationPsiColumns.ts | util | 108 |
| features/supply/src/pages/integration-psi/utils/integrationPsiEditLock.test.ts | test | 63 |
| features/supply/src/pages/integration-psi/utils/integrationPsiEditLock.ts | util | 164 |
| features/supply/src/pages/integration-psi/utils/integrationPsiSave.test.ts | test | 213 |
| features/supply/src/pages/integration-psi/utils/integrationPsiSave.ts | util | 239 |
| features/supply/src/pages/integration-psi/__asis-mapping__.md | mapping | 296 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | IntegrationPsiForm.tsx:91 IntegrationPsiGrid.tsx:108 IntegrationPsi.tsx:218 |
| (useTabLookupQueries) | hook | 2 | Y | IntegrationPsiForm.tsx:100 IntegrationPsi.tsx:179 |
| SCP0111/main//call-proc | hook | 1 | Y | IntegrationPsi.tsx:155 |
| /admin/menu/SCP0111/column | http | 1 | Y | useIntegrationPsiStore.ts:169 |
| /admin/menu/SCP0111/measure | http | 1 | Y | useIntegrationPsiStore.ts:190 |
| /admin/menu/SCP0111/search-conditions | http | 1 | Y | useIntegrationPsiStore.ts:212 |
| /SCP0111/main/{action}/call-proc | http | 1 | N | integrationPsiApi.ts:46 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 190 |
| PeriodRangePicker | onChange | <arrow> set,start.slice,end.slice | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 210 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 243 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 244 |
| FunctionSearchIcon | onClick | onPopup | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 239 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 255 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 295 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 296 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 324 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 207 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 247 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 259 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 295 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 296 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 315 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 347 |
| IntegrationPsiForm | onSearch | handleSearch | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 387 |
| IntegrationPsiForm | onItemSearch | <arrow> setOpenItemModal | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 388 |
| IntegrationPsiGrid | onDerivMismatch | <arrow> setToast,t | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 426 |
| IntegrationPsiGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 432 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| InputField | 2 |
| CustomDropdown | 1 |
| PeriodRangePicker | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| IntegrationPsiForm | 1 |
| SubTitle | 1 |
| IntegrationPsiGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | `${binding.slice(0, 4)}-${binding.slice(4, 6)}` | 75 | true |  |  | object | features/supply/src/pages/integration-psi/utils/integrationPsiColumns.ts | 80 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 2 |
| MSG00219 | 1 |
| MSG00260 | 1 |
| MSG01434 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |
| MSG00014 | 1 |
| MSG00608 | 1 |
| LBL00001 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL01150 | 1 |
| LBL00767 | 1 |
| LBL00051 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00112 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0111(10), SCM0002(3), SSP0021(2), SSP0060(1), SCP0013(1), SCP0025(1)
- SP/PKG: PKG_SCP0111(9), P_SCP0111_SAVE_INTEGRATION_PSI(4), P_SCP0111_GET_ESS_PACK_LINE(3), P_ACTIVE_FLAG(3), P_SCP0111_GET_INTEGRATION_PSI(2), P_SCP0111_SAVE_PSI_ADMIN(2), P_DIVISION_ID(1), PKG_NSCM_UI_COM_MENU(1), P_OPERATION_GROUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | '^'delim bulk SAVE 는 useProcMutation(배열 unfold)을 우회해 apiClient.post 직접 호출 | features/supply/src/pages/integration-psi/integration-psi.constants.ts | 156 |
| code | `dtPSI = DBUtils.Filter(dtPSIAll, sb, true); if (dtPSI.Rows.Count > 0) { MSG00260; return; }` | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 77 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 'Integration PSI' 24행 | features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | 40 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch (design 03 §1-M 7행). PIVOT measure 세로축. division=81 은 MKT_FCST 제외. | features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | 43 |
| endpoint | SCP0111 저장 call-proc 직접 호출 — '^'delim bulk payload 는 useProcMutation(배열 unfold)을 우회해 | features/supply/src/pages/integration-psi/utils/integrationPsiApi.ts | 1 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

