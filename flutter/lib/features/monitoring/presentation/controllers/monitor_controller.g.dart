// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MonitorController)
final monitorControllerProvider = MonitorControllerProvider._();

final class MonitorControllerProvider
    extends $AsyncNotifierProvider<MonitorController, MonitorDataState> {
  MonitorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monitorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monitorControllerHash();

  @$internal
  @override
  MonitorController create() => MonitorController();
}

String _$monitorControllerHash() => r'5a6c7574f937278c8689df27ee96b33314b785bb';

abstract class _$MonitorController extends $AsyncNotifier<MonitorDataState> {
  FutureOr<MonitorDataState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MonitorDataState>, MonitorDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MonitorDataState>, MonitorDataState>,
              AsyncValue<MonitorDataState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
