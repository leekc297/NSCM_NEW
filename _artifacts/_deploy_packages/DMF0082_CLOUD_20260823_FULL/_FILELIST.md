# DMF0082_CLOUD_20260823_FULL — 파일 목록 (기계 산출)

총 127 파일 / 2,936,679 bytes

| 경로 | bytes | 줄 | md5(10) | 용도 |
|---|---:|---:|---|---|
| `00_CLOUD_PRECHECK.sql` | 12,494 | 171 | `a88a9fc693` | 적용 전 확인 C1~C9 — C4=⛔ 센티널 적용 게이트 |
| `A_DB/00B_DDL_DEFAULT_ON_NULL.sql` | 4,874 | 100 | `1fa328ab34` | DEFAULT ON NULL 5표 61열 (멱등) |
| `A_DB/00_GTT_DDL.sql` | 33,098 | 963 | `aa5f7a6641` | GT_DMF0082_* 33종 + 인덱스 1 자급 DDL (멱등) |
| `A_DB/01_PKG_DMF0082_SPEC.sql` | 7,419 | 94 | `38b1da40c0` | PKG SPEC 전체 교체 (92줄) |
| `A_DB/02_PKG_DMF0082_BODY.sql` | 839,599 | 14,755 | `1c799ac04e` | PKG BODY 전체 교체 (14,753줄 · 0820 대비 +149행) |
| `A_DB/04_CMBO_SYNC.sql` | 63,997 | 174 | `b7f3b6ab12` | CMBO 24종 MERGE (⚠ 공유 콤보 포함 — 선별 적용) |
| `A_DB/10_SHEET_COLUMNS.sql` | 90,184 | 188 | `ac776bdae6` | SHEET_COLUMNS 90행 (2시트) — 시트 단위 재적재 |
| `A_DB/11_SHEET_MEASURE.sql` | 16,199 | 48 | `7fc6b92381` | SHEET_MEASURE 22행 재적재 |
| `A_DB/12_EXCEL_COLUMNS.sql` | 923 | 6 | `90e306ff23` | EXCEL_COLUMNS 1행 재적재 |
| `A_DB/20_WIRING_AUTH.sql` | 202,507 | 1,605 | `e8b45cc4c6` | 배선 160행 + 권한 106행 MERGE (총 266) |
| `A_DB/21_LOOKUP.sql` | 37,078 | 128 | `23bf569bee` | LOOKUP_MASTER_DETAIL 21행 MERGE (NULL-safe ON) |
| `A_DB/30_MSG_LBL_MNU.sql` | 136,785 | 912 | `4fd7917f69` | MSG/LBL/MNU 92코드 227행 INSERT-only |
| `A_DB/90_VERIFY.sql` | 13,011 | 181 | `71301a2b55` | 적용 후 검증 V1~V10 (⭐ V2 오탐 정정본 · 사내 전항목 PASS) |
| `B_FE/features/demand/src/pages/forecast-price/ForecastPrice.tsx` | 60,968 | 1,139 | `d31f1b4d8c` |  |
| `B_FE/features/demand/src/pages/forecast-price/__asis-mapping__.md` | 108,987 | 525 | `04f5472705` |  |
| `B_FE/features/demand/src/pages/forecast-price/components/ForecastPriceForm.tsx` | 14,576 | 314 | `6bea5a49e4` |  |
| `B_FE/features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx` | 96,494 | 1,751 | `14078d9626` |  |
| `B_FE/features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.tsx` | 10,325 | 237 | `91ac550e2e` |  |
| `B_FE/features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx` | 53,716 | 1,180 | `ad4f5feab9` |  |
| `B_FE/features/demand/src/pages/forecast-price/forecast-price.constants.ts` | 17,933 | 258 | `f03105b1fc` |  |
| `B_FE/features/demand/src/pages/forecast-price/utils/forecast-price.combo.ts` | 875 | 13 | `786d834064` |  |
| `B_FE/features/demand/src/pages/forecast-price/utils/forecast-price.groupMeasure.test.ts` | 4,351 | 124 | `8c1fbc2baf` |  |
| `B_FE/packages/foundation/src/utils/string.ts` | 1,358 | 32 | `2735ff4315` |  |
| `B_FE/packages/shared/src/components/organisms/index.ts` | 705 | 14 | `7945a0d845` |  |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` | 10,551 | 239 | `3f6433a8ea` |  |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid/olapUtils.ts` | 1,325 | 35 | `ddc91327b4` |  |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts` | 19,045 | 392 | `182294275e` |  |
| `B_FE_MERGE/_READ_FIRST.md` | 1,716 | 24 | `df89d7d9d8` |  |
| `B_FE_MERGE/configs/types/procedures.d.ts` | 148,272 | 4,536 | `3307fc4338` |  |
| `B_FE_MERGE/configs/types/procedures.d.ts.COMMON.txt` | 108,462 | 3,639 | `996fbb4595` |  |
| `B_FE_MERGE/packages/shared/src/components/molecules/customDropdown/components/CustomListboxRow.tsx` | 1,859 | 61 | `c9dc7f95dd` |  |
| `B_FE_MERGE/packages/shared/src/components/molecules/customDropdown/components/CustomListboxRow.tsx.COMMON.txt` | 3,016 | 90 | `1b3e5b8a1f` |  |
| `B_FE_MERGE/packages/shared/src/components/organisms/data-grid/dataGridUtils.ts` | 22,413 | 561 | `b9bbb2b8ec` |  |
| `B_FE_MERGE/packages/shared/src/components/organisms/data-grid/dataGridUtils.ts.COMMON.txt` | 21,739 | 553 | `f001409789` |  |
| `B_FE_MERGE/packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx` | 21,695 | 529 | `7b580ad393` |  |
| `B_FE_MERGE/packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx.COMMON.txt` | 20,099 | 510 | `bc78b0728d` |  |
| `B_FE_MERGE/packages/shared/src/stores/useDirtyRegistry.ts` | 10,237 | 233 | `f04f7fb54b` |  |
| `B_FE_MERGE/packages/shared/src/stores/useDirtyRegistry.ts.COMMON.txt` | 10,237 | 233 | `51f5497883` |  |
| `B_FE_POOL/features/demand/src/components/fcst-upload-modal/FcstUploadModal.tsx` | 15,251 | 376 | `0972e7ab7c` |  |
| `B_FE_POOL/features/demand/src/components/index.ts` | 100 | 2 | `ba03e05931` |  |
| `B_FE_POOL/features/demand/src/components/versionModal/VersionModal.module.scss` | 4,630 | 128 | `ef9de0aa18` |  |
| `B_FE_POOL/features/demand/src/components/versionModal/VersionModal.tsx` | 25,866 | 621 | `5cd31c4a9a` |  |
| `B_FE_POOL/features/demand/src/components/versionModal/version-modal.api.ts` | 4,179 | 84 | `f69965d57a` |  |
| `B_FE_POOL/features/demand/src/components/versionModal/version-modal.constants.ts` | 4,040 | 76 | `e1016339be` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/ForecastPriceForm.module.scss` | 253 | 16 | `9430f70c6f` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.test.ts` | 8,884 | 199 | `4d73c6943f` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.ts` | 26,918 | 587 | `d143825615` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.module.scss` | 913 | 38 | `a0b70a3474` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx` | 42,308 | 836 | `d13f1e451d` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/ForecastTemplateModal.module.scss` | 954 | 35 | `48b7a0aac3` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.module.scss` | 3,974 | 121 | `b3eef005f6` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.module.scss` | 770 | 34 | `c273bac236` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx` | 13,889 | 320 | `2105ae65ee` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/components/modals/index.ts` | 490 | 7 | `534256d8ad` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/forecast-price.types.ts` | 3,002 | 71 | `8c496d1a71` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/index.ts` | 50 | 1 | `28ddceb947` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/useForecastPriceStore.test.tsx` | 6,035 | 170 | `d919470c29` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/useForecastPriceStore.ts` | 19,694 | 436 | `c924690455` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.api.ts` | 7,157 | 160 | `63135ea1a8` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.asFromSite.test.ts` | 3,212 | 84 | `e6fad4b2ed` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.asFromSite.ts` | 2,362 | 44 | `240dbe1115` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.editLock.test.ts` | 5,507 | 129 | `e326d9fd9b` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.editLock.ts` | 4,135 | 77 | `ee0524bfb8` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.excelForm.ts` | 6,327 | 144 | `4b9f8f4543` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.groupMeasure.ts` | 5,187 | 109 | `d721857c9a` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.measureEdit.test.ts` | 4,279 | 116 | `a2241f4531` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.save.test.ts` | 6,539 | 149 | `887fa78369` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.save.ts` | 10,597 | 207 | `69915def2c` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.validate.test.ts` | 9,138 | 234 | `c6dfa0a744` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.validate.ts` | 8,629 | 153 | `572c4c3ed2` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.wsAuth.test.ts` | 4,192 | 119 | `2b0c98076b` |  |
| `B_FE_POOL/features/demand/src/pages/forecast-price/utils/forecast-price.wsAuth.ts` | 20,278 | 346 | `74bdd2f511` |  |
| `B_FE_POOL/packages/foundation/src/apis/axios.ts` | 5,953 | 196 | `e7bc72ef07` |  |
| `B_FE_POOL/packages/foundation/src/constants/button-type.ts` | 362 | 15 | `8184ee7836` |  |
| `B_FE_POOL/packages/foundation/src/constants/column-config.ts` | 719 | 27 | `83f47a7f35` |  |
| `B_FE_POOL/packages/foundation/src/constants/index.ts` | 189 | 6 | `b4b8caa666` |  |
| `B_FE_POOL/packages/foundation/src/constants/message-id.ts` | 1,094 | 14 | `27b31e7412` |  |
| `B_FE_POOL/packages/foundation/src/lib/query-client.ts` | 7,635 | 167 | `1b22f1a9c2` |  |
| `B_FE_POOL/packages/foundation/src/styles/common-styles.module.scss` | 1,317 | 52 | `c9eb09a93c` |  |
| `B_FE_POOL/packages/foundation/src/utils/columnMapping.ts` | 18,863 | 445 | `f478efcb2f` |  |
| `B_FE_POOL/packages/foundation/src/utils/editTracker.ts` | 7,513 | 153 | `cd36a46d21` |  |
| `B_FE_POOL/packages/foundation/src/utils/gridAction.ts` | 44,644 | 972 | `b56c610aa0` |  |
| `B_FE_POOL/packages/foundation/src/utils/gridUtils.ts` | 3,676 | 93 | `007700a2a3` |  |
| `B_FE_POOL/packages/foundation/src/utils/mergeManager.ts` | 11,147 | 261 | `f49a4dc4db` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/columnSelectDualList/ColumnSelectDualList.module.scss` | 4,508 | 226 | `1d1b2fa3c6` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/columnSelectDualList/ColumnSelectDualList.tsx` | 12,455 | 331 | `7bf5744b70` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx` | 28,417 | 584 | `8e60fe2a02` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/customDropdown/CustomDropdownMui.module.scss` | 3,468 | 66 | `72e4d0b247` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/customDropdown/components/CustomListbox.module.scss` | 743 | 33 | `d1cc974ca0` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/customDropdown/components/CustomListbox.tsx` | 5,349 | 138 | `f9c74bdd04` |  |
| `B_FE_POOL/packages/shared/src/components/molecules/dialog/CustomDialog.tsx` | 11,720 | 314 | `78620dc09f` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/alert/Alert.tsx` | 747 | 27 | `154f62475d` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/data-grid/DataGrid.tsx` | 46,653 | 933 | `c0446533ee` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/data-grid/gridContextMenu.ts` | 13,967 | 379 | `f8ef7e29b1` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/data-grid/titleSetApi.ts` | 10,764 | 241 | `f3977d6903` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/main-title/MainTitle.tsx` | 3,577 | 93 | `98cd3265d6` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/result-area/ResultArea.module.scss` | 2,331 | 102 | `d5d75d3a6e` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/result-area/ResultArea.tsx` | 6,066 | 171 | `d47b5b825a` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/result-area/ResultArea.types.ts` | 2,984 | 64 | `4e6c9f2755` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/search-area/SearchArea.tsx` | 7,999 | 223 | `a504548e8f` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/sub-title/SubTitle.tsx` | 18,594 | 470 | `bfc5f2cd81` |  |
| `B_FE_POOL/packages/shared/src/components/organisms/toast-message/ToastMessage.tsx` | 945 | 28 | `865cdb7782` |  |
| `B_FE_POOL/packages/shared/src/components/templates/index.ts` | 300 | 5 | `811fbb429d` |  |
| `B_FE_POOL/packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.module.scss` | 1,291 | 50 | `cfc2610d3c` |  |
| `B_FE_POOL/packages/shared/src/hooks/index.ts` | 196 | 5 | `a54e066f0c` |  |
| `B_FE_POOL/packages/shared/src/hooks/useClearAppData.ts` | 2,201 | 42 | `bb6a135f06` |  |
| `B_FE_POOL/packages/shared/src/hooks/useCustomQueryClient.ts` | 8,510 | 262 | `c2c67cd315` |  |
| `B_FE_POOL/packages/shared/src/hooks/useInsertedRows.ts` | 15,506 | 327 | `2ba5c6d7e5` |  |
| `B_FE_POOL/packages/shared/src/hooks/useSaveWithValidation.ts` | 4,630 | 100 | `b12d8a90b6` |  |
| `B_FE_POOL/packages/shared/src/hooks/useTabBtnPermissions.ts` | 1,909 | 54 | `9db1758ea4` |  |
| `B_FE_POOL/packages/shared/src/lib/lges.ts` | 851 | 44 | `21729511af` |  |
| `B_FE_POOL/packages/shared/src/lib/mui.ts` | 305 | 19 | `e509df6852` |  |
| `B_FE_POOL/packages/shared/src/stores/index.ts` | 312 | 9 | `9136b3eff4` |  |
| `B_FE_POOL/packages/shared/src/stores/useMessageStore.ts` | 2,056 | 76 | `d195076660` |  |
| `B_FE_POOL/packages/shared/src/stores/useSessionStore.ts` | 4,771 | 126 | `32bf726fa1` |  |
| `C_BE/admin-menu/Menu.xml` | 3,506 | 102 | `eb98f686a5` |  |
| `C_BE/admin-menu/MenuController.java` | 9,432 | 176 | `d105f6a900` |  |
| `C_BE/admin-menu/MenuService.java` | 1,392 | 27 | `781f6d0dfa` |  |
| `C_BE/admin-menu/MenuServiceImpl.java` | 7,445 | 198 | `d923e93676` |  |
| `_INVENTORY.md` | 8,271 | 87 | `68f871c3f4` | 선행판 인벤토리 (참고 이월) |
| `_README.md` | 14,202 | 190 | `f3242c2798` | 취합 근거·정정 계보·제외 사유·적용 순서·미해결 (정본) |
| `_cloud_gap_check.mjs` | 2,925 | 57 | `6d4d89070e` |  |
| `_precopy_export_guard.mjs` | 2,729 | 56 | `96beebf020` |  |
| `_survey/collect_report.json` | 32,080 | 328 | `06c4c70574` | 기계 스윕 원자료 |
| `_survey/delta_vs_DMF0082_CLOUD_20260820.diff` | 15,692 | 248 | `e54da4826c` | BODY 델타 +149행 (마커 3종) |
| `_survey/fe_check_20260823.txt` | 1,398 | 32 | `4148963e82` | FE 검증 원문 (type-check/lint, error 0) |
| `_survey/file_desc.json` | 1,509 | 21 | `954c3dd4ac` | 본 목록의 용도 설명 원천 |
