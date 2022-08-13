import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

module Icons {

    function drawAlarmIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as Null
    ) as Void {
        dc.setPenWidth(5 * scale);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(x, y, 20 * scale);
        dc.drawLine(x, y - 10 * scale, x, y);
        dc.drawLine(x, y, x - 6 * scale, y + 8 * scale);
        dc.drawLine(x + 17 * scale, y - 23 * scale, x + 23 * scale, y - 17 * scale);
        dc.drawLine(x - 17 * scale, y - 23 * scale, x - 23 * scale, y - 17 * scale);
    }

    function drawBatteryIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as {
            :percentage as Number,
            :isCharging as Boolean,
        }
    ) as Void {
        var offset = 50 * (100 - options[:percentage] as Number) / 100;
        dc.setPenWidth(4 * scale);
        dc.setColor(
            options[:percentage] as Number > 15
                ? Graphics.COLOR_GREEN
                : Graphics.COLOR_RED,
            Graphics.COLOR_TRANSPARENT
        );
        dc.fillRoundedRectangle(
            x - 15 * scale,
            y - (20 - offset) * scale,
            30 * scale,
            (50 - offset) * scale,
            2
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x - 8 * scale, y - 26 * scale, 16 * scale, 6 * scale);
        dc.drawRoundedRectangle(
            x - 15 * scale,
            y - 20 * scale,
            30 * scale,
            50 * scale,
            2
        );
    }

    function drawBluetoothIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as {
            :state as ConnectionState,
        }
    ) as Void {
        var isConnected = options[:state] == System.CONNECTION_STATE_CONNECTED;
        dc.setPenWidth(4 * scale);
        dc.setColor(
            isConnected
                ? Graphics.COLOR_BLUE
                : Graphics.COLOR_WHITE,
            Graphics.COLOR_TRANSPARENT
        );
        dc.drawLine(x - 15 * scale, y - 15 * scale, x + 15 * scale, y + 15 * scale);
        dc.drawLine(x - 15 * scale, y + 15 * scale, x + 15 * scale, y - 15 * scale);
        dc.drawLine(x + 15 * scale, y + 15 * scale, x, y + 30 * scale);
        dc.drawLine(x + 15 * scale, y - 15 * scale, x, y - 30 * scale);
        dc.setPenWidth(5 * scale);
        dc.drawLine(x - 1 * scale, y - 30 * scale, x - 1 * scale, y + 30 * scale);
        if (!isConnected) {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(
                x - 30 * scale,
                y - 10 * scale,
                x + 30 * scale,
                y + 10 * scale
            );
        }
    }

    function drawHeartIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as Null
    ) as Void {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - 15 * scale, y - 10 * scale, 16 * scale);
        dc.fillCircle(x + 15 * scale, y - 10 * scale, 16 * scale);
        dc.fillPolygon([
            [x - 28 * scale, y - 3 * scale] as Array<Numeric>,
            // Off by one to adjust to rounding weirdness
            [x + 29 * scale, y - 3 * scale] as Array<Numeric>,
            [x + 1 * scale, y + 25 * scale] as Array<Numeric>,
            [x - 1 * scale, y + 25 * scale] as Array<Numeric>,
        ] as Array<ArrayOfNumeric>);
    }

    // Monkey C compiler doesn't understand Array<Array<T>> for some reason?
    typedef ArrayOfNumeric as Array<Numeric>;

    function drawNotificationIcon(
        dc as Dc, x as Number, y as Number, scale as Float, options as Null
    ) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(
            x - 25 * scale,
            y - 20 * scale,
            50 * scale,
            35 * scale,
            4
        );
        dc.fillPolygon([
            [x - 15 * scale, y + 15 * scale] as Array<Numeric>,
            [x - 15 * scale, y + 25 * scale] as Array<Numeric>,
            [x, y + 15 * scale] as Array<Numeric>,
        ] as Array<ArrayOfNumeric>);
    }

}
