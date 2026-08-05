// configs/types/procedures.d.ts — ProcedureMap 안에 아래 블록을 추가 (기존 내용 유지, 통째 교체 금지)
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
