import 'dart:convert';

class Sales {
  final int? totalSales;
  final dynamic totalRevenue;
  final int? totalReceipts;
  final int? totalInvoices;
  final List<GraphDatum>? graphData;

  Sales({
    this.totalSales,
    this.totalRevenue,
    this.totalReceipts,
    this.totalInvoices,
    this.graphData,
  });

  factory Sales.fromRawJson(String str) => Sales.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
        totalSales: json["total_sales"],
        totalRevenue: json["total_revenue"],
        totalReceipts: json["total_receipts"],
        totalInvoices: json["total_invoices"],
        graphData: json["graph_data"] == null
            ? []
            : List<GraphDatum>.from(
                json["graph_data"]!.map((x) => GraphDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_sales": totalSales,
        "total_revenue": totalRevenue,
        "total_receipts": totalReceipts,
        "total_invoices": totalInvoices,
        "graph_data": graphData == null
            ? []
            : List<dynamic>.from(graphData!.map((x) => x.toJson())),
      };
}

class GraphDatum {
  final String? week;
  final String? salesKey;
  final dynamic salesValue;

  GraphDatum({
    this.week,
    this.salesKey,
    this.salesValue,
  });

  factory GraphDatum.fromRawJson(String str) =>
      GraphDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GraphDatum.fromJson(Map<String, dynamic> json) {
    // Identify if the sales key is "week" or "month"
    String? detectedSalesKey;
    dynamic detectedSalesValue;

    if (json.containsKey("week")) {
      detectedSalesKey = "week";
      detectedSalesValue = json["week"];
    } else if (json.containsKey("date")) {
      detectedSalesKey = "date";
      detectedSalesValue = json["date"];
    } else if (json.containsKey("month")) {
      detectedSalesKey = "month";
      detectedSalesValue = json["month"];
    }

    return GraphDatum(
      week: json[detectedSalesKey].toString(), // assuming week is always an int
      salesKey: detectedSalesKey,
      salesValue: double.tryParse(json["sales"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "week": week,
        if (salesKey != null)
          salesKey!: salesValue, // Only include the detected key
      };
}
