import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
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
  File? _recordedFile;
  bool _isVoiceRecorded = false;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _setupAudioSession();
  }

  Future<void> _setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      _startRecording();
    } else if (status.isDenied || status.isRestricted || status.isLimited) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission permanently denied. Open settings.')),
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final status = await Permission.microphone.request();
              if (status.isGranted) {
                _startRecording();
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
    });
  }

  Future<void> _stopRecording() async {
    if (_recorder != null && _isRecording) {
      final result = await _recorder!.stop();
      final path = result?.path;
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          setState(() {
            _recordedFile = file;
            _isVoiceRecorded = true;
          });
          widget.controller.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('🎧 Voice recorded: ${file.path.split("/").last}')),
          );
        }
      }
    }
    setState(() => _isRecording = false);
  }

  Future<void> _playRecording() async {
    if (_recordedFile != null) {
      try {
        print("Trying to play: ${_recordedFile!.path}");
        print("Exists: ${_recordedFile!.existsSync()}");
        print("Size: ${_recordedFile!.lengthSync()} bytes");

        await _player.setFilePath(_recordedFile!.path);
        await _player.play();
      } catch (e) {
        debugPrint('Error playing recording: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Playback error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                enabled: !_isVoiceRecorded,
                decoration: widget.decoration ??
                    const InputDecoration(
                      hintText: 'Special Instructions (Optional)',
                      border: OutlineInputBorder(),
                    ),
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
              ),
            ),
            const SizedBox(width: 10),
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
        ),
        if (_recordedFile != null) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _playRecording,
            child: Row(
              children: const [
                Icon(Icons.play_arrow, color: Colors.teal),
                SizedBox(width: 4),
                Text("Play Recorded Voice"),
              ],
            ),
          ),
        ]
      ],
    );
  }
}
