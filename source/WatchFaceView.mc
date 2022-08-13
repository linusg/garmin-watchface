import Toybox.ActivityMonitor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;

typedef DrawIconMethod as Method(
    dc as Dc,
    x as Number,
    y as Number,
    scale as Float,
    options as Dictionary?
) as Void;

typedef Indicator as {
    :text as String,
    :drawIcon as DrawIconMethod?,
    :drawIconOptions as Dictionary?,
};

class WatchFaceView extends WatchUi.WatchFace {

    private var _drawBoundingBoxes as Boolean = false;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        dc.setAntiAlias(true);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onUpdate(dc as Dc) as Void {
        var activityMonitorInfo = ActivityMonitor.getInfo();
        var deviceSettings = System.getDeviceSettings();
        var systemStats = System.getSystemStats();
        var currentConditions = Weather.getCurrentConditions();
        var now = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);

        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(
            Lang.format("$1$, $2$ $3$", [now.day_of_week, now.day, now.month])
        );

        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(
            Lang.format("$1$:$2$", [now.hour.format("%02d"), now.min.format("%02d")])
        );

        View.onUpdate(dc);

        var topIndicators = [] as Array<Indicator>;
        var bottomIndicators1 = [] as Array<Indicator>;
        var bottomIndicators2 = [] as Array<Indicator>;

        if (
            currentConditions != null
            && (currentConditions as CurrentConditions).temperature != null
        ) {
            topIndicators.add({
                :text => Lang.format("$1$ °C", [
                    (
                        (currentConditions as CurrentConditions).temperature as Number
                    ).format("%d"),
                ]),
            });
        }
        if (deviceSettings.notificationCount) {
            topIndicators.add({
                :text => deviceSettings.notificationCount.toString(),
                :drawIcon => (
                    new Lang.Method(Icons, :drawNotificationIcon) as DrawIconMethod
                ),
            });
        }
        if (deviceSettings.alarmCount) {
            topIndicators.add({
                :text => deviceSettings.alarmCount.toString(),
                :drawIcon => new Lang.Method(Icons, :drawAlarmIcon) as DrawIconMethod,
            });
        }

        if (
            activityMonitorInfo.steps != null
            && activityMonitorInfo.stepGoal != null
        ) {
            bottomIndicators1.add({
                :text => Lang.format("$1$/$2$", [
                    (activityMonitorInfo.steps as Number).toString(),
                    (activityMonitorInfo.stepGoal as Number).toString(),
                ]),
            });
        }
        if (activityMonitorInfo.distance != null) {
            bottomIndicators1.add({
                :text => Lang.format("$1$ km", [
                    (
                        (activityMonitorInfo.distance as Number).toFloat() / 100000
                    ).format("%.1f"),
                ]),
            });
        }

        bottomIndicators2.add({
            :text => Lang.format("$1$%", [systemStats.battery.format("%d")]),
            :drawIcon => new Lang.Method(Icons, :drawBatteryIcon) as DrawIconMethod,
            :drawIconOptions => {
                :percentage => systemStats.battery,
                :isCharging => systemStats.charging,
            },
        });

        var indicatorHeight = 32;
        drawIndicators(dc, topIndicators, 40, indicatorHeight);
        drawIndicators(
            dc,
            bottomIndicators1,
            deviceSettings.screenHeight - indicatorHeight * 2 - 70,
            indicatorHeight
        );
        drawIndicators(
            dc,
            bottomIndicators2,
            deviceSettings.screenHeight - indicatorHeight - 40,
            indicatorHeight
        );
    }

    function getScreenSizeAtOffsetY(offsetY as Number, height as Number) as {
        :offsetX as Number, :widthAtOffsetY as Number
    } {
        var deviceSettings = System.getDeviceSettings();
        if (offsetY + height > deviceSettings.screenHeight / 2) {
            offsetY += height;
        }
        var widthAtOffsetY = 2 * Math.sqrt(
            Math.pow(deviceSettings.screenWidth / 2, 2)
            - Math.pow(deviceSettings.screenWidth / 2 - offsetY, 2)
        );
        var offsetX = (deviceSettings.screenWidth - widthAtOffsetY) / 2;
        return {
            :offsetX => offsetX.toNumber(),
            :widthAtOffsetY => widthAtOffsetY.toNumber(),
        };
    }

    function drawIndicators(
        dc as Dc, indicators as Array<Indicator>, offsetY as Number, height as Number
    ) as Void {
        var screenSize = getScreenSizeAtOffsetY(offsetY, height);
        var widthAtOffsetY = screenSize[:widthAtOffsetY] as Number;
        var offsetX = screenSize[:offsetX] as Number;
        for (var i = 0; i < indicators.size(); i++) {
            var indicator = indicators[i];
            var x = widthAtOffsetY / indicators.size() * i + offsetX;
            var y = offsetY;
            var width = widthAtOffsetY / indicators.size();
            drawIndicator(dc, x, y, width, height, indicator);
        }
    }

    function drawIndicator(
        dc as Dc,
        x as Number,
        y as Number,
        width as Number,
        height as Number,
        indicator as Indicator
    ) as Void {
        // Let's just say it's a square
        var iconWidth = indicator[:drawIcon] != null ? height : 0;
        var iconHeight = height;

        var textDimensions = dc.getTextDimensions(
            indicator[:text] as String,
            Graphics.FONT_TINY
        );
        var textWidth = textDimensions[0];
        var textHeight = textDimensions[1];

        var offsetX = (width - (iconWidth + textWidth)) / 2;

        var iconX = x + offsetX;
        var iconY = y;

        var textX = x + offsetX + iconWidth + (iconWidth ? 4 : 0);
        var textY = y + (height - textHeight) / 2;

        if (_drawBoundingBoxes) {
            dc.setPenWidth(1);
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(x, y, width, height);
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(iconX, iconY, iconWidth, iconHeight);
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawRectangle(textX, textY, textWidth, textHeight);
        }

        if (indicator[:drawIcon] != null) {
            (indicator[:drawIcon] as DrawIconMethod).invoke(
                dc,
                iconX + iconWidth / 2,
                iconY + iconHeight / 2,
                0.45,
                indicator[:drawIconOptions]
            );
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            textX,
            textY,
            Graphics.FONT_TINY,
            indicator[:text] as String,
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }

}
