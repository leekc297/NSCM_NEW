# DMF0074_CLOUD_20260823 — 파일 목록 (기계 산출)

총 98 파일 / 1,164,852 bytes

| 경로 | bytes | 줄 | md5(10) | 용도 |
|---|---:|---:|---|---|
| `00_CLOUD_PRECHECK.sql` | 6,410 | 78 | `6c9e4918cd` | 적용 전 확인 C1~C6 (read-only) — C3=DMF0074_40 판별 / C5=시퀀스 / C6=SP_W 0건 |
| `A_DB/00_GTT_DDL.sql` | 23,139 | 612 | `a0e9df616d` | GT_DM74_* 17종 자급 DDL (기존재 skip·멱등) |
| `A_DB/01_PKG_DMF0074_SPEC.sql` | 2,510 | 53 | `f35a03bdfa` | PKG SPEC 전체 교체 (51줄) |
| `A_DB/02_PKG_DMF0074_BODY.sql` | 242,408 | 3,982 | `c6ea65e585` | PKG BODY 전체 교체 (3,980줄 · 0819 대비 +0행) |
| `A_DB/05_FIX_HISTORY_SEQ_RESEED.sql` | 1,983 | 30 | `7072143646` | HISTORY_SEQ 재시드 — PRECHECK C5 가 뒤처짐일 때만 |
| `A_DB/10_SHEET_COLUMNS.sql` | 58,395 | 121 | `fa831854f1` | SCM_MST_SHEET_COLUMNS 58행 — 시트 단위 삭제 후 재적재 |
| `A_DB/12_EXCEL_COLUMNS.sql` | 2,812 | 8 | `fe1dfc320f` | SCM_ADM_EXCEL_COLUMNS 2행 ⭐ DMF0074 + DMF0074_40 |
| `A_DB/20_WIRING_AUTH.sql` | 54,365 | 429 | `29ec31a846` | 배선 43행 + 권한 27행 MERGE (패밀리 포함) |
| `A_DB/30_MSG_LBL_MNU.sql` | 41,381 | 279 | `74746961ed` | MSG/LBL/MNU 69행 INSERT-only (MSG01015 포함) |
| `A_DB/90_VERIFY.sql` | 4,580 | 65 | `48a296552c` | 적용 후 검증 V1~V7 (사내에서 전 항목 PASS 실측) |
| `A_DB/91_DIAG_TEMPLATE_EMPTY.sql` | 5,432 | 87 | `1a0fdc047d` | 진단 — Excel Form 0건 퍼널 |
| `A_DB/92_DIAG_CLOUD_MRFPARITY.sql` | 3,868 | 69 | `5c4be8d8ad` | 진단 — MRF 버전 사내/클라우드 대조 |
| `A_DB/93_DIAG_CLOUD_TEMPLATE_FUNNEL.sql` | 9,125 | 147 | `3cf4dd8722` | 진단 — 템플릿 조회 단계별 감소 지점 |
| `A_DB/94_DIAG_CLOUD_SPW_LEDGER.sql` | 2,862 | 50 | `ab9c058474` | 진단 — SP_W 버전 vs 원장 적재 행수 |
| `A_DB/95_FIX_CLOUD_EMPTY_SPW_VERSION.sql` | 4,861 | 87 | `0b4dd84daf` | 조치안(대증) — 빈 SP_W 버전 해소 |
| `B_FE/features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.tsx` | 8,495 | 217 | `9e9eca4813` |  |
| `B_FE/features/demand/src/pages/metal-link-price/metal-link-price.constants.ts` | 11,373 | 315 | `85e77302f8` |  |
| `B_FE/packages/foundation/src/utils/string.ts` | 1,358 | 32 | `2735ff4315` |  |
| `B_FE/packages/shared/src/components/organisms/index.ts` | 705 | 14 | `7945a0d845` |  |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` | 10,551 | 239 | `3f6433a8ea` |  |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid/olapUtils.ts` | 1,325 | 35 | `ddc91327b4` |  |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts` | 19,045 | 392 | `182294275e` |  |
| `B_FE_MERGE/_READ_FIRST.md` | 1,544 | 23 | `2d4fc5d36f` |  |
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
| `B_FE_POOL/features/demand/src/pages/metal-link-price/MetalLinkPrice.tsx` | 15,476 | 330 | `7eb10db53a` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/__asis-mapping__.md` | 48,253 | 317 | `d6a8b6c3ef` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.module.scss` | 2,354 | 88 | `b0f160c414` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/MetalLinkPriceForm.tsx` | 10,710 | 241 | `9f45a14878` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/MetalLinkPriceGrid.tsx` | 11,446 | 291 | `d15d5805b3` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/modals/MetalLinkTemplateModal.module.scss` | 882 | 30 | `1f8250dd3d` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.module.scss` | 986 | 36 | `8cd7ab88ba` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx` | 10,168 | 265 | `12de19b6cb` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/index.ts` | 35 | 1 | `708021fc47` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/metal-link-price.types.ts` | 1,784 | 41 | `84d98be5b5` |  |
| `B_FE_POOL/features/demand/src/pages/metal-link-price/useMetalLinkPriceStore.ts` | 7,025 | 160 | `1fe01c8063` |  |
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
| `_README.md` | 10,901 | 152 | `59cf057fa5` | 취합 근거·정정 계보·제외 사유·적용 순서·미해결 |
| `_cloud_gap_check.mjs` | 2,925 | 57 | `6d4d89070e` |  |
| `_precopy_export_guard.mjs` | 2,729 | 56 | `96beebf020` |  |
| `_survey/collect_report.json` | 24,895 | 154 | `e614dde84c` | 기계 스윕 원자료 |
| `_survey/delta_vs_DMF0074_CLOUD_20260819.diff` | 35 | 4 | `20c8fee872` | BODY 델타 (+0행) |
| `_survey/fe_check_20260823.txt` | 1,398 | 32 | `4148963e82` | FE 검증 원문 (type-check/lint, error 0) |
| `_survey/file_desc.json` | 1,725 | 22 | `8a25b13eb9` | 본 목록의 용도 설명 원천 |
