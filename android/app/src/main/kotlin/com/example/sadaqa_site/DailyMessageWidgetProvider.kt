package com.example.sadaqa_site

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class DailyMessageWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val message = widgetData.getString("daily_message", "لا توجد بيانات")

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.daily_message_widget_layout)
            views.setTextViewText(R.id.widget_message, message)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
