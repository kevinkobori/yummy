import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_carousel/reorderable_carousel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:another_flushbar/flushbar.dart';
import '../../../components/image_source_sheet.dart';
import '../../../controllers/recipes/recipe.dart';

class ImagesForm extends StatefulWidget {
  final Recipe recipe;
  const ImagesForm(this.recipe);
  @override
  _ImagesFormState createState() => _ImagesFormState();
}

class _ImagesFormState extends State<ImagesForm> {
  int globalIndex = 0;
  int insertIndex;
  String mode;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: List.from(widget.recipe.images),
      validator: (images) {
        if (images.isEmpty)
          return 'Insira ao menos uma imagem';
        else if (images[0] ==
            'https://idealservis.com.br/portal/wp-content/uploads/2014/07/default-placeholder.png')
          return 'Mude a imagem principal';
        return null;
      },
      onSaved: (images) => widget.recipe.newImages = images,
      builder: (state) {
        void onImagesSelected(List<dynamic> listImages, String type) {
          if (type == 'instagram') {
          } else {
            if (mode == 'replace') {
              insertIndex = globalIndex;
              state.value.removeAt(globalIndex);
              state.value.insert(insertIndex, listImages[0]);
              state.didChange(state.value);
            } else {
              state.value.insert(insertIndex, listImages[0]);
              state.didChange(state.value);
            }
          }
          Navigator.of(context).pop();
        }

        if (state.value.isEmpty) {
          state.value.insert(0,
              'https://idealservis.com.br/portal/wp-content/uploads/2014/07/default-placeholder.png');
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  if (state.value[globalIndex] is String)
                    Image.network(
                      state.value[globalIndex] as String,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Image.file(
                        state.value[globalIndex] as File,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: Theme.of(context).accentColor,
                          child: InkWell(
                            onTap: () {
                              mode = 'replace';

                              if (Platform.isAndroid)
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => ImageSourceSheet(
                                    onImagesSelected: onImagesSelected,
                                  ),
                                );
                              else
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (_) => ImageSourceSheet(
                                    onImagesSelected: onImagesSelected,
                                  ),
                                );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 8.0, 12.0, 8.0),
                              child: Text(
                                'Mudar Foto',
                                style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipOval(
                        child: Material(
                          color: Theme.of(context).accentColor,
                          child: InkWell(
                            onTap: () {
                              if (globalIndex == 0) {
                                state.value.removeAt(globalIndex);
                                state.didChange(state.value);
                              } else {
                                final int lastGlobalIndex = globalIndex;
                                globalIndex = globalIndex - 1;
                                state.value.removeAt(lastGlobalIndex);
                                state.didChange(state.value);
                              }
                            },
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.remove,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
