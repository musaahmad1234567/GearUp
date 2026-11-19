import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'login_page.dart';

const _orange = Color(0xFFF28C28);
const _background = Color(0xFF1A1A1A);

void main() => runApp(const GearUpApp());

class GearUpApp extends StatelessWidget {
  const GearUpApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GEARUP',
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: _background,
          colorScheme: const ColorScheme.dark(primary: _orange),
        ),
        home: const GearUpSplash(),
      );
}

class GearUpSplash extends StatefulWidget {
  const GearUpSplash({super.key});

  @override
  State<GearUpSplash> createState() => _GearUpSplashState();
}

class _GearUpSplashState extends State<GearUpSplash> {
  int _progress = 78;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 160), (timer) {
      if (!mounted) return;
      if (_progress >= 100) {
        timer.cancel();
      } else {
        setState(() => _progress = math.min(100, _progress + 1 + math.Random().nextInt(4)));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.paddingOf(context);
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _TopoPainter())),
            Positioned(
              top: MediaQuery.sizeOf(context).height * .25,
              left: MediaQuery.sizeOf(context).width * .2,
              child: IgnorePointer(
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _orange.withOpacity(.08),
                    boxShadow: [BoxShadow(color: _orange.withOpacity(.11), blurRadius: 90, spreadRadius: 35)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    const _TopBar(),
                    const Spacer(),
                    const _Branding(),
                    const SizedBox(height: 24),
                    const _MountainContour(),
                    const Spacer(),
                    _ProgressPanel(progress: _progress),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: 340,
                      height: 48,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: _orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const OnboardingDiscoverPage(),
                          ),
                        ),
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: safe.bottom == 0 ? 12.0 : 4.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingDiscoverPage extends StatelessWidget {
  const OnboardingDiscoverPage({super.key});

  static const _ink = Color(0xFF1B1C1C);
  static const _muted = Color(0xFF777777);
  static const _surface = Color(0xFFFBF9F9);
  static const _gearImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC7jkUtP6vARUESG5pHWZ1cQjM-nMXr7FcRFAdX0h9mnjFpseVHXiKS5FiHfNPfRTpkAKmHjQJGTKy19oK0CuXjMjTpzSKtjshc6QNEBqWIKAx5oHn2Qf66acEcXxhJDDYxB0gX4PFLUmj3Fqxzbfmcf1fm_FFQVzL3mXiEb0vBK0_2tU8Zf81ns9FbODFMkjE5BiSS1tUfPX4TEk6-CuzwqIiIRikmtl1D3_KRcgc';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _surface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: _ink),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.landscape, color: _orange, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Onboarding Discover',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _goToLogin(context),
                      child: const Text('Skip', style: TextStyle(color: _muted)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF914D00),
                        child: Icon(Icons.person, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(0.0, constraints.maxHeight - 32),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    _gearImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) =>
                                        Container(
                                      color: const Color(0xFFE9E8E7),
                                      child: const Icon(
                                        Icons.backpack,
                                        size: 100,
                                        color: Color(0xFF887364),
                                      ),
                                    ),
                                  ),
                                  const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [Color(0x33000000), Colors.transparent],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: _ImageBadge(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 7,
                                            height: 7,
                                            decoration: const BoxDecoration(
                                              color: _orange,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 7),
                                          const Text('PRO SERIES 2025'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    right: 16,
                                    bottom: 16,
                                    child: _ImageBadge(
                                      dark: true,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.verified, size: 16, color: Color(0xFFFFB77D)),
                                          SizedBox(width: 6),
                                          Text('Alpine Grade'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            children: [
                              Expanded(child: _SpecTile(Icons.shield_outlined, 'Weatherproof', 'GORE-TEX Pro')),
                              SizedBox(width: 7),
                              Expanded(child: _SpecTile(Icons.backpack_outlined, 'Ultralight', 'Dyneema Ripstop')),
                              SizedBox(width: 7),
                              Expanded(child: _SpecTile(Icons.hiking, 'Vibram Grip', 'High Traction')),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'Discover Your Gear',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 25,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Find everything you need for your next hiking and camping adventure.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _muted, fontSize: 15, height: 1.55),
                          ),
                          const SizedBox(height: 22),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _PageDot(active: true),
                              SizedBox(width: 8),
                              _PageDot(),
                              SizedBox(width: 8),
                              _PageDot(),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const OnboardingReservePage(),
                                ),
                              ),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: const Text(
                                'Next',
                                style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .5),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _goToLogin(context),
                            child: const Text('Skip to Sign In', style: TextStyle(color: _muted)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class OnboardingReservePage extends StatelessWidget {
  const OnboardingReservePage({super.key});

  static const _ink = Color(0xFF1B1C1C);
  static const _muted = Color(0xFF5F5E5E);
  static const _surface = Color(0xFFFBF9F9);
  static const _kitImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA3okXOmSIvZLuyVlAQBTxt7JeZaFdPcoNy4F8qTTlxZawll7sGpWdRGwkuWiyNE35JYXXm0IE87P5HG3yrH0H4wuUIiiZFTA2uCIDJMx6CC97oMcxQcjhqdLVrw-_vP_4_56xiKAPCkmRGp-nMLdC6rhb_t8sD9wW3y2zJUBtzhZhd2s2opUMjNO6UxOB0yF2ELZYpWTCGYWn4MRTISQpRc7XeQdE6cmZVObrczzg';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _surface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: _ink),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.landscape, color: _orange, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Onboarding Reserve',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _goToLogin(context),
                      child: const Text('Skip', style: TextStyle(color: Color(0xFF554336))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF914D00),
                        child: Icon(Icons.person, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(0.0, constraints.maxHeight - 32),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Color(0x10000000), blurRadius: 22, offset: Offset(0, 4)),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(color: const Color(0xFFF5F3F3)),
                                    Image.network(
                                      _kitImage,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) => const Center(
                                        child: Icon(Icons.outdoor_grill, size: 100, color: Color(0xFF887364)),
                                      ),
                                    ),
                                    Positioned(
                                      left: 10,
                                      bottom: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.92),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _PulseDot(),
                                            SizedBox(width: 7),
                                            Text(
                                              'CAMP KIT • READY',
                                              style: TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .6),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Material(
                                        color: Colors.white.withOpacity(.92),
                                        shape: const CircleBorder(),
                                        child: IconButton(
                                          tooltip: 'Periksa detail perlengkapan',
                                          onPressed: () => showDialog<void>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Camp Kit'),
                                              content: const Text('Perlengkapan camping siap disewa dan sudah diperiksa.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Tutup'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          icon: const Icon(Icons.view_in_ar, size: 18, color: _ink),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4E2E1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bolt, size: 15, color: Color(0xFF474746)),
                                SizedBox(width: 5),
                                Text(
                                  'STEP 02 • SEAMLESS FLOW',
                                  style: TextStyle(color: Color(0xFF474746), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .7),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Rent Easily',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _ink, fontSize: 26, height: 1.25, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose your favorite outdoor equipment and rent it with just a few simple steps.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _muted, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 18),
                          const Row(
                            children: [
                              Expanded(child: _ValueTile(Icons.verified_outlined, 'Inspected')),
                              SizedBox(width: 8),
                              Expanded(child: _ValueTile(Icons.local_shipping_outlined, 'Direct Ship')),
                              SizedBox(width: 8),
                              Expanded(child: _ValueTile(Icons.assignment_return_outlined, 'Free Returns')),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).maybePop(),
                                child: const _PageDot(),
                              ),
                              const SizedBox(width: 8),
                              const _PageDot(active: true),
                              const SizedBox(width: 8),
                              const _PageDot(),
                            ],
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const OnboardingAdventurePage(),
                                ),
                              ),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: const Text('Next', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () => Navigator.of(context).maybePop(),
                                icon: const Icon(Icons.arrow_back, size: 18),
                                label: const Text('Previous'),
                                style: TextButton.styleFrom(foregroundColor: _muted),
                              ),
                              TextButton(
                                onPressed: () => _goToLogin(context),
                                child: const Text('Skip to Catalog', style: TextStyle(color: _muted)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ValueTile extends StatelessWidget {
  const _ValueTile(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: _orange, size: 20),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 10, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}

class OnboardingAdventurePage extends StatelessWidget {
  const OnboardingAdventurePage({super.key});

  static const _ink = Color(0xFF1B1C1C);
  static const _muted = Color(0xFF5F5E5E);
  static const _surface = Color(0xFFFBF9F9);
  static const _heroImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD3A8AG8zAQJXRbeeLkJeHAY08b0GUyLp4cl_XMpvLNoFZMACQe6klt0JGIdslk-LJs1dMn3O1GlVG2YAYFxFP-5BsNI-W9-QHhzD1dbp9jY__LGRvNbSKIz68Egb3aGV5hL5KzLKyF-ccIO-Liucl6m42L_gAADliwRO8pfMV6e7FWu2SNXS-pKUAnDrTOgURC_xVdzMOgpXTHXXLh9CdG1N7PpZf8z1FdQbnN6UM';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _surface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: _ink),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(Icons.landscape, color: _orange, size: 20),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Onboarding Adventure',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: _ink, fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showLoginMessage(context),
                      child: const Text('Skip', style: TextStyle(color: Color(0xFF554336))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF914D00),
                        child: Icon(Icons.person, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: math.max(0.0, constraints.maxHeight - 32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  _StepMark(),
                                  SizedBox(width: 5),
                                  _StepMark(),
                                  SizedBox(width: 5),
                                  _StepMark(active: true),
                                ],
                              ),
                              Text(
                                'STEP 3 OF 3',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    _heroImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) => Container(
                                      color: const Color(0xFFE3E2E2),
                                      child: const Icon(Icons.landscape, size: 100, color: Color(0xFF887364)),
                                    ),
                                  ),
                                  const DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [Color(0x99000000), Colors.transparent],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 14,
                                    left: 14,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.93),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.verified, color: _orange, size: 16),
                                          SizedBox(width: 6),
                                          Text('Alpine Certified', style: TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    left: 14,
                                    right: 14,
                                    bottom: 14,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.terrain, size: 18, color: Colors.white),
                                            SizedBox(width: 6),
                                            Text('3,450m Basecamp', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                        _TemperatureBadge(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDCC3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.explore, color: Color(0xFF6E3900), size: 15),
                                SizedBox(width: 6),
                                Text('Ready For Launch', style: TextStyle(color: Color(0xFF2F1500), fontSize: 10, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          const Text(
                            'Start Your Adventure',
                            style: TextStyle(color: _ink, fontSize: 27, height: 1.2, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Get ready for your next outdoor experience with the right equipment.',
                            style: TextStyle(color: _muted, fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 18),
                          const Row(
                            children: [
                              Expanded(child: _FeatureCard(Icons.shield_outlined, 'Damage Waiver', 'Full trail protection')),
                              SizedBox(width: 10),
                              Expanded(child: _FeatureCard(Icons.inventory_2_outlined, 'Trailhead Drop', 'Delivered to camp')),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _PageDot(),
                              SizedBox(width: 8),
                              _PageDot(),
                              SizedBox(width: 8),
                              _PageDot(active: true),
                            ],
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _orange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: () => _showLoginMessage(context),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                              onPressed: () => _showLoginMessage(context),
                              child: const Text.rich(
                                TextSpan(
                                  style: TextStyle(color: _ink, fontSize: 13),
                                  children: [
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(text: 'Log In', style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  static void _showLoginMessage(BuildContext context) {
    _goToLogin(context);
  }
}

void _goToLogin(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const LoginPage()),
  );
}

class _StepMark extends StatelessWidget {
  const _StepMark({this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
        width: active ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: active ? _orange : const Color(0xFFC8C6C5),
          borderRadius: BorderRadius.circular(8),
        ),
      );
}

class _TemperatureBadge extends StatelessWidget {
  const _TemperatureBadge();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xCC303031),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.device_thermostat, color: _orange, size: 15),
            SizedBox(width: 4),
            Text('-12°C Tested', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
          ],
        ),
      );
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 76),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: const Color(0xFFEFEDED).withOpacity(.8), borderRadius: BorderRadius.circular(9)),
              child: Icon(icon, color: _orange, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 10, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF5F5E5E), fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({required this.child, this.dark = false});
  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? const Color(0xDD303031) : const Color(0xEFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8)],
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: dark ? Colors.white : const Color(0xFF1B1C1C),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: .4,
          ),
          child: child,
        ),
      );
}

class _SpecTile extends StatelessWidget {
  const _SpecTile(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 19, color: const Color(0xFF554336)),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(title, style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 10, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(subtitle, style: const TextStyle(color: Color(0xFF777777), fontSize: 8)),
            ),
          ],
        ),
      );
}

class _PageDot extends StatelessWidget {
  const _PageDot({this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: active ? 32 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: active ? _orange : const Color(0xFFE3E2E2),
          borderRadius: BorderRadius.circular(8),
        ),
      );
}

class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF303031).withOpacity(.72), borderRadius: BorderRadius.circular(30)),
            child: const Row(children: [
              _PulseDot(),
              SizedBox(width: 7),
              Text('SYS.READY', style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
            ]),
          ),
          const Row(children: [
            Icon(Icons.signal_cellular_alt, size: 17, color: Color(0xFF888888)),
            SizedBox(width: 5),
            Text('ALPINE-NET', style: TextStyle(color: Color(0xFF888888), fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          ]),
        ],
      );
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(opacity: Tween(begin: .45, end: 1.0).animate(_controller), child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle)));
}

class _Branding extends StatelessWidget {
  const _Branding();
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: 112,
            height: 112,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF252525), borderRadius: BorderRadius.circular(26), boxShadow: [BoxShadow(color: _orange.withOpacity(.16), blurRadius: 26, spreadRadius: 2), const BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 9))]),
            child: const CustomPaint(painter: _LogoPainter()),
          ),
          const SizedBox(height: 23),
          const Text('GEARUP', textAlign: TextAlign.center, style: TextStyle(fontSize: 29, height: 1.2, letterSpacing: 7, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 7),
          const Text('RENT YOUR GEAR, EXPLORE MORE.', textAlign: TextAlign.center, style: TextStyle(color: _orange, fontSize: 12, letterSpacing: 1.15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          const Wrap(alignment: WrapAlignment.center, spacing: 9, children: [
            _MicroLabel('EXPEDITION'), _TinyDivider(), _MicroLabel('BACKCOUNTRY'), _TinyDivider(), _MicroLabel('ALPINE'),
          ]),
        ],
      );
}

class _MicroLabel extends StatelessWidget {
  const _MicroLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: Color(0xFF999999), fontSize: 9, letterSpacing: 1.4, fontWeight: FontWeight.w600));
}

class _TinyDivider extends StatelessWidget {
  const _TinyDivider();
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.only(top: 4), child: SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFF555555), shape: BoxShape.circle))));
}

class _MountainContour extends StatelessWidget {
  const _MountainContour();
  @override
  Widget build(BuildContext context) => const SizedBox(width: 280, height: 48, child: CustomPaint(painter: _ContourPainter()));
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({required this.progress});
  final int progress;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [const _PulseDot(), const SizedBox(width: 7), Text(progress == 100 ? 'EXPEDITION READY' : 'PREPARING EXPEDITION...', style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w600))]),
            Text(progress == 100 ? 'READY' : '$progress%', style: TextStyle(color: progress == 100 ? Colors.white : _orange, fontSize: 11, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 4,
              color: const Color(0xFF282828),
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                widthFactor: progress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: _orange,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: _orange.withOpacity(.55), blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _Meta('V2.4 // PROD'),
            Row(children: [Icon(Icons.lock_outline, size: 12, color: Color(0xFF777777)), SizedBox(width: 4), _Meta('ENCRYPTED')]),
            _Meta('SEATTLE, WA'),
          ]),
        ]),
      );
}

class _Meta extends StatelessWidget {
  const _Meta(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: Color(0xFF777777), fontSize: 9, letterSpacing: .8, fontFamily: 'monospace'));
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 3.2..strokeJoin = StrokeJoin.round..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(size.width * .08, size.height * .83)..lineTo(size.width * .42, size.height * .25)..lineTo(size.width * .58, size.height * .51)..lineTo(size.width * .71, size.height * .34)..lineTo(size.width * .94, size.height * .83)..close();
    p.color = Colors.white;
    canvas.drawPath(path, p);
    final inner = Path()..moveTo(size.width * .30, size.height * .83)..lineTo(size.width * .48, size.height * .55)..lineTo(size.width * .62, size.height * .75)..lineTo(size.width * .76, size.height * .56)..lineTo(size.width * .91, size.height * .83);
    p.color = _orange; p.strokeWidth = 3.5; canvas.drawPath(inner, p);
    canvas.drawCircle(Offset(size.width * .42, size.height * .25), 3, Paint()..color = _orange);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ContourPainter extends CustomPainter {
  const _ContourPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..moveTo(0, 45)..lineTo(50, 45)..lineTo(85, 23)..lineTo(110, 37)..lineTo(140, 9)..lineTo(175, 33)..lineTo(200, 17)..lineTo(235, 45)..lineTo(280, 45);
    canvas.drawPath(path, Paint()..color = const Color(0xFF383838)..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
    final orange = Path()..moveTo(35, 45)..lineTo(85, 23)..lineTo(110, 37)..lineTo(140, 9)..lineTo(175, 33)..lineTo(200, 17)..lineTo(235, 45);
    canvas.drawPath(orange, Paint()..color = _orange..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
    canvas.drawCircle(const Offset(140, 9), 3, Paint()..color = _orange);
    canvas.drawLine(const Offset(0, 46), Offset(size.width, 46), Paint()..color = const Color(0xFF2C2C2C)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopoPainter extends CustomPainter {
  const _TopoPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(.10)..style = PaintingStyle.stroke..strokeWidth = .7;
    final paths = [
      Path()..moveTo(-40, size.height*.22)..cubicTo(size.width*.18, size.height*.17, size.width*.47, size.height*.29, size.width+40, size.height*.20),
      Path()..moveTo(-40, size.height*.31)..cubicTo(size.width*.25, size.height*.25, size.width*.55, size.height*.39, size.width+40, size.height*.30),
      Path()..moveTo(-40, size.height*.42)..cubicTo(size.width*.24, size.height*.36, size.width*.64, size.height*.49, size.width+40, size.height*.40),
      Path()..moveTo(-40, size.height*.62)..cubicTo(size.width*.18, size.height*.55, size.width*.58, size.height*.69, size.width+40, size.height*.60),
      Path()..moveTo(-40, size.height*.73)..cubicTo(size.width*.26, size.height*.67, size.width*.69, size.height*.77, size.width+40, size.height*.69),
    ];
    for (final path in paths) canvas.drawPath(path, p);
    for (final mark in [Offset(size.width*.15, size.height*.12), Offset(size.width*.85, size.height*.18), Offset(size.width*.77, size.height*.78), Offset(size.width*.20, size.height*.88)]) {
      canvas.drawCircle(mark, 1.5, Paint()..color = _orange.withOpacity(.55));
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
