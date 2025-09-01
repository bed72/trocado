enum IconsConstant {
  path(name: 'lib/modules/core/presentation/icons/svgs/'),
  user(name: 'user'),
  userFilled(name: 'user_filled'),
  wallet(name: 'wallet'),
  walletFilled(name: 'wallet_filled'),
  receipt(name: 'receipt'),
  receiptFilled(name: 'receipt_filled'),
  notification(name: 'notification'),
  notificationFilled(name: 'notification_filled');

  final String name;

  const IconsConstant({required this.name});
}
