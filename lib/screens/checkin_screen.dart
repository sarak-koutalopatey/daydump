import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/pressable.dart';
import '../widgets/primary_button.dart';
import 'completion_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  int _step = 0;
  final _answers = ['', '', ''];
  final _controllers = List.generate(3, (_) => TextEditingController());
  final _focusNodes = List.generate(3, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _goNext() {
    _answers[_step] = _controllers[_step].text;
    if (_step < 2) {
      setState(() => _step++);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[_step].requestFocus();
      });
    } else {
      final state = context.read<AppState>();
      state.addEntry(
        accomplished: _answers[0],
        blockers: _answers[1],
        tomorrow: _answers[2],
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompletionScreen(streak: state.streak + (state.completedToday ? 0 : 1)),
        ),
      );
    }
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[_step].requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = kQuestions[_step];
    final isLast = _step == 2;

    return Scaffold(
      backgroundColor: context.cBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _CheckInHeader(step: _step, total: 3, onBack: _goBack),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.label,
                      style: GoogleFonts.figtree(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: context.cAccent,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.title,
                      style: GoogleFonts.figtree(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: context.cText,
                        letterSpacing: -0.4,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      q.hint,
                      style: GoogleFonts.figtree(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: context.cText2,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _AnswerInput(
                        controller: _controllers[_step],
                        focusNode: _focusNodes[_step],
                        questionTitle: q.title,
                        onChanged: (v) => _answers[_step] = v,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: isLast ? 'Finish' : 'Next',
                      trailing: isLast
                          ? const Icon(Icons.check_rounded)
                          : const Icon(Icons.arrow_forward_rounded),
                      onTap: _goNext,
                    ),
                    const SizedBox(height: 16),
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

class _CheckInHeader extends StatelessWidget {
  final int step;
  final int total;
  final VoidCallback onBack;

  const _CheckInHeader({
    required this.step,
    required this.total,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
      child: Row(
        children: [
          Pressable(
            onTap: onBack,
            useBackgroundShift: true,
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: Icon(
                  step == 0 ? Icons.close_rounded : Icons.arrow_back_rounded,
                  color: context.cText,
                  size: 22,
                ),
              ),
            ),
          ),
          Expanded(
            child: Semantics(
              label: 'Step ${step + 1} of $total',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(total, (i) {
                  final active = i == step;
                  final done = i < step;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: active ? 24 : 6,
                    decoration: BoxDecoration(
                      color: (active || done) ? context.cText : context.cBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

class _AnswerInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String questionTitle;
  final ValueChanged<String> onChanged;

  const _AnswerInput({
    required this.controller,
    required this.focusNode,
    required this.questionTitle,
    required this.onChanged,
  });

  @override
  State<_AnswerInput> createState() => _AnswerInputState();
}

class _AnswerInputState extends State<_AnswerInput> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() => _charCount = widget.controller.text.length);
      widget.onChanged(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cSurface2,
        border: Border.all(color: context.cBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: GoogleFonts.figtree(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: context.cText,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Type your answer…',
                hintStyle: GoogleFonts.figtree(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: context.cText3,
                  height: 1.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              cursorColor: context.cAccent,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$_charCount chars',
              style: GoogleFonts.figtree(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.cText3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
