import 'dart:async'; // Add this for Timer
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentinix_ecommerce/Reusable/color.dart';

class VoiceRecorderTextField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<File?>? onRecordingComplete;
  final double height;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  const VoiceRecorderTextField({
    super.key,
    required this.controller,
    this.onRecordingComplete,
    this.height = 45,
    this.iconSize = 20,
    this.padding,
  });

  @override
  State<VoiceRecorderTextField> createState() => _VoiceRecorderTextFieldState();
}

class _VoiceRecorderTextFieldState extends State<VoiceRecorderTextField> {
  bool _isRecording = false;
  bool _isPlaying = false;
  File? _audioFile;
  AnotherAudioRecorder? _recorder;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration? _recordingDuration;
  Duration? _playbackPosition;
  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() => _isPlaying = false);
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() => _playbackPosition = position);
    });
  }

  @override
  void dispose() {
    _stopRecording(); // Properly stop recording if active
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  Future<bool> _checkPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Microphone permission denied")),
          );
        }
        return false;
      }

      if (Platform.isAndroid) {
        final storageStatus = await Permission.manageExternalStorage.request();
        if (!storageStatus.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Storage permission denied")),
            );
          }
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _startRecording() async {
    if (!await _checkPermissions()) return;

    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.wav';

      _recorder = AnotherAudioRecorder(filePath, audioFormat: AudioFormat.WAV);
      final recording = await _recorder?.start();
      if (recording == null) {
        throw Exception("Failed to initialize recorder");
      }

      // Start recording timer
      _recordingDuration = Duration.zero;
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mounted) {
          setState(() {
            _recordingDuration = Duration(seconds: timer.tick);
          });
        }
      });

      if (mounted) {
        setState(() {
          _isRecording = true;
          _audioFile = null;
          widget.controller.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Recording failed: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    if (_recorder == null) return;

    try {
      final result = await _recorder?.stop();
      if (result?.path == null) return;

      final recordedFile = File(result!.path!);
      if (recordedFile.existsSync() && recordedFile.lengthSync() > 0) {
        if (mounted) {
          setState(() {
            _audioFile = recordedFile;
            _isRecording = false;
            _playbackPosition = null;
          });
        }
        widget.onRecordingComplete?.call(_audioFile);
      } else {
        recordedFile.deleteSync();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Recording failed - empty file")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Stop recording failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecording = false);
      }
    }
  }

  void _deleteAudio() {
    _audioFile?.deleteSync();
    if (mounted) {
      setState(() {
        _audioFile = null;
        _playbackPosition = null;
      });
    }
    widget.onRecordingComplete?.call(null);
  }

  Future<void> _playAudio() async {
    if (_audioFile == null || !_audioFile!.existsSync()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No voice file found to play.")),
        );
      }
      return;
    }

    try {
      if (mounted) {
        setState(() => _isPlaying = true);
      }
      await _audioPlayer.play(DeviceFileSource(_audioFile!.path));
    } catch (e) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Playback error: ${e.toString()}")),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pause error: ${e.toString()}")),
        );
      }
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: widget.height,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                // Record/Stop button
                GestureDetector(
                  onTap: _isRecording ? _stopRecording : _startRecording,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: widget.iconSize,
                    color: _isRecording ? Colors.red : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(width: 12),

                // Status text and duration
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _audioFile != null
                            ? "Voice message"
                            : _isRecording
                            ? "Recording..."
                            : "Tap mic to record",
                        style: TextStyle(
                          fontSize: 13,
                          color: (_isRecording || _audioFile != null)
                              ? Colors.black87
                              : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_isRecording || _audioFile != null)
                        Text(
                          _isRecording
                              ? _formatDuration(_recordingDuration)
                              : _formatDuration(_playbackPosition ??
                              Duration(milliseconds: _audioFile?.lengthSync() ?? 0)),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                // Playback controls
                if (_audioFile != null) ...[
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.green,
                    ),
                    onPressed: _isPlaying ? _pauseAudio : _playAudio,
                    iconSize: widget.iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteAudio,
                    iconSize: widget.iconSize,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}