import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentOptionsWidget extends StatefulWidget {
  final double totalPrice;
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentOptionsWidget({
    Key? key,
    required this.totalPrice,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  }) : super(key: key);

  @override
  State<PaymentOptionsWidget> createState() => _PaymentOptionsWidgetState();
}

class _PaymentOptionsWidgetState extends State<PaymentOptionsWidget> {
  bool showInstallmentOptions = false;
  String selectedInstallmentPlan = 'full';

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'card',
      name: 'Credit/Debit Card',
      icon: Icons.credit_card,
      description: 'Secure payment with your card',
      processingFee: 2.5,
    ),
    PaymentMethod(
      id: 'paypal',
      name: 'PayPal',
      icon: Icons.payment,
      description: 'Pay with your PayPal account',
      processingFee: 3.0,
    ),
    PaymentMethod(
      id: 'apple_pay',
      name: 'Apple Pay',
      icon: Icons.apple,
      description: 'Quick and secure payment',
      processingFee: 0.0,
    ),
    PaymentMethod(
      id: 'google_pay',
      name: 'Google Pay',
      icon: Icons.help_outline,
      description: 'Pay with Google Pay',
      processingFee: 0.0,
    ),
    PaymentMethod(
      id: 'bank_transfer',
      name: 'Bank Transfer',
      icon: Icons.account_balance,
      description: 'Direct bank transfer',
      processingFee: 0.0,
    ),
  ];

  final List<InstallmentPlan> installmentPlans = [
    InstallmentPlan(
      id: 'full',
      name: 'Pay in Full',
      description: 'Pay the full amount now',
      installments: 1,
      interestRate: 0.0,
    ),
    InstallmentPlan(
      id: 'deposit_50',
      name: '50% Deposit',
      description: 'Pay 50% now, rest on arrival',
      installments: 2,
      interestRate: 0.0,
    ),
    InstallmentPlan(
      id: 'deposit_25',
      name: '25% Deposit',
      description: 'Pay 25% now, rest on arrival',
      installments: 2,
      interestRate: 2.5,
    ),
    InstallmentPlan(
      id: 'monthly_3',
      name: '3 Monthly Payments',
      description: 'Split into 3 monthly payments',
      installments: 3,
      interestRate: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Options',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),

            // Payment method selection
            _buildPaymentMethodSection(),

            SizedBox(height: 20),

            // Installment options (show for expensive bookings)
            if (widget.totalPrice > 100) _buildInstallmentSection(),

            SizedBox(height: 20),

            // Price breakdown
            _buildPriceBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        ...paymentMethods.map((method) => _buildPaymentMethodTile(method)),
      ],
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    bool isSelected = widget.selectedPaymentMethod == method.id;

    return GestureDetector(
      onTap: () {
        widget.onPaymentMethodChanged(method.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              method.icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    method.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (method.processingFee > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${method.processingFee}%',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Plan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showInstallmentOptions = !showInstallmentOptions;
                });
              },
              child: Text(
                showInstallmentOptions ? 'Hide Options' : 'Show Options',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        if (showInstallmentOptions) ...[
          SizedBox(height: 12),
          ...installmentPlans.map((plan) => _buildInstallmentPlanTile(plan)),
        ],
      ],
    );
  }

  Widget _buildInstallmentPlanTile(InstallmentPlan plan) {
    bool isSelected = selectedInstallmentPlan == plan.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedInstallmentPlan = plan.id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : null,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  Text(
                    plan.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (plan.interestRate > 0)
                    Text(
                      '${plan.interestRate}% interest',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            if (plan.installments > 1)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${plan.installments}x',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    PaymentMethod selectedMethod = paymentMethods.firstWhere(
      (method) => method.id == widget.selectedPaymentMethod,
      orElse: () => paymentMethods.first,
    );

    InstallmentPlan selectedPlan = installmentPlans.firstWhere(
      (plan) => plan.id == selectedInstallmentPlan,
      orElse: () => installmentPlans.first,
    );

    double processingFee =
        widget.totalPrice * (selectedMethod.processingFee / 100);
    double interestFee = widget.totalPrice * (selectedPlan.interestRate / 100);
    double finalTotal = widget.totalPrice + processingFee + interestFee;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          _buildPriceRow('Subtotal', widget.totalPrice),
          if (processingFee > 0)
            _buildPriceRow('Processing Fee (${selectedMethod.processingFee}%)',
                processingFee),
          if (interestFee > 0)
            _buildPriceRow(
                'Interest (${selectedPlan.interestRate}%)', interestFee),
          Divider(height: 20),
          _buildPriceRow('Total', finalTotal, isTotal: true),
          if (selectedPlan.installments > 1) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                selectedPlan.id == 'deposit_50' ||
                        selectedPlan.id == 'deposit_25'
                    ? 'Pay ${selectedPlan.name.split(' ')[0]} now: \$${(finalTotal * (selectedPlan.id == 'deposit_50' ? 0.5 : 0.25)).toStringAsFixed(2)}'
                    : 'Monthly payment: \$${(finalTotal / selectedPlan.installments).toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.inter(
              fontSize: isTotal ? 14 : 13,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final double processingFee;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.processingFee,
  });
}

class InstallmentPlan {
  final String id;
  final String name;
  final String description;
  final int installments;
  final double interestRate;

  InstallmentPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.installments,
    required this.interestRate,
  });
}
