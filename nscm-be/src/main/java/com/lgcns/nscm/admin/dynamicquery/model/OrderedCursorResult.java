package com.lgcns.nscm.admin.dynamicquery.model;

import java.util.ArrayList;
import java.util.List;

public class OrderedCursorResult {

	private final List<ColumnMeta> columns = new ArrayList<ColumnMeta>();

	private final List<OrderedRowMap> rows = new ArrayList<OrderedRowMap>();

	public List<ColumnMeta> getColumns() {
		return columns;
	}

	public List<OrderedRowMap> getRows() {
		return rows;
	}

	public static class ColumnMeta {
		private final String name;
		private final String type;

		public ColumnMeta(String name, String type) {
			this.name = name;
			this.type = type;
		}

		public String getName() {
			return name;
		}

		public String getType() {
			return type;
		}
	}
}
