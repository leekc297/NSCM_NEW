-- [E20261026-BTNDIV] 검증: 표본 사용자 × Division 별 버튼 (사내 실측용 — 클라우드는 사용자 ID 를 환경에 맞게)
DECLARE
  C SYS_REFCURSOR; V_MNU VARCHAR2(50); V_SHT VARCHAR2(200); V_BTN VARCHAR2(150);
  PROCEDURE RUN(P_U VARCHAR2, P_M VARCHAR2, P_D VARCHAR2) IS BEGIN
    DBMS_OUTPUT.PUT_LINE('== ' || P_U || ' / ' || P_M || ' / ' || NVL(P_D,'(null)'));
    SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV(P_U, P_M, P_D, C);
    LOOP FETCH C INTO V_MNU, V_SHT, V_BTN; EXIT WHEN C%NOTFOUND; DBMS_OUTPUT.PUT_LINE('   ' || V_SHT || '.' || V_BTN); END LOOP; CLOSE C;
  END;
BEGIN
  RUN('dodae', 'SCP0007', NULL); RUN('dodae', 'SCP0007', '40'); RUN('dodae', 'SCP0007', '81');
  RUN('jaeuk.shin', 'SCP0007', '40'); RUN('jaeuk.shin', 'SCP0007', '82');
  RUN('jiwon.park', 'SCP0007', '81'); RUN('jiwon.park', 'SCP0007', '40');
  RUN('minyonglee1', 'SCP0007', 'ALL'); RUN('minyonglee1', 'SCP0007', '40'); RUN('minyonglee1', 'SCP0007', 'EE');
END;
/
