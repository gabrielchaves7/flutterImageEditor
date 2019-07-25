package com.example.editor_foto;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ColorMatrix;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.ColorMatrixColorFilter;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.List;

/** EditorFotoPlugin */
public class EditorFotoPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "editor_foto");
    channel.setMethodCallHandler(new EditorFotoPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      if (call.method.equals("aplicarBrilho")) {
          byte[] foto = call.argument("foto");
          double contraste = call.argument("contraste");
          double brilho = call.argument("brilho");
          Bitmap fotoBmp = BitmapFactory.decodeByteArray(foto, 0, foto.length);
          result.success(changeBitmapContrastBrightness(fotoBmp, (float)contraste, (float)brilho));
      } else {
          result.notImplemented();
      }
  }

    public static byte[] changeBitmapContrastBrightness(Bitmap bmp, float contrast, float brightness) {
        ColorMatrix cm = new ColorMatrix(new float[]
                {
                        contrast, 0, 0, 0, brightness,
                        0, contrast, 0, 0, brightness,
                        0, 0, contrast, 0, brightness,
                        0, 0, 0, 1, 0
                });

        Bitmap ret = Bitmap.createBitmap(bmp.getWidth(), bmp.getHeight(), bmp.getConfig());

        Canvas canvas = new Canvas(ret);

        Paint paint = new Paint();
        paint.setColorFilter(new ColorMatrixColorFilter(cm));
        canvas.drawBitmap(bmp, 0, 0, paint);

        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ret.compress(Bitmap.CompressFormat.JPEG, 80, byteArrayOutputStream);
        byte[] byteArray = byteArrayOutputStream.toByteArray();

        return byteArray;
    }
}
