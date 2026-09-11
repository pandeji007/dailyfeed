import 'package:dailyfeed/core/exceptions.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  IconData get _icon {
    if (error is AppException) {
      switch ((error as AppException).type) {
        case AppErrorType.noInternet:
          return Icons.wifi_off_rounded;
        case AppErrorType.timeout:
          return Icons.timer_off_outlined;
        case AppErrorType.unauthorized:
          return Icons.lock_outline_rounded;
        default:
          return Icons.error_outline_rounded;
      }
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final message = error is AppException
        ? (error as AppException).message
        : 'Something went wrong. Please try again.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(_icon, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
