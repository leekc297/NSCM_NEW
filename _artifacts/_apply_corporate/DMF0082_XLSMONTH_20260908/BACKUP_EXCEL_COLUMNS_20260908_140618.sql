UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS SET HEADER_CONTENT = 'Div|Project Code|Sales Site|Model|Incoterms|FCST Type|Customs Handbook|Plant Site|Currency|Measure'
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice';
COMMIT;
