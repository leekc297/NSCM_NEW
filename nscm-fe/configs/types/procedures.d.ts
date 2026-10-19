export { };

// 배열 타입에서 요소 타입만 추출하는 헬퍼
type Unpacked<T> = T extends (infer U)[] ? U : T;

interface Base {
  [key: string]: {
    [key: string]: {
      request: Record<string, JsonPrimitive>;
      response: Record<string, WijmoRowItem>;
    };
  };
}

interface RawProcedureMap extends Base {
  /**
   * 테스트용.
   */
  test: {
    sheetA: {
      request: {
        divisionId: string;
        team: string;
        endCustomer: string;
      };
      response: {
        o_rc1: {
          itemCode: string;
          itemName: string;
          forecastDate: string;
          [key: string]: string | number;
        };
      };
    };
  } & {
    [K in 'sheetB' | 'sheetC']:{
      request: {
        divisionId: string;
        team: string;
        endCustomer: string;
      };
      response: {
        o_rc1: {
          itemCode: string;
          itemName: string;
          forecastDate: string;
          [key: string]: string | number;
        };
        o_rc2: {
          itemCode: string;
          itemName: string;
          forecastDate: string;
          [key: string]: string | number;
        };
      };
    }
  }

  /**
   * Shipment Request(Electrode) — SSP0022 (신규 생성 2026-09-26)
   *
   * AS-IS GSCM.SSP.Plan.UIL SSP0022_ShipmentRequestElectrode — pivot 메인그리드(BOH/PSI) +
   * 요청상세(편집) + 재고상세(읽기전용) + 엑셀전용 4시트. 설계 근거:
   * .atlas/gscm-design/SSP0022/design/00_checklist.md ~ 03_grid-columns.md.
   * SP 12건(PKG_SSP0022/PKG_DM0003/PKG_SSP0002) 전부 TO-BE 미배포(all_objects 0건,
   * 2026-09-26 ora.py 실측) — 아래 request/response 는 design 02/03 문서의 AS-IS 소비부
   * 역산치(코드 관점)이며 SP 실측 대사가 아니다(convert-sp 후속 배포 시 재검증 필수).
   * SHEETS:
   * - `main`               PKG_SSP0022.P_SSP0022_GET_SHIPMENT_PSI (메인 pivot 조회)
   * - `requestDetail`      PKG_SSP0022.P_SSP0022_GET_REQUEST_DETAIL / SAVE 대상
   * - `stockDetail`        PKG_SSP0022.P_SSP0022_GET_STOCK_DETAIL (읽기전용)
   * - `requestDetailExcel` PKG_SSP0022.P_SSP0022_GET_REQUEST_DETAIL_EXCEL_DOWN
   * - `spreadTitle`        PKG_SSP0022.P_SSP0022_GET_SHEET_CALENDAR_3SPAN (동적 pivot 3-span 헤더)
   * - `bodItemPopup`       PKG_SSP0022.P_SSP0022_GET_ITEM_POPUP (BOD/Item 검색 팝업)
   */
  SSP0022: {
    main: {
      request: {
        divisionId: string; // P_DIVISION_ID
        companyId: string; // P_COMPANY_ID
        plantId: string; // P_PLANT_ID (콤마, 빈값 'ALL')
        cellType: string; // P_CELL_TYPE (콤마)
        planStartYyyymmdd: string; // P_PLAN_START_YYYYMMDD
        fromYyyymmdd: string; // P_FROM_YYYYMMDD
        toYyyymmdd: string; // P_TO_YYYYMMDD
        modelId: string; // P_MODEL_ID
        itemId: string; // P_ITEM_ID
        nickName: string; // P_NICK_NAME
        sesUserId: string; // P_USER_ID
        mnuId: string; // P_PROGRAM_ID
        sheetName: string; // P_SHEET_NAME
        realFlag: string; // P_REAL_FLAG ('Y'|'N' — cboPlanDate 최신선택 여부)
        myModelChk: string; // P_MY_MODEL_CHK ('Y'|'N')
        partLeaderChk: string; // P_PART_LEADER_CHK ('Y'|'N')
        teamLeaderChk: string; // P_TEAM_LEADER_CHK ('Y'|'N')
        delegateChk: string; // P_DELEGATE_CHK ('Y'|'N')
        nonChk: string; // P_NON_CHK ('Y' — 4개 체크박스 전부 미체크 시)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          PLANT_ID: string;
          CELL_TYPE: string;
          MODEL_ID: string;
          ITEM_ID: string;
          MEASURE: string;
          [key: string]: string | number;
        };
      };
    };
    requestDetail: {
      request: {
        divisionId: string;
        companyId: string;
        modelId: string; // P_MODEL_ID(2차, txtModelId2)
        itemId: string; // P_ITEM_ID(2차, txtItemId2)
        nickName: string; // P_NICK_NAME(2차)
        fromYyyymmdd: string; // drpPeriod2
        toYyyymmdd: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MODEL_ID: string;
          ITEM_ID: string;
          EDIT_FLAG: string;
          [key: string]: string | number;
        };
      };
    };
    stockDetail: {
      request: {
        divisionId: string;
        companyId: string;
        modelId: string;
        itemId: string;
        lotId: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          PLANT_ID: string;
          MODEL_ID: string;
          ITEM_ID: string;
          [key: string]: string | number;
        };
      };
    };
    requestDetailExcel: {
      request: {
        divisionId: string;
        companyId: string;
        modelId: string;
        itemId: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          COMPANY_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          ITEM_ID: string;
          YYYYMMDD: string;
          QTY: number;
          TRANSPORT_MODE: string;
          INCOTERMS: string;
        };
      };
    };
    spreadTitle: {
      request: {
        fromYyyymmdd: string; // p_start_yyyymmdd
        toYyyymmdd: string; // p_end_yyyymmdd
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
        };
      };
    };
    bodItemPopup: {
      request: {
        divisionId: string;
        modelId: string;
        itemId: string;
        sesUserId: string;
      };
      response: {
        o_rc1: {
          BOD_ID: string;
          ITEM_ID: string;
          MODEL_ID: string;
          INCOTERMS: string;
          TRANSPORT_MODE: string;
          CONFIRM_DAY: string;
        };
      };
    };
  }

  /**
   * Shipment Request Pack — SSP0026 (신규 생성 2026-09-26, iter-1 골격)
   *
   * AS-IS GSCM.SSP.Forms.UIL.Plan.SSP0026_ShipmentRequestPack(정본, controls 76) — pivot 메인그리드
   * (Pack Biz/Cell Biz) + 상세(Request Detail 편집/Result Detail 읽기전용) + 엑셀전용 5시트.
   * 설계 근거: .atlas/gscm-design/SSP0026/design/00_checklist.md ~ 03_grid-columns.md(v4),
   * convert-flow/goal.md·plan.md.
   * SP 13건 중 7건 미배포(all_objects 0건, 2026-09-26 ora.py 실측, goal.md ②) — 메인 그리드
   * 조회(GET_SHIPMENT_REQUEST_PACK/_CELL)·저장(SAVE_SHIP_REQ_*4종)이 핵심 미배포 경로다.
   * 아래 request/response 는 design 02/03 문서의 AS-IS 소비부 역산치이며 SP 실측 대사가 아니다
   * (convert-sp 후속 배포 시 재검증 필수). 동적 pivot(D_/W_/M_) 컬럼은 response 에 인덱스 시그니처로만
   * 표현 — 정적 나열 금지(03_grid-columns.md §2).
   * SHEETS:
   * - `pack`/`cell`         PKG_SSP0026.P_SSP0026_GET_SHIPMENT_REQUEST_PACK/_CELL (미배포)
   * - `requestDetail`       PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL_PACK (배포됨) / _CELL(미배포)
   * - `resultDetail`        PKG_SSP0026.P_SSP0026_GET_RESULT_DETAIL (배포됨, 읽기전용)
   * - `requestDetailExcel`  PKG_SSP0026.P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN (배포됨)
   * - `spreadTitle`         PKG_SSP0026.P_SSP0026_GET_SPREAD_TITLE (배포됨, 동적 pivot 헤더)
   * - `bodItem`             PKG_SSP0026.P_SSP0026_GET_BOD_ITEM (배포됨, Incoterms/TrMode 변경 시 BOD_ID 자동세팅)
   * - `itemByDivisionPopup` PKG_SSP0026.P_SSP0026_GET_ITEM_BY_DIVISION_POPUP (배포됨, Model 팝업)
   */
  SSP0026: {
    pack: {
      request: {
        divisionId: string; // 고정값 "40"
        teamIds: string; // 콤마, 빈값 'ALL'
        endCustomerIds: string;
        salesSiteIds: string;
        plantSiteIds: string;
        bucketType: string; // Daily/Weekly/Monthly 코드
        fromYyyymmdd: string;
        toYyyymmdd: string;
        projectCode: string;
        modelId: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          MODEL_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MEASURE: string;
          CRUD_TYPE: string;
          CONFIRM_DAY: string;
          [key: string]: string | number; // D_/W_/M_ 동적 pivot 컬럼(03_grid-columns.md §2)
        };
      };
    };
    cell: {
      request: {
        divisionId: string;
        teamIds: string;
        endCustomerIds: string;
        salesSiteIds: string;
        plantSiteIds: string;
        bucketType: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        projectCode: string;
        modelId: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          MODEL_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MEASURE: string;
          CRUD_TYPE: string;
          [key: string]: string | number;
        };
      };
    };
    requestDetail: {
      request: {
        divisionId: string;
        fromYyyymmdd: string; // drpPeriod2
        toYyyymmdd: string;
        modelId: string; // txtItemld2
        nickName: string;
        lotId: string; // §2.9 dead parameter — AS-IS 그대로 미반영
        requestorName: string; // txtRequestor.Text(이름 문자열, ID 아님)
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MODEL_ID: string;
          EDIT_FLAG: string;
          CRUD_TYPE: string;
          [key: string]: string | number;
        };
      };
    };
    resultDetail: {
      request: {
        divisionId: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        modelId: string;
        nickName: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MODEL_ID: string;
          [key: string]: string | number;
        };
      };
    };
    requestDetailExcel: {
      request: {
        divisionId: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        modelId: string;
        sesUserId: string;
        mnuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          TO_SITE: string;
          MODEL_ID: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        fromYyyymmdd: string; // P_START_DT
        toYyyymmdd: string; // P_END_DT
        sesUserId: string; // P_CREATED_BY
        sheetName: string; // P_SHEET_NAME
        divisionId: string; // P_DIVISION_ID
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
        };
      };
    };
    bodItem: {
      request: {
        divisionId: string;
        modelId: string;
        incoterms: string;
        transportMode: string;
      };
      response: {
        o_rc1: {
          BOD_ID: string;
          MODEL_ID: string;
          INCOTERMS: string;
          TRANSPORT_MODE: string;
        };
      };
    };
    itemByDivisionPopup: {
      request: {
        divisionId: string; // 고정 "40"
        plantSiteOrSalesSite: string; // Model=plantSite / Model2=salesSite(02_search-combo.md §4.6)
        projectCode: string; // 빈 문자열 고정(AS-IS)
        currentItemId: string;
      };
      response: {
        o_rc1: {
          ITEM_ID: string;
          MODEL_ID: string;
          [key: string]: string | number;
        };
      };
    };
  }

  /**
   * MKT FCST Comparison — DMF0040 (Read-only Report, 신규 생성 2026-08-26)
   *
   * AS-IS DMF0040_MktFcst_Comparison (Forms.UIL 1,875행) — 버전(최대 2) 간 Waterfall 비교.
   * SHEETS (전부 SEARCH — 저장 없음):
   * - `mktFcstComparison` PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON (18 IN + O_RC1/O_RESULT_CURSOR)
   * - `spreadTitle`       DMF0040_GET_SPREAD_TITLE (5 IN — 동적 시간축)
   * - `version`           PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP (DMF0035 versionWf 동계약 — MF 축)
   * PROC_M = _artifacts/_diagnostics/dmf0040_build_20260826/seed_meta.py (positional 20/7 실측 등재)
   */
  DMF0040: {
    mktFcstComparison: {
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수 — MSG00097)
        scmSiteId: string; // 2  P_SCM_SITE_ID (Sales Site — 콤마, 빈값 'ALL')
        plantSiteId: string; // 3  P_PLANT_SITE_ID
        teamId: string; // 4  P_TEAM_ID
        customer: string; // 5  P_CUSTOMER (End Customer)
        bizType: string; // 6  P_BIZ_TYPE
        projectCode: string; // 7  P_PROJECT_CODE (텍스트 raw — 40 비활성 '')
        itemId: string; // 8  P_ITEM_ID
        fromYyyymmdd: string; // 9  P_FROM_YYYYMMDD
        toYyyymmdd: string; // 10 P_TO_YYYYMMDD
        sesUserId: string; // 11 P_CREATED_BY (BE 세션 주입)
        versionNo: string; // 12 P_VERSION_NO (콤마 최대 2 — MSG00255)
        itemType: string; // 13 P_ITEM_TYPE
        owner: string; // 14 P_OWNER
        diffOnly: string; // 15 P_DIFF_ONLY ('True'|'False' — AS-IS bool 직렬화 파리티)
        bucket: string; // 16 P_BUCKET (DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY)
        userId: string; // 17 P_USER_ID
        mnuId: string; // 18 P_MENU_ID
      };
      response: {
        o_rc1: {
          VERSION_NO: string;
          MEASURE: string;
          MEASURE_GROUP: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        sesUserId: string; // 3 P_CREATED_BY (BE 주입)
        divisionId: string; // 4 P_DIVISION_ID
        bucket: string; // 5 P_BUCKET
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
    version: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string; // 'MF_D,MF_W,MF_M' 조합 (체크박스)
        versionNo: string; // 설명 검색어
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          VER_CRE_SEQ: string | number;
          YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * Demand Plan Waterfall — DMF0035 (Read-only Report, AS-IS 3 UI 통합 2026-08-06)
   *
   * GUBUN(MKT_FCST/SALES_PLAN/BIZ_PLAN, 초기값 MKT_FCST) = 메인+타이틀 시트 스위칭.
   * SHEETS(canonical PROC):
   * - `mktFcstWaterfall`   PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL   (AS-IS 19 IN + USER/MENU = 21)
   * - `salesPlanWaterfall` PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL (20+2=22 — DMF0022 재사용)
   * - `bizPlanWaterfall`   PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL   (AS-IS 17 IN + 2 = 19)
   * - `*SpreadTitle`       각 PKG GET_SPREAD_TITLE (5 IN — Two-pass 2차)
   * - `version`            DMF0073_GET_VERSION_SALESPRICE 9-arg 공유 계약 (DMF0082.version 동일)
   * 정본: Doc/화면분석서/DMF0035_DemandPlanWaterfall_ASIS_통합분석_v1.0.md §4.3
   */
  DMF0035: {
    mktFcstWaterfall: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        projectCode: string;
        itemId: string;
        itemType: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        plantSiteId: string;
        bizType: string;
        owner: string;
        versionNo: string;
        bucket: string;
        cellYn: string;
        senderCode: string;
        userDeptId: string;
        groupId: string;
        userId: string;
        menuId: string;
      };
      response: {
        o_rc1: {
          VERSION_NO: string;
          MEASURE: string;
          [key: string]: string | number;
        };
        /**
         * o_rc2 — 실적 경계 기준일 (AS-IS ds.Tables[1]): BASIS_DATE / ISO_WEEK.
         *   당기(당월·당주) 버킷 헤더 강조의 기준. 비어 오면 화면이 오늘 날짜로 degrade 한다.
         */
        o_rc2: {
          BASIS_DATE: string;
          ISO_WEEK: string | number;
          [key: string]: string | number;
        };
      };
    };
    salesPlanWaterfall: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        projectCode: string;
        itemId: string;
        itemType: string;
        fromYyyymmdd: string;
        nowYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        plantSiteId: string;
        bizType: string;
        owner: string;
        internalYn: string;
        cellYn: string;
        versionType: string;
        bucket: string;
        userDeptId: string;
        groupId: string;
        userId: string;
        menuId: string;
      };
      response: {
        o_rc1: {
          VERSION_NO: string;
          MEASURE: string;
          [key: string]: string | number;
        };
        /**
         * o_rc2 — 실적 경계 기준일 (AS-IS ds.Tables[1]): BASIS_DATE / ISO_WEEK.
         *   당기(당월·당주) 버킷 헤더 강조의 기준. 비어 오면 화면이 오늘 날짜로 degrade 한다.
         */
        o_rc2: {
          BASIS_DATE: string;
          ISO_WEEK: string | number;
          [key: string]: string | number;
        };
      };
    };
    bizPlanWaterfall: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        projectCode: string;
        itemId: string;
        itemType: string;
        fromYyyymmdd: string;
        nowYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        plantSiteId: string;
        bizType: string;
        owner: string;
        versionType: string;
        cellYn: string;
        qtyYn: string;
        userId: string;
        menuId: string;
      };
      response: {
        o_rc1: {
          VERSION_NO: string;
          MEASURE: string;
          [key: string]: string | number;
        };
        /**
         * o_rc2 — 실적 경계 기준일 (AS-IS ds.Tables[1]): BASIS_DATE / ISO_WEEK.
         *   당기(당월·당주) 버킷 헤더 강조의 기준. 비어 오면 화면이 오늘 날짜로 degrade 한다.
         */
        o_rc2: {
          BASIS_DATE: string;
          ISO_WEEK: string | number;
          [key: string]: string | number;
        };
      };
    };
    mktFcstSpreadTitle: {
      request: {
        divisionId: string;
        bucket: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        userId: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string;
          COLUMN_WIDTH: string;
          VISIBLE_FLAG: string;
          HORIZONTAL_ALIGN_CODE: string;
          [key: string]: string | number;
        };
      };
    };
    salesPlanSpreadTitle: {
      request: {
        divisionId: string;
        bucket: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        userId: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string;
          COLUMN_WIDTH: string;
          VISIBLE_FLAG: string;
          HORIZONTAL_ALIGN_CODE: string;
          [key: string]: string | number;
        };
      };
    };
    bizPlanSpreadTitle: {
      request: {
        divisionId: string;
        bucket: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        userId: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string;
          COLUMN_WIDTH: string;
          VISIBLE_FLAG: string;
          HORIZONTAL_ALIGN_CODE: string;
          [key: string]: string | number;
        };
      };
    };
    version: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string;
        description: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          MONTHLY_ROLLING_FCST: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          /** 버전 기준일 (당주 판정 — SALES MRF 편집) */
          YYYYMMDD: string;
          /** 'Y' = 현재 ISO 주차 버전 (AS-IS "현재 주차만 수정가능") */
          EDITABLE: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    // [E20260922-VERMRF] SALES Version 모달 MRF 저장 — 'version' 시트 SAVE 버튼 배선
    //   PKG_DMF0035.P_DMF0035_SAVE_VERSION_MRF (4 IN + o_result_cursor). '^' 연결 값이라
    //   useProcMutation 이 아닌 apiClient.post call-proc 로 호출 (DMF0082 ExchangeRate SAVE 선례).
    // MKT/BIZ Version 모달 — PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP
    //   (versionNo = 설명 LIKE 검색어. 축 'MF_SF_*'/'BP_*' — SP 내부 분기. 2026-08-06 배선)
    versionWf: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string;
        versionNo: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          EDI_APPLY: string;
          VER_CRE_SEQ: string | number;
          YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * ForecastPrice — DMF0082
   *
   * SHEETS:
   * - `FcstNPrice` (메인 조회/저장 — Division 40/81계열/82. 82=조회 전용(V82-00). canonical PROC `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`)
   * - `spreadTitle`   (동적 컬럼 SP `DMF0082_GET_SPREAD_TITLE` — Two-pass 2차)
   *
   * PROC IN 이름은 S1.db.md §4 PKG-prefixed canonical 따름.
   */

  /**
   * Customer FCST Waterfall — DMF0053 (Read-only Report, 신규 생성 2026-08-27)
   *
   * AS-IS DMF0053_CustFcstWaterfall (Forms.UIL 1,822행) — Customer FCST vs EDI Waterfall.
   * SHEETS (전부 SEARCH — 저장 없음):
   * - `custFcstWaterfall` PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL (21 IN + O_RC1~3/O_RESULT_CURSOR)
   * - `spreadTitle`       PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE (7 IN — 동적 시간축)
   * Version 조회조건 미구현 (AS-IS btnVersion 숨김) — versionNo='' 고정.
   * PROC_M = _artifacts/_diagnostics/dmf0053_build_20260827/seed_meta.sql (positional 25/9 실측 등재)
   */
  DMF0053: {
    custFcstWaterfall: {
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수 — MSG00097)
        deptId: string; // 2  P_DEPT_ID (Team — 콤마, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        projectCode: string; // 5  P_PROJECT_CODE (텍스트 raw — 40 비활성 '')
        itemId: string; // 6  P_ITEM_ID
        itemType: string; // 7  P_ITEM_TYPE
        fromYyyymmdd: string; // 8  P_FROM_YYYYMMDD (Period*)
        toYyyymmdd: string; // 9  P_TO_YYYYMMDD
        sesUserId: string; // 10 P_CREATED_BY (BE 세션 주입)
        plantSiteId: string; // 11 P_PLANT_SITE_ID
        bizType: string; // 12 P_BIZ_TYPE
        owner: string; // 13 P_OWNER
        bucket: string; // 14 P_BUCKET (DAILY/WEEKLY/MONTHLY/ONLY_WEEKLY)
        userDeptId: string; // 15 P_USER_DEPT_ID (BODY 미사용 실측 — '' 전달)
        groupId: string; // 16 P_GROUP_ID (BODY 미사용 실측 — '' 전달)
        versionNo: string; // 17 P_VERSION_NO (Version 조회조건 미구현 — '' 고정)
        fromCreatedate: string; // 18 P_FROM_CREATEDATE (Input Date*)
        toCreatedate: string; // 19 P_TO_CREATEDATE
        userId: string; // 20 P_USER_ID
        mnuId: string; // 21 P_MENU_ID
      };
      response: {
        o_rc1: {
          MEASURE: string;
          MEASURE_GROUP: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        sesUserId: string; // 3 P_CREATED_BY (BE 주입)
        divisionId: string; // 4 P_DIVISION_ID
        bucket: string; // 5 P_BUCKET
        userId: string; // 6 P_USER_ID
        mnuId: string; // 7 P_MENU_ID
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * Sales Plan Waterfall — DMF0022 (Read-only Report)
   *
   * SHEETS:
   * - `salesPlanWaterfall` (메인 조회. canonical PROC `PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL`)
   * - `spreadTitle`        (동적 컬럼 SP `DMF0022_GET_SPREAD_TITLE` — Two-pass 2차. SCM_MST_SHEET_COLUMNS 미등록 — TODO §F6)
   *
   * PROC IN 이름은 S1.db.md §4 PKG-prefixed canonical 따름.
   */
  DMF0022: {
    salesPlanWaterfall: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        projectCode: string;
        itemId: string;
        itemType: string;
        fromYyyymmdd: string;
        nowYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        plantSiteId: string;
        bizType: string;
        owner: string;
        internalYn: string;
        cellYn: string;
        versionType: string;
        bucket: string;
        userDeptId: string;
        groupId: string;
        userId: string;
        menuId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DEPT_ID: string;
          END_CUSTOMER: string;
          END_CUSTOMER40: string;
          SCM_SITE_ID: string;
          CUST_GROUP: string;
          PROJECT_CODE: string;
          CUST_GROUP_DTL: string;
          OWNER: string;
          APPLICATION: string;
          ROUTE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          PROJECT_OWNER: string;
          BIZ_TYPE_NAME: string;
          BIZ_TYPE_NAME40: string;
          GROUP_ID: string;
          ITEM_ID: string;
          TEXT: string;
          ITEM_CLASS_NAME: string;
          ITEM_NAME: string;
          ITEM_TYPE: string;
          NICK_NAME: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          PLANT_SITE_ID: string;
          CELL_PROD_SITE_ID: string;
          CURRENCY: string;
          COMPANY_ID: string;
          VERSION_NO: string;
          MEASURE: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        divisionId: string;
        bucket: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        sesUserId: string;
        userId: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string;
          COLUMN_WIDTH: string;
          VISIBLE_FLAG: string;
          HORIZONTAL_ALIGN_CODE: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * ForecastPrice — DMF0082
   *
   * SHEETS:
   * - `FcstNPrice` (메인 조회/저장 — Division 40/81계열/82. 82=조회 전용(V82-00). canonical PROC `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`)
   * - `spreadTitle`   (동적 컬럼 SP `DMF0082_GET_SPREAD_TITLE` — Two-pass 2차)
   *
   * PROC IN 이름은 S1.db.md §4 PKG-prefixed canonical 따름.
   */
  DMF0082: {
    // Version 선택 POPUP — DMF0073_GET_VERSION_SALESPRICE 공유 계약 (VersionSelectModal). o_rc1 = 버전 목록.
    version: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string;
        description: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          MONTHLY_ROLLING_FCST: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    // Exchange Rate POPUP — DMF0082_POPUP_GET_FUTUREPRICE_INFO (ExchangeRateModal). o_rc1 = 환율 목록.
    futurePriceInfo: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          YYYYMMDD: string;
          YYYYMM: string;
          CURRENCY: string;
          UNIT_CURRENCY: string;
          EXCHANGE_PRICE: string | number;
          LAST_UPDATE_DATE: string; // [E20260915-EXLASTUPD] 'YYYY-MM-DD HH24:MI:SS'
          LAST_UPDATED_BY: string;
          [key: string]: string | number;
        };
      };
    };
    // Price 기간 일괄저장 조회 — DMF0082_POPUP_GET_..._SAVE_PRICE_POPUP (SavePricePeriodModal). data 커서.
    savePriceData: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        plantSiteId: string;
        projectCode: string;
        itemId: string;
        customerProjectCode: string;
        customerModel: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        biztype: string;
        sesUserId: string;
        userGroup: string;
        owner: string;
        overRange: string;
        invalidExec: string;
      };
      response: {
        data: {
          [key: string]: string | number;
        };
      };
    };
    // Price 기간 일괄저장 시간축/저장주차 — DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE (SavePricePeriodModal).
    savePriceTitle: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        sesUserId: string;
        divisionId: string;
      };
      response: {
        data: {
          [key: string]: string | number;
        };
      };
    };
    FcstNPrice: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        bizType: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        salesSite: string;
        plantSiteId: string;
        itemId: string;
        versionType: string;
        qtyYn: string;
        sesUserId: string;
        userGroup: string;
        // [UICATEGORY 2026-08-07] 조회조건 Project/Owner/SenderCode — PROC_M SORT_ORD 14~16 (DEFAULT 'ALL')
        projectCode: string;
        owner: string;
        senderCode: string;
      };
      response: {
        fcstNPrice: {
          DIVISION_ID: string;
          TEAM_ID: string;
          END_CUSTOMER: string;
          SOLDTO_CUSTOMER: string;
          COUNTRY_NAME: string;
          CITY_NAME: string;
          SCM_SITE_ID: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          NICK_NAME: string;
          INCOTERMS: string;
          ITEM_TYPE: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          CUST_GROUP: string;
          CUST_GROUP_DTL: string;
          OWNER: string;
          APPLICATION: string;
          ROUTE: string;
          MDM_PROJECT_NAME: string;
          MIN_CAPACITY: string;
          FORECAST_INFO_BIZ_TYPE: string;
          CELL_TYPE: string;
          FORECAST_INFO_CELL_MODEL: string;
          FORECAST_INFO_CELL_PACK_COUNT: string;
          FORECAST_INFO_ALL: string;
          FORECAST_INFO_SPEC: string;
          FORECAST_INFOR_VERSION: string;
          CELL_MODEL_NICK_NAME: string;
          VMI_YN: string;
          DMS_SALES: string;
          DMS_CUSTOMER: string;
          AS_FROM_SITE: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          SENDER_NAME: string;
          CELL_PROD_SITE_ID: string;
          CURRENCY: string;
          VERSION_NO: string;
          MEASURE_GROUP: string;
          BUCKET: string;
          EDIT_FLAG: string;
          SORT_KEY: string;
          MEASURE: string;
          [key: string]: string | number;
        };
        drop1: {
          MONTH_NAME: string;
          ISO_WEEK: string;
          [key: string]: string;
        };
        drop2: {
          THIS_YYYYMMWW: string;
          ISO_WEEK: string;
          [key: string]: string;
        };
        drop3: {
          MEASURE: string;
          EDIT_FLAG: string;
          [key: string]: string;
        };
        drop4: {
          YYYYMMDD: string;
          [key: string]: string;
        };
      };
    };
    spreadTitle: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        sesUserId: string;
        divisionId: string;
      };
      response: {
        o_rc: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string;
          [key: string]: string;
        };
      };
    };
    // 버튼 활성화 권한 — PKG_DMF0082.P_DMF0082_GET_BUTTON_AUTH (화면 오픈·Division 변경 시 1회).
    //   buttonAuth = 버튼 Y/N 1행 / measureAuth = 메저별 편집권한(= GET_MAIN_DATA drop3 와 동일 산출).
    buttonAuth: {
      request: {
        divisionId: string;
        sesUserId: string;
        userGroup: string;
      };
      response: {
        buttonAuth: {
          DIVISION_ID: string;
          INSERT_YN: string;
          DELETE_YN: string;
          SAVE_YN: string;
          PRICE_BATCH_YN: string;
          EXCEL_FORM_YN: string;
          EXCEL_UPLOAD_YN: string;
          EDIT_AUTH_YN: string;
          [key: string]: string;
        };
        measureAuth: {
          MEASURE: string;
          EDIT_AUTH_YN: string;
          TODAY_LIMIT_YN: string;
          TODAY_DAY_LIST: string;
          [key: string]: string;
        };
      };
    };
  };
  DMF0042: {
    'Biz Plan': {
      // DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA PROC_M(SORT_ORD 순 16 IN — sesUserId BE주입) 정확 일치
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수 — MSG00097)
        deptId: string; // 2  P_DEPT_ID (Team — 콤마 delim, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        projectCode: string; // 5  P_PROJECT_CODE (텍스트 raw — 40 비활성 '')
        itemId: string; // 6  P_ITEM_ID (Model/Nickname 텍스트 raw)
        itemType: string; // 7  P_ITEM_TYPE
        fromYyyymmdd: string; // 8  P_FROM_YYYYMMDD
        nowYyyymmdd: string; // 9  P_NOW_YYYYMMDD (⭐ 금주 월요일 — AS-IS GetThisWeekMonday)
        toYyyymmdd: string; // 10 P_TO_YYYYMMDD
        plantSiteId: string; // 12 P_PLANT_SITE_ID (40 비활성 'ALL')
        bizType: string; // 13 P_BIZTYPE
        userGroup: string; // 14 P_USERINFO (권한 그룹 — FE 필수 전달, lookup GET_ADMIN_GROUP)
        owner: string; // 15 P_OWNER (텍스트 raw)
        qtyYn: string; // 16 P_QTY_YN ('N' 고정 — AS-IS cboQty dead)
      };
      response: {
        // 커서 1 — 본문 (정적 63컬럼은 admin SHEET_COLUMNS 메타 주도 + 동적 Y_/Q_/M_ 기간 컬럼)
        data: {
          DIVISION_ID: string;
          DEPT_ID: string;
          DEPT_ID40: string;
          END_CUSTOMER: string;
          END_CUSTOMER40: string;
          SCM_SITE_ID40: string;
          SCM_SITE_ID81: string;
          SCM_SITE_ID82: string;
          PROJECT_CODE: string;
          PROJECT_CODE82: string;
          PROJECT_NAME: string;
          ITEM_ID: string;
          ITEM_ID40: string;
          NICK_NAME: string;
          INCOTERMS: string;
          INCOTERMS82: string;
          FCST_TYPE: string;
          CELL_PROD_SITE: string;
          CURRENCY: string;
          PLANT_SITE_ID: string;
          ITEM_USE: string;
          UNIT_ENERGY: string | number;
          EDIT_FLAG: string; // 행 편집권 ('Y' 만 편집 — GADM 아님)
          MEASURE: string;
          [key: string]: string | number; // + Y_/Q_/M_ 동적 기간 컬럼 + 정적 63
        };
        // 커서 2 — 40 편집 유효구간 (1행. 81/82 = lookup DM_LONG_PLAN 미등재 → NULL 반환 — FE NULL 방어.
        //   alias = SP L1084~1091 실측. YYYYQQ = 'yyyyq' 5자리 — REPLACE(CALENDAR_YYYYQQ,'Q',''))
        calendar: {
          VALID_YN: string;
          START_YYYYMM: string;
          END_YYYYMM: string;
          START_YYYYQQ: string;
          END_YYYYQQ: string;
          START_YYYY: string;
          END_YYYY: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // DMF0042_GET_SPREAD_TITLE PROC_M (sesUserId BE주입 — userId/mnuId FE 전달)
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        divisionId: string; // 4 P_DIVISION_ID
        userId: string; // 5 P_USER_ID
        mnuId: string; // 6 P_MENU_ID
      };
      response: {
        data: {
          COLUMN_NAME: string; // binding (Y_yyyy / Q_yyyy_q / M_yyyymm / B_* / 정적)
          COLUMN_LABEL_NAME: string; // leaf(3단) 라벨
          SMALL_CLASS_LABEL_NAME: string; // 2단 (분기)
          LARGE_CLASS_LABEL_NAME: string; // 1단 (연)
          SORT_ORDER_NO: string | number;
          FIXED_FLAG: string;
          VISIBLE_FLAG: string;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      // PR_GET_DAY_RANGE PROC_M 공유 (AS-IS GetDayRange p_month=7 — .cs L308)
      request: {
        createdBy: string; // 1 P_CREATED_BY (BE 세션 자동)
        month: string; // 2 P_MONTH (AS-IS 7 고정)
      };
      response: {
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
    titleSet: {
      // SCM0002_SET_TITLESET_POPUP 공유 계약 ('^' delim 다건 SAVE 는 apiClient.post 직접)
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        divisionId: string;
      };
      response: { o_rc1: { COLUMN_NAME: string; COLUMN_LABEL: string; [key: string]: string } };
    };
    futurePriceData: {
      // DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA (sesUserId BE주입 — cate='BP' 고정)
      request: {
        divisionId: string; // 1 P_DIVISION_ID ('ALL' 허용)
        fromYyyymmdd: string; // 2 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 3 P_TO_YYYYMMDD
        cate: string; // 5 P_CATE ('BP' — AS-IS LoadData)
        userId: string; // 6 P_USER_ID
        mnuId: string; // 7 P_MENU_ID
      };
      response: {
        data: {
          DIVISION_ID: string;
          CURRENCY: string;
          UNIT_CURRENCY: string;
          YYYYMMDD: string; // 'D'||yyyymmdd (SP L54 실측 — 'D' prefix)
          EXCHANGE_PRICE: string | number;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    cutoffVersion: {
      // DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION (versionType='BP_M' 고정)
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        yyyymmFrom: string; // 2 P_YYYYMM_FROM
        yyyymmTo: string; // 3 P_YYYYMM_TO
        versionType: string; // 4 P_VERSION_TYPE ('BP_M')
        userId: string; // 5 P_USER_ID
        mnuId: string; // 6 P_MENU_ID
      };
      response: {
        data: {
          DIVISION_ID: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          [key: string]: string | number;
        };
      };
    };
    mdfVersion: {
      // DMF0042_GET_DM_MDF_VERSION (sesUserId BE주입 — versionType='BP_M' 고정)
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        versionDescription: string; // 2 P_VERSION_DESCRIPTION (검색어 — 빈값 허용)
        versionType: string; // 3 P_VERSION_TYPE ('BP_M')
        fromYyyymmdd: string; // 4 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 5 P_TO_YYYYMMDD
        userId: string; // 7 P_USER_ID
        mnuId: string; // 8 P_MENU_ID
      };
      response: {
        // 커서 11컬럼 — 2026-08-25 응답 실측 (Ver. Cutoff · Replace 팝업이 같은 커서를 공유한다).
        //   그리드 표시 8종 = AS-IS VersionCutOffPopUp L190~198 / ReplaceByCutOffPopUp L173~182 1:1.
        //   CREATED_BY · CREATION_DATE · EDIT_YN 은 응답에만 있고 AS-IS 그리드에는 없다.
        data: {
          DIVISION_ID: string; // '40'
          VERSION_NO: string; // 'BP_M_20260814_V002'
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string; // 'BP_M'
          YYYYMMDD: string; // Cutoff Date — '20260814' (8자리 raw)
          VER_CRE_SEQ: number; // Ver Seq — 숫자
          LAST_UPDATED_BY: string; // Update By
          LAST_UPDATE_DATE: string; // Update Date — '2026-08-14 14:35:53'
          CREATED_BY: string;
          CREATION_DATE: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * Production Plan Line — SCP0013 (SCP 도메인 1호 화면, Phase A = Shell+메타)
   *
   * SHEETS:
   * - `Line` (메인 조회 — SP `SCP0013_GET_PRODUCTION_PLAN_LINEBY`, AS-IS 22 IN positional 1:1.
   *   ⚠️ 사내 Oracle SP 전원 INVALID(기계변환 초안) — T19 정식 변환 전까지 조회 비활성.
   *   차단 handoff: `_artifacts/_apply_corporate/A5_scp0013_phase0_sp_blocked_handoff.md`)
   *
   * request 키 = AS-IS .cs FindData_Main L2053~2074 파라미터 camelCase 1:1 (22개).
   * response = AS-IS 반환 DataSet 4테이블 1:1 (o_rc1 메인 wide-pivot / o_rc2 Fix / o_rc3 W ratio / o_rc4 M ratio).
   */
  SCP0013: {
    Line: {
      request: {
        divisionId: string;
        operationGroup: string;
        scmSiteId: string;
        lineId: string;
        modelId: string;
        itemId: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        planStartYyyymmdd: string;
        planType: string;
        seq: string;
        programId: string;
        sheetName: string;
        userId: string;
        electrodeType: string;
        nickName: string;
        cellTypeGr: string;
        lineAssign: string;
        bucket: string;
        chkAll: string;
        extraSpec: string;
        debugMode: string;
      };
      response: {
        // 메인 그리드 — measure 별 행 + D_/W_/M_/B_ wide-pivot 동적 컬럼 (AS-IS Tables[0]).
        o_rc1: {
          KEY_IDX: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          ORIGIN_DIVISION_ID: string;
          OPERATION_GROUP: string;
          OPERATION_GROUP_NAME: string;
          SCM_SITE_ID: string;
          SCM_SITE_DESCRIPTION: string;
          OPERATION_ID: string;
          LINE_ID: string;
          ITEM_ID: string;
          MODEL_ID: string;
          NICK_NAME: string;
          CELL_ID: string;
          EXTRA_SPEC: string;
          CELL_TYPE_GROUP_CODE: string;
          ELECTRODE_TYPE: string;
          MEASURE: string;
          MEASURE_NAME: string;
          UNIT: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          PLAN_START_YYYYMMDD: string;
          PLAN_TYPE: string;
          PLAN_SEQ: string;
          CP_KEY: string;
          FIX_KEY: string;
          [key: string]: string | number;
        };
        // Fix 정보 (AS-IS Tables[1] — Set_FixCellColor 입력).
        o_rc2: {
          FIX_KEY: string;
          [key: string]: string | number;
        };
        // WEEKLY Ratio (AS-IS Tables[2] — LINE_TOTAL_LOAD W_ 덮어쓰기).
        o_rc3: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          OPERATION_ID: string;
          LINE_ID: string;
          MEASURE: string;
          [key: string]: string | number;
        };
        // MONTHLY Ratio (AS-IS Tables[3] — LINE_TOTAL_LOAD M_ 덮어쓰기).
        o_rc4: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          OPERATION_ID: string;
          LINE_ID: string;
          MEASURE: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * MetalLinkPrice — DMF0074 (Metal Link Price · 메탈 판가 연동)
   *
   * 사내 Oracle PKG_DMF0074 ALL_ARGUMENTS 실측 (2026-07-10 — hook #105 분석 산출물 d74_realdata).
   * SHEETS:
   * - `Metal Link Price` (메인 — Base 16 + 메탈 6그룹×7원소 42 + EDIT_YN. 조회전용 —
   *                       SHT_NM = SCM_ADM_EXCEL_COLUMNS 기존 등록명 그대로 — excel-upload 체인 키)
   * - `template`         (Excel Form 템플릿 조회 — P_DMF0074_GET_METAL_LINK_TEMPLATE, division-gate 동일)
   * - `version`          (DMF0073_GET_VERSION_SALESPRICE 공유 — DMF0020 version 시트와 동일 계약)
   * 저장 = Excel Upload 스테이징 단일 경로(P_DMF0074_EXCEL_UPLOAD — FileController excel-upload 체인) — 타입 미등재.
   * 편집제어 = 단일 division-gate (SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN — 행 하드필터 + EDIT_YN).
   */
  DMF0074: {
    'Metal Link Price': {
      // PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE PROC_M(SORT_ORD 1~12 IN) 정확 일치
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수 — MSG00097)
        deptId: string; // 2  P_DEPT_ID (Team — 콤마 delim, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        plantSiteId: string; // 5  P_PLANT_SITE_ID (81* 전용 — 82/40 '')
        projectCode: string; // 6  P_PROJECT_CODE (텍스트 raw — 40 비활성 '')
        itemId: string; // 7  P_ITEM_ID (Model/Nickname 텍스트 raw)
        fromYyyymmdd: string; // 8  P_FROM_YYYYMMDD (YYYYMM — 월 범위, 기본 당월)
        toYyyymmdd: string; // 9  P_TO_YYYYMMDD (YYYYMM — 기본 +6개월)
        versionType: string; // 10 P_VERSION_TYPE ('Current' 또는 버전NO 콤마 최대 2 — MSG00283/00255)
        sesUserId: string; // 11 P_USER_ID (BE 세션 자동 — division-gate 키)
        mnuId: string; // 12 P_MENU_ID (BE 메뉴 자동 — division-gate 키)
      };
      response: {
        // O_RC1 — Base 16 + 메탈 42(6그룹×Ni/Co/Li2CO3/LIOH/Al/Mn/Cu suffix 1~7) + EDIT_YN
        o_rc1: {
          DIVISION_ID: string;
          PLAN_YYYYMM: string;
          DEPT_ID: string; // hidden (width 0)
          DEPT_NAME: string;
          END_CUSTOMER: string;
          PROJECT_CODE: string; // DIVISION_ID 토큰에 40 없음 — 소형 미표시
          PROJECT_NAME: string;
          PLANT_SITE_ID: string; // hidden
          ITEM_ID: string;
          METAL_LINK_YN: string;
          SCM_SITE_ID: string;
          CURRENCY: string;
          FCST_TYPE_CODE: string; // hidden
          FCST_TYPE: string;
          METAL_EXCEPTION_YN: string;
          ENERGY: string | number;
          EDIT_YN: string; // 단일 division-gate 프로젝션 (그리드 셀 편집에 사용 금지 — 조회전용)
          [key: string]: string | number; // APPLY_PRICE_TYPE_CODE1~7 / FROM_PERIOD1~7 / TO_PERIOD1~7 / CONTRACT_UNIT1~7 / METAL_APPLY1~7 / METAL_REQR1~7
        };
      };
    };
    template: {
      // PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE PROC_M (1 IN + 세션 2 + o_rc1/O_RESULT)
      request: {
        divisionId: string; // 1 P_DIVISION_ID (부모 화면 division 고정 전달)
        sesUserId: string; // 2 P_USER_ID (BE 세션 자동)
        mnuId: string; // 3 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // O_RC1 — 업로드 대상 조합 (measure 열 '-' placeholder) + EDIT_YN. 0건 = MRF:Y 버전 부재 MSG
        o_rc1: {
          DIVISION_ID: string;
          PLAN_YYYYMM: string;
          DEPT_NAME: string;
          END_CUSTOMER: string;
          ITEM_ID: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    version: {
      // DMF0073_GET_VERSION_SALESPRICE PROC_M 공유 (DMF0020 version 시트와 동일 9-arg 계약)
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string; // AS-IS DMF0074 btnSPVer = 'SP' 고정
        description: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          EDI_APPLY: string;
          VER_CRE_SEQ: string | number;
          YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          MONTHLY_ROLLING_FCST: string;
          EDITABLE: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * MktFcst — DMF0003 (MKT FCST / 시장예측)
   *
   * ⭐ Phase 2a: 사내 Oracle SP 시그니처/PROC_M 실측 반영 (2026-06-28, ora.py 검증).
   * SHEETS:
   * - `Mkt Fcst`     (메인 조회 — PIVOT wide format. SHEETS.MAIN value 등록명. SP `DMF0003_GET_MKT_FCST_DATA`
   *                   = 22 IN(camelCase) + O_RC1/O_RC2/O_RC3/O_RESULT_CURSOR. PROC_M 26 row 일치)
   * - `spreadTitle`  (동적 컬럼 SP `DMF0003_GET_SPREAD_TITLE` = 6 IN + O_RC1 — 기간 PIVOT 헤더 메타)
   * - `measureCount` (Insert 시 measure 행 개수 — admin SHEET_MEASURE 동적)
   *
   * sesUserId(P_USER_ID) / mnuId(P_MENU_ID) / createdBy(P_CREATED_BY) / userGroup(P_USER_GROUP)
   * 는 BE makeProcedure 가 세션·메뉴 컨텍스트로 자동 채움 (PROC_M COL_NM 매칭).
   * ⚠️ SP 에 bucketType(Bucket) IN 파라미터 없음 — Bucket(M/W/D) 은 FE 측 PIVOT 표시 분기 전용.
   */
  DMF0003: {
    'Mkt Fcst': {
      // DMF0003_GET_MKT_FCST_DATA PROC_M(SORT_ORD 1~22) IN 파라미터와 정확히 일치 (camelCase).
      request: {
        divisionId: string; // 1  P_DIVISION_ID
        scmSiteId: string; // 2  P_SCM_SITE_ID (Sales Site)
        plantSiteId: string; // 3  P_PLANT_SITE_ID
        teamId: string; // 4  P_TEAM_ID
        customer: string; // 5  P_CUSTOMER (End Customer)
        bizType: string; // 6  P_BIZ_TYPE
        projectCode: string; // 7  P_PROJECT_CODE
        itemId: string; // 8  P_ITEM_ID
        fromYyyymmdd: string; // 9  P_FROM_YYYYMMDD
        toYyyymmdd: string; // 10 P_TO_YYYYMMDD
        createdBy: string; // 11 P_CREATED_BY (BE 세션 자동)
        userGroup: string; // 12 P_USER_GROUP (BE 세션 자동)
        itemType: string; // 13 P_ITEM_TYPE
        owner: string; // 14 P_OWNER
        qtyYn: string; // 15 P_QTY_YN (Qty ≥ 0)
        cellYn: string; // 16 P_CELL_YN (Cell Qty)
        invalidExec: string; // 17 P_INVALID_EXEC (New Model Flag)
        asYn: string; // 18 P_AS_YN
        userDeptId: string; // 19 P_USER_DEPT_ID
        senderCode: string; // 20 P_SENDER_CODE
        sesUserId: string; // 21 P_USER_ID (BE 세션 자동)
        mnuId: string; // 22 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // wide format (고정 컬럼 + 동적 PIVOT M_/W_/D_ 컬럼). O_RC1 = 메인 데이터셋.
        //   O_RC2(8주 bucket) / O_RC3(현재 주차) = Phase 2b(편집 matrix) 입력.
        o_rc1: {
          DIVISION_ID: string;
          END_CUSTOMER: string;
          SCM_SITE_ID: string;
          ITEM_ID: string;
          NICK_NAME: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          ITEM_TYPE: string;
          MEASURE: string;
          MEASURE_GROUP: string;
          // 행 단위 편집 권한 ('Y'/'N') — 'N' = 데이터 컬럼 전체 잠금 (보강스펙 §1 Row 비대칭).
          EDIT_FLAG: string;
          // 7자리 요일 플래그('0000000') — 주→일 분배(Phase 2c) 입력. 본 단계 미사용.
          BUCKET: string;
          [key: string]: string | number;
        };
        // O_RC2 — SCM_SYS_CALENDAR_M 의 "7주 후 주(SYSDATE+49d)" 단일 row (SELECT *).
        //   BASIS_YYYYMM = Division 40 Monthly 8주차 잠금 cutoff 월 (보강스펙 §5, SP L4277~4283).
        o_rc2: {
          BASIS_YYYYMMDD: string;
          BASIS_YYYYMM: string;
          ISO_YYYYWW: string;
          ISO_WEEK: string;
          MONTH_NAME: string;
          CALENDAR_YYYY: string;
          [key: string]: string | number;
        };
        // O_RC3 — 현재/전주 정보 (SP L4290~4302).
        o_rc3: {
          THIS_YYYYMM: string; // 'M_'||BASIS_YYYYMM (현재 월 컬럼 binding)
          THIS_YYYYMMWW: string; // 'W_'||BASIS_YYYYMM||ISO_WEEK (현재 주 컬럼 binding)
          BASIS_DATE: string;
          PRE_YYYYMM: string; // 'M_'||전주 BASIS_YYYYMM
          PRE_YYYYMMWW: string; // 'W_'||전주 binding
          BASIS_YYYYMM: string; // 현재 월 (yyyymm)
          ISO_WEEK: string; // 현재 ISO 주차
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // DMF0003_GET_SPREAD_TITLE PROC_M IN 파라미터 (6 IN). createdBy/userGroup 은 BE 세션 자동.
      //   ⚠️ SP body L86~123: 동적 기간컬럼 = D_yyyymmdd / W_yyyymm+ISO_WEEK / M_yyyymm.
      //   type='LOAD'|'COLUMN' (기본 'COLUMN') — 첫 LOAD 시 AS_FROM_SITE 컬럼 자동추가 분기.
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        createdBy: string; // 3 P_CREATED_BY (BE 세션 자동)
        divisionId: string; // 4 P_DIVISION_ID
        userGroup: string; // 5 P_USER_GROUP (BE 세션 자동)
        type: string; // 6 P_TYPE ('COLUMN' | 'LOAD')
      };
      response: {
        // O_RC1 — SCM_MST_SHEET_COLUMNS + SCM_SYS_CALENDAR_M UNION (정적 컬럼 + 기간 컬럼).
        o_rc1: {
          PROGRAM_ID: string;
          SHEET_NAME: string;
          COLUMN_NAME: string; // binding (M_yyyymm / W_yyyymmISO / D_yyyymmdd / 정적컬럼명)
          COLUMN_LABEL_NAME: string; // leaf header (일=CALENDAR_DAY)
          SORT_ORDER_NO: string;
          SMALL_CLASS_LABEL_NAME: string; // 2단 header (주차 WEEK_NAME)
          LARGE_CLASS_LABEL_NAME: string; // 1단 header (대상 MONTH_NAME)
          DAY_CODE: string; // 요일 (DAYOFWEEK)
          COLUMN_WIDTH: string | number;
          CELL_CONTROL_OBJECT_TYPE_CODE: string; // 'FPNumber' 등
          HORIZONTAL_ALIGN_CODE: string; // 'R' (기간컬럼)
          VISIBLE_FLAG: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
      };
    };
    measureCount: {
      request: Record<string, string>;
      response: { o_rc1: { [key: string]: string | number } };
    };
    // ⭐ Phase 2e POPUP — DMF0003 내부 sheet 확장 (자매 titleSet sheet 표준 동일).
    //   BTN_MPG(MNU_ID='DMF0003' + SHT_NM + SEARCH/SAVE) → API_M → PROC_M 은 corp handoff
    //   `_artifacts/_apply_corporate/37_dmf0003_popup_metadata_handoff.sql` (적용 보류).
    //   request key = PROC_M COL_NM(camelCase) positional, response = SP O_RC alias 실측.
    //
    // sspCompare — SSP↔MKT 동기화 비교 (DMF0003_GET_MKT_FCST_COMPARE_POPUP, 8 IN + O_RC1).
    //   트리거: 메인 grid CellDblClick (Div40 & MEASURE='MKT_FCST_RP' & 동기화색[ATTR1 A/P]) (.cs L2628~2683).
    //   ⚠️ 배포본 시그니처 = O_RC1 단일 (USER_ARGUMENTS 9 args 실측, 2026-06-28).
    sspCompare: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        scmSiteId: string; // 2 P_SCM_SITE_ID
        projectCode: string; // 3 P_PROJECT_CODE (End Customer40)
        itemId: string; // 4 P_ITEM_ID
        domExp: string; // 5 P_DOM_EXP
        fcstType: string; // 6 P_FCST_TYPE
        incoterms: string; // 7 P_INCOTERMS
        yyyymmdd: string; // 8 P_YYYYMMDD
      };
      response: {
        // O_RC1 — 비교 grid (SP body L100~106 실측 alias).
        o_rc1: {
          DIVISION_ID: string;
          PROJECT_CODE: string; // End Customer
          SCM_SITE_ID: string; // Sales Site
          ITEM_ID: string; // Model
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string; // Customs Handbook
          YYYYMMDD: string;
          CATEGORY: string; // Measure ('Non-Sync MKT Fcst'/'Sync'/'Carry Over')
          CONFIRM_ID: string;
          SO_NO: string;
          PLAN_QTY: string | number; // Qty
          RESULT_QTY: string | number; // Shipment Result Qty
          [key: string]: string | number;
        };
      };
    };
    // prPopup — PR 발행/조회 (DMF0003_GET_PRPOPUP 14 IN + O_RC1 DETAIL / O_RC2 HEADER / O_RC3 ERR_MSG).
    //   트리거: 메인 grid 우클릭 contextMenu Request_PR(.cs L5689)/View_PR(L5746)/Add_History.
    //   SAVE: DMF0003_SAVE_PRPOPUP (별 sheet btn 'SAVE'). popupType/^delim 다건.
    prPopup: {
      request: {
        popupType: string; // 1 P_POPUP_TYPE (Request_PR/View_PR/Add_History/View_History)
        requestNo: string; // 2 P_REQUEST_NO
        divisionId: string; // 3 P_DIVISION_ID
        projectCode: string; // 4 P_PROJECT_CODE
        scmSiteId: string; // 5 P_SCM_SITE_ID (^delim 다건)
        itemId: string; // 6 P_ITEM_ID (^delim 다건)
        domExp: string; // 7 P_DOM_EXP
        fcstType: string; // 8 P_FCST_TYPE
        incoterms: string; // 9 P_INCOTERMS
        plantSiteId: string; // 10 P_PLANT_SITE_ID
        yyyymmdd: string; // 11 P_YYYYMMDD (^delim 다건)
        planQty: string; // 12 P_PLAN_QTY (^delim 다건)
      };
      response: {
        // O_RC1 — DETAIL grid (SP body L183~ 실측 alias, NextSCM migration L22).
        o_rc1: {
          ITEM_SEQ: string | number;
          STORAGE_PLANT_ID: string;
          YYYYMMDD: string;
          PROJECT_CODE: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          ITEM_UOM: string;
          QTY: string | number;
          SCM_SITE_ID: string;
          SLOC: string;
          ITEM_DETAIL: string;
          [key: string]: string | number;
        };
        // O_RC2 — HEADER (REQUEST_NO/DIVISION_NAME/PUCH_MGR/PUCH_GROUP/REQUESTED_BY/REQUEST_DATE/PR_HEADER).
        o_rc2: {
          REQUEST_NO: string;
          DIVISION_NAME: string;
          PUCH_MGR: string;
          PUCH_GROUP: string;
          REQUESTED_BY: string;
          REQUEST_DATE: string;
          PR_HEADER: string;
          [key: string]: string | number;
        };
        // O_RC3 — ERR_MSG (단일 row, 비어있으면 정상).
        o_rc3: { ERR_MSG: string; [key: string]: string | number };
      };
    };
    // prHistory — PR 이력 조회 (DMF0003_GET_PR_HISTORY_POPUP 13 IN + O_RC1 grid / O_RC2 header).
    //   트리거: 메인 grid 우클릭 contextMenu View_History (.cs L5739, BNPIn measure + D_ 컬럼 단일 셀).
    prHistory: {
      request: {
        popupType: string; // 1 P_POPUP_TYPE (View_History)
        divisionId: string; // 2 P_DIVISION_ID
        requestNo: string; // 3 P_REQUEST_NO
        projectCode: string; // 4 P_PROJECT_CODE
        scmSiteId: string; // 5 P_SCM_SITE_ID
        itemId: string; // 6 P_ITEM_ID
        domExp: string; // 7 P_DOM_EXP
        fcstType: string; // 8 P_FCST_TYPE
        incoterms: string; // 9 P_INCOTERMS
        plantSiteId: string; // 10 P_PLANT_SITE_ID
        yyyymmdd: string; // 11 P_YYYYMMDD
        planQty: string; // 12 P_PLAN_QTY
      };
      response: {
        // O_RC1 — 이력 grid (SP body L64~67 실측 alias).
        o_rc1: {
          REQUEST_NO: string;
          REQUEST_DATE: string;
          REQUESTED_BY: string;
          ITEM_QTY: string | number; // Qty
          ITEM_DETAIL: string;
          PR_HEADER: string;
          PROJECT_CODE: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          YYYYMMDD: string;
          [key: string]: string | number;
        };
        // O_RC2 — header (PR_HEADER/PROJECT_CODE/ITEM_ID/ITEM_NAME/YYYYMMDD).
        o_rc2: {
          PR_HEADER: string;
          PROJECT_CODE: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          YYYYMMDD: string;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      // PR_GET_DAY_RANGE PROC_M (2 IN + o_rc1/o_rc2) — 기본 조회구간 (AS-IS GetDayRange p_month=6).
      request: {
        createdBy: string; // 1 P_CREATED_BY (BE 세션 자동)
        month: string; // 2 P_MONTH (AS-IS 6 고정 — "7개월에서 6개월로 변경" .cs L994)
      };
      response: {
        // o_rc1 = ISO 주 정렬 범위 (AS-IS Tables[0], 미사용) / o_rc2 = 월 경계 범위 (AS-IS Tables[1] 사용분)
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
  };
  /**
   * CustomerFcstUpload — DMF0014 (Customer FCST Upload)
   *
   * 사내 Oracle PKG_DMF0014 ALL_ARGUMENTS 실측 (2026-07-04 —
   * _deploy_packages/DMF0014_CUST_FCST_UPLOAD_20260704/04_VERIFY/001_all_arguments.txt).
   * SHEETS:
   * - `FCST Upload`  (메인 — 식별 13 + EDIT_FLAG/EDIT_YN + 동적 D_ 기간 컬럼.
   *                   SHT_NM = SCM_ADM_EXCEL_COLUMNS 기존 등록명 그대로 — excel-upload 체인 키)
   * - `spreadTitle`  (동적 기간 헤더 — 전 버킷 D_ 접두: WEEKLY=주 시작일 / MONTHLY=월 시작일)
   * - `dayRange`     (PR_GET_DAY_RANGE 재사용 — DMF0048 dayRange 와 동일 계약)
   * SAVE(P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA 17 IN '^'delim)는 apiClient.post 직접 — 타입 미등재.
   */
  DMF0014: {
    'FCST Upload': {
      // PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA PROC_M(SORT_ORD 1~15 IN) 정확 일치
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수)
        deptId: string; // 2  P_DEPT_ID (Team — 콤마 delim, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        plantSiteId: string; // 5  P_PLANT_SITE_ID
        projectCode: string; // 6  P_PROJECT_CODE (텍스트 raw — 빈값 '')
        itemId: string; // 7  P_ITEM_ID (Model/Nickname 텍스트 raw)
        startYyyymmdd: string; // 8  P_START_YYYYMMDD
        endYyyymmdd: string; // 9  P_END_YYYYMMDD
        bucketType: string; // 10 P_BUCKET_TYPE ('DAILY'/'WEEKLY'/'MONTHLY' full-word)
        domExp: string; // 11 P_DOM_EXP (Customs Handbook)
        createdBy: string; // 12 P_CREATED_BY (BE 세션 자동)
        userinfo: string; // 13 P_USERINFO (AS-IS NowGroupID)
        sesUserId: string; // 14 P_USER_ID (BE 세션 자동)
        mnuId: string; // 15 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // O_RC1 — 식별 13 + EDIT_FLAG/EDIT_YN + 동적 D_ 기간 컬럼 (스모크 실측 15 cols)
        o_rc1: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          PLANT_SITE_ID: string;
          CUSTOMER_PROJECT_CODE: string;
          CUSTOMER_MODEL: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          MEASURE_GROUP: string;
          MEASURE: string;
          UPLOAD_UOM: string;
          PROJECT_CODE: string;
          ITEM_ID: string;
          EDIT_FLAG: string; // 'Y' = 기간 셀 편집 가능 행 (AS-IS EditButton 판정 1:1)
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE PROC_M (3 IN + 세션 2 + o_rc1)
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        bucketType: string; // 3 P_BUCKET_TYPE (full-word — 'W'/'M' 은 커서 미오픈, DPY-4025)
        sesUserId: string; // 4 P_USER_ID (BE 세션 자동)
        mnuId: string; // 5 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // O_RC1 — 스모크 실측: DAILY 184 / WEEKLY 27 / MONTHLY 6 행 (20260701~20261231)
        o_rc1: {
          COLUMN_NAME: string; // 'D_yyyymmdd' (전 버킷 D_ 접두 — WEEKLY=주 시작일)
          COLUMN_LABEL: string; // 'yyyymmdd'
          SMALL_LABEL_NAME: string; // 상단 그룹 라벨 (요일 / Wnn / yyyy-mm)
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      // PR_GET_DAY_RANGE PROC_M 재사용 (DMF0048 배선분 — DELETE+INSERT 금지 정책)
      request: {
        createdBy: string; // 1 P_CREATED_BY (BE 세션 자동)
        month: string; // 2 P_MONTH (AS-IS GetDayRange p_month=6 — .cs L1237)
      };
      response: {
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
  };

  /**
   * CustPsiUpload — DMF0013 (Customer PSI Upload)
   *
   * DMF0014(CustomerFcstUpload)를 복제·파생한 화면 — MeasureGroup 고정값만 "PSI" 로 분기
   * (AS-IS DMF0013_CustPsiUpload.cs 헤더 주석이 "DMF0014_CustFcstUpload" 로 남음, 원장 §0.3).
   * 타입 형상(request/response)은 DMF0014 와 동일하다 — SP 는 DMF0013 계열(직접 GET/SAVE)이나
   * PROC_M ALL_ARGUMENTS 가 이 FE 저장소에 없어(seed 만, 원장 §7.3-1) DMF0014 실측 형상을 승계한다.
   * SHEETS:
   * - `PSI Upload`  (메인 — AS-IS SheetView "PSI Upload" 등록명 그대로. excel-upload 체인 키)
   * - `spreadTitle` (동적 기간 헤더 — 공유 SP DM.DMF0014_GET_SPREAD_TITLE 재사용, 원장 §6.1)
   * - `dayRange`    (PR_GET_DAY_RANGE 재사용 — DMF0014/DMF0048 와 동일 계약)
   * SAVE(P_DMF0013_SAVE_CUST_PSI_UPLOAD_DATA 17 IN '^'delim)는 apiClient.post 직접 — 타입 미등재.
   */
  DMF0013: {
    'PSI Upload': {
      // DM.DMF0013_GET_CUST_PSI_UPLOAD_DATA (13 IN + 세션 2 — DMF0014 형상 승계, 원장 §E10 L435~448)
      request: {
        divisionId: string; // 1  P_DIVISION_ID (단일 필수)
        deptId: string; // 2  P_DEPT_ID (Team — 콤마 delim, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        plantSiteId: string; // 5  P_PLANT_SITE_ID
        projectCode: string; // 6  P_PROJECT_CODE (텍스트 raw — 빈값 '')
        itemId: string; // 7  P_ITEM_ID (Model 텍스트 raw)
        startYyyymmdd: string; // 8  P_START_YYYYMMDD
        endYyyymmdd: string; // 9  P_END_YYYYMMDD
        bucketType: string; // 10 P_BUCKET_TYPE ('DAILY'/'WEEKLY'/'MONTHLY' full-word)
        domExp: string; // 11 P_DOM_EXP (Customs Handbook)
        createdBy: string; // 12 P_CREATED_BY (BE 세션 자동)
        userinfo: string; // 13 P_USERINFO (AS-IS NowGroupID)
        sesUserId: string; // 14 P_USER_ID (BE 세션 자동)
        mnuId: string; // 15 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // O_RC1 — 식별 14 (DIVISION_ID~EDIT_FLAG) + 동적 D_ 기간 컬럼 (원장 §3.1).
        //   EDIT_YN 유무(14 vs 15열)는 admin SHEET_COLUMNS 실측 필요(원장 §5-4) — 승계로 함께 선언.
        o_rc1: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          PLANT_SITE_ID: string;
          CUSTOMER_PROJECT_CODE: string;
          CUSTOMER_MODEL: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          MEASURE_GROUP: string; // 이 화면 고정값 "PSI" (AS-IS InsertRow L631)
          MEASURE: string;
          UPLOAD_UOM: string;
          PROJECT_CODE: string;
          ITEM_ID: string;
          EDIT_FLAG: string; // 'Y' = 기간 셀 편집 가능 행 (AS-IS EditButton 판정 1:1)
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // 공유 SP DM.DMF0014_GET_SPREAD_TITLE (3 IN + 세션 2 + o_rc1) — DMF0013 이 그대로 재사용(원장 §6.1)
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        bucketType: string; // 3 P_BUCKET_TYPE (full-word)
        sesUserId: string; // 4 P_USER_ID (BE 세션 자동)
        mnuId: string; // 5 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // 'D_yyyymmdd' (전 버킷 D_ 접두)
          COLUMN_LABEL: string; // 'yyyymmdd'
          SMALL_LABEL_NAME: string; // 상단 그룹 라벨 (요일 / Wnn / yyyy-mm)
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      // PR_GET_DAY_RANGE PROC_M 재사용 (AS-IS GetDayRange p_month=6 — 원장 §6.1)
      request: {
        createdBy: string; // 1 P_CREATED_BY (BE 세션 자동)
        month: string; // 2 P_MONTH (AS-IS p_month=6)
      };
      response: {
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
  };
  /**
   * message
   */
  SYS0001: {
    msgMgmt: {
      request: {
        messageType: string;
        message: string;
        useYn: string;
      };
      response: {
        o_rc: {
          MSG_ID: string;
          MSG_NM_KO: string;
          MSG_NM_EN: string;
          MSG_NM_CN: string;
          MSG_TP_CD: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  /**
   * user
   */
  SYS0002: {
    userMgmt: {
      request: {
        user: string;
        department: string;
        group: string;
        useYn: string;
      };
      response: {
        o_rc: {
          USER_ID: string;
          USER_NM: string;
          USER_ENG_NM: string;
          USER_POP_BTN: string;
          USER_EML: string;
          DEPT_ID: string;
          DEPT_NM: string;
          DEPT_POP_BTN: string;
          USER_HPHN: string;
          LANG_CD: string;
          TMZ_CD: string;
          LOGN_DTM: string;
          ACNT_LOK_YN: string;
          PERM_KEP_CNC_YN: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  /**
   * group
   */
  SYS0007: {
    groupMgmt: {
      request: {
        group: string;
        useYn: string;
      };
      response: {
        o_rc: {
          USER_GR_ID: string;
          USER_GR_NM: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  /**
   * menu
   */
  SYS0003: {
    levelOneMenu: {
      request: {};
      response: {
        o_rc: {
          MNU_ID: string;
          MNU_MSG_ID: string;
          MNU_MSG_NM: string;
          MNU_DESC: string;
          MNU_URL: string;
          ROUTE_PATH: string;
          SORT_ORD: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
    levelTwoMenu: {
      request: {
        menuId: string;
      };
      response: {
        o_rc: {
          LEVEL_ONE_MNU_ID: string;
          MNU_ID: string;
          MNU_MSG_ID: string;
          MNU_MSG_NM: string;
          MNU_DESC: string;
          MNU_URL: string;
          SORT_ORD: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
    levelThreeMenu: {
      request: {
        menuId: string;
      };
      response: {
        o_rc: {
          LEVEL_ONE_MNU_ID: string;
          LEVEL_TWO_MNU_ID: string;
          MNU_ID: string;
          MNU_MSG_ID: string;
          MNU_MSG_NM: string;
          MNU_DESC: string;
          MNU_URL: string;
          MNU_TP_CD: string;
          UNIT_TP_CD: string;
          SORT_ORD: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  /**
   * group-menu
   */
  SYS0008: {
    group: {
      request: {};
      response: {
        o_rc: {
          USER_GR_ID: string;
          USER_GR_NM: string;
        };
      };
    }
    menu: {
      request: {
        groupId: string;
      };
      response: {
        o_rc: {
          USER_GR_ID: string;
          LEVEL_ONE_MENU_ID: string;
          LEVEL_ONE_MENU_MSG_NM: string;
          LEVEL_TWO_MENU_ID: string;
          LEVEL_TWO_MENU_MSG_NM: string;
          MNU_ID: string;
          MNU_MSG_NM: string;
          MNU_AUTH_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
    button: {
      request: {
        groupId: string;
        menuId: string;
      };
      response: {
        o_rc: {
          user_GR_ID: string;
          MNU_ID: string;
          MNU_MSG_NM: string;
          SHT_NM: string;
          MNU_BTN_CD: string;
          BTN_AUTH_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  /**
   * uicategory
   */
  SYS0004: {
    [sheets in 'column'|'measure']: {
      request: {
        programId: string;
        sheetName: string;
        columnName: string;
        columnLabelName: string;
        valid: string;
      };
      response: {
        column: {
          PROGRAM_ID: string;
          PROGRAM_NAME: string;
          SHEET_NAME: string;
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SORT_ORDER_NO: string;
          DATA_SORT_METHOD_CODE: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          FIXED_FLAG: string;
          COLUMN_WIDTH: string;
          CELL_CONTROL_OBJECT_TYPE_CODE: string;
          CELL_COMBO_DATA_TYPE: string;
          DATA_SCALE_NUMBER: string;
          DATA_MAX_LENGTH: string;
          HORIZONTAL_ALIGN_CODE: string;
          UPPERCASE_APPLY_FLAG: string;
          VISIBLE_FLAG: string;
          DEFAULT_FLAG: string;
          VALID_YN: string;
          USER_SELECTABLE_FLAG: string;
          INPUT_TP_CD: string;
          DIVISION_ID: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          ATTRIBUTE3: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
        measure: {
          PROGRAM_ID: string;
          PROGRAM_NAME: string;
          SHEET_NAME: string;
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SORT_ORDER_NO: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          UPPERCASE_APPLY_FLAG: string;
          VALID_YN: string;
          USER_SELECTABLE_FLAG: string;
          INPUT_TP_CD: string;
          DIVISION_ID: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          MEASURE_COLOR: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  };
  
  SYS0005: { // Procedure Setting list
    procList: {
      request: {
        schema?: string;
        procedure?: string;
      };
      response: {
        o_rc: {
          OWNER?: string;
          PROC_NM: string;
        };
      };
    }
    procInfo:{
      request: {
        OWNER?: string;
        PROC_NM: string;
        isYn?: string;
      };
      response: {
        o_rc: {
          PROC_NM: string;
          PROC_NM_KEY: string;
          OWNER: string;
          COL_NM: string;
          DATA_TP_CD: string;
          COL_TP_CD: string;
          SORT_ORD: number;
          IS_YN: string;
        };
      };
    }
  };
  /**
   * SCM0016 Batch Log (Admin > System) — 조회 전용(read-only) 3그리드.
   *   batchLog: Run Status(runStatus) 로 배치 잡 목록(Main).
   *   stepInfo / batchLogHist: Main 행 더블클릭 시 그 JOB_ID(=JOB_NAME)로 재조회(master→detail).
   * 데이터원 = Oracle DBMS_SCHEDULER 뷰(PKG_SCM0016). sesUserId/mnuId 는 BE 세션 주입.
   */
  SCM0016: {
    batchLog: {
      request: {
        runStatus?: string;
      };
      response: {
        batchLog: {
          JOB_ID: string;
          JOB_NAME: string;
          JOB_DESCRIPTION: string;
          STEP_ID: string;
          STEP_NAME: string;
          SCHEDULE_UID: string;
          SCHEDULE_NAME: string;
          RUN_DATE: string;
          RUN_STATUS: string;
          RUN_STATUS_NAME: string;
          RUN_DURATION: string;
          RUN_STATUS_MESSAGE: string;
          NEXT_RUN_DATE: string;
        };
      };
    }
    stepInfo: {
      request: {
        jobId: string;
      };
      response: {
        stepInfo: {
          JOB_ID: string;
          JOB_NAME: string;
          STEP_UID: string;
          STEP_ID: string;
          STEP_NAME: string;
          STEP_TYPE: string;
          EXEC_COMMAND: string;
          ON_SUCCESS_ACTION: string;
          RETRY_ATTEMPTS: string;
          RETRY_INTERVAL: string;
          ON_FAILURE_ACTION: string;
        };
      };
    }
    batchLogHist: {
      request: {
        jobId: string;
      };
      response: {
        batchLogHist: {
          JOB_ID: string;
          RUN_DATE: string;
          RUN_STATUS: string;
          RUN_STATUS_NAME: string;
          RUN_DURATION: string;
          RUN_STATUS_MESSAGE: string;
        };
      };
    }
  };

  /**
   * sales site
   */
  DMF0004: {
    site: {
      request: {
        divisionId: string;
        endCustomer: string;
        salesSite: string;
        activeFlag: string;
        soldToCustomer: string;
      };
      response: {
        salesSite: {
          LAST_UPDATED_BY: string;
          VMI_YN: string;
          SOLDTO_CUSTOMER: string;
          SHIP_PLAN_AUTO: string;
          DISTRIBUTION_CHANNEL: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          ATTRIBUTE5: string;
          COUNTRY: string;
          CITY: string;
          DIVISION_ID: string;
          CITY_NAME: string;
          VALID_YN: string;
          COUNTRY_NAME: string;
          EDIT_FLAG: string;
          END_CUSTOMER: string;
          COMPANY_ID: string;
        };
      };
    }
  } & {
    [K in 'customer' | 'location' | 'bucket']: {
      request: {
        divisionId: string;
        salesSite: string;
        activeFlag: string;
      };
      response: {
        salesCustomer: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          SOLDTO_CODE: string;
          SOLDTO_DESCRIPTION: string;
          SHIPTO_CODE: string;
          SHIPTO_DESCRIPTION: string;
          SHIPTO_REGION_NAME: string;
          SHIPTO_CITY_NAME: string;
          REP_YN: string;
          VALID_YN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string;
        };
        salesLocation: {
          LOCATION_SEQ: string;
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          PLANT_ID: string;
          LOCATION_CODE: string;
          LOCATION_DESCRIPTION: string;
          STORAGE_ID: string;
          VALID_YN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string;
        };
        salesBucket: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          INCOTERMS: string;
          D_MON: string;
          D_TUE: string;
          D_WED: string;
          D_THU: string;
          D_FRI: string;
          D_SAT: string;
          D_SUN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string;
        };      
      };
    };
  };
  /**
   * Sales Site Project Model
   */
  DMF0005: {
    production: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        salesSite: string;
        projectCode: string;
        itemId: string;
        activeFlag: string;
        owner: string;
      };
      response: {
        production: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          PROJECT_CODE: string;
          DEPT_ID: string;
          TEAM_NAME: string;
          ITEM_ID: string;
          CUST_GROUP: string;
          END_CUSTOMER: string;
          SOLDTO_CODE: string;
          SHIPTO_CODE: string;
          SOLDTO_CUSTOMER: string;
          OWNER: string;
          OWNER_NAME: string;
          SALES_PLAN_ADJUST_YN: string;
          ITEM_TYPE: string;
          ITEM_CLASS_NAME: string;
          ITEM_NAME: string;
          NICK_NAME: string;
          SALES_COMPANY: string;
          SALES_PLANT: string;
          BPMS_EXIST: string;
          CELL_PER_CAR: string;
          CELL_PER_MODULE: string;
          EDI_LT: string;
          VMI_LT: string;
          PROJECT_INFO: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          PROJECT_OWNER: string;
          PRJ_OWNR_ID: string;
          VALID_YN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          MDM_ACTIVE: string;
        };
      };
    };
    purchase: {
      request: {
        divisionId: string;
        salesSite: string;
        projectCode: string;
        activeFlag: string;
      };
      response: {
        purchase: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          SALES_PLAN_ADJUST_YN: string;
          ITEM_TYPE: string;
          ITEM_CLASS_NAME: string;
          ITEM_ID: string;
          KWH: string;
          CUSTOMER_MODEL: string;
          NICK_NAME: string;
          BPMS_EXIST: string;
          OWNER: string;
          OWNER_NAME: string;
          VALID_YN: string;
          CELL_PER_CAR: string;
          CELL_PER_MODULE: string;
          MODULE_PER_CAR: string;
          SALES_COMPANY: string;
          SALES_PLANT: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string;
          EDI: string;
          EDI_LT: string;
        };
      };
    };
    // Model Code Change 팝업 저장 전용 — PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP(P_DATA JSON, P_USER_ID).
    //   조회 SP 가 없는 시트라 response 는 저장 행 타입(data[]) 정의용이다.
    modelChange: {
      request: Record<string, never>;
      response: {
        modelChange: {
          ITEM_ID_BEFORE: string;
          ITEM_ID_AFTER: string;
        };
      };
    };
  };
  /**
   * popup - region(coutnry, city)
   */
  COM0001: {
    region: {
      request: {
        country: string;
        city: string;
      };
      response: {
        o_rc1: {
          COUNTRY: string;
          COUNTRY_NAME: string;
          CITY: string;
          CITY_NAME: string;
          STATE_NM: string;
        };
      }
    }
  };
  /**
   * popup - customer(soldTo, shipTo)
   */
  COM0002: {
    customer: {
      request: {
        divisionId: string;
        soldTo: string;
        shipTo: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          SOLDTO_CODE: string;
          SOLDTO_DESCRIPTION: string;
          SHIPTO_CODE: string;
          SHIPTO_DESCRIPTION: string;
          SHIPTO_REGION_NAME: string;
          SHIPTO_CITY_NAME: string;
        };
      };
    }
  };
  /**
   * popup - sloc
   */
  COM0003: {
    sloc: {
      request: {
        divisionId: string;
        storageId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PLANT_ID: string;
          STORAGE_ID: string;
          STORAGE_DESCRIPTION: string;
        };
      }
    };
  }
  SYS0006: { // API
    apiList: {
      request: {
        apiType?: string;
        apiId?: string;
        useYn: string;
      };
      response: {
        o_rc: {
          API_ID: string;
          API_MSG_ID: string;
          API_MSG_NM: string;
          API_MSG_DESC?: string;
          API_URL: string;
          USE_YN: string;
        };
      };
    }
  }
  /**
   * Lookup
   */
  SYS0010: {
    lookupMaster: {
      request: {
        lookupType: string;
        lookupGroup: string;
        validYn: string;
      };
      response: {
        o_rc: {
          LOOKUP_TYPE: string;
          DESCRIPTION: string;
          LOOKUP_GROUP: string;
          VALID_YN: string;
          SEGMENT1: string;
          SEGMENT2: string;
          SEGMENT3: string;
          SEGMENT4: string;
          SEGMENT5: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          ATTRIBUTE3: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          ATTRIBUTE11: string;
          ATTRIBUTE12: string;
          ATTRIBUTE13: string;
          ATTRIBUTE14: string;
          ATTRIBUTE15: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
    lookupDetail: {
      request: {
        lookupType: string;
      };
      response: {
        o_rc: {
          LOOKUP_TYPE: string;
          SEGMENT1: string;
          SEGMENT2: string;
          SEGMENT3: string;
          SEGMENT4: string;
          SEGMENT5: string;
          VALID_YN: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          ATTRIBUTE3: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          ATTRIBUTE11: string;
          ATTRIBUTE12: string;
          ATTRIBUTE13: string;
          ATTRIBUTE14: string;
          ATTRIBUTE15: string;
          DISPLAY_SEQ: string;
          DESCRIPTION: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
  };
  SYS0009: { // Menu Button
    menuBtnList: {
      request: {
        menuId?: string;
        sheetNm?: string;
        btnCd?: string;
        apiNm?: string;
        useYn?: string;
      };
      response: {
        o_rc: {
          MNU_ID: string;
          MNU_NM: string;
          SHT_NM: string;
          MNU_BTN_CD: string;
          API_ID: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    }
  }
  /**
   * Auth Request
   */
  SYS0011: {
    authority: {
      request: {};
      response: {
        o_rc: {
          USER_GR_ID: string;
          USER_GR_NM: string;
          DESC: string;
        };
      };
    };
    division: {
      request: {};
      response: {
        o_rc: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
        };
      };
    };
    myAuthorityList: {
      request: {
        sesUserId: string;
      };
      response: {
        o_rc: {
          USER_GR_ID: string;
          USER_GR_NM: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          CREATION_DATE: string;
          APPROVAL_RESULT: string;
          REJECT_REASON: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
    userInfo: {
      request: {
        sesUserId: string;
      };
      response: {
        o_rc: {
          USER_ID: string;
          USER_NM: string;
          USER_ENG_NM: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          LANG_CD: string;
          TMZ_CD: string;
        };
      };
    };
  } 
  /**
   * group-user (SYS0014) — IN/OUT SSOT. SP: P_SYS0014_GET_GROUP_LIST_M / _GET_USER_BY_GROUP_M / _GET_AUTH_LIST_M / _SAVE_GROUP_USER_M
   */
  SYS0014: {
    GroupInfo: {
      request: {
        search: string;
      };
      response: {
        o_rc1: {
          USER_GR_ID: string;
          USER_GR_NM: string;
          USE_YN: string;
        };
      };
    };
    UserInfo: {
      request: {
        userGrId: string;
      };
      response: {
        o_rc1: {
          USER_ID: string;
          USER_NM: string;
          USER_ENG_NM: string;
          USER_EML: string;
          DEPT_NM: string;
          USE_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
    Division: {
      request: {
        userGrId: string;
        userId: string;
        unitTpCd: string;
      };
      response: {
        o_rc1: {
          UNIT_ID: string;
          UNIT_NM: string;
          JV_PLANT_ID: string;
          UPPR_UNIT_ID: string;
          EDIT_YN: string;
          USE_YN: string;
        };
      };
    };
    DivisionPopup: {
      request: {
        searchText: string;
      };
      response: {
        o_rc: {
          CODE: string;
          NAME: string;
        };
      };
    };
  }
  /**
   * notice-setup (SYS0016)
   */
  SYS0016: {
    main: {
      request: {
        module: string;
        subModule: string;
        activeYn: string;
      };
      response: {
        o_rc1: {
          NOTICE_ID: string;
          MODULE: string;
          MODULE_NM: string;
          SUB_MODULE: string;
          SUB_MODULE_NM: string;
          NOTICE: string;
          ACTIVE: string;
          START_DATE: string;
          END_DATE: string;
          PUBLICATION_PERIOD: string;
          POPUP_YN: string;
          NOTICE_TITLE: string;
          NOTICE_CONTENT: string;
          NOTICE_IMAGE: string;
          IMAGE_FILE_NM: string;
          CREATED_BY: string;
          CREATION_DATE: string; // ⭐ [2026-08-23] 공통소스 notice-setup.util(createEmptyNotice) 소비 — 미선언 시 TS2353
          ACTION: string;
        };
      };
    };
  };
  /**
   * popup - owner
   */
  COM0004: {
    owner: {
      request: {
        user: string;
        divisionId: string;
      };
      response: {
        o_rc1: {
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
        };
      };
    };
  };
  /**
   * SCP0121_OwnerPopup — SCP0121_PlanGroupMaster 의 Owner(담당자) 선택 팝업 (전용 신규).
   *
   * 데이터 SP PKG_SCP0121.P_SCP0121_GET_OWNER_DATA_POPUP (현재 미배포 — convert-sp 후속).
   * IN: p_division_id / p_search(콤마 다중검색, USER_ID·USER_NAME·DEPT_NAME_KO 3컬럼 OR LIKE) /
   *     p_owner_id(기선택 UserID CSV — Base/User 서버분리 축).
   * OUT: o_rc1=Base 후보(UserID NOT IN p_owner_id) / o_rc2=User 기선택(UserID IN p_owner_id).
   * 컬럼 메타는 SCM_MST_SHEET_COLUMNS PROGRAM_ID='DMF000'(시트 'Owner Base'/'Owner User', 각 6컬럼).
   * 근거: design/02_search-combo.md §2.1, design/03_grid-columns.md §4.
   */
  SCP0121: {
    ownerPopup: {
      request: {
        divisionId: string; // p_division_id (부모 division — FxUGA.Code 권한필터)
        search: string; // p_search (콤마 다중검색, 공백=전건)
        ownerId: string; // p_owner_id (기선택 UserID CSV, 'ALL' 특수값)
      };
      response: {
        o_rc1: {
          UserID: string;
          UserName: string; // 이름 + ' ' + JOB_NAME 결합
          USER_NAME_EN: string; // OK 반환 userNameEn CSV 원천
          DEPT_ID: string; // 비표시 데이터 필드(그리드 컬럼 아님)
          DEPT_NAME_KO: string;
          SORT_ORDER_NO: string; // 이동 후 재정렬 키
          USER_SELECTABLE_FLAG: string; // 드래그 가드(SP 항상 'Y')
        };
        o_rc2: {
          UserID: string;
          UserName: string;
          USER_NAME_EN: string;
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          SORT_ORDER_NO: string;
          USER_SELECTABLE_FLAG: string;
        };
      };
    };
    /**
     * main — 메인 편집 그리드. GET/SAVE = SCP0121_GET_PLAN_GROUP_LINE / SCP0121_SAVE_PLAN_GROUP_LINE.
     *   TO-BE PKG_SCP0121 멤버 **미배포**(all_procedures 0건, ora.py 2026-10-13 — convert-sp 백로그).
     *   이 계약은 AS-IS MSSQL 본문(design/03_grid-columns.md §4-2/§4-3) + DB 메타 11컬럼(SCM_MST_SHEET_COLUMNS
     *   PROGRAM_ID='SCP0121', sheet 'Plan Group Master') 실측 근거 — SP 미배포 상태의 best-evidence 계약.
     *   request 파라미터는 조회조건 6종(Division 단일 + 체크리스트 5 CSV, 미선택/ALL → 공백).
     */
    main: {
      request: {
        divisionId: string; // 1 p_division_id (단일)
        operationId: string; // 2 p_operation_id (CSV, ALL/미선택 → '')
        plantId: string; // 3 p_plant_id (CSV)
        factoryId: string; // 4 p_factory_id (Building, CSV)
        lineId: string; // 5 p_line_id (CSV)
        planGroupId: string; // 6 p_plan_group_id (CSV)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          PLANT_ID: string;
          FACTORY_ID: string;
          FACTORY_NAME: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          OPMZ_PLAN_GR_ID: string; // 셀콤보 PlanGroup
          OPMZ_PLAN_GR_ITEM_ID: string; // Model (더블클릭 Item 팝업)
          PRE_PLAN_GR_ID: string; // 저장 diff/삭제 WHERE 스냅샷 (hidden)
          PRE_PLAN_GR_ITEM_ID: string; // 저장 diff/삭제 WHERE 스냅샷 (hidden)
          [key: string]: string | number;
        };
      };
    };
    /**
     * searchInfo — 조회조건 6커서 공급. 공용 SP PKG_COM0000.P_SCP0121_GET_SEARCH_INFO
     *   (API_ID SCP0121_SEARCH_INFO_GET, 배포됨 — ora.py 2026-10-13). SCP0124 searchInfo 와 동일 SP.
     *   커서 COL_NM 은 SCM_ADM_PROC_M 실측: plantList/factoryList/lineList/planGroupList/targetList/operationList.
     *   전건 CODE/NAME/DIVISION_ID (Line 은 OPERATION_ID/PLANT_ID/FACTORY_ID 추가) — division/다축은 FE 클라 필터.
     *   targetList(Prod Frozen Target) 는 보이는 조회조건이 아니라 Plan Group 등록 팝업 입력(§4.6) — FE 조회조건 미사용.
     */
    searchInfo: {
      request: {
        userId: string; // 1 P_USER_ID — AS-IS 고정 '' (owner 필터 우회, BE 세션 보정)
      };
      response: {
        plantList: {
          CODE: string; // PLANT_ID
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        factoryList: {
          CODE: string; // FACTORY_ID (Building)
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        lineList: {
          CODE: string; // LINE_ID
          NAME: string;
          DIVISION_ID: string;
          OPERATION_ID: string;
          PLANT_ID: string;
          FACTORY_ID: string;
          [key: string]: string | number;
        };
        planGroupList: {
          CODE: string; // OPMZ_PLAN_GR_ID
          NAME: string; // OPMZ_PLAN_GR_NAME
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        targetList: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        operationList: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * popup - project by division
   */
  COM0005: {
    projectByDivision: {
      request: {
        divisionId?: string;
        deptId?: string;
        endCustomer?: string;
        salesSite?: string;
        projectCode?: string;
        etc?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          END_CUSTOMER: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          CURRENCY: string;
          PROJECT_VER_SEQ: string;
          PROJECT_OWNER: string;
        };
      };
    };
  };
  /**
   * popup - owner by division
   */
  COM0006: {
    ownerByDivision: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        projectCode: string;
        salesSite: string;
        owner: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          USER_NM: string;
          OWNER: string;
          SORT_ORDER_NO: string;
        };
      };
    };
  };
  /**
   * popup - message
   */
  COM0007: {
    message: {
      request: {
        messageType: string;
        message: string;
      };
      response: {
        o_rc: {
          MSG_ID: string;
          MSG_NM_KO: string;
          MSG_NM_EN: string;
          MSG_NM_CN: string;
          MSG_TP_CD: string;
        };
      };
    };
  };
  /**
   * popup - item by division
   */
  COM0008: {
    itemByDivision: {
      request: {
        divisionId?: string;
        deptId?: string;
        endCustomer?: string;
        salesSite?: string;
        projectCode?: string;
        itemId?: string;
        activeFlag?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          ITEM_TYPE: string;
          ITEM_TYPE_NAME: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          END_CUSTOMER: string;
          CURRENCY: string;
          END_CUSTOMER40: string;
        };
      };
    };
    itemBySmallDivision: {
      request: {
        divisionId?: string;
        deptId?: string;
        endCustomer?: string;
        projectCode?: string;
        salesSite?: string;
        itemId?: string;
        itemType?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          ITEM_TYPE: string;
          ITEM_TYPE_NAME: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          END_CUSTOMER: string;
          CURRENCY: string;
          END_CUSTOMER40: string;
        };
      };
    };
  }
  /**
   * popup - item by plant site (AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyPlantSitePopup).
   * 그리드 셀 팝업 — 공통 COM0008(ItemByDivision)·COM0013(Material)과 조회조건/컬럼/SP 가 다르다.
   *   plant site(SCM_SITE_ID)로 좁혀 조회. proc: PKG_SCM0002.P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP.
   *   AS-IS 사용 화면: SCP0036 JigItem / SCP0037 OperationLT / SSP0100 LTManagement.
   *   COM0012 는 ProjectModal 이 선점 → 신규 번호 COM0014.
   */
  COM0014: {
    itemByPlantSite: {
      request: {
        divisionId?: string;
        scmSiteId?: string;
        itemId?: string;
        assignYn?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          ITEM_TYPE: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
        };
      };
    };
  }

  SCM0002: {
    ModelPopup: {
      request: {
        divisionId?: string;
        projectCode?: string;
        scmSiteId?: string;
        itemId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          ITEM_TYPE: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
        };
      };
    };
    // Elec Material 팝업 (AS-IS SCM0002_ItembyDivisionPopupEE, SCP0095) — proc P_SCM0002_GET_ITEM_ELEC.
    //   division/company 는 'ALL' 센티널, company 는 SITE.COMPANY_ID 기준, item 은 LIKE/IN.
    ElecPopup: {
      request: {
        divisionId?: string;
        companyId?: string;
        itemId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          COMPANY_ID: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
        };
      };
    };
    // Project by Division 팝업 (AS-IS SCM0002_ProjectbyDivisionPopup base, SCP0009) — proc P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP.
    ProjectByDivPopup: {
      request: {
        divisionId?: string;
        projectCode?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          BIZ_TYPE: string;
          CURRENCY: string;
          PROJECT_VER_SEQ: string;
          PROJECT_OWNER: string;
        };
      };
    };
    // CAPA Item 팝업 (AS-IS SCM0002_CAPAItemPopup, SCP0104) — proc PKG_SCM0002.P_SCM0002_GET_CAPA_ITEM_POPUP.
    CapaItemPopup: {
      request: {
        divisionId?: string;
        itemId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP: string;
          OPERATION_ID: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          NICK_NAME: string;
        };
      };
    };
  }
  /**
   * popup - team
   */
  COM0009: {
    team: {
      request: {
        teamId: string;
        teamName: string;
        divisionId: string;
      };
      response: {
        o_rc1: {
          DEPT_ID: string;
          DEPT_NAME_KO: string;
          TEAM_ID: string;
          TEAM_NAME_KO: string;
        };
      };
    };
  };
  /**
   * popup - sso user
   */
  COM0010: {
    ssoUser: {
      request: {
        user: string;
        ssoUserYn: string;
      };
      response: {
        o_rc: {
          USER_ID: string;
          USER_NM: string;
          USER_ENG_NM: string;
          DEPT_ID: string;
          DEPT_NM: string;
        };
      };
    };
  };
  /**
   * popup - sso dept
   */
  COM0011: {
    ssoDept: {
      request: {
        department: string;
      };
      response: {
        o_rc: {
          DEPT_ID: string;
          DEPT_NM: string;
        };
      };
    };
  };
  COM0012: {
    project: {
      request: {
        divisionId: string;
        projectCode?: string;
      };
      response: {
        o_rc1: {
          DIVISION_NAME: string;
          END_CUSTOMER: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          CURRENCY: string;
          PROJECT_VER_SEQ: string;
          PROJECT_OWNER: string;
        }
      }
    }
  }

  /**
   * popup - material by division (AS-IS SCM0002_MaterialByDivisionPopup, SCP 27개 화면 공용)
   */
  COM0013: {
    materialByDivision: {
      request: {
        divisionId?: string;
        operationGroup?: string;
        itemId?: string;
        scpModuleType?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          NICK_NAME: string;
          ITEM_CLASS_NAME: string;
        };
      };
    };
  };
  /**
   * Master - Customer_Model_Mapping
   */
  DMF0006: {
    customerModelMapping: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        salesSite: string;
        customerPJT: string;
        customerModel: string;
        projectCode: string;
        itemId: string;
        activeFlag: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DEPT_ID: string;
          END_CUSTOMER: string;
          SCM_SITE_ID: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          CUSTOMER_PROJECT_CODE: string;
          CUSTOMER_MODEL: string;
          ITEM_ID: string;
          ITEM_CLASS_NAME: string;
          ITEM_NAME: string;
          CAPACITY: string;
          CONVERT_QTY_PACK: string;
          CONVERT_QTY_MODULE: string;
          CONVERT_QTY_CELL: string;
          VALID_YN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          AUTHORITY_YN: string;
        };
      };
    }
  }
  /**
   * Master - Customer FCST Master
   *
   * - `customerFcst`: MEASURE_GROUP='CUST_FCST' 데이터 (PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA)
   * - `customerPSI` : MEASURE_GROUP='PSI' 데이터 (PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA)
   *   저장 SP 는 두 시트 공용 (PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA).
   */
  DMF0007: {
    customerFcst: {
      request: {
        planWeek: string;
        divisionId: string;
        endCustomer: string;
        scmSiteId: string;
        bucketType: string;
        validYn: string;
        userId: string;
      };
      response: {
        o_rc1: {
          PLAN_WEEK: string;
          DIVISION_ID: string;
          DEPT_ID: string;
          CUSTOMER_CODE: string;
          SCM_SITE_ID: string;
          SUMMARY_BUCKET_TYPE: string;
          MEASURE_GROUP: string;
          MEASURE: string;
          EDI_FCST_YN: string;
          UPLOAD_UOM: string;
          UPLOAD_BUCKET_TYPE: string;
          VALID_YN: string;
          UPLOAD_ORDER: string;
          EDIT_FLAG: string;
          [key: string]: string;
        };
      };
    };
    customerPSI: {
      request: {
        planWeek: string;
        divisionId: string;
        endCustomer: string;
        scmSiteId: string;
        bucketType: string;
        validYn: string;
        userId: string;
      };
      response: {
        o_rc1: {
          PLAN_WEEK: string;
          DIVISION_ID: string;
          DEPT_ID: string;
          CUSTOMER_CODE: string;
          SCM_SITE_ID: string;
          SUMMARY_BUCKET_TYPE: string;
          MEASURE_GROUP: string;
          MEASURE: string;
          EDI_FCST_YN: string;
          CUSTOMER_PSI: string;
          UPLOAD_UOM: string;
          UPLOAD_BUCKET_TYPE: string;
          VALID_YN: string;
          UPLOAD_ORDER: string;
          EDIT_FLAG: string;
          [key: string]: string;
        };
      };
    };
    /**
     * customerPsiPivot — Wijmo PivotGrid 입력용 long-format raw rows.
     * SP `P_DMF0007_GET_CUST_PSI_PIVOT_DATA` 반환.
     */
    customerPsiPivot: {
      request: {
        planWeek: string;
        divisionId: string;
        endCustomer: string;
        scmSiteId: string;
        bucketType: string;
        validYn: string;
        userId: string;
      };
      response: {
        o_rc1: {
          PLAN_WEEK: string;
          DIVISION_ID: string;
          CUSTOMER_CODE: string;
          SCM_SITE_ID: string;
          SUMMARY_BUCKET_TYPE: string;
          SUMMARY_BUCKET_VALUE: string;
          SUMMARY_BUCKET_YN: string;
          MEASURE_GROUP: string;
          MEASURE: string;
          EDI_FCST_YN: string;
          CUSTOMER_PSI: string;
          UPLOAD_UOM: string;
          UPLOAD_BUCKET_TYPE: string;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          EDIT_YN: string;
        };
      };
    };
  };
  /**
   * Master - ERP EDI Master 정비 (DMF0008)
   *
   * - `summary` / `repair` / `salesSite` / `sspm`: canonical PKG_DMF0008.P_* PROC 매핑.
   * - `spreadTitle` / `updateHistory`: SCM_MST_SHEET_COLUMNS 미등록 동적 컬럼·헤더 SHEET (BE 매핑 미확정 — TODO §F3/§F4).
   *   `spreadTitle` 는 4 그리드의 동적 헤더 SP `DMF0000_GET_COMMON_SPREAD_TITLE` 응답 메타.
   *   `updateHistory` 는 `DMF0000_GET_UPDATE_HISTORY` 의 SDATE/EDATE/UPDATED_BY.
   */
  /**
   * DMF0020 — Sales Future Price (환율/판매단가 관리)
   *
   * 메인 SP : PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO (4 IN + 2 OUT cursor)
   * 환율 SP : PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA (8 IN + 1 OUT)
   * 메타 등록: To-be_v2_converted/08_Screen_Registration/registrations/03_DMF0020_Registration.sql
   * Phase 2 DB 적재 검증 통과 (PKG_DMF0020 18 SP VALID, 4,511줄 body).
   *
   * sesUserId / mnuId 는 BE 자동 채움 (PROC_M COL_NM 매칭, 2026-06-03 fix 적용).
   */
  DMF0020: {
    main: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
      };
      response: {
        // P_DMF0020_GET_FUTUREPRICE_INFO SP body line 422 결과 7 컬럼
        o_rc1: {
          YYYYMMDD: string;
          YYYYMM: string;
          DIVISION_ID: string;
          CURRENCY: string;
          UNIT_CURRENCY: string;
          EXCHANGE_PRICE: string | number;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    pivot: {
      request: { startYyyymmdd: string; endYyyymmdd: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
    exchange: {
      request: { startYyyymmdd: string; endYyyymmdd: string };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          CURRENCY: string;
          UNIT_CURRENCY: string;
          EXCHANGE_PRICE: string;
          [key: string]: string;
        };
      };
    };
    priceBatch: {
      // P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP signature
      request: {
        divisionId: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        createdBy: string;
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    version: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        createdBy: string;
        divisionId: string;
        versionType: string;
        description: string;
      };
      response: {
        // SP body 결과 SELECT 절 (line 60~77): CODE/VERSION_NO/VERSION_DESCRIPTION/VERSION_TYPE/
        //   EDI_APPLY/VER_CRE_SEQ/YYYYMMDD/CREATED_BY/CREATION_DATE/MONTHLY_ROLLING_FCST/EDITABLE/EDIT_YN
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          EDI_APPLY: string;
          VER_CRE_SEQ: string | number;
          YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          MONTHLY_ROLLING_FCST: string;
          EDITABLE: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
    titleSet: {
      // DMF0002_GET_TITLESET_POPUP signature (standalone)
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        divisionId: string;
      };
      response: { o_rc1: { COLUMN_NAME: string; COLUMN_LABEL: string; [key: string]: string } };
    };
    owner: {
      request: { divisionId: string };
      response: { o_rc1: { OWNER_ID: string; OWNER_NAME: string; [key: string]: string } };
    };
    spreadTitle: {
      request: { startYyyymmdd: string; endYyyymmdd: string };
      response: { o_rc1: { [key: string]: string } };
    };
    spreadTitleDate: {
      request: { startYyyymmdd: string; endYyyymmdd: string };
      response: {
        o_rc1: {
          BASIS_START_DATE: string;
          BASIS_START_DATE2: string;
          MMDD: string;
          WEEK_NAME: string;
          YER: string;
          MON: string;
          BASIS_YYYYMM: string;
          [key: string]: string;
        };
      };
    };
    measureCount: {
      request: Record<string, string>;
      response: { o_rc1: { [key: string]: string | number } };
    };
  };
  /**
   * Sales Plan — DMF0021
   */
  DMF0021: {
    'Sales Plan': {
      // DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        scmSiteId: string;
        projectCode: string;
        itemId: string;
        itemType: string;
        fromYyyymmdd: string;
        nowYyyymmdd: string;
        toYyyymmdd: string;

        // SCM_ADM_PROC_M에는 있지만 BE에서 세션 주입
        sesUserId?: string;

        plantSiteId: string;
        bizType: string;
        owner: string;
        internalYn: string;
        userGroup: string;
        bucket: string;
        userDeptId: string;
      };
      response: {
        // 기간 컬럼(M_/W_/D_)이 동적이므로 index signature 필요
        data: {
          [key: string]: string | number | null;
        };
        calendar: {
          THIS_YYYYMM: string;
          THIS_YYYYMMWW: string;
          [key: string]: string | number | null;
        };
        editAuth: {
          EDIT_AUTH_SALESAMT_LOC: string;
          EDIT_AUTH_RTF_SYS_RP: string;
          [key: string]: string | number | null;
        };
      };
    };

    spreadTitle: {
      // DMF0021_GET_SPREAD_TITLE
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;

        // BE 세션 주입
        sesUserId?: string;

        divisionId: string;
        bucket: string;
      };
      response: {
        // PROC_M의 OUT COL_NM이 data
        data: {
          PROGRAM_ID: string;
          SHEET_NAME: string;
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SORT_ORDER_NO: string | number;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          COLUMN_WIDTH: string | number;
          CELL_CONTROL_OBJECT_TYPE_CODE: string;
          HORIZONTAL_ALIGN_CODE: string;
          VISIBLE_FLAG: string;
          DIVISION_ID: string;
          [key: string]: string | number | null;
        };
      };
    };

    measureInfo: {
      // 첨부된 P_DMF0021_GET_SALES_PLAN_MEASUREINFO는 IN 파라미터 없음
      request: Record<string, never>;
      response: {
        // Oracle O_RC1이지만 PROC_M에서 data로 매핑
        data: {
          CODE: string;
          NAME: string;
          DISPLAY_SEQ: string | number;
        };
      };
    };

    dayRange: {
      // PR_GET_DAY_RANGE
      request: {
        createdBy: string;
        month: string;
      };
      response: {
        o_rc1: {
          DAY_RANGE: string;
          [key: string]: string | number | null;
        };
        o_rc2: {
          DAY_RANGE: string;
          [key: string]: string | number | null;
        };
      };
    };

    titleSet: {
      // DMF0002_GET_TITLESET_POPUP 조회 계약
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        sesUserId?: string;
        divisionId: string;
        mnuId?: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL: string;
          [key: string]: string | number | null;
        };
      };
    };
  };

  /**
   * BusinessPlan — DMF0042 (Business Plan · 사업계획)
   *
   * 사내 Oracle ALL_ARGUMENTS 실측 (2026-07-15 — P2 PROC_M 12본 116행 positional 계약).
   * SHEETS:
   * - `Biz Plan`        (메인 조회 — PIVOT wide format. SP `DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA`
   *                      16 IN + 커서 2 — data/calendar[40 편집 유효구간, 81/82 NULL])
   * - `spreadTitle`     (동적 3단 연/분기/월 헤더 — `DMF0042_GET_SPREAD_TITLE`.
   *                      COLUMN_NAME = Y_yyyy / Q_yyyy_q / M_yyyymm — SP L220/235/251 실측)
   * - `dayRange`        (PR_GET_DAY_RANGE 공유 — AS-IS GetDayRange p_month=7. o_rc2=월단위)
   * - `titleSet`        (Column/Measure Setting 영구 저장 — SCM0002_SET_TITLESET_POPUP 공유 계약)
   * - `futurePriceData` (Exchange Rate 모달 grid — `DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA`.
   *                      YYYYMMDD = 'D'||yyyymmdd prefix — SP L54 실측)
   * - `cutoffVersion`   (Ver. Cutoff 버전 목록 — `DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION`)
   * - `mdfVersion`      (Replace 대상 버전 목록 — `DMF0042_GET_DM_MDF_VERSION`)
   * SAVE 계열(PKG SAVE 19키 '^' bulk / SET_PRICE / CUTOFF / REPLACE / exchangeRate SAVE)은
   * apiClient.post 직접 — 타입 미등재. sesUserId/createdBy/lastUpdatedBy 는 BE 세션 자동주입.
   * ⚠ userGroup(P_USERINFO — CMBO BizPlanUserAuthGroup)·userId/mnuId 는 FE payload 필수.
   */
  /**
   * SalesReports — DMF0044 (Sales Reports / MDF Reports)
   *
   * SHEETS (PROC_M 2026-07-22 실측 — PKG_DMF0044 판 우선, 부재 4종 standalone):
   * - `MDF Reports`   (메인 조회 — PIVOT wide. `PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA` 9 IN,
   *                    커서2 data/result. 2행 Measure 블록)
   * - `spreadTitle`   (동적 월 헤더 — `DMF0044_GET_SPREAD_TITLE` standalone 4 IN)
   * - `measure`       (Measure 2행 블록 정의 — `PKG.P_DMF0044_GET_MEASURE` p_data_type)
   * - `unitedVersion` (United 버전 팝업 조회 — `PKG.P_DMF0044_GET_SALES_VERSION_POPUP` 7 IN)
   * - `exchangeRate`  (환율 팝업 — 조회 2종 6 IN + 월 헤더 1 IN)
   * - `textbox`       (82 코멘트 — `PKG.P_DMF0044_GET_TEXTBOX` 3 IN / ⭐ OUT 4커서 data·rc2(MONDAY 기준월)·rc3)
   * - `titleSet`      (공유 — DMF0042 동일 계약)
   * SAVE 계열('^' bulk = apiClient.post 직접 — 미등재): SAVE_SALES_PLAN_REPORT_C(21 IN)/
   *   _C_CF(23 IN)/SAVE_DM_EXCHANGE_RATE_REPORT(9 IN)/SAVE_TEXTBOX(16 IN)/
   *   SAVE_SALES_PLAN_VERSION_COPY(8 IN)/P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY(5 IN)/MOBILE_REPORT_CREATE(5 IN)
   */
  /**
   * EtcSalesReports — DMF0049 (Etc Sales Reports — DMF0044 파생 형제)
   *
   * SHEETS (PROC_M 2026-07-22 실측 — PKG 판 우선/조회·저장 standalone):
   * - `MDF Reports`   (메인 — `DMF0049_GET_SALES_ETC_REPORTS_DATA` 8 IN[sesUserId 6번 BE주입],
   *                    EDIT_AUTH_V 조인. division 세트행 40=3/81=2/82=1)
   * - `spreadTitle`   (`PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE` 6 IN — 커서 2)
   * - `measure`       (`PKG_DMF0049.P_DMF0049_GET_MEASURE` 3 IN)
   * - `unitedVersion` (DMF0044 SP 공유 — API_ID 만 DMF0049_ 신규)
   * - `titleSet`      (공유)
   * SAVE('^' bulk 미등재): `DMF0049_SAVE_SALES_ETC_REPORT_C` 36 IN — DB POSITION 정본
   *   (…31 cellModelInfo/32 cellModel/33 measure/34 yyyymmdd/35 qty/36 sesUserId).
   */
  DMF0049: {
    'MDF Reports': {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        mdfType: string; // 2 P_MDF_TYPE (REPORT_SP_W/BP_M)
        yyyy: string; // 3 P_YYYY
        spVersionNo: string; // 4 P_SP_VERSION_NO (United 주입 — 필수 MSG00283)
        userGroup: string; // 5 P_USER_GROUP (EDIT_AUTH_V 조인)
        userId: string; // 7 P_USER_ID
        mnuId: string; // 8 P_MENU_ID
      };
      response: {
        data: {
          DIVISION_ID: string;
          DEPARTMENT_ID: string;
          DEPARTMENT_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          END_CUST_REPORT: string;
          CUST_REPORT: string;
          PRODUCT_GROUP: string;
          ITEM_ID: string;
          PROJECT_CODE: string;
          END_CUSTOMER: string;
          SCM_SITE_ID: string;
          CURRENCY: string;
          MEASURE: string;
          DATA_SEQ: string | number;
          EDIT_FLAG: string; // ⚠ 동적 셀 편집 판정 미사용 (DMF0049 매트릭스)
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE (6 IN — sesUserId 2번 BE주입)
      request: {
        divisionId: string; // 1
        startDt: string; // 3 (선택연도 0101)
        endDt: string; // 4 (선택연도 1231)
        userId: string; // 5
        mnuId: string; // 6
      };
      response: {
        data: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          SORT_ORDER_NO: string | number;
          FIXED_FLAG: string;
          VISIBLE_FLAG: string;
          [key: string]: string | number;
        };
      };
    };
    measure: {
      // PKG_DMF0049.P_DMF0049_GET_MEASURE (3 IN — division 세트 정의)
      request: {
        divisionId: string; // 1
        userId: string; // 2
        mnuId: string; // 3
      };
      response: {
        data: { CODE: string; NAME: string; [key: string]: string | number };
      };
    };
    unitedVersion: {
      // PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP 공유 (7 IN)
      request: {
        divisionId: string;
        sdt: string;
        edt: string;
        versionType: string;
        description: string;
        userId: string;
        mnuId: string;
      };
      response: {
        data: {
          VERSION_NO: string;
          VERSION_TYPE: string;
          VERSION_DESCRIPTION: string;
          SEND_YN: string;
          YYYYMMDD: string;
          [key: string]: string | number;
        };
      };
    };
    titleSet: {
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        divisionId: string;
      };
      response: { o_rc1: { COLUMN_NAME: string; COLUMN_LABEL: string; [key: string]: string } };
    };
  };

  DMF0044: {
    'MDF Reports': {
      // PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA (9 IN — sesUserId BE주입, 나머지 FE)
      request: {
        divisionId: string; // 1 P_DIVISION_ID (필수)
        mdfType: string; // 2 P_MDF_TYPE (REPORT_SP_W / REPORT_BP_M)
        yyyy: string; // 3 P_YYYY (선택 연도)
        spVersionNo: string; // 4 P_SP_VERSION_NO (United 팝업 주입 — 필수 MSG00283)
        dataType: string; // 5 P_DATA_TYPE (ALL/1/2)
        userGroup: string; // 6 P_USER_GROUP (권한 그룹 — FE 필수 전달)
        userId: string; // 8 P_USER_ID
        mnuId: string; // 9 P_MNU_ID
      };
      response: {
        // 커서 1 — 본문 (정적 46컬럼 admin 메타 + 동적 M_yyyymm 12컬럼. 2행 Measure 블록)
        data: {
          DIVISION_ID: string;
          DEPARTMENT_ID: string;
          DEPARTMENT_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          END_CUST_REPORT: string;
          CUST_REPORT: string;
          PRODUCT_GROUP: string;
          ITEM_ID: string;
          NICK_NAME: string;
          MEASURE: string;
          CURRENCY: string;
          COMPANY_ID: string;
          CUTOFF_TYPE: string;
          CUTOFF_YYYYMMDD: string;
          SCM_SITE_ID: string;
          PROJECT_CODE: string;
          FCST_TYPE: string;
          INCOTERMS: string;
          EDIT_FLAG: string; // 행 편집권 (4변수 매트릭스 입력 1)
          [key: string]: string | number; // + M_yyyymm 동적 12컬럼 + 정적 46
        };
      };
    };
    spreadTitle: {
      // DMF0044_GET_SPREAD_TITLE (standalone 4 IN — sesUserId BE주입)
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        startDt: string; // 3 P_START_DT (선택연도 0101)
        endDt: string; // 4 P_END_DT (선택연도 1231)
      };
      response: {
        data: {
          COLUMN_NAME: string; // binding (M_yyyymm / B_* / 정적)
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string; // 연 span
          SORT_ORDER_NO: string | number;
          FIXED_FLAG: string;
          VISIBLE_FLAG: string;
          [key: string]: string | number;
        };
      };
    };
    measure: {
      // PKG_DMF0044.P_DMF0044_GET_MEASURE (3 IN — Measure 2행 블록 정의. Insert 강제 세팅 원천)
      request: {
        dataType: string; // 1 P_DATA_TYPE
        userId: string; // 2 P_USER_ID
        mnuId: string; // 3 P_MNU_ID
      };
      response: {
        data: { CODE: string; NAME: string; [key: string]: string | number };
      };
    };
    unitedVersion: {
      // PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP (7 IN)
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        sdt: string; // 2 P_SDT (기본 당월-1)
        edt: string; // 3 P_EDT (기본 당월+5)
        versionType: string; // 4 P_VERSION_TYPE (REPORT_SP_W/REPORT_BP_M 계열)
        description: string; // 5 P_DESCRIPTION (검색어)
        userId: string; // 6 P_USER_ID
        mnuId: string; // 7 P_MNU_ID
      };
      response: {
        data: {
          VERSION_NO: string;
          VERSION_TYPE: string;
          VERSION_DESCRIPTION: string;
          SEND_YN: string; // Transfer 게이트 (N=전송가능/Y=취소가능/C=취소됨)
          YYYYMMDD: string;
          [key: string]: string | number;
        };
      };
    };
    exchangeRate: {
      // PKG_DMF0044.P_DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP(+_DATA) (6 IN 동일 — sesUserId BE주입)
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        year: string; // 2 P_YEAR
        versionNo: string; // 4 P_VERSION_NO
        userId: string; // 5 P_USER_ID
        mnuId: string; // 6 P_MNU_ID
      };
      response: {
        data: {
          DIVISION_ID: string;
          CURRENCY: string;
          UNIT_CURRENCY: string;
          [key: string]: string | number; // + 월 피벗 컬럼
        };
      };
    };
    textbox: {
      // PKG_DMF0044.P_DMF0044_GET_TEXTBOX (3 IN / ⭐ OUT 4커서 — o_rc1=data, o_rc2=MONDAY 기준월, o_rc3)
      request: {
        versionNo: string; // 1 P_VERSION_NO
        userId: string; // 2 P_USER_ID
        mnuId: string; // 3 P_MNU_ID
      };
      response: {
        data: { YYYYMM: string; [key: string]: string | number };
        rc2: { MONDAY: string; [key: string]: string | number };
        rc3: { [key: string]: string | number };
      };
    };
    titleSet: {
      // SCM0002_SET_TITLESET_POPUP 공유 계약 (DMF0042 동일)
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        divisionId: string;
      };
      response: { o_rc1: { COLUMN_NAME: string; COLUMN_LABEL: string; [key: string]: string } };
    };
  };
  DMF0008: {
    summary: {
      request: {
        divisionId: string;
        fromYyyymmdd?: string;
        toYyyymmdd?: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          EDI_SENDER_NAME: string;
          GSCM_MASTER_DATA: string;
          SUCCESS: string;
          EXCEPTION_DATA: string;
          [key: string]: string;
        };
      };
    };
    repair: {
      request: {
        divisionId: string;
        senderName: string;
        flag: string;
        fromYyyymmdd?: string;
        toYyyymmdd?: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          EDI_SENDER_NAME: string;
          EDI_SENDER_CODE: string;
          CUST_UNLOADING_POINT: string;
          CUST_PLANT: string;
          CUST_ITEM_ID: string;
          ERP_SOLDTO: string;
          ERP_SHIPTO: string;
          ERP_ITEM_ID: string;
          GSCM_SALES_SITE_ID: string;
          ACTIVE_SS: string;
          GSCM_SSPM: string;
          GSCM_SSPM_INCOTERMS: string;
          ACTIVE_SSPM: string;
          PROJECT_STATUS: string;
          PLANT_SITE_STATUS: string;
          ERP_STATUS: string;
          INPUT_DATE: string;
          EXCEPTION_FLAG: string;
          LAST_UPDATE_DATE: string;
          EXCEPTION_DATE: string;
          EXCLUSION: string;
          [key: string]: string;
        };
      };
    };
    salesSite: {
      request: {
        divisionId: string;
        soldTo: string;
        shipTo: string;
        scmSiteId: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          TEAM_ID: string;
          TEAM_NAME: string;
          END_CUSTOMER: string;
          SOLDTO_CUSTOMER: string;
          COMPANY_ID: string;
          SSCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          REP_SOLDTO_CODE: string;
          REP_SHIPTO_CODE: string;
          VMI_YN: string;
          SITE_VALID_YN: string;
          CUSTOMER_VALID_YN: string;
          REP_YN: string;
          COUNTRY: string;
          CITY: string;
          COUNTRY_NAME: string;
          CITY_NAME: string;
          DISTRIBUTION_CHANNEL: string;
          SHIP_PLAN_AUTO: string;
          ATTRIBUTE5: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string;
          TEAM_EDIT_FLAG: string;
          [key: string]: string;
        };
        // BE 가 O_RESULT_CURSOR alias 로도 반환 가능 (룰 21 §10.3 dual cursor 패턴)
        O_RESULT_CURSOR?: {
          [key: string]: string;
        };
      };
    };
    sspm: {
      request: {
        divisionId: string;
        itemId: string;
        scmSiteId: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DEPT_ID: string;
          DEPT_ID2: string;
          CUST_GROUP: string;
          END_CUSTOMER: string;
          END_CUSTOMER40: string;
          OWNER: string;
          USER_ID: string;
          SOLDTO_CODE: string;
          SOLDTO_DESCRIPTION: string;
          SHIPTO_CODE: string;
          SHIPTO_DESCRIPTION: string;
          SOLDTO_CUSTOMER: string;
          SCM_SITE_ID: string;
          SCM_SITE_ID40: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          PROJECT_STATUS: string;
          PROJECT_OWNER: string;
          SALES_PLAN_ADJUST_YN: string;
          ITEM_TYPE: string;
          ITEM_CLASS_NAME: string;
          ITEM_ID: string;
          ITEM_NAME: string;
          PRODUCTION_PROCESS: string;
          CELL_TYPE: string;
          CELL_TYPE_81: string;
          CELL_TYPE_82: string;
          KWH: string;
          CELL_PER_CAR: string;
          CELL_PER_MODULE: string;
          MODULE_PER_CAR: string;
          CUSTOMER_MODEL: string;
          SALES_COMPANY: string;
          SALES_PLANT: string;
          NICK_NAME: string;
          BPMS_EXIST: string;
          ATTRIBUTE1: string;
          CATHODE_MATERIALS: string;
          ATTRIBUTE2: string;
          CUST_GROUP_DTL: string;
          APPLICATION: string;
          ROUTE: string;
          LIABILITY_PERIOD: string;
          CELL_NAME: string;
          CURRENCY: string;
          EDI: string;
          EDI_LT: string;
          VMI_LT: string;
          PARTIAL_PLAN_YN: string;
          VALID_YN: string;
          MODULE_VARIANT: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          ATTRIBUTE4: string;
          REPORT_GROUP1: string;
          REPORT_GROUP2: string;
          REPORT_GROUP3: string;
          REPORT_GROUP4: string;
          REPORT_GROUP5: string;
          REPORT_GROUP6: string;
          ATTRIBUTE5: string;
          REPORT_GROUP7: string;
          REPORT_GROUP8: string;
          OS_CORP: string;
          CONTRIBUTION_TYPE: string;
          EDIT_FLAG: string;
          EDIT_FLAG2: string;
          EDIT_FLAG3: string;
          [key: string]: string;
        };
      };
    };
    spreadTitle: {
      request: {
        programId: string;
        sheetName: string;
        divisionId: string;
        startYyyymmdd: string;
        endYyyymmdd: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          [key: string]: string;
        };
      };
    };
    updateHistory: {
      request: {
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          SDATE: string;
          EDATE: string;
          UPDATED_BY: string;
          [key: string]: string;
        };
      };
    };
    // 'main' = ErpEdiMaster SUMMARY sheet (SHEETS.MAIN='main' enum 과 일치, BE: PKG_DMF0008.P_DMF0008_GET_EDI_MST_SUMMARY)
    main: {
      request: {
        divisionId: string;
        fromYyyymmdd?: string;
        toYyyymmdd?: string;
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          EDI_SENDER_NAME: string;
          GSCM_MASTER_DATA: string;
          SUCCESS: string;
          EXCEPTION_DATA: string;
          CNT: string;
          EDIT_YN: string;
          [key: string]: string;
        };
      };
    };
    // 'division' = ErpEdiMasterForm Division lookup (BE: PKG_DMF0008.P_DMF0008_GET_MY_DIVISION_LIST 또는 redirect)
    division: {
      request: {
        sesUserId?: string;
        menuId?: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          NAME: string;
          [key: string]: string;
        };
      };
    };
  };
  SYS0013: {
    main: {
      request: {
        reportName: string;
        description: string;
        role: string;
      };
      response: {
        o_rc1: {
          DQ_ID?: number | string | undefined;
          DQ_NAME: string;
          DESCRIPTION: string;
          GROUP_NAME: string;
          VALID_YN: string;
          DQ_TEXT: string;
          CREATED_BY?: string;
          CREATION_DATE?: string;
          LAST_UPDATED_BY?: string;
          LAST_UPDATE_DATE?: string;
          ADMIN_ONLY_YN: string;
          DIVISION_ID: string;
          CRUD_TYPE: string;
          VIEW?: string;
          EDIT_FLAG?: string;
          // [key: string]: string | number;
        };
      };
    },
    columns: {
      request: {
        dqId: number;
      };
      response: {
        o_rc1: {
          CREATED_BY?: string;
          LAST_UPDATED_BY?: string;
          SEQNO: string;
          COLUMN_NAME: string;
          VALID_YN: string;
          CREATION_DATE?: string;
          DQ_ID: number;
          VALUE_YN: string;
          LAST_UPDATE_DATE?: string;
          VALUE_TYPE: string;
          CRUD_TYPE: string;
          AGGREGATE: string;
        };
      };
    },
    parameters: {
      request: {
        dqId: number;
      };
      response: {
        o_rc1: {
          CREATED_BY?: string;
          LAST_UPDATED_BY?: string;
          SEQNO: string;
          PARAMETER_TYPE: string;
          VALID_YN: string;
          CREATION_DATE?: string;
          DQ_ID: number;
          LAST_UPDATE_DATE?: string;
          PARAMETER_ID: string;
          VALUE?: string;
          OPERATION_ID: string;
          CRUD_TYPE: string;
          REP_YN: string;
        };
      };
    },
    popupColumns: {
      request: {
        dqId: number;
      };
      response: {
        o_rc1: {
          CREATED_BY: string;
          LAST_UPDATED_BY: string;
          SEQNO: string;
          COLUMN_NAME: string;
          VALID_YN: string;
          CREATION_DATE: string;
          DQ_ID: number;
          VALUE_YN: string;
          LAST_UPDATE_DATE: string;
          VALUE_TYPE: string;
        };
      };
    },
    popupParameters: {
      request: {
        dqId: number;
      };
      response: {
        o_rc1: {
          CREATED_BY: string;
          LAST_UPDATED_BY: string;
          SEQNO: string;
          PARAMETER_TYPE: string;
          VALID_YN: string;
          CREATION_DATE: string;
          DQ_ID: string;
          LAST_UPDATE_DATE: string;
          PARAMETER_ID: string;
          VALUE: string;
          OPERATION_ID: string;
        };
      };
    },
    result: {
      request: {
        sqlText: string;
      };
      response: {
        o_rc1: {
          [key: string]: string | number;
        };
      };
    }
  },
  /**
   * mail-setup (SYS0017)
   */
  SYS0017: {
    main: {
      request: {
        useType: string;
        module: string;
        submodule: string;
        active: string;
      };
      response: {
        o_rc1: {
          USE_TYPE_CODE: string;
          MODULE_CODE: string;
          SUB_MODULE_CODE: string;
          CATEGORY_ID: string;
          CATEGORY_DESC: string;
          CYCLE_CLASS_CODE: string;
          DETAIL_CLASS_CODE: string;
          SEND_TIME_TEXT: string;
          SEND_MIN_TIME_TEXT: string;
          ACTIVE_FLAG: string;
        };
      };
    };
    message: {
      request: {
        useType: string;
        categoryId: string;
      };
      response: {
        o_rc1: {
          USE_TYPE_CODE: string;
          CATEGORY_ID: string;
          CATEGORY_DESC: string;
          LANGUAGE_CODE: string;
          LANGUAGE: string;
          MAIL_TITLE: string;
          MESSAGE_CONTENT: string;
        };
      };
    };
    allReceiver: {
      request: {
        user: string;
        dept: string;
      };
      response: {
        o_rc1: {
          USERID: string;
          USERNAME: string;
          USERNAME_E: string;
          EMAIL: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          CELLPHONENUM: string;
          LANGUAGE: string;
          USEYN: string;
        };
      };
    };
    selReceiver: {
      request: {
        useType: string;
        categoryId: string;
      };
      response: {
        o_rc1: {
          USE_TYPE_CODE: string;
          CATEGORY_ID: string;
          CATEGORY_DESC: string;
          USERID: string;
          USERNAME: string;
          DEPT_NAME: string;
          EMAIL: string;
          CELLPHONENUM: string;
          LANGUAGE: string;
        };
      };
    };
    sqlText: {
      request: {
        useType: string;
        module: string;
        submodule: string;
        categoryId: string;
      };
      response: {
        o_rc1: {
          TEXT1: string;
          TEXT2: string;
          TEXT3: string;
          TEXT4: string;
          TEXT5: string;
          TEXT6: string;
          TEXT7: string;
          TEXT8: string;
        };
      };
    };
  };
  /**
   * Demand Manager — DMF0068 (소형 수주관리, Division 40 전용)
   *
   * SHEETS:
   * - `ContributeSalesList` (메인 조회. `PKG_DMF0068.P_DMF0068_GET_ORDERLIST`
   *                          — o_rc1=데이터 / o_rc2=조립된 SQL 텍스트(진단용, 화면 미사용))
   * - `versionPopup`        (버전 팝업. `PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP`)
   * - `lookupProject`       (Project 셀 콤보. `PKG_DMF0068.P_DMF0068_GET_LOOKUPPROJECT`)
   *
   * 저장/삭제는 컬렉션 IN 을 바인딩할 수 없어 CLOB(JSON) 래퍼를 사용한다
   * (`P_DMF0068_SAVE_ORDERLIST_JSON` / `P_DMF0068_DEL_ORDERLIST_JSON`).
   * 월 컬럼 M1..Mn 은 조회 기간의 월 수만큼만 내려온다 (n번째 표시 월 = Mn).
   */
  DMF0068: {
    ContributeSalesList: {
      request: {
        divisionId: string;
        versionNo: string;
        fromDt: string;
        toDt: string;
      };
      response: {
        o_rc1: {
          PROJECT_NAME: string;
          MEASURE: string;
          ORDERSTART: string;
          ORDEREND: string;
          ORDERAPPROVAL: number;
          ORDERNOW: number;
          SRESULT: number;
          SPLAN: number;
          STOCK: number;
          STOCK2: number;
          KEYVALUE: string;
          KEYVALUE2: string;
          MEASURE2: string;
          EDIT_YN: string;
          [key: string]: string | number;
        };
        o_rc2: {
          SQL_TEXT: string;
        };
      };
    };
    versionPopup: {
      request: {
        startYyyymmdd: string;
        endYyyymmdd: string;
        divisionId: string;
        versionType: string;
        description: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          VERSION_NO: string;
          VERSION_DESCRIPTION: string;
          VERSION_TYPE: string;
          VER_CRE_SEQ: string;
          YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          EDIT_YN: string;
        };
      };
    };
    lookupProject: {
      request: {
        divisionId: string;
        versionNo: string;
      };
      response: {
        o_rc1: {
          CODE: string;
          NAME: string;
        };
      };
    };
  };
  SCM0007: {
    main: {
      // SCM.SCM0006_GET_RECIPIENT_MASTER(p_use_type, p_module, p_submodule, p_active) — SYS0017 공유
      request: {
        useType: string;
        module: string;
        submodule: string;
        active: string;
      };
      response: {
        o_rc1: {
          USE_TYPE_CODE: string;
          MODULE_CODE: string;
          SUB_MODULE_CODE: string;
          CATEGORY_ID: string;
          CATEGORY_DESC: string;
          CYCLE_CLASS_CODE: string;
          DETAIL_CLASS_CODE: string;
          SEND_TIME_TEXT: string;
          SEND_MIN_TIME_TEXT: string;
          ACTIVE_FLAG: string;
        };
      };
    };
    message: {
      // SCM.SCM0006_GET_RECIPIENT_MESSAGE(p_use_type, p_categoryID) — SYS0017 공유
      request: {
        useType: string;
        categoryId: string;
      };
      response: {
        o_rc1: {
          USE_TYPE_CODE: string;
          CATEGORY_ID: string;
          CATEGORY_DESC: string;
          LANGUAGE_CODE: string;
          LANGUAGE: string;
          MAIL_TITLE: string;
          MESSAGE_CONTENT: string;
        };
      };
    };
    allReceiver: {
      // SCM.SCM0007_GET_RECIPIENT_SMS_GROUP_LIST(p_group, p_phone) — SMS Group 마스터 검색
      // (FE SHEETS.ALL_RECEIVER, DB SHEET_COLUMNS.SHEET_NAME/MNU_BTN_MPG_M.SHT_NM 과 모두 일치)
      request: {
        group: string;
        phone: string;
      };
      response: {
        o_rc1: {
          SMS_GROUP_NAME: string;
          SMS_PHONE: string;
          ACTIVE_FLAG: string;
        };
      };
    };
    selReceiver: {
      // SCM.SCM0007_GET_RECIPIENT_SMS_ASSIGN(p_categoryID) — 카테고리에 할당된 SMS Group
      request: {
        categoryId: string;
      };
      response: {
        o_rc1: {
          CATEGORY_ID: string;
          SMS_GROUP_NAME: string;
          SMS_PHONE: string;
          ACTIVE_FLAG: string;
        };
      };
    };
  };
  /**
   * Sales Monitoring — DMF0048
   */
  DMF0048: {
    'Sales Monitoring': {
      // PKG_DMF0048.P_DMF0048_GET_DM_PLN_SALES_MONITORING PROC_M(SORT_ORD 1~20 IN) 와 정확히 일치
      //   (ALL_ARGUMENTS 실측 2026-07-04 — _deploy_packages/DMF0048_SALES_MONITORING_20260704/04_VERIFY).
      request: {
        divisionId: string; // 1  P_DIVISION_ID
        deptId: string; // 2  P_DEPT_ID (Team — 콤마 delim, 빈값 'ALL')
        endCustomer: string; // 3  P_END_CUSTOMER
        scmSiteId: string; // 4  P_SCM_SITE_ID (Sales Site)
        projectCode: string; // 5  P_PROJECT_CODE (빈값 '' = 전체)
        itemId: string; // 6  P_ITEM_ID (LIKE 부분일치)
        itemType: string; // 7  P_ITEM_TYPE
        fromYyyymmdd: string; // 8  P_FROM_YYYYMMDD
        nowYyyymmdd: string; // 9  P_NOW_YYYYMMDD (AS-IS sNowDate = 오늘)
        toYyyymmdd: string; // 10 P_TO_YYYYMMDD
        createdBy: string; // 11 P_CREATED_BY (BE 세션 자동)
        plantSiteId: string; // 12 P_PLANT_SITE_ID
        biztype: string; // 13 P_BIZTYPE
        owner: string; // 14 P_OWNER
        internalYn: string; // 15 P_INTERNAL_YN (Include Internal Txn)
        userinfo: string; // 16 P_USERINFO (AS-IS NowGroupID — GET_ADMIN_GROUP 판정)
        bucket: string; // 17 P_BUCKET ('DAILY'/'WEEKLY'/'MONTHLY' full-word)
        userDeptId: string; // 18 P_USER_DEPT_ID (JV Planner 전용 — 일반 공란)
        sesUserId: string; // 19 P_USER_ID (BE 세션 자동)
        mnuId: string; // 20 P_MENU_ID (BE 메뉴 자동)
      };
      response: {
        // O_RC1 — wide format (식별 컬럼 + 동적 PIVOT M_/W_/D_ 컬럼 + EDIT_YN). 스모크 실측 2026-07-04:
        //   Div40 724행/59cols, Div81 1,236행 (04_VERIFY/002_smoke_results.txt).
        o_rc1: {
          DIVISION_ID: string;
          END_CUSTOMER: string;
          END_CUSTOMER40: string;
          SCM_SITE_ID: string;
          PROJECT_CODE: string;
          GROUP_ID: string;
          ITEM_ID: string;
          TEXT: string;
          KWH_CELL: string | number;
          KWH_MODULE: string | number;
          KWH_PACK: string | number;
          NICK_NAME: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          DOM_EXP: string;
          COMPANY_ID: string;
          CELL_PROD_SITE_ID: string;
          CURRENCY: string;
          PLANT_SITE_ID: string;
          MEASURE: string;
          SORT_ORDER_NO: string | number;
          // 행 편집 플래그 — read-only 화면이라 미사용 (기록: __asis-mapping__.md)
          EDIT_YN: string;
          [key: string]: string | number;
        };
        // O_RC2 — 현재/전주 주차 정보 (헤더 초록 강조 + Color 과거 회색 판정 입력).
        o_rc2: {
          THIS_YYYYMM: string; // 'M_'||현재월 binding
          THIS_YYYYMMWW: string; // 'W_'||현재주 binding
          BASIS_DATE: string;
          PRE_YYYYMM: string;
          PRE_YYYYMMWW: string;
          BASIS_YYYYMM: string;
          ISO_WEEK: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      // DMF0048_GET_SPREAD_TITLE PROC_M (5 IN + o_rc1) — 2026-07-04 O_RC1 복원 변환분.
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
        createdBy: string; // 3 P_CREATED_BY (BE 세션 자동)
        divisionId: string; // 4 P_DIVISION_ID
        bucket: string; // 5 P_BUCKET ('DAILY' 일 때만 D_ 생성)
      };
      response: {
        // O_RC1 — SHEET_COLUMNS(division 필터) + 달력 기간컬럼 UNION (스모크 실측 48행/22cols).
        o_rc1: {
          PROGRAM_ID: string;
          SHEET_NAME: string;
          COLUMN_NAME: string; // binding (M_yyyymm / W_yyyymm+ISO_WEEK / D_yyyymmdd / 정적컬럼명)
          COLUMN_LABEL_NAME: string;
          SORT_ORDER_NO: string | number;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          COLUMN_WIDTH: string | number;
          CELL_CONTROL_OBJECT_TYPE_CODE: string;
          HORIZONTAL_ALIGN_CODE: string;
          VISIBLE_FLAG: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      // PR_GET_DAY_RANGE PROC_M (2 IN + o_rc1/o_rc2) — 기본 조회구간 (AS-IS GetDayRange p_month=6).
      request: {
        createdBy: string; // 1 P_CREATED_BY (BE 세션 자동)
        month: string; // 2 P_MONTH (AS-IS 6 고정 — "7개월에서 6개월로 변경" .cs L994)
      };
      response: {
        // o_rc1 = ISO 주 정렬 범위 (AS-IS Tables[0], 미사용) / o_rc2 = 월 경계 범위 (AS-IS Tables[1] 사용분)
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
  };
  // SCP0085 Ending Inventory — 조회 전용 Report(convert-react). 조회 SP 이중화:
  //   main = SCP0085_GET_ENDING_INVENTORY(p_yyyymm) / daily = SCP0085_GET_ENDING_INVENTORY_DAILY(p_yyyymmdd).
  //   PKG_SCP0085 배포 완료(2026-10-13 ora.py 실측, all_objects VALID). 컬럼셋은 SCM_MST_SHEET_COLUMNS
  //   99행 메타 구동(index signature). SP 는 itemType/profitCenter(IN CLOB) 도 받는다. itemType 은
  //   FE 가 전송(전체=빈값), profitCenter 는 조회조건이 없어 FE 미전송 — WHERE 절이 TRIM(...) IS NULL 로
  //   NULL-safe 하게 처리해 누락 시 필터 없이 전체 반환(callProc2 가 미전달 키를 null 바인딩).
  SCP0085: {
    main: {
      request: {
        yyyymm: string; // p_yyyymm
        divisionId: string; // p_division_id (콤마 다중, ALL)
        plantId: string; // p_plant_id (콤마 다중, ALL)
        itemId: string; // p_item_id
        debugMode: string; // debug_mode ('F')
        itemType?: string; // p_item_type — 콤마 다중 코드(H,P,Q,R), 빈값=전체
        profitCenter?: string; // p_profit_center — AS-IS 미대응, FE 미전송(NULL-safe)
      };
      response: {
        o_rc1: {
          YYYYMM: string;
          DIVISION_ID: string;
          PLANT_NAME: string;
          PLANT_ID: string;
          ITEM_ID: string;
          QUANTITY: string | number;
          USE_CELL_CF_BOM: string;
          CELL_CONVER_FACTOR: string | number;
          CELL_CONVER_QUANTITY: string | number;
          CELL_TYPE_GR: string;
          [key: string]: string | number;
        };
      };
    };
    daily: {
      request: {
        yyyymmdd: string; // p_yyyymmdd
        divisionId: string; // p_division_id (콤마 다중, ALL)
        plantId: string; // p_plant_id (콤마 다중, ALL)
        itemId: string; // p_item_id
        debugMode: string; // debug_mode ('F')
        itemType?: string; // p_item_type — 콤마 다중 코드(H,P,Q,R), 빈값=전체
        profitCenter?: string; // p_profit_center — AS-IS 미대응, FE 미전송(NULL-safe)
      };
      response: {
        o_rc1: {
          YYYYMMDD: string;
          YYYYMM: string;
          DIVISION_ID: string;
          PLANT_NAME: string;
          PLANT_ID: string;
          ITEM_ID: string;
          QUANTITY: string | number;
          USE_CELL_CF_BOM: string;
          CELL_CONVER_FACTOR: string | number;
          CELL_CONVER_QUANTITY: string | number;
          // 일별 SP 는 값을 반환하지 않으나 컬럼은 메타상 존재(공백 표시, design 03 §2-3) — 타입은 유지.
          CELL_TYPE_GR: string;
          [key: string]: string | number;
        };
      };
    };
  };
  // SCP0084 Long-term stock (장기진부화 재고) — 조회 리포트 + MEMO Edit-토글 저장(convert-react).
  //   조회 SCP0084_GET_LONG_TERM_STOCK(5-IN) / 저장 SCP0084_SAVE_LONG_TERM_STOCK_MEMO_ROW_DATASET
  //   (6키+MEMO, MEMO 만 UPDATE). PKG_SCP0084 미배포(convert-sp 후속) — 컬럼셋은 SCM_MST_SHEET_COLUMNS
  //   59행 메타 구동(index signature). 아래 필드는 저장키/편집 컬럼 SSOT 문서용.
  SCP0084: {
    main: {
      request: {
        yyyymm: string; // p_yyyymm
        divisionId: string; // p_division_id (콤마 다중, 전체='')
        plantId: string; // p_plant_id (콤마 다중, 전체='')
        longTermTypeCode: string; // p_long_term_type_code (콤마 다중, 전체='')
        debugMode: string; // debug_mode ('F')
      };
      response: {
        o_rc1: {
          YYYYMM: string;
          DIVISION_ID: string;
          PLANT_ID: string;
          PLANT_DESCRIPTION: string;
          ITEM_ID: string;
          ITEM_UOM: string;
          MEMO: string; // 유일 편집 컬럼(EditButton 토글 후, 저장 대상)
          // 저장 매칭 6키(design 03 §4.3) — MEMO 만 UPDATE, WHERE=(YYYYMM_VAL,PLANT_ID,DIVISION_ID,ITEM_ID,CHARG,DEVALUATION_AGE).
          YYYYMM_VAL: string;
          CHARG: string;
          DEVALUATION_AGE: string;
          [key: string]: string | number;
        };
      };
    };
  };
  // SCP0101 Inventory Trend — 조회 전용 Report(convert-react). 단일 조회 SP:
  //   main = SCP0101_GET_INVENTORY_TREND(p_yyyymm/p_division_id/p_plant_id/p_item_id/debug_mode).
  //   2 REPORT_TYPE(LongTerm/Ending) UNION 45컬럼. PKG_SCP0101 미배포(convert-sp 후속) — 컬럼셋은
  //   SCM_MST_SHEET_COLUMNS 47행 메타 구동(index signature). 아래 필드는 조건포맷/헤더 판정 SSOT 문서용.
  SCP0101: {
    main: {
      request: {
        yyyymm: string; // p_yyyymm (monthPicker, 헤더 relabel 기준 focus 월)
        divisionId: string; // p_division_id (콤마 다중, ALL)
        plantId: string; // p_plant_id (콤마 다중, ALL)
        itemId: string; // p_item_id (텍스트/팝업 반환, 콤마 다중)
        debugMode: string; // debug_mode ('F')
      };
      response: {
        o_rc1: {
          YYYYMM: string;
          DIVISION_ID: string;
          PLANT_DESCRIPTION: string;
          PLANT_ID: string;
          ITEM_ID: string;
          REPORT_TYPE: string; // {LongTerm, Ending} — 행 배경 R1 트리거
          CHK_QTY: string | number; // hidden 판정컬럼(0/10/20/30/40) — INV_STATUS 조건포맷 R2
          INV_STATUS_AVAILABLE: string | number;
          INV_STATUS_HOLDING: string | number;
          INV_STATUS_QT: string | number;
          INV_STATUS_BLOCKED: string | number;
          [key: string]: string | number;
        };
      };
    };
  };
  // SCP0017 Production Plan Waterfall (생산계획 Waterfall) — 읽기전용 조회 pivot(convert-react).
  //   main  = SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL(15-IN, 동적 pivot D_/W_/M_ 값칼럼 반환).
  //   title = SCP0009_GET_SHEET_CALENDAR_3SPAN(+_ISO) 상당 — 기간칼럼 헤더 메타(3단 라벨/DAY_CODE/정렬).
  //   PKG_SCP0017 미배포(all_objects 0건, convert-sp 후속). 고정 컬럼셋은 SCM_MST_SHEET_COLUMNS
  //   MODEL 25행 메타 구동(index signature) — 아래 필드는 SSOT/헤더 판정 문서용. design 03 §1/§2/§4.
  SCP0017: {
    main: {
      request: {
        divisionId: string; // p_division_id (단일)
        operationGroup: string; // p_operation_group (단일)
        scmSiteId: string; // p_scm_site_id (콤마 다중, ALL)
        lineId: string; // p_line_id (콤마 다중, '-'→제외)
        itemId: string; // p_item_id (팝업 반환, 콤마 다중)
        fromYyyymmdd: string; // p_from_yyyymmdd (YYYYMMDD)
        toYyyymmdd: string; // p_to_yyyymmdd (YYYYMMDD)
        versionNo: string; // p_version_no (PP_W_YYYYMMDD, Gap 시 2건 콤마)
        electrodeType: string; // p_electrode_type (다중, ALL→NULL)
        nickName: string; // p_nick_name (텍스트)
        gap: string; // p_gap ('Y'/'N')
        programId: string; // p_program_id ('SCP0017')
        sheetName: string; // p_sheet_name ('MODEL')
        debugMode: string; // debug_mode ('F')
      };
      response: {
        o_rc1: {
          MEASURE: string; // 좌측 고정 말미(fixed) — measure 코드
          MEASURE_NAME: string; // 데이터칼럼 시작 앵커 표시명
          VERSION_NO: string; // 강제 행 축(FORCED_AXIS)
          NOTATION: string; // 행별 표시 포맷(INTEGER/POINT/POINT3)
          // 동적 기간칼럼 D_yyyymmdd / W_yyyymm+ISO주차 / M_yyyymm 은 index signature 로 수용.
          [key: string]: string | number;
        };
      };
    };
    title: {
      request: {
        divisionId: string; // 헤더 캘린더 기준 division
        bucket: string; // DAILY/WEEKLY/MONTHLY/WEEKLY_ISO (ISO 분기)
        fromYyyymmdd: string; // p_start_yyyymmdd
        toYyyymmdd: string; // p_end_yyyymmdd
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // D_/W_/M_ binding
          COLUMN_LABEL_NAME: string; // 3단 leaf 라벨
          SMALL_CLASS_LABEL_NAME: string; // 2단(주차) 라벨
          LARGE_CLASS_LABEL_NAME: string; // 1단(월) 라벨
          DAY_CODE: string; // 'SAT'/'SUN'/'' 주말 헤더색 판정
          SORT_ORDER_NO: string | number; // 좌→우 배치 정렬
          [key: string]: string | number;
        };
      };
    };
  };
  // SCP0016 Shipment Plan FG Waterfall (출하계획 FG Waterfall) — 읽기전용 조회 pivot(convert-react).
  //   main        = SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL(동적 pivot D_/W_/M_ 값칼럼 반환).
  //   spreadTitle = 공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(start/end 2-IN, VALID) — 기간칼럼 헤더 메타.
  //   PKG_SCP0016 미배포(all_objects 0건, convert-sp 후속). 고정 컬럼셋은 SCM_MST_SHEET_COLUMNS
  //   'Waterfall Shipment Plan' 28행 메타 구동(index signature) — 아래 필드는 SSOT/헤더 판정 문서용. design 03 §1/§2/§4.
  SCP0016: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id (단일)
        fromYyyymmdd: string; // 2 p_from_yyyymmdd (YYYYMMDD)
        toYyyymmdd: string; // 3 p_to_yyyymmdd (YYYYMMDD)
        bizType: string; // 4 p_biz_type (Operation Group 단일)
        projectCode: string; // 5 p_project_code (Project 팝업 반환)
        itemId: string; // 6 p_item_id (Model 팝업 반환)
        versionNo: string; // 7 p_version_no (SP_W_YYYYMMDD, 다중 콤마)
        electype: string; // 8 p_electype (다중, ALL→NULL)
        iso: string; // 9 p_iso ('T' if WeeklyISO else 'F')
        programId: string; // 10 p_program_id ('SCP0016')
        sheetName: string; // 11 p_sheet_name ('Shipment Plan FG'; 12 p_user_id = 세션 자동)
      };
      response: {
        o_rc1: {
          MEASURE: string; // measure 코드(hidden 행 축, Set_SumValues 판정 키)
          measure_label: string; // 표시용 measure 명(고정 말미 컬럼)
          version_no: string; // 강제 행 축(FORCED_AXIS)
          KEY_IDX: string; // 세로 병합 그룹 키(division+biz_type+project_code+item_id+to_site+incoterms)
          // 동적 기간칼럼 D_yyyymmdd / W_yyyymm+ISO주차 / M_yyyymm 은 index signature 로 수용.
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD (공용 캘린더 SP 2-IN)
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // D_/W_/M_ binding
          COLUMN_LABEL_NAME: string; // 3단 leaf 라벨(일)
          SMALL_CLASS_LABEL_NAME: string; // 2단(주차) 라벨
          LARGE_CLASS_LABEL_NAME: string; // 1단(월) 라벨
          DAY_CODE: string; // 'SAT'/'SUN'/'' 주말 헤더색 판정
          SORT_ORDER_NO: string | number; // 좌→우 배치 정렬
          [key: string]: string | number;
        };
      };
    };
  };
  // SCM0014 Validation Shipment Result (Intransit Inventory) — 읽기전용 조회(convert-react).
  //   조회 SP = SCM0014_GET_VALIDATION_SHIPMENT_RESULT(8-IN, OUT cursor 1). PKG_SCM0014 미배포(convert-sp 후속).
  //   반환 컬럼 정본 = AS-IS MSSQL SP SELECT 23컬럼(design 03 §4.2). 컬럼셋은 SCM_MST_SHEET_COLUMNS 23행
  //   메타 구동(index signature) — 아래 필드는 SSOT 문서용.
  SCM0014: {
    main: {
      request: {
        divisionId: string; // p_division_id (단일)
        plantSiteId: string; // p_plant_site_id (텍스트, LIKE %..%)
        salesSiteId: string; // p_sales_site_id (텍스트, LIKE %..%)
        projectCode: string; // p_project_code (콤마 다중)
        itemId: string; // p_item_id (콤마 다중)
        fromYyyymmdd: string; // p_from_yyyymmdd (YYYYMMDD)
        toYyyymmdd: string; // p_to_yyyymmdd (YYYYMMDD)
        resultType: string; // p_result_type (I/C/B)
      };
      response: {
        o_rc1: {
          result_date: string; // YYYY-MM-DD 문자열
          result_type: string; // 'Plant Issue'/'Intransit' 텍스트(코드 아님)
          division_id: string;
          shipment_no: string;
          project_code: string;
          item_id: string;
          NICK_NAME: string;
          plant: string;
          Trans_Mode: string;
          operation_group: string;
          delivery_qty: string | number;
          customer_code: string; // final_soldto_code
          shipto_code: string;
          incoterms: string; // final_incoterms
          from_scm_site_id: string;
          to_scm_site_id: string;
          bod_lead_time: string;
          plant_issue_date: string;
          pol_atd_date: string;
          pod_ata_date: string; // ATA 없으면 ETA fallback
          pod_atd_date: string; // ATD 없으면 ETD fallback
          f_dest_eta_date: string;
          f_dest_eta_date2: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * SCP0001 Plant Site (Supply Master). master(site) + sub 3시트(location/customer/locationOsp).
   * GET 4본 = PKG_SCP0001.P_SCP0001_GET_* (커서 o_rc1 — SCM_ADM_PROC_M 실측 2026-09-24).
   * SAVE 4본 = P_SCP0001_SAVE_* — P_DATA CLOB(JSON array, camelCase PATH 실측) + sesUserId.
   *   response.save 는 GET 커서가 아니라 SAVE JSON payload 계약(JSON_TABLE PATH 전건)이다 —
   *   useProcMutation<M, S, 'save'> 의 payload 타입으로 쓴다(design 03 §4.2).
   */
  SCP0001: {
    site: {
      request: {
        // p_division_id — 콤마 목록. 주의: null 이면 SP 가 권한 무관 전체 반환(권한필터 없음) —
        //   'ALL' 은 권한 division(EE 제외) 전 코드 콤마 확장으로 전달(null 금지, design 02 §2-1)
        divisionId: string;
        plantId: string | null; // p_plant_id — UPPER LIKE(코드+명칭)
        scmSiteId: string | null; // p_scm_site_id — UPPER LIKE(코드+명칭)
        ospYn: string | null; // p_osp_yn — 'ALL'->null
        validYn: string | null; // p_valid_yn — 'ALL'->null, 기본 'Y'
        newYn: string | null; // p_new_yn — 항상 null(AS-IS cboNew 제거 잔재, design 02 §2-4)
      };
      response: {
        // P_SCP0001_GET_PLANT_SITE o_rc1 반환 31컬럼 (PKG 본문 실측, design 03 §4.1)
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          OSP_YN: string;
          PLANT_ID: string;
          PLANT_NAME: string;
          OPERATION_GROUP: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          HQ_VENDOR_CODE: string;
          HQ_VENDOR_CODE_NAME: string;
          SCM_VENDOR_NAME: string;
          COUNTRY: string;
          CITY: string;
          SHIP_FROZEN: string;
          PROD_FROZEN: string;
          FP_PLAN_PERIOD: string;
          BUILD_AHEAD: string;
          VALID_YN: string;
          NEW_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          COMPANY_ID: string;
          LOGISTIC_PLANT_ID: string;
          PACKER_ITEM_ID_SUFFIX: string;
          PACKER_LINE_ACTIVE_YN: string; // ATTRIBUTE1
          FROZEN_TYPE: string; // ATTRIBUTE6 — site 셀콤보 LookupCommon(A1=FROZEN_TYPE) 등재(iter-3 H1), 저장 frozenType 전달
          SSP_SHIP_FROZEN: string; // ATTRIBUTE7 — 화면 미사용, row 보존만
          LINK_PLANT_SITE_CODE: string; // ATTRIBUTE9
          LINK_PLANT_SITE: string;
        };
        // SAVE_PLANT_SITE JSON payload (JSON_TABLE PATH 실측 — vmiYn 'N' 고정, shipFrozen 없음)
        save: {
          activeFlag: string; // CRUD_TYPE I/M/D
          divisionId: string;
          plantId: string;
          scmSiteId: string;
          siteDescription: string;
          country: string;
          city: string;
          operationGroup: string;
          vmiYn: string;
          validYn: string;
          newYn: string;
          frozenType: string | null;
          prodFrozen: string | null;
          fpPlanPeriod: string | null;
          buildAhead: string | null;
          createdBy: string;
          creationDate: string | null; // 기존행만 'YYYY-MM-DD HH:mm:ss'
          lastUpdatedBy: string;
          companyId: string;
          logisticPlantId: string;
          packerItemIdSuffix: string;
          hqVendorCode: string;
          packerLineActiveYn: string;
          scmVendorName: string;
          ospYnGb: string; // 행 OSP_YN — P_SCP0001_SAVE_VENDOR 분기 키
          linkPlantSiteId: string;
        };
      };
    };
    location: {
      request: {
        divisionId: string; // 마스터 선택 행 DIVISION_ID (row-context, design 03 §4.1)
        scmSiteId: string; // 마스터 선택 행 SCM_SITE_ID
        validYn: string | null; // 조회조건 Valid 재사용 — 'ALL'->null
      };
      response: {
        // P_SCP0001_GET_LOCATION o_rc1 반환 19컬럼
        o_rc1: {
          LOCATION_SEQ: string;
          LOCATION_CODE: string;
          LOCATION_CODE2: string;
          LOCATION_DESCRIPTION: string;
          FACTORY_ID: string;
          FACTORY_ID2: string;
          FACTORY_NAME: string;
          OPERATION_ID: string;
          OPERATION_ID2: string;
          OPERATION_NAME: string;
          ELECTRODE_TYPE: string;
          STORAGE_ID: string;
          SSP_STORAGE_ID: string; // ATTRIBUTE2
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          DISPLAY_SEQ: string;
        };
        // SAVE_LOCATION JSON payload — divisionId/scmSiteId/plantId 는 마스터 컨텍스트(AS-IS cs:1135~1137)
        save: {
          activeFlag: string;
          locationSeq: string | null; // 신규 null -> SEQ1_SCM_MST_LOCATION.NEXTVAL
          divisionId: string;
          scmSiteId: string;
          plantId: string;
          locationCode: string;
          locationDescription: string;
          factoryId: string;
          operationId: string;
          electrodeType: string;
          storageId: string;
          sspStorageId: string;
          validYn: string;
          createdBy: string;
          creationDate: string | null;
          lastUpdatedBy: string;
        };
      };
    };
    customer: {
      request: {
        divisionId: string; // 마스터 선택 행 DIVISION_ID
        scmSiteId: string; // 마스터 선택 행 SCM_SITE_ID
        activeFlag: string; // 'ALL' 문자열 허용(NULL/'ALL'=전체 — PKG 라인 288)
        createdBy: string; // 세션 USER_ID (EDIT_FLAG dept 판정)
        userGroup: string; // 세션 그룹명 — 'ADMIN'/'DM ADMIN' 판정(AS-IS NowGroupID 이관, hook #128 잔존)
      };
      response: {
        // P_SCP0001_GET_SITE_CUSTOMER o_rc1 반환 13컬럼
        o_rc1: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          SOLDTO_CODE: string;
          SOLDTO_DESCRIPTION: string;
          SHIPTO_CODE: string;
          SHIPTO_DESCRIPTION: string;
          SHIPTO_REGION_NAME: string;
          SHIPTO_CITY_NAME: string;
          REP_YN: string;
          VALID_YN: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
          EDIT_FLAG: string; // 행별 편집권한 — 'N' 행 편집 차단 (메타 VIS=N hidden)
        };
        // SAVE_SITE_CUSTOMER JSON payload
        save: {
          activeFlag: string;
          divisionId: string;
          scmSiteId: string;
          soldtoCode: string;
          soldtoDescription: string;
          shiptoCode: string;
          shiptoDescription: string;
          repYn: string;
          validYn: string;
          createdBy: string;
        };
      };
    };
    locationOsp: {
      request: {
        divisionId: string; // 마스터 선택 행 DIVISION_ID
        scmSiteId: string; // 마스터 선택 행 SCM_SITE_ID
        validYn: string | null; // 'ALL'->null
      };
      response: {
        // P_SCP0001_GET_LOCATION_OSP o_rc1 반환 12컬럼
        o_rc1: {
          DIVISION_ID: string;
          PLANT_ID: string;
          STORAGE_ID: string;
          SCM_SITE_ID: string;
          SITE_DESCRIPTION: string;
          DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          LOGISTIC_PLANT_ID: string; // 화면 미사용 — row 보존만
        };
        // SAVE_LOCATION_OSP JSON payload — MERGE 키 DIVISION_ID+PLANT_ID+STORAGE_ID+SCM_SITE_ID
        save: {
          activeFlag: string;
          divisionId: string;
          scmSiteId: string;
          plantId: string;
          description: string;
          storageId: string;
          validYn: string;
          lastUpdatedBy: string;
        };
      };
    };
    /**
     * Vendor 검색 팝업 시트 — AS-IS SCM0002_VendorPopup(PU-04/05) 대응. TO-BE 공용 컴포넌트 부재로
     * 화면 전용 모달이 PKG_SCM0002.P_SCM0002_GET_VENDOR_POPUP(배포·VALID 실측)을 자기 화면 시트로
     * 배선한다(05_register.sql — MNU_BTN_MPG/API_M/PROC_M 등록, all_arguments 실측 기준).
     */
    vendor: {
      request: {
        vendorCode: string; // P_VENDOR_CODE — LIKE 부분일치
        vendorName: string; // P_VENDOR_NAME — LIKE 부분일치
        paker: string | null; // P_PAKER — PACKER_YN 콤마 IN, null=전체 (SP 원문 철자 그대로)
      };
      response: {
        o_rc1: {
          COMPANY_ID: string;
          VENDOR_CODE: string;
          VENDOR_NAME: string;
          REPRESENTATIVE: string;
          COUNTRY: string;
          VENDOR_ADDRESS: string;
          PACKER_YN: string;
        };
      };
    };
  };
  SCP0007: {
    bod: {
      request: {
        divisionId: string; // p_division_id
        fromSite: string; // p_from_site
        toSite: string; // p_to_site
        incoterms: string; // p_incoterms
        incotermsSsp: string; // p_incoterms_ssp
        transMode: string; // p_trans_mode
        inputStatus: string; // p_input_status
        validYn: string; // p_valid
      };
      response: {
        o_rc1: {
          BOD_ID: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          CUSTOMER: string;
          // AS-IS DefColumns.CUSTOMER_CODE(SCP0007_BOD.cs L101) — 04_impl-gap-audit.md #11.
          CUSTOMER_CODE: string;
          INCOTERMS: string;
          INCOTERMS_SSP: string;
          FROM_SITE_CODE: string;
          FROM_SITE_NAME: string;
          TO_SITE_CODE: string;
          TO_SITE_NAME: string;
          PRIORITY: string;
          ROUTE_ID: string;
          TRANSPORT_MODE: string;
          // 요일별 운송 가능 여부(Y/N) — Route 선택 팝업이 주입. 그리드 전례 없음(신규 boolean 7컬럼).
          DAYS_MON: string;
          DAYS_TUE: string;
          DAYS_WED: string;
          DAYS_THU: string;
          DAYS_FRI: string;
          DAYS_SAT: string;
          DAYS_SUN: string;
          LEAD_TIME: string;
          DIS_TOTAL_LEAD_TIME: string;
          BOD_VALID: string; // 그리드 바인딩. 저장 SP 파라미터는 p_valid_yn (컬럼명≠파라미터명)
          ROUTE_VALID: string;
          FROM_COUNTRY: string;
          FROM_CITY: string;
          TO_COUNTRY: string;
          TO_CITY: string;
          SAFETY_STOCK: string;
          ROUTE_CNT: string;
          VMI_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          ROUTE_CHK: string;
          LT_TYPE: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          BEFORE_LEAD_TIME: string;
          AFTER_LEAD_TIME: string;
          REMARKS: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * Country/City 조회 — AS-IS GetData_Country()(SCP0007_BOD.cs L604-638, SCP.SCP0007_GET_COUNTRY_CITY).
     * BOD 그리드의 FROM_SITE_CODE/TO_SITE_CODE 셀 값으로 SCM_SITE_ID 를 매칭해 country/city/site_type
     * 를 읽어오는 캐시(dtCountryCity) 원천. TO-BE SP(PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY) 는
     * 95_SCP0007_SCP0005_proc_api_registration.sql BLOCK 1 로 PROC_M 만 등록되어 있고 버튼/API 배선
     * (SCM_ADM_MNU_BTN_MPG_M/SCM_ADM_USER_GR_MNU_BTN_MPG_M)이 없다 — 실행 전 등록 필요
     * (design/05_register.sql, 확인필요/DB 접속 불가로 미적용).
     */
    countryCity: {
      request: {
        divisionId: string; // p_division_id (AS-IS division 멀티선택 CSV)
        scmSiteId: string; // p_scm_site_id (AS-IS 항상 빈 문자열 — 조회 시 division 전체를 받아 캐시)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          SCM_SITE_ID: string;
          COUNTRY: string;
          CITY: string;
          VMI_YN: string;
          SITE_TYPE: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * From/To City 조합의 Route 존재 건수 — AS-IS SetCityCode()(SCP0007_BOD.cs L1440-1462,
     * SCP.SCP0007_GET_ROUTE_CNT). From/To Site 변경으로 City 가 확정된 행마다 재조회해
     * ROUTE_CNT 컬럼을 갱신한다. TO-BE SP(PKG_SCP0007.P_SCP0007_GET_ROUTE_CNT) 도 countryCity 와
     * 동일하게 PROC_M 만 등록되어 있고 버튼/API 배선이 없다(확인필요/DB 접속 불가로 미적용).
     */
    routeCnt: {
      request: {
        fromCity: string; // p_from_city
        toCity: string; // p_to_city
      };
      response: {
        o_rc1: {
          ROUTE_CNT: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0030 BOD Item (Supply Master). AS-IS SCP0030_BOD_ITEM.cs spdMain 2시트("BOD ITEM"/"Excluded Item").
   * GET/SAVE SP = PKG_SCP0030.P_SCP0030_{GET,SAVE}_BOD_{ITEM,EXCLUDED_ITEM} (배포 VALID, all_arguments/PROC_M
   * 실측 2026-09-26). GET 파라미터 COL_NM 은 PROC_M camelCase 그대로 — sesUserId/mnuId 는 BE 세션 자동주입.
   * bodItem GET 은 planGroupId 를 받지 않는다(AS-IS 메인 SP 미전달, 02 §5.3 확인필요1 — 비기능 유지).
   * O_RC1 컬럼은 03_grid-columns.md §1-A/§1-B DB 실측(all_source). 그리드 컬럼은 admin 동적(staticColumns)이라
   * 응답 타입은 로직 참조 컬럼 + index signature 로 둔다.
   */
  SCP0030: {
    bodItem: {
      request: {
        divisionId: string; // p_division_id (콤마 다중)
        fromSite: string; // p_from_site
        toSite: string; // p_to_site
        incoterms: string; // p_incoterms
        transMode: string; // p_trans_mode
        itemId: string; // p_item_id (콤마 다중)
        nickName: string; // p_nick_name
        valid: string; // p_valid
      };
      response: {
        o_rc1: {
          SEQ: string;
          DIVISION_ID: string;
          CUSTOMER: string;
          FROM_SITE_CODE: string;
          FROM_CITY: string;
          TO_SITE_CODE: string;
          TO_CITY: string;
          INCOTERMS: string;
          SAFETY_STOCK: string;
          TRANSPORT_MODE: string;
          ITEM_ID: string;
          NICK_NAME: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          PRIORITY: string;
          BOD_ITEM_VALID: string;
          BOD_VALID: string;
          ROUTE_VALID: string;
          ROUTE_ID: string;
          BOD_ID: string;
          LEAD_TIME: string;
          ORG_FROM_YYYYMMDD: string;
          ORG_TO_YYYYMMDD: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          [key: string]: string | number;
        };
      };
    };
    bodItemExcluded: {
      request: {
        divisionId: string; // p_division_id
        fromSite: string; // p_from_site
        toSite: string; // p_to_site
        incoterms: string; // p_incoterms
        transMode: string; // p_trans_mode
        itemId: string; // p_item_id
        nickName: string; // p_nick_name
        valid: string; // p_valid
        planGroupId: string; // p_plan_group_id (Excluded GET 은 plan group 파라미터를 받는다)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          ITEM_ID: string;
          NICK_NAME: string;
          BOD_ID: string;
          FROM_SITE_NAME: string;
          TO_SITE_NAME: string;
          INCOTERMS: string;
          TRANSPORT_MODE: string;
          BOD_EX_FROM_YYYYMMDD: string;
          BOD_EX_TO_YYYYMMDD: string;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * btnItemId Item-by-division 검색 팝업 + Excluded ITEM_ID 셀 더블클릭(02 §4.6, 03 §5-7).
     * AS-IS SCM0002_ItembyDivisionPopup(division/scmSite/itemId → ItemID). TO-BE 공용 컴포넌트 미존재라
     * 화면 로컬 모달로 신설. 주의: 이 팝업 조회 SP·API 배선은 PKG_SCP0030(4멤버=GET/SAVE ×2)에 없다 —
     * 배선 완비, 실행은 convert-sp 팝업 SP 배포 후(확인필요/SP 후속, SSP0025 ItemByDivisionModal 선례).
     */
    itemPopup: {
      request: {
        divisionId: string; // 전극 포함 division(UIUtils.GetAllDivisionCheckedElectrode)
        scmSite: string; // 선택 FromSite
        itemId: string; // 입력 Item ID(콤마 다중)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          ITEM_ID: string;
          MODEL_ID: string;
          NICK_NAME: string;
          FROM_SITE_CODE: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * Excluded BOD_ID 셀 더블클릭 → GetBODItem 팝업(03 §5-7). retList 다건 = cascade 신규행
     * (FROM_SITE_NAME/TO_SITE_NAME/BOD_ID/INCOTERMS/TRANSPORT_MODE) 채움. 조회 SP 미배포(convert-sp 후속).
     */
    bodPopup: {
      request: {
        divisionId: string;
        itemId: string;
        planGroup: string; // OPMZ_PLAN_GR_NAME
      };
      response: {
        o_rc1: {
          BOD_ID: string;
          FROM_SITE_NAME: string;
          TO_SITE_NAME: string;
          INCOTERMS: string;
          TRANSPORT_MODE: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0005 Distribution Route (Shipping Master, domain SSP — convert-react 전환). AS-IS
   * SCP0005_DistributionRoute.cs 단일 그리드 마스터. GET SP PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE
   * (SHT_NM='route'). O_RC 반환 41컬럼 = 그리드 39(Distribution Route 시트) + 보조 2(TRANSPORT_MODE_NAME,
   * DAYS 조합). design 03 §4.1 실측(SP body all_source + AS-IS 바이트 대조 1:1).
   */
  SCP0005: {
    route: {
      request: {
        fromCountry: string; // p_from_country ('ALL'/'' = 무필터)
        fromCity: string; // p_from_city
        toCountry: string; // p_to_country
        toCity: string; // p_to_city
        transportMode: string; // p_transport_mode (코드, 'ALL'/'' = 무필터)
        validYn: string; // p_valid_yn ('ALL' | 'Y' | 'N')
      };
      response: {
        o_rc1: {
          ROUTE_ID: string;
          LT_TYPE: string;
          VALID_YN: string;
          FROM_CITY_NAME: string;
          FROM_COUNTRY: string;
          FROM_CITY: string;
          TRANSPORT_MODE: string; // 코드 (셀 콤보 TransportModeCode)
          TRANSPORT_MODE_NAME: string; // 코드명 (보조 서브쿼리)
          PRIORITY: string;
          DAYS_MON: string;
          DAYS_TUE: string;
          DAYS_WED: string;
          DAYS_THU: string;
          DAYS_FRI: string;
          DAYS_SAT: string;
          DAYS_SUN: string;
          DAYS: string; // 요일 조합 'Mon, Tue, …' (보조)
          D_COUNTRY: string;
          D_PORT_CODE: string;
          D_PORT_NAME: string;
          A_COUNTRY: string;
          A_PORT_CODE: string;
          A_PORT_NAME: string;
          SHIPPING_COMPANY: string;
          TO_COUNTRY: string;
          TO_CITY: string;
          TO_CITY_NAME: string;
          SHIP_DOC_PREPARATION_DATE: string;
          LT_DEPARTURE_INLAND: string;
          LT_WAIT_SHIPPING: string;
          LT_VOYAGE: string;
          LT_LAY_OFF_CLEARANCE: string;
          LT_ARRIVAL_INLAND: string;
          LT_SUM: string;
          One_SEGMENT_COST: string; // = ATTRIBUTE1 (Pick Up Cost)
          Two_SEGMENT_COST: string; // = ATTRIBUTE2 (Freight Cost)
          Three_SEGMENT_COST: string; // = ATTRIBUTE3 (Delivery Cost)
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0028 Shipment Lot Size (Shipping Master, domain SSP — convert-react 전환). AS-IS
   * SCP0028_Shipment_Lot_Size.cs 단일 그리드 마스터 편집. GET SP PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE
   * (SHT_NM='main', IN 7 / OUT o_rc1 데이터 + O_RESULT_CURSOR). 반환 18컬럼 = SCM_MST_SHEET_COLUMNS
   * (PROGRAM_ID='SCP0028') 실측 18행(표시 15 + hidden 3). design 03 §1·§4.1 실측(all_arguments + PROC_M).
   *   - main    : 조회(GET) — 조회조건 7필드 → o_rc1 18컬럼
   *   - input   : 일괄입력 후보 조회(P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT, INSERT 버튼 API) — o_rc1 후보행
   *   - popup   : 일괄입력/삭제 팝업 후보(P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP, SHT_NM='popup') — o_rc1 후보행
   */
  SCP0028: {
    main: {
      request: {
        divisionId: string; // p_division_id (단일, 필수)
        operationGroup: string; // p_operation_group ('ALL'/'' = 무필터, 콤마 다중)
        fromSite: string; // p_from_site (콤마 다중, 'ALL'/'' = 무필터)
        toSite: string; // p_to_site (콤마 다중)
        transMode: string; // p_trans_mode (콤마 다중)
        itemId: string; // p_item_id (콤마 다중, Item 팝업 반환)
        valid: string; // p_valid ('ALL'->NULL | 'Y' | 'N')
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP_ID: string; // 셀 콤보 LookupCommon(OPERATION_GROUP) P/A/E
          FROM_SITE_DESCRIPTION: string;
          TO_SITE_DESCRIPTION: string;
          ITEM_ID: string;
          NICK_NAME: string;
          TRANS_MODE_NAME: string;
          TRANS_MODE_CODE: string; // hidden — 저장 키
          LOT_SIZE: string; // 편집 4컬럼(number, dataScale=0)
          INCREMENT: string; // 편집 4컬럼 — LOT_SIZE auto-sync 파생(design 03 §3-16)
          VALID_YN: string; // 편집 4컬럼(셀 콤보 YesOrNo)
          SPLIT_YN: string; // 편집 4컬럼(셀 콤보 YesOrNo)
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          FROM_SITE: string; // hidden — 저장 키
          TO_SITE: string; // hidden — 저장 키
          [key: string]: string | number;
        };
      };
    };
  } & {
    input: {
      request: {
        divisionId: string; // P_DIVISION_ID
        operationGroup: string; // P_OPERATION_GROUP (콤마 다중)
        fromSite: string; // P_FROM_SITE (콤마 다중)
        toSite: string; // P_TO_SITE (콤마 다중)
        itemId: string; // P_ITEM_ID (콤마 다중)
        userId: string; // P_USER_ID (세션)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP_ID: string;
          FROM_SITE_DESCRIPTION: string;
          TO_SITE_DESCRIPTION: string;
          ITEM_ID: string;
          NICK_NAME: string;
          TRANS_MODE_NAME: string;
          TRANS_MODE_CODE: string;
          LOT_SIZE: string;
          INCREMENT: string;
          VALID_YN: string;
          SPLIT_YN: string;
          FROM_SITE: string;
          TO_SITE: string;
          [key: string]: string | number;
        };
      };
    };
  } & {
    popup: {
      request: {
        divisionId: string; // P_DIVISION_ID
        operationGroup: string; // P_OPERATION_GROUP
        fromSite: string; // P_FROM_SITE
        toSite: string; // P_TO_SITE
        itemId: string; // P_ITEM_ID
        actionFlag: string; // P_ACTION_FLAG ('I' 일괄입력 / 'D' 일괄삭제)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP_ID: string;
          FROM_SITE: string;
          FROM_SITE_DESCRIPTION: string;
          TO_SITE: string;
          TO_SITE_DESCRIPTION: string;
          ITEM_ID: string;
          NICK_NAME: string;
          TRANS_MODE_CODE: string;
          TRANS_MODE_NAME: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0024 Production Plan Fix. GET SP(PKG_SCP0024.P_SCP0024_GET_PROD_PLAN_FIX)는 조회기간에 따라
   * 일자(D_YYYYMMDD)·주(W_)·월(M_) pivot 컬럼이 가변이라 고정 컬럼만 선언하고 나머지는 인덱스 시그니처로 받는다.
   */
  SCP0024: {
    main: {
      request: {
        divisionId: string; // P_DIVISION_ID (단일, 필수)
        operationGroup: string; // P_OPERATION_GROUP (단일, 필수)
        scmSiteId: string; // P_SCM_SITE_ID (콤마 다중, ''=무필터 — 'ALL' 전송 금지)
        lineId: string; // P_LINE_ID (콤마 다중, ''=무필터)
        itemId: string; // P_ITEM_ID (''=무필터)
        fromYyyymmdd: string; // P_FROM_YYYYMMDD
        toYyyymmdd: string; // P_TO_YYYYMMDD
        electrodeType: string; // P_ELECTRODE_TYPE (콤마 다중, ''=무필터)
        debugMode: string; // P_DEBUG_MODE ('F' 고정)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          OPERATION_GROUP: string;
          OPERATION_GROUP_NAME: string;
          SCM_SITE_ID: string;
          SCM_SITE_DESCRIPTION: string;
          OPERATION_ID: string;
          LINE_ID: string;
          ITEM_ID: string;
          NICK_NAME: string;
          ORIGIN_DIVISION_ID: string;
          ELECTRODE_TYPE: string;
          MEASURE: string; // 'Prod Plan' / 'Fix Reason' 행 축
          [key: string]: string | number; // D_YYYYMMDD / W_* / M_* pivot 컬럼
        };
      };
    };
  };

  /**
   * SCP0022 Formation (Supply Master). GET 결과 컬럼은 dbo.SCP0022_GET_* SP 별칭 기준(실측).
   * yield 계열은 서버가 %(x100)로 반환. EXCEPT/EXCEPT_LT 는 ORG_* 원본키를 함께 실어 온다.
   */
  SCP0022: {
    formation: {
      request: {
        divisionId: string;
        plantSiteId: string;
        itemId: string;
      };
      response: {
        formation: {
          DIVISION_ID: string;
          PLANT_SITE_ID: string;
          PLANT_SITE_NAME: string;
          ITEM_ID: string;
          NICK_NAME: string;
          SHIPMENT_PIC_USER: string;
          LT_FORMATION: string;
          ADD_LT_FORMATION: string;
          FORMATION_YIELD: string;
          CHAR_YIELD: string;
          FORMATION_TOTAL_YIELD: string;
          SSP_MODIFY_YIELD: string;
          FORMATION_ORDER: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          EDIT_FLAG: string;
        };
      };
    };
  } & {
    except: {
      request: {
        divisionId: string;
        plantSiteId: string;
        itemId: string;
      };
      response: {
        formationExcept: {
          division_id: string;
          plant_site_id: string;
          plant_site_name: string;
          item_id: string;
          nick_name: string;
          formation_start_date: string;
          formation_end_date: string;
          formation_yield: string;
          CHAR_YIELD: string;
          FORMATION_TOTAL_YIELD: string;
          except_comment: string;
          created_by: string;
          creation_date: string;
          last_updated_by: string;
          last_update_date: string;
          ORG_DIVISION_ID: string;
          ORG_PLANT_SITE_ID: string;
          ORG_ITEM_ID: string;
          ORG_FORMATION_START_DATE: string;
          ORG_FORMATION_END_DATE: string;
          EDIT_FLAG: string;
        };
      };
    };
  } & {
    exceptLt: {
      request: {
        divisionId: string;
        plantSiteId: string;
        itemId: string;
      };
      response: {
        formationExceptLt: {
          division_id: string;
          plant_site_id: string;
          plant_site_name: string;
          item_id: string;
          nick_name: string;
          formation_start_date: string;
          formation_end_date: string;
          LT_FORMATION: string;
          ADD_LT_FORMATION: string;
          except_comment: string;
          created_by: string;
          creation_date: string;
          last_updated_by: string;
          last_update_date: string;
          ORG_DIVISION_ID: string;
          ORG_PLANT_SITE_ID: string;
          ORG_ITEM_ID: string;
          ORG_FORMATION_START_DATE: string;
          ORG_FORMATION_END_DATE: string;
          EDIT_FLAG: string;
        };
      };
    };
  };

  /**
   * SCP0110 Demand Group Master (Supply Master). master/detail 이중 그리드 —
   *   groupName(Group Master siMain) / modelList(Model List siSub). GET OUT 커서 = o_rc1 (PROC_M 실측).
   *   요청 키 = PKG_SCP0110 PROC_M COL_NM(camelCase) 1:1(all_arguments 실측). SAVE 는 '^' delim 다건
   *   CLOB(activeFlag/divisionId/...) 라 apiClient.post 직접(useProcMutation 미사용).
   */
  SCP0110: {
    groupName: {
      request: {
        divisionId: string;
        operationGroup: string;
        groupName: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP: string;
          GROUP_ID: string;
          GROUP_NAME: string;
          ONLY_STOCK: string;
          PRE_KEY_VALUES: string;
        };
      };
    };
  } & {
    modelList: {
      request: {
        divisionId: string;
        operationGroup: string;
        groupId: string;
        groupName: string;
        projectId: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          PROJECT_CODE: string;
          PROJECT_NAME: string;
          ITEM_ID: string;
          GROUP_ID: string;
        };
      };
    };
  };

  /**
   * SCP0039 Master Validation (Supply Master). read-only 검증 대시보드.
   *   마스터 목록(12 검증유형)은 lookup MASTER_VALIDATION(admin/lookup)로 조회 — proc 아님(여기 미정의).
   *   아래 12 시트 = 검증유형별 GET SP dispatch(PKG_SCP0039 멤버). 요청 계약 공통
   *   (P_DIVISION_ID/P_SEARCH_TYPE/P_PLAN_GROUP_ID/P_ITEM_ID = all_arguments 실측). 결과는 sheetNm 별
   *   SCM_MST_SHEET_COLUMNS 메타 구동이라 행 타입은 동적(Record). itemSearch = Model/Item 팝업(SP 후속).
   */
  SCP0039: {
    bom: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    projectRoute: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    projectRouteElec: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    bod: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    lineAssign: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    tactTime: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    tactTimeOsp: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    outsourcingCapacity: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    stockOsp: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    planGroup: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    intransitInventory: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    yield: {
      request: { divisionId: string; searchType: string; planGroupId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  } & {
    itemSearch: {
      request: { divisionId: string; itemId: string };
      response: { o_rc1: { [key: string]: string | number } };
    };
  };
  /**
   * SCP0023 Outsourcing Capacity (Supply Master). 단일 그리드 — 외주(OSP) Plant 별 Model 의 Daily Capacity.
   * GET 결과 컬럼은 SCP0023_GET_OUTSOURCING_CAPA 반환 형상 기준(design 03 §4.1, lowercase colNm=SHEET_COLUMNS).
   *   item_id='-' 는 SP 가 'Total' 로 변환, capa_order 는 파생 정렬값. TO-BE PKG_SCP0023 미배포(convert-sp 후속).
   * 편집 컬럼 = daily_capa_qty(정수 최소1) + valid_yn. created_by/last_updated_by 는 저장 시 스칼라(단일값).
   */
  SCP0023: {
    main: {
      request: {
        divisionId: string;
        plantSiteId: string;
        itemId: string;
        nickName: string;
        valid: string;
        debugMode: string;
      };
      response: {
        o_rc1: {
          division_id: string;
          scm_site_id: string;
          vendor_code: string;
          vendor_name: string;
          item_id: string;
          nick_name: string;
          daily_capa_qty: string;
          capa_order: string;
          valid_yn: string;
          created_by: string;
          creation_date: string;
          last_updated_by: string;
          last_update_date: string;
        };
      };
    };
  };

  /**
   * SCP0015 Plan Management (Supply Plan). 그리드 2개(planMgmt/engineRun) + 비가시 데이터 채널(planConfirm).
   * 파라미터 키 = SCM_ADM_PROC_M COL_NM 실측(ora.py 2026-09-24). sesUserId 는 BE 세션 주입(FE 미전송),
   *   sesUserGrId 는 BE 미주입이라 FE 가 session.groupId 를 실어 보낸다(design 03 §4.2 — AS-IS p_group_id 누락 결함 미반복).
   * 커서 키 = o_rc(단수. o_rc1 아님 — PROC_M 실측). planMgmt 응답 o_rc2~o_rc8 = REVISION_NO 행별 콤보 후보
   *   7종(TE/TM/PR/MA/SE/FN/SU 순, design 03 §1.4/§4.2 — 한 응답에 후보 전량 동봉되는 특수 구조).
   * 저장 액션(EXECUTE/CONFIRM/STOP)은 MNU_BTN_CD 가 BUTTON_TYPE 밖이라 apiClient.post 수동 경로로 호출
   *   — 화면 코드(PlanManagement.tsx) 참조. RUN(EXECUTE) SP 본문은 P_RAISE_NOT_MIGRATED(convert-sp 백로그).
   */
  SCP0015: {
    planMgmt: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        planYear: string; // 2 P_PLAN_YEAR
        planWeek: string; // 3 P_PLAN_WEEK (비필수 — 빈값 허용)
        sesUserGrId: string; // 5 P_GROUP_ID (CONFIRM_AUTH/RUN_AUTH 판정 키 — FE session.groupId 필수)
      };
      response: {
        o_rc: {
          DIVISION_ID: string;
          DIVISION_NAME: string;
          PLAN_TYPE_DESCRIPTION: string;
          PLAN_TYPE: string;
          MODELING_ID: string;
          REVISION_NO: string;
          REVISION_DESC: string; // AS-IS 부터 미사용(무해)
          PLAN_STATUS_NAME: string;
          PLAN_STATUS: string; // 0=실행중 / 1=정상종료 / -1=에러종료 / -2=종료중
          CONFIRM_YN: string;
          CONFIRM_TIME: string;
          CONFIRM_USER: string;
          CONFIRM_AUTH: string; // 행별 Y/N
          RUN_AUTH: string; // 행별 Y/N
          CANCEL_AUTH: string; // 화면 미사용(CANCEL 버튼 미추가 — 사용자 확정 2026-09-24)
          [key: string]: string | number;
        };
      } & {
        [K in 'o_rc2' | 'o_rc3' | 'o_rc4' | 'o_rc5' | 'o_rc6' | 'o_rc7' | 'o_rc8']: {
          CODE: string; // REVISION_NO 후보
          NAME: string;
          MODELING_ID: string;
          PLAN_STATUS: string;
          PLAN_STATUS_NAME: string;
          PLAN_TYPE: string;
          PLAN_TYPE_DESCRIPTION: string;
          DISPLAY_SEQ: string | number;
          [key: string]: string | number;
        };
      };
    };
    engineRun: {
      request: {
        modelingId: string; // 1 P_MODELING_ID
        divisionId: string; // 2 P_DIVISION_ID
        revisionNo: string; // 3 P_REVISION_NO
      };
      response: {
        o_rc: {
          MODELING_ID: string;
          PLAN_ID: string;
          PLAN_NAME: string;
          DIVISION_ID: string;
          PLAN_TYPE: string;
          PLAN_SEQ: string | number;
          STEP_NAME: string; // ENGINE_RUN_STATUS lookup 4단계(10/20/30/40)
          STEP_PROCESS1: string; // SP 상시 '' — SetBGColor 진행바 캔버스 셀
          STEP_PROCESS2: string;
          STEP_PROCESS3: string;
          STEP_PROCESS4: string;
          STEP_STATUS: string; // -1/0/1 (색상 판정 키)
          START_TIME: string;
          END_TIME: string;
          [key: string]: string | number;
        };
        o_rc2: {
          PLAN_STATUS: string; // 대상 PLAN 의 현재 상태(폴링 중지 판정 키)
          PLAN_STATUS_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    planConfirm: {
      request: {
        modelingId: string; // 1 P_MODELING_ID
        divisionId: string; // 2 P_DIVISION_ID
        revisionNo: string; // 3 P_REVISION_NO
      };
      response: {
        o_rc: {
          CONFIRM_YN: string;
          CONFIRM_USER: string;
          CONFIRM_TIME: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0087 MDM Class Master (Supply Master). 단일 그리드 — 클래스 마스터 조회/편집.
   * 조회조건: Class ID(like) / Class Name(like) / Use Flag(Y/N/ALL, ALL->''). 자동조회 없음.
   * GET 결과 컬럼 = SCP0087_GET_MDM_CLASS_MASTER 반환 23컬럼(design 03 §4.2, uppercase alias=SHEET_COLUMNS colNm).
   *   GET 은 backfill side-effect(SCM_MST_ITEM_CLASS_SN->_M, 분류3칼럼 NULL) — convert-sp 소관.
   * SAVE = UPDATE-only 3컬럼(ITEM_TYPE/PROCESS_GROUP/PROCESS_DETAIL), USE_FLAG/CLASS_NAME 무반영(design 03 §4.4).
   *   USER_ID 는 @LoginUser 세션 주입(convert-core §3.5) — FE payload 미포함. TO-BE PKG_SCP0087 미배포(convert-sp 후속).
   */
  SCP0087: {
    main: {
      request: {
        classId: string;
        className: string;
        useFlag: string;
        debugMode: string;
      };
      response: {
        o_rc1: {
          CLASS_ID: string;
          CLASS_NAME: string;
          ITEM_TYPE: string;
          PROCESS_GROUP: string;
          PROCESS_DETAIL: string;
          LEVEL: string;
          LEVEL_1_CODE: string;
          LEVEL_1_NAME: string;
          LEVEL_1_ID: string;
          LEVEL_2_CODE: string;
          LEVEL_2_NAME: string;
          LEVEL_2_ID: string;
          LEVEL_3_CODE: string;
          LEVEL_3_NAME: string;
          LEVEL_3_ID: string;
          LEVEL_4_CODE: string;
          LEVEL_4_NAME: string;
          LEVEL_4_ID: string;
          USE_FLAG: string;
          INSERT_ID: string;
          INSERT_TIME: string;
          UPDATE_ID: string;
          UPDATE_TIME: string;
        };
      };
    };
  };

  /**
   * SCP0018 — Waterfall Shipment Plan Semi (Read-only Report, 보완 회차 v2)
   *
   * AS-IS: GSCM.SCP.Forms.UIL/Analysis/SCP0018_WaterfallShipmentPlanSemi.cs — 조회 전용
   * (Delete/Save 순수 NO-OP, Edit NO-OP+MSG00109). SHEETS(전부 SEARCH — 저장 없음):
   * - `main`         PKG_SCP0018.P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL (미배포 — convert-sp 후속)
   * - `spreadTitle`  PKG_SCP0009.P_SCP0009_GET_SHEET_CALENDAR_3SPAN[_ISO] (미배포 — convert-sp 후속)
   * 정본 분석: `.atlas/gscm-design/SCP0018/design/{00_checklist,01_layout,02_search-combo,03_grid-columns}.md`.
   * SP 미배포로 request/response 계약은 설계문서 §4.2/§2.6 역산치 — 배포 후 재검증 필요.
   */
  SCP0018: {
    main: {
      request: {
        fromYyyymmdd: string; // p_from_yyyymmdd
        toYyyymmdd: string; // p_to_yyyymmdd
        divisionId: string; // p_division_id
        operationGroup: string; // p_operation_group
        itemId: string; // p_item_id
        versionNo: string; // p_version_no (다중 — 구분자 확인 필요, 02_search-combo.md §7#4)
        electype: string; // p_electype (다중 — 구분자 확인 필요)
        programId: string; // p_program_id ('SCP0018' 고정)
        sheetName: string; // p_sheet_name (파생값 — OperationGroup=='A'?'CELL':'ELECTRODE')
        userId: string; // p_user_id
      };
      response: {
        o_rc1: {
          MEASURE: string;
          MEASURE_LABEL: string;
          [key: string]: string | number;
        };
      };
    };
    spreadTitle: {
      request: {
        startYyyymmdd: string; // p_start_yyyymmdd
        endYyyymmdd: string; // p_end_yyyymmdd
        userId: string; // p_user_id
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string;
          COLUMN_LABEL_NAME: string;
          MMDD_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * ProjectReg — SDM1010 (Project Registration · 프로젝트 등록)
   *
   * ⭐ 2026-08-13 신본 PKG_SDM1010(외부 전달 정본 — KTJ 2026.08.06/08.12) 계약으로 전면 재작성.
   *   원천 명세: scratchpad `PKG_SDM1010_NEW_CONTRACT.md` (15 SP 전량 — 커서 컬럼 순서 그대로 등재).
   * SHEETS (SEARCH — 커서명 'data'):
   * - `TAB1`       (§1 GET_TAB1_PJT_REG — 본인 MGMT_USER_ID 필터, 조회조건 없음. 35컬럼)
   * - `TAB2`       (§5 GET_TAB2_PJT_LIST — 콤보 'ALL' 센티널 + 'YYYY-MM-DD' 기간. 36컬럼)
   * - `POP1_TREE`  (§6 GET_POP_USER_ORG — 조직도. UPPER_DEPT_ID 트리)
   * - `POP1_GRID1` (§7 GET_POP_USER_BY_DEPT — deptId 有=부서 모드 / 無=userInfo 부분일치·NULL=0행)
   * - `POP1_GRID2` (§8 GET_POP_PJT_AUTH_WRITE — 입력(WRITE)·CONFIRM 사용자)
   * - `POP1_GRID3` (§9 GET_POP_PJT_AUTH_READ — 조회(READ)·CONFIRM 사용자, §8 동형)
   * - `POP1_GRID4` (§10 GET_POP_PJT_AUTH_REQ — 비CONFIRM(REQUEST/REJECT/NULL) 요청·이력)
   * - `POP2_GRID5` (§14 GET_POP_MY_WORK — SAMPLE_*_DATE 는 서버 placeholder 하드코딩)
   * - `period`     (§15 GET_PERIOD — TAB2 등록완료일 기본값. YMD_* 'YYYYMMDD' 문자열)
   * SAVE / REQ / CANCEL / 모달 SAVE·REJECT (§2·§3·§4·§11·§12·§13) 는 **행별 단건** apiClient.post 직접
   * (`features/sdm/src/pages/project-reg/utils/project-reg.api.ts` — 결과커서 CODE '0'+EVENT 건수 판정 의무)
   * — 타입 미등재 (DMF0042/0044 SAVE 계열 관행 동일).
   * sesUserId/mnuId 는 BE 세션 자동주입 — request 미포함. 미사용 IN 파라미터도 시그니처
   * 충족을 위해 request 에 포함한다 (sesDivisionId 등 — PROC_M COL_NM 등재분, §18-8).
   * 날짜 컬럼(SOP_DATE/REG_REQ_DATE/REG_COMP_DATE/SAMPLE_*)은 Oracle DATE 원형 → BE ISO 직렬화 수신.
   */
  SDM1010: {
    TAB1: {
      request: {
        sesDivisionId: string; // 1 P_SES_DIVISION_ID (SP 내 주석 처리 — 시그니처 충족용 '')
        userGroup: string; // 4 P_SES_USER_GR_ID (본문 미사용 — 시그니처 충족용 '')
      };
      response: {
        // §1 O_CURSOR 35컬럼 — 순서 그대로. ⚠ `DPJT_ATUH_*` 오타 alias 가 패키지 정본 (§18-10)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          DPJT_ATUH_REG_STR: string; // 리터럴 '권한등록' (링크 셀 텍스트)
          DPJT_ATUH_REG_STATUS: string; // 파생 WRITING/COMPLETE
          DPJT_ATUH_REG_STATUS_NAME: string;
          DPJT_ATUH_REG_STATUS_COLOR_TYPE: string; // Gray/Amber/Green/Red (TAG 색 데이터 주도)
          DEPT_ID: string;
          DEPT_NAME: string;
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DPJT_REG_STATUS: string; // DRAFT/WRITING/WAITING/COMPLETE/REJECT
          DPJT_REG_STATUS_NAME: string;
          DPJT_REG_STATUS_COLOR_TYPE: string;
          REG_REQ_DATE: string;
          [key: string]: string | number;
        };
      };
    };
    TAB2: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID ('ALL' 허용)
        endCustomer: string; // 2 P_END_CUSTOMER (= 값 OR 'ALL' — §5 등호 매칭·콤마 다중 불가)
        dpjtAuthType: string; // 3 P_DPJT_AUTH_TYPE (ADMIN/WRITE/READ or 'ALL')
        dpjtRegStatus: string; // 4 P_DPJT_REG_STATUS (or 'ALL')
        regCompDateFr: string; // 5 P_REG_COMP_DATE_FR ('YYYY-MM-DD' — 둘 다 채우거나 둘 다 빈 값)
        regCompDateTo: string; // 6 P_REG_COMP_DATE_TO ('YYYY-MM-DD' — 한쪽만 NULL=0행 §5)
      };
      response: {
        // §5 O_CURSOR 36컬럼 — 순서 그대로 (조회 전용)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          MY_WORK: string; // 리터럴 'My Work' (링크 셀 텍스트)
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          DPJT_AUTH_TYPE: string; // ADMIN/WRITE/READ (파생 'NONE' — §5 CASE)
          DPJT_AUTH_TYPE_NAME: string;
          DPJT_REG_STATUS: string;
          DPJT_REG_STATUS_NAME: string;
          DPJT_REG_STATUS_COLOR_TYPE: string;
          REG_COMP_DATE: string;
          DPJT_DEVELOP_STATUS: string;
          DPJT_DEVELOP_STATUS_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    POP1_TREE: {
      request: {
        sesDivisionId: string; // 1 P_SES_DIVISION_ID (본문 미사용 — 시그니처 충족용 '')
      };
      response: {
        // §6 O_CURSOR 6컬럼 — 트리 빌더는 UPPER_DEPT_ID 로 부모 연결
        data: {
          LEVEL_NO: string | number;
          DEPT_ID: string;
          DEPT_NAME: string; // = DEPT_NAME_KO
          UPPER_DEPT_ID: string;
          USER_COUNT: string | number;
          ORGN: string; // LPAD 들여쓰기 + DEPT_ID (표시용)
          [key: string]: string | number;
        };
      };
    };
    POP1_GRID1: {
      request: {
        userInfo: string; // 1 P_USER_INFO (UPPER(ID||NAME) LIKE 부분일치 — NULL=0행 §7)
        deptId: string; // 2 P_DEPT_ID (有=부서 모드·userInfo 무시 / 無=검색 모드)
        sesDivisionId: string; // 3 P_SES_DIVISION_ID (미사용 — 시그니처 충족용 '')
      };
      response: {
        // §7 O_CURSOR 6컬럼 (두 분기 동일)
        data: {
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    POP1_GRID2: {
      request: {
        dpjtKey: string; // 1 P_DPJT_KEY
        sesDivisionId: string; // 2 P_SES_DIVISION_ID (미사용 — 시그니처 충족용 '')
      };
      response: {
        // §8 O_CURSOR 7컬럼 — WRITE·CONFIRM 사용자
        data: {
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    POP1_GRID3: {
      request: {
        dpjtKey: string; // 1 P_DPJT_KEY
        sesDivisionId: string; // 2 P_SES_DIVISION_ID (미사용 — 시그니처 충족용 '')
      };
      response: {
        // §9 O_CURSOR 7컬럼 — READ·CONFIRM 사용자 (§8 동형)
        data: {
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    POP1_GRID4: {
      request: {
        dpjtKey: string; // 1 P_DPJT_KEY
        sesDivisionId: string; // 2 P_SES_DIVISION_ID (미사용 — 시그니처 충족용 '')
      };
      response: {
        // §10 O_CURSOR 12컬럼 — 비CONFIRM(REQUEST + REJECT·NULL 이력) 행. 처리 버튼은
        //   DPJT_AUTH_STATUS='REQUEST' 행만 활성 (FE 렌더 — PROCESS 는 SP '' 리터럴)
        data: {
          DPJT_AUTH_STATUS: string; // REQUEST/REJECT/NULL('')
          DPJT_AUTH_STATUS_NAME: string;
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DPJT_AUTH_TYPE: string; // WRITE/READ (요청 권한)
          DPJT_AUTH_TYPE_NAME: string;
          PROCESS: string; // '' 리터럴 — 처리 버튼 렌더 placeholder (메타 ATTRIBUTE1='REQ_ACTION')
          [key: string]: string | number;
        };
      };
    };
    POP2_GRID5: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID (SP 필터 주석 처리 — 시그니처 충족용 '')
        dpjtKey: string; // 2 P_DPJT_KEY (단건 필터)
      };
      response: {
        // §14 O_CURSOR 17컬럼 — ⚠ SAMPLE_A~D_DATE 는 SP 하드코딩 placeholder (정오표 기록)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          SAMPLE_A_DATE: string;
          SAMPLE_B_DATE: string;
          SAMPLE_C_DATE: string;
          SAMPLE_D_DATE: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    period: {
      request: {
        frBucket: string; // 1 P_FR_BUCKET (D/W/M — PW/Y 미구현 §15)
        frDateVal: string; // 2 P_FR_DATE_VAL (정수 문자열, 음수 가능)
        frBucketType: string; // 3 P_FR_BUCKET_TYPE (S/E/C)
        toBucket: string; // 4 P_TO_BUCKET (FR 과 동일 bucket 만 — §15 결함 ③ 회피)
        toDateVal: string; // 5 P_TO_DATE_VAL
        toBucketType: string; // 6 P_TO_BUCKET_TYPE (S/E/C — 'X'=From 만 반환)
      };
      response: {
        // §15 O_CURSOR — YMD_* 'YYYYMMDD' 문자열 소비 (DATE_* 직렬화 포맷 의존 회피)
        data: {
          DATE_FR: string;
          YMD_FR: string;
          DATE_TO: string;
          YMD_TO: string;
          [key: string]: string | number;
        };
      };
    };

    // ── ⭐ [2026-08-23] 공통소스(spms-demand) 계약 병합 ────────────────────────
    //   같은 SDM1010 을 두 구현이 서로 다른 시트명으로 쓴다:
    //     · features/sdm         (사내 정본) = TAB1/TAB2/POP1_*/period
    //     · features/spms-demand (공통소스)  = project/myProject/popup*
    //   한쪽만 두면 반대쪽이 TS2344(시트 제약 위반)로 전멸한다. 키가 겹치지 않아 **합집합**으로 둔다.

    // TAB1 — 프로젝트 등록.
    project: {
      request: {
        sesDivisionId: string;
        sesUserId: string;
        sesMenuId: string;
        sesUserGrId: string;
      };
      response: {
        projectList: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          DPJT_ATUH_REG_STR: string;
          DPJT_ATUH_REG_STATUS: string;
          DPJT_ATUH_REG_STATUS_NAME: string;
          DPJT_ATUH_REG_STATUS_COLOR_TYPE: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DPJT_REG_STATUS: string;
          DPJT_REG_STATUS_NAME: string;
          DPJT_REG_STATUS_COLOR_TYPE: string;
          REG_REQ_DATE: string;
        };
      };
    };
    // TAB2 — 나의 프로젝트 현황.
    myProject: {
      request: {
        divisionId: string;
        endCustomer: string;
        dpjtAuthType: string;
        dpjtRegStatus: string;
        regCompDateFr: string;
        regCompDateTo: string;
        sesUserId: string;
      };
      response: {
        myProjectList: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string;
          MY_WORK: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          DPJT_AUTH_TYPE: string;
          DPJT_AUTH_TYPE_NAME: string;
          DPJT_REG_STATUS: string;
          DPJT_REG_STATUS_NAME: string;
          DPJT_REG_STATUS_COLOR_TYPE: string;
          REG_COMP_DATE: string;
          DPJT_DEVELOP_STATUS: string;
          DPJT_DEVELOP_STATUS_NAME: string;
        };
      };
    };
    // 권한관리 팝업 — 조직도.
    popupOrg: {
      request: {
        sesDivisionId: string;
        sesUserId: string;
      };
      response: {
        orgList: {
          LEVEL_NO: number;
          DEPT_ID: string;
          DEPT_NAME: string;
          UPPER_DEPT_ID: string | null;
          USER_COUNT: number;
          ORGN: string;
        };
      };
    };
    // 권한관리 팝업 — 조직 노드별 사용자 목록. P_SDM1010_GET_POP_USER_BY_DEPT.
    popupUser: {
      request: {
        userInfo: string;
        deptId: string;
        sesDivisionId: string;
        sesUserId: string;
      };
      response: {
        userList: {
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
        };
      };
    };
    // 권한관리 팝업 — 패키지의 WRITE/READ 조회·저장 프로시저를 각각 호출한다.
    popupAuthWrite: {
      request: {
        pjtKey: string;
        sesDivisionId: string;
        sesUserId: string;
      };
      response: {
        authWriteList: {
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
        };
      };
    };
    popupAuthRead: {
      request: {
        pjtKey: string;
        sesDivisionId: string;
        sesUserId: string;
      };
      response: {
        authReadList: {
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
        };
      };
    };
    // 권한관리 팝업 — 권한 요청(승인/반려 대상) 리스트.
    // 승인은 WRITE/READ 전체 목록 저장으로 반영하고, 반려는 SAVE_POP_BTN_REJECT를 호출한다.
    popupAuthReq: {
      request: {
        pjtKey: string;
        sesDivisionId: string;
        sesUserId: string;
      };
      response: {
        authRequestList: {
          DPJT_AUTH_STATUS: string;
          DPJT_AUTH_STATUS_NAME: string;
          DPJT_KEY: string;
          USER_ID: string;
          USER_NAME: string;
          JOB_CODE: string;
          JOB_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DPJT_AUTH_TYPE: string;
          DPJT_AUTH_TYPE_NAME: string;
          PROCESS: string;
        };
      };
    };
    // My Work 팝업 — 샘플 일정 상세. SDM1010_GET_POP_MY_WORK.
    // (화면설계서 §확인사항 "상세 내역은 추가 예정" — 명시된 표만 반영, 나머지는 미정)
    popupMyWork: {
      request: {
        divisionId: string;
        pjtKey: string;
        sesUserId: string;
      };
      response: {
        scheduleList: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          SAMPLE_A_DATE: string;
          SAMPLE_B_DATE: string;
          SAMPLE_C_DATE: string;
          SAMPLE_D_DATE: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
        };
      };
    };
  };

  /**
   * ProjectList — SDM1020 (Project List · 프로젝트 조회/변경)
   *
   * ⭐ 계약 단일 원천 = `_artifacts/_apply_corporate/SDM1020_META_20260819/_CONTRACT.md`
   *   (PROC_M COL_NM = payload 키 — ALL_ARGUMENTS positional 29=29 실측. 원문 = PKG_SDM1020.txt).
   * SHEETS (SEARCH — 커서명 'data'):
   * - `Project List` (P_SDM1020_GET_PJT_LIST — SHT_NM 실명(공백 포함), API_ID 시트 토큰 'main'.
   *   커서 41컬럼 — 메타 30 + 보조 NAME 계열. ⚠ D1: DPJT_AUTH_REQ_READ 는 커서에 동명 2회 SELECT —
   *   FE 는 컬럼명 1회 바인딩(마지막 값 승리 의존 금지). ⚠ D2: 권한요청 TAG 의 NAME/COLOR 커서 실명 =
   *   `DPJT_AUTH_REQ_WRITE_NAME`/`_WRITE_COLOR_TYPE`. `DPJT_AUTH_REQ_LINK` 는 FE 파생 — 커서 미반환)
   * - `period` (PR_GET_DAY_RANGE 공유 — SDM1020_period_SEARCH. 실서명 2-IN createdBy/month —
   *   설계서의 P_FR_BUCKET 7-인자 서명은 실물과 다름, 계약 ⑤)
   * BTN 계열 2본은 **행별 단건** apiClient.post 직접
   * (`features/sdm/src/pages/project-list/utils/project-list.api.ts` — 결과커서 CODE '0'+EVENT 판정
   * 의무. SDM1010 SAVE 계열 관행 동일 — 타입 미등재. COL_NM 계약 ①):
   * - REQ    = PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG (15 IN — activeFlag/dpjtKey/dpjtCode/dpjtSeq/
   *   divisionId/dpjtClass/endCustomer/dpjtName/cellType/stackMethod/bizType/sopDate/sopPlantId
   *   + sesUserId(BE주입) → result)
   * - AUTHREQ = PKG_SDM1020.P_SDM1020_REQ_PJT_AUTH (5 IN — dpjtKey/dpjtAuthReqWrite/dpjtAuthReqRead
   *   + sesUserId(BE주입) → result)
   * sesUserId/mnuId 는 BE 세션 자동주입 — request 미포함.
   * 날짜 컬럼(SOP_DATE/REG_COMP_DATE)은 Oracle DATE 원형 → BE ISO 직렬화 수신.
   */
  SDM1020: {
    'Project List': {
      request: {
        divisionId: string; // 1 P_DIVISION_ID (단일 필수 — MyDivision)
        endCustomer: string; // 2 P_END_CUSTOMER (콤마 다중 or 'ALL' — UF_FX_STRING_SPLIT)
        dpjtAuthType: string; // 3 P_DPJT_AUTH_TYPE (ADMIN/WRITE/READ/NONE 콤마 다중 or 'ALL')
        dpjtRegStatus: string; // 4 P_DPJT_REG_STATUS (콤마 다중 or 'ALL')
        regCompDateFr: string; // 5 P_REG_COMP_DATE_FR ('YYYY-MM-DD' — 필수, TO_DATE SUBSTR 1..10)
        regCompDateTo: string; // 6 P_REG_COMP_DATE_TO ('YYYY-MM-DD' — 필수)
      };
      response: {
        // O_CURSOR — SELECT 순서 그대로 (PKG_SDM1020.txt L136~219 실측)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          DIVISION_ID: string;
          DIVISION_NAME: string; // ⚠ D8: DIVISION_ID 재-alias (CODE=NAME — as-is 수용)
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string; // ⚠ D8: SCM_SITE_ID 재-alias
          DEPT_ID: string;
          DEPT_NAME: string; // = DEPT_NAME_KO
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DPJT_AUTH_TYPE: string; // ADMIN/WRITE/READ (REQUEST 상태 = 'NONE' 치환)
          DPJT_AUTH_TYPE_NAME: string;
          DPJT_REG_STATUS: string; // TAG (lookup SPMS_DPJT_REG_STATUS — P-22 도메인)
          DPJT_REG_STATUS_NAME: string;
          DPJT_REG_STATUS_COLOR_TYPE: string;
          REG_COMP_DATE: string;
          DPJT_DEVELOP_STATUS: string;
          DPJT_DEVELOP_STATUS_NAME: string;
          DPJT_AUTH_MGMT: string; // ADMIN=''(NULL — 링크 노출) / 그 외 '-' (P-02)
          DPJT_AUTH_REQ_STATUS: string; // ADMIN+요청存 = '권한요청' / 그 외 NULL (TAG)
          DPJT_AUTH_REQ_WRITE_NAME: string; // D2 — 권한요청 TAG NAME (커서 실명)
          DPJT_AUTH_REQ_WRITE_COLOR_TYPE: string; // D2 — 'warning-major'
          DPJT_AUTH_REQ_WRITE: string; // 3상태 DISABLED/CHECKED/UNCHECKED (P-04)
          DPJT_AUTH_REQ_READ: string; // 3상태 (⚠ D1: 커서 동명 2회 — 판정 CASE 동일·1회 바인딩)
          MOD_ROW_YN: string; // 행 편집 가능 여부 (Y인 행만 편집 가능)
          [key: string]: string | number;
        };
      };
    };
    period: {
      // PR_GET_DAY_RANGE PROC_M 공유 (실서명 2-IN — 계약 ⑤. o_rc2 = 월 경계 'YYYYMMDD:YYYYMMDD')
      request: {
        createdBy: string; // 1 P_CREATED_BY (SP NVL 가드 — '')
        month: string; // 2 P_MONTH (당월 1일 앵커 소비 — M-1~Today 는 FE dayjs 병행, 계약 ⑤)
      };
      response: {
        o_rc1: { DAY_RANGE: string; [key: string]: string | number };
        o_rc2: { DAY_RANGE: string; [key: string]: string | number };
      };
    };
  };

  /**
   * ProjectMaster — SDM5010 (Project Master · 프로젝트 등록 요청 승인/반려 + Master 관리)
   *
   * ⭐ 계약 단일 원천 = `_artifacts/_apply_corporate/SDM5010_META_20260819/_CONTRACT.md`
   *   (PROC_M COL_NM = payload 키 — ALL_ARGUMENTS positional 44=44 실측. 원문 = PKG_SDM5010.txt
   *   치명 결함 정정본 02_PKG_SDM5010.sql — D1~D6·D10~D13 정정 승인 반영).
   * SHEETS (SEARCH — 커서명 'data'):
   * - TAB1 (P_SDM5010_GET_TAB1_PJT_REG_REQ — Session 4 IN. SP 내부 필터 = DIVISION_ID=P_SES_DIVISION_ID
   *   + MGMT_USER_ID=P_SES_USER_ID(본인 — 설계 원문 유지 사용자 확정 D14) + WAITING/REQ_MOD. 조회조건 미소비 F-3)
   * - TAB2 (P_SDM5010_GET_TAB2_PJT_MASTER — 멀티 콤마 4축 + 'ALL' 무필터 + REG_COMP_DATE BETWEEN.
   *   ⚠ 커서 REG_COMP_DATE 2회 중복(D16) — FE 는 컬럼명 1회 바인딩(첫 출현) 의존)
   * - period (PKG_SDM1010.P_SDM1010_GET_PERIOD 공유 배선 — SDM5010_period_SEARCH. 계약 ① 재사용)
   * BTN 계열 3본은 **행별 단건** apiClient.post 직접
   * (`features/sdm/src/pages/project-master/utils/project-master.api.ts` — 결과커서 CODE '0'+EVENT
   * 판정 의무. COL_NM 계약 ①):
   * - CONFIRM = PKG_SDM5010.P_SDM5010_BTN_TAB1_CONFIRM (15 IN — dpjtKey/dpjtCode/dpjtSeq/
   *   dpjtKeyParent/divisionId/dpjtClass/endCustomer/dpjtName/cellType/stackMethod/bizType/
   *   sopDate/sopPlantId/note + sesUserId(BE주입) → result)
   * - CANCEL = PKG_SDM5010.P_SDM5010_BTN_TAB1_CANCEL (5 IN — divisionId/dpjtKey/dpjtKeyParent/note
   *   + sesUserId(BE주입) → result)
   * - SAVE = PKG_SDM5010.P_SDM5010_SAVE_TAB2_PJT_MASTER (5 IN — activeFlag('M' 단건만 유효)/
   *   dpjtKey/dpjtDevelopStatus/disabled('CHECKED' 정확 일치만 DISABLED — 계약 ⑥) + sesUserId(BE주입) → result)
   * sesUserId/mnuId 는 BE 세션 자동주입 — request 미포함.
   * 날짜 컬럼(SOP_DATE/REG_REQ_DATE/REG_COMP_DATE)은 Oracle DATE 원형 → BE ISO 직렬화 수신.
   */
  SDM5010: {
    TAB1: {
      request: {
        sesDivisionId: string; // 1 P_SES_DIVISION_ID (SP WHERE 실사용 — 조회조건 Division 전달)
        userGroup: string; // 4 P_SES_USER_GR_ID (수신만·본문 미사용 D7 — 시그니처 충족용 '')
      };
      response: {
        // 계약 ⑤ O_CURSOR 36컬럼 — callproc 실측 순서 그대로. ⚠ `DPJT_ATUH_*` 오타 alias 유지 확정(F-12)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_CODE_MOD_YN: string;
          DPJT_SEQ: string | number;
          DPJT_REG_CAT: string; // 구분 신규/수정('MOD') — 행 색상 축 (P-05)
          DPJT_REG_CAT_NAME: string;
          DIVISION_ID: string;
          DIVISION_NAME: string; // ⚠ D8: DIVISION_ID 재-alias (CODE=NAME — as-is 수용)
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string; // ⚠ D8: SCM_SITE_ID 재-alias
          DEPT_ID: string;
          DEPT_NAME: string;
          DEPT_NAME_KO: string;
          DEPT_NAME_EN: string;
          DEPT_NAME_CN: string;
          MGMT_USER_ID: string;
          USER_NAME: string;
          USER_NAME_EN: string;
          DPJT_ATUH_REG_STR: string; // 리터럴 '권한관리' (링크 셀 — 커서 실명 유지 F-12)
          DPJT_ATUH_REG_STATUS: string; // 파생 WRITING/COMPLETE (TAG)
          DPJT_ATUH_REG_STATUS_NAME: string;
          DPJT_ATUH_REG_STATUS_COLOR_TYPE: string; // Gray/Amber/Green/Red (TAG 색 데이터 주도)
          NOTE: string;
          REG_COL: string; // '' 리터럴 — 승인/반려 행 버튼 placeholder (메타 ATTRIBUTE1='REG_ACTION' F-15)
          DPJT_KEY_PARENT: string;
          [key: string]: string | number;
        };
      };
    };
    TAB2: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID (단일 필수 — MyDivision. UF_FX_STRING_SPLIT 테이블화)
        endCustomer: string; // 2 P_END_CUSTOMER (콤마 다중 or 'ALL' — UC-06)
        cellType: string; // 3 P_CELL_TYPE (콤마 다중 or 'ALL')
        bizType: string; // 4 P_BIZ_TYPE (콤마 다중 or 'ALL')
        dpjtDevelopStatus: string; // 5 P_DPJT_DEVELOP_STATUS (콤마 다중 or 'ALL')
        regCompDateFr: string; // 6 P_REG_COMP_DATE_FR ('YYYY-MM-DD' — TO_DATE SUBSTR 1..10)
        regCompDateTo: string; // 7 P_REG_COMP_DATE_TO ('YYYY-MM-DD')
      };
      response: {
        // 계약 ⑤ O_CURSOR 36컬럼 — ⚠ REG_COMP_DATE 2회 중복(D16) → 첫 출현 1회 바인딩(타입은 1회 등재)
        data: {
          DPJT_KEY: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          DPJT_REG_CAT: string;
          DPJT_REG_CAT_NAME: string;
          DIVISION_ID: string;
          DIVISION_NAME: string;
          DPJT_CLASS: string;
          DPJT_CLASS_NAME: string;
          END_CUSTOMER: string;
          END_CUSTOMER_NAME: string;
          DPJT_NAME: string;
          CELL_TYPE: string;
          CELL_TYPE_NAME: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          BIZ_TYPE: string;
          BIZ_TYPE_NAME: string;
          SOP_DATE: string;
          SOP_PLANT_ID: string;
          SOP_PLANT_NAME: string;
          NOTE: string;
          REG_REQ_DATE: string;
          REG_COMP_DATE: string;
          CNFM_USER_ID: string;
          CNFM_USER_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          DPJT_ATUH_REG_STR: string; // 리터럴 '권한관리' (링크 셀)
          DPJT_ATUH_REG_STATUS: string; // TAG
          DPJT_ATUH_REG_STATUS_NAME: string;
          DPJT_ATUH_REG_STATUS_COLOR_TYPE: string;
          DPJT_DEVELOP_STATUS: string; // 편집 콤보 DpjtDevelopStatus (P-12)
          DPJT_DEVELOP_STATUS_NAME: string;
          DISABLE_YN: string; // CHECKED/UNCHECKED (계약 ⑥ — DPJT_MGMT_STATUS='DISABLED' 표현)
          [key: string]: string | number;
        };
      };
    };
    period: {
      // PKG_SDM1010.P_SDM1010_GET_PERIOD 공유 배선 (계약 ① — SDM1010 period 시트와 동일 소비 패턴)
      request: {
        frBucket: string; // 1 P_FR_BUCKET (D/W/M)
        frDateVal: string; // 2 P_FR_DATE_VAL (정수 문자열, 음수 가능)
        frBucketType: string; // 3 P_FR_BUCKET_TYPE (S/E/C)
        toBucket: string; // 4 P_TO_BUCKET (FR 과 동일 bucket 만)
        toDateVal: string; // 5 P_TO_DATE_VAL
        toBucketType: string; // 6 P_TO_BUCKET_TYPE (S/E/C/X)
      };
      response: {
        // YMD_* 'YYYYMMDD' 문자열 소비 — YMD_FR = M-1 앵커, To=Today 는 FE dayjs 병행 (E01-2)
        data: {
          DATE_FR: string;
          YMD_FR: string;
          DATE_TO: string;
          YMD_TO: string;
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * ProductionRequest — SDM2010 (Production Request · 샘플 수요 > 샘플제작 요청 > 생산 요청)
   *
   * ⭐ 정본 원천 = 화면설계서 SDM2010_ProdReq_화면설계서_20260824.xlsx (순수 신규 — AS-IS 부재).
   * SHEETS (SEARCH — 커서명 'data'):
   * - tree (P_SDM2010_GET_PJT_SAMPLE_TREE — P_SES_DIVISION_ID + P_SES_USER_ID(BE주입).
   *   커서 = 고객 > 프로젝트 > 빌드 No. flat 행 — FE 가 3-level Tree 로 변환)
   * - process (P_SDM2010_GET_PJT_SAMPLE_PROCESS — P_DPJT_CODE/P_DPJT_BUILD_NO + Session)
   * - build (P_SDM2010_GET_PJT_SAMPLE_BUILD — 동일 IN. 단건 커서 — 빌드 패널 조회 모드)
   * - demand (⚠ 설계서 샘플수요등록 시트의 조회 SP 가 Tree SP 로 기재(복붙 정황) —
   *   수요 그리드 전용 GET/SAVE SP 는 PROC_M 등재 시 확정. 커서 컬럼도 미확정이라 index
   *   signature 만 등재)
   * BTN 계열 2본은 **단건/행별 단건** apiClient.post 직접 (utils/production-request.api.ts —
   *   결과커서 CODE '0'+EVENT 판정 의무):
   * - SAVEBUILD = PKG_SDM2010.P_SDM2010_SAVE_PJT_SAMPLE_BUILD (⚠ 설계서 IN 에
   *   P_DPJT_BUILD_SEQ 2회(빌드/묶음) — 묶음은 P_DPJT_BIND_SEQ 오기로 보고 bindSeq 전달)
   * - SAVE(demand) = PKG_SDM2010.P_SDM2010_SAVE_PJT_SAMPLE_DEMAND (행별 단건 —
   *   '^' bulk join 금지, SDM1020 확정 계보)
   * sesUserId 는 BE 세션 자동주입(NDaoInterface._selectList) — request/payload 미포함.
   *   sesDivisionId 는 자동주입 아님 — FE 세션값으로 전달.
   * ⚠ 커서 컬럼명은 SP 미작성 상태의 FE 선행 계약 — PKG_SDM2010 작성/등재 시 실측 대조 필수.
   */
  SDM2010: {
    tree: {
      request: {
        sesDivisionId: string; // 1 P_SES_DIVISION_ID (Session 정보 참조)
      };
      response: {
        // flat 행 — LEVEL_NO 1 고객 / 2 프로젝트 코드 / 3 빌드 No. (FE 3-level Tree 조립)
        data: {
          LEVEL_NO: string | number;
          ITEM_ID: string; // 표시·키 (레벨 3 = 'A1-N1' 표시값)
          UPPER_ITEM_ID: string; // 부모 키 (level 1 = NULL)
          IN_PROGRESS: string; // 'PROGRESS' = 진행 중 빌드 보유 (상위 레벨 집계)
          DPJT_BUILD_NO: string; // level 3 빌드 No (예 '26VW01-A1-N1') — 조회 트리거
          DPJT_AUTH_TYPE: string; // 권한(ADMIN, WRITE, READ)
          [key: string]: string | number;
        };
      };
    };
    process: {
      request: {
        dpjtCode: string; // 1 P_DPJT_CODE (Tree 선택)
        dpjtBuildNo: string; // 2 P_DPJT_BUILD_NO (Tree 선택)
        sesDivisionId: string; // 3 P_SES_DIVISION_ID
      };
      response: {
        // 단계 7종 = lookup SPMS_DPJT_BUILD_PROCESS 전수 + SPMS_PROJECT_PROCESS LEFT JOIN (단계명·상태 단일 원천)
        data: {
          DPJT_BUILD_PROCESS: string; // PROD_REQ / PLAN_YIELD / SPEC / QTY_CNF / REQ_APPROV / PROD_APPROV / PROD_PLAN
          DPJT_BUILD_PROCESS_NAME: string;
          PROCESS_STATUS: string; // DONE / INPROGRESS / STANDBY / DISABLED
          PROGRESS_CNT: string | number;
          TARGET_CNT: string | number;
          [key: string]: string | number;
        };
      };
    };
    build: {
      request: {
        dpjtCode: string; // 1 P_DPJT_CODE (Tree 선택 정보)
        dpjtBuildNo: string; // 2 P_DPJT_BUILD_NO (Tree 선택 정보)
        sesDivisionId: string; // 3 P_SES_DIVISION_ID (Session 정보 참조)
      };
      response: {
        // 빌드 패널 조회 모드 — 단건 커서 (설계서 GRID LEFT Default View)
        data: {
          DPJT_CODE: string;
          STACK_METHOD: string;
          DPJT_BUILD_NO: string;
          DPJT_BUILD_TYPE: string; // 빌드 차수 구분 (A/B/…)
          DPJT_BUILD_SEQ: string | number;
          DPJT_BIND_TYPE: string; // 묶음 차수 구분
          DPJT_BIND_SEQ: string | number;
          NOTE: string;
          [key: string]: string | number;
        };
      };
    };
    demand: {
      request: {
        dpjtCode: string; // 1 P_DPJT_CODE (Tree 선택 정보)
        dpjtBuildNo: string; // 2 P_DPJT_BUILD_NO (Tree 선택 정보)
        sesDivisionId: string; // 3 P_SES_DIVISION_ID (Session 정보 참조)
      };
      response: {
        // 컬럼은 admin 메타(staticColumns) 100% 주도 — SP/커서 미확정이라 index signature 만
        // 수율/Loss 계획 점검 — SPMS_PROJECT_YIELD_MGMT_DTL (없으면 lookup SPMS_YIELD_FACTOR 템플릿 행)
        data: {
          DPJT_BUILD_NO: string;
          DPJT_KEY: string;
          DPJT_USE_TYPE: string; // 용도구분
          REQ_ROUTE: string; // 요청공정
          DPJT_USE_TYPE_DETAIL: string; // 용도상세
          REQ_QTY: string | number;     // 요청수량
          UOM: string;                  // 단위
          ITEM_ID: string;              // 생산코드
          CELL_ID: string;              // 셀코드
          SHIP_REQ_DATE: string;        // 출하필요일
          SAMPLE_PROCESS_TYPE: string;  // 처리 유형
          PROCESS_PLAN_DATE: string;    // 처리 예정일
          PIC_USER_ID: string;          // PIC
          DPJT_MGMT_NO: string;         // 관리 No.
          NOTE: string;                 // 변경사유
          DIVISION_ID: string;
          CELL_TYPE: string;
          STACK_METHOD: string;
          BIZ_TYPE: string;
          DPJT_CLASS: string;
          [key: string]: string | number;
        };

      };
    };
  };
  /**
   * PlanYield — SDM2020 (계획수율 · 샘플 수요 > 샘플제작 요청 > 계획수율)
   *
   * ⭐ 정본 원천 = `Doc/화면설계서_SDM/SDM2020/계획수율_20260828.xlsx`(UI 목업) +
   *   `테이블 명세_v1.0_20260828.xlsx`(SPMS_PROJECT_YIELD_MGMT_MST/DTL) + 사내 DB `PKG_SDM2020`
   *   (2026-08-31 ALL_SOURCE 실측 — 화면설계서 없음, AS-IS 부재). 정오표 =
   *   `Doc/화면분석서/SDM2020_PlanYield_정오표.md`.
   * SHEETS (SEARCH — 커서명 'data'):
   * - tree / process / build = PKG_SDM2020.P_SDM2020_GET_PJT_SAMPLE_TREE / _PROCESS / _BUILD (DB 실존.
   *   SDM2010 과 동일 계약 — 공용 components/sample-status-tree · sample-process-flow 가 소비)
   * - build 는 커서 2본: 'data'(헤더 단건) + 'plant'(공정별 요청법인 — O_PLANT_CURSOR, 2026-09-03 추가.
   *   행 원천 lookup SPMS_REQ_OPERATION(수율 ATTRIBUTE8='Y') + SPMS_PROJECT_YIELD_MGMT_MST LEFT JOIN)
   * - yield = PKG_SDM2020.P_SDM2020_GET_PJT_YIELD (2026-09-04 추가. 행 원천 lookup SPMS_YIELD_TABLE —
   *   사업부/공정그룹/공정 일치, 법인 SEGMENT2·공법 SEGMENT4 는 개별 행 우선 없으면 'ALL' —
   *   + SPMS_PROJECT_YIELD_MGMT_DTL LEFT JOIN(선택/Delta 조정/비고/버전))
   * BTN 2본은 '^' 벌크 1건 call-proc 직접 (utils/plan-yield.api.ts — CODE '0'+EVENT 판정):
   * - SAVEPLANT(plant) = PKG_SDM2020.P_SDM2020_SAVE_PJT_SAMPLE_BUILD (P_OPERATION_ID 전달 시 요청법인
   *   저장 모드 — SPMS_PROJECT_YIELD_MGMT_MST Build 단위 DELETE 후 INSERT. dpjtKey 는 SP 가 해석)
   * - CONFIRM(yield)  = PKG_SDM2020.P_SDM2020_SAVE_PJT_YIELD (선택 공정 단위 DTL DELETE 후 템플릿+편집값 INSERT)
   * sesUserId 는 BE 세션 자동주입 — payload 미포함. sesDivisionId 는 FE 세션값 전달.
   */
  SDM2020: {
    tree: {
      request: {
        sesDivisionId: string; // 1 P_SES_DIVISION_ID (Session)
      };
      response: {
        // flat 행 — LEVEL_NO 1 고객 / 2 프로젝트 코드 / 3 빌드 No. (FE 3-level Tree 조립)
        data: {
          LEVEL_NO: string | number;
          ITEM_ID: string; // 표시·키 (레벨 3 = 'A1-N1' 표시값)
          UPPER_ITEM_ID: string; // 부모 키 (레벨 1 = NULL)
          IN_PROGRESS: string; // 'PROGRESS' = 진행 중 빌드 보유 (상위 레벨 집계)
          DPJT_BUILD_NO: string; // 레벨 3 실키 (예 '26VW01-A1-N1') — 조회 트리거
          [key: string]: string | number;
        };
      };
    };
    process: {
      request: {
        dpjtCode: string; // 1 P_DPJT_CODE (Tree 선택)
        dpjtBuildNo: string; // 2 P_DPJT_BUILD_NO (Tree 선택)
        sesDivisionId: string; // 3 P_SES_DIVISION_ID
      };
      response: {
        // 단계 7종 = lookup SPMS_DPJT_BUILD_PROCESS 전수 + SPMS_PROJECT_PROCESS LEFT JOIN (단계명·상태 단일 원천)
        data: {
          DPJT_BUILD_PROCESS: string; // PROD_REQ / PLAN_YIELD / SPEC / QTY_CNF / REQ_APPROV / PROD_APPROV / PROD_PLAN
          DPJT_BUILD_PROCESS_NAME: string;
          PROCESS_STATUS: string; // DONE / INPROGRESS / STANDBY / DISABLED
          PROGRESS_CNT: string | number;
          TARGET_CNT: string | number;
          // 단계가 열리는 화면 메뉴 ID (lookup ATTRIBUTE1 — 예 SDM2010 / SDM2020).
          //   ProcessFlow 단계 클릭 이동의 단일 원천. SP 가 이 컬럼을 SELECT 해야 클릭이 동작한다.
          ATTRIBUTE1?: string;
          [key: string]: string | number | undefined;
        };
      };
    };
    build: {
      request: {
        dpjtCode: string;
        dpjtBuildNo: string;
        sesDivisionId: string;
      };
      response: {
        // 단건 — 샘플 요청 법인 패널 헤더 (D-PJT 코드 / 빌드 차수 / 공법 / 특이사항)
        data: {
          DPJT_KEY: string;
          DPJT_CLASS: string;
          MGMT_USER_ID: string;
          DPJT_CODE: string;
          DPJT_SEQ: string | number;
          DPJT_NAME: string;
          END_CUSTOMER: string;
          STACK_METHOD: string;
          STACK_METHOD_NAME: string;
          DPJT_BUILD_NO: string;
          DPJT_BUILD_STATUS: string;
          DPJT_BUILD_TYPE: string;
          DPJT_BUILD_SEQ: string | number;
          DPJT_BIND_TYPE: string;
          DPJT_BIND_SEQ: string | number;
          NOTE: string;
          DIVISION_ID: string;
          CELL_TYPE: string;
          BIZ_TYPE: string;
          [key: string]: string | number;
        };
        // 공정별 요청 법인 (O_PLANT_CURSOR) — lookup SPMS_REQ_OPERATION 행 + SPMS_PROJECT_YIELD_MGMT_MST 값
        plant: {
          DPJT_BUILD_NO: string;
          DPJT_KEY: string;
          DIVISION_ID: string;
          CELL_TYPE: string;
          STACK_METHOD: string;
          OPERATION_GROUP: string; // 공정 그룹 코드 = lookup SEGMENT3 (E 전극 / A 조립 / P 모듈팩)
          MGMT_TYPE: string; // 관리 구분 = lookup SEGMENT4 양음극 (C 양극 / A 음극 / '-')
          OPERATION_ID: string; // 공정 = lookup SEGMENT5 (양극·음극 동일 코드 — MGMT_TYPE 로 구분)
          OPERATION_GROUP_NAME: string; // 구분 표시 (양극/음극/조립/모듈/팩) — 병합·확인 토글 축
          OPERATION_NAME: string; // 공정
          PLANT_ID: string; // 요청법인 (FPComboBox PlantByDivisionCompany) — 미지정 ''
          CONFIRM_FLAG: string; // 확인 — CHECKED / UNCHECKED (구분 단위 동일값)
          DISPLAY_SEQ: string | number;
          [key: string]: string | number;
        };
      };
    };
    yield: {
      request: {
        dpjtCode: string;
        dpjtBuildNo: string;
        // ⭐ 조회 단위 = 구분(공정 그룹) 1블록. 요청법인 패널에서 선택한 행의 구분으로만 좁히고
        //   법인·공정으로는 좁히지 않는다 — 그 구분에 속한 **전 공정**의 행이 함께 와야 한다.
        //   ⚠ SP 변경 필요 (2026-09-04): P_SDM2020_GET_PJT_YIELD 에서 P_PLANT_ID/P_OPERATION_ID
        //   조건을 제거하고 (P_OPERATION_GROUP + P_MGMT_TYPE) 로만 필터해야 한다.
        operationGroup: string; // 공정 그룹 (E/A/P)
        mgmtType: string; // 양음극 (C/A/-) — 양극·음극은 OPERATION_GROUP 이 같아 필수
        sesDivisionId: string;
      };
      response: {
        // 수율/Loss 계획 점검 — lookup SPMS_YIELD_TABLE 템플릿 행 + SPMS_PROJECT_YIELD_MGMT_DTL 편집값 LEFT JOIN
        data: {
          YIELD_MGMT_KEY: string; // lookup SEGMENT5 (예 A7000_LOSS_01040_C01)
          DPJT_BUILD_NO: string;
          DPJT_KEY: string;
          DIVISION_ID: string;
          CELL_TYPE: string;
          STACK_METHOD: string;
          PLANT_ID: string;
          OPERATION_GROUP: string;
          MGMT_TYPE: string;
          OPERATION_ID: string;
          OPERATION_GROUP_NAME: string;
          OPERATION_NAME: string;
          YIELD_VER: string; // DTL 저장값 (없으면 NULL)
          LEVEL_1: string;
          LEVEL_2: string; // 항목
          LEVEL_3: string; // 인자
          LEVEL_4: string; // Condition (lookup ATTRIBUTE7)
          FACTOR_LABEL: string; // 표시용 — 조건행 = LEVEL_4 / 그 외 = LEVEL_3
          IS_GROUP: string; // 'Y' = 인자 그룹 헤더행 (CALC_RULE·VALUE 없음 — 편집 불가)
          UOM: string; // '[%]' / '[타]' / '[셀]'
          CHECKED_FLAG: string; // 선택 — DTL 값, 없으면 lookup CHECKED='Y' → UNCHECKED / 그 외 NONE
          BASIC_VAL: string | number; // Delta (Ref) = lookup VALUE (텍스트 원문 — '-' 포함)
          YIELD_VAL: string | number; // Delta (조정) = DTL
          ADD_INFO_1: string; // 비고 (조정사유) = DTL
          NOTE: string; // 참고 = lookup ADD_INFO (불량 유형 등)
          ADD_INFO_2: string; // 참고 2 = lookup ADD_INFO2 (예시)
          DISPLAY_TYPE: string; // DTL
          CALC_RULE: string; // SUM / YEILD
          ROW_MERGE: string;
          ROW_COLOR: string;
          DISPLAY_SEQ: string | number;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0120 Constraint Mgmt (ConstraintMgmt) — 상/하 2그리드 Lookup 마스터-디테일.
   *
   * IN 키와 응답 커서 키는 `SCM_ADM_PROC_M`(PROC_NM/SORT_ORD/COL_NM) **실측값**이다.
   * 응답 키는 `o_rc` 이며 `o_rc1` 이 **아니다** — PKG 인자명은 `O_RC1` 이지만 FE 가 보는 키는
   * PROC_M 의 COL_NM 축이다. 자매 SCP0122 의 `o_rc1` 을 복사하면 rows 가 항상 빈 배열이 된다(hook #80).
   * - `lookupMaster` PKG_SCP0120.P_SCP0120_GET_LOOKUP_MASTER IN 3(lookupType/validYn/adminYn) / OUT `o_rc` 34컬럼
   * - `lookupDetail` PKG_SCP0120.P_SCP0120_GET_LOOKUP_DETAIL IN 1(lookupType)                  / OUT `o_rc` 43컬럼
   *
   * 컬럼 목록은 `ALL_SOURCE` 의 PKG BODY SELECT 절 원문 실측이며(`SCM_MST_SHEET_COLUMNS` 34/43 과 대사 일치),
   * Sub 의 `SEGMENT*_KEY` 10열은 SP 가 `SEGMENT n AS SEGMENT n _KEY` 로 원본을 함께 내려주는 UPDATE/DELETE 키다
   * — 화면이 값을 만들지 않고 그대로 재전송해야 한다(편집값을 넣으면 UPDATE 0행 + 무오류).
   * Sub 컬럼의 표시명·표시여부·필수(`*`)는 선택한 마스터 행 값으로 런타임에 바뀌지만, 키 집합 자체는 고정이다.
   */
  SCP0120: {
    lookupMaster: {
      request: {
        lookupType: string; // 1 부분일치(UPPER LIKE). 'ALL' 치환 금지 — 리터럴로 받아 0행이 된다.
        validYn: string; // 2 ALL 은 빈 문자열로 정규화해 보낸다.
        adminYn: string; // 3 관리자 판정(AdminYn_SCP0120 콤보가 세션으로 판정한 값)
      };
      response: {
        o_rc: {
          LOOKUP_TYPE_KEY: string;
          LOOKUP_TYPE: string;
          DESCRIPTION: string;
          LOOKUP_GROUP: string;
          VALID_YN: string;
          SEGMENT1: string;
          SEGMENT2: string;
          SEGMENT3: string;
          SEGMENT4: string;
          SEGMENT5: string;
          SEGMENT6: string;
          SEGMENT7: string;
          SEGMENT8: string;
          SEGMENT9: string;
          SEGMENT10: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          ATTRIBUTE3: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          ATTRIBUTE11: string;
          ATTRIBUTE12: string;
          ATTRIBUTE13: string;
          ATTRIBUTE14: string;
          ATTRIBUTE15: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
    lookupDetail: {
      request: {
        lookupType: string; // 1 마스터 더블클릭으로 확정된 LOOKUP_TYPE (row-context lazy fetch)
      };
      response: {
        o_rc: {
          LOOKUP_TYPE: string;
          DESCRIPTION: string;
          DISPLAY_SEQ: string | number; // 원장 NUMBER — 런타임에 number 로 내려온다(String() 가드 필요)
          SEGMENT1: string;
          SEGMENT2: string;
          SEGMENT3: string;
          SEGMENT4: string;
          SEGMENT5: string;
          SEGMENT6: string;
          SEGMENT7: string;
          SEGMENT8: string;
          SEGMENT9: string;
          SEGMENT10: string;
          SEGMENT1_KEY: string;
          SEGMENT2_KEY: string;
          SEGMENT3_KEY: string;
          SEGMENT4_KEY: string;
          SEGMENT5_KEY: string;
          SEGMENT6_KEY: string;
          SEGMENT7_KEY: string;
          SEGMENT8_KEY: string;
          SEGMENT9_KEY: string;
          SEGMENT10_KEY: string;
          VALID_YN: string;
          ATTRIBUTE1: string;
          ATTRIBUTE2: string;
          ATTRIBUTE3: string;
          ATTRIBUTE4: string;
          ATTRIBUTE5: string;
          ATTRIBUTE6: string;
          ATTRIBUTE7: string;
          ATTRIBUTE8: string;
          ATTRIBUTE9: string;
          ATTRIBUTE10: string;
          ATTRIBUTE11: string;
          ATTRIBUTE12: string;
          ATTRIBUTE13: string;
          ATTRIBUTE14: string;
          ATTRIBUTE15: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
        };
      };
    };
  };

  /**
   * SCP0122 Plan Activity Management (PlanActivityMgmt) — 단일 그리드 CRUD 마스터.
   *   GET  SCP0122_GET_PLAN_ACTIVITY_MGMT (15컬럼) / SAVE 캐럿(^)접기 (convert-flow SCP0122).
   */
  SCP0122: {
    main: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID (PROC_M COL_NM, camelCase 컨벤션)
        planGroupId: string; // 2 P_PLAN_GROUP_ID
        prsCd: string; // 3 P_PRS_CD
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PRS_CD: string;
          OPMZ_PRS_NAME: string;
          OPMZ_PLAN_GR_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          OPMZ_ACTV_SEQ: string | number;
          OPMZ_ACTV_CD: string;
          OPMZ_ACTV_NAME: string;
          LINK_UI_TYPE: string;
          PROGRAM_NAME: string;
          CONFIRM_YN: string;
          AUTO_YN: string;
          OPTION_YN: string;
          PRE_OPMZ_ACTV_CD: string;
          PRE_OPMZ_ACTV_SEQ: string | number;
        };
      };
    };
  };

  /**
   * SCP0124 Plan Group Dashboard — 조회 전용 단일 그리드 대시보드(CRUD 없음, Measure 없음).
   *   GET SCP0124_GET_PLAN_GROUP_DASHBOARD, 파라미터 6개, 응답 13컬럼(전건 INPUT_TP_CD='S').
   *   PKG_SCP0124 PACKAGE/BODY VALID 배포됨(ora.py 2026-10-13). main 응답 13컬럼 계약은
   *   03_grid-columns.md §1/§4 실측(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0124' 13행)을 근거로 한다.
   *   searchInfo 는 조회조건 Plant/Plan Group 공급(공용 P_SCP0121_GET_SEARCH_INFO — AS-IS 와 동일).
   */
  SCP0124: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id
        plantId: string; // 3 p_plant_id
        completedYn: string; // 4 p_completed_yn
        startDate: string; // 5 p_start_date
        endDate: string; // 6 p_end_date
      };
      response: {
        o_rc1: {
          PLAN_START_YYYYMMDD: string;
          DIVISION_ID: string;
          OPMZ_PRS_CD: string;
          OPMZ_PLAN_GR_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          OWNER: string;
          COMPLETED_YN: string;
          FP_TARGET_YN: string;
          OPMZ_ACTV_CD: string;
          OPMZ_ACTV_NAME: string;
          OPMZ_PLAN_ID: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * searchInfo — 조회조건 Plant/Plan Group 공급. AS-IS `GetSearchInfo()`(cs:178-198, p_user_id='')
     * 가 부르는 공용 `PKG_COM0000.P_SCP0121_GET_SEARCH_INFO`(SCP0039·SCP0120~0126 공용) 다.
     * AS-IS 는 Tables[0]=Plant(clbPlant), Tables[3]=Plan Group(cboPlanGroup) 을 쓴다 → 커서
     * COL_NM(SCM_ADM_PROC_M 실측) `plantList`(1번째)·`planGroupList`(4번째). 나머지 4커서
     * (factoryList/lineList/targetList/operationList)는 이 화면이 쓰지 않아 선언하지 않는다
     * (자매 SCP0123 searchInfo 선례). 전건 CODE/NAME/DIVISION_ID — division 은 FE 클라 필터.
     */
    searchInfo: {
      request: {
        userId: string; // 1 P_USER_ID — AS-IS 고정 '' (owner 필터 우회)
      };
      response: {
        plantList: {
          CODE: string; // PLANT_ID
          NAME: string;
          DIVISION_ID: string; // FE 클라 필터 키
          [key: string]: string | number;
        };
        planGroupList: {
          CODE: string; // OPMZ_PLAN_GR_ID
          NAME: string; // OPMZ_PLAN_GR_NAME
          DIVISION_ID: string; // FE 클라 필터 키
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0127 Precede/Safety Stock Day — 단일 그리드 CRUD 마스터(SCP0122 계열과 동일 구조).
   *   GET  SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY (조회조건 9종 → 17컬럼)
   *   SAVE SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY (신규/변경 12 + pre 8 = 20 파라미터)
   *   PKG_SCP0127 는 TO-BE 미배포(all_objects 0건, goal.md ② — convert-sp 백로그). 이 계약은
   *   design/02_search-combo.md §5·03_grid-columns.md §1/§4.4 실측(SCM_MST_SHEET_COLUMNS
   *   PROGRAM_ID='SCP0127' 17행)을 근거로 한다 — SP 미배포 상태의 best-evidence 파라미터명.
   */
  SCP0127: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id (다중, 콤마결합 — 결합 포맷 확인 필요, 02_search-combo.md §5)
        scmSiteId: string; // 3 p_scm_site_id (다중, 콤마결합 — 결합 포맷 확인 필요)
        itemId: string; // 4 p_item_id
        stage: string; // 5 p_stage
        validYn: string; // 6 p_valid_yn
        valueType: string; // 7 p_value_type
        periodFrom: string; // 8 p_period_from
        periodTo: string; // 9 p_period_to
      };
      response: {
        o_rc1: {
          VALUE_TYPE: string;
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          OPMZ_PLAN_GR_ID: string;
          SCM_SITE_ID: string;
          ITEM_ID: string;
          STAGE: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          TYPE_APPLY_DAY: string | number;
          VALUE_DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    /**
     * init SEARCH PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO (IN 2: divisionId/siteId → OUT 커서 o_rc1~o_rc6)
     *   Site/Type 조회조건 콤보 다중커서 원천. 자매 SCP0128 의 init 시트와 동형(SCP0128 은 o_rc7 까지
     *   있으나 SCP0127 BODY 는 o_rc6 까지). 커서 COL_NM 은 PACKAGE BODY `OPEN O_RCn FOR` SELECT 별칭
     *   실측(PKG_SCP0127 BODY L35~128): o_rc1=PlanGroup/o_rc2=Site/o_rc3=Stage/o_rc4=Type(COVER_DAY_TYPE)/
     *   o_rc5=DM_YN/o_rc6=Item. FE 는 Site(o_rc2)/Type(o_rc4)만 소비한다(Stage 는 기존 lookup, PlanGroup/
     *   Item/Valid 는 기존 배선 유지).
     *   DB 등록: API_ID='SCP0127_init_SEARCH' + MNU_BTN_MPG_M(SCP0127,init,SEARCH) + USER_GR 3그룹
     *   (ADMIN/SCM PI Admin/SCP Planner) 적용·검증 완료(2026-10-11 ora.py).
     */
    init: {
      request: {
        divisionId: string; // 1 p_division_id (CLOB)
        scmSiteId: string; // 2 p_site_id (CLOB)
      };
      response: {
        /** Plan Group(o_rc1) — SCP_OPMZ_PLAN_GR_M. FE 미소비(기존 PlanGroup CMBO 유지). */
        o_rc1: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        /** Site(o_rc2) — SCM_MST_SITE SALES/PLANT UNION. Division cascade + IN('81','40','82') 재필터. */
        o_rc2: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Stage(o_rc3) — LOOKUP 'OPMZ_STAGE_CD'. FE 미소비(기존 useTabLookupQueries 유지). */
        o_rc3: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Type / Value Type(o_rc4) — LOOKUP 'COVER_DAY_TYPE' 2행(MAX/MIN). 전역(Division 하위 아님). */
        o_rc4: {
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** DM_YN(o_rc5) — 미사용 여분 커서. */
        o_rc5: {
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Item(o_rc6) — SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM. FE 미소비(팝업 원천). */
        o_rc6: {
          DIVISION_ID: string;
          ITEM_ID: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0128 Precede/Safety Stock Qty — 단일 그리드 CRUD 마스터 + 조회조건 전용 `init` 시트.
   *   main GET  PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK (조회조건 9종 → 16컬럼, PROC_M 등록은 IN 9 +
   *     커서 o_rc1 뿐이라 행 타입은 loose index signature 로 둔다 — SCP0002 LineMaster 선례와 동일)
   *   init SEARCH PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO (IN 2: divisionId/siteId → OUT 커서 o_rc1~o_rc7)
   *     Site/Type/Stage/PlanGroup/Item 조회조건 콤보 다중커서 원천. AS-IS `GetSearchInfo`(.cs:190~215)
   *     DataSet Tables[0..5] ↔ o_rc1~o_rc6 1:1. 자매 SCP0125/SCP0126 의 `init` 시트와 동형 규약
   *     (전용 SHT_NM='init' + MNU_BTN_CD='SEARCH', API_ID='SCP0128_init_SEARCH').
   *   PKG_SCP0128 배포 완료(PACKAGE+BODY VALID, 2026-10-11 ora.py 실측). 커서 COL_NM 은 PACKAGE BODY
   *     `OPEN O_RCn FOR` SELECT 별칭 실측(L35~128).
   */
  SCP0128: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id (다중, 콤마결합)
        scmSiteId: string; // 3 p_scm_site_id (다중, 콤마결합)
        itemId: string; // 4 p_item_id
        stage: string; // 5 p_stage
        validYn: string; // 6 p_valid_yn
        valueType: string; // 7 p_value_type
        periodFrom: string; // 8 p_period_from
        periodTo: string; // 9 p_period_to
      };
      response: {
        // main 그리드 행 — SCM_MST_SHEET_COLUMNS 동적 컬럼(16행). PROC_M 미등록이라 loose.
        //   WijmoRowItem(Record<string, WijmoPrimitive>) 과 동형이어야 EditTracker/그리드 핸들러에
        //   그대로 넘길 수 있다(string|number 로 좁히면 WijmoPrimitive 의 null 과 불일치 — type-check fail).
        o_rc1: WijmoRowItem;
      };
    };
    init: {
      request: {
        divisionId: string; // 1 p_division_id (CLOB — 단일 Division, STRING_SPLIT 대상)
        scmSiteId: string; // 2 p_site_id (CLOB)
      };
      response: {
        /** Plan Group(AS-IS Tables[0]) — SCP_OPMZ_PLAN_GR_M, Division cascade. */
        o_rc1: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        /** Site(Tables[1]) — SCM_MST_SITE. AS-IS 가 추가로 DIVISION_ID IN('81','40','82') 클라 재필터. */
        o_rc2: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Stage(Tables[2]) — LOOKUP 'OPMZ_STAGE_CD'(SEGMENT1=DIVISION_ID), Division cascade. */
        o_rc3: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Type / Value Type(Tables[3]) — LOOKUP 'COVER_DAY_TYPE' 2행(MAX/MIN). */
        o_rc4: {
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** DM_YN(Tables[4]) — AS-IS Valid 콤보는 미사용(YesOrNo 콤보 바인드). 여분 커서. */
        o_rc5: {
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Item(Tables[5]) — SCM_MST_ITEM_SN ∪ SCP_OPMZ_VIRTUAL_BOM. 조회조건 콤보 아님(팝업 원천). */
        o_rc6: {
          DIVISION_ID: string;
          ITEM_ID: string;
          [key: string]: string | number;
        };
        /** OPMZ_STAGE_CD 중복(미사용 추정). */
        o_rc7: {
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0129 Demand Exception — 단일 그리드 CRUD 마스터 + 조회조건 전용 `init` 시트(SCP0128 계열).
   *   main GET  PKG_SCP0129.P_SCP0129_GET_DEMAND_EXCEPTION (조회조건 8종 → 16컬럼) — 배포 완료
   *     (PACKAGE+BODY VALID, 2026-10-13 ora.py 실측)
   *   main SAVE PKG_SCP0129.P_SCP0129_SAVE_DEMAND_EXCEPTION (현재값 9 + user 1 + pre 7 = 19파라미터,
   *     surrogate PK 없는 복합키 UPDATE 패턴) — 배포 완료
   *   init SEARCH PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO (IN 2: divisionId/siteId → OUT o_rc1~o_rc7) —
   *     PlanGroup/Site/Stage 조회조건 콤보 다중커서 원천. AS-IS GetSearchInfo(.cs:191~216)가 SCP0128
   *     SP 를 재사용(SCP0129 전용 GET_SEARCH_INFO 없음). API_ID='SCP0128_init_SEARCH' 재사용 —
   *     SCM_ADM_MNU_BTN_MPG_M(SCP0129, init, SEARCH) 등록 필요(register SQL).
   */
  SCP0129: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id (다중, 콤마결합 — init o_rc1)
        scmSiteId: string; // 3 p_scm_site_id (다중, 콤마결합 — init o_rc2)
        itemId: string; // 4 p_item_id
        stage: string; // 5 p_stage (init o_rc7, ATTRIBUTE3='Y')
        validYn: string; // 6 p_valid_yn (CMBO YesOrNo)
        periodFrom: string; // 7 p_period_from
        periodTo: string; // 8 p_period_to
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_ID: string;
          SCM_SITE_ID: string;
          ITEM_ID: string;
          STAGE: string;
          MODEL_TYPE_CD: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          STOCK_EXCEPTION: string;
          VALUE_DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    init: {
      request: {
        divisionId: string; // 1 p_division_id (CLOB — 빈 값 호출, FE 가 Division cascade)
        scmSiteId: string; // 2 p_site_id (CLOB)
      };
      response: {
        /** Plan Group(AS-IS Tables[0]) — SCP_OPMZ_PLAN_GR_M, Division 단순일치 cascade. */
        o_rc1: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          [key: string]: string | number;
        };
        /** Site(Tables[1]) — SCM_MST_SITE, EE 분기 cascade(matchSiteByDivision). */
        o_rc2: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** Stage(Tables[6]=O_RC7) — LOOKUP 'OPMZ_STAGE_CD' + ATTRIBUTE3='Y'(2025-11-14 신버전),
         *    SEGMENT1=DIVISION_ID, Division 단순일치 cascade. SCP0128 의 O_RC3(구버전)과 다름. */
        o_rc7: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
        /** o_rc3(Stage 구버전)·o_rc4(Type)·o_rc5(ValidYn)·o_rc6(Item) — SCP0129 조회조건 콤보 미사용. */
        o_rc3: { [key: string]: string | number };
        o_rc4: { [key: string]: string | number };
        o_rc5: { [key: string]: string | number };
        o_rc6: { [key: string]: string | number };
      };
    };
  };

  /**
   * SCP0130 Scheduled Receipt Information — 2 sheetNm 정적 그리드(Virtual Bom 14컬럼 +
   * Scheduled Reciept Information 13컬럼, pivot 없음, master-detail 아님 — 동일 조회조건을
   * 공유하는 독립 시트 2개).
   *   GET  virtualBom 시트 = SCP.SCP0130_GET_VIRTUAL_BOM / scheduledReceipt 시트 =
   *     SCP.SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION — AS-IS `FindData_Main()`(.cs:556-666)가
   *     `_sActiveSheetName`에 따라 queryId 를 분기하는 서로 다른 SP다(gap-resolve/iter-1 정정 —
   *     이전 회차 문서가 두 시트 모두 GET_VIRTUAL_BOM으로 잘못 기재했던 것을 AS-IS 원문으로 확정).
   *     파라미터 7종(조회조건, design/02_search-combo.md §1)은 두 SP가 동일 계약을 공유한다.
   *   SAVE SCP.SCP0130_SVAE_VIRTUAL_BOM(원문 오탈자 유지) + SCP.SCP0130_SAVE_SCHEDULED_RECIEPT_
   *     INFORMATION(design/03_grid-columns.md §4 저장 3-SP 체인, 2번째 SP만 이 계약에 반영 —
   *     1번째는 재조회 트리거 성격)
   *   PKG_SCP0130 는 TO-BE 미배포(all_objects 0건, goal.md ② — convert-sp 백로그). 이 계약은
   *   design/03_grid-columns.md §1 실측(SCM_MST_SHEET_COLUMNS PROGRAM_ID='SCP0130' 27행,
   *   sheetNm 2개)을 근거로 한다 — SP 미배포 상태의 best-evidence 파라미터명(SCP0129 선례).
   */
  SCP0130: {
    virtualBom: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id (콤마 결합 다중)
        siteId: string; // 3 p_site_id (콤마 결합 다중, comboId 미확정 — 확인 필요)
        itemIdChild: string; // 4 p_item_id_child (콤마 결합 다중, comboId 미확정 — 확인 필요)
        validYn: string; // 5 p_valid_yn
        fromDate: string; // 6 p_from_date
        itemId: string; // 7 p_item_id (Item ID 팝업 결과)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_ID: string;
          PLANT_SITE_ID: string;
          ITEM_ID: string;
          ITEM_ID_CHILD: string;
          TO_EXPC_QTY: string;
          TO_YYYYMMDD: string;
          VALUE_DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    scheduledReceipt: {
      request: {
        divisionId: string; // 1 p_division_id
        planGroupId: string; // 2 p_plan_group_id (콤마 결합 다중)
        siteId: string; // 3 p_site_id (콤마 결합 다중, comboId 미확정 — 확인 필요)
        itemIdChild: string; // 4 p_item_id_child (콤마 결합 다중, comboId 미확정 — 확인 필요)
        validYn: string; // 5 p_valid_yn
        fromDate: string; // 6 p_from_date
        itemId: string; // 7 p_item_id
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_ID: string;
          PLANT_SITE_ID: string;
          ITEM_ID_CHILD: string;
          TO_YYYYMMDD: string;
          TO_EXPC_QTY: string;
          VALUE_DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0133 Warehouse Capacity (Supply Master) — 2 sheetNm 정적 그리드(Warehouse Capacity
   * 15컬럼 + Warehouse Item Mapping 16컬럼, pivot 없음). 신규 전환(nscmPath 후보 확정,
   * goal.md ①) — GSCM 원본 `.cs` 미확보 + AS-IS MSSQL 접속 불가(design 00~03 3중 ERROR)라
   * 아래 계약은 SP 파라미터명(spCalls 정적 확인)·SHEET_COLUMNS 31행 실측(design 03 §1) 기준
   * best-evidence 다 — SCP0129/SCP0130 선례와 동일하게 "확인 필요" 항목을 주석으로 남긴다.
   *   GET  main(WhCapa) = SCP.SCP0133_GET_WAREHOUSE_CAPACITY(9파라미터, design 03 §4.2).
   *     Warehouse Item Mapping 전용 GET SP 없음 — 조회 경로 자체가 확인 필요(design 03 §6-9).
   *   GET  searchInfo = SCP.SCP0133_GET_SEARCH_INFO(파라미터 없음, 반환 컬럼 미상 — 확인 필요,
   *     저장 직후/시트 전환 시 재호출 용도 추정, design 03 §4.1). 이 activity 는 배선하지 않는다
   *     (SP 본문·반환 계약 자체가 미확인 — convert-sp 후속에서 확정 후 연결).
   *   SAVE main(WhCapa) = SCP.SCP0133_SAVE_WAREHOUSE_CAPACITY(16파라미터, p_pre_* 5개 포함).
   *   SAVE itemMapping = SCP.SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING(15파라미터, p_pre_* 4개 포함).
   *   PKG_SCP0133 는 TO-BE 미배포(all_objects 0건, goal.md ② — convert-sp 백로그).
   */
  SCP0133: {
    main: {
      request: {
        divisionId: string; // 1 p_division_id
        opmzPlanGrId: string; // 2 p_opmz_plan_gr_id (콤마 결합 다중, comboId 미확정 — 확인 필요)
        siteId: string; // 3 p_site_id (콤마 결합 다중, comboId 미확정 — 확인 필요)
        stage: string; // 4 p_stage (콤마 결합 다중, lookup 후보 OPMZ_STAGE_CD — 확인 필요)
        whNm: string; // 5 p_wh_nm (콤마 결합 다중, 원천 미상 — 확인 필요)
        fromYyyymmdd: string; // 6 p_from_yyyymmdd
        toYyyymmdd: string; // 7 p_to_yyyymmdd
        itemId: string; // 8 p_item_id (Item ID 팝업 결과)
        validYn: string; // 9 p_valid_yn
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_ID: string;
          WH_NM: string;
          SCM_SITE_ID: string;
          STAGE: string;
          FROM_YYYYMMDD: string;
          TO_YYYYMMDD: string;
          MAX_CAPA: string;
          VALUE_DESCRIPTION: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0098 Production Plan Line (CAPA Mobility IT / CAPA Report Small) — 단일 pivot 그리드
   *   (measure 행전개 + 동적 기간컬럼 D_/W_/M_/PR_M_ + 3단 머지헤더 + measure별 편집잠금). Insert 없음.
   *
   * IN 키는 `PKG_SCP0098` all_arguments 실측(ora.py) + 이 레포 camelCase↔P_SNAKE 컨벤션으로 도출.
   *   PROC_M(COL_NM) 등록은 convert-sp 소관(2.9) — 배포된 PKG all_arguments 를 정본으로 확정한다.
   * 응답 커서명 = OUT 인자명 lowercase(hook #80): 데이터 `o_rc` / 결과상태 `o_result_cursor`.
   * SHEETS:
   * - `main`            P_GET_CAPA_MOBILITYIT           IN 13 / OUT o_rc(pivot) + o_result_cursor
   * - `capaProductRate` P_SAVE_SCP_CAPA_PRODUCT_RATE    IN 10(단행) — 배열 unfold 저장(생산준비율)
   * - `capaMonth`       P_SAVE_SCP_CAPA                 IN 10(단행) — Capa 월(M_) 저장
   * - `capaWork`        P_SAVE_SCP_CAPA_WORK            IN 10(단행) — Capa Work 일(D_) 저장
   * - `copy`            P_COPY_MONTH_WEEK               IN 3 — Week/Month 복사(행 없음)
   * - `titleSet`        공용 Column/Measure 설정 모달 소유 시트(BTN_MPG 배선)
   */
  SCP0098: {
    main: {
      request: {
        todayYyyymmdd: string; // 1  P_TODAY_YYYYMMDD 기준일(오늘)
        fromYyyymmdd: string; // 2  P_FROM_YYYYMMDD  조회 From
        toYyyymmdd: string; // 3  P_TO_YYYYMMDD    조회 To
        divisionId: string; // 4  P_DIVISION_ID    '40' 고정
        plantId: string; // 5  P_PLANT_ID       Plant 다중(CSV, 'ALL')
        lineId: string; // 6  P_LINE_ID        Line 다중(CSV, '-'→'')
        operationId: string; // 7  P_OPERATION_ID   = Line 값(AS-IS 동일 전달)
        modelId: string; // 8  P_MODEL_ID       = Line 값(AS-IS 동일 전달)
        itemId: string; // 9  P_ITEM_ID        Material(팝업)
        nickName: string; // 10 P_NICK_NAME      자유 텍스트
        bucket: string; // 11 P_BUCKET         D/W/M
        userId: string; // 12 P_USER_ID        세션(BE 주입 가능 — 명시 전달)
        debugMode: string; // 13 P_DEBUG_MODE     'F'
      };
      response: {
        // pivot 데이터 — 정적 19컬럼(design 03 §1.1) + 동적 D_/W_/M_/PR_M_ (인덱스 시그니처).
        o_rc: {
          DIVISION_ID: string;
          COMPANY_ID: string;
          PLANT_ID: string;
          FACTORY_ID: string;
          FACTORY_NAME: string;
          OPERATION_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          PRODUCT_READY: string | number;
          ITEM_ID: string;
          NICK_NAME: string;
          ITEM_NAME: string;
          MEASURE_UI: string;
          MEASURE_NAME: string;
          OEE: string | number;
          LOAD_RATE: string;
          NO_WORK: string;
          NO_WORK_CALC: string;
          RAMP_UP: string;
          [key: string]: string | number;
        };
        o_result_cursor: {
          RESULT_CODE: string;
          RESULT_MSG: string;
          [key: string]: string | number;
        };
      };
    };
    capaProductRate: {
      // request/response 는 저장 전송 행(useProcMutation data 타입) 동일 shape. 결과는 o_result_cursor 로 온다.
      request: {
        activeFlag: string; // 1  P_ACTIVE_FLAG  CRUD I/M/D
        divisionId: string; // 2  P_DIVISION_ID
        plantId: string; // 3  P_PLANT_ID
        factoryId: string; // 4  P_FACTORY_ID
        operationId: string; // 5  P_OPERATION_ID
        lineId: string; // 6  P_LINE_ID
        startYyyymmdd: string; // 7  P_START_YYYYMMDD
        endYyyymmdd: string; // 8  P_END_YYYYMMDD
        productRate: string; // 9  P_PRODUCT_RATE
        userId: string; // 10 P_USER_ID (BE 주입 가능)
      };
      response: {
        row: {
          activeFlag: string;
          divisionId: string;
          plantId: string;
          factoryId: string;
          operationId: string;
          lineId: string;
          startYyyymmdd: string;
          endYyyymmdd: string;
          productRate: string;
          userId: string;
        };
      };
    };
    capaMonth: {
      request: {
        activeFlag: string; // 1  P_ACTIVE_FLAG
        divisionId: string; // 2  P_DIVISION_ID
        plantId: string; // 3  P_PLANT_ID
        factoryId: string; // 4  P_FACTORY_ID
        operationId: string; // 5  P_OPERATION_ID
        lineId: string; // 6  P_LINE_ID
        itemId: string; // 7  P_ITEM_ID
        yyyymm: string; // 8  P_YYYYMM
        value: string; // 9  P_VALUE
        userId: string; // 10 P_USER_ID
      };
      response: {
        row: {
          activeFlag: string;
          divisionId: string;
          plantId: string;
          factoryId: string;
          operationId: string;
          lineId: string;
          itemId: string;
          yyyymm: string;
          value: string;
          userId: string;
        };
      };
    };
    capaWork: {
      request: {
        activeFlag: string; // 1  P_ACTIVE_FLAG
        divisionId: string; // 2  P_DIVISION_ID
        plantId: string; // 3  P_PLANT_ID
        factoryId: string; // 4  P_FACTORY_ID
        operationId: string; // 5  P_OPERATION_ID
        lineId: string; // 6  P_LINE_ID
        measure: string; // 7  P_MEASURE (NO_WORK/LOAD_RATE/RAMP_UP)
        yyyymmdd: string; // 8  P_YYYYMMDD
        value: string; // 9  P_VALUE
        userId: string; // 10 P_USER_ID
      };
      response: {
        row: {
          activeFlag: string;
          divisionId: string;
          plantId: string;
          factoryId: string;
          operationId: string;
          lineId: string;
          measure: string;
          yyyymmdd: string;
          value: string;
          userId: string;
        };
      };
    };
    copy: {
      request: {
        userId: string; // 1 P_USER_ID (BE 주입 가능)
        dayType: string; // 2 P_DAY_TYPE (WEEK/MONTH)
        debugMode: string; // 3 P_DEBUG_MODE 'F'
      };
      response: { o_result_cursor: { RESULT_CODE: string; RESULT_MSG: string } };
    };
    titleSet: {
      request: {
        programId: string;
        sheetName: string;
        columnType: string;
        divisionId: string;
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
  };

  /**
   * SCP0123 Plan Control (PlanControl) — 상/하 2그리드 Activity 실행 콘솔 (convert-flow SCP0123).
   *
   * 아래 IN 키·OUT 커서명은 `SCM_ADM_PROC_M`(PROC_NM/SORT_ORD/COL_NM) **실측값**이다. 이 화면의 응답 키는
   * `o_rc1` 이 **아니다** — 커서 인자명(O_RC1)과 PROC_M 의 COL_NM 은 별개 축이고 FE 가 보는 키는 후자다.
   * 자매 SCP0122 의 `o_rc1` 을 복사하면 rows 가 항상 빈 배열이 된다(hook #80).
   * - `planControl` PKG_SCP0123.P_SCP0123_GET_PLAN_CONTROL    IN 5 / OUT 커서 `planControl`
   *     같은 SP 가 actvCd·planId 를 지정받으면 **4컬럼(상태)만** 내리는 단건 분기를 탄다(본문 L156~).
   *     SAVE(`P_SCP0123_SAVE_PLAN_ACTV_RUN`, IN 7)도 이 시트명으로 배선되며 FE 는 apiClient.post 로 부른다.
   * - `engineRun`   PKG_SCP0123.P_SCP0123_GET_PLAN_ENGINE_RUN IN 5 / OUT 커서 `engineRun`
   * - `searchInfo`  PKG_COM0000.P_SCP0121_GET_SEARCH_INFO     IN 1 / OUT 커서 6 중 **4번째 `planGroupList`**
   *     (SCP0039·SCP0120~0126 공용. 나머지 5커서는 이 화면이 쓰지 않아 선언하지 않는다.)
   *
   * 컬럼 메타 축(`SCM_MST_SHEET_COLUMNS.SHEET_NAME` = 'Plan Control' 22행 / 'Status' 7행)은 위 `SHT_NM`
   * 과 값이 다르다 — 섞으면 조용히 컬럼 0건이 된다. 22행 중 `CONFIRM`·`DETAIL` 은 SP 무반환 코드 전용
   * 컬럼이라 아래 response 에 없다(화면 formatItem 이 그린다).
   */
  SCP0123: {
    planControl: {
      request: {
        divisionId: string; // 1 조회조건 Division
        planGroupId: string; // 2 조회조건 Plan Group
        planStartYyyymmdd: string; // 3 모드별(주단위 콤보 CODE / 일단위 DatePicker) yyyyMMdd
        actvCd: string; // 4 전체조회는 '' / 단건 상태 재조회는 Activity 코드
        planId: string; // 5 전체조회는 '' / 단건 상태 재조회는 Plan ID
      };
      response: {
        planControl: {
          PLAN_START_YYYYMMDD: string;
          OPMZ_PRS_CD: string;
          DIVISION_ID: string;
          OPMZ_PLAN_GR_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          OPMZ_TGT_DIVS_CD: string;
          OPMZ_ACTV_CD: string;
          OPMZ_ACTV_NAME: string;
          OPMZ_PLAN_ID_INDP_YN: string;
          CONFIRM_YN: string;
          OPTION_YN: string;
          LINK: string; // IB.LINK_NAME AS LINK
          LINK_ADDRESS: string;
          ACTION_NAME: string;
          OPMZ_ACTV_SEQ: string | number;
          OPMZ_PLAN_ID: string;
          OPMZ_ACTV_RUN_STAT_CD: string;
          OPMZ_ACTV_RUN_STAT_NAME: string;
          LAST_UPDATE_DATE: string;
          LAST_UPDATED_BY: string;
        };
      };
    };
    engineRun: {
      request: {
        divisionId: string;
        planGroupId: string;
        planStartYyyymmdd: string;
        actvCd: string;
        planId: string;
      };
      response: {
        engineRun: {
          PLAN_ID: string;
          PROGRESS_CODE: string;
          PROGRESS_TEXT: string;
          STATUS: string;
          START_DATE: string;
          END_DATE: string;
          DETAILS: string;
        };
      };
    };
    searchInfo: {
      request: {
        // ADMIN/SCM PI Admin 은 '' 를 보내 owner 필터를 우회한다(X21) — SP 가
        //   `P_USER_ID IS NULL OR OWNR_LST_CTN LIKE ...` 이고 Oracle 은 '' = NULL 이다.
        userId: string;
      };
      response: {
        planGroupList: {
          CODE: string; // OPMZ_PLAN_GR_ID
          NAME: string; // OPMZ_PLAN_GR_NAME
          DIVISION_ID: string; // F01·F02 클라 필터 키
        };
      };
    };
  };

  /**
   * SCP0125 Workbench — 5탭 / 7 데이터시트(+`init`) / 102 컬럼 (convert-flow SCP0125).
   *
   * IN 키·OUT 커서명은 `SCM_ADM_PROC_M`(PROC_NM/SORT_ORD/COL_NM) **실측**(ora.py 2026-09-26, 143행 /
   * 12 proc), response 컬럼은 `PKG_SCP0125` PACKAGE BODY 의 `OPEN O_RC1 FOR` SELECT 목록을 그대로
   * 옮긴 것이다(BODY:159~310 init · 346 mktFcst · 521 elecDemand · 1645 stock · 1936 stockUc ·
   * 2410 stockElec · 2627 stockElecUc · 2884 stock2ndOcv).
   *
   * 시트축이 둘이다 — 여기 키는 **호출축**(`SCM_ADM_API_M.API_ID` 접미 camelCase 8종)이고 컬럼 메타
   * 축(`SCM_MST_SHEET_COLUMNS.SHEET_NAME` = 'MKT FCST'/'STOCK'/'Stock(Elec. Plant)'/'Elec. Demand'/
   * 'Stock(2nd OCV)' 5종)과 값이 다르다. 섞으면 조용히 컬럼 0건이 된다
   * (화면 상수 `SHEETS` ↔ `ADMIN_SHEET_NAME`).
   * - GET 7종: IN 5 동일(`divisionId`/`planStartYyyymmdd`/`versionNo`/`nickName`/`itemId`) / OUT `o_rc1`.
   *   `stock`↔`stockUc`, `stockElec`↔`stockElecUc` 는 division `81_UC` 여부로 FE 가 골라 부르는
   *   **별개 sheetName** 이며 UC 쪽만 `LINE_ID`·`BEFORE_DEGAS` 2컬럼을 더 내린다.
   * - `init`: IN **0개** / OUT 커서 **9개**(`o_rc1`~`o_rc9`), 화면당 1회.
   * - SAVE 4종은 IN 이 전건 **CLOB 평면 파라미터**(행축 `^` 결합) + `sesUserId` 스칼라라
   *   `useProcMutation` 계약(`{data: rows[]}`)에 맞지 않는다 — 화면이 `apiClient.post` 로 직접
   *   조립한다(`utils/workbench.save.ts`). 그래서 여기 선언하지 않는다.
   */
  SCP0125: {
    init: {
      request: {}; // IN 0개 — `PROC_M` 11행 전건 OUT
      response: {
        // o_rc1 cboVersion 후보 — BODY:160~168 `DM_MST_VERSION`
        o_rc1: {
          CODE: string; // VERSION_NO
          NAME: string; // VERSION_NO (CODE=NAME)
          DIVISION_ID: string; // F03 클라 필터 키
          YYYYMMDD: string; // F03 범위(planStart ~ +6d) 판정 키
          [key: string]: string | number;
        };
        // o_rc2 MKT FCST Sales Site — BODY:172~192
        o_rc2: { DIVISION_ID: string; CODE: string; NAME: string; [key: string]: string | number };
        // o_rc3 Plant Site — BODY:195~203. `PLANT_ID` 는 D4(Operation 파생)의 조인 키다
        o_rc3: {
          DIVISION_ID: string;
          CODE: string;
          NAME: string;
          PLANT_ID: string;
          [key: string]: string | number;
        };
        // o_rc4 STOCK 계열 SCM Site — BODY:205~231
        o_rc4: { DIVISION_ID: string; CODE: string; NAME: string; [key: string]: string | number };
        // o_rc5 Item 존재검증 — BODY:234~237. **CODE/NAME 규약이 아니다**(업무 컬럼명)
        o_rc5: { DIVISION_ID: string; ITEM_ID: string; [key: string]: string | number };
        // o_rc6 Project Code 존재검증 — BODY:240~243. 동일하게 CODE/NAME 아님
        o_rc6: { DIVISION_ID: string; PROJECT_CODE: string; [key: string]: string | number };
        // o_rc7 소형(40) End Customer — BODY:246~274
        o_rc7: { CODE: string; NAME: string; [key: string]: string | number };
        // o_rc8 Stock(Elec. Plant) Location — BODY:278~287
        o_rc8: { CODE: string; NAME: string; ELEC_YN: string; [key: string]: string | number };
        // o_rc9 Line — BODY:289~310. `PLANT_ID`·`OPERATION_ID` 가 D4 파생·2단 cascade 의 키다
        o_rc9: {
          DIVISION_ID: string;
          PLANT_ID: string;
          OPERATION_ID: string;
          CODE: string; // LINE_ID
          NAME: string; // LINE_ID (CODE=NAME)
          LINE_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    mktFcst: {
      request: {
        divisionId: string; // 1
        planStartYyyymmdd: string; // 2 (이 SP 는 미사용 — 드라이빙 조건은 division + versionNo)
        versionNo: string; // 3
        nickName: string; // 4 부분일치(파라미터만 UPPER — GAP-10)
        itemId: string; // 5 부분일치(동일)
      };
      response: {
        // BODY:347~369 (+ PRE_CHG_* 2컬럼은 CHG_* 의 별칭 사본)
        o_rc1: {
          DIVISION_ID: string;
          VERSION_NO: string;
          CUTOFF_YYYYMMDD: string;
          PROJECT_CODE: string;
          PROJECT_CODE_40: string; // 소형(40) 배타 표시 — 원천은 PROJECT_CODE 동일 컬럼
          SCM_SITE_ID: string;
          NICK_NAME: string;
          ITEM_ID: string;
          FCST_TYPE: string; // 숨김 코드 — 파생 D1 의 출력
          FCST_TYPE_NAME: string; // 표시명(lookup SALES_TYPE_CODE SEGMENT2)
          INCOTERMS: string;
          PLANT_SITE_ID: string;
          CELL_PROD_SITE_ID: string;
          DUE_DATE: string; // TO_DATE(...) — 직렬화 문자열
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number; // 변경없음 skip 판정 기준(저장 대상 제외)
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    stock: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string;
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:1646~1666 — 20컬럼. `LINE_ID`·`BEFORE_DEGAS` 는 UC 전용이라 **여기 없다**
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          SRCE_DIVS_CD: string;
          STOCK_TYPE: string; // 숨김 코드 — 파생 D2 의 출력
          STOCK_TYPE_NAME: string;
          PROJECT_CODE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          INCOTERMS: string;
          FROM_SITE_ID: string;
          SCM_SITE_ID: string;
          INV_DATE: string;
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    stockUc: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string;
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:1937~1959 — `stock` + `LINE_ID`·`BEFORE_DEGAS` 2컬럼(= STOCK 시트 메타 22행)
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          SRCE_DIVS_CD: string;
          STOCK_TYPE: string;
          STOCK_TYPE_NAME: string;
          PROJECT_CODE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          INCOTERMS: string;
          FROM_SITE_ID: string;
          SCM_SITE_ID: string;
          LINE_ID: string; // 81_UC 전용 — 2단 cascade(ATTRIBUTE2 `SCM_SITE_ID:SCM_SITE_ID`)
          BEFORE_DEGAS: string; // 81_UC 전용 — 메타 자동 콤보 `YesOrNo`
          INV_DATE: string;
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    // stockElec / stockElecUc — 컬럼셋이 완전히 같다(BODY:2411~2432 ↔ 2628~2649 실측 21컬럼).
    //   division 분기는 sheetName 선택(드라이빙 로직)에만 있고 request·response 는 동일하다.
    stockElec: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string;
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:2411~2432 — `stock` 20컬럼 + `LOCATION_CODE`(Elec. Plant 전용) = 21컬럼
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          SRCE_DIVS_CD: string;
          STOCK_TYPE: string;
          STOCK_TYPE_NAME: string;
          PROJECT_CODE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          INCOTERMS: string;
          FROM_SITE_ID: string;
          SCM_SITE_ID: string;
          LOCATION_CODE: string; // Elec. Plant 전용(lookup OPMZ_LOCATION_CODE SEGMENT3='Y')
          INV_DATE: string;
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    stockElecUc: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string;
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:2628~2649 — `stockElec` 와 컬럼셋 동일(21컬럼). division 81_UC 에서만 호출된다
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          SRCE_DIVS_CD: string;
          STOCK_TYPE: string;
          STOCK_TYPE_NAME: string;
          PROJECT_CODE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          INCOTERMS: string;
          FROM_SITE_ID: string;
          SCM_SITE_ID: string;
          LOCATION_CODE: string;
          INV_DATE: string;
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    elecDemand: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string; // 이 SP 의 드라이빙 조건(`SCP_ANL_PRODUCTION_PLAN`)
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:523~540 — 18컬럼
        o_rc1: {
          DIVISION_ID: string;
          PLAN_START_YYYYMMDD: string;
          PLAN_TYPE: string;
          SEQ: string | number;
          PLANT_SITE_ID: string; // SP 는 `SCM_SITE_ID AS PLANT_SITE_ID` 로 내린다
          NICK_NAME: string;
          ITEM_ID: string;
          LINE_ID: string; // 2단 cascade(ATTRIBUTE2 `PLANT_SITE_ID:PLANT_SITE_ID`)
          OPERATION_ID: string; // 직접입력 불가 — 파생 D4 전용
          YYYYMMDD: string; // TO_DATE(...)
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
    stock2ndOcv: {
      request: {
        divisionId: string;
        planStartYyyymmdd: string;
        versionNo: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // BODY:2886~2904 — 19컬럼
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          STOCK_TYPE: string;
          STOCK_TYPE_NAME: string;
          NICK_NAME: string;
          ITEM_ID: string;
          PLANT_ID: string;
          OPERATION_ID: string;
          // BODY:2913 `CAST(NULL AS VARCHAR2(200 CHAR))` — 권한 원복 대기라 **항상 NULL**(설계 U4)
          OPERATION_NAME: string;
          // BODY:2914 `TO_CHAR(A.SECOND_OCV_TIME)` = VARCHAR2. 컬럼 메타 셀유형은 `FPNumber` 라
          //   타입이 어긋난다(GAP-9 — 정정은 admin UI 소관, 화면 override 금지)
          SECOND_OCV_TIME: string;
          SECOND_OCV_DATE: string; // TRUNC(...) DATE
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          PLANT_SITE: string;
          INVENTORY_TYPE: string;
          MODEL: string;
          LOT_ID: string;
          LOT: string;
          PRODUCTION_DATE: string;
          BUILDING: string;
          PALLET_ID: string;
          VALTAGE: string; // AS-IS 라벨 오탈자 그대로(design 03 §1#11 — "Voltage" 아님)
          CAPACITY: string;
          SOC: string;
          INVENTORY_STATUS: string;
          ROUTE: string;
          ROUTE_NAME: string;
          ROUTE_TYPE: string;
          OPERATION: string;
          LINE: string;
          CURRENT_OP_START_DATE: string;
          REMAIN_LEAD_TIME: string;
          EXP_FORMATION_END_DATE: string;
          HOLD_YN: string;
          SPECIAL_YN: string;
          STOCK_QTY: string;
          AVAILABLE_QTY: string;
          HOLD_QTY: string;
          LONG_QTY: string;
          EXPIRATION_QTY: string;
          CUSTOMER: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * Inventory Raw — SSP0017 (신규 전환, 2026-09-26)
   *
   * AS-IS SSP0017_InventoryRaw(GSCM.SSP.Plan.UIL) — 단일 FpSpread(spdMain) 조회 전용 화면.
   * 전 컬럼 조회직후 편집잠금(LockColumn), Insert/Delete/Edit/Save 전부 NO-OP.
   * SHEETS (전부 SEARCH — 저장 없음):
   * - `main` SSP.SSP0017_GET_INVENTORY_RAW — MISSING(convert-sp 후속, all_objects 0건 실측).
   *   AS-IS IN 9개(division/plant_site/item_id/inventory_type/plan_start_yyyymmdd/user_id/
   *   program_id/sheet_name/language) 중 user_id/program_id/sheet_name/language 는 BE 세션·
   *   라우트 자동 주입이라 FE request 에는 5개(실 조회조건)만 싣는다(DMF0004 SalesSite 표준).
   * 정본: .atlas/gscm-design/SSP0017/design/00~03_*.md, convert-flow/goal.md·plan.md.
   */
  SSP0017: {
    main: {
      request: {
        divisionId: string; // p_division_id ("40" 고정, disabled)
        plantSite: string; // p_plant_site (다중 콤마, Division EE 분기 콤보 2종)
        itemId: string; // p_item_id (ItemByDivisionModal 반환)
        inventoryType: string; // p_inventory_type (LookupCommon INV_TYPE)
        planStartYyyymmdd: string; // p_plan_start_yyyymmdd (필수 — 콤보 SQL_ID 확인 필요, design 02 §2 주1)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          CUTOFF_YYYYMMDD: string;
          SRCE_DIVS_CD: string;
          STOCK_TYPE: string;
          STOCK_TYPE_NAME: string;
          PROJECT_CODE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          INCOTERMS: string;
          FROM_SITE_ID: string;
          SCM_SITE_ID: string;
          LOCATION_CODE: string; // Elec. Plant 전용(lookup OPMZ_LOCATION_CODE SEGMENT3='Y')
          INV_DATE: string;
          QTY: string | number;
          CHG_QTY: string | number;
          CHG_RSN: string;
          CHG_TYPE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_CHG_QTY: string | number;
          PRE_CHG_RSN: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0126 OPT CAPA — 8탭 마스터 편집 (convert-flow SCP0126, 2026-09-26 iter-4 등재).
   *
   * 아래 IN 키·OUT 커서명은 `SCM_ADM_PROC_M`(PROC_NM/COL_TP_CD/SORT_ORD/COL_NM) **실측값**이며
   * `ALL_ARGUMENTS`(SP 시그니처)·FE 조립 payload 3원천 전건 일치를 확인했다(178 파라미터).
   * 전건 **camelCase** 다 — snake `p_division_id` 로 보내면 NULL 바인딩된다.
   *
   * 시트명은 **B축**(`SCM_ADM_MNU_BTN_MPG_M.SHT_NM`)이다. 컬럼 메타 축(A축 =
   * `SCM_MST_SHEET_COLUMNS.SHEET_NAME` = `'No Work'`·`'Daily Capa'`·`'SOP/EOP'`·
   * `'Ramp-up(From/To)'`·`'Ramp-up(Interval)'`·`'Preparation Rate'`·`'Utilization Rate'`·
   * `'Yield(Elec.)'`, 131행)과 **값이 다르다** — 섞으면 조용히 컬럼 0건 또는 조회 0건이 된다.
   *
   * - `init`        `P_SCP0126_GET_CAPA_SEARCH_INFO` IN **0** / OUT 커서 `o_rc1`~`o_rc6`
   *     조회조건 마스터 6종. Plant/Line/Operation/LineType 은 CMBO 가 아니라 이 커서들의 클라 필터다.
   * - 그리드 8시트  GET IN **8 공통**(divisionId·planGrId·fromYyyymm·toYyyymm·plantId·lineId·
   *     nickName·itemId) / OUT 커서 `o_rc1`. `plantId`/`lineId` 는 CSV 이며 `''` 면 무필터다.
   *     SAVE 는 시트별 파라미터 수가 다르다(13~26) — `activeFlag` + 값 + `pre*` + `sesUserId` 규약.
   * - `noWorkBatch` `P_SCP0126_SAVE_NO_WORK_BATCH` IN 9 (SAVE 전용, 팝업)
   *     FE 는 `apiClient.post('/SCP0126/noWorkBatch/SAVE/call-proc')` 로 부른다(CLOB 평면 payload).
   * - `noWorkWeek`  GET IN 8 / SAVE IN 11 — **화면 미배선**(Week bucket 모드는 후속 회차, 판정 D-5).
   *     SP·버튼 메타는 배포돼 있으므로 라우팅 키만 등재해 `SHEETS` 유니온과 정합을 맞춘다.
   *
   * 저장은 `useProcMutation` 경유이고 그 `mutationFn` 인자 타입이 **response 행 타입**이라
   * (`useCustomQueryClient.ts:192`), 화면이 조립한 camelCase SAVE payload 가 대입되도록 각 행 타입에
   * index signature 를 둔다. 컬럼셋 자체는 admin 메타 구동이므로 아래 컬럼 목록은
   * `SCM_MST_SHEET_COLUMNS` 실측 전건(131행)이며 화면이 하드코딩하는 값이 아니다.
   */
  SCP0126: {
    init: {
      request: Record<string, never>;
      response: {
        /** Plant 마스터 — `SEQ` 2 = OSP. `ORG_DIVISION_ID` 는 `EE_UC` 축 전환용이다. */
        o_rc1: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          ORG_DIVISION_ID: string;
          SEQ: string | number;
          [key: string]: string | number;
        };
        /** Line 마스터 — `LINE_NAME`·`OPERATION_ID` 가 파생 2종(R-08·R-09)의 원천이다. */
        o_rc2: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          ORG_DIVISION_ID: string;
          PLANT_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          [key: string]: string | number;
        };
        /** Operation 후보(`CODE` = `NAME`). */
        o_rc3: {
          CODE: string;
          NAME: string;
          DIVISION_ID: string;
          SEQ: string | number;
          [key: string]: string | number;
        };
        /** 탭 표시제외 목록(`OPMZ_OPT_CAPA_EXPT_DIV`) — `SHEET_NAME` 은 **A축 표시명**이다. */
        o_rc4: {
          DIVISION_ID: string;
          SHEET_NAME: string;
          [key: string]: string | number;
        };
        /** Line Type 후보 — 행의 `OPERATION_ID` 로 좁힌다. */
        o_rc5: {
          CODE: string;
          NAME: string;
          OPERATION_ID: string;
          [key: string]: string | number;
        };
        /** No Work `TYPE` lookup 10건 — Day 모드에서는 소비처가 없다(Week 모드 후속). */
        o_rc6: {
          CODE: string;
          NAME: string;
          [key: string]: string | number;
        };
      };
    };
    noWork: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          CHK: string;
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          LINE_TYPE: string;
          NO_WORK_DATE: string;
          DAY_OF_WEEK: string;
          WEEK_NAME: string;
          OFF_TIME: string | number;
          NO_WORK_TYPE: string;
          DESC: string;
          VALID_YN: string;
          FIX: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    /** Week bucket 모드 — SP·버튼 메타만 존재하고 화면 배선 0건이다(판정 D-5, 후속 회차). */
    noWorkWeek: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          PLANT_ID: string;
          LINE_ID: string;
          OPERATION_ID: string;
          LINE_TYPE: string;
          WEEK_NAME: string;
          OFF_TIME: string | number;
          [key: string]: string | number;
        };
      };
    };
    /** No Work 일괄저장 팝업 — SAVE 전용(IN 9). GET 이 없어 response 는 표준 결과만 온다. */
    noWorkBatch: {
      request: {
        divisionId: string;
        lineId: string;
        startDate: string;
        endDate: string;
        /** 행 결합 CLOB — `,` 구분(`CString.AppendString` 규약). */
        seq: string;
        offTime: string;
        type: string;
        desc: string;
        sesUserId: string;
      };
      response: {
        o_rc1: {
          [key: string]: string | number;
        };
      };
    };
    dailyCapa: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // 원장 `SCP_OPMZ_DDLY_CAPA` 를 OUTER JOIN 하므로 아직 저장되지 않은 조합도 내려온다 —
        //   그 행은 `PRE_KEY_VALUES` 첫 토큰이 공백이고 저장 시 `'M'→'I'` 로 재판정된다.
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          NICK_NAME: string;
          ITEM_ID: string;
          YYYYMM: string;
          CAPA: string | number;
          M_MIN: string | number;
          LANE: string | number;
          WIDE_YN: string;
          PRDN_OPER_RT: string | number;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    sopEop: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          LINE_TYPE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          TYPE: string;
          DATE: string;
          DESC: string;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    rampUp: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          LINE_TYPE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          START_DATE: string;
          END_DATE: string;
          /** `SCP_OPMZ_RAMP_UP.EFCY` NOT NULL — 공백 저장은 ORA-01400 배치 전건 롤백이다. */
          EFCY: string | number;
          DESC: string;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    rampUpItvl: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          LINE_TYPE: string;
          NICK_NAME: string;
          ITEM_ID: string;
          START_DATE: string;
          ITVL1: string | number;
          EFCY1: string | number;
          ITVL2: string | number;
          EFCY2: string | number;
          ITVL3: string | number;
          EFCY3: string | number;
          ITVL4: string | number;
          EFCY4: string | number;
          DESC: string;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    prepRt: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          FROM_DATE: string;
          TO_DATE: string;
          PREP_RT: string | number;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    utilRt: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          LINE_ID: string;
          LINE_NAME: string;
          OPERATION_ID: string;
          FROM_DATE: string;
          TO_DATE: string;
          UTIL_RT: string | number;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
    yldElec: {
      request: {
        divisionId: string;
        planGrId: string;
        fromYyyymm: string;
        toYyyymm: string;
        plantId: string;
        lineId: string;
        nickName: string;
        itemId: string;
      };
      response: {
        // 2단 헤더 시트 — `ELEC_POST`/`ASSY` 가 `Yield(%)` 아래로 묶인다(메타 구동, 화면 무지정).
        o_rc1: {
          DIVISION_ID: string;
          OPMZ_PLAN_GR_NAME: string;
          PLANT_ID: string;
          NICK_NAME: string;
          ITEM_ID: string;
          YYYYMM: string;
          ELEC_POST: string | number;
          ASSY: string | number;
          VALID_YN: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          PRE_KEY_VALUES: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0055 Shipment(Allo) Report — PKG_SCP0055 MISSING(convert-sp 후속, 2026-09-26 실측).
   * main: GET(Main/Gap 공유, cboPlanDate/cboGapDate 로 기준일만 다름, design 03 §0) — 4결과셋
   *   (o_rc1=계획raw/o_rc2=팀행뼈대/o_rc3=실적raw/o_rc4=PlanType·Seq). SAVE 는 o_rc2 재사용
   *   (design 03 §4.3 — 비고 변경 행만 배열로 전송).
   * note: 비고 단건 조회(design 03 §4.2, 행 단위 개별 호출 — N+1 성능 개선 후보로 기록).
   */
  SCP0055: {
    main: {
      request: {
        divisionId: string; // P_DIVISION_ID (OnShown 고정 "40")
        bizType: string; // P_BIZ_TYPE(OperationGroup, OnShown 고정 "A")
        cellTypeGr: string; // P_CELL_TYPE_GR(OnShown 고정 "C")
        fromYyyymmdd: string; // P_FROM_YYYYMMDD(Period From, 월 1일)
        toYyyymmdd: string; // P_TO_YYYYMMDD(Period To, 월 말일)
        planStartYyyymmdd: string; // P_PLAN_START_YYYYMMDD(cboPlanDate 또는 cboGapDate — 탭별 기준일)
        fromsite: string; // P_FROMSITE(clbFromSite 콤마구분)
        teamId: string; // P_TEAM_ID(clbTeam 콤마구분)
        itemId: string; // P_ITEM_ID(txtModel_ID)
        nickname: string; // P_NICKNAME(txtNickName)
        programId: string; // P_PROGRAM_ID='SCP0055'
        sheetName: string; // P_SHEET_NAME
        userId: string; // P_USER_ID
        fcstYn: string; // P_FCST_YN(Y/N)
        debugMode: string; // DEBUG_MODE
      };
      response: {
        o_rc1: {
          SITE_NAME: string;
          EXTRA_SPEC: string;
          NICK_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          YYYYMMDD: string;
          QTY: number;
          [key: string]: string | number;
        };
        o_rc2: {
          SITE_NAME: string;
          SITE_ID: string;
          EXTRA_SPEC: string;
          NICK_NAME: string;
          DEPT_ID: string;
          DEPT_NAME: string;
          PLAN_DATE: string;
          GAP_DATE: string;
          NOTE: string;
          PROGRAM_ID: string;
          USER_ID: string;
          [key: string]: string | number;
        };
        o_rc3: {
          SITE_NAME: string;
          EXTRA_SPEC: string;
          NICK_NAME: string;
          DEPT_NAME: string;
          YYYYMMDD: string;
          QTY: number;
          [key: string]: string | number;
        };
        o_rc4: {
          PLAN_TYPE: string;
          SEQ: string;
          [key: string]: string | number;
        };
      };
    };
    note: {
      request: {
        siteId: string; // P_SITE_ID
        deptId: string; // P_DEPT_ID(요약행이면 sTEAM_NAME 대체, design 03 §4.2)
        nickName: string; // P_NICK_NAME
        planDate: string; // P_PLAN_DATE
        gapDate: string; // P_GAP_DATE
        programId: string; // P_PROGRAM_ID
      };
      response: {
        o_rc1: {
          NOTE: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0049 CAPA (Capacity) — 편집형 동적 pivot 화면 (신규 생성 2026-09-26, convert-flow SCP0049).
   *
   * domain SCP -> features/supply. 라우트는 폴더 + DB `ROUTE_PATH='supply/supply-master/capa'` 로만 해석.
   * `PKG_SCP0049` **배포·VALID**(ora.py 2026-09-26) — 아래 키는 `all_arguments`/`SCM_ADM_PROC_M`
   * 실측(camelCase COL_NM)이다. OUT 커서 `O_RC`/`O_RC2`/`O_RC3`/`O_RESULT_CURSOR` -> FE 읽기키
   * `o_rc`/`o_rc2`/`o_rc3`(소문자, 메모리 proc-cursor-key-colnm-vs-fe-read).
   * SHEETS: capa(SEARCH=P_GET_CAPA/SAVE=P_SAVE_CAPA) · userTitle(SEARCH=P_GET_SHEET_USER_TITLE) ·
   *   calendar(SEARCH=P_GET_SHEET_CALENDAR) · dayRange(SEARCH=P_GET_DAY_RANGE) ·
   *   newVersion(SEARCH=P_GET_NEW_VERSION_INFO/SAVE=P_SAVE_NEW_VERSION).
   *   newModel/mailSend 은 공용 `features/master/.../capaNewModelPopup` 이 apiClient.post 로 직접 소비.
   */
  SCP0049: {
    capa: {
      request: {
        todayYyyymmdd: string; // 1  P_TODAY_YYYYMMDD
        fromYyyymm: string; // 2  P_FROM_YYYYMM
        toYyyymm: string; // 3  P_TO_YYYYMM
        divisionId: string; // 4  P_DIVISION_ID
        group: string; // 5  P_GROUP        Operation group (CSV, 'ALL' -> SP NULL)
        plantId: string; // 6  P_PLANT_ID     이하 다중 CSV, 'ALL' -> SP NULL
        factoryId: string; // 7  P_FACTORY_ID   라벨 Building
        versionId: string; // 8  P_VERSION_ID   'Current' sentinel 포함
        lineId: string; // 9  P_LINE_ID
        operationId: string; // 10 P_OPERATION_ID
        modelId: string; // 11 P_MODEL_ID
        itemId: string; // 12 P_ITEM_ID
        nickName: string; // 13 P_NICK_NAME
        bucket: string; // 14 P_BUCKET       'M' | 'D,M'
        checkLoss: string; // 15 P_CHECK_LOSS   'Y'/'N'
        checkLine: string; // 16 P_CHECK_LINE
        checkTact: string; // 17 P_CHECK_TACT
        checkYield: string; // 18 P_CHECK_YIELD
        checkEmpty: string; // 19 P_CHECK_EMPTY
        userAuth: string; // 21 P_USER_AUTH    NowGroupID
        searchType: string; // 22 P_SEARCH_TYPE  'CAPA' | 'EXCEL'
        debugMode: string; // 23 DEBUG_MODE     'F'
        // 20 P_USER_ID = BE @LoginUser 자동 주입(FE 미전달)
      };
      response: {
        // 커서1 = 메인 그리드. 고정 43필드 + 동적 기간(D_/M_/Y_)은 인덱스 시그니처로 받는다(03 §4.1).
        o_rc: {
          DIVISION_ID: string;
          COMPANY_ID: string;
          SITE_ID: string;
          LOSS_CODE: string;
          EDITORBLE_YN: string;
          CATEGORY_ID: string;
          DATA_TABLE: string;
          ROW_RANKING: string;
          LANE_QTY: string;
          CONFIRM_FLAG: string;
          [key: string]: string | number;
        };
        // 커서2 = 확정률 헤더 요약(1행 4필드) — 영역1 R14.
        o_rc2: {
          TOT_PROGRESS: string;
          AUTO_PROGRESS: string;
          SMALL_PROGRESS: string;
          ELECTRODE_PROGRESS: string;
          [key: string]: string | number;
        };
        // 커서3 = PIC 필터 요약(1행 1필드).
        o_rc3: {
          FILTER: string;
          [key: string]: string | number;
        };
      };
    };
    userTitle: {
      request: { programId: string; sheetName: string; userId: string };
      response: {
        o_rc: {
          COLUMN_NAME: string;
          [key: string]: string | number;
        };
      };
    };
    calendar: {
      request: { todayYyyymmdd: string; fromYyyymm: string; toYyyymm: string; bucket: string };
      response: {
        o_rc: {
          COLUMN_NAME: string; // 'D_yyyymmdd' | 'M_yyyymm' | 'Y_yyyy'
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string;
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
    dayRange: {
      request: { createdBy: string; month: string | number };
      response: {
        o_rc: {
          FROM_VALUE: string;
          TO_VALUE: string;
          [key: string]: string | number;
        };
      };
    };
    // newVersion SHEET 은 SEARCH(P_GET_NEW_VERSION_INFO)/SAVE(P_SAVE_NEW_VERSION) 를 함께 라우팅한다.
    //   request = SEARCH 계약(Version Info 팝업 검색폼 — PROC_M COL_NM 실측 2026-09-26):
    //   fromDate/toDate/versionName/chkBp/chkRp/chkScp. SAVE 는 apiClient.post 로 별도 전송하며
    //   그 계약(todayYyyymmdd/chkBp/chkRp/chkScp/versionDivision/versionName/updateId)은 모달이 직접 조립한다.
    newVersion: {
      request: {
        fromDate: string;
        toDate: string;
        versionName: string;
        chkBp: string; // 'Y' | 'N'
        chkRp: string;
        chkScp: string;
      };
      response: {
        // Version Info 그리드(siMain, Roslyn 실측 10컬럼). 잉여 필드는 인덱스 시그니처.
        o_rc: {
          VERSION_ID: string;
          DIVISION_ID: string;
          VERSION_WEEK: string;
          VERSION_DATE: string;
          VERSION_TIME: string;
          VERSION_NAME: string;
          BP_USE_FLAG: string;
          RP_USE_FLAG: string;
          SCP_USE_FLAG: string;
          CONFIRMED_BY: string;
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0108 CAPA LOB Report — 전건 조회전용 Report (신규 생성 2026-09-25, convert-flow SCP0108).
   *
   * 시트 = `_progress_status == '0'` ? CURRENT : CUTOFF (AS-IS cs:376~389). 탭 UI 없음.
   * SHEETS (전부 SEARCH — **저장 SP 가 존재하지 않는다**, design 03 §4.3):
   * - `CURRENT`     SCP.SCP0108_GET_CAPA_LOB_CURRENT (IN 15 / OUT 커서 2 = 데이터 + Bottleneck)
   * - `CUTOFF`      SCP.SCP0108_GET_CAPA_LOB         (IN 15 동일 / OUT 커서 2)
   * - `spreadTitle` SCP.SCP0104_GET_SPREAD_TITLE     (SCP0104~0108 공용 — 동적 월/연 헤더)
   * `SCM_MST_SHEET_COLUMNS` 의 세 번째 sheetNm `MAIN`(15행 `VALID_YN='N'`)은 **그리드 시트가 아니다** —
   * 헤더 SP 의 lookup 매칭 키일 뿐이라 이 유니온에 넣지 않는다(design 03 §0.3).
   *
   * ⚠ `PKG_SCP0108`·`PKG_SCP0104` **미배포**(ALL_OBJECTS 0건, `SCM_ADM_PROC_M` 0건) — 아래 request 키는
   *   AS-IS SP IN 순서 + 이 레포 camelCase↔`P_SNAKE` 컨벤션으로 도출한 것이다. 배포 후 `all_arguments`
   *   실측으로 `convert-sp` 가 확정한다. 자매 capa-speed-plan(SCP0105)은 같은 공용 헤더 SP 에
   *   `p_from_yyyymm` 스네이크 키를 보내고 있어 **둘 중 하나는 PROC_M 등록 시 맞춰야 한다**(04 리포트 기재).
   * OUT 커서 이름도 미확정이라 화면은 `utils/capaLobReport.cursors.ts` 의 fallback chain 으로 읽는다(hook #80).
   */
  SCP0108: {
    // CURRENT / CUTOFF 는 IN 계약이 완전히 같다(design 03 §4.2) — 키 매핑으로 중복을 없앤다.
    [K in 'CURRENT' | 'CUTOFF']: {
      request: {
        version: string; // 1  P_VERSION      Plan Month(VER_ID, yyyyMM)
        versionSeq: number; // 2  P_VERSION_SEQ  VER_SEQ (AS-IS byte, 실패 시 0. CURRENT SP 는 미사용 — C-02)
        divisionId: string; // 3  P_DIVISION_ID
        siteId: string; // 4  P_SITE_ID      이하 6축 CSV, 무선택 = '' (무필터)
        plantId: string; // 5  P_PLANT_ID
        factoryId: string; // 6  P_FACTORY_ID   라벨은 Building (hook #112 rename)
        lineId: string; // 7  P_LINE_ID
        operationId: string; // 8  P_OPERATION_ID
        nickName: string; // 9  P_NICK_NAME    비어있지 않으면 DV='1' 합계행 추가
        electrodeType: string; // 10 P_ELECTRODE_TYPE  -> ELTR_LN_TP_CD IN (...)
        bottleneckFlag: string; // 11 P_BOTTLENECK_FLAG 'Y'/'N'/'' ('ALL' -> '')
        programId: string; // 12 P_PROGRAM_ID   'SCP0108'
        sheetName: string; // 13 P_SHEET_NAME   'CURRENT' | 'CUTOFF'
        // 14 P_USER_ID  = BE @LoginUser 자동 주입(두 SP 본문 미참조 — C-11)
        // 15 DEBUG_MODE = 리터럴 'F'(두 SP 본문 미참조)
      };
      response: {
        // 커서1 = 그리드 데이터. 기간 컬럼(M_01yyyymm / Y_yyyy)은 동적이라 인덱스 시그니처로 받는다.
        o_rc1: {
          DV: string; // '1'=NickName 합계행 / '2'=상세행 (CURRENT 메타엔 없지만 응답엔 있다)
          DIVISION_ID: string;
          SITE_ID: string;
          COMPANY_ID: string;
          PLANT_ID: string;
          LINE_ID: string;
          NICK_NAME: string;
          OPERATION_ID: string;
          OPERATION_NAME: string;
          ELTR_LN_TP_CD: string;
          [key: string]: string | number;
        };
        // 커서2 = Bottleneck 플래그(키 9축 + 기간별 'Y'/null). 행 인덱스가 아니라 키로 병합한다(R-11).
        o_rc2: {
          DV: string;
          DIVISION_ID: string;
          SITE_ID: string;
          COMPANY_ID: string;
          PLANT_ID: string;
          LINE_ID: string;
          NICK_NAME: string;
          OPERATION_ID: string;
          ELTR_LN_TP_CD: string;
          [key: string]: string | number;
        };
      };
    };
  } & {
    spreadTitle: {
      request: {
        fromYyyymm: string; // 1 P_FROM_YYYYMM  = Plan Month + 1개월 (6자리 아니면 호출 skip)
        programId: string; // 2 P_PROGRAM_ID   'SCP0108'
        sheetName: string; // 3 P_SHEET_NAME   **'MAIN' 리터럴** — CURRENT/CUTOFF 를 넘기면 1단 라벨이 사라진다
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // 'M_01202511' | 'Y_2028'
          COLUMN_LABEL_NAME: string; // '2025-11' | '2028'      <- 3단
          SMALL_CLASS_LABEL_NAME: string; // '2025'              <- 2단
          LARGE_CLASS_LABEL_NAME: string; // 'Operation Plan'    <- 1단
          DAY_CODE: string; // SCP0108 경로에서는 항상 ''
          SORT_ORDER_NO: string | number; // 12자리 고정폭 — 문자열 정렬이 표시 순서
          [key: string]: string | number;
        };
      };
    };
  };

  /**
   * SCP0107 CAPA TEEP Report — 전건 조회전용 Report (신규 생성 2026-09-25, convert-flow SCP0107).
   *
   * 시트 = `GetDivisionTypeName(_division_type)` (Electrode -> ELTR / Cell·Module·Pack -> ASSEMBLY).
   * 탭 UI 없음(`TabStripPolicy=Never`). SHEETS (전부 SEARCH — **저장 SP 가 존재하지 않는다**, design 03 §4.4):
   * - `ASSEMBLY`    SCP.SCP0107_GET_CAPA_TEEP_ASSEMBLY (IN 13 / OUT 커서 1)
   * - `ELTR`        SCP.SCP0107_GET_CAPA_TEEP_ELTR     (IN 13 동일 / OUT 커서 1)
   * - `spreadTitle` SCP.SCP0104_GET_SPREAD_TITLE       (SCP0104~0108 공용 — 동적 월/연 헤더)
   *
   * 주의: `PKG_SCP0107`·`PKG_SCP0104` **미배포**(ALL_OBJECTS 0건, ora.py 2026-09-25) — 아래 request 키는
   *   AS-IS SP IN 순서(design 02 §5.5) + 이 레포 camelCase↔`P_SNAKE` 컨벤션으로 도출한 것이다. 배포 후
   *   `all_arguments` 실측으로 `convert-sp` 가 확정한다. OUT 커서 이름도 미확정이라 화면은
   *   `utils/capaTeepReport.cursors.ts` 의 fallback chain 으로 읽는다(hook #80).
   * 주의: **`p_prog_stat`·`p_nick_name`·`p_from_yyyymm` 이 없다** — 자매 SCP0106 파라미터를 복사하지 말 것.
   *   기간 기준은 SP 가 `p_version` 에서 `DATEADD(MM,1,...)` 로 재계산한다(design 03 §2.1).
   */
  SCP0107: {
    // ASSEMBLY / ELTR 는 IN 계약이 완전히 같다(design 03 §4.2) — 키 매핑으로 중복을 없앤다.
    [K in 'ASSEMBLY' | 'ELTR']: {
      request: {
        version: string; // 1  P_VERSION      Plan Month(VER_ID, yyyyMM)
        versionSeq: number; // 2  P_VERSION_SEQ  VER_SEQ (AS-IS byte 캐스팅, 실패 시 0)
        divisionId: string; // 3  P_DIVISION_ID  다중 CSV. **ALL -> ''**(SP 가 전체로 해석)
        siteId: string; // 4  P_SITE_ID      이하 6축 CSV. ALL -> 후보 전건 CSV / 후보 0건 -> 'NONE'
        plantId: string; // 5  P_PLANT_ID
        factoryId: string; // 6  P_FACTORY_ID   라벨은 Building (hook #112 rename)
        lineId: string; // 7  P_LINE_ID
        operationId: string; // 8  P_OPERATION_ID    Electrode 에서 필드는 숨지만 값은 계속 실린다
        electrodeType: string; // 9  P_ELECTRODE_TYPE  동상
        programId: string; // 10 P_PROGRAM_ID   'SCP0107'
        sheetName: string; // 11 P_SHEET_NAME   'ASSEMBLY' | 'ELTR' (SCM_MST_SHEET_MEASURE 조회 키)
        // 12 P_USER_ID  = BE @LoginUser 자동 주입
        debugMode: string; // 13 DEBUG_MODE     리터럴 'F'
      };
      response: {
        // 커서1 = 그리드 데이터. 행 = Measure(피벗 세로축), 기간 컬럼(M_01yyyymm / Y_yyyy)은 동적이라
        //   인덱스 시그니처로 받는다. `MEASURE` 는 폭 0 숨김이지만 배경색·소수자릿수 판정 조건 컬럼이다.
        o_rc1: {
          DIVISION_ID: string;
          PLANT_NAME: string;
          FACTORY_NAME: string;
          LINE_NAME: string;
          OPERATION_NAME: string;
          ELTR_LN_TP_CD: string; // ASSEMBLY 만 반환(ELTR SP 는 미반환 — design 03 §1.6)
          MEASURE_GROUP: string;
          MEASURE_GROUP_NAME: string;
          MEASURE: string;
          MEASURE_NAME: string;
          SORT_ORDER_NO_GR: string | number; // 2=전체 Total / 3=Division Total / 0=상세
          BIZ_QTY: number;
          PRE_QTY: number;
          PFRSLT_QTY: number;
          BASE_QTY: number;
          [key: string]: string | number;
        };
      };
    };
  } & {
    spreadTitle: {
      request: {
        fromYyyymm: string; // 1 P_FROM_YYYYMM  = Plan Month **+1개월** (6자리 아니면 호출 skip)
        programId: string; // 2 P_PROGRAM_ID   'SCP0107'
        sheetName: string; // 3 P_SHEET_NAME   'ASSEMBLY' | 'ELTR' (lookup SCP_CAPA_RPT_CODE 매칭 키)
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // 'M_01202602' | 'Y_2029'
          COLUMN_LABEL_NAME: string; // '2026-02' | '2029'   <- 3단(월은 2자리로 잘라 표시, V-18)
          SMALL_CLASS_LABEL_NAME: string; // '2026'          <- 2단
          LARGE_CLASS_LABEL_NAME: string; // 'Operation Plan' <- 1단(공백이면 결함, V-16)
          DAY_CODE: string; // SCP0107 경로에서는 항상 ''
          SORT_ORDER_NO: string | number; // 12자리 고정폭 — 문자열 정렬이 표시 순서
          [key: string]: string | number;
        };
      };
    };
  };


  /**
   * SSP0015 Shipment Plan(Mobility & IT) / ShipmentPSI — master PSI pivot(2 시트: 일반/Packer) +
   *   detail 다중 sheet(편집 shtDetail·Hold/MES + 읽기전용). 신규 전환 2026-09-27.
   *   PKG_SSP0015 VALID(24 proc) — 파라미터는 ALL_ARGUMENTS 실측(ora.py 2026-09-27) 그대로.
   *   Division 은 '40' 고정(disabled). Plant Site 는 master 활성시트별 comboId 스왑
   *   (Main=ShipmentRequestPlantSite_SCP / Packer=FromSiteByDivisionOspPack, design 02 §2.2).
   *   Main(o_rc1)은 SP 가 D_/W_/M_/B_ 동적 컬럼을 서버 pivot(wide) 으로 반환.
   *   calendar = PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용) — 3단 헤더 메타.
   *   미이관(design 03 §6): shtDetail 셀콤보 TransMode/ShipToCode + PARAM2/ATTRIBUTE10='D'
   *   (05_register.sql 로 SCM_MST_SHEET_COLUMNS enrichment), PlanDateShip 콤보(PlanDate 재사용, Packer 확인필요).
   *   ERP 인터페이스 연쇄(GetERPInterface: SO_NO_CNT·CONFIRM_CHANGETIME·CHG_BATCH·RtFlag E/F/C_E)는
   *   convert-sp/런타임 후속 — FE 는 저장 라우팅 + 행별 필수검증 + 확인창까지(04_react-gap.md 확인필요).
   */
  /**
   * SSP0014 Shipment Model PIC — 단일 그리드(spdMain) 담당자 마스터.
   *   손으로 추가한 엔트리다(이 파일의 자동 생성기는 이 저장소에 없다). 근거는 전부 DB 실측
   *   (ora.py 2026-09-28) — 추정 없음:
   *     - request 7필드 = `SCM_ADM_PROC_M` PROC_NM='PKG_SSP0014.P_SSP0014_GET_MODEL_PIC',
   *       COL_TP_CD='IN', SORT_ORD 1~7 (OUT 은 o_rc1 CURSOR + O_RESULT_CURSOR PROC_RESULT).
   *     - response o_rc1 21열 = `SCM_MST_SHEET_COLUMNS` PROGRAM_ID='SSP0014' SORT_ORDER_NO 1~21.
   *       INPUT_TP_CD 분포도 함께 실측: USER_ID='M'(필수) / PART_LEADER·TEAM_LEADER·MAIL_USER1~5·
   *       VALID_YN 8열='O'(편집) / 나머지 12열='S'(조회전용) = AS-IS LockColumn(cs:274~278)과 1:1.
   *   SAVE(14 IN)·USER_CHECK(userId) 는 여기 넣지 않는다 — `call-proc` 직호출 경로라 화면 로컬 타입
   *   (`shipment-model-pic.types.ts` SaveRequest/SaveResultRow/UserCheckRequest)이 계약을 잡는다.
   */
  SSP0014: {
    main: {
      request: {
        divisionId: string; // 1 필수 단일 (권한 Division — 콤보 밖 값은 화면이 차단)
        operationGroup: string; // 2 P/A/E/W, ALL=''
        fromSite: string; // 3 Plant Site 다중 콤마
        validYn: string; // 4 Y/N, ALL=''
        itemId: string; // 5 Model 다건 콤마
        userId: string; // 6 LIKE (User ID(Name) 6필드 OR)
        language: string; // 7 세션 langCd (라벨/이름 언어 분기)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          OPERATION_GROUP: string;
          FROM_SITE: string;
          ITEM_ID: string;
          NICK_NAME: string;
          USER_ID: string;
          USER_NAME: string;
          PART_LEADER: string;
          PART_LEADER_NAME: string;
          TEAM_LEADER: string;
          TEAM_LEADER_NAME: string;
          MAIL_USER1: string;
          MAIL_USER2: string;
          MAIL_USER3: string;
          MAIL_USER4: string;
          MAIL_USER5: string;
          VALID_YN: string;
          CREATED_BY: string;
          CREATION_DATE: string;
          LAST_UPDATED_BY: string;
          LAST_UPDATE_DATE: string;
          // 공용 DataGrid 가 붙이는 편집 추적 키(CRUD_TYPE 등)를 위한 여유.
          [key: string]: string | number;
        };
      };
    };
  };
  /**
   * SSP0005 Shipment Working Day — 출하 근무일 달력 마스터(단일 그리드).
   *   손으로 추가한 엔트리다(이 파일의 자동 생성기는 이 저장소에 없다). 근거는 전부 DB 실측
   *   (ora.py 2026-09-29) — 추정 없음:
   *     - 'Shipment Working Day' request 5필드 = `SCM_ADM_PROC_M`
   *       PROC_NM='PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY', COL_TP_CD='IN', SORT_ORD 1~5
   *       (OUT 은 o_rc1 CURSOR + O_RESULT_CURSOR PROC_RESULT).
   *     - 시트명은 `SCM_MST_SHEET_COLUMNS.SHEET_NAME`(PROGRAM_ID='SSP0005') 과 같은
   *       'Shipment Working Day' 다 — `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` 도 같은 값으로 등록했다.
   *     - response o_rc1 정적 2열(COMPANY_ID/DIVISION_ID)은 컬럼 메타 실측 2행 그대로이고,
   *       D_YYYYMMDD 동적 일자열은 조회기간에 따라 달라져 index signature 로 받는다.
   *     - 'calendar' 는 공용 3단 헤더 SP(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN,
   *       API_ID='SCP0009_SHEET_CALENDAR_3SPAN_GET') 재사용이다 — PROC_M 실측 IN 2 / OUT o_rc1.
   *   SAVE(8 IN — 5 CLOB '^' 배열 + 3 VARCHAR2)와 GET_SCP_PERIOD 는 여기 넣지 않는다.
   *   `call-proc` 직호출 경로라 화면 로컬 타입(`shipment-working-day.types.ts`)이 계약을 잡는다.
   */
  SSP0005: {
    'Shipment Working Day': {
      request: {
        fromYyyymmdd: string; // 1 P_FROM_YYYYMMDD (yyyyMMdd)
        toYyyymmdd: string; // 2 P_TO_YYYYMMDD (yyyyMMdd)
        divisionId: string; // 3 P_DIVISION_ID — 'ALL' 금지, 권한 코드 콤마 전개(02 §4.4)
        companyId: string; // 4 P_COMPANY_ID (단일 선택)
        debugMode: string; // 5 P_DEBUG_MODE ('F' 고정)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          COMPANY_ID: string;
          // 동적 일자열 D_YYYYMMDD('Y'/'N'/null) + 공용 DataGrid 편집 추적 키(CRUD_TYPE 등).
          [key: string]: string | number;
        };
      };
    };
    calendar: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // 'D_'||BASIS_YYYYMMDD / 'W_'.. / 'M_'.. (컬럼이 되는 건 D_ 뿐)
          COLUMN_LABEL_NAME: string; // leaf(일) 라벨
          SMALL_CLASS_LABEL_NAME: string; // 2단(주차) 라벨
          LARGE_CLASS_LABEL_NAME: string; // 1단(월) 라벨
          DAY_CODE: string; // MON~SUN — 주말 헤더 색 원천(D_ 행에만 존재)
          SORT_ORDER_NO: string;
          [key: string]: string | number;
        };
      };
    };
  };
  SSP0015: {
    // Master PSI (일반 Mobility & IT) — GET_SHIPMENT_PSI 17 IN + o_rc1/o_rc2/o_rc3.
    //   SAVE = SAVE_SHIPMENT_PSI(WH_IN 측정치 D_셀 flat payload — apiClient.post call-proc 경로).
    main: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID ('40' 고정)
        fromSite: string; // 2 P_FROM_SITE (Plant Site 다중 콤마)
        itemId: string; // 3 P_ITEM_ID
        planStartYyyymmdd: string; // 4 P_PLAN_START_YYYYMMDD (=Plan Date)
        planType: string; // 5 P_PLAN_TYPE
        fromYyyymmdd: string; // 6 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 7 P_TO_YYYYMMDD
        userId: string; // 8 P_USER_ID
        myModelChk: string; // 9 P_MYMODELCHK (Y/N)
        programId: string; // 10 P_PROGRAM_ID
        sheetName: string; // 11 P_SHEET_NAME
        debugMode: string; // 12 P_DEBUG_MODE
        seq: string; // 13 P_SEQ
        partLeaderChk: string; // 14 P_PARTLEADERCHK
        teamLeaderChk: string; // 15 P_TEAMLEADERCHK
        nonChk: string; // 16 P_NONCHK
        delegateeChk: string; // 17 P_DELEGATEECHK
      };
      response: {
        // 서버 wide pivot — base 프레임 17열(design 03 §1.A) + 동적 D_/W_/M_/B_ 컬럼(런타임 키)
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          FROM_SITE_NM: string;
          ITEM_ID: string;
          NICK_NAME: string;
          TYPE: string;
          PSI_NAME: string;
          MEASURE: string;
          MEASURE_NAME: string;
          PLAN_TYPE: string;
          SEQ: string | number;
          PLAN_START_YYYYMMDD: string;
          TO_SITE: string;
          CONFIRM_DAY: string;
          [key: string]: string | number; // D_yyyymmdd / W_ / M_ / B_ 동적 컬럼
        };
        o_rc2: { [key: string]: string | number };
        o_rc3: { [key: string]: string | number };
      };
    };
    // Master PSI (Packer) — GET_SHIPMENT_PSI_PACKER 17 IN (일반과 동일 시그니처) + o_rc1.
    mainPacker: {
      request: {
        divisionId: string;
        fromSite: string;
        itemId: string;
        planStartYyyymmdd: string;
        planType: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        userId: string;
        myModelChk: string;
        programId: string;
        sheetName: string;
        debugMode: string;
        seq: string;
        partLeaderChk: string;
        teamLeaderChk: string;
        nonChk: string;
        delegateeChk: string;
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          MEASURE: string;
          MEASURE_NAME: string;
          TO_SITE: string;
          CONFIRM_DAY: string;
          [key: string]: string | number;
        };
      };
    };
    // 3단 헤더 캘린더 메타 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (공용)
    calendar: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // D_yyyymmdd / W_yyyymmWW / M_yyyymm
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string; // 요일 (토/일 헤더색 분기)
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
    // Detail 편집 그리드 — Shipment Confirm Detail (GET_SHIPMENT_CONFIRM_DETAIL 17 IN + o_rc1, 72열).
    //   SAVE = SAVE_SHIPMENT_REQUEST_CONFIRM_40(24 IN) → ERP 인터페이스 연쇄(convert-sp/런타임 후속).
    confirmDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        fromYyyymmdd: string; // 4 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 5 P_TO_YYYYMMDD
        planStartYyyymmdd: string; // 6 P_PLAN_START_YYYYMMDD
        language: string; // 7 P_LANGUAGE
        userId: string; // 8 P_USER_ID
        myModelChk: string; // 9 P_MYMODELCHK
        requestor: string; // 10 P_REQUESTOR
        partLeaderChk: string; // 11 P_PARTLEADERCHK
        teamLeaderChk: string; // 12 P_TEAMLEADERCHK
        searchYn: string; // 13 P_SEARCH_YN
        nonChk: string; // 14 P_NONCHK
        realFlag: string; // 15 P_REAL_FLAG
        debugMode: string; // 16 P_DEBUG_MODE
        delegateeChk: string; // 17 P_DELEGATEECHK
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          ITEM_ID: string;
          NICK_NAME: string;
          FROM_SITE: string;
          TO_SITE: string;
          SHIPMENT_CONFIRM_QTY: string | number;
          SHIPMENT_DATE: string;
          TRANSPORT_MODE: string;
          REMARKS: string;
          REMARKS2: string;
          CHANGE_REASON_CODE: string;
          CHANGE_REASON_DETAIL: string;
          SHIPMENT_STATUS: string;
          ERP_STATUS: string;
          ERP_SO_NO: string;
          CHANGE_REQ_NO: string;
          CONFIRM_ID: string;
          EDIT_MAIN: string;
          [key: string]: string | number; // 72컬럼 전체는 admin 메타 구동(SCM_MST_SHEET_COLUMNS)
        };
      };
    };
    // Hold stock (편집 insert) — GET_BLOCK_STOCK 14 IN + o_rc1. SAVE = SAVE_BLOCK_STOCK_DATA(13 IN).
    holdStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        planStartYyyymmdd: string; // 4 P_PLAN_START_YYYYMMDD
        planType: string; // 5 P_PLAN_TYPE
        seq: string; // 6 P_SEQ
        language: string; // 7 P_LANGUAGE
        searchYn: string; // 8 P_SEARCH_YN
        userId: string; // 9 P_USER_ID
        myModelChk: string; // 10 P_MYMODELCHK
        partLeaderChk: string; // 11 P_PARTLEADERCHK
        teamLeaderChk: string; // 12 P_TEAMLEADERCHK
        nonChk: string; // 13 P_NONCHK
        delegateeChk: string; // 14 P_DELEGATEECHK
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          ITEM_ID: string;
          NICK_NAME: string;
          HOLD_YYYYMMDD: string;
          RELEASE_YYYYMMDD: string;
          HOLD_QTY: string | number;
          REMARKS: string;
          [key: string]: string | number;
        };
      };
    };
    // MES Stock (편집) — GET_MES_STOCK 12 IN. SAVE = SAVE_MES_STOCK(11 IN).
    mesStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        planStartYyyymmdd: string; // 4 P_PLAN_START_YYYYMMDD
        userId: string; // 5 P_USER_ID
        lotId: string; // 6 P_LOT_ID
        myModelChk: string; // 7 P_MYMODELCHK
        partLeaderChk: string; // 8 P_PARTLEADERCHK
        teamLeaderChk: string; // 9 P_TEAMLEADERCHK
        delegateeChk: string; // 10 P_DELEGATEECHK
        nonChk: string; // 11 P_NONCHK
        language: string; // 12 P_LANGUAGE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    // W/H Stock — GET_WH_STOCK 13 IN (읽기전용)
    whStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        itemId: string; // 2 P_ITEM_ID
        planStartYyyymmdd: string; // 3 P_PLAN_START_YYYYMMDD
        planType: string; // 4 P_PLAN_TYPE
        planSeq: string; // 5 P_PLAN_SEQ
        fromSite: string; // 6 P_FROM_SITE
        userId: string; // 7 P_USER_ID
        myModelChk: string; // 8 P_MYMODELCHK
        partLeaderChk: string; // 9 P_PARTLEADERCHK
        teamLeaderChk: string; // 10 P_TEAMLEADERCHK
        searchYn: string; // 11 P_SEARCH_YN
        nonChk: string; // 12 P_NONCHK
        delegateeChk: string; // 13 P_DELEGATEECHK
      };
      response: { o_rc1: { STOCK_STATUS: string; [key: string]: string | number } };
    };
    // SCS Stock — GET_SCS_STOCK 10 IN (읽기전용)
    scsStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        planStartYyyymmdd: string; // 2 P_PLAN_START_YYYYMMDD
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        userId: string; // 5 P_USER_ID
        myModelChk: string; // 6 P_MYMODELCHK
        partLeaderChk: string; // 7 P_PARTLEADERCHK
        teamLeaderChk: string; // 8 P_TEAMLEADERCHK
        delegateeChk: string; // 9 P_DELEGATEECHK
        nonChk: string; // 10 P_NONCHK
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    // Stock Location Detail — GET_STOCK_LOCATION_DETAIL 16 IN (읽기전용)
    stockLocationDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        planStartYyyymmdd: string; // 5 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 6 P_DBL_FLAG
        language: string; // 7 P_LANGUAGE
        programId: string; // 8 P_PROGRAM_ID
        sheetName: string; // 9 P_SHEET_NAME
        debugMode: string; // 10 P_DEBUG_MODE
        userId: string; // 11 P_USER_ID
        myModelChk: string; // 12 P_MYMODELCHK
        partLeaderChk: string; // 13 P_PARTLEADERCHK
        teamLeaderChk: string; // 14 P_TEAMLEADERCHK
        delegateeChk: string; // 15 P_DELEGATEECHK
        nonChk: string; // 16 P_NONCHK
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    // Shipment Result — GET_SHIPMENT_RESULT 15 IN (읽기전용)
    shipmentResult: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        fromYyyymmdd: string; // 4 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 5 P_TO_YYYYMMDD
        type: string; // 6 P_TYPE (Result Type 콤마 다중)
        userId: string; // 7 P_USER_ID
        companyId: string; // 8 P_COMPANY_ID
        myModelChk: string; // 9 P_MYMODELCHK
        partLeaderChk: string; // 10 P_PARTLEADERCHK
        teamLeaderChk: string; // 11 P_TEAMLEADERCHK
        delegateeChk: string; // 12 P_DELEGATEECHK
        nonChk: string; // 13 P_NONCHK
        realFlag: string; // 14 P_REAL_FLAG
        planStartYyyymmdd: string; // 15 P_PLAN_START_YYYYMMDD
      };
      response: { o_rc1: { DIVISION_ID: string; [key: string]: string | number } };
    };
  };


  /**
   * SSP0060 Shipment Plan — PSI 듀얼그리드(Main pivot + Detail 8-sheet). 신규 전환 2026-09-25.
   *   PKG_SSP0060 VALID(18 proc) — 파라미터는 ALL_ARGUMENTS 실측(ora.py 2026-09-25) 그대로.
   *   Main(o_rc1)은 SP 가 D_/W_/M_ 동적 컬럼을 서버 pivot(wide) 으로 반환한다
   *   (PKG BODY L3376~3495 실측 — 설계문서 03 §2.4 의 "클라 pivot 추정"과 다름).
   *   calendar = PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용) — 3단 헤더 메타.
   *   holdStock SAVE(SSP0060_SAVE_HOLD_STOCK_DATA)는 TO-BE/AS-IS DB 양쪽 모두 미존재(실측) —
   *   convert-sp 후속. planDetail SAVE = SAVE_SHIPMENT_REQUEST_CONFIRM(38 IN 실측).
   */
  SSP0060: {
    // Division/Company 2-cursor 전용 SP (P_SSP0060_GET_SHIPMENT_DIVISION — 콤보 레지스트리 아님)
    division: {
      request: {
        param1: string; // 1 PARAM1 = 세션 groupId (AS-IS NowGroupID)
        param2: string; // 2 PARAM2 = 세션 userId
      };
      response: {
        o_rc1: { CODE: string; NAME: string; ATTRIBUTE1: string | number }; // Division (1=일반, 0=VP)
        o_rc2: { CODE: string; NAME: string; DIVISION_ID: string }; // Company (전 Division, 클라 필터용 DIVISION_ID 포함)
      };
    };
    // 3단 헤더 캘린더 메타 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (공용)
    calendar: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // D_yyyymmdd / W_yyyymmWW / M_yyyymm
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string; // 요일 (토/일 헤더색 분기)
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
    // Main PSI — GET 12 IN 실측. SAVE(15 IN: +activeFlag/toSite/transportMode/incoterms/fcstType/
    //   yyyymmdd/shipmentQty/userDeptId/debugMode)는 편집 D_셀 flat payload 수동 조립(apiClient.post) 경로.
    main: {
      request: {
        divisionId: string; // GET 1 P_DIVISION_ID
        companyId: string; // GET 2 P_COMPANY_ID
        fromSite: string; // GET 3 P_FROM_SITE
        planStartYyyymmdd: string; // GET 4 P_PLAN_START_YYYYMMDD (=선택 Plan Date)
        fromYyyymmdd: string; // GET 5 P_FROM_YYYYMMDD
        toYyyymmdd: string; // GET 6 P_TO_YYYYMMDD
        itemId: string; // GET 7 P_ITEM_ID
        productLevel1: string; // GET 8 P_PRODUCT_LEVEL1
        userId: string; // GET 9 P_USER_ID
        programId: string; // GET 10 P_PROGRAM_ID ('SSP0060')
        sheetName: string; // GET 11 P_SHEET_NAME ('Shipment Plan')
        realFlag: string; // GET 12 P_REAL_FLAG ('Y'=최신 Plan)
      };
      response: {
        // 서버 wide pivot — base 컬럼 + 동적 D_/W_/M_ 컬럼(런타임 키)
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          FROM_SITE_DESCRIPTION: string;
          PRODUCT_LEVEL1: string;
          ITEM_ID: string;
          NICK_NAME: string;
          BOH_TYPE: string;
          BOH_QTY: string | number;
          PSI: string;
          MEASURE: string;
          MEASURE_NAME: string;
          TO_SITE: string;
          TRANSPORT_MODE: string;
          INCOTERMS: string;
          FCST_TYPE: string;
          ORD_SEQ: string | number;
          SEQ: string | number;
          CONFIRM_DAY: string;
          BACK_COLOR: string;
          LOT_YN: string;
          [key: string]: string | number; // D_yyyymmdd / W_ / M_ 동적 수량 컬럼
        };
        o_rc2: { [key: string]: string | number };
      };
    };
    // Detail — Shipment Plan Detail (GET 19 IN 실측). SAVE=SAVE_SHIPMENT_REQUEST_CONFIRM(38 IN 실측 —
    //   P_CHANGE_REQUEST_NO/P_CONFIRM_ID/P_NEW_* 14종/P_REMARKS3/P_CHECK_NEED_YN/P_EDIT_MAIN/P_TOP_FLAG 포함)는
    //   그리드 행(payload=행 컬럼) 전송 — 컬럼↔파라미터 매핑은 PROC_M(convert-sp 소관).
    planDetail: {
      request: {
        divisionId: string; // GET 1 P_DIVISION_ID
        companyId: string; // GET 2 P_COMPANY_ID
        fromSite: string; // GET 3 P_FROM_SITE
        itemId: string; // GET 4 P_ITEM_ID
        productLevel1: string; // GET 5 P_PRODUCT_LEVEL1
        requestor: string; // GET 6 P_REQUESTOR
        toSite: string; // GET 7 P_TO_SITE
        transportMode: string; // GET 8 P_TRANSPORT_MODE
        incoterms: string; // GET 9 P_INCOTERMS
        fcstType: string; // GET 10 P_FCST_TYPE
        planStartYyyymmdd: string; // GET 11 P_PLAN_START_YYYYMMDD
        fromYyyymmdd: string; // GET 12 P_FROM_YYYYMMDD
        toYyyymmdd: string; // GET 13 P_TO_YYYYMMDD
        dblFlag: string; // GET 14 P_DBL_FLAG (Main 더블클릭 드릴다운 'Y')
        realFlag: string; // GET 15 P_REAL_FLAG
        language: string; // GET 16 P_LANGUAGE
        programId: string; // GET 17 P_PROGRAM_ID
        sheetName: string; // GET 18 P_SHEET_NAME
        debugMode: string; // GET 19 DEBUG_MODE
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          ITEM_ID: string;
          NICK_NAME: string;
          FROM_SITE: string;
          TO_SITE: string;
          SHIPMENT_CONFIRM_QTY: string | number;
          SHIPMENT_DATE: string;
          TRANSPORT_MODE: string;
          REMARKS: string;
          REMARKS2: string;
          CHANGE_REASON_CODE: string;
          CHANGE_REASON_DETAIL: string;
          SHIPMENT_STATUS: string;
          ERP_STATUS: string;
          ERP_SO_NO: string;
          CHANGE_REQ_NO: string;
          EDIT_MAIN: string;
          [key: string]: string | number; // 71컬럼 전체는 admin 메타 구동 (SCM_MST_SHEET_COLUMNS)
        };
      };
    };
    // 읽기전용 Detail 5-sheet + HoldStock 2-sheet — GET IN 목록 ALL_ARGUMENTS 실측
    stockDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        productLevel1: string; // 5 P_PRODUCT_LEVEL1
        planStartYyyymmdd: string; // 6 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 7 P_DBL_FLAG
        language: string; // 8 P_LANGUAGE
        programId: string; // 9 P_PROGRAM_ID
        sheetName: string; // 10 P_SHEET_NAME
        debugMode: string; // 11 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    owmsDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        productLevel1: string; // 5 P_PRODUCT_LEVEL1
        planStartYyyymmdd: string; // 6 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 7 P_DBL_FLAG
        language: string; // 8 P_LANGUAGE
        programId: string; // 9 P_PROGRAM_ID
        sheetName: string; // 10 P_SHEET_NAME
        debugMode: string; // 11 DEBUG_MODE
      };
      response: { o_rc1: { STOCK_STATUS: string; [key: string]: string | number } };
    };
    holdStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        productLevel1: string; // 4 P_PRODUCT_LEVEL1
        planStartYyyymmdd: string; // 5 P_PLAN_START_YYYYMMDD
        planType: string; // 6 P_PLAN_TYPE
        seq: string; // 7 P_SEQ
        language: string; // 8 P_LANGUAGE
        searchYn: string; // 9 P_SEARCH_YN
        userId: string; // 10 P_USER_ID
        // SAVE(SSP0060_SAVE_HOLD_STOCK_DATA)는 TO-BE/AS-IS DB 공히 미존재(실측) — convert-sp 후속.
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          ITEM_ID: string;
          NICK_NAME: string;
          HOLD_YYYYMMDD: string;
          RELEASE_YYYYMMDD: string;
          HOLD_QTY: string | number;
          REMARKS: string;
          [key: string]: string | number;
        };
      };
    };
    mesStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        productLevel1: string; // 5 P_PRODUCT_LEVEL1
        planStartYyyymmdd: string; // 6 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 7 P_DBL_FLAG
        language: string; // 8 P_LANGUAGE
        programId: string; // 9 P_PROGRAM_ID
        sheetName: string; // 10 P_SHEET_NAME
        debugMode: string; // 11 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    mesStockDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        productLevel1: string; // 5 P_PRODUCT_LEVEL1
        boxId: string; // 6 P_BOX_ID
        planStartYyyymmdd: string; // 7 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 8 P_DBL_FLAG
        language: string; // 9 P_LANGUAGE
        programId: string; // 10 P_PROGRAM_ID
        sheetName: string; // 11 P_SHEET_NAME
        debugMode: string; // 12 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    shipmentResult: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        productLevel1: string; // 4 P_PRODUCT_LEVEL1
        fromYyyymmdd: string; // 5 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 6 P_TO_YYYYMMDD
        type: string; // 7 P_TYPE (Result Type 콤마 다중)
        userId: string; // 8 P_USER_ID
        companyId: string; // 9 P_COMPANY_ID
        myModelChk: string; // 10 P_MYMODELCHK
        partLeaderChk: string; // 11 P_PARTLEADERCHK
        teamLeaderChk: string; // 12 P_TEAMLEADERCHK
        delegateeChk: string; // 13 P_DELEGATEECHK
        nonChk: string; // 14 P_NONCHK
        realFlag: string; // 15 P_REAL_FLAG
        planStartYyyymmdd: string; // 16 P_PLAN_START_YYYYMMDD
      };
      response: { o_rc1: { DIVISION_ID: string; [key: string]: string | number } };
    };
    // 화면 전용 팝업(ConfirmDetail·저장 후 Request) 공용 GET — 3 IN / o_rc1·o_rc2
    confirmDetail: {
      request: {
        changeRequestNo: string; // 1 P_CHANGE_REQUEST_NO ('' = Request 팝업 경로)
        userId: string; // 2 P_USER_ID
        language: string; // 3 P_LANGUAGE
      };
      response: {
        o_rc1: { CHANGE_REQ_NO: string; [key: string]: string | number };
        o_rc2: { [key: string]: string | number };
      };
    };
    // 저장 후 Request 팝업의 Request 실행 — SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN 13 IN 실측
    requestDraftingMain: {
      request: {
        activeFlag: string; // 1 P_ACTIVE_FLAG
        divisionId: string; // 2 P_DIVISION_ID
        changeReqNo: string; // 3 P_CHANGE_REQ_NO
        confirmId: string; // 4 P_CONFIRM_ID
        shipmentQty: string; // 5 P_SHIPMENT_QTY
        shipmentDate: string; // 6 P_SHIPMENT_DATE
        newYyyymmdd: string; // 7 P_NEW_YYYYMMDD
        newQty: string; // 8 P_NEW_QTY
        userId: string; // 9 P_USER_ID
        changeReasonCode: string; // 10 P_CHANGE_REASON_CODE
        changeReasonDetail: string; // 11 P_CHANGE_REASON_DETAIL
        title: string; // 12 P_TITLE
        programId: string; // 13 P_PROGRAM_ID
      };
      response: {
        o_rc1: { [key: string]: string | number };
        o_rc2: { [key: string]: string | number };
      };
    };
  };


  /**
   * SSP0021 Shipment Plan — PSI 듀얼그리드(Main pivot + Detail 7-sheet). 신규 전환 2026-09-27.
   *   PKG_SSP0021 VALID(15 proc) — 파라미터는 ALL_ARGUMENTS 실측(ora.py 2026-09-27) 그대로.
   *   자매 SSP0060(Shipment Plan(Auto & ESS))과 동일 계열이나 SSP0021 은 Product Level·Tot PSI 가
   *   없고 Main 직접 저장 경로가 없다(편집 SHIP_PLAN → Simulation → Detail Confirm 저장, design 03 §4.1).
   *   Division/Company 는 2-cursor 전용 SP(P_SSP0021_GET_SHIPMENT_DIVISION — 콤보 레지스트리 아님,
   *   VP/NERP/81_UC 를 서버에서 재현). calendar = PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN(공용).
   *   Drafting(3경로 ERP IF 체인)·Hold Detail 편집은 SP 미배포(convert-sp 후속). planDetail SAVE =
   *   P_SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM(24 IN 실측).
   */
  SSP0021: {
    // Division/Company 2-cursor 전용 SP (P_SSP0021_GET_SHIPMENT_DIVISION — PARAM1=groupId, PARAM2=userId)
    division: {
      request: {
        param1: string; // 1 PARAM1 = 세션 groupId (AS-IS NowGroupID)
        param2: string; // 2 PARAM2 = 세션 userId
      };
      response: {
        o_rc1: { CODE: string; NAME: string; ATTRIBUTE1: string | number }; // Division (VP UNION 포함)
        o_rc2: { CODE: string; NAME: string; DIVISION_ID: string }; // Company (전 Division, 클라 필터용 DIVISION_ID 포함)
      };
    };
    // 3단 헤더 캘린더 메타 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN (공용)
    calendar: {
      request: {
        startYyyymmdd: string; // 1 P_START_YYYYMMDD
        endYyyymmdd: string; // 2 P_END_YYYYMMDD
      };
      response: {
        o_rc1: {
          COLUMN_NAME: string; // D_yyyymmdd / W_yyyymmWW / M_yyyymm
          COLUMN_LABEL_NAME: string;
          SMALL_CLASS_LABEL_NAME: string;
          LARGE_CLASS_LABEL_NAME: string;
          DAY_CODE: string; // 요일 (토/일 헤더색 분기)
          SORT_ORDER_NO: string | number;
          [key: string]: string | number;
        };
      };
    };
    // Main PSI — GET 11 IN 실측(P_SSP0021_GET_SHIPMENT_PLAN — Product Level 없음). Main 직접 SAVE 없음
    //   (편집 SHIP_PLAN → Simulation → Detail Confirm 저장, design 03 §4.1). o_rc1 = 서버 wide pivot.
    main: {
      request: {
        divisionId: string; // GET 1 P_DIVISION_ID
        companyId: string; // GET 2 P_COMPANY_ID
        fromSite: string; // GET 3 P_FROM_SITE
        planStartYyyymmdd: string; // GET 4 P_PLAN_START_YYYYMMDD (=선택 Plan Date)
        fromYyyymmdd: string; // GET 5 P_FROM_YYYYMMDD
        toYyyymmdd: string; // GET 6 P_TO_YYYYMMDD
        itemId: string; // GET 7 P_ITEM_ID
        userId: string; // GET 8 P_USER_ID
        programId: string; // GET 9 P_PROGRAM_ID ('SSP0021')
        sheetName: string; // GET 10 P_SHEET_NAME ('Shipment Plan')
        realFlag: string; // GET 11 P_REAL_FLAG ('Y'=최신 Plan)
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          FROM_SITE_DESCRIPTION: string;
          ITEM_ID: string;
          NICK_NAME: string;
          BOH_TYPE: string;
          BOH_QTY: string | number;
          PSI: string;
          MEASURE: string;
          MEASURE_NAME: string;
          TO_SITE: string;
          CONFIRM_DAY: string;
          BACK_COLOR: string;
          LOT_YN: string;
          SEQ: string | number;
          [key: string]: string | number; // D_yyyymmdd / W_ / M_ 동적 수량 컬럼
        };
        o_rc2: { [key: string]: string | number };
      };
    };
    // Detail — Shipment Plan Detail (GET 14 IN 실측). SAVE=SAVE_SHIPMENT_REQUEST_CONFIRM(24 IN 실측)는
    //   그리드 행(payload=행 컬럼) 전송 — 컬럼↔파라미터 매핑은 PROC_M(convert-sp 소관).
    planDetail: {
      request: {
        divisionId: string; // GET 1 P_DIVISION_ID
        companyId: string; // GET 2 P_COMPANY_ID
        fromSite: string; // GET 3 P_FROM_SITE
        itemId: string; // GET 4 P_ITEM_ID
        requestor: string; // GET 5 P_REQUESTOR
        planStartYyyymmdd: string; // GET 6 P_PLAN_START_YYYYMMDD
        fromYyyymmdd: string; // GET 7 P_FROM_YYYYMMDD
        toYyyymmdd: string; // GET 8 P_TO_YYYYMMDD
        dblFlag: string; // GET 9 P_DBL_FLAG (Main 더블클릭 드릴다운 'Y')
        realFlag: string; // GET 10 P_REAL_FLAG
        language: string; // GET 11 P_LANGUAGE
        programId: string; // GET 12 P_PROGRAM_ID
        sheetName: string; // GET 13 P_SHEET_NAME
        debugMode: string; // GET 14 DEBUG_MODE
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          ITEM_ID: string;
          NICK_NAME: string;
          FROM_SITE: string;
          TO_SITE: string;
          SHIPMENT_CONFIRM_QTY: string | number;
          SHIPMENT_DATE: string;
          TRANSPORT_MODE: string;
          REMARKS: string;
          REMARKS2: string;
          CHANGE_REASON_CODE: string;
          CHANGE_REASON_DETAIL: string;
          SHIPMENT_STATUS: string;
          ERP_STATUS: string;
          ERP_SO_NO: string;
          CONFIRM_ID: string;
          EDIT_MAIN: string;
          [key: string]: string | number; // 69컬럼 전체는 admin 메타 구동 (SCM_MST_SHEET_COLUMNS)
        };
      };
    };
    // 읽기전용 Detail 5-sheet + HoldStock — GET IN 목록 ALL_ARGUMENTS 실측(Product Level 없음)
    stockDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        planStartYyyymmdd: string; // 5 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 6 P_DBL_FLAG
        language: string; // 7 P_LANGUAGE
        programId: string; // 8 P_PROGRAM_ID
        sheetName: string; // 9 P_SHEET_NAME
        debugMode: string; // 10 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    owmsDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        planStartYyyymmdd: string; // 5 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 6 P_DBL_FLAG
        language: string; // 7 P_LANGUAGE
        programId: string; // 8 P_PROGRAM_ID
        sheetName: string; // 9 P_SHEET_NAME
        debugMode: string; // 10 DEBUG_MODE
      };
      response: { o_rc1: { STOCK_STATUS: string; [key: string]: string | number } };
    };
    holdStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        planStartYyyymmdd: string; // 4 P_PLAN_START_YYYYMMDD
        planType: string; // 5 P_PLAN_TYPE
        seq: string; // 6 P_SEQ
        language: string; // 7 P_LANGUAGE
        searchYn: string; // 8 P_SEARCH_YN
        userId: string; // 9 P_USER_ID
        // SAVE(HOLD_STOCK)·Hold Detail GET 은 미배포(표시전용) — convert-sp 후속.
      };
      response: {
        o_rc1: {
          DIVISION_ID: string;
          FROM_SITE: string;
          ITEM_ID: string;
          NICK_NAME: string;
          HOLD_YYYYMMDD: string;
          RELEASE_YYYYMMDD: string;
          HOLD_QTY: string | number;
          REMARKS: string;
          [key: string]: string | number;
        };
      };
    };
    mesStock: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        planStartYyyymmdd: string; // 5 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 6 P_DBL_FLAG
        language: string; // 7 P_LANGUAGE
        programId: string; // 8 P_PROGRAM_ID
        sheetName: string; // 9 P_SHEET_NAME
        debugMode: string; // 10 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    mesStockDetail: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        companyId: string; // 2 P_COMPANY_ID
        fromSite: string; // 3 P_FROM_SITE
        itemId: string; // 4 P_ITEM_ID
        boxId: string; // 5 P_BOX_ID
        planStartYyyymmdd: string; // 6 P_PLAN_START_YYYYMMDD
        dblFlag: string; // 7 P_DBL_FLAG
        language: string; // 8 P_LANGUAGE
        programId: string; // 9 P_PROGRAM_ID
        sheetName: string; // 10 P_SHEET_NAME
        debugMode: string; // 11 DEBUG_MODE
      };
      response: { o_rc1: { [key: string]: string | number } };
    };
    shipmentResult: {
      request: {
        divisionId: string; // 1 P_DIVISION_ID
        fromSite: string; // 2 P_FROM_SITE
        itemId: string; // 3 P_ITEM_ID
        fromYyyymmdd: string; // 4 P_FROM_YYYYMMDD
        toYyyymmdd: string; // 5 P_TO_YYYYMMDD
        type: string; // 6 P_TYPE (Result Type 콤마 다중)
        userId: string; // 7 P_USER_ID
        companyId: string; // 8 P_COMPANY_ID
        myModelChk: string; // 9 P_MYMODELCHK
        partLeaderChk: string; // 10 P_PARTLEADERCHK
        teamLeaderChk: string; // 11 P_TEAMLEADERCHK
        delegateeChk: string; // 12 P_DELEGATEECHK
        nonChk: string; // 13 P_NONCHK
        realFlag: string; // 14 P_REAL_FLAG
        planStartYyyymmdd: string; // 15 P_PLAN_START_YYYYMMDD
      };
      response: { o_rc1: { DIVISION_ID: string; [key: string]: string | number } };
    };
  };

  /**
   * Shipment Change Request Confirm — SSP0003 (Read-only 승인, master-detail 2그리드 + 액션 3종)
   *
   * AS-IS GSCM.SSP.Plan.UIL/SSP0003_ShipmentChangeRequestConfirm.cs (2018행).
   * request 키는 SCM_ADM_PROC_M COL_NM 실측(ora.py)과 1:1 일치 — BaseService.makeProcedure 가 COL_NM 키로
   * 값을 찾으므로 오타 키는 예외 없이 NULL 바인딩된다([[generic-callproc-param-key-must-match-proc-m-colnm]]).
   * SHEETS (GET):
   * - `main`     PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM (9 IN · o_rc1)
   * - `sub`      PKG_SSP0003.P_SSP0003_GET_REQ_DRAFTING     (2 IN · o_rc1=그리드/o_rc2=폼)
   * - `delegate` PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD   (2 IN · o_rc1) — apploval 은 SP 파라미터 오타 그대로 등재
   * response 는 컬럼 메타(SCM_MST_SHEET_COLUMNS) 위임이라 행 shape 을 WijmoRowItem 으로 loose 유지(Base 동등).
   */
  SSP0003: {
    main: {
      request: {
        divisionId: string; // 1 divisionId (다중 콤마, EE 제외)
        fromSite: string; // 2 fromSite
        requestId: string; // 3 requestId (Requestor 다건)
        fromYyyymmdd: string; // 4 fromYyyymmdd
        toYyyymmdd: string; // 5 toYyyymmdd
        status: string; // 6 status (기본 Q)
        language: string; // 7 language (@sesLangCd)
        itemId: string; // 8 itemId (Model 다건)
        changeType: string; // 9 changeType (기본 ALL)
      };
      response: { o_rc1: WijmoRowItem };
    };
    sub: {
      request: {
        changeRequestNo: string; // 1 changeRequestNo (마스터 CHANGE_REQ_NO)
        language: string; // 2 language
      };
      response: { o_rc1: WijmoRowItem; o_rc2: WijmoRowItem };
    };
    delegate: {
      request: {
        divisionId: string; // 1 divisionId
        apploval: string; // 2 apploval (SP 파라미터명 오타 그대로 — 승인자)
      };
      response: { o_rc1: WijmoRowItem };
    };
  };

}

type ProcessedProcedures = {
  [M in keyof RawProcedureMap]: {
    [S in keyof RawProcedureMap[M]]: {
      request: RawProcedureMap[M][S]['request'];
      response: {
        [RS in keyof RawProcedureMap[M][S]['response']]:
        (RawProcedureMap[M][S]['response'][RS] & { CRUD_TYPE?: string });
      };
    };
  };
};

declare global {
  type ProcedureMap = ProcessedProcedures;

  type MenuId = keyof ProcedureMap;
  type SheetName<M extends MenuId> = Extract<keyof ProcedureMap[M], string>;
  
  /**
   * MenuId, SheetName에서 정의한 검색조건
   */
  type ProcRequest<M extends MenuId, S extends SheetName<M>> = ProcedureMap[M][S]['request'];

  /**
   * MenuId, SheetName에서 정의한 response set의 key(ex. o_rc1 ...)
   */
  type ResponseKeys<M extends MenuId, S extends SheetName<M>> = Extract<keyof ProcedureMap[M][S]['response'], string>;

  /**
   * MenuId, SheetName에서 정의한 response data
   */
  type ResponseData<
    M extends MenuId,
    S extends SheetName<M>,
    RS extends ResponseKeys<M, S> = ResponseKeys<M, S>,
  > = ProcedureMap[M][S]['response'][RS];

  /**
   * MenuId, SheetName에서 정의한 api의 전체 response
   */
  type ProcResponse<M extends MenuId, S extends SheetName<M>> = {[RS in ResponseKeys<M, S>]: ResponseData<M, S, RS>[]};

  interface MutateRequest<M extends MenuId, S extends SheetName<M>, RS extends ResponseKeys<M, S>> {
    data: ResponseData<M, S, RS>[]
  }

  interface MutateResponse {
    DATARESULT: number;
    errMsg: any; // 프로시저 에러 메시지는 동적이므로 any 유지
  }
}
