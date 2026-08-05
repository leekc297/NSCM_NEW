// procedures.d.ts 에 아래 블록을 추가한다 (COM0004 블록 앞).
// 재취합: 2026-07-30 (라이브 procedures.d.ts 에서 재추출)

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
