import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderTextField extends StatefulWidget {
  final TextEditingController controller;
  final InputDecoration? decoration;
  final int maxLines;
  final int? maxLength;

  const VoiceRecorderTextField({
    super.key,
    required this.controller,
    this.decoration,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  State<VoiceRecorderTextField> createState() => _VoiceRecorderTextFieldState();
}

class _VoiceRecorderTextFieldState extends State<VoiceRecorderTextField> {
  AnotherAudioRecorder? _recorder;
  bool _isRecording = false;
  bool _micPermissionGranted = false;
  String? _filePath;

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      _micPermissionGranted = true;
      _startRecording();
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission permanently denied. Open settings.')),
      );
      openAppSettings();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Microphone Permission'),
        content: const Text('This app needs access to your microphone to record audio.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _micPermissionGranted = false;
            },
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final status = await Permission.microphone.request();
              if (status.isGranted) {
                setState(() => _micPermissionGranted = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🎤 Microphone permission granted')),
                );
                _startRecording();
              } else if (status.isPermanentlyDenied) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Permission permanently denied. Open settings.')),
                );
                openAppSettings();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('❌ Microphone permission denied')),
                );
              }
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _recorder = AnotherAudioRecorder(path, audioFormat: AudioFormat.AAC);
    await _recorder!.initialized;
    await _recorder!.start();

    setState(() {
      _isRecording = true;
      _filePath = path;
    });
  }

  Future<void> _stopRecording() async {
    if (_recorder != null && _isRecording) {
      final result = await _recorder!.stop();
      final path = result?.path;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          widget.controller.text = path;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('🎧 Recording saved at: $path')),
          );
        }
      }
    }

    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            decoration: widget.decoration,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
          ),
        ),
        Listener(
          onPointerDown: (_) => _checkAndRequestPermission(),
          onPointerUp: (_) => _stopRecording(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.red.withOpacity(0.2) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mic,
              color: _isRecording ? Colors.red : Colors.teal,
              size: _isRecording ? 32 : 28,
            ),
          ),
        ),
      ],
    );
  }
}
