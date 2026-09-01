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
          EDIT_YN: string;
          [key: string]: string | number;
        };
      };
    };
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
    }
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
  }
  /**
   * popup - team
   */
  COM0009: {
    team: {
      request: {
        teamId: string;
        teamName: string;
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
      };
      response: {
        o_rc: {
          USER_ID: string;
          USER_NM: string;
          USER_ENG_NM: string;
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
          DPJT_AUTH_TYPE: string; // ADMIN/WRITE/READ (REQUEST 상태 = 'NONE' 치환 — P-01 편집 축)
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
