# SCP0111 — To-Be Fact Pack 요약

- page_key: `supply/integration-psi` · feature: supply · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 12 (미해결 1, 주석 속 5) · 이벤트 20 · 컴포넌트 사용 23 · 하드코딩 컬럼 1 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | component | 337 |
| features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | component | 692 |
| features/supply/src/pages/integration-psi/index.ts | index | 2 |
| features/supply/src/pages/integration-psi/integration-psi.constants.ts | constants | 236 |
| features/supply/src/pages/integration-psi/integration-psi.types.ts | types | 34 |
| features/supply/src/pages/integration-psi/IntegrationPsi.module.scss | style | 12 |
| features/supply/src/pages/integration-psi/IntegrationPsi.tsx | page | 619 |
| features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | store | 268 |
| features/supply/src/pages/integration-psi/utils/integrationPsiApi.ts | api | 72 |
| features/supply/src/pages/integration-psi/utils/integrationPsiColumns.test.ts | test | 65 |
| features/supply/src/pages/integration-psi/utils/integrationPsiColumns.ts | util | 108 |
| features/supply/src/pages/integration-psi/utils/integrationPsiEditLock.test.ts | test | 209 |
| features/supply/src/pages/integration-psi/utils/integrationPsiEditLock.ts | util | 200 |
| features/supply/src/pages/integration-psi/utils/integrationPsiSave.test.ts | test | 383 |
| features/supply/src/pages/integration-psi/utils/integrationPsiSave.ts | util | 300 |
| features/supply/src/pages/integration-psi/__asis-mapping__.md | mapping | 384 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | IntegrationPsiForm.tsx:81 IntegrationPsiGrid.tsx:145 IntegrationPsi.tsx:290 |
| (useTabLookupQueries) | hook | 3 | Y | IntegrationPsiForm.tsx:91 IntegrationPsiGrid.tsx:148 IntegrationPsi.tsx:236 |
| SCP0111/main//call-proc | hook | 1 | Y | IntegrationPsi.tsx:173 |
| SCP0111/essPackLine//call-proc | hook | 1 | Y | IntegrationPsi.tsx:190 |
| /admin/menu/SCP0111/column | http | 1 | Y | useIntegrationPsiStore.ts:200 |
| /admin/menu/SCP0111/measure | http | 1 | Y | useIntegrationPsiStore.ts:221 |
| /admin/menu/SCP0111/search-conditions | http | 1 | Y | useIntegrationPsiStore.ts:243 |
| /SCP0111/main/{action}/call-proc | http | 1 | N | integrationPsiApi.ts:46 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 179 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 202 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 233 |
| Button | onClick | onPopup | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 229 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 244 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 284 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 327 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 332 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 409 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 421 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 530 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 531 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 599 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 617 |
| g.hostElement | keydown | blockNonIntegerKey | addEventListener | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 630 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/integration-psi/components/IntegrationPsiGrid.tsx | 665 |
| IntegrationPsiForm | onSearch | handleSearch | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 524 |
| IntegrationPsiForm | onItemSearch | <arrow> setOpenItemModal | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 525 |
| IntegrationPsiGrid | onDerivMismatch | <arrow> t,setAlert | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 578 |
| IntegrationPsiGrid | onFocus | NOOP | jsx | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 593 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| InputField | 2 |
| MaterialByDivisionModal | 2 |
| CustomDropdown | 1 |
| PeriodField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| IntegrationPsiForm | 1 |
| SubTitle | 1 |
| IntegrationPsiGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | `${binding.slice(0, 4)}-${binding.slice(4, 6)}` | 75 | true |  |  | object | features/supply/src/pages/integration-psi/utils/integrationPsiColumns.ts | 80 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00429 | 1 |
| MSG00219 | 1 |
| MSG00260 | 1 |
| MSG01434 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |
| MSG00014 | 1 |
| MSG00608 | 1 |
| MSG01502 | 1 |
| LBL00001 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL01150 | 1 |
| LBL00767 | 1 |
| LBL00051 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00112 | 1 |
| MSG00009 | 1 |
| MSG00011 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0111(10), SCM0002(4), SCP0049(2), SCP0047(2), SCP0006(2), COM0013(2), SSP0021(2), SCP0098(1), DMF0021(1), SSP0060(1), SCP0013(1), SCP0134(1), SCP0025(1), SCP0110(1)
- SP/PKG: PKG_SCP0111(10), P_SCP0111_GET_ESS_PACK_LINE(5), P_SCP0111_SAVE_INTEGRATION_PSI(5), P_SCP0111_SAVE_PSI_ADMIN(4), P_ACTIVE_FLAG(3), P_SCP0111_GET_INTEGRATION_PSI(2), PR_GET_LOOKUP_INFO_LIST(1), P_ITEM_ID(1), P_NICK_NAME(1), P_DIVISION_ID(1), PKG_NSCM_UI_COM_MENU(1), P_OPERATION_GROUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | PeriodField 는 자체 <Grid size={gridSize}> 로 렌더하므로 바깥 Grid 로 감싸지 않는다(gridSize=3). | features/supply/src/pages/integration-psi/components/IntegrationPsiForm.tsx | 194 |
| endpoint | '^'delim bulk SAVE 는 useProcMutation(배열 unfold)을 우회해 apiClient.post 직접 호출 | features/supply/src/pages/integration-psi/integration-psi.constants.ts | 226 |
| code | `dtPSI = DBUtils.Filter(dtPSIAll, sb, true); if (dtPSI.Rows.Count > 0) { MSG00260; return; }` | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 88 |
| code | 그리드 gotFocus 용 no-op — 렌더마다 새 화살표(`() => undefined`)를 내리면 그 참조가 gotFocus prop 으로 | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 124 |
| endpoint | 영역3 그리드 — 고정 24열(admin 메타) + 서버측 동적 YYYYMM PIVOT + 편집잠금 L1~L23 + 조건색 C1/C2 + LINE_ID 신규행 셀콤보(§2-D). division/auth 조합으로 셀 단위 잠금을 beginningEdit 에서 재현(편집모드 없음). essPackLineRows(분기 A ESS Pack Line): 원천이 CMBO 아닌 SP(P_SCP0111_GET_ESS_PACK_LINE, I | features/supply/src/pages/integration-psi/IntegrationPsi.tsx | 555 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 'Integration PSI' 24행 | features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | 40 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch (design 03 §1-M 7행). PIVOT measure 세로축. division=81 은 MKT_FCST 제외. | features/supply/src/pages/integration-psi/useIntegrationPsiStore.ts | 43 |
| endpoint | SCP0111 저장 call-proc 직접 호출 — '^'delim bulk payload 는 useProcMutation(배열 unfold)을 우회해 | features/supply/src/pages/integration-psi/utils/integrationPsiApi.ts | 1 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

