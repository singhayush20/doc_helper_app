part of 'doc_upload_page.dart';

class _DocUploadForm extends StatelessWidget {
  const _DocUploadForm();

  Future<void> _pickFile(BuildContext context) async {
    // TODO: plug in file_picker later
    // For now just call bloc with a dummy path or integrate real picker.
    // final result = await FilePicker.platform.pickFiles(...);
    // if (result != null && result.files.single.path != null) {
    //   context.read<UploadDocBloc>().fileSelected(result.files.single.path!);
    // }
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DocUploadBloc, DocUploadState>(
    builder: (context, state) {
      final store = state.store;

      return Padding(
        padding: EdgeInsets.all(DsSpacing.radialSpace16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload area card
            DecoratedBox(
              decoration: BoxDecoration(
                color: DsColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DsColors.borderSubtle),
              ),
              child: Padding(
                padding: EdgeInsets.all(DsSpacing.radialSpace16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: DsSpacing.verticalSpace12,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: DsColors.primary,
                    ),
                    const DsText.titleMedium(data: 'Drag & drop files here'),
                    const DsText.bodySmall(
                      data:
                          'Supported formats: PDF, DOCX, TXT. Max file size: 10MB.',
                      color: DsColors.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: DsSpacing.verticalSpace12),
                    ElevatedButton(
                      onPressed: () => _pickFile(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DsColors.buttonPrimary,
                        foregroundColor: DsColors.buttonPrimaryText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const DsText.labelLarge(
                        data: 'Choose File',
                        color: DsColors.buttonPrimaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: DsSpacing.verticalSpace24),

            if (store.isUploading ||
                store.errorMessage != null ||
                store.uploadResponse != null)
              UploadDocCard(
                fileName: store.fileName.isEmpty
                    ? 'Selected document'
                    : store.fileName,
                progress: store.progress,
                isUploading: store.isUploading,
                isError: state is OnException,
                errorMessage: store.errorMessage,
                onCancel: store.isUploading
                    ? () => context.read<DocUploadBloc>().cancelUpload()
                    : null,
              ),
          ],
        ),
      );
    },
  );
}

class UploadDocCard extends StatelessWidget {
  const UploadDocCard({
    super.key,
    required this.fileName,
    required this.progress,
    required this.isUploading,
    this.isError = false,
    this.errorMessage,
    this.onCancel,
  });

  final String fileName;
  final double progress; // 0.0 - 1.0
  final bool isUploading;
  final bool isError;
  final String? errorMessage;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).clamp(0, 100).toStringAsFixed(0);

    final Color borderColor = isError ? DsColors.error : DsColors.borderSubtle;

    return Container(
      decoration: BoxDecoration(
        color: DsColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius12),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.all(DsSpacing.radialSpace12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading icon
          Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: isError
                  ? DsColors.error.withAlpha(25)
                  : DsColors.backgroundSubtle,
              borderRadius: BorderRadius.circular(DsBorderRadius.borderRadius8),
            ),
            child: Icon(
              isError ? Icons.error_outline : Icons.insert_drive_file_outlined,
              color: isError ? DsColors.error : DsColors.primary,
              size: 22.r,
            ),
          ),
          SizedBox(width: DsSpacing.horizontalSpace12),

          // Text + progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: DsSpacing.verticalSpace4,
              children: [
                DsText.labelLarge(
                  data: fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isError && errorMessage != null) ...[
                  DsText.bodySmall(
                    data: errorMessage!,
                    color: DsColors.textError,
                  ),
                ] else ...[
                  // Progress bar
                  SizedBox(
                    height: 6.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        DsBorderRadius.borderRadius4,
                      ),
                      child: LinearProgressIndicator(
                        value: isUploading ? progress : 1,
                        backgroundColor: DsColors.backgroundDisabled,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          DsColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: DsSpacing.verticalSpace4),
                  DsText.bodySmall(
                    data: isUploading
                        ? '$percent% complete'
                        : 'Upload completed',
                    color: DsColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),

          // Cancel / close button
          if (isUploading || onCancel != null)
            IconButton(
              icon: Icon(
                isUploading ? Icons.close : Icons.check,
                color: isError
                    ? DsColors.error
                    : (isUploading
                          ? DsColors.textSecondary
                          : DsColors.textSuccess),
                size: 20.r,
              ),
              onPressed: isUploading ? onCancel : null,
            ),
        ],
      ),
    );
  }
}
