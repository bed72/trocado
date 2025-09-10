import 'package:flutter/widgets.dart';

import 'livedata.dart';

final class _Event<T> {
  final T value;

  _Event(this.value);
}

/// An abstraction to communicate events to UI from ViewModel or the likes.
///
/// Depends on `LiveData` internally.
///
/// Most of the events originate in the UI, so wouldn't need communication of
/// the same to the UI layer.
///
/// In the rest of the cases, there will be changes to the "state" of the UI exposed
/// via `LiveData` / `Stream` etc.
///
/// But there are cases where the UI needs to be notified of events after an
/// asynchronous work etc for things like toasts, dialogs etc. These are essentially
/// "ephemeral state" and should be cleared after being handled.
/// Just as described in the [Official Android Guidelines for UI Events](https://developer.android.com/topic/architecture/ui-layer/events#consuming-trigger-updates)
///
/// If you are in doubt of whether to put something inside the state or fire an event,
/// prefer the state.
abstract class EventQueue<T> {
  final List<_Event<T>> _events = <_Event<T>>[];

  LiveData<_Event<T>?> get _nextEvent => _mutableNextEvent;

  final MutableLiveData<_Event<T>?> _mutableNextEvent =
      MutableLiveData<_Event<T>?>(null);

  void _onHandled(_Event<T> event) {
    _events.remove(event);

    _events.isNotEmpty
        ? _mutableNextEvent.value = _events.first
        : _mutableNextEvent.value = null;
  }

  void _push(T value) {
    final event = _Event<T>(value);
    _events.add(event);

    if (_mutableNextEvent.value == null && _events.isNotEmpty) {
      _mutableNextEvent.value = _events.first;
    }
  }
}

final class MutableEventQueue<T> extends EventQueue<T> {
  void push(T value) {
    _push(value);
  }
}

class EventListener<T> extends StatefulWidget {
  final Widget child;
  final EventQueue<T> eventQueue;
  final Future<void> Function(BuildContext, T) onEvent;

  const EventListener({
    super.key,
    required this.child,
    required this.onEvent,
    required this.eventQueue,
  });

  @override
  State<StatefulWidget> createState() => _EventListenerState<T>();
}

class _EventListenerState<T> extends State<EventListener<T>> {
  bool _handledInitialValue = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_handledInitialValue) {
      _handledInitialValue = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _onChange(context, widget.eventQueue._nextEvent.value);
      });
    }
  }

  Future<void> _onChange(BuildContext context, _Event<T>? event) async {
    if (event != null) {
      await widget.onEvent(context, event.value);
      widget.eventQueue._onHandled(event);
    }
  }

  @override
  Widget build(BuildContext context) => LiveDataListener<_Event<T>?>(
    liveData: widget.eventQueue._nextEvent,
    changeListener: (ctx, event, _) => _onChange(ctx, event),
    child: widget.child,
  );
}
