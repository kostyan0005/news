import 'dart:math';

const _charset =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
final _random = Random.secure();

String generateAutoId() =>
    List.generate(20, (_) => _charset[_random.nextInt(_charset.length)]).join();
