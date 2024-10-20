package com.example.teampro4;  // Replace with your package name
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.teampro4/text_recognition";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("runTextRecognition")) {
                                String imagePath = call.argument("imagePath");
                                try {
                                    String recognizedText = runTextRecognition(imagePath);
                                    result.success(recognizedText);
                                } catch (IOException e) {
                                    result.error("UNAVAILABLE", "Text recognition failed.", null);
                                }
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String runTextRecognition(String imagePath) throws IOException {
        Bitmap bitmap = BitmapFactory.decodeFile(imagePath);
        InputImage image = InputImage.fromBitmap(bitmap, 0);
        TextRecognizer recognizer = TextRecognition.getClient();
        final StringBuilder recognizedText = new StringBuilder();

        recognizer.process(image)
                .addOnSuccessListener(
                        texts -> {
                            for (Text.TextBlock block : texts.getTextBlocks()) {
                                recognizedText.append(block.getText()).append("\n");
                            }
                        })
                .addOnFailureListener(
                        e -> {
                            e.printStackTrace();
                        });

        return recognizedText.toString();
    }
}