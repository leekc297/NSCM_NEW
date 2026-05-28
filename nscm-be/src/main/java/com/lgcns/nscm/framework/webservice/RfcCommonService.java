package com.lgcns.nscm.framework.webservice;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoDestinationManager;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoTable;

@Service
public class RfcCommonService {

    public Map<String, Object> executeDynamicRfc(String rfcName, Map<String, Object> params) throws JCoException {
    	params.get("des");
        JCoDestination destination = JCoDestinationManager.getDestination("MY_SAP_DEST");
        JCoFunction function = destination.getRepository().getFunction(rfcName);

        if (function == null) throw new RuntimeException(rfcName + "is Not found function.");

        // 1. Dynamic Import (Map -> RFC Input)
        JCoParameterList importParams = function.getImportParameterList();
        if (importParams != null && params != null) {
            params.forEach((key, value) -> {
                if (importParams.getMetaData().indexOf(key) >= 0) {
                    importParams.setValue(key, value);
                }
            });
        }

        // 2. RFC 실행
        function.execute(destination);

        // 3. Dynamic Export & Table (RFC Output -> Map)
        Map<String, Object> resultMap = new HashMap<>();

        // Export 파라미터 추출 Map
        JCoParameterList exportParams = function.getExportParameterList();
        if (exportParams != null) {
            for (int i = 0; i < exportParams.getMetaData().getFieldCount(); i++) {
                String fieldName = exportParams.getMetaData().getName(i);
                resultMap.put(fieldName, exportParams.getValue(fieldName));
            }
        }

        // Table 파라미터 추출 (결과 리스트)
        JCoParameterList tableParams = function.getTableParameterList();
        if (tableParams != null) {
            for (int i = 0; i < tableParams.getMetaData().getFieldCount(); i++) {
                String tableName = tableParams.getMetaData().getName(i);
                JCoTable table = tableParams.getTable(tableName);
                resultMap.put(tableName, cvtJCoTableToList(table));
            }
        }

        return resultMap;
    }

    // JCoTable을 List<Map>으로 변환하는 유틸리티
    private List<Map<String, Object>> cvtJCoTableToList(JCoTable table) {
        List<Map<String, Object>> list = new ArrayList<>();
        for (int i = 0; i < table.getNumRows(); i++) {
            table.setRow(i);
            Map<String, Object> row = new HashMap<>();
            for (int j = 0; j < table.getMetaData().getFieldCount(); j++) {
                String colName = table.getMetaData().getName(j);
                row.put(colName, table.getValue(colName));
            }
            list.add(row);
        }
        return list;
    }
}
