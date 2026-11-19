/// Saved payment instruments page ("Payment Methods") for the GEARUP app.
///
/// Mirrors the HTML reference: a security/deposit guarantee banner, the four
/// saved instruments (Mandiri VA default, BCA VA, GoPay, QRIS) with
/// set-default / edit / delete / unlink actions, an "Add Payment Method"
/// bottom sheet with a type selector and dynamic form, and a toast.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Design tokens (mirrors the HTML theme)
// ---------------------------------------------------------------------------
const _surface = Color(0xFFFBF9F9);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF554336);
const _secondary = Color(0xFF5F5E5E);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _inverseSurface = Color(0xFF303031);
const _inverseOnSurface = Color(0xFFF2F0F0);
const _error = Color(0xFFBA1A1A);
const _surfaceVariant = Color(0xFFE3E2E2);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _surfaceContainer = Color(0xFFEFEDED);
const _surfaceContainerHigh = Color(0xFFE9E8E7);
const _surfaceContainerHighest = Color(0xFFE3E2E2);

/// A saved payment instrument.
class _Instrument {
  final String name;
  final String detail;
  final IconData icon;
  final String badge;
  final _BadgeStyle badgeStyle;
  final List<_InstrumentAction> actions;

  const _Instrument({
    required this.name,
    required this.detail,
    required this.icon,
    required this.badge,
    required this.badgeStyle,
    required this.actions,
  });
}

enum _BadgeStyle { defaultTag, linked, none }

enum _InstrumentAction { setDefault, edit, delete, unlink }

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  String? _defaultMethod = 'Mandiri Virtual Account';
  bool _addOpen = false;

  static const _instruments = <_Instrument>[
    _Instrument(
      name: 'Mandiri Virtual Account',
      detail: '•••• •••• •••• 0014',
      icon: Icons.account_balance,
      badge: 'DEFAULT',
      badgeStyle: _BadgeStyle.defaultTag,
      actions: [_InstrumentAction.edit, _InstrumentAction.delete],
    ),
    _Instrument(
      name: 'BCA Virtual Account',
      detail: '•••• •••• •••• 8492',
      icon: Icons.account_balance_wallet,
      badge: '',
      badgeStyle: _BadgeStyle.none,
      actions: [
        _InstrumentAction.setDefault,
        _InstrumentAction.edit,
        _InstrumentAction.delete,
      ],
    ),
    _Instrument(
      name: 'GoPay E-Wallet',
      detail: '+62 812 •••• 7890',
      icon: Icons.contactless,
      badge: 'LINKED',
      badgeStyle: _BadgeStyle.linked,
      actions: [_InstrumentAction.setDefault, _InstrumentAction.unlink],
    ),
    _Instrument(
      name: 'QRIS Stored Credentials',
      detail: 'Instant trail checkout enabled',
      icon: Icons.qr_code_scanner,
      badge: '',
      badgeStyle: _BadgeStyle.none,
      actions: [_InstrumentAction.setDefault, _InstrumentAction.delete],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _onSurface,
          ),
        ),
        actions: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: _primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              const _GuaranteeBanner(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'SAVED INSTRUMENTS (4)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: _onSurface,
                    ),
                  ),
                  Text(
                    'Instant Clearance',
                    style: TextStyle(fontSize: 11, color: _secondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final ins in _instruments)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InstrumentCard(
                    instrument: ins,
                    isDefault: _defaultMethod == ins.name,
                    onAction: (a) => _onAction(ins, a),
                  ),
                ),
              const SizedBox(height: 8),
              _AddPaymentButton(onTap: () => setState(() => _addOpen = true)),
              const SizedBox(height: 16),
              const _TrailPolicyNote(),
            ],
          ),
          if (_addOpen) _buildAddSheet(),
        ],
      ),
    );
  }

  void _onAction(_Instrument ins, _InstrumentAction action) {
    switch (action) {
      case _InstrumentAction.setDefault:
        setState(() => _defaultMethod = ins.name);
        _toast('${ins.name} set as primary.');
        break;
      case _InstrumentAction.edit:
        _toast('Editing ${ins.name}');
        break;
      case _InstrumentAction.delete:
        _toast('Removed ${ins.name}');
        break;
      case _InstrumentAction.unlink:
        _toast('Unlinked ${ins.name}');
        break;
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 2500),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _inverseSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              const Icon(Icons.check_circle,
                  size: 18, color: _primaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                      fontSize: 14, color: _inverseOnSurface),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ------------------------------------------------------------- add sheet --
  Widget _buildAddSheet() {
    return GestureDetector(
      onTap: () => setState(() => _addOpen = false),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: const _AddPaymentSheet(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Guarantee banner
// ---------------------------------------------------------------------------
class _GuaranteeBanner extends StatelessWidget {
  const _GuaranteeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: _surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user,
                size: 18, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'GEAR PROTECTION GUARANTEE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: _primary,
                      ),
                    ),
                    SizedBox(width: 6),
                    _Dot(),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  '256-Bit SSL Encrypted • Zero deposit holds are safely linked '
                  'to your validated payment source for swift trail pickup.',
                  style: TextStyle(fontSize: 12, color: _secondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: _primaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Instrument card
// ---------------------------------------------------------------------------
class _InstrumentCard extends StatelessWidget {
  final _Instrument instrument;
  final bool isDefault;
  final ValueChanged<_InstrumentAction> onAction;

  const _InstrumentCard({
    required this.instrument,
    required this.isDefault,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(instrument.icon,
                          size: 24, color: _onSurface),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  instrument.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _onSurface,
                                  ),
                                ),
                              ),
                              if (instrument.badgeStyle !=
                                  _BadgeStyle.none) ...[
                                const SizedBox(width: 8),
                                _Badge(
                                  label: instrument.badge,
                                  style: instrument.badgeStyle,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            instrument.detail,
                            style: const TextStyle(
                              fontSize: 14,
                              color: _secondary,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (instrument.actions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in instrument.actions)
                        _ActionButton(
                          action: a,
                          label: switch (a) {
                            _InstrumentAction.setDefault => 'Set as Default',
                            _InstrumentAction.edit => 'Edit',
                            _InstrumentAction.delete => 'Delete',
                            _InstrumentAction.unlink => 'Unlink',
                          },
                          onTap: () => onAction(a),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isDefault
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 20,
            color: isDefault ? _primaryContainer : _surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final _BadgeStyle style;

  const _Badge({required this.label, required this.style});

  @override
  Widget build(BuildContext context) {
    final isDefault = style == _BadgeStyle.defaultTag;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isDefault ? _primaryContainer : _surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDefault ? Colors.white : _onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final _InstrumentAction action;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.action,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDestructive = action == _InstrumentAction.delete ||
        action == _InstrumentAction.unlink;
    final isPrimary = action == _InstrumentAction.setDefault;

    if (isPrimary) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: _surfaceContainer,
          foregroundColor: _onSurface,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      );
    }

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: isDestructive ? _error : _secondary,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// Add button + policy note
// ---------------------------------------------------------------------------
class _AddPaymentButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPaymentButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _inverseSurface,
          foregroundColor: _inverseOnSurface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        icon: const Icon(Icons.add_circle, size: 20, color: _primaryContainer),
        label: const Text(
          'Add Payment Method',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TrailPolicyNote extends StatelessWidget {
  const _TrailPolicyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, size: 20, color: _secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Zero charge occurs until your gear leaves the regional GEARUP '
              'basecamp outpost.',
              style: TextStyle(
                fontSize: 12,
                color: _secondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Add payment bottom sheet
// ---------------------------------------------------------------------------
class _AddPaymentSheet extends StatefulWidget {
  const _AddPaymentSheet();

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

enum _MethodType { va, ewallet, card }

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  _MethodType _type = _MethodType.va;
  bool _makeDefault = false;

  static const _providers = [
    'Bank Mandiri (Instant VA)',
    'Bank Central Asia (BCA)',
    'Bank Negara Indonesia (BNI)',
    'Bank Rakyat Indonesia (BRI)',
    'CIMB Niaga',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _surfaceVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Add Payment Method',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _onSurface,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Verified credentials for equipment leases',
                          style:
                              TextStyle(fontSize: 12, color: _secondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20, color: _onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'SELECT TYPE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: _secondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _typeButton(
                    _MethodType.va,
                    Icons.account_balance,
                    'Bank VA',
                  ),
                  const SizedBox(width: 4),
                  _typeButton(
                    _MethodType.ewallet,
                    Icons.smartphone,
                    'E-Wallet',
                  ),
                  const SizedBox(width: 4),
                  _typeButton(
                    _MethodType.card,
                    Icons.credit_card,
                    'Card',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SheetField(
                label: _providerLabel,
                child: DropdownButtonFormField<String>(
                  value: _providers.first,
                  items: [
                    for (final p in _providers)
                      DropdownMenuItem(value: p, child: Text(p)),
                  ],
                  onChanged: (_) {},
                  decoration: _inputDecoration(suffix: Icons.expand_more),
                ),
              ),
              const SizedBox(height: 12),
              _SheetField(
                label: _accountLabel,
                child: TextField(
                  decoration: _inputDecoration(
                    hint: _accountHint,
                    suffix: Icons.pin,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _SheetField(
                label: 'Account Holder Name',
                child: TextField(
                  decoration: _inputDecoration(hint: 'Full name on account'),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () =>
                    setState(() => _makeDefault = !_makeDefault),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _makeDefault,
                        onChanged: (v) =>
                            setState(() => _makeDefault = v ?? false),
                        activeColor: _primaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Set as primary source for instant trail bookings',
                        style: TextStyle(fontSize: 12, color: _onSurface),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: _inverseSurface,
                        content: Text(
                          'New payment instrument verified & secured.',
                          style:
                              TextStyle(color: _inverseOnSurface),
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _primaryContainer,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.verified, size: 20),
                  label: const Text(
                    'Link Payment Method',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _providerLabel => switch (_type) {
        _MethodType.va => 'Bank or Institution',
        _MethodType.ewallet => 'E-Wallet Provider (GoPay, OVO, etc.)',
        _MethodType.card => 'Card Issuer',
      };

  String get _accountLabel => switch (_type) {
        _MethodType.va => 'Virtual Account Number',
        _MethodType.ewallet => 'Registered Mobile Number',
        _MethodType.card => 'Card Number (16 Digits)',
      };

  String get _accountHint => switch (_type) {
        _MethodType.va => 'e.g. 88012 9048 2901',
        _MethodType.ewallet => 'e.g. 0812 3456 7890',
        _MethodType.card => 'e.g. 4111 1111 1111 1111',
      };

  InputDecoration _inputDecoration({String? hint, IconData? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _surfaceContainerHighest),
        suffixIcon: suffix != null
            ? Icon(suffix, size: 20, color: _secondary)
            : null,
        filled: true,
        fillColor: _surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryContainer, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _typeButton(_MethodType type, IconData icon, String label) {
    final selected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? _surfaceContainerLowest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? _onSurface : _secondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w500,
                  color: selected ? _onSurface : _secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label;
  final Widget child;

  const _SheetField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: _secondary,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
