/// Shared booking and payment-modelling types used across the checkout
/// screens (CheckoutPage and PaymentMethodPage).

/// Booking context passed from the Booking Form into the checkout screens,
/// so the summary, total, and payment channel stay in sync.
class CheckoutBooking {
  final String name;
  final String category;
  final String price;
  final String image;
  final DateTime startDate;
  final int days;
  final int rate;

  const CheckoutBooking({
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.startDate,
    required this.days,
    required this.rate,
  });
}

/// Booking context shared between the checkout screens.
class PaymentMethodModel {
  final CheckoutBooking booking;
  final String bookingRef;
  final int total;

  const PaymentMethodModel({
    required this.booking,
    required this.bookingRef,
    required this.total,
  });
}

/// Top-level currency formatter used across the checkout screens.
String rupiah(int value) =>
    'Rp${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}';


/// Booking context passed from the Payment Method screen into the final
/// confirmation screen (Step 3 of 3).
class ConfirmPaymentModel {
  final CheckoutBooking booking;
  final String bookingRef;
  final String bookingName;
  final String edition;
  final String qty;
  final String imageNetwork;
  final String vaNumber;
  final String accountName;
  final DateTime startDate;
  final int days;
  final int rate;

  const ConfirmPaymentModel({
    required this.booking,
    required this.bookingRef,
    required this.bookingName,
    required this.edition,
    required this.qty,
    required this.startDate,
    required this.days,
    required this.rate,
    required this.imageNetwork,
    required this.vaNumber,
    required this.accountName,
  });
}
