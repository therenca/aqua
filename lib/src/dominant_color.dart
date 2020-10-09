import 'package:flutter/widgets.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> getColorFromAvatar(ImageProvider imageProvider) async {
	var palletGenerator = await PaletteGenerator.fromImageProvider(imageProvider);
	return palletGenerator.dominantColor.color;
}