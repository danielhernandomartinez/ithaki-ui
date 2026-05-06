import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/api_diagnostics_provider.dart';

class ApiDiagnosticsScreen extends ConsumerStatefulWidget {
  const ApiDiagnosticsScreen({super.key});

  @override
  ConsumerState<ApiDiagnosticsScreen> createState() =>
      _ApiDiagnosticsScreenState();
}

class _ApiDiagnosticsScreenState extends ConsumerState<ApiDiagnosticsScreen> {
  List<ApiDiagnosticResult> _results = [];
  bool _running = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0FA),
      appBar: AppBar(
        title: const Text('API Diagnostics'),
        backgroundColor: const Color(0xFF6B4EFF),
        foregroundColor: Colors.white,
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              tooltip: 'Copy error report',
              icon: const Icon(Icons.copy_outlined),
              onPressed: () => _copyErrorReport(context, _results),
            ),
        ],
      ),
      body: Column(
        children: [
          _SummaryBar(results: _results, running: _running),
          Expanded(
            child: _results.isEmpty && !_running
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _running &&
                            _results.length <
                                ApiDiagnosticsRepository.endpoints.length
                        ? _results.length + 1
                        : _results.length,
                    itemBuilder: (context, i) {
                      if (i == _results.length) {
                        return const _LoadingTile();
                      }
                      return _ResultTile(result: _results[i]);
                    },
                  ),
          ),
          _RunButton(running: _running, onRun: _runAll),
        ],
      ),
    );
  }

  Future<void> _runAll() async {
    if (_running) return;
    setState(() {
      _results = [];
      _running = true;
    });

    final repo = ref.read(apiDiagnosticsRepositoryProvider);

    for (final endpoint in ApiDiagnosticsRepository.endpoints) {
      final result = await repo.runEndpoint(endpoint);
      if (!mounted) return;
      setState(() => _results = [..._results, result]);
    }

    if (mounted) setState(() => _running = false);
  }

  void _copyErrorReport(
      BuildContext context, List<ApiDiagnosticResult> results) {
    final report = _buildErrorReport(results);
    Clipboard.setData(ClipboardData(text: report));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error report copied to clipboard')),
    );
  }

  static String _buildErrorReport(List<ApiDiagnosticResult> results) {
    final errors = results.where((r) => r.hasError).toList();
    if (errors.isEmpty) return 'All endpoints OK';

    final buf = StringBuffer();
    buf.writeln('# API Diagnostics Error Report');
    buf.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buf.writeln('Errors: ${errors.length} / ${results.length}');
    buf.writeln();

    for (final r in errors) {
      buf.writeln('## ${r.endpoint.title}');
      buf.writeln('Path: ${r.endpoint.displayPath}');
      buf.writeln('Status: ${r.statusLabel}');
      buf.writeln('Duration: ${r.duration.inMilliseconds}ms');
      if (r.error != null) buf.writeln('Error: ${r.error}');
      if (r.responsePreview.isNotEmpty) {
        buf.writeln('Response: ${r.responsePreview}');
      }
      buf.writeln();
    }
    return buf.toString();
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.results, required this.running});

  final List<ApiDiagnosticResult> results;
  final bool running;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) return const SizedBox.shrink();

    final total = ApiDiagnosticsRepository.endpoints.length;
    final done = results.length;
    final errors = results.where((r) => r.hasError).length;
    final ok = done - errors;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _Chip(label: '$ok OK', color: const Color(0xFF22C55E)),
          const SizedBox(width: 8),
          _Chip(label: '$errors Errors', color: const Color(0xFFEF4444)),
          const Spacer(),
          Text(
            running ? '$done / $total' : 'Done $done / $total',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _ResultTile extends StatefulWidget {
  const _ResultTile({required this.result});

  final ApiDiagnosticResult result;

  @override
  State<_ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends State<_ResultTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final isError = r.hasError;
    final statusColor =
        isError ? const Color(0xFFEF4444) : const Color(0xFF22C55E);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: r.responsePreview.isNotEmpty || r.error != null
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      r.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.endpoint.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          r.endpoint.displayPath,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black45),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${r.duration.inMilliseconds}ms',
                    style: const TextStyle(fontSize: 11, color: Colors.black38),
                  ),
                  if (r.responsePreview.isNotEmpty || r.error != null) ...[
                    const SizedBox(width: 4),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: Colors.black38,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_expanded && (r.responsePreview.isNotEmpty || r.error != null))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  r.error ?? _prettyJson(r.responsePreview),
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _prettyJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Running...', style: TextStyle(color: Colors.black45)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_tethering_outlined, size: 48, color: Colors.black26),
          const SizedBox(height: 12),
          const Text(
            'Press "Run all checks" to test all endpoints.',
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }
}

class _RunButton extends StatelessWidget {
  const _RunButton({required this.running, required this.onRun});

  final bool running;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: running ? null : onRun,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4EFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: running
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Run all checks',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}
