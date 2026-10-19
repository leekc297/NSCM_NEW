# DMF0074 — To-Be Fact Pack 요약

- page_key: `demand/metal-link-price` · feature: demand · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 10 (미해결 0, 주석 속 3) · 이벤트 31 · 컴포넌트 사용 60 · 하드코딩 컬럼 10 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 10건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.module.scss | component | 89 |
| features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | component | 344 |
| features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | component | 303 |
| features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.module.scss | component | 33 |
| features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx | component | 231 |
| features/demand/src/pages/metal-link-price/components/modals/metalLinkTemplateModalStore.ts | store | 25 |
| features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.module.scss | component | 39 |
| features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | component | 301 |
| features/demand/src/pages/metal-link-price/components/modals/metalLinkVersionModalStore.ts | store | 57 |
| features/demand/src/pages/metal-link-price/index.ts | index | 2 |
| features/demand/src/pages/metal-link-price/metal-link-price.constants.ts | constants | 327 |
| features/demand/src/pages/metal-link-price/metal-link-price.types.ts | types | 42 |
| features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | page | 401 |
| features/demand/src/pages/metal-link-price/useMetalLinkPriceStore.ts | store | 176 |
| features/demand/src/pages/metal-link-price/utils/metal-link-price.searchCombos.ts | util | 43 |
| features/demand/src/pages/metal-link-price/__asis-mapping__.md | mapping | 318 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | MetalLinkPriceForm.tsx:72 MetalLinkTemplateModal.tsx:58 MetalLinkVersionModal.tsx:89 MetalLinkPrice.tsx:97 |
| DMF0074/template//call-proc | hook | 1 | Y | MetalLinkTemplateModal.tsx:83 |
| DMF0074/version//call-proc | hook | 1 | Y | MetalLinkVersionModal.tsx:136 |
| DMF0074/Metal Link Price//call-proc | hook | 1 | Y | MetalLinkPrice.tsx:79 |
| /DMF0074/Metal Link Price/SAVE/call-proc | http | 1 | Y | MetalLinkPrice.tsx:364 |
| /admin/menu/DMF0074/column | http | 1 | Y | useMetalLinkPriceStore.ts:132 |
| /admin/menu/DMF0074/search-conditions | http | 1 | Y | useMetalLinkPriceStore.ts:150 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Metal Link Price | divisionId deptId endCustomer scmSiteId plantSiteId projectCode itemId fromYyyymmdd toYyyymmdd versionType sesUserId mnuId | o_rc1 | PKG_DMF0074 P_DMF0074_GET_METAL_LINK_TEMPLATE DMF0073_GET_VERSION_SALESPRICE P_DMF0074_EXCEL_UPLOAD |
| template | divisionId sesUserId mnuId | o_rc1 | PKG_DMF0074 P_DMF0074_GET_METAL_LINK_TEMPLATE DMF0073_GET_VERSION_SALESPRICE P_DMF0074_EXCEL_UPLOAD |
| version | startYyyymmdd endYyyymmdd createdBy divisionId versionType description | o_rc1 | PKG_DMF0074 P_DMF0074_GET_METAL_LINK_TEMPLATE DMF0073_GET_VERSION_SALESPRICE P_DMF0074_EXCEL_UPLOAD |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 140 |
| SearchArea | onSearch | onSubmit | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 165 |
| CustomDropdown | onChange | <arrow> setSearchParams,String,setComboTrigger | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 180 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 250 |
| InputField | onKeyDown | openModalOnEnter(() => setOpenPrjByDivisionModal(true)) | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 251 |
| Button | onClick | <arrow> setOpenPrjByDivisionModal | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 258 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 277 |
| InputField | onKeyDown | openModalOnEnter(() => setOpenModelByDivisionModal(true)) | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 278 |
| Button | onClick | <arrow> setOpenModelByDivisionModal | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 284 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 299 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 313 |
| Button | onClick | <arrow> setOpenVersionModal | jsx | features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx | 319 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 183 |
| g | updatedLayout | onLayout | addHandler | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 228 |
| f | filterChanging | <arrow> s.activeEditor.buttonClicked.addHandler,s.apply | addHandler | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 260 |
| s.activeEditor | buttonClicked | <arrow> s.apply | addHandler | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 263 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 269 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx | 175 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx | 214 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx | 223 |
| g.hostElement? | dblclick | onDbl | addEventListener | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 182 |
| SearchArea | onSearch | handleFind | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 213 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 226 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 235 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 246 |
| Button | onClick | handleApply | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 286 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 293 |
| MetalLinkPriceForm | onSubmit | handleSearch | jsx | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 274 |
| MetalLinkVersionModal | onApply | <arrow> setSearchParams | jsx | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 340 |
| FcstUploadModal | onSave | <arrow> useSessionStore.getState,apiClient.post,Number | jsx | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 358 |
| FcstUploadModal | onUploaded | <arrow> setSearchParams,setFilters | jsx | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 384 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 8 |
| Button | 7 |
| CustomDropdown | 4 |
| InputField | 4 |
| SearchArea | 3 |
| FunctionSearchIcon | 3 |
| PeriodField | 2 |
| DataGrid | 2 |
| CustomDialog | 2 |
| ResultArea | 2 |
| MetalLinkPriceGrid | 2 |
| Tooltip | 1 |
| FileExceldownloadIcon | 1 |
| ProgressIndicator | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| MetalLinkPriceForm | 1 |
| SubTitle | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| MetalLinkVersionModal | 1 |
| FcstUploadModal | 1 |
| Alert | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | c.key | c.header | c.width ?? 100 | c.visible !== false && (c.width ?? 100) > 0 |  |  | object | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 49 |
| mergedColumns | col.colNm | col.colLblNm \|\| fb?.header \|\| col.colNm | col.colWth ?? fb?.width ?? 100 | col.visible !== false && (col.colWth ?? fb?.width ?? 100) >  |  |  | object | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 65 |
| baseStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 104 |
| leaf | c.binding | c.header | c.width | true | true |  | object | features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx | 126 |
| VERSION_COLUMNS | VERSION_NO | Version | 240 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 61 |
| VERSION_COLUMNS | VERSION_DESCRIPTION | Details | 300 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 62 |
| VERSION_COLUMNS | VERSION_TYPE | Type | 90 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 63 |
| VERSION_COLUMNS | MONTHLY_ROLLING_FCST | Monthly Rolling Forecast | 170 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 64 |
| VERSION_COLUMNS | CREATED_BY | Create By | 110 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 65 |
| VERSION_COLUMNS | CREATION_DATE | Create Date | 150 |  |  |  | meta-shape | features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx | 66 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 3 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00617 | 1 |
| LBL00618 | 1 |
| LBL00606 | 1 |
| LBL00005 | 1 |
| LBL00762 | 2 |
| LBL00664 | 2 |
| LBL00763 | 1 |
| LBL00627 | 2 |
| LBL00674 | 1 |
| LBL00739 | 1 |
| LBL00608 | 1 |
| MSG00137 | 1 |
| MSG00283 | 1 |
| MSG00614 | 1 |
| MSG00108 | 1 |
| MSG00097 | 1 |
| MSG00255 | 1 |
| MSG00265 | 1 |
| MSG01015 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0020(6), DMF0074_40(5), DMF0014(3), DMF0074(3), DMF0082(2), DMF0042(1), DMF0021(1), DMF0045(1), DMF0053(1)
- SP/PKG: PKG_DMF0074(9), P_DMF0074_GET_METAL_LINK_PRICE(4), P_DMF0074_GET_METAL_LINK_TEMPLATE(3), DMF0073_GET_VERSION_SALESPRICE(3), P_DMF0074_EXCEL_UPLOAD(2), P_FROM(2), DMF0000_GET_COMMON_SPREAD_TITLE(1), P_MODE(1), P_PROGRAM_ID(1), P_CREATED_BY(1), PKG_NSCM_UI_COM_MENU(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 정본은 admin 동적 fetch (fetchStaticColumns) — 본 fallback 은 BE 메타 미응답 시 작동 보장용. | features/demand/src/pages/metal-link-price/metal-link-price.constants.ts | 89 |
| code | import { MetalLinkTemplateModal } from './components/modals/MetalLinkTemplateModal'; | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 25 |
| endpoint | ui-dynamic-property-management — Menu Button 권한 동적 fetch (하드코딩 금지) | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 65 |
| code | const [openTemplateModal, setOpenTemplateModal] = useState<boolean>(false); | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 75 |
| code | void setToast({ message: t('LBL00665', '_Loading...'), type: 'default', duration: 2000 }); | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 165 |
| code | setOpenTemplateModal(true); | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 253 |
| jsx | iconComponent: <FileExceldownloadIcon />, | features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx | 256 |
| endpoint | ⭐ ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 58행, admin 즉시 반영) | features/demand/src/pages/metal-link-price/useMetalLinkPriceStore.ts | 128 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

