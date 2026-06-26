import 'package:drift/wasm.dart';

/// Entry point compiled to `drift_worker.dart.js` for Drift's web database.
void main() {
  WasmDatabase.workerMainForOpen();
}
