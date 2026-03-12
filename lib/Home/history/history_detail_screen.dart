import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map data;

  const HistoryDetailScreen({super.key, required this.data});

  Widget field(String title, dynamic value) {
    if (value == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String calculator = data["calculator_name"].toString().toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text("Calculation Detail")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["calculator_name"],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
              const SizedBox(height: 20),
        
              /// EMI
              if (calculator.contains("emi")) ...[
                field("Loan Amount", "₹${data["loan_amount"]}"),
                field("Interest Rate", "${data["interest_rate"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Monthly EMI", "₹${data["monthly_emi"]}"),
                field("Principal Amount", "₹${data["principal_amount"]}"),
                field("Total Interest", "₹${data["total_interest"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              ///TDS
              if (calculator.contains("tds")) ...[
                field("Amount", "₹${data["amount"]}"),
                field("TDS Rate", "${data["tds_rate"]}%"),
                field("TDS Amount", "₹${data["tds_amount"]}"),
                field("Net Amount", "₹${data["net_amount"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
              ///GST
              if (calculator.contains("gst")) ...[
                field("Amount", "₹${data["amount"]}"),
                field("GST Rate", "${data["gst_rate"]}%"),
                field("Calculation Type", data["calculation_type"]),
                field("GST Type", data["gst_type"]),
                field("Net Amount", "₹${data["net_amount"]}"),
                field("GST Amount", "₹${data["gst_amount"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// FD
              if (calculator.contains("fd")) ...[
                field("Invested Amount", "₹${data["invested_amount"]}"),
                field("Interest Rate", "${data["annual_rate"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Estimated Return", "₹${data["estimated_return"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// RD
              if (calculator.contains("rd")) ...[
                field("Monthly Investment", "₹${data["monthly_investment"]}"),
                field("Interest Rate", "${data["interest_rate"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Invested Amount", "₹${data["invested_amount"]}"),
                field("Estimated Return", "₹${data["estimated_return"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// PPF
              if (calculator.contains("ppf")) ...[
                field("Total Investment", "₹${data["total_investment"]}"),
                field("Return Rate", "${data["return_rate"]}%"),
                field("Time Period", "${data["time_in_years"]} Years"),
                field("Frequency", data["frequency"]),
                field("Total Invested", "₹${data["total_invested"]}"),
                field("Estimated Return", "₹${data["estimated_return"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              ///SWP
              if (calculator.contains("swp")) ...[
                field("Invested Amount", "₹${data["invested_amount"]}"),
                field("Withdrawal Amount", "₹${data["withdrawal_amount"]}"),
                field("Return Rate", "${data["return_rate"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Total Withdrawn", "₹${data["total_withdrawn"]}"),
                field("Balance Amount", "₹${data["balance_amount"]}"),
              ],
        
        
              ///SIP
              if (calculator.contains("sip")) ...[
                field("Monthly Investment", "₹${data["monthly_investment"]}"),
                field("Return Rate", "${data["return_rate"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Total Invested", "₹${data["total_invested"]}"),
                field("Estimated Return", "₹${data["estimated_return"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// Maturity
              if (calculator.contains("maturity")) ...[
                field("Total Investment", "₹${data["total_investment"]}"),
                field("Interest Rate", "${data["rate_of_interest"]}%"),
                field("Time Period", "${data["time_period_years"]} Years"),
                field("Total Invested", "₹${data["total_invested"]}"),
                field("Estimated Return", "₹${data["estimated_return"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// XIRR
              if (calculator.contains("xirr")) ...[
                field("Start Date", data["start_date"]),
                field("End Date", data["end_date"]),
                field("Maturity Date", data["maturity_date"]),
                field("Investment", "₹${data["investment"]}"),
                field("Maturity Amount", "₹${data["maturity_amount"]}"),
                field("Frequency", data["frequency"]),
                field("XIRR Result", "${data["xirr_result"]}%"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              /// IRR
              if (calculator.contains("irr")) ...[
                field("Initial Investment", "₹${data["initial_investment"]}"),
                field("Cash Flows", data["cash_flows"].toString()),
                field("IRR Result", "${data["irr_result"]}%"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
        
              
        
        
        
              /// ELECTRICITY
              if (calculator.contains("electricity")) ...[
                field("Power Consumption", "${data["power_consumption"]} ${data["power_unit"]}"),
                field("Energy Price", "₹${data["energy_price"]}"),
                field("Usage Time", "${data["usage_time"]} ${data["time_unit"]}"),
                field("Power Consumed", data["power_consumed"]),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
              /// PAINT
              if (calculator.contains("paint")) ...[
                field("Total Area", "${data["total_area"]} ${data["area_unit"]}"),
                field("Paint Efficiency", data["paint_efficiency"]),
                field("Cost Per Liter", "₹${data["cost_per_liter"]}"),
                field("Paint Needed", data["paint_needed"]),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
              /// LAND UNIT
              if (calculator.contains("land")) ...[
                field("Land Area", "${data["land_area"]} ${data["unit"]}"),
                field("Price Per Unit", "₹${data["price_per_unit"]}"),
                field("Total Amount", "₹${data["total_amount"]}"),
              ],
        
              const SizedBox(height: 20),
        
              field("Date", data["created_at"].toString().substring(0, 10)),
            ],
          ),
        ),
      ),
    );
  }
}
