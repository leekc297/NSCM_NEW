package com.lgcns.nscm.framework.utils;

import java.io.InputStream;
import java.util.*;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

public class ExcelUtils {

    /**
     * MultipartFile(Excel)을 List<Map> 구조(JSON 대응)로 변환하는 모듈화 함수
     */
    public static List<Map<String, Object>> convertExcelToJson(MultipartFile file) throws Exception {
        List<Map<String, Object>> resultList = new ArrayList<>();

        try (InputStream is = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(is)) {

            Sheet sheet = workbook.getSheetAt(0); // 첫 번째 시트 사용
            Row headerRow = sheet.getRow(0);     // 첫 번째 행을 헤더(Key)로 간주
            int columnCount = headerRow.getPhysicalNumberOfCells();

            // 두 번째 행(index 1)부터 데이터 읽기
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row currentRow = sheet.getRow(i);
                if (currentRow == null) continue;

                Map<String, Object> rowData = new HashMap<>();
                for (int j = 0; j < columnCount; j++) {
                    String columnHeader = headerRow.getCell(j).getStringCellValue();
                    Cell cell = currentRow.getCell(j);
                    rowData.put(columnHeader, getCellValue(cell));
                }
                resultList.add(rowData);
            }
        }
        return resultList;
    }

    // 셀 타입별 데이터 추출 헬퍼 함수
    private static Object getCellValue(Cell cell) {
        if (cell == null) return "";
        return switch (cell.getCellType()) {
            case STRING -> cell.getStringCellValue();
            case NUMERIC -> DateUtil.isCellDateFormatted(cell) ? cell.getDateCellValue() : cell.getNumericCellValue();
            case BOOLEAN -> cell.getBooleanCellValue();
            case FORMULA -> cell.getCellFormula();
            default -> "";
        };
    }
}
