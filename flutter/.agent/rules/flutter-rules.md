---
trigger: always_on
---

Always check for unnecessary rebuilds. If a Consumer can be wrapped around a smaller widget tree instead of the whole screen, do it.

# Flutter + Riverpod + Android Rules

## High-Level Objective
Maintain a highly scalable, reactive, and performant Android application using the **Riverpod 2.x (Generator)** ecosystem and **Feature-First** architecture.

---

## 🏗️ Architectural Constraints
- **Feature-First Structure**: Organize by feature, not by layer.
  - `lib/features/[feature_name]/domain/` (Models/Entities)
  - `lib/features/[feature_name]/data/` (Repositories/DTOs)
  - `lib/features/[feature_name]/presentation/` (Widgets/Screens)
  - `lib/features/[feature_name]/application/` (Providers/Notifiers)

---

## 💧 Riverpod Implementation Standards
- **Generator Only**: Always use `@riverpod` annotations. Do not use legacy `StateProvider` or `ChangeNotifierProvider`.
- **Async Handling**: Use `AsyncValue` for all UI-bound data. 
  - **Rule**: You must always handle `.when(data: ..., error: ..., loading: ...)` to ensure no unhandled loading states.
- **Invalidation Strategy**: After a successful POST/PUT/DELETE mutation, the Agent must call `ref.invalidate()` on the affected provider.
- **Widget Ref**: Use `ConsumerWidget` for screens and `Consumer` for granular rebuilds in large trees.

---

## 🤖 Android Specifics
- **Permissions**: If a feature requires hardware access, automatically check and prompt for updates in:
  - `android/app/src/main/AndroidManifest.xml`
  - `ios/Runner/Info.plist` (for parity)
- **Lifecycle**: Use `ref.onDispose` within providers to cancel streams, timers, or platform channels when the Android Activity/Fragment is destroyed.
- **Back Button**: Implement `PopScope` for custom back-navigation logic to match Android system gestures.

---

## 🛠️ Tooling & Commands
Whenever the codebase is modified:
1. **Build Runner**: If a model or provider changes, immediately run:
   `flutter pub run build_runner build --delete-conflicting-outputs`
2. **Lints**: Adhere to `flutter_lints`. No "magic numbers" for padding/colors; use `Theme.of(context)` or a global `AppSpacing` constant.
3. **Localization**: All strings must be placed in `lib/l10n/app_en.arb`. Hardcoded strings in `Text()` widgets are a violation.

---

## 📝 Agent Interaction Instructions
- **Step 1**: Before writing code, check if a Repo/Service exists for the data.
- **Step 2**: Generate the `@freezed` model.
- **Step 3**: Generate the `@riverpod` notifier.
- **Step 4**: Build the UI using `ref.watch`.
- **Step 5**: Run build_runner and verify no compilation errors.