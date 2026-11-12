package com.itsash.vrat

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews
import org.json.JSONObject
import java.time.LocalDate
import java.time.temporal.ChronoUnit

/**
 * Home-screen widget: the next followed vrat or festival and the two after it.
 * The app (Dart) stores the next ~60 days as JSON; this class drops past dates
 * by the local date and works out "Today / Tomorrow / in N days" itself, so it
 * stays right without the app being opened.
 */
class VratWidget : AppWidgetProvider() {

    override fun onUpdate(context: Context, manager: AppWidgetManager, appWidgetIds: IntArray) {
        val views = build(context)
        for (id in appWidgetIds) manager.updateAppWidget(id, views)
    }

    private class Item(val date: LocalDate, val name: String, val label: String)

    companion object {
        private const val PREFS = "vrat_widget"
        private const val KEY = "data"

        fun save(context: Context, json: String) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putString(KEY, json).apply()
        }

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, VratWidget::class.java))
            if (ids.isEmpty()) return
            val views = build(context)
            for (id in ids) manager.updateAppWidget(id, views)
        }

        private fun load(context: Context): Pair<Boolean, List<Item>> {
            val raw = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY, null)
                ?: return Pair(false, emptyList())
            return try {
                val root = JSONObject(raw)
                val arr = root.getJSONArray("items")
                val today = LocalDate.now()
                val items = ArrayList<Item>()
                for (i in 0 until arr.length()) {
                    val o = arr.getJSONObject(i)
                    val date = LocalDate.parse(o.getString("d"))
                    if (!date.isBefore(today)) items.add(Item(date, o.getString("n"), o.optString("l")))
                }
                items.sortBy { it.date }
                Pair(root.optBoolean("hindi"), items)
            } catch (e: Exception) {
                Pair(false, emptyList())
            }
        }

        private fun whenLabel(context: Context, hindi: Boolean, date: LocalDate): String {
            val days = ChronoUnit.DAYS.between(LocalDate.now(), date)
            return when {
                days <= 0L -> if (hindi) "आज" else context.getString(R.string.widget_today)
                days == 1L -> if (hindi) "कल" else context.getString(R.string.widget_tomorrow)
                else -> if (hindi) "$days दिन में" else context.getString(R.string.widget_in_days, days.toInt())
            }
        }

        private fun build(context: Context): RemoteViews {
            val (hindi, items) = load(context)
            val views = RemoteViews(context.packageName, R.layout.widget_vrat)

            if (items.isEmpty()) {
                views.setViewVisibility(R.id.widget_content, View.GONE)
                views.setViewVisibility(R.id.widget_empty, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_content, View.VISIBLE)
                views.setViewVisibility(R.id.widget_empty, View.GONE)
                val first = items[0]
                views.setTextViewText(R.id.widget_name, first.name)
                views.setTextViewText(R.id.widget_when, whenLabel(context, hindi, first.date))
                views.setTextViewText(R.id.widget_date, first.label)
                val rows = intArrayOf(R.id.widget_next1, R.id.widget_next2)
                for (i in rows.indices) {
                    val item = items.getOrNull(i + 1)
                    if (item == null) {
                        views.setViewVisibility(rows[i], View.GONE)
                    } else {
                        views.setViewVisibility(rows[i], View.VISIBLE)
                        views.setTextViewText(rows[i], "${item.name}  ·  ${item.label}  ·  ${whenLabel(context, hindi, item.date)}")
                    }
                }
            }

            val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
                ?: Intent(Intent.ACTION_MAIN).setPackage(context.packageName)
            val pending = PendingIntent.getActivity(
                context, 0, launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            views.setOnClickPendingIntent(R.id.widget_root, pending)
            return views
        }
    }
}
