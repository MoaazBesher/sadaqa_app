package com.example.sadaqa_site

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class PrayerTimesWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val prayerTimes = widgetData.getString("prayer_times", "لا توجد بيانات")
        val nextPrayer = widgetData.getString("next_prayer", "")
        val nextPrayerTime = widgetData.getString("next_prayer_time", "")
        val countdown = widgetData.getString("countdown", "")

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.prayer_times_widget_layout)

            views.setTextViewText(R.id.widget_next_prayer_label, "التالي: $nextPrayer")
            views.setTextViewText(R.id.widget_next_prayer_time, nextPrayerTime ?: "")

            if (countdown != null && countdown.isNotEmpty()) {
                views.setTextViewText(R.id.widget_countdown, countdown)
            } else {
                views.setTextViewText(R.id.widget_countdown, "")
            }

            views.setTextViewText(R.id.widget_prayer_times, prayerTimes ?: "لا توجد بيانات")

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
