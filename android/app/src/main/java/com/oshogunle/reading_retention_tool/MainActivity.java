package com.oshogunle.reading_retention_tool;

import android.os.Bundle;

import java.nio.ByteBuffer;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.content.Intent;


public class MainActivity extends FlutterActivity {

  private String sharedText;

 /* @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // Handle intent when app is initially opened
    handleSendIntent(getIntent());

    new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.contentEquals("getSharedData")) {
                  result.success(sharedData);
                  sharedData.clear();
                }
              }
            }
    );
  }*/

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/html".equals(type)) {
        handleSendText(intent); // Handle text being sent
      }
    }

    new MethodChannel(getFlutterView(), "app.channel.shared.data").setMethodCallHandler(
            new MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.contentEquals("getSharedText")) {
                  result.success(sharedText);
                  sharedText = null;
                }
              }
            });
  }

  private void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  }

/*  @Override
  protected void onNewIntent(Intent intent) {
    // Handle intent when app is resumed
    super.onNewIntent(intent);
    handleSendIntent(intent);
  }

  private void handleSendIntent(Intent intent) {
    String action = intent.getAction();
    String type = intent.getType();

    // We only care about sharing intent that contain html
    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/html".equals(type)) {
        sharedData.put("subject", intent.getStringExtra(Intent.EXTRA_SUBJECT));
        sharedData.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
      }
    }
  }*/
}
