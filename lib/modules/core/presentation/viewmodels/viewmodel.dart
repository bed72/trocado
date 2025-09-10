/// `ViewModel`s are essentially UI State Controllers
///
/// A `ViewModel` lives until the 'Scope' of it is disposed
/// Inside a `ViewModelScope`, you can access a `ViewModel` inside a Widget like this
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   final CounterViewModel viewModel = context.getViewModel();
/// }
/// ```
///
/// `ViewModel`s allow for UI Widgets to be as simple as possible
/// UI only talks and listens to the `ViewModel`, the rest of
/// the application code is abstracted away.
///
/// ```
///                               ┌─────────┐
///                  ┌───────────►│ Network │
///                  │            └─────────┘
/// ┌────┐     ┌─────┴─────┐      ┌──────────┐
/// │ UI │◄───►│ ViewModel ├─────►│ Database │
/// └────┘     └─────┬─────┘      └──────────┘
///                  │            ┌──────────┐
///                  └───────────►│ MemCache │
///                               └──────────┘
/// ```
/// One can choose to have more abstractions between the `ViewModel`
/// and network, database and memcache like `Repository`, `Service`
/// to simplify the logic inside a `ViewModel` or to hold some state
/// in a larger scope than the ViewModel
abstract class ViewModel {
  void onDispose() {}
}

final class ViewModelStore {
  final Map<String, ViewModel> _viewModels = <String, ViewModel>{};

  T? get<T extends ViewModel>({String key = ''}) {
    final Type type = T;
    return _viewModels['$key:$type'] as T?;
  }

  void put<T extends ViewModel>(T viewModel, {String key = ''}) {
    final Type type = T;
    _viewModels['$key:$type'] = viewModel;
  }

  void dispose() {
    for (final ViewModel viewModel in _viewModels.values) {
      viewModel.onDispose();
    }
    _viewModels.clear();
  }
}
