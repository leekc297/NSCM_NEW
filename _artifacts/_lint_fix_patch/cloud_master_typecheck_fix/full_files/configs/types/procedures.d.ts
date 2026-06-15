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
   * ForecastPrice — DMF0082
   *
   * SHEETS:
   * - `fcstNPrice_40` (메인 조회/저장 — Division 40 고정. canonical PROC `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`)
   * - `spreadTitle`   (동적 컬럼 SP `DMF0082_GET_SPREAD_TITLE` — Two-pass 2차)
   *
   * PROC IN 이름은 S1.db.md §4 PKG-prefixed canonical 따름.
   */
  DMF0082: {
    fcstNPrice_40: {
      request: {
        divisionId: string;
        deptId: string;
        endCustomer: string;
        bizType: string;
        fromYyyymmdd: string;
        toYyyymmdd: string;
        salesSite: string;
        itemId: string;
        versionType: string;
        qtyYn: string;
        sesUserId: string;
        userGroup: string;
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
          DEPT_NM: string;
          LANG_CD: string;
          TMZ_CD: string;
        };
      };
    };
  }
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
