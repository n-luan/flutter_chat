package com.example.chat;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.support.v4.app.RemoteInput;
import android.content.Context;
import android.content.Intent;
import android.content.ComponentName;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.support.v4.app.NotificationCompat;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import java.util.Map;
import java.util.List;
import static android.R.drawable.ic_delete;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RecentTaskInfo;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.ActivityManager.RunningTaskInfo;
import android.app.KeyguardManager;
import android.support.v4.app.TaskStackBuilder;

import me.leolin.shortcutbadger.ShortcutBadger;

public class MyFirebaseMessagingService extends FirebaseMessagingService {

  @Override
  public void onMessageReceived(RemoteMessage remoteMessage) {
    super.onMessageReceived(remoteMessage);
    if (isLocked() || !isRunning("com.example.chat")) {
      RemoteMessage.Notification notification = remoteMessage.getNotification();
      Map<String, String> data = remoteMessage.getData();
      sendNotification(notification, data);
    }
  }

  public boolean isRunning(String myPackage) {
    ActivityManager manager = (ActivityManager) getSystemService(ACTIVITY_SERVICE);
    List<ActivityManager.RunningTaskInfo> runningTaskInfo = manager.getRunningTasks(1);
    ComponentName componentInfo = runningTaskInfo.get(0).topActivity;

    System.out.println(componentInfo.getClassName());

    return componentInfo.getPackageName().equals(myPackage);
  }

  public boolean isLocked() {
    KeyguardManager myKM = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
    return myKM.inKeyguardRestrictedInputMode();
  }

  private void sendNotification(RemoteMessage.Notification notification, Map<String, String> data) {
    Bitmap icon = BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher);

    try {
      // Create an Intent for the activity you want to start
      Intent resultIntent = new Intent(this, MainActivity.class).setAction(Intent.ACTION_MAIN)
          .addCategory("FLUTTER_NOTIFICATION_CLICK")
          .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
      PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, resultIntent, PendingIntent.FLAG_UPDATE_CURRENT);

      JSONObject jo = new JSONObject(data.get("user"));

      String name = jo.getString("name");
      // int id = Integer.parseInt(data.get("id"));
      int id = 0;
      String text = data.get("text");
      int unread_count = Integer.parseInt(data.get("unread_count"));

      NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, "channel_id")
          .setContentTitle(name).setContentText(text).setAutoCancel(true)
          .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
          .setDefaults(Notification.DEFAULT_VIBRATE).setSmallIcon(R.mipmap.ic_launcher).setContentIntent(pendingIntent)
          .setPriority(Notification.PRIORITY_MAX).setContentInfo(text).setLargeIcon(icon).setColor(Color.BLUE)
          .setLights(Color.GREEN, 1000, 300);

      NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

      Notification _notification = notificationBuilder.build();

      ShortcutBadger.applyCount(getApplicationContext(), unread_count);
      ShortcutBadger.applyNotification(getApplicationContext(), _notification, unread_count);

      notificationManager.notify(id, _notification);

    } catch (Exception e) {
      // TODO: handle exception
      System.out.println(e);
    }
  }
}
