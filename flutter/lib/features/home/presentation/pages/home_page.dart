import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';
import '../../../../core/widgets/shad_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(syncControllerProvider.notifier).refreshStatus(),
    );
  }

  Future<void> _handleSync() async {
    await ref.read(syncControllerProvider.notifier).sync();
  }

  Future<void> _handleForceSync() async {
    await ref.read(syncControllerProvider.notifier).forceSync();
  }

  String _formatSyncTime(String? iso) {
    if (iso == null) return 'Nunca';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return '${dt.toLocal()}';
  }

  @override
  Widget build(BuildContext context) {
    final sync = ref.watch(syncControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingestion'),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ShadCard(
              title: 'Estado de sincronización',
              subtitle: 'Última actualización y datos almacenados localmente.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatusRow(
                    label: 'Última sync:',
                    value: _formatSyncTime(sync.lastSyncAt),
                  ),
                  _StatusRow(
                    label: 'Registros locales:',
                    value: '${sync.feedCount}',
                  ),
                  if (sync.syncing || sync.forceSyncing)
                    _StatusRow(
                      label: sync.forceSyncing ? 'Forzando:' : 'Sincronizando:',
                      value:
                          '${sync.downloaded} descargados · ${sync.inserted} insertados',
                    ),
                  if (sync.error != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: Text(
                        sync.error!,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ShadCard(
              title: 'Sincronizar',
              subtitle:
                  'Descarga desde PocketBase todos los registros nuevos desde la última sync.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed:
                        (sync.syncing || sync.forceSyncing) ? null : _handleSync,
                    style: _buttonStyle(),
                    child: sync.syncing
                        ? const _Spinner('Sincronizando…')
                        : const Text('Sincronizar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ShadCard(
              title: 'Forzar sincronización',
              subtitle:
                  'Borra todos los datos locales y descarga el historial completo desde el inicio.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: (sync.syncing || sync.forceSyncing)
                        ? null
                        : _handleForceSync,
                    style: _buttonStyle(),
                    child: sync.forceSyncing
                        ? const _Spinner('Forzando…')
                        : const Text('Forzar sincronización'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0EA5E9),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatusRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _Spinner extends StatelessWidget {
  final String label;

  const _Spinner(this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
