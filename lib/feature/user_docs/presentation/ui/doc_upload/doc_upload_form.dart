part of 'doc_upload_page.dart';

class _DocUploadForm extends StatelessWidget {
  const _DocUploadForm();

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<DocUploadBloc, DocUploadState>(
    builder: (context, state) => Padding(
      padding: EdgeInsets.all(DsSpacing.radialSpace16),
      child: Column(
        spacing: DsSpacing.verticalSpace24,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: DsColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(
                DsBorderRadius.borderRadius16,
              ),
              border: Border.all(color: DsColors.borderSubtle),
            ),
            child: Padding(
              padding: EdgeInsets.all(DsSpacing.radialSpace16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: DsSpacing.verticalSpace12,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: DsSizing.size20,
                    color: DsColors.primary,
                  ),
                  const DsText.titleMedium(data: 'Drag & drop files here'),
                  const DsText.bodySmall(
                    data:
                        '''Supported formats: PDF, DOCX, TXT. Max file size: 10MB.''',
                    color: DsColors.textSecondary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: DsSpacing.verticalSpace12),
                  ElevatedButton(
                    onPressed: () =>
                        getBloc<DocUploadBloc>(context).uploadRequested(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DsColors.buttonPrimary,
                      foregroundColor: DsColors.buttonPrimaryText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DsBorderRadius.borderRadius22,
                        ),
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
          if (state.store.isUploading ||
              state.store.uploadError != null ||
              state.store.uploadResponse != null ||
              state is OnUploadSuccess)
            UploadDocCard(
              fileName: state.store.fileName.isEmpty
                  ? 'Selected document'
                  : state.store.fileName,
              progress: state.store.progress,
              isUploading: state.store.isUploading,
              isError:
                  state is OnUploadFailure || state is OnUploadProgressError,
              errorMessage: state.store.uploadError,
              onCancel: state.store.isUploading ? () {} : null,
            ),
        ],
      ),
    ),
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
  final double progress;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
              size: DsSizing.size22,
            ),
          ),
          SizedBox(width: DsSpacing.horizontalSpace12),
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

          const UploadActionButton(),
        ],
      ),
    );
  }
}

class UploadActionButton extends StatelessWidget {
  const UploadActionButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DocUploadBloc, DocUploadState>(
        buildWhen: (prev, curr) =>
            prev.store.isUploading != curr.store.isUploading ||
            prev.store.uploadError != curr.store.uploadError ||
            prev.store.progress != curr.store.progress,
        builder: (context, state) {
          final bloc = getBloc<DocUploadBloc>(context);
          final store = state.store;

          if (store.isUploading) {
            return IconButton(
              icon: Icon(Icons.close, size: DsSizing.size24),
              onPressed: bloc.cancelUpload,
            );
          }

          if (state is OnException) {
            return DsTextButton.primary(
              onTap: bloc.uploadRequested,
              data: 'Retry',
            );
          }

          if (state is OnUploadSuccess) {
            return Icon(
              Icons.check_circle,
              color: DsColors.textSuccess,
              size: DsSizing.size24,
            );
          }

          return const SizedBox.shrink();
        },
      );
}
