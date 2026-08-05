package com.lgcns.nscm.admin.dynamicquery.model;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;

import lombok.extern.slf4j.Slf4j;


@Slf4j
public class OrderedCursorTypeHandler extends BaseTypeHandler<OrderedCursorResult> {

	/** IN 바인딩 미사용 (OUT 커서 전용). */
	@Override
	public void setNonNullParameter(PreparedStatement ps, int i, OrderedCursorResult parameter, JdbcType jdbcType)
			throws SQLException {
		throw new UnsupportedOperationException(
				"OrderedCursorTypeHandler 는 OUT 커서 전용입니다 (IN 바인딩 미지원).");
	}

	/** 컬럼 인덱스 기반 조회 미사용. */
	@Override
	public OrderedCursorResult getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
		throw new UnsupportedOperationException(
				"OrderedCursorTypeHandler 는 CALLABLE OUT 커서 전용입니다 (ResultSet 컬럼 접근 미지원).");
	}

	/** 컬럼명 기반 조회 미사용. */
	@Override
	public OrderedCursorResult getNullableResult(ResultSet rs, String columnName) throws SQLException {
		throw new UnsupportedOperationException(
				"OrderedCursorTypeHandler 는 CALLABLE OUT 커서 전용입니다 (ResultSet 컬럼 접근 미지원).");
	}

	@Override
	public OrderedCursorResult getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {

		OrderedCursorResult result = new OrderedCursorResult();

		Object cursor = cs.getObject(columnIndex);
		if (!(cursor instanceof ResultSet)) {
			// SP 가 커서를 안 열었거나 NULL — 빈 결과 반환 (컬럼/행 0).
			return result;
		}

		try (ResultSet rs = (ResultSet) cursor) {
			ResultSetMetaData meta = rs.getMetaData();
			int colCount = meta.getColumnCount();

			// 1) 컬럼 정의 — 값과 무관하게 ResultSetMetaData 로 전체 컬럼 확보 (NULL 컬럼 누락 방지).
			//    표시 라벨(getColumnLabel: AS alias 우선) 을 컬럼명으로, 원본 타입명을 타입으로.
			String[] colLabels = new String[colCount];
			for (int i = 1; i <= colCount; i++) {
				String label = meta.getColumnLabel(i);
				if (label == null || label.isEmpty()) {
					label = meta.getColumnName(i);
				}
				String typeName = meta.getColumnTypeName(i); // Oracle/JDBC 원본 타입명 (VARCHAR2/NUMBER/...)
				colLabels[i - 1] = label;
				result.getColumns().add(new OrderedCursorResult.ColumnMeta(label, typeName));
			}

			// 2) 데이터 행 — 컬럼 순서 보존 (OrderedRowMap = LinkedHashMap). 값이 모두 NULL 인
			//    컬럼도 key 를 명시적으로 넣어, 행 단독으로도 전체 컬럼이 드러나도록 한다.
			while (rs.next()) {
				OrderedRowMap row = new OrderedRowMap();
				for (int i = 1; i <= colCount; i++) {
					// OrderedRowMap.put 이 CLOB / oracle.sql.TIMESTAMP·DATE 변환 수행.
					row.put(colLabels[i - 1], rs.getObject(i));
				}
				result.getRows().add(row);
			}
		} catch (SQLException e) {
			log.error("OrderedCursorTypeHandler 커서 처리 오류: " + e.getMessage());
			throw e;
		}

		return result;
	}
}
