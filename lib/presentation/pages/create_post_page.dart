import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/bloc/community_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final List<File> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _showMediaPickerOptions() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedFiles.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileLimitExceeded(6))),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(l10n.selectPicturesFromAlbum),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImages();
                  }),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: Text(l10n.selectVideoFromAlbum),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImages() async {
    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(imageQuality: 80);

    if (!mounted || pickedFiles.isEmpty) return;

    final remainingSpace = 6 - _selectedFiles.length;
    if (pickedFiles.length > remainingSpace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileLimitExceeded(remainingSpace))),
      );
    }
    
    setState(() {
      _selectedFiles.addAll(pickedFiles.take(remainingSpace).map((file) => File(file.path)));
    });
  }

  Future<void> _pickVideo() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedFiles.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fileLimitExceeded(6))),
      );
      return;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFiles.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool canPost = _titleController.text.isNotEmpty && _contentController.text.isNotEmpty;

    return BlocListener<CommunityBloc, CommunityState>(
      listener: (context, state) {
        if (state is CommunityPostSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.createPost),
          actions: [
            BlocBuilder<CommunityBloc, CommunityState>(
              builder: (context, state) {
                final isSubmitting = state is CommunityLoading;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: canPost && !isSubmitting
                        ? () {
                            context.read<CommunityBloc>().add(AddPost(
                                  title: _titleController.text,
                                  content: _contentController.text,
                                  mediaFiles: _selectedFiles,
                                ));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade200,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),
                    child: isSubmitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(l10n.publish),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineSmall,
                decoration: InputDecoration.collapsed(
                  hintText: l10n.title,
                ),
              ),
              const Divider(height: 32),
              TextField(
                controller: _contentController,
                decoration: InputDecoration.collapsed(
                  hintText: l10n.content,
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 16),
              _buildMediaGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedFiles.length + (_selectedFiles.length < 6 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _selectedFiles.length && _selectedFiles.length < 6) {
          return GestureDetector(
            onTap: _showMediaPickerOptions,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.black54),
            ),
          );
        }

        final file = _selectedFiles[index];
        final isImage = ['.jpg', '.jpeg', '.png', '.gif'].any((ext) => file.path.toLowerCase().endsWith(ext));

        return Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: isImage
                    ? Image.file(file, fit: BoxFit.cover)
                    : _VideoThumbnail(videoFile: file),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const CircleAvatar(radius: 12, backgroundColor: Colors.black54, child: Icon(Icons.close, color: Colors.white, size: 16)),
              onPressed: () {
                setState(() {
                  _selectedFiles.removeAt(index);
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class _VideoThumbnail extends StatefulWidget {
  final File videoFile;

  const _VideoThumbnail({Key? key, required this.videoFile}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  Uint8List? _thumbnailData;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: widget.videoFile.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 256,
        quality: 50,
      );
      if (mounted) {
        setState(() {
          _thumbnailData = thumbnailData;
        });
      }
    } catch (e) {
      // Handle error, maybe show a broken icon
      debugPrint("Error generating thumbnail: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnailData == null) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return Image.memory(
      _thumbnailData!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
