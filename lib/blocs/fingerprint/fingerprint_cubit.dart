import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/fingerprint/fingerprint_state.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintCubit extends Cubit<FingerprintState> {
  FingerprintCubit() : super(FingerprintInitial());

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> checkFingerprint() async {
    try {
      // Check if device supports biometrics
      bool isBiometricSupported = await _localAuth.isDeviceSupported();

      if (!isBiometricSupported) {
        emit(FingerprintFailure());
        return;
      }

      // Check if there are enrolled biometrics
      bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;

      if (!canAuthenticateWithBiometrics) {
        emit(FingerprintFailure());
        return;
      }

      // Authenticate user
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (isAuthenticated) {
        emit(FingerprintSuccess());
      } else {
        emit(FingerprintFailure());
      }
    } on PlatformException catch (e) {
      if (e.code == 'NotEnrolled') {
        debugPrint("No biometrics enrolled.");
      } else if (e.code == 'LockedOut') {
        debugPrint("Device locked due to too many failed attempts.");
      } else {
        debugPrint("Unknown error: ${e.message}");
      }
      emit(FingerprintFailure());
    } catch (e) {
      debugPrint("Unexpected error: $e");
      emit(FingerprintFailure());
    }
  }
}
